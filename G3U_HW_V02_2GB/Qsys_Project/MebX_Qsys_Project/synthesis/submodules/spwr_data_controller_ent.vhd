
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.spwr_data_controller_pkg.all;       -- For routing_table_t, if still needed

entity spwr_data_controller_ent is
    generic (
        -- Timeout expressed in clock cycles (1 ms @ 100 MHz → 100_000).
        TIMEOUT_CYCLES_G : positive := 100_000
    );
    port(
        -- Clock/Reset
        clk_i                      : in  std_logic;
        rst_i                      : in  std_logic;
        -- Routing Table
        spw_router_routing_table_i : in  routing_table_t              := c_rst_routing_table;
        -- Flow Control
        spw_txdata_ready_i         : in  std_logic                    := '0';
        -- RX from SpaceWire
        spw_rxdata_data_i          : in  std_logic_vector(7 downto 0) := x"00";
        spw_rxdata_flag_i          : in  std_logic                    := '0';
        spw_rxdata_ready_i         : in  std_logic                    := '0';
        -- Outputs
        crossbar_switch_select_o   : out std_logic_vector(5 downto 0);
        spw_txdata_data_o          : out std_logic_vector(7 downto 0);
        spw_txdata_flag_o          : out std_logic;
        spw_txdata_write_o         : out std_logic;
        spw_rxdata_read_o          : out std_logic
    );
end spwr_data_controller_ent;

architecture RTL of spwr_data_controller_ent is

    ------------------------------------------------------------------------------
    -- 1) Type Declarations
    ------------------------------------------------------------------------------
    type t_data_controller_fsm is (IDLE, DELAY, PROCESSING, WAITING, TRANSMITTING, TIMEOUT, FINISHED);

    ------------------------------------------------------------------------------
    -- 2) Constants (unchanged)
    ------------------------------------------------------------------------------
    constant EOP_CODE : std_logic_vector(7 downto 0) := x"00"; -- EOP if flag='1'
    constant EEP_CODE : std_logic_vector(7 downto 0) := x"01"; -- EEP if flag='1'

    ------------------------------------------------------------------------------
    -- 3) Internal Signals
    ------------------------------------------------------------------------------
    signal s_data_controller_state : t_data_controller_fsm := IDLE;

    signal s_dest_channel : std_logic_vector(5 downto 0) := (others => '1');

    -- Registered outputs
    signal r_crossbar_select : std_logic_vector(5 downto 0) := (others => '1');
    signal r_txdata_data     : std_logic_vector(7 downto 0) := (others => '0');
    signal r_txdata_flag     : std_logic                    := '0';
    signal r_txdata_write    : std_logic                    := '0';
    signal r_rxdata_read     : std_logic                    := '0';

    ------------------------------------------------------------------------------
    -- 4) Timeout Control
    -- ‑ A separate counter/process keeps the FSM readable.
    -- ‑ Width = 32 bits ⇒ covers up to ‑4 s @ 100 MHz.
    ------------------------------------------------------------------------------
    signal s_timeout_cnt     : unsigned(31 downto 0) := (others => '0');
    signal s_timeout_active  : std_logic            := '0';
    signal s_timeout_expired : std_logic            := '0';

begin
    --------------------------------------------------------------------------
    -- Timeout Counter
    --------------------------------------------------------------------------
    p_timeout : process(clk_i)
    begin
        if rising_edge(clk_i) then
            if (rst_i = '1') then
                s_timeout_cnt    <= (others => '0');
                s_timeout_active <= '0';
                s_timeout_expired<= '0';
            else
                -- Default: assume it did not expire this cycle
                s_timeout_expired <= '0';

                -- Active only while forwarding a packet
                if (s_timeout_active = '1') then
                    if (s_timeout_cnt = 0) then
                        s_timeout_expired <= '1';      -- flag for FSM
                    else
                        s_timeout_cnt <= s_timeout_cnt - 1;
                    end if;
                end if;

                -- Reload / start
                if ((s_data_controller_state = TRANSMITTING) and
                    (spw_rxdata_ready_i = '1')) then
                    -- Got a data byte → reload
                    s_timeout_cnt    <= to_unsigned(TIMEOUT_CYCLES_G - 1, s_timeout_cnt'length);
                    s_timeout_active <= '1';
                elsif (s_data_controller_state = FINISHED) or
                      (s_data_controller_state = IDLE) then
                    -- Packet done → stop counter
                    s_timeout_active <= '0';
                    s_timeout_cnt    <= (others => '0');
                end if;
            end if;
        end if;
    end process p_timeout;

    ------------------------------------------------------------------------------
    -- Single-Process FSM
    ------------------------------------------------------------------------------
    p_data_controller_fsm : process(clk_i)
        variable v_data_controller_state      : t_data_controller_fsm;
        variable v_next_data_controller_state : t_data_controller_fsm;
    begin
        if rising_edge(clk_i) then

            if (rst_i = '1') then
                ------------------------------------------------------------------------
                -- Synchronous Reset
                ------------------------------------------------------------------------
                v_data_controller_state      := IDLE;
                v_next_data_controller_state := IDLE;

                s_data_controller_state <= IDLE;

                s_dest_channel    <= (others => '1');
                r_crossbar_select <= (others => '1');
                r_txdata_data     <= (others => '0');
                r_txdata_flag     <= '0';
                r_txdata_write    <= '0';
                r_rxdata_read     <= '0';

            else
                ------------------------------------------------------------------------
                -- Default assignments each clock to avoid latches
                ------------------------------------------------------------------------
                v_data_controller_state := s_data_controller_state;

                ------------------------------------------------------------------------
                -- FSM State Transitions
                ------------------------------------------------------------------------
                case s_data_controller_state is

                    ----------------------------------------------------------------------
                    -- IDLE
                    ----------------------------------------------------------------------
                    when IDLE =>
                        if (spw_rxdata_ready_i = '1') then
                            -- Next: read the first byte (destination address)
                            v_data_controller_state := PROCESSING;
			    -- Counter not started yet (first byte is address)
                            -- We will assert spw_rxdata_read in the “Outputs” section below
                        end if;

                    ----------------------------------------------------------------------
                    -- DELAY
                    ----------------------------------------------------------------------
                    when DELAY =>
                        v_data_controller_state := v_next_data_controller_state;

                    ----------------------------------------------------------------------
                    -- PROCESSING
                    --   - The first RX byte is the destination address => Index routing.
                    ----------------------------------------------------------------------
                    when PROCESSING =>
                        if (spw_rxdata_ready_i = '1') then
                            if (spw_rxdata_flag_i = '0') then
                                -- In the same cycle we see spw_rxdata_data_i. 
                                -- Then we move to TRANSMITTING next cycle.
                                s_dest_channel    <= spw_router_routing_table_i(
                                    to_integer(unsigned(spw_rxdata_data_i)));
                                r_crossbar_select <= spw_router_routing_table_i(
                                    to_integer(unsigned(spw_rxdata_data_i)));

                                v_data_controller_state      := DELAY;
                                v_next_data_controller_state := WAITING;
                            else
                                v_data_controller_state      := DELAY;
                                v_next_data_controller_state := FINISHED;
                            end if;
                        end if;

                    ----------------------------------------------------------------------
                    -- WAITING
                    ----------------------------------------------------------------------
                    when WAITING =>
                        if ((spw_rxdata_ready_i = '1') and (spw_txdata_ready_i = '1')) then
                            -- We see valid data from Rx
                            -- TX can accept data
                            v_data_controller_state := TRANSMITTING;

                        elsif (s_timeout_expired = '1') and (spw_txdata_ready_i = '1') then
                            -- 1 ms gap ⇒ inject EEP and close the packet
                            v_data_controller_state := TIMEOUT;
                        end if;

                    ----------------------------------------------------------------------
                    -- TRANSMITTING
                    --   - Forward data from Rx to Tx, one word per cycle.
                    --   - Flow control: only write if spw_txdata_ready_i='1'.
                    --   - Detect EOP/EEP => move to FINISHED.
                    ----------------------------------------------------------------------
                    when TRANSMITTING =>
                        v_data_controller_state := WAITING;

                        -- Check EOP/EEP
                        if (spw_rxdata_flag_i = '1') then
                            if ((spw_rxdata_data_i = EOP_CODE) or (spw_rxdata_data_i = EEP_CODE)) then
                                v_data_controller_state      := DELAY;
                                v_next_data_controller_state := FINISHED;
                            end if;
                        end if;

                    ----------------------------------------------------------------
                    -- TIMEOUT
                    --   - Inject a single EEP, then finish the packet.
                    ----------------------------------------------------------------
                    when TIMEOUT =>
                        v_data_controller_state      := DELAY;
                        v_next_data_controller_state := FINISHED;

                    ----------------------------------------------------------------------
                    -- FINISHED
                    --   - Packet complete => de-select channel, return to IDLE.
                    ----------------------------------------------------------------------
                    when FINISHED =>
                        s_dest_channel          <= (others => '1');
                        v_data_controller_state := IDLE;

                    when others =>
                        -- Fallback if something unexpected
                        v_data_controller_state := IDLE;
                end case;

                ------------------------------------------------------------------------
                -- Next-State Update
                ------------------------------------------------------------------------
                s_data_controller_state <= v_data_controller_state;

                ------------------------------------------------------------------------
                -- OUTPUT ASSIGNMENTS (depend on v_data_controller_state)
                --
                -- Typically, you do one "default" block at the top of the process 
                -- (r_txdata_write <= '0', etc.) then refine them here.
                ------------------------------------------------------------------------
                r_crossbar_select <= (others => '1');
                r_txdata_data     <= (others => '0');
                r_txdata_flag     <= '0';
                r_txdata_write    <= '0';
                r_rxdata_read     <= '0';

                case v_data_controller_state is

                    when IDLE =>
                        -- No writes, no reads
                        null;

                    when DELAY =>
                        r_crossbar_select <= s_dest_channel;

                    when PROCESSING =>
                        -- We are about to read the routing address
                        r_rxdata_read <= '1';

                    when WAITING =>
                        r_crossbar_select <= s_dest_channel;

                    when TRANSMITTING =>
                        -- We keep crossbar selected from above
                        r_crossbar_select <= s_dest_channel;
                        r_rxdata_read     <= '1';
                        r_txdata_write    <= '1';
                        r_txdata_data     <= spw_rxdata_data_i;
                        r_txdata_flag     <= spw_rxdata_flag_i;

                    when TIMEOUT =>
                        -- Timeout: inject EEP and finish the packet
                        r_crossbar_select <= s_dest_channel;
                        r_txdata_write    <= '1';
                        r_txdata_flag     <= '1';
                        r_txdata_data     <= EEP_CODE;
                        -- No RX read here – we’re inserting the EEP

                    when FINISHED =>
                        -- Done with packet
                        null;

                    when others =>
                        null;

                end case;

            end if;
        end if;
    end process p_data_controller_fsm;

    ------------------------------------------------------------------------------
    -- Assign Registered Signals to Entity Outputs
    ------------------------------------------------------------------------------
    crossbar_switch_select_o <= r_crossbar_select;
    spw_txdata_data_o        <= r_txdata_data;
    spw_txdata_flag_o        <= r_txdata_flag;
    spw_txdata_write_o       <= r_txdata_write;
    spw_rxdata_read_o        <= r_rxdata_read;

end architecture RTL;
