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
		procedure p_readdata(read_address_i : t_avalon_mm_dcom_address) is
		begin

			-- Registers Data Read
			case (read_address_i) is
				-- Case for access to all registers address

				when (16#00#) =>
					-- Dcom Device Address Register : Dcom Device Base Address
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(7 downto 0) <= dcom_write_registers_i.dcom_dev_addr_reg.dcom_dev_base_addr(7 downto 0);
					end if;
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						avalon_mm_dcom_o.readdata(15 downto 8) <= dcom_write_registers_i.dcom_dev_addr_reg.dcom_dev_base_addr(15 downto 8);
					end if;
					if (avalon_mm_dcom_i.byteenable(2) = '1') then
						avalon_mm_dcom_o.readdata(23 downto 16) <= dcom_write_registers_i.dcom_dev_addr_reg.dcom_dev_base_addr(23 downto 16);
					end if;
					if (avalon_mm_dcom_i.byteenable(3) = '1') then
						avalon_mm_dcom_o.readdata(31 downto 24) <= dcom_write_registers_i.dcom_dev_addr_reg.dcom_dev_base_addr(31 downto 24);
					end if;

				when (16#01#) =>
					-- Dcom IRQ Control Register : Dcom Global IRQ Enable
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_write_registers_i.dcom_irq_control_reg.dcom_global_irq_en;
					end if;

				when (16#02#) =>
					-- SpaceWire Device Address Register : SpaceWire Device Base Address
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(7 downto 0) <= dcom_write_registers_i.spw_dev_addr_reg.spw_dev_base_addr(7 downto 0);
					end if;
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						avalon_mm_dcom_o.readdata(15 downto 8) <= dcom_write_registers_i.spw_dev_addr_reg.spw_dev_base_addr(15 downto 8);
					end if;
					if (avalon_mm_dcom_i.byteenable(2) = '1') then
						avalon_mm_dcom_o.readdata(23 downto 16) <= dcom_write_registers_i.spw_dev_addr_reg.spw_dev_base_addr(23 downto 16);
					end if;
					if (avalon_mm_dcom_i.byteenable(3) = '1') then
						avalon_mm_dcom_o.readdata(31 downto 24) <= dcom_write_registers_i.spw_dev_addr_reg.spw_dev_base_addr(31 downto 24);
					end if;

				when (16#03#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config Disconnect
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_write_registers_i.spw_link_config_reg.spw_lnkcfg_disconnect;
					end if;

				when (16#04#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config Linkstart
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_write_registers_i.spw_link_config_reg.spw_lnkcfg_linkstart;
					end if;

				when (16#05#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config Autostart
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_write_registers_i.spw_link_config_reg.spw_lnkcfg_autostart;
					end if;

				when (16#06#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config TxDivCnt
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(7 downto 0) <= dcom_write_registers_i.spw_link_config_reg.spw_lnkcfg_txdivcnt;
					end if;

				when (16#07#) =>
					-- SpaceWire Link Status Register : SpaceWire Link Running
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.spw_link_status_reg.spw_link_running;
					end if;

				when (16#08#) =>
					-- SpaceWire Link Status Register : SpaceWire Link Connecting
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.spw_link_status_reg.spw_link_connecting;
					end if;

				when (16#09#) =>
					-- SpaceWire Link Status Register : SpaceWire Link Started
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.spw_link_status_reg.spw_link_started;
					end if;

				when (16#0A#) =>
					-- SpaceWire Link Status Register : SpaceWire Error Disconnect
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.spw_link_status_reg.spw_err_disconnect;
					end if;

				when (16#0B#) =>
					-- SpaceWire Link Status Register : SpaceWire Error Parity
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.spw_link_status_reg.spw_err_parity;
					end if;

				when (16#0C#) =>
					-- SpaceWire Link Status Register : SpaceWire Error Escape
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.spw_link_status_reg.spw_err_escape;
					end if;

				when (16#0D#) =>
					-- SpaceWire Link Status Register : SpaceWire Error Credit
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.spw_link_status_reg.spw_err_credit;
					end if;

				when (16#0E#) =>
					-- SpaceWire Timecode Control Register : SpaceWire Timecode Tx Time
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(5 downto 0) <= dcom_write_registers_i.spw_timecode_control_reg.timecode_tx_time;
					end if;
					-- SpaceWire Timecode Control Register : SpaceWire Timecode Tx Control
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						avalon_mm_dcom_o.readdata(9 downto 8) <= dcom_write_registers_i.spw_timecode_control_reg.timecode_tx_control;
					end if;

				when (16#0F#) =>
					-- SpaceWire Timecode Control Register : SpaceWire Timecode Tx Send
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_write_registers_i.spw_timecode_control_reg.timecode_tx_send;
					end if;

				when (16#10#) =>
					-- SpaceWire Timecode Control Register : SpaceWire Timecode Rx Received Clear
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_write_registers_i.spw_timecode_control_reg.timecode_rx_received_clear;
					end if;

				when (16#11#) =>
					-- SpaceWire Timecode Status Register : SpaceWire Timecode Rx Time
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(5 downto 0) <= dcom_read_registers_i.spw_timecode_status_reg.timecode_rx_time;
					end if;
					-- SpaceWire Timecode Status Register : SpaceWire Timecode Rx Control
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						avalon_mm_dcom_o.readdata(9 downto 8) <= dcom_read_registers_i.spw_timecode_status_reg.timecode_rx_control;
					end if;

				when (16#12#) =>
					-- SpaceWire Timecode Status Register : SpaceWire Timecode Rx Received
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.spw_timecode_status_reg.timecode_rx_received;
					end if;

				when (16#13#) =>
					-- Data Scheduler Device Address Register : Data Scheduler Device Base Address
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(7 downto 0) <= dcom_write_registers_i.data_scheduler_dev_addr_reg.data_scheduler_dev_base_addr(7 downto 0);
					end if;
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						avalon_mm_dcom_o.readdata(15 downto 8) <= dcom_write_registers_i.data_scheduler_dev_addr_reg.data_scheduler_dev_base_addr(15 downto 8);
					end if;
					if (avalon_mm_dcom_i.byteenable(2) = '1') then
						avalon_mm_dcom_o.readdata(23 downto 16) <= dcom_write_registers_i.data_scheduler_dev_addr_reg.data_scheduler_dev_base_addr(23 downto 16);
					end if;
					if (avalon_mm_dcom_i.byteenable(3) = '1') then
						avalon_mm_dcom_o.readdata(31 downto 24) <= dcom_write_registers_i.data_scheduler_dev_addr_reg.data_scheduler_dev_base_addr(31 downto 24);
					end if;

				when (16#14#) =>
					-- Data Scheduler Timer Control Register : Data Scheduler Timer Start
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_write_registers_i.data_scheduler_tmr_control_reg.timer_start;
					end if;

				when (16#15#) =>
					-- Data Scheduler Timer Control Register : Data Scheduler Timer Run
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_write_registers_i.data_scheduler_tmr_control_reg.timer_run;
					end if;

				when (16#16#) =>
					-- Data Scheduler Timer Control Register : Data Scheduler Timer Stop
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_write_registers_i.data_scheduler_tmr_control_reg.timer_stop;
					end if;

				when (16#17#) =>
					-- Data Scheduler Timer Control Register : Data Scheduler Timer Clear
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_write_registers_i.data_scheduler_tmr_control_reg.timer_clear;
					end if;

				when (16#18#) =>
					-- Data Scheduler Timer Config Register : Data Scheduler Timer Start on Sync
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_write_registers_i.data_scheduler_tmr_config_reg.timer_start_on_sync;
					end if;

				when (16#19#) =>
					-- Data Scheduler Timer Config Register : Data Scheduler Timer Clock Div
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(7 downto 0) <= dcom_write_registers_i.data_scheduler_tmr_config_reg.timer_clk_div(7 downto 0);
					end if;
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						avalon_mm_dcom_o.readdata(15 downto 8) <= dcom_write_registers_i.data_scheduler_tmr_config_reg.timer_clk_div(15 downto 8);
					end if;
					if (avalon_mm_dcom_i.byteenable(2) = '1') then
						avalon_mm_dcom_o.readdata(23 downto 16) <= dcom_write_registers_i.data_scheduler_tmr_config_reg.timer_clk_div(23 downto 16);
					end if;
					if (avalon_mm_dcom_i.byteenable(3) = '1') then
						avalon_mm_dcom_o.readdata(31 downto 24) <= dcom_write_registers_i.data_scheduler_tmr_config_reg.timer_clk_div(31 downto 24);
					end if;

				when (16#1A#) =>
					-- Data Scheduler Timer Config Register : Data Scheduler Timer Start Time
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(7 downto 0) <= dcom_write_registers_i.data_scheduler_tmr_config_reg.timer_start_time(7 downto 0);
					end if;
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						avalon_mm_dcom_o.readdata(15 downto 8) <= dcom_write_registers_i.data_scheduler_tmr_config_reg.timer_start_time(15 downto 8);
					end if;
					if (avalon_mm_dcom_i.byteenable(2) = '1') then
						avalon_mm_dcom_o.readdata(23 downto 16) <= dcom_write_registers_i.data_scheduler_tmr_config_reg.timer_start_time(23 downto 16);
					end if;
					if (avalon_mm_dcom_i.byteenable(3) = '1') then
						avalon_mm_dcom_o.readdata(31 downto 24) <= dcom_write_registers_i.data_scheduler_tmr_config_reg.timer_start_time(31 downto 24);
					end if;

				when (16#1B#) =>
					-- Data Scheduler Timer Status Register : Data Scheduler Timer Stopped
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.data_scheduler_tmr_status_reg.timer_stopped;
					end if;

				when (16#1C#) =>
					-- Data Scheduler Timer Status Register : Data Scheduler Timer Started
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.data_scheduler_tmr_status_reg.timer_started;
					end if;

				when (16#1D#) =>
					-- Data Scheduler Timer Status Register : Data Scheduler Timer Running
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.data_scheduler_tmr_status_reg.timer_running;
					end if;

				when (16#1E#) =>
					-- Data Scheduler Timer Status Register : Data Scheduler Timer Cleared
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.data_scheduler_tmr_status_reg.timer_cleared;
					end if;

				when (16#1F#) =>
					-- Data Scheduler Timer Status Register : Data Scheduler Timer Time
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(7 downto 0) <= dcom_read_registers_i.data_scheduler_tmr_status_reg.timer_current_time(7 downto 0);
					end if;
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						avalon_mm_dcom_o.readdata(15 downto 8) <= dcom_read_registers_i.data_scheduler_tmr_status_reg.timer_current_time(15 downto 8);
					end if;
					if (avalon_mm_dcom_i.byteenable(2) = '1') then
						avalon_mm_dcom_o.readdata(23 downto 16) <= dcom_read_registers_i.data_scheduler_tmr_status_reg.timer_current_time(23 downto 16);
					end if;
					if (avalon_mm_dcom_i.byteenable(3) = '1') then
						avalon_mm_dcom_o.readdata(31 downto 24) <= dcom_read_registers_i.data_scheduler_tmr_status_reg.timer_current_time(31 downto 24);
					end if;

				when (16#20#) =>
					-- Data Scheduler Packet Config Register : Data Scheduler Send EOP with Packet
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_write_registers_i.data_scheduler_pkt_config_reg.send_eop;
					end if;

				when (16#21#) =>
					-- Data Scheduler Packet Config Register : Data Scheduler Send EEP with Packet
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_write_registers_i.data_scheduler_pkt_config_reg.send_eep;
					end if;

				when (16#22#) =>
					-- Data Scheduler Buffer Status Register : Data Scheduler Buffer Used [Bytes]
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(7 downto 0) <= dcom_read_registers_i.data_scheduler_buffer_status_reg.data_buffer_used(7 downto 0);
					end if;
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						avalon_mm_dcom_o.readdata(15 downto 8) <= dcom_read_registers_i.data_scheduler_buffer_status_reg.data_buffer_used(15 downto 8);
					end if;

				when (16#23#) =>
					-- Data Scheduler Buffer Status Register : Data Scheduler Buffer Empty
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.data_scheduler_buffer_status_reg.data_buffer_empty;
					end if;

				when (16#24#) =>
					-- Data Scheduler Buffer Status Register : Data Scheduler Buffer Full
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.data_scheduler_buffer_status_reg.data_buffer_full;
					end if;

				when (16#25#) =>
					-- Data Scheduler IRQ Control Register : Data Scheduler Tx End IRQ Enable
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_write_registers_i.data_scheduler_irq_control_reg.irq_tx_end_en;
					end if;

				when (16#26#) =>
					-- Data Scheduler IRQ Control Register : Data Scheduler Tx Begin IRQ Enable
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_write_registers_i.data_scheduler_irq_control_reg.irq_tx_begin_en;
					end if;

				when (16#27#) =>
					-- Data Scheduler IRQ Flags Register : Data Scheduler Tx End IRQ Flag
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.data_scheduler_irq_flags_reg.irq_tx_end_flag;
					end if;

				when (16#28#) =>
					-- Data Scheduler IRQ Flags Register : Data Scheduler Tx Begin IRQ Flag
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.data_scheduler_irq_flags_reg.irq_tx_begin_flag;
					end if;

				when (16#29#) =>
					-- Data Scheduler IRQ Flags Clear Register : Data Scheduler Tx End IRQ Flag Clear
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_write_registers_i.data_scheduler_irq_flags_clear_reg.irq_tx_end_flag_clear;
					end if;

				when (16#2A#) =>
					-- Data Scheduler IRQ Flags Clear Register : Data Scheduler Tx Begin IRQ Flag Clear
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_write_registers_i.data_scheduler_irq_flags_clear_reg.irq_tx_begin_flag_clear;
					end if;

				when (16#2B#) =>
					-- RMAP Device Address Register : RMAP Device Base Address
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(7 downto 0) <= dcom_write_registers_i.rmap_dev_addr_reg.rmap_dev_base_addr(7 downto 0);
					end if;
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						avalon_mm_dcom_o.readdata(15 downto 8) <= dcom_write_registers_i.rmap_dev_addr_reg.rmap_dev_base_addr(15 downto 8);
					end if;
					if (avalon_mm_dcom_i.byteenable(2) = '1') then
						avalon_mm_dcom_o.readdata(23 downto 16) <= dcom_write_registers_i.rmap_dev_addr_reg.rmap_dev_base_addr(23 downto 16);
					end if;
					if (avalon_mm_dcom_i.byteenable(3) = '1') then
						avalon_mm_dcom_o.readdata(31 downto 24) <= dcom_write_registers_i.rmap_dev_addr_reg.rmap_dev_base_addr(31 downto 24);
					end if;

				when (16#2C#) =>
					-- RMAP Codec Config Register : RMAP Target Logical Address
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(7 downto 0) <= dcom_write_registers_i.rmap_codec_config_reg.rmap_target_logical_addr;
					end if;
					-- RMAP Codec Config Register : RMAP Target Key
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						avalon_mm_dcom_o.readdata(15 downto 8) <= dcom_write_registers_i.rmap_codec_config_reg.rmap_target_key;
					end if;

				when (16#2D#) =>
					-- RMAP Codec Status Register : RMAP Status Command Received
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.rmap_codec_status_reg.rmap_stat_command_received;
					end if;

				when (16#2E#) =>
					-- RMAP Codec Status Register : RMAP Status Write Requested
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.rmap_codec_status_reg.rmap_stat_write_requested;
					end if;

				when (16#2F#) =>
					-- RMAP Codec Status Register : RMAP Status Write Authorized
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.rmap_codec_status_reg.rmap_stat_write_authorized;
					end if;

				when (16#30#) =>
					-- RMAP Codec Status Register : RMAP Status Read Requested
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.rmap_codec_status_reg.rmap_stat_read_requested;
					end if;

				when (16#31#) =>
					-- RMAP Codec Status Register : RMAP Status Read Authorized
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.rmap_codec_status_reg.rmap_stat_read_authorized;
					end if;

				when (16#32#) =>
					-- RMAP Codec Status Register : RMAP Status Reply Sended
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.rmap_codec_status_reg.rmap_stat_reply_sended;
					end if;

				when (16#33#) =>
					-- RMAP Codec Status Register : RMAP Status Discarded Package
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.rmap_codec_status_reg.rmap_stat_discarded_package;
					end if;

				when (16#34#) =>
					-- RMAP Codec Status Register : RMAP Error Early EOP
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.rmap_codec_status_reg.rmap_err_early_eop;
					end if;

				when (16#35#) =>
					-- RMAP Codec Status Register : RMAP Error EEP
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.rmap_codec_status_reg.rmap_err_eep;
					end if;

				when (16#36#) =>
					-- RMAP Codec Status Register : RMAP Error Header CRC
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.rmap_codec_status_reg.rmap_err_header_crc;
					end if;

				when (16#37#) =>
					-- RMAP Codec Status Register : RMAP Error Unused Packet Type
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.rmap_codec_status_reg.rmap_err_unused_packet_type;
					end if;

				when (16#38#) =>
					-- RMAP Codec Status Register : RMAP Error Invalid Command Code
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.rmap_codec_status_reg.rmap_err_invalid_command_code;
					end if;

				when (16#39#) =>
					-- RMAP Codec Status Register : RMAP Error Too Much Data
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.rmap_codec_status_reg.rmap_err_too_much_data;
					end if;

				when (16#3A#) =>
					-- RMAP Codec Status Register : RMAP Error Invalid Data CRC
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(0) <= dcom_read_registers_i.rmap_codec_status_reg.rmap_err_invalid_data_crc;
					end if;

				when (16#3B#) =>
					-- RMAP Memory Area Config : RMAP Memory Area Address Offset
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						avalon_mm_dcom_o.readdata(7 downto 0) <= dcom_write_registers_i.rmap_mem_area_config_reg.rmap_mem_area_addr_offset(7 downto 0);
					end if;
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						avalon_mm_dcom_o.readdata(15 downto 8) <= dcom_write_registers_i.rmap_mem_area_config_reg.rmap_mem_area_addr_offset(15 downto 8);
					end if;
					if (avalon_mm_dcom_i.byteenable(2) = '1') then
						avalon_mm_dcom_o.readdata(23 downto 16) <= dcom_write_registers_i.rmap_mem_area_config_reg.rmap_mem_area_addr_offset(23 downto 16);
					end if;
					if (avalon_mm_dcom_i.byteenable(3) = '1') then
						avalon_mm_dcom_o.readdata(31 downto 24) <= dcom_write_registers_i.rmap_mem_area_config_reg.rmap_mem_area_addr_offset(31 downto 24);
					end if;

				when others =>
					-- No register associated to the address, return with 0x00000000
					avalon_mm_dcom_o.readdata <= (others => '0');

			end case;

		end procedure p_readdata;

		variable v_read_address : t_avalon_mm_dcom_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_dcom_o.readdata    <= (others => '0');
			avalon_mm_dcom_o.waitrequest <= '1';
			v_read_address               := 0;
		elsif (rising_edge(clk_i)) then
			avalon_mm_dcom_o.readdata    <= (others => '0');
			avalon_mm_dcom_o.waitrequest <= '1';
			if (avalon_mm_dcom_i.read = '1') then
				v_read_address := to_integer(unsigned(avalon_mm_dcom_i.address));
				-- check if the address is allowed
				if ((v_read_address >= c_AVALON_MM_DCOM_MIN_ADDR) and (v_read_address <= c_AVALON_MM_DCOM_MAX_ADDR)) then
					avalon_mm_dcom_o.waitrequest <= '0';
					p_readdata(v_read_address);
				end if;
			end if;
		end if;

	end process p_avalon_mm_dcom_read;

end architecture RTL;
