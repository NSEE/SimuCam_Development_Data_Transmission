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

	signal s_data_acquired : std_logic;

begin

	p_avalon_mm_dcom_write : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin

			-- Write Registers Reset/Default State

			-- Dcom Device Address Register : Dcom Device Base Address
			dcom_write_registers_o.dcom_dev_addr_reg.dcom_dev_base_addr                       <= (others => '0');
			-- Dcom IRQ Control Register : Dcom Global IRQ Enable
			dcom_write_registers_o.dcom_irq_control_reg.dcom_global_irq_en                    <= '0';
			-- SpaceWire Device Address Register : SpaceWire Device Base Address
			dcom_write_registers_o.spw_dev_addr_reg.spw_dev_base_addr                         <= (others => '0');
			-- SpaceWire Link Config Register : SpaceWire Link Config Disconnect
			dcom_write_registers_o.spw_link_config_reg.spw_lnkcfg_disconnect                  <= '0';
			-- SpaceWire Link Config Register : SpaceWire Link Config Linkstart
			dcom_write_registers_o.spw_link_config_reg.spw_lnkcfg_linkstart                   <= '0';
			-- SpaceWire Link Config Register : SpaceWire Link Config Autostart
			dcom_write_registers_o.spw_link_config_reg.spw_lnkcfg_autostart                   <= '0';
			-- SpaceWire Link Config Register : SpaceWire Link Config TxDivCnt
			dcom_write_registers_o.spw_link_config_reg.spw_lnkcfg_txdivcnt                    <= x"01";
			-- SpaceWire Timecode Control Register : SpaceWire Timecode Tx Time
			dcom_write_registers_o.spw_timecode_control_reg.timecode_tx_time                  <= (others => '0');
			-- SpaceWire Timecode Control Register : SpaceWire Timecode Tx Control
			dcom_write_registers_o.spw_timecode_control_reg.timecode_tx_control               <= (others => '0');
			-- SpaceWire Timecode Control Register : SpaceWire Timecode Tx Send
			dcom_write_registers_o.spw_timecode_control_reg.timecode_tx_send                  <= '0';
			-- SpaceWire Timecode Control Register : SpaceWire Timecode Rx Received Clear
			dcom_write_registers_o.spw_timecode_control_reg.timecode_rx_received_clear        <= '0';
			-- Data Scheduler Device Address Register : Data Scheduler Device Base Address
			dcom_write_registers_o.data_scheduler_dev_addr_reg.data_scheduler_dev_base_addr   <= (others => '0');
			-- Data Scheduler Timer Control Register : Data Scheduler Timer Start
			dcom_write_registers_o.data_scheduler_tmr_control_reg.timer_start                 <= '0';
			-- Data Scheduler Timer Control Register : Data Scheduler Timer Run
			dcom_write_registers_o.data_scheduler_tmr_control_reg.timer_run                   <= '0';
			-- Data Scheduler Timer Control Register : Data Scheduler Timer Stop
			dcom_write_registers_o.data_scheduler_tmr_control_reg.timer_stop                  <= '0';
			-- Data Scheduler Timer Control Register : Data Scheduler Timer Clear
			dcom_write_registers_o.data_scheduler_tmr_control_reg.timer_clear                 <= '0';
			-- Data Scheduler Timer Config Register : Data Scheduler Timer Run on Sync
			dcom_write_registers_o.data_scheduler_tmr_config_reg.timer_run_on_sync            <= '1';
			-- Data Scheduler Timer Config Register : Data Scheduler Timer Clock Div
			dcom_write_registers_o.data_scheduler_tmr_config_reg.timer_clk_div                <= (others => '0');
			-- Data Scheduler Timer Config Register : Data Scheduler Timer Start Time
			dcom_write_registers_o.data_scheduler_tmr_config_reg.timer_start_time             <= (others => '0');
			-- Data Scheduler Packet Config Register : Data Scheduler Send EOP with Packet
			dcom_write_registers_o.data_scheduler_pkt_config_reg.send_eop                     <= '1';
			-- Data Scheduler Packet Config Register : Data Scheduler Send EEP with Packet
			dcom_write_registers_o.data_scheduler_pkt_config_reg.send_eep                     <= '0';
			-- Data Scheduler Data Control Register : Data Scheduler Initial Read Address [High Dword]
			dcom_write_registers_o.data_scheduler_data_control_reg.rd_initial_addr_high_dword <= (others => '0');
			-- Data Scheduler Data Control Register : Data Scheduler Initial Read Address [Low Dword]
			dcom_write_registers_o.data_scheduler_data_control_reg.rd_initial_addr_low_dword  <= (others => '0');
			-- Data Scheduler Data Control Register : Data Scheduler Read Data Length [Bytes]
			dcom_write_registers_o.data_scheduler_data_control_reg.rd_data_length_bytes       <= (others => '0');
			-- Data Scheduler Data Control Register : Data Scheduler Data Read Start
			dcom_write_registers_o.data_scheduler_data_control_reg.rd_start                   <= '0';
			-- Data Scheduler Data Control Register : Data Scheduler Data Read Reset
			dcom_write_registers_o.data_scheduler_data_control_reg.rd_reset                   <= '0';
			-- Data Scheduler Data Control Register : Data Scheduler Data Read Auto Restart
			dcom_write_registers_o.data_scheduler_data_control_reg.rd_auto_restart            <= '0';
			-- Data Scheduler IRQ Control Register : Data Scheduler Tx End IRQ Enable
			dcom_write_registers_o.data_scheduler_irq_control_reg.irq_tx_end_en               <= '0';
			-- Data Scheduler IRQ Control Register : Data Scheduler Tx Begin IRQ Enable
			dcom_write_registers_o.data_scheduler_irq_control_reg.irq_tx_begin_en             <= '0';
			-- Data Scheduler IRQ Flags Clear Register : Data Scheduler Tx End IRQ Flag Clear
			dcom_write_registers_o.data_scheduler_irq_flags_clear_reg.irq_tx_end_flag_clear   <= '0';
			-- Data Scheduler IRQ Flags Clear Register : Data Scheduler Tx Begin IRQ Flag Clear
			dcom_write_registers_o.data_scheduler_irq_flags_clear_reg.irq_tx_begin_flag_clear <= '0';
			-- RMAP Device Address Register : RMAP Device Base Address
			dcom_write_registers_o.rmap_dev_addr_reg.rmap_dev_base_addr                       <= (others => '0');
			-- RMAP Codec Config Register : RMAP Target Logical Address
			dcom_write_registers_o.rmap_codec_config_reg.rmap_target_logical_addr             <= x"00";
			-- RMAP Codec Config Register : RMAP Target Key
			dcom_write_registers_o.rmap_codec_config_reg.rmap_target_key                      <= x"00";
			-- RMAP Memory Area Config Register : RMAP Memory Area Address Offset
			dcom_write_registers_o.rmap_mem_area_config_reg.rmap_mem_area_addr_offset         <= (others => '0');
			-- RMAP Memory Area Pointer Register : RMAP Memory Area Pointer
			dcom_write_registers_o.rmap_mem_area_ptr_reg.rmap_mem_area_ptr                    <= (others => '0');

		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin

			-- Write Registers Triggers Reset

			-- SpaceWire Timecode Control Register : SpaceWire Timecode Tx Send
			dcom_write_registers_o.spw_timecode_control_reg.timecode_tx_send                  <= '0';
			-- SpaceWire Timecode Control Register : SpaceWire Timecode Rx Received Clear
			dcom_write_registers_o.spw_timecode_control_reg.timecode_rx_received_clear        <= '0';
			-- Data Scheduler Timer Control Register : Data Scheduler Timer Start
			dcom_write_registers_o.data_scheduler_tmr_control_reg.timer_start                 <= '0';
			-- Data Scheduler Timer Control Register : Data Scheduler Timer Run
			dcom_write_registers_o.data_scheduler_tmr_control_reg.timer_run                   <= '0';
			-- Data Scheduler Timer Control Register : Data Scheduler Timer Stop
			dcom_write_registers_o.data_scheduler_tmr_control_reg.timer_stop                  <= '0';
			-- Data Scheduler Timer Control Register : Data Scheduler Timer Clear
			dcom_write_registers_o.data_scheduler_tmr_control_reg.timer_clear                 <= '0';
			-- Data Scheduler Data Control Register : Data Scheduler Data Read Start
			dcom_write_registers_o.data_scheduler_data_control_reg.rd_start                   <= '0';
			-- Data Scheduler Data Control Register : Data Scheduler Data Read Reset
			dcom_write_registers_o.data_scheduler_data_control_reg.rd_reset                   <= '0';
			-- Data Scheduler IRQ Flags Clear Register : Data Scheduler Tx End IRQ Flag Clear
			dcom_write_registers_o.data_scheduler_irq_flags_clear_reg.irq_tx_end_flag_clear   <= '0';
			-- Data Scheduler IRQ Flags Clear Register : Data Scheduler Tx Begin IRQ Flag Clear
			dcom_write_registers_o.data_scheduler_irq_flags_clear_reg.irq_tx_begin_flag_clear <= '0';

		end procedure p_control_triggers;

		procedure p_writedata(write_address_i : t_avalon_mm_dcom_address) is
		begin

			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				when (16#00#) =>
					-- Dcom Device Address Register : Dcom Device Base Address
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.dcom_dev_addr_reg.dcom_dev_base_addr(7 downto 0) <= avalon_mm_dcom_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						dcom_write_registers_o.dcom_dev_addr_reg.dcom_dev_base_addr(15 downto 8) <= avalon_mm_dcom_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_dcom_i.byteenable(2) = '1') then
						dcom_write_registers_o.dcom_dev_addr_reg.dcom_dev_base_addr(23 downto 16) <= avalon_mm_dcom_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_dcom_i.byteenable(3) = '1') then
						dcom_write_registers_o.dcom_dev_addr_reg.dcom_dev_base_addr(31 downto 24) <= avalon_mm_dcom_i.writedata(31 downto 24);
					end if;

				when (16#01#) =>
					-- Dcom IRQ Control Register : Dcom Global IRQ Enable
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.dcom_irq_control_reg.dcom_global_irq_en <= avalon_mm_dcom_i.writedata(0);
					end if;

				when (16#02#) =>
					-- SpaceWire Device Address Register : SpaceWire Device Base Address
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.spw_dev_addr_reg.spw_dev_base_addr(7 downto 0) <= avalon_mm_dcom_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						dcom_write_registers_o.spw_dev_addr_reg.spw_dev_base_addr(15 downto 8) <= avalon_mm_dcom_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_dcom_i.byteenable(2) = '1') then
						dcom_write_registers_o.spw_dev_addr_reg.spw_dev_base_addr(23 downto 16) <= avalon_mm_dcom_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_dcom_i.byteenable(3) = '1') then
						dcom_write_registers_o.spw_dev_addr_reg.spw_dev_base_addr(31 downto 24) <= avalon_mm_dcom_i.writedata(31 downto 24);
					end if;

				when (16#03#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config Disconnect
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.spw_link_config_reg.spw_lnkcfg_disconnect <= avalon_mm_dcom_i.writedata(0);
					end if;

				when (16#04#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config Linkstart
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.spw_link_config_reg.spw_lnkcfg_linkstart <= avalon_mm_dcom_i.writedata(0);
					end if;

				when (16#05#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config Autostart
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.spw_link_config_reg.spw_lnkcfg_autostart <= avalon_mm_dcom_i.writedata(0);
					end if;

				when (16#06#) =>
					-- SpaceWire Link Config Register : SpaceWire Link Config TxDivCnt
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.spw_link_config_reg.spw_lnkcfg_txdivcnt <= avalon_mm_dcom_i.writedata(7 downto 0);
					end if;

				when (16#0E#) =>
					-- SpaceWire Timecode Control Register : SpaceWire Timecode Tx Time
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.spw_timecode_control_reg.timecode_tx_time <= avalon_mm_dcom_i.writedata(5 downto 0);
					end if;
					-- SpaceWire Timecode Control Register : SpaceWire Timecode Tx Control
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						dcom_write_registers_o.spw_timecode_control_reg.timecode_tx_control <= avalon_mm_dcom_i.writedata(9 downto 8);
					end if;

				when (16#0F#) =>
					-- SpaceWire Timecode Control Register : SpaceWire Timecode Tx Send
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.spw_timecode_control_reg.timecode_tx_send <= avalon_mm_dcom_i.writedata(0);
					end if;

				when (16#10#) =>
					-- SpaceWire Timecode Control Register : SpaceWire Timecode Rx Received Clear
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.spw_timecode_control_reg.timecode_rx_received_clear <= avalon_mm_dcom_i.writedata(0);
					end if;

				when (16#13#) =>
					-- Data Scheduler Device Address Register : Data Scheduler Device Base Address
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.data_scheduler_dev_addr_reg.data_scheduler_dev_base_addr(7 downto 0) <= avalon_mm_dcom_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						dcom_write_registers_o.data_scheduler_dev_addr_reg.data_scheduler_dev_base_addr(15 downto 8) <= avalon_mm_dcom_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_dcom_i.byteenable(2) = '1') then
						dcom_write_registers_o.data_scheduler_dev_addr_reg.data_scheduler_dev_base_addr(23 downto 16) <= avalon_mm_dcom_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_dcom_i.byteenable(3) = '1') then
						dcom_write_registers_o.data_scheduler_dev_addr_reg.data_scheduler_dev_base_addr(31 downto 24) <= avalon_mm_dcom_i.writedata(31 downto 24);
					end if;

				when (16#14#) =>
					-- Data Scheduler Timer Control Register : Data Scheduler Timer Start
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.data_scheduler_tmr_control_reg.timer_start <= avalon_mm_dcom_i.writedata(0);
					end if;

				when (16#15#) =>
					-- Data Scheduler Timer Control Register : Data Scheduler Timer Run
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.data_scheduler_tmr_control_reg.timer_run <= avalon_mm_dcom_i.writedata(0);
					end if;

				when (16#16#) =>
					-- Data Scheduler Timer Control Register : Data Scheduler Timer Stop
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.data_scheduler_tmr_control_reg.timer_stop <= avalon_mm_dcom_i.writedata(0);
					end if;

				when (16#17#) =>
					-- Data Scheduler Timer Control Register : Data Scheduler Timer Clear
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.data_scheduler_tmr_control_reg.timer_clear <= avalon_mm_dcom_i.writedata(0);
					end if;

				when (16#18#) =>
					-- Data Scheduler Timer Config Register : Data Scheduler Timer Run on Sync
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.data_scheduler_tmr_config_reg.timer_run_on_sync <= avalon_mm_dcom_i.writedata(0);
					end if;

				when (16#19#) =>
					-- Data Scheduler Timer Config Register : Data Scheduler Timer Clock Div
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.data_scheduler_tmr_config_reg.timer_clk_div(7 downto 0) <= avalon_mm_dcom_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						dcom_write_registers_o.data_scheduler_tmr_config_reg.timer_clk_div(15 downto 8) <= avalon_mm_dcom_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_dcom_i.byteenable(2) = '1') then
						dcom_write_registers_o.data_scheduler_tmr_config_reg.timer_clk_div(23 downto 16) <= avalon_mm_dcom_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_dcom_i.byteenable(3) = '1') then
						dcom_write_registers_o.data_scheduler_tmr_config_reg.timer_clk_div(31 downto 24) <= avalon_mm_dcom_i.writedata(31 downto 24);
					end if;

				when (16#1A#) =>
					-- Data Scheduler Timer Config Register : Data Scheduler Timer Start Time
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.data_scheduler_tmr_config_reg.timer_start_time(7 downto 0) <= avalon_mm_dcom_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						dcom_write_registers_o.data_scheduler_tmr_config_reg.timer_start_time(15 downto 8) <= avalon_mm_dcom_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_dcom_i.byteenable(2) = '1') then
						dcom_write_registers_o.data_scheduler_tmr_config_reg.timer_start_time(23 downto 16) <= avalon_mm_dcom_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_dcom_i.byteenable(3) = '1') then
						dcom_write_registers_o.data_scheduler_tmr_config_reg.timer_start_time(31 downto 24) <= avalon_mm_dcom_i.writedata(31 downto 24);
					end if;

				when (16#20#) =>
					-- Data Scheduler Packet Config Register : Data Scheduler Send EOP with Packet
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.data_scheduler_pkt_config_reg.send_eop <= avalon_mm_dcom_i.writedata(0);
					end if;

				when (16#21#) =>
					-- Data Scheduler Packet Config Register : Data Scheduler Send EEP with Packet
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.data_scheduler_pkt_config_reg.send_eep <= avalon_mm_dcom_i.writedata(0);
					end if;

				when (16#25#) =>
					-- Data Scheduler Data Control Register : Data Scheduler Initial Read Address [High Dword]
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.data_scheduler_data_control_reg.rd_initial_addr_high_dword(7 downto 0) <= avalon_mm_dcom_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						dcom_write_registers_o.data_scheduler_data_control_reg.rd_initial_addr_high_dword(15 downto 8) <= avalon_mm_dcom_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_dcom_i.byteenable(2) = '1') then
						dcom_write_registers_o.data_scheduler_data_control_reg.rd_initial_addr_high_dword(23 downto 16) <= avalon_mm_dcom_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_dcom_i.byteenable(3) = '1') then
						dcom_write_registers_o.data_scheduler_data_control_reg.rd_initial_addr_high_dword(31 downto 24) <= avalon_mm_dcom_i.writedata(31 downto 24);
					end if;

				when (16#26#) =>
					-- Data Scheduler Data Control Register : Data Scheduler Initial Read Address [Low Dword]
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.data_scheduler_data_control_reg.rd_initial_addr_low_dword(7 downto 0) <= avalon_mm_dcom_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						dcom_write_registers_o.data_scheduler_data_control_reg.rd_initial_addr_low_dword(15 downto 8) <= avalon_mm_dcom_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_dcom_i.byteenable(2) = '1') then
						dcom_write_registers_o.data_scheduler_data_control_reg.rd_initial_addr_low_dword(23 downto 16) <= avalon_mm_dcom_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_dcom_i.byteenable(3) = '1') then
						dcom_write_registers_o.data_scheduler_data_control_reg.rd_initial_addr_low_dword(31 downto 24) <= avalon_mm_dcom_i.writedata(31 downto 24);
					end if;

				when (16#27#) =>
					-- Data Scheduler Data Control Register : Data Scheduler Read Data Length [Bytes]
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.data_scheduler_data_control_reg.rd_data_length_bytes(7 downto 0) <= avalon_mm_dcom_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						dcom_write_registers_o.data_scheduler_data_control_reg.rd_data_length_bytes(15 downto 8) <= avalon_mm_dcom_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_dcom_i.byteenable(2) = '1') then
						dcom_write_registers_o.data_scheduler_data_control_reg.rd_data_length_bytes(23 downto 16) <= avalon_mm_dcom_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_dcom_i.byteenable(3) = '1') then
						dcom_write_registers_o.data_scheduler_data_control_reg.rd_data_length_bytes(31 downto 24) <= avalon_mm_dcom_i.writedata(31 downto 24);
					end if;

				when (16#28#) =>
					-- Data Scheduler Data Control Register : Data Scheduler Data Read Start
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.data_scheduler_data_control_reg.rd_start <= avalon_mm_dcom_i.writedata(0);
					end if;

				when (16#29#) =>
					-- Data Scheduler Data Control Register : Data Scheduler Data Read Reset
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.data_scheduler_data_control_reg.rd_reset <= avalon_mm_dcom_i.writedata(0);
					end if;

				when (16#2A#) =>
					-- Data Scheduler Data Control Register : Data Scheduler Data Read Auto Restart
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.data_scheduler_data_control_reg.rd_auto_restart <= avalon_mm_dcom_i.writedata(0);
					end if;

				when (16#2C#) =>
					-- Data Scheduler IRQ Control Register : Data Scheduler Tx End IRQ Enable
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.data_scheduler_irq_control_reg.irq_tx_end_en <= avalon_mm_dcom_i.writedata(0);
					end if;

				when (16#2D#) =>
					-- Data Scheduler IRQ Control Register : Data Scheduler Tx Begin IRQ Enable
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.data_scheduler_irq_control_reg.irq_tx_begin_en <= avalon_mm_dcom_i.writedata(0);
					end if;

				when (16#30#) =>
					-- Data Scheduler IRQ Flags Clear Register : Data Scheduler Tx End IRQ Flag Clear
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.data_scheduler_irq_flags_clear_reg.irq_tx_end_flag_clear <= avalon_mm_dcom_i.writedata(0);
					end if;

				when (16#31#) =>
					-- Data Scheduler IRQ Flags Clear Register : Data Scheduler Tx Begin IRQ Flag Clear
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.data_scheduler_irq_flags_clear_reg.irq_tx_begin_flag_clear <= avalon_mm_dcom_i.writedata(0);
					end if;

				when (16#32#) =>
					-- RMAP Device Address Register : RMAP Device Base Address
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.rmap_dev_addr_reg.rmap_dev_base_addr(7 downto 0) <= avalon_mm_dcom_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						dcom_write_registers_o.rmap_dev_addr_reg.rmap_dev_base_addr(15 downto 8) <= avalon_mm_dcom_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_dcom_i.byteenable(2) = '1') then
						dcom_write_registers_o.rmap_dev_addr_reg.rmap_dev_base_addr(23 downto 16) <= avalon_mm_dcom_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_dcom_i.byteenable(3) = '1') then
						dcom_write_registers_o.rmap_dev_addr_reg.rmap_dev_base_addr(31 downto 24) <= avalon_mm_dcom_i.writedata(31 downto 24);
					end if;

				when (16#33#) =>
					-- RMAP Codec Config Register : RMAP Target Logical Address
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.rmap_codec_config_reg.rmap_target_logical_addr <= avalon_mm_dcom_i.writedata(7 downto 0);
					end if;
					-- RMAP Codec Config Register : RMAP Target Key
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						dcom_write_registers_o.rmap_codec_config_reg.rmap_target_key <= avalon_mm_dcom_i.writedata(15 downto 8);
					end if;

				when (16#42#) =>
					-- RMAP Memory Area Config Register : RMAP Memory Area Address Offset
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.rmap_mem_area_config_reg.rmap_mem_area_addr_offset(7 downto 0) <= avalon_mm_dcom_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						dcom_write_registers_o.rmap_mem_area_config_reg.rmap_mem_area_addr_offset(15 downto 8) <= avalon_mm_dcom_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_dcom_i.byteenable(2) = '1') then
						dcom_write_registers_o.rmap_mem_area_config_reg.rmap_mem_area_addr_offset(23 downto 16) <= avalon_mm_dcom_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_dcom_i.byteenable(3) = '1') then
						dcom_write_registers_o.rmap_mem_area_config_reg.rmap_mem_area_addr_offset(31 downto 24) <= avalon_mm_dcom_i.writedata(31 downto 24);
					end if;

				when (16#43#) =>
					-- RMAP Memory Area Pointer Register : RMAP Memory Area Pointer
					if (avalon_mm_dcom_i.byteenable(0) = '1') then
						dcom_write_registers_o.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(7 downto 0) <= avalon_mm_dcom_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_dcom_i.byteenable(1) = '1') then
						dcom_write_registers_o.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(15 downto 8) <= avalon_mm_dcom_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_dcom_i.byteenable(2) = '1') then
						dcom_write_registers_o.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(23 downto 16) <= avalon_mm_dcom_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_dcom_i.byteenable(3) = '1') then
						dcom_write_registers_o.rmap_mem_area_ptr_reg.rmap_mem_area_ptr(31 downto 24) <= avalon_mm_dcom_i.writedata(31 downto 24);
					end if;

				when others =>
					-- No register associated to the address, do nothing
					null;

			end case;

		end procedure p_writedata;

		variable v_write_address : t_avalon_mm_dcom_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_dcom_o.waitrequest <= '1';
			s_data_acquired              <= '0';
			v_write_address              := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			avalon_mm_dcom_o.waitrequest <= '1';
			p_control_triggers;
			s_data_acquired              <= '0';
			if (avalon_mm_dcom_i.write = '1') then
				v_write_address := to_integer(unsigned(avalon_mm_dcom_i.address));
				-- check if the address is allowed
				if ((v_write_address >= c_AVALON_MM_DCOM_MIN_ADDR) and (v_write_address <= c_AVALON_MM_DCOM_MAX_ADDR)) then
					avalon_mm_dcom_o.waitrequest <= '0';
					s_data_acquired              <= '1';
					if (s_data_acquired = '0') then
						p_writedata(v_write_address);
					end if;
				end if;
			end if;
		end if;
	end process p_avalon_mm_dcom_write;

end architecture RTL;
