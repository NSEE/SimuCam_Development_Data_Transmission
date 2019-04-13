library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_dcom_pkg.all;
use work.avalon_mm_dcom_registers_pkg.all;

entity avalon_mm_dcom_write_ent is
	port(
		clk_i                  : in  std_logic;
		rst_i                  : in  std_logic;
		avalon_mm_dcom_i       : in  t_avalon_mm_dcom_write_in;
		avalon_mm_dcom_o       : out t_avalon_mm_dcom_write_out;
		dcom_write_registers_o : out t_dcom_write_registers
	);
end entity avalon_mm_dcom_write_ent;

architecture RTL of avalon_mm_dcom_write_ent is

	signal s_data_written : std_logic;

begin

	p_avalon_mm_dcom_write : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			-- dcom resets
			dcom_write_registers_o.spw_link_config_reg.spw_lnkcfg_disconnect           <= '0';
			dcom_write_registers_o.spw_link_config_reg.spw_lnkcfg_linkstart            <= '0';
			dcom_write_registers_o.spw_link_config_reg.spw_lnkcfg_autostart            <= '0';
			dcom_write_registers_o.spw_link_config_reg.spw_lnkcfg_txdivcnt             <= x"01";
			dcom_write_registers_o.spw_timecode_tx_rxctrl_reg.timecode_tx_time         <= "000000";
			dcom_write_registers_o.spw_timecode_tx_rxctrl_reg.timecode_tx_control      <= "00";
			dcom_write_registers_o.spw_timecode_tx_rxctrl_reg.timecode_tx_send         <= '0';
			dcom_write_registers_o.spw_timecode_tx_rxctrl_reg.timecode_rx_received_clr <= '0';
			dcom_write_registers_o.data_controller_config_reg.send_eop                 <= '1';
			dcom_write_registers_o.data_controller_config_reg.send_eep                 <= '1';
			dcom_write_registers_o.data_scheduler_timer_config_reg.timer_start_on_sync <= '1';
			dcom_write_registers_o.data_scheduler_timer_clkdiv_reg.timer_clk_div       <= x"00000000";
			dcom_write_registers_o.data_scheduler_timer_time_in_reg.timer_time_in      <= x"00000000";
			dcom_write_registers_o.data_scheduler_timer_control_reg.timer_start        <= '0';
			dcom_write_registers_o.data_scheduler_timer_control_reg.timer_run          <= '0';
			dcom_write_registers_o.data_scheduler_timer_control_reg.timer_stop         <= '0';
			dcom_write_registers_o.data_scheduler_timer_control_reg.timer_clear        <= '0';
			dcom_write_registers_o.dcom_irq_control_reg.dcom_tx_end_en                 <= '0';
			dcom_write_registers_o.dcom_irq_control_reg.dcom_tx_begin_en               <= '0';
			dcom_write_registers_o.dcom_irq_control_reg.dcom_global_irq_en             <= '0';
			dcom_write_registers_o.dcom_irq_flags_clear_reg.dcom_tx_end_flag_clear     <= '0';
			dcom_write_registers_o.dcom_irq_flags_clear_reg.dcom_tx_begin_flag_clear   <= '0';
			s_data_written                                                             <= '0';
		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin
			-- dcom triggers
			dcom_write_registers_o.spw_timecode_tx_rxctrl_reg.timecode_tx_send         <= '0';
			dcom_write_registers_o.spw_timecode_tx_rxctrl_reg.timecode_rx_received_clr <= '0';
			dcom_write_registers_o.data_scheduler_timer_control_reg.timer_start        <= '0';
			dcom_write_registers_o.data_scheduler_timer_control_reg.timer_run          <= '0';
			dcom_write_registers_o.data_scheduler_timer_control_reg.timer_stop         <= '0';
			dcom_write_registers_o.data_scheduler_timer_control_reg.timer_clear        <= '0';
			dcom_write_registers_o.dcom_irq_flags_clear_reg.dcom_tx_end_flag_clear     <= '0';
			dcom_write_registers_o.dcom_irq_flags_clear_reg.dcom_tx_begin_flag_clear   <= '0';
			s_data_written                                                             <= '0';
		end procedure p_control_triggers;

		procedure p_writedata(write_address_i : t_avalon_mm_dcom_address) is
		begin
			if (s_data_written = '0') then
				-- Registers Write Data
				case (write_address_i) is
					-- Case for access to all registers address

					-- dcom registers
					when (16#00#) =>
						dcom_write_registers_o.spw_link_config_reg.spw_lnkcfg_disconnect <= avalon_mm_dcom_i.writedata(0);
						dcom_write_registers_o.spw_link_config_reg.spw_lnkcfg_linkstart  <= avalon_mm_dcom_i.writedata(1);
						dcom_write_registers_o.spw_link_config_reg.spw_lnkcfg_autostart  <= avalon_mm_dcom_i.writedata(2);
						dcom_write_registers_o.spw_link_config_reg.spw_lnkcfg_txdivcnt   <= avalon_mm_dcom_i.writedata(31 downto 24);
					when (16#01#) =>
						dcom_write_registers_o.spw_timecode_tx_rxctrl_reg.timecode_tx_time         <= avalon_mm_dcom_i.writedata(5 downto 0);
						dcom_write_registers_o.spw_timecode_tx_rxctrl_reg.timecode_tx_control      <= avalon_mm_dcom_i.writedata(7 downto 6);
						dcom_write_registers_o.spw_timecode_tx_rxctrl_reg.timecode_tx_send         <= avalon_mm_dcom_i.writedata(8);
						dcom_write_registers_o.spw_timecode_tx_rxctrl_reg.timecode_rx_received_clr <= avalon_mm_dcom_i.writedata(24);
					when (16#02#) =>
						null;
					when (16#03#) =>
						dcom_write_registers_o.data_controller_config_reg.send_eop <= avalon_mm_dcom_i.writedata(0);
						dcom_write_registers_o.data_controller_config_reg.send_eep <= avalon_mm_dcom_i.writedata(1);
					when (16#04#) =>
						dcom_write_registers_o.data_scheduler_timer_config_reg.timer_start_on_sync <= avalon_mm_dcom_i.writedata(0);
					when (16#05#) =>
						dcom_write_registers_o.data_scheduler_timer_clkdiv_reg.timer_clk_div <= avalon_mm_dcom_i.writedata(31 downto 0);
					when (16#06#) =>
						null;
					when (16#07#) =>
						dcom_write_registers_o.data_scheduler_timer_time_in_reg.timer_time_in <= avalon_mm_dcom_i.writedata(31 downto 0);
					when (16#08#) =>
						dcom_write_registers_o.data_scheduler_timer_control_reg.timer_start <= avalon_mm_dcom_i.writedata(0);
						dcom_write_registers_o.data_scheduler_timer_control_reg.timer_run   <= avalon_mm_dcom_i.writedata(1);
						dcom_write_registers_o.data_scheduler_timer_control_reg.timer_stop  <= avalon_mm_dcom_i.writedata(2);
						dcom_write_registers_o.data_scheduler_timer_control_reg.timer_clear <= avalon_mm_dcom_i.writedata(3);
					when (16#09#) =>
						dcom_write_registers_o.dcom_irq_control_reg.dcom_tx_end_en     <= avalon_mm_dcom_i.writedata(0);
						dcom_write_registers_o.dcom_irq_control_reg.dcom_tx_begin_en   <= avalon_mm_dcom_i.writedata(1);
						dcom_write_registers_o.dcom_irq_control_reg.dcom_global_irq_en <= avalon_mm_dcom_i.writedata(8);
					when (16#0A#) =>
						null;
					when (16#0B#) =>
						dcom_write_registers_o.dcom_irq_flags_clear_reg.dcom_tx_end_flag_clear   <= avalon_mm_dcom_i.writedata(0);
						dcom_write_registers_o.dcom_irq_flags_clear_reg.dcom_tx_begin_flag_clear <= avalon_mm_dcom_i.writedata(1);
					when others =>
						null;

				end case;
				s_data_written <= '1';
			end if;
		end procedure p_writedata;

		variable v_write_address : t_avalon_mm_dcom_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_dcom_o.waitrequest <= '1';
			v_write_address              := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			avalon_mm_dcom_o.waitrequest <= '1';
			p_control_triggers;
			if (avalon_mm_dcom_i.write = '1') then
				v_write_address              := to_integer(unsigned(avalon_mm_dcom_i.address));
				avalon_mm_dcom_o.waitrequest <= '0';
				p_writedata(v_write_address);
			end if;
		end if;
	end process p_avalon_mm_dcom_write;

end architecture RTL;
