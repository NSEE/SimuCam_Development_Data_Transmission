library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity spwm_data_arbiter_ent is
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
end spwm_data_arbiter_ent;

------------------------------------------------------------------------------

architecture RTL of spwm_data_arbiter_ent is

    ------------------------------------------------------------------------------
    -- 1) Type Declarations
    ------------------------------------------------------------------------------
    type t_arbiter_fsm is (
        RESET_STATE,     -- Holds the FSM in reset until g_RESET_DELAY is complete
        IDLE,            -- No active channel; waiting for FIFO to have a channel
        ACTIVE,          -- Actively granting one channel
        WAIT_2CLK_1,     -- First clock of 2-clock-cycle wait after channel done
        WAIT_2CLK_2      -- Second clock of 2-clock-cycle wait
    );

    ------------------------------------------------------------------------------
    -- 2) Constants
    ------------------------------------------------------------------------------
    constant C_FIFO_SIZE : natural := g_SPW_ROUTER_CHANNELS + 2; 
    --  +2 to ensure no overflow under simultaneous requests.

    ------------------------------------------------------------------------------
    -- 3) Internal Signals
    ------------------------------------------------------------------------------
    -- FIFO storage for channel IDs (range: 0..g_SPW_ROUTER_CHANNELS)
    type t_fifo_array is array (0 to C_FIFO_SIZE-1) of natural range 0 to g_SPW_ROUTER_CHANNELS;
    signal s_fifo           : t_fifo_array := (others => 0);
    signal s_write_ptr      : natural range 0 to C_FIFO_SIZE-1 := 0;
    signal s_read_ptr       : natural range 0 to C_FIFO_SIZE-1 := 0;
    signal s_fifo_count     : natural range 0 to C_FIFO_SIZE   := 0;  -- tracks how many channels in FIFO

    signal s_arbiter_state  : t_arbiter_fsm := RESET_STATE;

    -- Reset Delay Counter
    signal s_reset_counter  : natural range 0 to 255 := 0;

    -- Active channel index (0..g_SPW_ROUTER_CHANNELS)
    signal s_active_channel : natural range 0 to g_SPW_ROUTER_CHANNELS := 0;

    -- Write Allowed outputs (one-hot: only the active channel is '1')
    signal r_write_allowed  : std_logic_vector(0 to g_SPW_ROUTER_CHANNELS) := (others => '0');

    -- Registered outputs to the shared SpaceWire TX
    signal r_out_txdata_write : std_logic                    := '0';
    signal r_out_txdata_data  : std_logic_vector(7 downto 0) := (others => '0');
    signal r_out_txdata_flag  : std_logic                    := '0';

    -- Registered "ready" for the input channel
    signal r_in_spw_txdata_ready : std_logic := '0';

    ------------------------------------------------------------------------------
    -- 4) Functions/Procedures (Optional Helpers)
    ------------------------------------------------------------------------------
    -- Enqueue a channel ID into the FIFO if there's space and if not already queued.
    function enqueue_channel(
        v_channel_id : natural;
        v_fifo       : t_fifo_array;
        v_write_ptr  : natural;
        v_fifo_count : natural
    ) return t_fifo_array is
        variable new_fifo : t_fifo_array := v_fifo;
    begin
        if v_fifo_count < C_FIFO_SIZE then
            new_fifo(v_write_ptr) := v_channel_id;
        end if;
        return new_fifo;
    end function;

    -- Check if a channel is already in the FIFO
    function is_in_fifo(
        constant c_channel_id : in natural;
        constant c_fifo       : t_fifo_array;
        constant c_read_ptr   : natural;
        constant c_write_ptr  : natural;
        constant c_fifo_count : natural
    ) return boolean is
        variable v_idx : natural := c_read_ptr;
        variable v_cnt : natural := c_fifo_count;
    begin
		for i in 0 to C_FIFO_SIZE loop
			if v_cnt > 0 then
				if c_fifo(v_idx) = c_channel_id then
					return true;
				end if;
				v_idx := (v_idx + 1) mod C_FIFO_SIZE;
				v_cnt := v_cnt - 1;
			end if;
        end loop;
        return false;
    end function is_in_fifo;

begin

    ------------------------------------------------------------------------------
    -- Single-Process FSM
    ------------------------------------------------------------------------------
    p_data_arbiter : process(clock_i)
        variable v_arbiter_state  : t_arbiter_fsm;
        variable v_next_state     : t_arbiter_fsm;
        variable v_fifo           : t_fifo_array;
        variable v_write_ptr      : natural range 0 to C_FIFO_SIZE-1;
        variable v_read_ptr       : natural range 0 to C_FIFO_SIZE-1;
        variable v_fifo_count     : natural range 0 to C_FIFO_SIZE;
        variable v_channel_id     : natural range 0 to g_SPW_ROUTER_CHANNELS;
        variable v_write_allowed  : std_logic_vector(0 to g_SPW_ROUTER_CHANNELS);
        variable v_active_channel : natural range 0 to g_SPW_ROUTER_CHANNELS;
        variable v_reset_counter  : natural range 0 to 255;
        variable v_in_spw_ready   : std_logic;
        variable v_out_write      : std_logic;
        variable v_out_data       : std_logic_vector(7 downto 0);
        variable v_out_flag       : std_logic;
    begin
        if rising_edge(clock_i) then

            ------------------------------------------------------------------------------
            -- 1. Copy current signals into local variables
            ------------------------------------------------------------------------------
            v_arbiter_state  := s_arbiter_state;
            v_fifo           := s_fifo;
            v_write_ptr      := s_write_ptr;
            v_read_ptr       := s_read_ptr;
            v_fifo_count     := s_fifo_count;
            v_reset_counter  := s_reset_counter;
            v_active_channel := s_active_channel;

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
                v_reset_counter   := g_RESET_DELAY;
                v_fifo_count      := 0;
                v_write_ptr       := 0;
                v_read_ptr        := 0;
                for i in 0 to C_FIFO_SIZE-1 loop
                    v_fifo(i) := 0;
                end loop;

                v_active_channel  := 0;
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
                -- 4. Enqueue New Requests (if not already in FIFO)
                ------------------------------------------------------------------------------
                for i in 0 to g_SPW_ROUTER_CHANNELS loop
                    if data_arbiter_write_request_i(i) = '1' then
                        if (i /= v_active_channel) then
                            if not is_in_fifo(i, v_fifo, v_read_ptr, v_write_ptr, v_fifo_count) then
                                if v_fifo_count < C_FIFO_SIZE then
                                    v_fifo := enqueue_channel(i, v_fifo, v_write_ptr, v_fifo_count);
                                    v_write_ptr := (v_write_ptr + 1) mod C_FIFO_SIZE;
                                    v_fifo_count := v_fifo_count + 1;
                                end if;
                            end if;
                        end if;
                    end if;
                end loop;

                ------------------------------------------------------------------------------
                -- 5. FSM State Transitions
                ------------------------------------------------------------------------------
                case v_arbiter_state is

                    --------------------------------------------------------------------------
                    -- RESET_STATE: Wait g_RESET_DELAY cycles before enabling the arbiter
                    --------------------------------------------------------------------------
                    when RESET_STATE =>
                        if v_reset_counter > 0 then
                            v_reset_counter := v_reset_counter - 1;
                        else
                            -- Done with reset delay => go to IDLE
                            v_next_state := IDLE;
                        end if;

                    --------------------------------------------------------------------------
                    -- IDLE: If FIFO not empty, choose the front channel as active
                    --------------------------------------------------------------------------
                    when IDLE =>
                        if v_fifo_count > 0 then
                            v_active_channel := v_fifo(v_read_ptr);
                            v_next_state     := ACTIVE;
                        else
                            v_active_channel  := 0;
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
                            -- Remove it from FIFO (it has completed its packet)
                            v_read_ptr    := (v_read_ptr + 1) mod C_FIFO_SIZE;
                            v_fifo_count  := v_fifo_count - 1;
                            v_next_state  := WAIT_2CLK_1;  -- Begin 2-cycle delay
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
            s_fifo            <= v_fifo;
            s_write_ptr       <= v_write_ptr;
            s_read_ptr        <= v_read_ptr;
            s_fifo_count      <= v_fifo_count;
            s_reset_counter   <= v_reset_counter;
            s_active_channel  <= v_active_channel;

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
