
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.spwr_crossbar_switch_pkg.all;

entity spwr_crossbar_switch_ent is
    generic(
        g_RESET_DELAY         : natural  range 0 to 8  := 2;
        g_SPW_ROUTER_CHANNELS : positive range 1 to 32 := 4
    );
    port(
        --------------------------------------------------------------------------
        -- Clock/Reset
        --------------------------------------------------------------------------
        clock_i : in  std_logic;
        reset_i : in  std_logic;

        --------------------------------------------------------------------------
        -- Arbitration Interface
        -- data_arbiter_write_allowed_i, data_arbiter_write_request_o:
        --   Each is (N_in)x(N_out), where
        --     N_in  = g_SPW_ROUTER_CHANNELS           (input channels 0..N_in)
        --     N_out = g_SPW_ROUTER_CHANNELS + 1       (output channels 0..N_out, with
        --                                              the last index used as the
        --                                              overflow channel)
        --   Index 0 can still be used for the internal config channel, but any
        --   select value of 0 is now re‑routed to the overflow output channel.
        --------------------------------------------------------------------------
        data_arbiter_write_allowed_i : in  t_2d_slv(0 to g_SPW_ROUTER_CHANNELS,
                                                    0 to g_SPW_ROUTER_CHANNELS+1);
        data_arbiter_write_request_o : out t_2d_slv(0 to g_SPW_ROUTER_CHANNELS,
                                                    0 to g_SPW_ROUTER_CHANNELS+1);

        --------------------------------------------------------------------------
        -- Per-Channel Inputs
        --------------------------------------------------------------------------
        in_spw_txdata_write_i : in  t_1d_sl(0 to g_SPW_ROUTER_CHANNELS);
        in_spw_txdata_data_i  : in  t_1d_slv8(0 to g_SPW_ROUTER_CHANNELS);
        in_spw_txdata_flag_i  : in  t_1d_sl(0 to g_SPW_ROUTER_CHANNELS);
        in_spw_txdata_ready_o : out t_1d_sl(0 to g_SPW_ROUTER_CHANNELS);

        --------------------------------------------------------------------------
        -- Per-Channel Outputs
        -- An extra (overflow) output channel has been appended at index
        -- g_SPW_ROUTER_CHANNELS + 1.  There is *no* corresponding input channel.
        --------------------------------------------------------------------------
        out_spw_txdata_write_o : out t_1d_sl(0 to g_SPW_ROUTER_CHANNELS+1);
        out_spw_txdata_data_o  : out t_1d_slv8(0 to g_SPW_ROUTER_CHANNELS+1);
        out_spw_txdata_flag_o  : out t_1d_sl(0 to g_SPW_ROUTER_CHANNELS+1);
        out_spw_txdata_ready_i : in  t_1d_sl(0 to g_SPW_ROUTER_CHANNELS+1);

        --------------------------------------------------------------------------
        -- Crossbar Selects
        -- crossbar_switch_select_i(n) = 6-bit index => output channel "m"
        --   "111111" means "no connection"
        --   All select values of 0 or > g_SPW_ROUTER_CHANNELS+1 are re‑routed to
        --   the overflow output channel (index g_SPW_ROUTER_CHANNELS+1).
        --------------------------------------------------------------------------
        crossbar_switch_select_i : in t_1d_slv6(0 to g_SPW_ROUTER_CHANNELS)
    );
end spwr_crossbar_switch_ent;

--------------------------------------------------------------------------------

architecture RTL of spwr_crossbar_switch_ent is

    ----------------------------------------------------------------------------
    -- 1) Type Definitions
    ----------------------------------------------------------------------------
    type t_crossbar_fsm is (RESET_HOLD, NORMAL);

    ----------------------------------------------------------------------------
    -- 2) Constants
    ----------------------------------------------------------------------------
    constant C_IN_CHANNEL_MAX  : natural := g_SPW_ROUTER_CHANNELS;      -- last input index
    constant C_OUT_CHANNEL_MAX : natural := g_SPW_ROUTER_CHANNELS + 1;  -- last output index (includes overflow)
    constant C_OVERFLOW_CH     : natural := C_OUT_CHANNEL_MAX;          -- convenience alias

    ----------------------------------------------------------------------------
    -- 3) Internal Signals
    ----------------------------------------------------------------------------
    signal s_crossbar_state : t_crossbar_fsm := RESET_HOLD;

    -- We hold in reset for g_RESET_DELAY cycles
    signal s_reset_counter  : natural range 0 to 255 := 0;

    -- Registered outputs to avoid latches
    signal r_data_arb_req  : t_2d_slv(0 to C_IN_CHANNEL_MAX, 0 to C_OUT_CHANNEL_MAX) := (others => (others => '0'));
    signal r_in_ready      : t_1d_sl(0 to C_IN_CHANNEL_MAX) := (others => '0');
    signal r_out_write     : t_1d_sl(0 to C_OUT_CHANNEL_MAX) := (others => '0');
    signal r_out_data      : t_1d_slv8(0 to C_OUT_CHANNEL_MAX) := (others => (others => '0'));
    signal r_out_flag      : t_1d_sl(0 to C_OUT_CHANNEL_MAX) := (others => '0');

begin

    ----------------------------------------------------------------------------
    -- 4) Single-Process: FSM with synchronous reset + combinational routing
    ----------------------------------------------------------------------------
    p_crossbar_switch : process(clock_i)
        -- Variables mirror the signals above to allow combinational style inside the clocked process
        variable v_state         : t_crossbar_fsm;
        variable v_next_state    : t_crossbar_fsm;
        variable v_reset_counter : natural range 0 to 255;

        -- Locals for arbitration requests
        variable v_req        : t_2d_slv(0 to C_IN_CHANNEL_MAX, 0 to C_OUT_CHANNEL_MAX);
        -- Locals for TX input readiness and output signals
        variable v_in_ready   : t_1d_sl(0 to C_IN_CHANNEL_MAX);
        variable v_out_write  : t_1d_sl(0 to C_OUT_CHANNEL_MAX);
        variable v_out_data   : t_1d_slv8(0 to C_OUT_CHANNEL_MAX);
        variable v_out_flag   : t_1d_sl(0 to C_OUT_CHANNEL_MAX);

        -- For convenience in decoding crossbar_select
        variable v_selected_output : natural range 0 to 62; -- 6-bit select value
    begin
        if rising_edge(clock_i) then

            --------------------------------------------------------------------
            -- 1) Capture current signals
            --------------------------------------------------------------------
            v_state         := s_crossbar_state;
            v_reset_counter := s_reset_counter;
            v_req           := r_data_arb_req;
            v_in_ready      := r_in_ready;
            v_out_write     := r_out_write;
            v_out_data      := r_out_data;
            v_out_flag      := r_out_flag;

            --------------------------------------------------------------------
            -- 2) Check synchronous reset
            --------------------------------------------------------------------
            if (reset_i = '1') then
                -- Enter RESET_HOLD state for g_RESET_DELAY cycles
                v_state         := RESET_HOLD;
                v_reset_counter := g_RESET_DELAY;

                -- Clear all registered vectors
                for i in 0 to C_IN_CHANNEL_MAX loop
                    v_in_ready(i) := '0';
                    for m in 0 to C_OUT_CHANNEL_MAX loop
                        v_req(i,m) := '0';
                    end loop;
                end loop;

                for m in 0 to C_OUT_CHANNEL_MAX loop
                    v_out_write(m) := '0';
                    v_out_data(m)  := (others => '0');
                    v_out_flag(m)  := '0';
                end loop;

            else
                ----------------------------------------------------------------
                -- 3) Default assignments each clock (avoid latches)
                ----------------------------------------------------------------
                v_next_state := v_state;

                for i in 0 to C_IN_CHANNEL_MAX loop
                    v_in_ready(i) := '0';
                    for m in 0 to C_OUT_CHANNEL_MAX loop
                        v_req(i,m) := '0';
                    end loop;
                end loop;

                for m in 0 to C_OUT_CHANNEL_MAX loop
                    v_out_write(m) := '0';
                    v_out_data(m)  := (others => '0');
                    v_out_flag(m)  := '0';
                end loop;

                ----------------------------------------------------------------
                -- 4) FSM Transitions
                ----------------------------------------------------------------
                case v_state is

                    ------------------------------------------------------------
                    -- RESET_HOLD: Wait g_RESET_DELAY cycles
                    ------------------------------------------------------------
                    when RESET_HOLD =>
                        if v_reset_counter > 0 then
                            v_reset_counter := v_reset_counter - 1;
                        else
                            v_next_state := NORMAL;
                        end if;

                    ------------------------------------------------------------
                    -- NORMAL: Perform combinational routing
                    ------------------------------------------------------------
                    when NORMAL =>
                        ----------------------------------------------------------------
                        -- Per-input routing evaluation
                        ----------------------------------------------------------------
                        for i in 0 to C_IN_CHANNEL_MAX loop
                            if crossbar_switch_select_i(i) = "111111" then
                                -- "111111" => no connection
                                null;  -- remain disconnected
                            else
                                -- Convert 6-bit select into integer
                                v_selected_output := to_integer(unsigned(crossbar_switch_select_i(i)));

                                -- Check if the data is for the overflow channel
                                if (v_selected_output = 0) or (v_selected_output > C_IN_CHANNEL_MAX) then
                                    v_selected_output := C_OVERFLOW_CH;
                                end if;

                                -- 1) We request arbitration for (i -> selected_output) if we are writing
                                --if in_spw_txdata_write_i(i) = '1' then
                                    v_req(i, v_selected_output) := '1';
                                --end if;

                                -- 2) Check if arbiter allows (i -> selected_output)
                                if data_arbiter_write_allowed_i(i, v_selected_output) = '1' then
                                    v_out_write(v_selected_output) := in_spw_txdata_write_i(i);
                                    v_out_data(v_selected_output)  := in_spw_txdata_data_i(i);
                                    v_out_flag(v_selected_output)  := in_spw_txdata_flag_i(i);
                                    -- The active output channel's ready is fed back to input channel i
                                    v_in_ready(i)  := out_spw_txdata_ready_i(v_selected_output);
                                end if;

                            end if;
                        end loop;

                    when others =>
                        v_next_state := RESET_HOLD;
                end case; -- v_state

                -- Commit next state
                v_state := v_next_state;
            end if; -- not in reset

            --------------------------------------------------------------------
            -- (5) Write variables back to signals
            --------------------------------------------------------------------
            s_crossbar_state <= v_state;
            s_reset_counter  <= v_reset_counter;

            for i in 0 to C_IN_CHANNEL_MAX loop
                r_in_ready(i) <= v_in_ready(i);
                for m in 0 to C_OUT_CHANNEL_MAX loop
                    r_data_arb_req(i,m) <= v_req(i,m);
                end loop;
            end loop;

            for m in 0 to C_OUT_CHANNEL_MAX loop
                r_out_write(m) <= v_out_write(m);
                r_out_data(m)  <= v_out_data(m);
                r_out_flag(m)  <= v_out_flag(m);
            end loop;

        end if; -- rising edge
    end process p_crossbar_switch;

    ----------------------------------------------------------------------------
    -- 5) Concurrent assignments to entity outputs
    ----------------------------------------------------------------------------
    data_arbiter_write_request_o <= r_data_arb_req;

    in_spw_txdata_ready_o  <= r_in_ready;
    out_spw_txdata_write_o <= r_out_write;
    out_spw_txdata_data_o  <= r_out_data;
    out_spw_txdata_flag_o  <= r_out_flag;

end architecture RTL;
