library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity spwr_data_arbiter_ent is
    generic(
        g_RESET_DELAY         : natural  range 0 to 8  := 0;
        g_SPW_ROUTER_CHANNELS : positive range 1 to 32 := 8
    );
    port(
        ------------------------------------------------------------------------------
        -- Clock/Reset
        ------------------------------------------------------------------------------
        clock_i  : in  std_logic;
        reset_i  : in  std_logic;

        ------------------------------------------------------------------------------
        -- Arbitration Requests and Grants
        ------------------------------------------------------------------------------
        -- Note: Vector indices are (0 to g_SPW_ROUTER_CHANNELS) to include
        --       the internal configuration channel (index 0).
        data_arbiter_write_request_i : in  std_logic_vector(0 to g_SPW_ROUTER_CHANNELS);
        data_arbiter_write_allowed_o : out std_logic_vector(0 to g_SPW_ROUTER_CHANNELS);

        ------------------------------------------------------------------------------
        -- Selected Input Channel Data/Control
        ------------------------------------------------------------------------------
        in_spw_txdata_write_i : in  std_logic;
        in_spw_txdata_data_i  : in  std_logic_vector(7 downto 0);
        in_spw_txdata_flag_i  : in  std_logic;
        in_spw_txdata_ready_o : out std_logic;  -- Arbiter telling the active channel "ready"

        ------------------------------------------------------------------------------
        -- Shared SpaceWire TX Channel
        ------------------------------------------------------------------------------
        out_spw_txdata_write_o : out std_logic;
        out_spw_txdata_data_o  : out std_logic_vector(7 downto 0);
        out_spw_txdata_flag_o  : out std_logic;
        out_spw_txdata_ready_i : in  std_logic
    );
end spwr_data_arbiter_ent;

------------------------------------------------------------------------------

architecture RTL of spwr_data_arbiter_ent is

    --------------------------------------------------------------------------
    -- 1) Helper functions (compile-time only)
    --------------------------------------------------------------------------
    -- next power-of-two ≥ n
    function next_pow2 (n : natural) return natural is
        variable p : natural := 1;
    begin
        while p < n loop
            p := p * 2;
        end loop;
        return p;
    end function;

    -- <log2 n> – width of an unsigned that can hold n-1
    function clog2 (n : natural) return natural is
        variable v : natural := n - 1;
        variable r : natural := 0;
    begin
        while v > 0 loop
            v := v / 2;
            r := r + 1;
        end loop;
        return r;
    end function;

    --------------------------------------------------------------------------
    -- 2) Constants
    --------------------------------------------------------------------------
    constant C_FIFO_SIZE  : natural := next_pow2(g_SPW_ROUTER_CHANNELS + 2);
    constant C_PTR_WIDTH  : natural := clog2(C_FIFO_SIZE);
    --------------------------------------------------------------------------
    -- 3) Type / subtype declarations
    --------------------------------------------------------------------------
    subtype t_ptr is unsigned(C_PTR_WIDTH-1 downto 0);

    type t_arbiter_fsm is (
        RESET_STATE,     -- Holds the FSM in reset until g_RESET_DELAY is complete
        IDLE,            -- No active channel; waiting for a request
        ACTIVE,          -- Actively granting one channel
        WAIT_2CLK_1,     -- First clock of 2-clock-cycle wait after channel done
        WAIT_2CLK_2      -- Second clock of 2-clock-cycle wait
    );


    --------------------------------------------------------------------------
    -- 4) Signals
    --------------------------------------------------------------------------
    signal s_write_ptr    : t_ptr := (others => '0');
    signal s_read_ptr     : t_ptr := (others => '0');

    signal s_arbiter_state  : t_arbiter_fsm := RESET_STATE;

    -- Reset Delay Counter
    signal s_reset_counter  : natural range 0 to 255 := 0;

    -- Active channel index (0..g_SPW_ROUTER_CHANNELS)
    signal s_active_channel : natural range 0 to g_SPW_ROUTER_CHANNELS := 0;

    -- Round-robin pointer (last channel that received a grant)
    signal s_rr_ptr         : natural range 0 to g_SPW_ROUTER_CHANNELS := 0;

    -- Write Allowed outputs (one-hot: only the active channel is '1')
    signal r_write_allowed  : std_logic_vector(0 to g_SPW_ROUTER_CHANNELS) := (others => '0');

    -- Registered outputs to the shared SpaceWire TX
    signal r_out_txdata_write : std_logic                    := '0';
    signal r_out_txdata_data  : std_logic_vector(7 downto 0) := (others => '0');
    signal r_out_txdata_flag  : std_logic                    := '0';

    -- Registered "ready" for the input channel
    signal r_in_spw_txdata_ready : std_logic := '0';

    --------------------------------------------------------------------------
    -- 5) Pure helpers
    --------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- ➤ BEGIN of architecture statements  ---------------------------------------
-------------------------------------------------------------------------------
begin

    ------------------------------------------------------------------------------
    -- Single-Process FSM
    ------------------------------------------------------------------------------
    p_data_arbiter : process(clock_i)
        variable v_arbiter_state  : t_arbiter_fsm;
        variable v_next_state     : t_arbiter_fsm;
        variable v_write_ptr     : t_ptr;
        variable v_read_ptr      : t_ptr;
        variable v_channel_id     : natural range 0 to g_SPW_ROUTER_CHANNELS;
        variable v_write_allowed  : std_logic_vector(0 to g_SPW_ROUTER_CHANNELS);
        variable v_active_channel : natural range 0 to g_SPW_ROUTER_CHANNELS;
        variable v_reset_counter  : natural range 0 to 255;
        variable v_in_spw_ready   : std_logic;
        variable v_out_write      : std_logic;
        variable v_out_data       : std_logic_vector(7 downto 0);
        variable v_out_flag       : std_logic;
        variable v_rr_ptr         : natural range 0 to g_SPW_ROUTER_CHANNELS;
        variable v_found_request  : boolean;
        variable v_search_idx     : natural range 0 to g_SPW_ROUTER_CHANNELS;
    begin
        if rising_edge(clock_i) then

            ------------------------------------------------------------------------------
            -- 1. Copy current signals into local variables
            ------------------------------------------------------------------------------
            v_arbiter_state  := s_arbiter_state;
            v_write_ptr      := s_write_ptr;
            v_read_ptr       := s_read_ptr;
            v_reset_counter  := s_reset_counter;
            v_active_channel := s_active_channel;
            v_rr_ptr         := s_rr_ptr;

            v_write_allowed  := r_write_allowed;
            v_in_spw_ready   := r_in_spw_txdata_ready;
            v_out_write      := r_out_txdata_write;
            v_out_data       := r_out_txdata_data;
            v_out_flag       := r_out_txdata_flag;

            ------------------------------------------------------------------------------
            -- 2. Synchronous Reset Handling
            ------------------------------------------------------------------------------
            if (reset_i = '1') then
                -- Reset everything immediately, then wait g_RESET_DELAY cycles in RESET_STATE
                v_arbiter_state   := RESET_STATE;
                v_reset_counter := g_RESET_DELAY;
                v_write_ptr     := (others => '0');
                v_read_ptr      := (others => '0');

                v_active_channel  := 0;
                v_rr_ptr          := 0;
                v_write_allowed   := (others => '0');
                v_in_spw_ready    := '0';
                v_out_write       := '0';
                v_out_data        := (others => '0');
                v_out_flag        := '0';

            else
                ------------------------------------------------------------------------------
                -- 3. Default Assignments (avoid latches)
                ------------------------------------------------------------------------------
                v_next_state := v_arbiter_state;

                -- Default each clock cycle: no writes to Tx, no channel ready, etc.
                v_write_allowed := (others => '0');
                v_in_spw_ready  := '0';
                v_out_write     := '0';
                v_out_data      := (others => '0');
                v_out_flag      := '0';

                ------------------------------------------------------------------------------
                -- 4. Round-robin Request Scan (replaces FIFO enqueue logic)
                ------------------------------------------------------------------------------
                -- No action needed here; scanning happens below in IDLE

                ------------------------------------------------------------------------------
                -- 5. FSM State Transitions
                ------------------------------------------------------------------------------
                case v_arbiter_state is

                    --------------------------------------------------------------------------
                    -- RESET_STATE: Wait g_RESET_DELAY cycles before enabling the arbiter
                    --------------------------------------------------------------------------
                    when RESET_STATE =>
                        if v_reset_counter /= 0 then
                            v_reset_counter := v_reset_counter - 1;
                        else
                            -- Done with reset delay => go to IDLE
                            v_next_state := IDLE;
                        end if;

                    --------------------------------------------------------------------------
                    -- IDLE: Find next requester in round-robin order
                    --------------------------------------------------------------------------
                    when IDLE =>
                        v_found_request := false;
                        -- start search just after the last granted channel
                        v_search_idx := (v_rr_ptr + 1) mod (g_SPW_ROUTER_CHANNELS + 1);
                        for n in 0 to g_SPW_ROUTER_CHANNELS loop
                            if data_arbiter_write_request_i(v_search_idx) = '1' then
                                v_active_channel := v_search_idx;
                                v_found_request  := true;
                                exit;  -- stop at first '1'
                            end if;
                            v_search_idx := (v_search_idx + 1) mod (g_SPW_ROUTER_CHANNELS + 1);
                        end loop;

                        if v_found_request then
                            v_next_state := ACTIVE;
                        else
                            v_active_channel := 0;
                        end if;

                    --------------------------------------------------------------------------
                    -- ACTIVE: Grant the active channel. Wait for it to deassert request
                    --------------------------------------------------------------------------
                    when ACTIVE =>
                        -- Allow only this channel
                        v_write_allowed(v_active_channel) := '1';
                        -- Directly route input signals to output signals
                        v_in_spw_ready := out_spw_txdata_ready_i;  -- "ready" from the Tx
                        v_out_write    := in_spw_txdata_write_i;   
                        v_out_data     := in_spw_txdata_data_i;    
                        v_out_flag     := in_spw_txdata_flag_i;

                        -- When the channel's request is dropped => done
                        if data_arbiter_write_request_i(v_active_channel) = '0' then
                            -- Remember which channel just finished (round-robin pointer)
                            v_rr_ptr     := v_active_channel;
                            v_next_state := WAIT_2CLK_1;  -- Begin 2-cycle delay
                        end if;

                    --------------------------------------------------------------------------
                    -- WAIT_2CLK_1: First of two idle cycles between channel transitions
                    --------------------------------------------------------------------------
                    when WAIT_2CLK_1 =>
                        -- Outputs remain zero; channel is no longer active
                        v_next_state := WAIT_2CLK_2;

                    --------------------------------------------------------------------------
                    -- WAIT_2CLK_2: Second of two idle cycles
                    --------------------------------------------------------------------------
                    when WAIT_2CLK_2 =>
                        v_next_state := IDLE;

                    when others =>
                        -- Safety fallback to IDLE
                        v_next_state := IDLE;

                end case;

                ------------------------------------------------------------------------------
                -- 6. Update State
                ------------------------------------------------------------------------------
                v_arbiter_state  := v_next_state;

            end if;

            ------------------------------------------------------------------------------
            -- 7. Write Local Variables Back to Signals
            ------------------------------------------------------------------------------
            s_arbiter_state   <= v_arbiter_state;
            s_write_ptr       <= v_write_ptr;
            s_read_ptr        <= v_read_ptr;
            s_reset_counter  <= v_reset_counter;
            s_active_channel  <= v_active_channel;
            s_rr_ptr          <= v_rr_ptr;

            r_write_allowed   <= v_write_allowed;
            r_in_spw_txdata_ready <= v_in_spw_ready;
            r_out_txdata_write    <= v_out_write;
            r_out_txdata_data     <= v_out_data;
            r_out_txdata_flag     <= v_out_flag;

        end if;  -- rising_edge(clock_i)
    end process p_data_arbiter;

    ------------------------------------------------------------------------------
    -- 5) Final Output Assignments
    ------------------------------------------------------------------------------
    data_arbiter_write_allowed_o <= r_write_allowed;

    out_spw_txdata_write_o <= r_out_txdata_write;
    out_spw_txdata_data_o  <= r_out_txdata_data;
    out_spw_txdata_flag_o  <= r_out_txdata_flag;

    in_spw_txdata_ready_o  <= r_in_spw_txdata_ready;

end architecture RTL;
