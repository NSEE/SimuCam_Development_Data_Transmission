library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.comm_irq_manager_pkg.all;

entity dcom_rprt_irq_manager_ent is
	port(
		clk_i               : in  std_logic;
		rst_i               : in  std_logic;
		irq_manager_stop_i  : in  std_logic;
		irq_manager_start_i : in  std_logic;
		global_irq_en_i     : in  std_logic;
		irq_watches_i       : in  t_ftdi_dcom_rprt_manager_watches;
		--		irq_contexts_i      : in  t_ftdi_dcom_rprt_manager_contexts;
		irq_flags_en_i      : in  t_ftdi_dcom_rprt_manager_flags;
		irq_flags_clr_i     : in  t_ftdi_dcom_rprt_manager_flags;
		irq_flags_o         : out t_ftdi_dcom_rprt_manager_flags;
		irq_o               : out std_logic
	);
end entity dcom_rprt_irq_manager_ent;

architecture RTL of dcom_rprt_irq_manager_ent is

	signal s_irq_manager_started : std_logic;
	signal s_irq_watches_delayed : t_ftdi_dcom_rprt_manager_watches;
	signal s_irq_flags           : t_ftdi_dcom_rprt_manager_flags;

begin

	p_ftdi_dcom_rprt_manager : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

			s_irq_manager_started <= '0';
			s_irq_watches_delayed <= c_DCOM_RPRT_IRQ_MANAGER_WATCHES_RST;
			s_irq_flags           <= c_DCOM_RPRT_IRQ_MANAGER_FLAGS_RST;

		elsif (rising_edge(clk_i)) then

			-- manage start/stop
			if (irq_manager_start_i = '1') then
				s_irq_manager_started <= '1';
			elsif (irq_manager_stop_i = '1') then
				s_irq_manager_started <= '0';
			end if;

			-- manage flags
			if (s_irq_manager_started = '0') then
				-- keep flags cleared
				s_irq_flags <= c_DCOM_RPRT_IRQ_MANAGER_FLAGS_RST;
			else
				-- clear flags --
				if (irq_flags_clr_i.rprt_spw_link_connected = '1') then
					s_irq_flags.rprt_spw_link_connected <= '0';
				end if;
				if (irq_flags_clr_i.rprt_spw_link_disconnected = '1') then
					s_irq_flags.rprt_spw_link_disconnected <= '0';
				end if;
				if (irq_flags_clr_i.rprt_spw_err_disconnect = '1') then
					s_irq_flags.rprt_spw_err_disconnect <= '0';
				end if;
				if (irq_flags_clr_i.rprt_spw_err_parity = '1') then
					s_irq_flags.rprt_spw_err_parity <= '0';
				end if;
				if (irq_flags_clr_i.rprt_spw_err_escape = '1') then
					s_irq_flags.rprt_spw_err_escape <= '0';
				end if;
				if (irq_flags_clr_i.rprt_spw_err_credit = '1') then
					s_irq_flags.rprt_spw_err_credit <= '0';
				end if;
				if (irq_flags_clr_i.rprt_rx_timecode_received = '1') then
					s_irq_flags.rprt_rx_timecode_received <= '0';
				end if;
				if (irq_flags_clr_i.rprt_rmap_err_early_eop = '1') then
					s_irq_flags.rprt_rmap_err_early_eop <= '0';
				end if;
				if (irq_flags_clr_i.rprt_rmap_err_eep = '1') then
					s_irq_flags.rprt_rmap_err_eep <= '0';
				end if;
				if (irq_flags_clr_i.rprt_rmap_err_header_crc = '1') then
					s_irq_flags.rprt_rmap_err_header_crc <= '0';
				end if;
				if (irq_flags_clr_i.rprt_rmap_err_unused_packet_type = '1') then
					s_irq_flags.rprt_rmap_err_unused_packet_type <= '0';
				end if;
				if (irq_flags_clr_i.rprt_rmap_err_invalid_command_code = '1') then
					s_irq_flags.rprt_rmap_err_invalid_command_code <= '0';
				end if;
				if (irq_flags_clr_i.rprt_rmap_err_too_much_data = '1') then
					s_irq_flags.rprt_rmap_err_too_much_data <= '0';
				end if;
				if (irq_flags_clr_i.rprt_rmap_err_invalid_data_crc = '1') then
					s_irq_flags.rprt_rmap_err_invalid_data_crc <= '0';
				end if;
				-- set flags --
				-- check if the global interrupt is enabled
				if (global_irq_en_i = '1') then

					-- check if the spw link connected interrupt is activated
					if (irq_flags_en_i.rprt_spw_link_connected = '1') then
						-- detect a rising edge in spw link running signal
						if ((s_irq_watches_delayed.rprt_spw_link_running = '0') and (irq_watches_i.rprt_spw_link_running = '1')) then
							s_irq_flags.rprt_spw_link_connected <= '1';
						end if;
					end if;

					-- check if the spw link disconnected interrupt is activated
					if (irq_flags_en_i.rprt_spw_link_disconnected = '1') then
						-- detect a falling edge in spw link running signal
						if ((s_irq_watches_delayed.rprt_spw_link_running = '1') and (irq_watches_i.rprt_spw_link_running = '0')) then
							s_irq_flags.rprt_spw_link_disconnected <= '1';
						end if;
					end if;

					-- check if the spw err disconnect interrupt is activated
					if (irq_flags_en_i.rprt_spw_err_disconnect = '1') then
						-- detect a rising edge in spw err disconnect signal
						if ((s_irq_watches_delayed.rprt_spw_err_disconnect = '0') and (irq_watches_i.rprt_spw_err_disconnect = '1')) then
							s_irq_flags.rprt_spw_err_disconnect <= '1';
						end if;
					end if;

					-- check if the spw err parity interrupt is activated
					if (irq_flags_en_i.rprt_spw_err_parity = '1') then
						-- detect a rising edge in spw err parity signal
						if ((s_irq_watches_delayed.rprt_spw_err_parity = '0') and (irq_watches_i.rprt_spw_err_parity = '1')) then
							s_irq_flags.rprt_spw_err_parity <= '1';
						end if;
					end if;

					-- check if the spw err escape interrupt is activated
					if (irq_flags_en_i.rprt_spw_err_escape = '1') then
						-- detect a rising edge in spw err escape signal
						if ((s_irq_watches_delayed.rprt_spw_err_escape = '0') and (irq_watches_i.rprt_spw_err_escape = '1')) then
							s_irq_flags.rprt_spw_err_escape <= '1';
						end if;
					end if;

					-- check if the spw err credit interrupt is activated
					if (irq_flags_en_i.rprt_spw_err_credit = '1') then
						-- detect a rising edge in spw err credit signal
						if ((s_irq_watches_delayed.rprt_spw_err_credit = '0') and (irq_watches_i.rprt_spw_err_credit = '1')) then
							s_irq_flags.rprt_spw_err_credit <= '1';
						end if;
					end if;

					-- check if the rx timecode received interrupt is activated
					if (irq_flags_en_i.rprt_rx_timecode_received = '1') then
						-- detect a rising edge in rx timecode received signal
						if ((s_irq_watches_delayed.rprt_rx_timecode_received = '0') and (irq_watches_i.rprt_rx_timecode_received = '1')) then
							s_irq_flags.rprt_rx_timecode_received <= '1';
						end if;
					end if;

					-- check if the rmap err early eop interrupt is activated
					if (irq_flags_en_i.rprt_rmap_err_early_eop = '1') then
						-- detect a rising edge in rmap err early eop signal
						if ((s_irq_watches_delayed.rprt_rmap_err_early_eop = '0') and (irq_watches_i.rprt_rmap_err_early_eop = '1')) then
							s_irq_flags.rprt_rmap_err_early_eop <= '1';
						end if;
					end if;

					-- check if the rmap err eep interrupt is activated
					if (irq_flags_en_i.rprt_rmap_err_eep = '1') then
						-- detect a rising edge in rmap err eep signal
						if ((s_irq_watches_delayed.rprt_rmap_err_eep = '0') and (irq_watches_i.rprt_rmap_err_eep = '1')) then
							s_irq_flags.rprt_rmap_err_eep <= '1';
						end if;
					end if;

					-- check if the rmap err header crc interrupt is activated
					if (irq_flags_en_i.rprt_rmap_err_header_crc = '1') then
						-- detect a rising edge in rmap err header crc signal
						if ((s_irq_watches_delayed.rprt_rmap_err_header_crc = '0') and (irq_watches_i.rprt_rmap_err_header_crc = '1')) then
							s_irq_flags.rprt_rmap_err_header_crc <= '1';
						end if;
					end if;

					-- check if the rmap err unused packet type interrupt is activated
					if (irq_flags_en_i.rprt_rmap_err_unused_packet_type = '1') then
						-- detect a rising edge in rmap err unused packet type signal
						if ((s_irq_watches_delayed.rprt_rmap_err_unused_packet_type = '0') and (irq_watches_i.rprt_rmap_err_unused_packet_type = '1')) then
							s_irq_flags.rprt_rmap_err_unused_packet_type <= '1';
						end if;
					end if;

					-- check if the rmap err invalid command_code interrupt is activated
					if (irq_flags_en_i.rprt_rmap_err_invalid_command_code = '1') then
						-- detect a rising edge in rmap err invalid command code signal
						if ((s_irq_watches_delayed.rprt_rmap_err_invalid_command_code = '0') and (irq_watches_i.rprt_rmap_err_invalid_command_code = '1')) then
							s_irq_flags.rprt_rmap_err_invalid_command_code <= '1';
						end if;
					end if;

					-- check if the rmap err too much data interrupt is activated
					if (irq_flags_en_i.rprt_rmap_err_too_much_data = '1') then
						-- detect a rising edge in rmap err too much data signal
						if ((s_irq_watches_delayed.rprt_rmap_err_too_much_data = '0') and (irq_watches_i.rprt_rmap_err_too_much_data = '1')) then
							s_irq_flags.rprt_rmap_err_too_much_data <= '1';
						end if;
					end if;

					-- check if the rmap err invalid data crc interrupt is activated
					if (irq_flags_en_i.rprt_rmap_err_invalid_data_crc = '1') then
						-- detect a rising edge in rmap err invalid data crc signal
						if ((s_irq_watches_delayed.rprt_rmap_err_invalid_data_crc = '0') and (irq_watches_i.rprt_rmap_err_invalid_data_crc = '1')) then
							s_irq_flags.rprt_rmap_err_invalid_data_crc <= '1';
						end if;
					end if;

				end if;
			end if;

			-- delay signals
			s_irq_watches_delayed <= irq_watches_i;

		end if;
	end process p_ftdi_dcom_rprt_manager;

	-- irq assignment and outputs generation
	irq_flags_o <= s_irq_flags;
	irq_o       <= ('0') when (rst_i = '1')
	               else ('1') when ((s_irq_flags.rprt_spw_link_connected = '1') or (s_irq_flags.rprt_spw_link_disconnected = '1') or (s_irq_flags.rprt_spw_err_disconnect = '1') or (s_irq_flags.rprt_spw_err_parity = '1') or (s_irq_flags.rprt_spw_err_escape = '1') or (s_irq_flags.rprt_spw_err_credit = '1') or (s_irq_flags.rprt_rx_timecode_received = '1') or (s_irq_flags.rprt_rmap_err_early_eop = '1') or (s_irq_flags.rprt_rmap_err_eep = '1') or (s_irq_flags.rprt_rmap_err_header_crc = '1') or (s_irq_flags.rprt_rmap_err_unused_packet_type = '1') or (s_irq_flags.rprt_rmap_err_invalid_command_code = '1') or (s_irq_flags.rprt_rmap_err_too_much_data = '1') or (s_irq_flags.rprt_rmap_err_invalid_data_crc = '1'))
	               else ('0');

end architecture RTL;
