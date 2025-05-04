library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-------------------------------------------------------------------------------
--  SpaceWire – dummy data "arbiter"
--  • Grants every channel immediately (registered, 1-clk latency)
--  • Discards all TX data – no shared output port
--  • Keeps the original g_RESET_DELAY generic so the rest of the design can
--    rely on a defined start-up latency.
-------------------------------------------------------------------------------
entity spwr_data_discard_ent is
    generic(
        g_RESET_DELAY         : natural  range 0 to 8  := 0;
        g_SPW_ROUTER_CHANNELS : positive range 1 to 32 := 8
    );
    port(
        ----------------------------------------------------------------------
        -- Clock / Reset
        ----------------------------------------------------------------------
        clock_i  : in  std_logic;
        reset_i  : in  std_logic;

        ----------------------------------------------------------------------
        -- Requests / Grants  (0 .. g_SPW_ROUTER_CHANNELS)
        ----------------------------------------------------------------------
        data_arbiter_write_request_i : in  std_logic_vector(0 to g_SPW_ROUTER_CHANNELS);
        data_arbiter_write_allowed_o : out std_logic_vector(0 to g_SPW_ROUTER_CHANNELS);

        ----------------------------------------------------------------------
        -- Dummy channel-side handshake (data lines are ignored)
        ----------------------------------------------------------------------
        in_spw_txdata_write_i : in  std_logic;
        in_spw_txdata_data_i  : in  std_logic_vector(7 downto 0);
        in_spw_txdata_flag_i  : in  std_logic;
        in_spw_txdata_ready_o : out std_logic
    );
end spwr_data_discard_ent;

-------------------------------------------------------------------------------
architecture RTL of spwr_data_discard_ent is
    --------------------------------------------------------------------------
    -- The original FSM collapses into a single counter that holds the design
    -- in reset for g_RESET_DELAY cycles and then forwards every request bit
    -- to its corresponding grant bit with a single-clock latency.
    --------------------------------------------------------------------------
    signal r_reset_cnt : natural range 0 to 255 := 0;
    signal r_grant     : std_logic_vector(0 to g_SPW_ROUTER_CHANNELS) := (others => '0');
begin

    p_grant : process(clock_i)
    begin
        if rising_edge(clock_i) then
            if reset_i = '1' then
                r_reset_cnt <= g_RESET_DELAY;
                r_grant     <= (others => '0');
            elsif r_reset_cnt /= 0 then
                r_reset_cnt <= r_reset_cnt - 1;
                r_grant     <= (others => '0');
            else
                ------------------------------------------------------------------
                -- "Grant on every request" behaviour
                ------------------------------------------------------------------
                r_grant <= data_arbiter_write_request_i;
            end if;
        end if;
    end process;

    --------------------------------------------------------------------------
    -- Output assignments / tie-offs
    --------------------------------------------------------------------------
    data_arbiter_write_allowed_o <= r_grant;      -- 1-clk registered mirror
    in_spw_txdata_ready_o        <= '1';          -- always ready, data is ignored

end architecture RTL;
