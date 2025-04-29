library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.spwm_crossbar_switch_pkg.all;

entity spwm_crossbar_switch_ent is
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
        --   Each is NxN, where N = g_SPW_ROUTER_CHANNELS + 1, typically.
        --   Index 0 might be for the internal config channel, etc.
        --------------------------------------------------------------------------
        data_arbiter_write_allowed_i : in  t_2d_slv(0 to g_SPW_ROUTER_CHANNELS, 0 to g_SPW_ROUTER_CHANNELS);
        data_arbiter_write_request_o : out t_2d_slv(0 to g_SPW_ROUTER_CHANNELS, 0 to g_SPW_ROUTER_CHANNELS);

        --------------------------------------------------------------------------
        -- Per-Channel Inputs
        --------------------------------------------------------------------------
        in_spw_txdata_write_i : in  t_1d_sl(0 to g_SPW_ROUTER_CHANNELS);
        in_spw_txdata_data_i  : in  t_1d_slv8(0 to g_SPW_ROUTER_CHANNELS);
        in_spw_txdata_flag_i  : in  t_1d_sl(0 to g_SPW_ROUTER_CHANNELS);
        in_spw_txdata_ready_o : out t_1d_sl(0 to g_SPW_ROUTER_CHANNELS);

        --------------------------------------------------------------------------
        -- Per-Channel Outputs
        --------------------------------------------------------------------------
        out_spw_txdata_write_o : out t_1d_sl(0 to g_SPW_ROUTER_CHANNELS);
        out_spw_txdata_data_o  : out t_1d_slv8(0 to g_SPW_ROUTER_CHANNELS);
        out_spw_txdata_flag_o  : out t_1d_sl(0 to g_SPW_ROUTER_CHANNELS);
        out_spw_txdata_ready_i : in  t_1d_sl(0 to g_SPW_ROUTER_CHANNELS);

        --------------------------------------------------------------------------
        -- Crossbar Selects
        -- crossbar_switch_select_i(n) = 6-bit index => output channel "m"
        --   "111111" means "no connection"
        --------------------------------------------------------------------------
        crossbar_switch_select_i : in t_1d_slv6(0 to g_SPW_ROUTER_CHANNELS)
    );
end spwm_crossbar_switch_ent;

--------------------------------------------------------------------------------

architecture RTL of spwm_crossbar_switch_ent is

    ----------------------------------------------------------------------------
    -- 1) Type Definitions
    ----------------------------------------------------------------------------
    type t_crossbar_fsm is (RESET_HOLD, NORMAL);

    ----------------------------------------------------------------------------
    -- 2) Constants
    ----------------------------------------------------------------------------
    constant C_CHANNEL_MAX : natural := g_SPW_ROUTER_CHANNELS;

    ----------------------------------------------------------------------------
    -- 3) Internal Signals
    ----------------------------------------------------------------------------
    signal s_crossbar_state : t_crossbar_fsm := RESET_HOLD;

    -- We hold in reset for g_RESET_DELAY cycles
    signal s_reset_counter  : natural range 0 to 255 := 0;

    -- Registered outputs to avoid latches
    signal r_data_arb_req  : t_2d_slv(0 to C_CHANNEL_MAX, 0 to C_CHANNEL_MAX) := (others => (others => '0'));
    signal r_in_ready      : t_1d_sl(0 to C_CHANNEL_MAX)                      := (others => '0');
    signal r_out_write     : t_1d_sl(0 to C_CHANNEL_MAX)                      := (others => '0');
    signal r_out_data      : t_1d_slv8(0 to C_CHANNEL_MAX)                    := (others => (others => '0'));
    signal r_out_flag      : t_1d_sl(0 to C_CHANNEL_MAX)                      := (others => '0');

begin

    ----------------------------------------------------------------------------
    -- Single-Process: FSM with synchronous reset + combinational routing
    ----------------------------------------------------------------------------
    p_crossbar_switch : process(clock_i)
        variable v_state : t_crossbar_fsm;
        variable v_next_state : t_crossbar_fsm;
        variable v_reset_counter : natural range 0 to 255;
        
        -- Locals for NxN arbitration requests
        variable v_req  : t_2d_slv(0 to C_CHANNEL_MAX, 0 to C_CHANNEL_MAX);
        -- Locals for TX input readiness and output signals
        variable v_in_ready : t_1d_sl(0 to C_CHANNEL_MAX);
        variable v_out_write : t_1d_sl(0 to C_CHANNEL_MAX);
        variable v_out_data  : t_1d_slv8(0 to C_CHANNEL_MAX);
        variable v_out_flag  : t_1d_sl(0 to C_CHANNEL_MAX);

        -- For convenience in decoding crossbar_select
        variable v_selected_output : integer;
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

                -- Clear everything
                for i in 0 to C_CHANNEL_MAX loop
                    v_in_ready(i)   := '0';
                    v_out_write(i)  := '0';
                    v_out_data(i)   := (others => '0');
                    v_out_flag(i)   := '0';
                    for m in 0 to C_CHANNEL_MAX loop
                        v_req(i,m) := '0';
                    end loop;
                end loop;

            else
                ----------------------------------------------------------------
                -- 3) Default assignments each clock (avoid latches)
                ----------------------------------------------------------------
                v_next_state := v_state;

                for i in 0 to C_CHANNEL_MAX loop
                    v_in_ready(i)  := '0';
                    v_out_write(i) := '0';
                    v_out_data(i)  := (others => '0');
                    v_out_flag(i)  := '0';
                    for m in 0 to C_CHANNEL_MAX loop
                        v_req(i,m) := '0';
                    end loop;
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
                        -- For each input channel i, decode crossbar_select
                        for i in 0 to C_CHANNEL_MAX loop
                            if crossbar_switch_select_i(i) = "111111" then
                                -- "111111" => no connection
                                null;  -- remain disconnected
                            else
                                -- Convert 6-bit select into integer
                                v_selected_output := to_integer(unsigned(crossbar_switch_select_i(i)));

                                -- Range check to avoid out-of-bounds:
                                if (v_selected_output >= 0) and (v_selected_output <= C_CHANNEL_MAX) then
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

                                else
                                    -- If out-of-range, treat as no connection
                                    null;
                                end if;
                            end if;
                        end loop;

                    when others =>
                        -- Safety fallback
                        v_next_state := RESET_HOLD;
                end case;

                ----------------------------------------------------------------
                -- 5) Update State
                ----------------------------------------------------------------
                v_state := v_next_state;

            end if;

            --------------------------------------------------------------------
            -- 6) Write local variables back to signals
            --------------------------------------------------------------------
            s_crossbar_state <= v_state;
            s_reset_counter  <= v_reset_counter;

            for i in 0 to C_CHANNEL_MAX loop
                r_in_ready(i)   <= v_in_ready(i);
                r_out_write(i)  <= v_out_write(i);
                r_out_data(i)   <= v_out_data(i);
                r_out_flag(i)   <= v_out_flag(i);
                for m in 0 to C_CHANNEL_MAX loop
                    r_data_arb_req(i,m) <= v_req(i,m);
                end loop;
            end loop;

        end if;  -- rising_edge(clock_i)
    end process p_crossbar_switch;

    ----------------------------------------------------------------------------
    -- 7) Assign Registered Signals to Entity Outputs
    ----------------------------------------------------------------------------
    data_arbiter_write_request_o <= r_data_arb_req;

    in_spw_txdata_ready_o  <= r_in_ready;
    out_spw_txdata_write_o <= r_out_write;
    out_spw_txdata_data_o  <= r_out_data;
    out_spw_txdata_flag_o  <= r_out_flag;

end architecture RTL;
