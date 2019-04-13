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
		avalon_mm_dcom_o       : out t_avalon_mm_dcom_read_out;
		avalon_mm_dcom_dump_i  : in  t_dcom_avs_dump_arr
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
				when (16#00#) =>
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
				when (16#01#) =>
					avalon_mm_dcom_o.readdata(5 downto 0)   <= dcom_write_registers_i.spw_timecode_tx_rxctrl_reg.timecode_tx_time;
					avalon_mm_dcom_o.readdata(7 downto 6)   <= dcom_write_registers_i.spw_timecode_tx_rxctrl_reg.timecode_tx_control;
					avalon_mm_dcom_o.readdata(8)            <= dcom_write_registers_i.spw_timecode_tx_rxctrl_reg.timecode_tx_send;
					avalon_mm_dcom_o.readdata(15 downto 9)  <= (others => '0');
					avalon_mm_dcom_o.readdata(21 downto 16) <= dcom_read_registers_i.spw_timecode_rx_reg.timecode_rx_time;
					avalon_mm_dcom_o.readdata(23 downto 22) <= dcom_read_registers_i.spw_timecode_rx_reg.timecode_rx_control;
					avalon_mm_dcom_o.readdata(24)           <= dcom_read_registers_i.spw_timecode_rx_reg.timecode_rx_received;
					avalon_mm_dcom_o.readdata(31 downto 25) <= (others => '0');
				when (16#02#) =>
					avalon_mm_dcom_o.readdata(10 downto 0)  <= dcom_read_registers_i.data_buffers_status_reg.data_buffer_used;
					avalon_mm_dcom_o.readdata(15 downto 11) <= (others => '0');
					avalon_mm_dcom_o.readdata(16)           <= dcom_read_registers_i.data_buffers_status_reg.data_buffer_empty;
					avalon_mm_dcom_o.readdata(17)           <= dcom_read_registers_i.data_buffers_status_reg.data_buffer_full;
					avalon_mm_dcom_o.readdata(31 downto 18) <= (others => '0');
				when (16#03#) =>
					avalon_mm_dcom_o.readdata(0)           <= dcom_write_registers_i.data_controller_config_reg.send_eop;
					avalon_mm_dcom_o.readdata(1)           <= dcom_write_registers_i.data_controller_config_reg.send_eep;
					avalon_mm_dcom_o.readdata(31 downto 2) <= (others => '0');
				when (16#04#) =>
					avalon_mm_dcom_o.readdata(0)           <= dcom_write_registers_i.data_scheduler_timer_config_reg.timer_start_on_sync;
					avalon_mm_dcom_o.readdata(31 downto 1) <= (others => '0');
				when (16#05#) =>
					avalon_mm_dcom_o.readdata(31 downto 0) <= dcom_write_registers_i.data_scheduler_timer_clkdiv_reg.timer_clk_div;
				when (16#06#) =>
					avalon_mm_dcom_o.readdata(0)           <= dcom_read_registers_i.data_scheduler_timer_status_reg.timer_stopped;
					avalon_mm_dcom_o.readdata(1)           <= dcom_read_registers_i.data_scheduler_timer_status_reg.timer_started;
					avalon_mm_dcom_o.readdata(2)           <= dcom_read_registers_i.data_scheduler_timer_status_reg.timer_running;
					avalon_mm_dcom_o.readdata(3)           <= dcom_read_registers_i.data_scheduler_timer_status_reg.timer_cleared;
					avalon_mm_dcom_o.readdata(31 downto 4) <= (others => '0');
				when (16#07#) =>
					avalon_mm_dcom_o.readdata(31 downto 0) <= dcom_read_registers_i.data_scheduler_timer_time_out_reg.timer_time_out;
				when (16#08#) =>
					avalon_mm_dcom_o.readdata(0)           <= dcom_write_registers_i.data_scheduler_timer_control_reg.timer_start;
					avalon_mm_dcom_o.readdata(1)           <= dcom_write_registers_i.data_scheduler_timer_control_reg.timer_run;
					avalon_mm_dcom_o.readdata(2)           <= dcom_write_registers_i.data_scheduler_timer_control_reg.timer_stop;
					avalon_mm_dcom_o.readdata(3)           <= dcom_write_registers_i.data_scheduler_timer_control_reg.timer_clear;
					avalon_mm_dcom_o.readdata(31 downto 4) <= (others => '0');
				when (16#09#) =>
					avalon_mm_dcom_o.readdata(0)           <= dcom_write_registers_i.dcom_irq_control_reg.dcom_tx_end_en;
					avalon_mm_dcom_o.readdata(1)           <= dcom_write_registers_i.dcom_irq_control_reg.dcom_tx_begin_en;
					avalon_mm_dcom_o.readdata(7 downto 2)  <= (others => '0');
					avalon_mm_dcom_o.readdata(8)           <= dcom_write_registers_i.dcom_irq_control_reg.dcom_global_irq_en;
					avalon_mm_dcom_o.readdata(31 downto 9) <= (others => '0');
				when (16#0A#) =>
					avalon_mm_dcom_o.readdata(0)           <= dcom_read_registers_i.dcom_irq_flags_reg.dcom_tx_end_flag;
					avalon_mm_dcom_o.readdata(1)           <= dcom_read_registers_i.dcom_irq_flags_reg.dcom_tx_begin_flag;
					avalon_mm_dcom_o.readdata(31 downto 2) <= (others => '0');
				when (16#0B#) =>
					avalon_mm_dcom_o.readdata(0)           <= dcom_write_registers_i.dcom_irq_flags_clear_reg.dcom_tx_end_flag_clear;
					avalon_mm_dcom_o.readdata(1)           <= dcom_write_registers_i.dcom_irq_flags_clear_reg.dcom_tx_begin_flag_clear;
					avalon_mm_dcom_o.readdata(31 downto 2) <= (others => '0');
				--
				when (15) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(0).avs_writedata(31 downto 0);
				when (16) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(0).avs_writedata(63 downto 32);
				when (17) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(0).avs_byteenable;
				when (18) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(1).avs_writedata(31 downto 0);
				when (19) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(1).avs_writedata(63 downto 32);
				when (20) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(1).avs_byteenable;
				when (21) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(2).avs_writedata(31 downto 0);
				when (22) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(2).avs_writedata(63 downto 32);
				when (23) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(2).avs_byteenable;
				when (24) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(3).avs_writedata(31 downto 0);
				when (25) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(3).avs_writedata(63 downto 32);
				when (26) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(3).avs_byteenable;
				when (27) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(4).avs_writedata(31 downto 0);
				when (28) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(4).avs_writedata(63 downto 32);
				when (29) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(4).avs_byteenable;
				when (30) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(5).avs_writedata(31 downto 0);
				when (31) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(5).avs_writedata(63 downto 32);
				when (32) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(5).avs_byteenable;
				when (33) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(6).avs_writedata(31 downto 0);
				when (34) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(6).avs_writedata(63 downto 32);
				when (35) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(6).avs_byteenable;
				when (36) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(7).avs_writedata(31 downto 0);
				when (37) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(7).avs_writedata(63 downto 32);
				when (38) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(7).avs_byteenable;
				when (39) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(8).avs_writedata(31 downto 0);
				when (40) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(8).avs_writedata(63 downto 32);
				when (41) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(8).avs_byteenable;
				when (42) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(9).avs_writedata(31 downto 0);
				when (43) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(9).avs_writedata(63 downto 32);
				when (44) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(9).avs_byteenable;
				when (45) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(10).avs_writedata(31 downto 0);
				when (46) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(10).avs_writedata(63 downto 32);
				when (47) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(10).avs_byteenable;
				when (48) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(11).avs_writedata(31 downto 0);
				when (49) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(11).avs_writedata(63 downto 32);
				when (50) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(11).avs_byteenable;
				when (51) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(12).avs_writedata(31 downto 0);
				when (52) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(12).avs_writedata(63 downto 32);
				when (53) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(12).avs_byteenable;
				when (54) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(13).avs_writedata(31 downto 0);
				when (55) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(13).avs_writedata(63 downto 32);
				when (56) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(13).avs_byteenable;
				when (57) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(14).avs_writedata(31 downto 0);
				when (58) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(14).avs_writedata(63 downto 32);
				when (59) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(14).avs_byteenable;
				when (60) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(15).avs_writedata(31 downto 0);
				when (61) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(15).avs_writedata(63 downto 32);
				when (62) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(15).avs_byteenable;
				when (63) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(16).avs_writedata(31 downto 0);
				when (64) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(16).avs_writedata(63 downto 32);
				when (65) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(16).avs_byteenable;
				when (66) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(17).avs_writedata(31 downto 0);
				when (67) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(17).avs_writedata(63 downto 32);
				when (68) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(17).avs_byteenable;
				when (69) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(18).avs_writedata(31 downto 0);
				when (70) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(18).avs_writedata(63 downto 32);
				when (71) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(18).avs_byteenable;
				when (72) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(19).avs_writedata(31 downto 0);
				when (73) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(19).avs_writedata(63 downto 32);
				when (74) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(19).avs_byteenable;
				when (75) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(20).avs_writedata(31 downto 0);
				when (76) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(20).avs_writedata(63 downto 32);
				when (77) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(20).avs_byteenable;
				when (78) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(21).avs_writedata(31 downto 0);
				when (79) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(21).avs_writedata(63 downto 32);
				when (80) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(21).avs_byteenable;
				when (81) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(22).avs_writedata(31 downto 0);
				when (82) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(22).avs_writedata(63 downto 32);
				when (83) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(22).avs_byteenable;
				when (84) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(23).avs_writedata(31 downto 0);
				when (85) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(23).avs_writedata(63 downto 32);
				when (86) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(23).avs_byteenable;
				when (87) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(24).avs_writedata(31 downto 0);
				when (88) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(24).avs_writedata(63 downto 32);
				when (89) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(24).avs_byteenable;
				when (90) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(25).avs_writedata(31 downto 0);
				when (91) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(25).avs_writedata(63 downto 32);
				when (92) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(25).avs_byteenable;
				when (93) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(26).avs_writedata(31 downto 0);
				when (94) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(26).avs_writedata(63 downto 32);
				when (95) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(26).avs_byteenable;
				when (96) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(27).avs_writedata(31 downto 0);
				when (97) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(27).avs_writedata(63 downto 32);
				when (98) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(27).avs_byteenable;
				when (99) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(28).avs_writedata(31 downto 0);
				when (100) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(28).avs_writedata(63 downto 32);
				when (101) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(28).avs_byteenable;
				when (102) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(29).avs_writedata(31 downto 0);
				when (103) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(29).avs_writedata(63 downto 32);
				when (104) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(29).avs_byteenable;
				when (105) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(30).avs_writedata(31 downto 0);
				when (106) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(30).avs_writedata(63 downto 32);
				when (107) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(30).avs_byteenable;
				when (108) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(31).avs_writedata(31 downto 0);
				when (109) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(31).avs_writedata(63 downto 32);
				when (110) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(31).avs_byteenable;
				when (111) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(32).avs_writedata(31 downto 0);
				when (112) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(32).avs_writedata(63 downto 32);
				when (113) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(32).avs_byteenable;
				when (114) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(33).avs_writedata(31 downto 0);
				when (115) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(33).avs_writedata(63 downto 32);
				when (116) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(33).avs_byteenable;
				when (117) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(34).avs_writedata(31 downto 0);
				when (118) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(34).avs_writedata(63 downto 32);
				when (119) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(34).avs_byteenable;
				when (120) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(35).avs_writedata(31 downto 0);
				when (121) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(35).avs_writedata(63 downto 32);
				when (122) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(35).avs_byteenable;
				when (123) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(36).avs_writedata(31 downto 0);
				when (124) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(36).avs_writedata(63 downto 32);
				when (125) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(36).avs_byteenable;
				when (126) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(37).avs_writedata(31 downto 0);
				when (127) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(37).avs_writedata(63 downto 32);
				when (128) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(37).avs_byteenable;
				when (129) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(38).avs_writedata(31 downto 0);
				when (130) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(38).avs_writedata(63 downto 32);
				when (131) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(38).avs_byteenable;
				when (132) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(39).avs_writedata(31 downto 0);
				when (133) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(39).avs_writedata(63 downto 32);
				when (134) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(39).avs_byteenable;
				when (135) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(40).avs_writedata(31 downto 0);
				when (136) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(40).avs_writedata(63 downto 32);
				when (137) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(40).avs_byteenable;
				when (138) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(41).avs_writedata(31 downto 0);
				when (139) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(41).avs_writedata(63 downto 32);
				when (140) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(41).avs_byteenable;
				when (141) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(42).avs_writedata(31 downto 0);
				when (142) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(42).avs_writedata(63 downto 32);
				when (143) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(42).avs_byteenable;
				when (144) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(43).avs_writedata(31 downto 0);
				when (145) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(43).avs_writedata(63 downto 32);
				when (146) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(43).avs_byteenable;
				when (147) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(44).avs_writedata(31 downto 0);
				when (148) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(44).avs_writedata(63 downto 32);
				when (149) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(44).avs_byteenable;
				when (150) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(45).avs_writedata(31 downto 0);
				when (151) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(45).avs_writedata(63 downto 32);
				when (152) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(45).avs_byteenable;
				when (153) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(46).avs_writedata(31 downto 0);
				when (154) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(46).avs_writedata(63 downto 32);
				when (155) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(46).avs_byteenable;
				when (156) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(47).avs_writedata(31 downto 0);
				when (157) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(47).avs_writedata(63 downto 32);
				when (158) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(47).avs_byteenable;
				when (159) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(48).avs_writedata(31 downto 0);
				when (160) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(48).avs_writedata(63 downto 32);
				when (161) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(48).avs_byteenable;
				when (162) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(49).avs_writedata(31 downto 0);
				when (163) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(49).avs_writedata(63 downto 32);
				when (164) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(49).avs_byteenable;
				when (165) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(50).avs_writedata(31 downto 0);
				when (166) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(50).avs_writedata(63 downto 32);
				when (167) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(50).avs_byteenable;
				when (168) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(51).avs_writedata(31 downto 0);
				when (169) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(51).avs_writedata(63 downto 32);
				when (170) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(51).avs_byteenable;
				when (171) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(52).avs_writedata(31 downto 0);
				when (172) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(52).avs_writedata(63 downto 32);
				when (173) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(52).avs_byteenable;
				when (174) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(53).avs_writedata(31 downto 0);
				when (175) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(53).avs_writedata(63 downto 32);
				when (176) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(53).avs_byteenable;
				when (177) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(54).avs_writedata(31 downto 0);
				when (178) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(54).avs_writedata(63 downto 32);
				when (179) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(54).avs_byteenable;
				when (180) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(55).avs_writedata(31 downto 0);
				when (181) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(55).avs_writedata(63 downto 32);
				when (182) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(55).avs_byteenable;
				when (183) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(56).avs_writedata(31 downto 0);
				when (184) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(56).avs_writedata(63 downto 32);
				when (185) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(56).avs_byteenable;
				when (186) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(57).avs_writedata(31 downto 0);
				when (187) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(57).avs_writedata(63 downto 32);
				when (188) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(57).avs_byteenable;
				when (189) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(58).avs_writedata(31 downto 0);
				when (190) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(58).avs_writedata(63 downto 32);
				when (191) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(58).avs_byteenable;
				when (192) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(59).avs_writedata(31 downto 0);
				when (193) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(59).avs_writedata(63 downto 32);
				when (194) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(59).avs_byteenable;
				when (195) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(60).avs_writedata(31 downto 0);
				when (196) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(60).avs_writedata(63 downto 32);
				when (197) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(60).avs_byteenable;
				when (198) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(61).avs_writedata(31 downto 0);
				when (199) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(61).avs_writedata(63 downto 32);
				when (200) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(61).avs_byteenable;
				when (201) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(62).avs_writedata(31 downto 0);
				when (202) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(62).avs_writedata(63 downto 32);
				when (203) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(62).avs_byteenable;
				when (204) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(63).avs_writedata(31 downto 0);
				when (205) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(63).avs_writedata(63 downto 32);
				when (206) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(63).avs_byteenable;
				when (207) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(64).avs_writedata(31 downto 0);
				when (208) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(64).avs_writedata(63 downto 32);
				when (209) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(64).avs_byteenable;
				when (210) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(65).avs_writedata(31 downto 0);
				when (211) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(65).avs_writedata(63 downto 32);
				when (212) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(65).avs_byteenable;
				when (213) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(66).avs_writedata(31 downto 0);
				when (214) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(66).avs_writedata(63 downto 32);
				when (215) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(66).avs_byteenable;
				when (216) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(67).avs_writedata(31 downto 0);
				when (217) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(67).avs_writedata(63 downto 32);
				when (218) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(67).avs_byteenable;
				when (219) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(68).avs_writedata(31 downto 0);
				when (220) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(68).avs_writedata(63 downto 32);
				when (221) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(68).avs_byteenable;
				when (222) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(69).avs_writedata(31 downto 0);
				when (223) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(69).avs_writedata(63 downto 32);
				when (224) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(69).avs_byteenable;
				when (225) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(70).avs_writedata(31 downto 0);
				when (226) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(70).avs_writedata(63 downto 32);
				when (227) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(70).avs_byteenable;
				when (228) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(71).avs_writedata(31 downto 0);
				when (229) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(71).avs_writedata(63 downto 32);
				when (230) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(71).avs_byteenable;
				when (231) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(72).avs_writedata(31 downto 0);
				when (232) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(72).avs_writedata(63 downto 32);
				when (233) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(72).avs_byteenable;
				when (234) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(73).avs_writedata(31 downto 0);
				when (235) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(73).avs_writedata(63 downto 32);
				when (236) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(73).avs_byteenable;
				when (237) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(74).avs_writedata(31 downto 0);
				when (238) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(74).avs_writedata(63 downto 32);
				when (239) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(74).avs_byteenable;
				when (240) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(75).avs_writedata(31 downto 0);
				when (241) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(75).avs_writedata(63 downto 32);
				when (242) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(75).avs_byteenable;
				when (243) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(76).avs_writedata(31 downto 0);
				when (244) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(76).avs_writedata(63 downto 32);
				when (245) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(76).avs_byteenable;
				when (246) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(77).avs_writedata(31 downto 0);
				when (247) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(77).avs_writedata(63 downto 32);
				when (248) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(77).avs_byteenable;
				when (249) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(78).avs_writedata(31 downto 0);
				when (250) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(78).avs_writedata(63 downto 32);
				when (251) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(78).avs_byteenable;
				when (252) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(79).avs_writedata(31 downto 0);
				when (253) =>
					avalon_mm_dcom_o.readdata <= avalon_mm_dcom_dump_i(79).avs_writedata(63 downto 32);
				when (254) =>
					avalon_mm_dcom_o.readdata(31 downto 8) <= (others => '0');
					avalon_mm_dcom_o.readdata(7 downto 0)  <= avalon_mm_dcom_dump_i(79).avs_byteenable;
				--
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
