library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_scheduler_ent is
	port(
		clk_i               : in  std_logic;
		rst_i               : in  std_logic;
		tmr_start_on_sync_i : in  std_logic;
		tmr_clk_div_i       : in  std_logic_vector(31 downto 0);
		tmr_time_in_i       : in  std_logic_vector(31 downto 0);
		tmr_clear_i         : in  std_logic;
		tmr_stop_i          : in  std_logic;
		tmr_run_i           : in  std_logic;
		tmr_start_i         : in  std_logic;
		sync_i              : in  std_logic;
		tmr_cleared_o       : out std_logic;
		tmr_running_o       : out std_logic;
		tmr_started_o       : out std_logic;
		tmr_stopped_o       : out std_logic;
		tmr_time_out_o      : out std_logic_vector(31 downto 0)
	);
end entity data_scheduler_ent;

architecture RTL of data_scheduler_ent is

	type t_data_scheduler_fsm is (
		STOPPED,
		STARTED,
		RUNNING,
		CLEAR
	);

	-- data scheduler fsm state signal
	signal s_data_scheduler_state : t_data_scheduler_fsm;

	signal s_tmr_time : std_logic_vector(31 downto 0);

	signal s_tmr_registered_clkdiv : std_logic_vector((tmr_clk_div_i'length - 1) downto 0);

	signal s_tmr_evt_counter : std_logic_vector(31 downto 0);

begin

	p_data_scheduler : process(clk_i, rst_i) is
		variable v_tmr_evt_flag : std_logic;
	begin
		if (rst_i = '1') then

		elsif rising_edge(clk_i) then

			-- timer event generation

			-- check if the event generation is active

			if ((s_data_scheduler_state = RUNNING)) then
				-- check if the clkdiv is zero (no clkdiv)
				if (s_tmr_registered_clkdiv = std_logic_vector(to_unsigned(0, s_tmr_registered_clkdiv'length))) then
					-- no clkdiv, use the clock as reference to generate event flag
					v_tmr_evt_flag    := '1';
					-- keep the event counter in zero
					s_tmr_evt_counter <= std_logic_vector(to_unsigned(0, s_tmr_evt_counter'length));
				else
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

			-- data scheduler fsm
			case (s_data_scheduler_state) is

				when STOPPED =>
					-- timer is stopped
					-- keep all internal signals a default
					s_data_scheduler_state  <= STOPPED;
					s_tmr_time              <= tmr_time_in_i;
					s_tmr_registered_clkdiv <= tmr_clk_div_i;
					s_tmr_evt_counter       <= std_logic_vector(to_unsigned(0, s_tmr_evt_counter'length));
					v_tmr_evt_flag          := '0';
					-- keep outputs at the default
					tmr_running_o           <= '0';
					tmr_started_o           <= '0';
					tmr_stopped_o           <= '1';
					tmr_time_out_o          <= std_logic_vector(to_unsigned(0, tmr_time_out_o'length));
					-- check if a command to start was received
					if (tmr_start_i = '1') then
						-- go to timer started
						s_data_scheduler_state <= STARTED;
						tmr_cleared_o          <= '0';
						tmr_running_o          <= '0';
						tmr_started_o          <= '1';
						tmr_stopped_o          <= '0';
					end if;

				when STARTED =>
					-- timer is started, but not running
					-- internal signals
					s_data_scheduler_state <= STARTED;
					s_tmr_evt_counter      <= std_logic_vector(to_unsigned(0, s_tmr_evt_counter'length));
					v_tmr_evt_flag         := '0';
					-- outputs
					tmr_cleared_o          <= '0';
					tmr_running_o          <= '0';
					tmr_started_o          <= '1';
					tmr_stopped_o          <= '0';
					tmr_time_out_o         <= s_tmr_time;

					-- check if a command to clear was received
					if (tmr_clear_i = '1') then
						-- go to timer running
						s_data_scheduler_state <= RUNNING;
					-- check if a command to run was received or a sync (when activated)
					elsif ((tmr_start_i = '1') or ((sync_i = '1') and (tmr_start_on_sync_i = '1'))) then
						-- go to timer running
						s_data_scheduler_state <= RUNNING;
						tmr_cleared_o          <= '0';
						tmr_running_o          <= '1';
						tmr_started_o          <= '0';
						tmr_stopped_o          <= '0';
					end if;

				when RUNNING =>
					-- timer is running
					-- internal signals
					s_data_scheduler_state <= RUNNING;
					-- outputs
					tmr_cleared_o          <= '0';
					tmr_running_o          <= '1';
					tmr_started_o          <= '0';
					tmr_stopped_o          <= '0';
					tmr_time_out_o         <= s_tmr_time;
					-- check if a event happened
					if (v_tmr_evt_flag = '1') then
						-- clear the event flag
						v_tmr_evt_flag := '0';
						-- increment the timer
						s_tmr_time     <= std_logic_vector(unsigned(s_tmr_time) + 1);
					end if;
					-- check if a stopped command was received
					if (tmr_stop_i = '1') then
						-- go to timer started
						s_data_scheduler_state <= STARTED;
						tmr_cleared_o          <= '0';
						tmr_running_o          <= '0';
						tmr_started_o          <= '1';
						tmr_stopped_o          <= '0';
					end if;

				when CLEAR =>
					-- clear timer
					s_data_scheduler_state <= STOPPED;
					tmr_cleared_o          <= '1';
					tmr_running_o          <= '0';
					tmr_started_o          <= '0';
					tmr_stopped_o          <= '1';

			end case;

		end if;
	end process p_data_scheduler;

end architecture RTL;
