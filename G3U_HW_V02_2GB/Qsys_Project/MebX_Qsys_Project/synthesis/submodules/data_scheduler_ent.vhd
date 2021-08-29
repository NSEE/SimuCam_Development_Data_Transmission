library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_scheduler_ent is
    generic(
        g_TIMER_CLKDIV_WIDTH : natural range 1 to 64 := 32;
        g_TIMER_TIME_WIDTH   : natural range 1 to 64 := 32
    );
    port(
        clk_i             : in  std_logic;
        rst_i             : in  std_logic;
        tmr_run_on_sync_i : in  std_logic;
        tmr_clk_div_i     : in  std_logic_vector((g_TIMER_CLKDIV_WIDTH - 1) downto 0);
        tmr_time_in_i     : in  std_logic_vector((g_TIMER_TIME_WIDTH - 1) downto 0);
        tmr_clear_i       : in  std_logic;
        tmr_stop_i        : in  std_logic;
        tmr_run_i         : in  std_logic;
        tmr_start_i       : in  std_logic;
        sync_i            : in  std_logic;
        dctrl_tmr_clear_i : in  std_logic;
        tmr_cleared_o     : out std_logic;
        tmr_running_o     : out std_logic;
        tmr_started_o     : out std_logic;
        tmr_stopped_o     : out std_logic;
        tmr_time_out_o    : out std_logic_vector((g_TIMER_TIME_WIDTH - 1) downto 0)
    );
end entity data_scheduler_ent;

architecture RTL of data_scheduler_ent is

    constant c_MAX_TIME_VALUE : std_logic_vector((g_TIMER_TIME_WIDTH - 1) downto 0) := (others => '1');

    type t_data_scheduler_fsm is (
        STOPPED,                        -- Stopped, reset all internal signals
        STARTED,                        -- Timer is started, but not running yet
        RUNNING,                        -- Timer is running
        CLEAR                           -- Clear timer
    );
    signal s_data_scheduler_state : t_data_scheduler_fsm; -- current state

    signal s_tmr_time : std_logic_vector((g_TIMER_TIME_WIDTH - 1) downto 0);

    signal s_tmr_registered_clkdiv : std_logic_vector((g_TIMER_CLKDIV_WIDTH - 1) downto 0);

    signal s_tmr_evt_counter : std_logic_vector((g_TIMER_CLKDIV_WIDTH - 1) downto 0);

begin

    -- data scheduler fsm process
    p_data_scheduler : process(clk_i, rst_i) is
        variable v_data_scheduler_state : t_data_scheduler_fsm;
        variable v_tmr_evt_flag         : std_logic;
    begin
        if (rst_i = '1') then
            -- states
            s_data_scheduler_state  <= STOPPED;
            v_data_scheduler_state  := STOPPED;
            -- internal signals
            s_tmr_time              <= std_logic_vector(to_unsigned(0, s_tmr_time'length));
            s_tmr_registered_clkdiv <= std_logic_vector(to_unsigned(0, s_tmr_registered_clkdiv'length));
            s_tmr_evt_counter       <= std_logic_vector(to_unsigned(0, s_tmr_evt_counter'length));
            -- internal variables
            v_tmr_evt_flag          := '0';
            -- outputs
            tmr_cleared_o           <= '0';
            tmr_running_o           <= '0';
            tmr_started_o           <= '0';
            tmr_stopped_o           <= '0';
            tmr_time_out_o          <= std_logic_vector(to_unsigned(0, tmr_time_out_o'length));
        elsif rising_edge(clk_i) then

            -- timer event generation

            -- check if the event generation is active (timer is running)
            if ((s_data_scheduler_state = RUNNING)) then
                -- check if the clkdiv is zero (no clkdiv)
                if (s_tmr_registered_clkdiv = std_logic_vector(to_unsigned(0, s_tmr_registered_clkdiv'length))) then
                    -- no clkdiv, use the clock as reference to generate event flag
                    v_tmr_evt_flag    := '1';
                    -- keep the event counter at zero
                    s_tmr_evt_counter <= std_logic_vector(to_unsigned(0, s_tmr_evt_counter'length));
                else
                    -- clkdiv is used
                    -- check if the timer event counter hit the desired clkdiv	
                    if (s_tmr_evt_counter = s_tmr_registered_clkdiv) then
                        -- timer event counter is at the desired clkdiv, generate event flag
                        v_tmr_evt_flag    := '1';
                        -- restart the event counter
                        s_tmr_evt_counter <= std_logic_vector(to_unsigned(0, s_tmr_evt_counter'length));
                    else
                        -- timer event counter is not at the desired clkdiv yet
                        -- keep event flag cleared
                        v_tmr_evt_flag    := '0';
                        -- increment timer event counter
                        s_tmr_evt_counter <= std_logic_vector(unsigned(s_tmr_evt_counter) + 1);
                    end if;
                end if;
            end if;

            -- States transitions FSM
            case (s_data_scheduler_state) is

                when STOPPED =>
                    -- Stopped, reset all internal signals
                    -- default state transition
                    s_data_scheduler_state  <= STOPPED;
                    v_data_scheduler_state  := STOPPED;
                    -- default internal signal values
                    s_tmr_time              <= tmr_time_in_i;
                    s_tmr_registered_clkdiv <= tmr_clk_div_i;
                    s_tmr_evt_counter       <= std_logic_vector(to_unsigned(0, s_tmr_evt_counter'length));
                    v_tmr_evt_flag          := '0';
                    -- conditional state transition
                    -- check if a command to start was received
                    if (tmr_start_i = '1') then
                        -- go to timer started
                        s_data_scheduler_state <= STARTED;
                        v_data_scheduler_state := STARTED;
                    end if;

                when STARTED =>
                    -- Timer is started, but not running yet
                    -- default state transition
                    s_data_scheduler_state <= STARTED;
                    v_data_scheduler_state := STARTED;
                    -- default internal signal values
                    s_tmr_evt_counter      <= std_logic_vector(to_unsigned(0, s_tmr_evt_counter'length));
                    v_tmr_evt_flag         := '0';
                    -- conditional state transition
                    -- check if a command to run was received or a sync (when activated)
                    if ((tmr_run_i = '1') or ((sync_i = '1') and (tmr_run_on_sync_i = '1'))) then
                        -- go to timer running
                        s_data_scheduler_state <= RUNNING;
                        v_data_scheduler_state := RUNNING;
                    end if;

                when RUNNING =>
                    -- Timer is running
                    -- default state transition
                    s_data_scheduler_state <= RUNNING;
                    v_data_scheduler_state := RUNNING;
                    -- default internal signal values
                    -- conditional state transition
                    -- check if clear command was issued
                    if ((tmr_clear_i = '1') or (dctrl_tmr_clear_i = '1')) then
                        -- go to clear
                        s_data_scheduler_state <= CLEAR;
                        v_data_scheduler_state := CLEAR;
                    else
                        -- check if a event happened
                        if (v_tmr_evt_flag = '1') then
                            -- clear the event flag
                            v_tmr_evt_flag := '0';
                            -- check if the timer can be incremented (a overflow will not occur)
                            if (s_tmr_time < c_MAX_TIME_VALUE) then
                                -- timer can be incremented without overflow
                                -- increment the timer
                                s_tmr_time <= std_logic_vector(unsigned(s_tmr_time) + 1);
                            else
                                -- timer will go to overflow if incremented
                                s_tmr_time <= std_logic_vector(to_unsigned(0, s_tmr_time'length));
                            end if;
                        end if;
                    end if;

                when CLEAR =>
                    -- Clear timer
                    -- default state transition
                    s_data_scheduler_state <= RUNNING;
                    v_data_scheduler_state := RUNNING;
                    -- default internal signal values
                    s_tmr_time             <= std_logic_vector(to_unsigned(0, s_tmr_time'length));
                    s_tmr_evt_counter      <= std_logic_vector(to_unsigned(0, s_tmr_evt_counter'length));
                    v_tmr_evt_flag         := '0';
                    -- conditional state transition

            end case;

            -- Output generation FSM
            case (v_data_scheduler_state) is

                when STOPPED =>
                    -- Stopped, reset all internal signals
                    -- default output signals
                    tmr_cleared_o  <= '0';
                    tmr_running_o  <= '0';
                    tmr_started_o  <= '0';
                    tmr_stopped_o  <= '1';
                    tmr_time_out_o <= std_logic_vector(to_unsigned(0, tmr_time_out_o'length));
                -- conditional output signals

                when STARTED =>
                    -- Timer is started, but not running yet
                    -- default output signals
                    tmr_cleared_o  <= '0';
                    tmr_running_o  <= '0';
                    tmr_started_o  <= '1';
                    tmr_stopped_o  <= '0';
                    tmr_time_out_o <= s_tmr_time;
                -- conditional output signals

                when RUNNING =>
                    -- Timer is running
                    -- default output signals
                    tmr_running_o  <= '1';
                    tmr_started_o  <= '0';
                    tmr_stopped_o  <= '0';
                    tmr_time_out_o <= s_tmr_time;
                -- conditional output signals

                when CLEAR =>
                    -- Clear timer
                    -- default output signals
                    tmr_cleared_o  <= '1';
                    tmr_running_o  <= '1';
                    tmr_started_o  <= '0';
                    tmr_stopped_o  <= '0';
                    tmr_time_out_o <= s_tmr_time;
                    -- conditional output signals

            end case;

            -- check if a stop was issued
            if (tmr_stop_i = '1') then
                -- stop, go to stopped
                s_data_scheduler_state <= STOPPED;
                v_data_scheduler_state := STOPPED;
            end if;

        end if;
    end process p_data_scheduler;

end architecture RTL;
