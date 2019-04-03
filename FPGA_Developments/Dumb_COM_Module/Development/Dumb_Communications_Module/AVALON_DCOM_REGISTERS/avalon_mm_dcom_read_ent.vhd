library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_dcom_pkg.all;
use work.avalon_mm_dcom_registers_pkg.all;

entity avalon_mm_dcom_read_ent is
	port(
		clk_i                  : in  std_logic;
		rst_i                  : in  std_logic;
		avalon_mm_dcom_i       : in  t_avalon_mm_dcom_read_in;
		dcom_write_registers_i : in  t_dcom_write_registers;
		dcom_read_registers_i  : in  t_dcom_read_registers;
		avalon_mm_dcom_o       : out t_avalon_mm_dcom_read_out
	);
end entity avalon_mm_dcom_read_ent;

architecture RTL of avalon_mm_dcom_read_ent is

begin

	p_avalon_mm_dcom_read : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			null;
		end procedure p_reset_registers;

		procedure p_flags_hold is
		begin
			null;
		end procedure p_flags_hold;

		procedure p_readdata(read_address_i : t_avalon_mm_dcom_address) is
		begin
			-- Registers Data Read
			case (read_address_i) is
				-- Case for access to all registers address

				-- dcom registers
				when (x"00") =>
					avalon_mm_dcom_o.readdata(0)            <= dcom_write_registers_i.spw_link_config_reg.spw_lnkcfg_disconnect;
					avalon_mm_dcom_o.readdata(1)            <= dcom_write_registers_i.spw_link_config_reg.spw_lnkcfg_linkstart;
					avalon_mm_dcom_o.readdata(2)            <= dcom_write_registers_i.spw_link_config_reg.spw_lnkcfg_autostart;
					avalon_mm_dcom_o.readdata(7 downto 3)   <= (others => '0');
					avalon_mm_dcom_o.readdata(8)            <= dcom_read_registers_i.spw_link_status_reg.spw_link_running;
					avalon_mm_dcom_o.readdata(9)            <= dcom_read_registers_i.spw_link_status_reg.spw_link_connecting;
					avalon_mm_dcom_o.readdata(10)           <= dcom_read_registers_i.spw_link_status_reg.spw_link_started;
					avalon_mm_dcom_o.readdata(15 downto 11) <= (others => '0');
					avalon_mm_dcom_o.readdata(16)           <= dcom_read_registers_i.spw_link_status_reg.spw_err_disconnect;
					avalon_mm_dcom_o.readdata(17)           <= dcom_read_registers_i.spw_link_status_reg.spw_err_parity;
					avalon_mm_dcom_o.readdata(18)           <= dcom_read_registers_i.spw_link_status_reg.spw_err_escape;
					avalon_mm_dcom_o.readdata(19)           <= dcom_read_registers_i.spw_link_status_reg.spw_err_credit;
					avalon_mm_dcom_o.readdata(23 downto 20) <= (others => '0');
					avalon_mm_dcom_o.readdata(31 downto 24) <= dcom_write_registers_i.spw_link_config_reg.spw_lnkcfg_txdivcnt;
				when (x"01") =>
					avalon_mm_dcom_o.readdata(5 downto 0)   <= dcom_write_registers_i.spw_timecode_tx_rxctrl_reg.timecode_tx_time;
					avalon_mm_dcom_o.readdata(7 downto 6)   <= dcom_write_registers_i.spw_timecode_tx_rxctrl_reg.timecode_tx_control;
					avalon_mm_dcom_o.readdata(8)            <= dcom_write_registers_i.spw_timecode_tx_rxctrl_reg.timecode_tx_send;
					avalon_mm_dcom_o.readdata(15 downto 9)  <= (others => '0');
					avalon_mm_dcom_o.readdata(21 downto 16) <= dcom_read_registers_i.spw_timecode_rx_reg.timecode_rx_time;
					avalon_mm_dcom_o.readdata(23 downto 22) <= dcom_read_registers_i.spw_timecode_rx_reg.timecode_rx_control;
					avalon_mm_dcom_o.readdata(24)           <= dcom_read_registers_i.spw_timecode_rx_reg.timecode_rx_received;
					avalon_mm_dcom_o.readdata(31 downto 25) <= (others => '0');
				when (x"02") =>
					avalon_mm_dcom_o.readdata(15 downto 0)  <= dcom_read_registers_i.data_buffers_status_reg.data_buffer_used;
					avalon_mm_dcom_o.readdata(16)           <= dcom_read_registers_i.data_buffers_status_reg.data_buffer_empty;
					avalon_mm_dcom_o.readdata(17)           <= dcom_read_registers_i.data_buffers_status_reg.data_buffer_full;
					avalon_mm_dcom_o.readdata(31 downto 18) <= (others => '0');
				when (x"03") =>
					avalon_mm_dcom_o.readdata(0)           <= dcom_write_registers_i.data_controller_config_reg.send_eop;
					avalon_mm_dcom_o.readdata(1)           <= dcom_write_registers_i.data_controller_config_reg.send_eep;
					avalon_mm_dcom_o.readdata(31 downto 2) <= (others => '0');
				when (x"04") =>
					avalon_mm_dcom_o.readdata(0)           <= dcom_write_registers_i.data_scheduler_timer_config_reg.timer_start_on_sync;
					avalon_mm_dcom_o.readdata(31 downto 1) <= (others => '0');
				when (x"05") =>
					avalon_mm_dcom_o.readdata(31 downto 0) <= dcom_write_registers_i.data_scheduler_timer_clkdiv_reg.timer_clk_div;
				when (x"06") =>
					avalon_mm_dcom_o.readdata(0)           <= dcom_read_registers_i.data_scheduler_timer_status_reg.timer_stopped;
					avalon_mm_dcom_o.readdata(1)           <= dcom_read_registers_i.data_scheduler_timer_status_reg.timer_started;
					avalon_mm_dcom_o.readdata(2)           <= dcom_read_registers_i.data_scheduler_timer_status_reg.timer_running;
					avalon_mm_dcom_o.readdata(3)           <= dcom_read_registers_i.data_scheduler_timer_status_reg.timer_cleared;
					avalon_mm_dcom_o.readdata(31 downto 4) <= (others => '0');
				when (x"07") =>
					avalon_mm_dcom_o.readdata(31 downto 0) <= dcom_read_registers_i.data_scheduler_timer_time_out_reg.timer_time_out;
				when (x"08") =>
					avalon_mm_dcom_o.readdata(0)           <= dcom_write_registers_i.data_scheduler_timer_control_reg.timer_start;
					avalon_mm_dcom_o.readdata(1)           <= dcom_write_registers_i.data_scheduler_timer_control_reg.timer_run;
					avalon_mm_dcom_o.readdata(2)           <= dcom_write_registers_i.data_scheduler_timer_control_reg.timer_stop;
					avalon_mm_dcom_o.readdata(3)           <= dcom_write_registers_i.data_scheduler_timer_control_reg.timer_clear;
					avalon_mm_dcom_o.readdata(31 downto 4) <= (others => '0');
				when (x"09") =>
					avalon_mm_dcom_o.readdata(0)           <= dcom_write_registers_i.dcom_irq_control_reg.dcom_tx_end_en;
					avalon_mm_dcom_o.readdata(1)           <= dcom_write_registers_i.dcom_irq_control_reg.dcom_tx_begin_en;
					avalon_mm_dcom_o.readdata(7 downto 2)  <= (others => '0');
					avalon_mm_dcom_o.readdata(8)           <= dcom_write_registers_i.dcom_irq_control_reg.dcom_global_irq_en;
					avalon_mm_dcom_o.readdata(31 downto 9) <= (others => '0');
				when (x"0A") =>
					avalon_mm_dcom_o.readdata(0)           <= dcom_read_registers_i.dcom_irq_flags_reg.dcom_tx_end_flag;
					avalon_mm_dcom_o.readdata(1)           <= dcom_read_registers_i.dcom_irq_flags_reg.dcom_tx_begin_flag;
					avalon_mm_dcom_o.readdata(31 downto 2) <= (others => '0');
				when (x"0B") =>
					avalon_mm_dcom_o.readdata(0)           <= dcom_write_registers_i.dcom_irq_flags_clear_reg.dcom_tx_end_flag_clear;
					avalon_mm_dcom_o.readdata(1)           <= dcom_write_registers_i.dcom_irq_flags_clear_reg.dcom_tx_begin_flag_clear;
					avalon_mm_dcom_o.readdata(31 downto 2) <= (others => '0');
				when others =>
					avalon_mm_dcom_o.readdata <= (others => '0');

			end case;
		end procedure p_readdata;

		variable v_read_address : t_avalon_mm_dcom_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_dcom_o.readdata    <= (others => '0');
			avalon_mm_dcom_o.waitrequest <= '1';
			v_read_address               := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			avalon_mm_dcom_o.readdata    <= (others => '0');
			avalon_mm_dcom_o.waitrequest <= '1';
			p_flags_hold;
			if (avalon_mm_dcom_i.read = '1') then
				v_read_address               := to_integer(unsigned(avalon_mm_dcom_i.address));
				avalon_mm_dcom_o.waitrequest <= '0';
				p_readdata(v_read_address);
			end if;
		end if;
	end process p_avalon_mm_dcom_read;

end architecture RTL;
