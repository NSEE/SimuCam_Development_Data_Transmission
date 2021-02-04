-- dcom_v2_top.vhd

-- This file was auto-generated as a prototype implementation of a module
-- created in component editor.  It ties off all outputs to ground and
-- ignores all inputs.  It needs to be edited to make it do something
-- useful.
-- 
-- This file will not be automatically regenerated.  You should check it in
-- to your version control system if you want to keep it.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.avalon_mm_dcom_pkg.all;
use work.avalon_mm_dcom_registers_pkg.all;
use work.dcom_avm_data_pkg.all;
use work.data_buffer_pkg.all;
use work.rmap_target_pkg.all;
use work.spw_codec_pkg.all;

entity dcom_v2_top is
	port(
		reset_sink_reset_i               : in  std_logic                     := '0'; --          --                       reset_sink.reset
		sync_channel_i                   : in  std_logic                     := '0'; --          --                 sync_conduit_end.sync_channel_i_signal
		clock_sink_100_clk_i             : in  std_logic                     := '0'; --          --                   clock_sink_100.clk
		avalon_slave_dcom_address_i      : in  std_logic_vector(7 downto 0)  := (others => '0'); --                avalon_slave_dcom.address
		avalon_slave_dcom_byteenable_i   : in  std_logic_vector(3 downto 0)  := (others => '0'); --                                 .byteenable
		avalon_slave_dcom_write_i        : in  std_logic                     := '0'; --          --                                 .write
		avalon_slave_dcom_read_i         : in  std_logic                     := '0'; --          --                                 .read
		avalon_slave_dcom_writedata_i    : in  std_logic_vector(31 downto 0) := (others => '0'); --                                 .writedata
		avalon_slave_dcom_readdata_o     : out std_logic_vector(31 downto 0); --                 --                                 .readdata
		avalon_slave_dcom_waitrequest_o  : out std_logic; --                                     --                                 .waitrequest
		avalon_master_data_readdata_i    : in  std_logic_vector(63 downto 0) := (others => '0'); --               avalon_master_data.readdata
		avalon_master_data_waitrequest_i : in  std_logic                     := '0'; --          --                                 .waitrequest
		avalon_master_data_address_o     : out std_logic_vector(63 downto 0); --                 --                                 .address
		avalon_master_data_read_o        : out std_logic; --                                     --                                 .read
		tx_interrupt_sender_irq_o        : out std_logic; --                                     --              tx_interrupt_sender.irq
		rprt_interrupt_sender_irq_o      : out std_logic; --                                     --            rprt_interrupt_sender.irq
		spw_link_status_started_i        : in  std_logic                     := '0'; --          -- conduit_end_spacewire_controller.spw_link_status_started_signal
		spw_link_status_connecting_i     : in  std_logic                     := '0'; --          --                                 .spw_link_status_connecting_signal
		spw_link_status_running_i        : in  std_logic                     := '0'; --          --                                 .spw_link_status_running_signal
		spw_link_error_errdisc_i         : in  std_logic                     := '0'; --          --                                 .spw_link_error_errdisc_signal
		spw_link_error_errpar_i          : in  std_logic                     := '0'; --          --                                 .spw_link_error_errpar_signal
		spw_link_error_erresc_i          : in  std_logic                     := '0'; --          --                                 .spw_link_error_erresc_signal
		spw_link_error_errcred_i         : in  std_logic                     := '0'; --          --                                 .spw_link_error_errcred_signal		
		spw_timecode_rx_tick_out_i       : in  std_logic                     := '0'; --          --                                 .spw_timecode_rx_tick_out_signal
		spw_timecode_rx_ctrl_out_i       : in  std_logic_vector(1 downto 0)  := (others => '0'); --                                 .spw_timecode_rx_ctrl_out_signal
		spw_timecode_rx_time_out_i       : in  std_logic_vector(5 downto 0)  := (others => '0'); --                                 .spw_timecode_rx_time_out_signal
		spw_data_rx_status_rxvalid_i     : in  std_logic                     := '0'; --          --                                 .spw_data_rx_status_rxvalid_signal
		spw_data_rx_status_rxhalff_i     : in  std_logic                     := '0'; --          --                                 .spw_data_rx_status_rxhalff_signal
		spw_data_rx_status_rxflag_i      : in  std_logic                     := '0'; --          --                                 .spw_data_rx_status_rxflag_signal
		spw_data_rx_status_rxdata_i      : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                 .spw_data_rx_status_rxdata_signal
		spw_data_tx_status_txrdy_i       : in  std_logic                     := '0'; --          --                                 .spw_data_tx_status_txrdy_signal
		spw_data_tx_status_txhalff_i     : in  std_logic                     := '0'; --          --                                 .spw_data_tx_status_txhalff_signal
		spw_errinj_ctrl_errinj_busy_i    : in  std_logic                     := '0'; --          --                                        .spw_errinj_ctrl_errinj_busy_signal
		spw_errinj_ctrl_errinj_ready_i   : in  std_logic                     := '0'; --          --                                        .spw_errinj_ctrl_errinj_ready_signal
		spw_link_command_autostart_o     : out std_logic; --                                     --                                 .spw_link_command_autostart_signal
		spw_link_command_linkstart_o     : out std_logic; --                                     --                                 .spw_link_command_linkstart_signal
		spw_link_command_linkdis_o       : out std_logic; --                                     --                                 .spw_link_command_linkdis_signal
		spw_link_command_txdivcnt_o      : out std_logic_vector(7 downto 0); --                  --                                 .spw_link_command_txdivcnt_signal
		spw_timecode_tx_tick_in_o        : out std_logic; --                                     --                                 .spw_timecode_tx_tick_in_signal
		spw_timecode_tx_ctrl_in_o        : out std_logic_vector(1 downto 0); --                  --                                 .spw_timecode_tx_ctrl_in_signal
		spw_timecode_tx_time_in_o        : out std_logic_vector(5 downto 0); --                  --                                 .spw_timecode_tx_time_in_signal
		spw_data_rx_command_rxread_o     : out std_logic; --                                     --                                 .spw_data_rx_command_rxread_signal
		spw_data_tx_command_txwrite_o    : out std_logic; --                                     --                                 .spw_data_tx_command_txwrite_signal
		spw_data_tx_command_txflag_o     : out std_logic; --                                     --                                 .spw_data_tx_command_txflag_signal
		spw_data_tx_command_txdata_o     : out std_logic_vector(7 downto 0); --                  --                                 .spw_data_tx_command_txdata_signal
		spw_errinj_ctrl_start_errinj_o   : out std_logic; --                                      --                                        .spw_errinj_ctrl_start_errinj_signal
		spw_errinj_ctrl_reset_errinj_o   : out std_logic; --                                      --                                        .spw_errinj_ctrl_reset_errinj_signal
		spw_errinj_ctrl_errinj_code_o    : out std_logic_vector(3 downto 0); --                   --                                        .spw_errinj_ctrl_errinj_code_signal
		codec_rmap_wr_waitrequest_i      : in  std_logic                     := '0'; --          --    conduit_end_rmap_master_codec.wr_waitrequest_signal
		codec_rmap_readdata_i            : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                 .readdata_signal
		codec_rmap_rd_waitrequest_i      : in  std_logic                     := '0'; --          --                                 .rd_waitrequest_signal
		codec_rmap_wr_address_o          : out std_logic_vector(31 downto 0); --                 --                                 .wr_address_signal
		codec_rmap_write_o               : out std_logic; --                                     --                                 .write_signal
		codec_rmap_writedata_o           : out std_logic_vector(7 downto 0); --                  --                                 .writedata_signal
		codec_rmap_rd_address_o          : out std_logic_vector(31 downto 0); --                 --                                 .rd_address_signal
		codec_rmap_read_o                : out std_logic; --                                     --                                 .read_signal
		rmap_mem_addr_offset_o           : out std_logic_vector(31 downto 0) ---                 -- conduit_end_rmap_mem_configs_out.mem_addr_offset_signal
	);
end entity dcom_v2_top;

architecture rtl of dcom_v2_top is

	-- Alias --

	-- Common Ports Alias
	alias a_avs_clock is clock_sink_100_clk_i;
	alias a_reset is reset_sink_reset_i;

	-- Signals --

	-- DCOM Avalon MM Read Signals
	signal s_dcom_avalon_mm_read_waitrequest : std_logic;

	-- DCOM Avalon MM Write Signals
	signal s_dcom_avalon_mm_write_waitrequest : std_logic;

	-- DCOM Avalon MM Registers Signals
	signal s_dcom_write_registers : t_dcom_write_registers;
	signal s_dcom_read_registers  : t_dcom_read_registers;

	-- DCOM AVM Controller Signals
	signal s_avm_data_master_rd_control : t_dcom_avm_data_master_rd_control;
	signal s_avm_data_master_rd_status  : t_dcom_avm_data_master_rd_status;

	-- Data Buffer Signals
	signal s_avs_dbuffer_wrdata    : std_logic_vector((c_AVS_DBUFFER_DATA_WIDTH - 1) downto 0);
	signal s_avs_dbuffer_wrreq     : std_logic;
	signal s_avs_dbuffer_halffull  : std_logic;
	signal s_avs_dbuffer_full      : std_logic;
	signal s_avs_bebuffer_wrdata   : std_logic_vector((c_AVS_BEBUFFER_DATA_WIDTH - 1) downto 0);
	signal s_avs_bebuffer_wrreq    : std_logic;
	signal s_avs_bebuffer_halffull : std_logic;
	signal s_avs_bebuffer_full     : std_logic;
	signal s_dcrtl_dbuffer_rddata  : std_logic_vector((c_DCTRL_DBUFFER_DATA_WIDTH - 1) downto 0);
	signal s_dcrtl_dbuffer_rdreq   : std_logic;
	signal s_dcrtl_dbuffer_empty   : std_logic;

	-- Data Controller Signals
	signal s_dctrl_tx_begin     : std_logic;
	signal s_dctrl_tx_ended     : std_logic;
	signal s_dctrl_spw_tx_ready : std_logic;
	signal s_dctrl_spw_tx_write : std_logic;
	signal s_dctrl_spw_tx_flag  : std_logic;
	signal s_dctrl_spw_tx_data  : std_logic_vector(7 downto 0);

	-- SpaceWire Codec (@ 100 MHz) Signals
	signal s_spw_codec_link_command_clk100    : t_spw_codec_link_command;
	signal s_spw_codec_link_status_clk100     : t_spw_codec_link_status;
	signal s_spw_codec_link_error_clk100      : t_spw_codec_link_error;
	signal s_spw_codec_timecode_rx_clk100     : t_spw_codec_timecode_rx;
	signal s_spw_codec_data_rx_status_clk100  : t_spw_codec_data_rx_status;
	signal s_spw_codec_data_tx_status_clk100  : t_spw_codec_data_tx_status;
	signal s_spw_codec_timecode_tx_clk100     : t_spw_codec_timecode_tx;
	signal s_spw_codec_data_rx_command_clk100 : t_spw_codec_data_rx_command;
	signal s_spw_codec_data_tx_command_clk100 : t_spw_codec_data_tx_command;

	-- SpaceWire Codec (@ 200 MHz) Signals
	signal s_spw_codec_link_command_clk200    : t_spw_codec_link_command;
	signal s_spw_codec_link_status_clk200     : t_spw_codec_link_status;
	signal s_spw_codec_link_error_clk200      : t_spw_codec_link_error;
	signal s_spw_codec_timecode_rx_clk200     : t_spw_codec_timecode_rx;
	signal s_spw_codec_data_rx_status_clk200  : t_spw_codec_data_rx_status;
	signal s_spw_codec_data_tx_status_clk200  : t_spw_codec_data_tx_status;
	signal s_spw_codec_timecode_tx_clk200     : t_spw_codec_timecode_tx;
	signal s_spw_codec_data_rx_command_clk200 : t_spw_codec_data_rx_command;
	signal s_spw_codec_data_tx_command_clk200 : t_spw_codec_data_tx_command;

	-- Timecode Rx Flag Manager Signals
	signal s_rxtc_tick_out : std_logic;

	-- DCOM Tx Interrupt Manager Signals
	signal s_txirq_tx_begin_delayed : std_logic;
	signal s_txirq_tx_ended_delayed : std_logic;

	-- Sync In Trigger Generator Signals
	signal s_sync_in_trigger : std_logic;
	signal s_sync_in_delayed : std_logic;

	-- Sync Polarity Fix Signals (timing issues, need to be changed)
	signal s_sync_channel_i_n : std_logic;

	-- Spw Codec Rx Dummy Reader Signals
	signal s_spw_dummy_rxvalid : std_logic;
	signal s_spw_dummy_rxread  : std_logic;

	-- spw mux
	-- "spw mux" to "codec" signals
	signal s_mux_rx_channel_command : t_spw_codec_data_rx_command;
	signal s_mux_rx_channel_status  : t_spw_codec_data_rx_status;
	signal s_mux_tx_channel_command : t_spw_codec_data_tx_command;
	signal s_mux_tx_channel_status  : t_spw_codec_data_tx_status;
	-- spw mux tx 1 signals
	signal s_mux_tx_1_command       : t_spw_codec_data_tx_command;
	signal s_mux_tx_1_status        : t_spw_codec_data_tx_status;
	-- spw mux tx 2 signals
	signal s_mux_tx_2_command       : t_spw_codec_data_tx_command;
	signal s_mux_tx_2_status        : t_spw_codec_data_tx_status;

	signal s_dummy_spw_mux_rx0_rxhalff : std_logic;
	signal s_dummy_spw_mux_tx0_txhalff : std_logic;

	-- rmap signals (TEMP)

	signal s_rmap_spw_control : t_rmap_target_spw_control;
	signal s_rmap_spw_flag    : t_rmap_target_spw_flag;

	signal s_rmap_mem_control : t_rmap_target_mem_control;
	signal s_rmap_mem_flag    : t_rmap_target_mem_flag;

	signal s_rmap_mem_wr_byte_address : std_logic_vector((32 + 0 - 1) downto 0);
	signal s_rmap_mem_rd_byte_address : std_logic_vector((32 + 0 - 1) downto 0);

begin

	-- Sync Polarity Fix Assignments (timing issues, need to be changed)
	s_sync_channel_i_n <= not sync_channel_i;

	-- DCOM Avalon MM Read Instantiation
	avalon_mm_dcom_read_ent_inst : entity work.avalon_mm_dcom_read_ent
		port map(
			clk_i                        => a_avs_clock,
			rst_i                        => a_reset,
			avalon_mm_dcom_i.address     => avalon_slave_dcom_address_i,
			avalon_mm_dcom_i.read        => avalon_slave_dcom_read_i,
			avalon_mm_dcom_i.byteenable  => avalon_slave_dcom_byteenable_i,
			dcom_write_registers_i       => s_dcom_write_registers,
			dcom_read_registers_i        => s_dcom_read_registers,
			avalon_mm_dcom_o.readdata    => avalon_slave_dcom_readdata_o,
			avalon_mm_dcom_o.waitrequest => s_dcom_avalon_mm_read_waitrequest
		);

	-- DCOM Avalon MM Write Instantiation
	avalon_mm_dcom_write_ent_inst : entity work.avalon_mm_dcom_write_ent
		port map(
			clk_i                        => a_avs_clock,
			rst_i                        => a_reset,
			avalon_mm_dcom_i.address     => avalon_slave_dcom_address_i,
			avalon_mm_dcom_i.write       => avalon_slave_dcom_write_i,
			avalon_mm_dcom_i.writedata   => avalon_slave_dcom_writedata_i,
			avalon_mm_dcom_i.byteenable  => avalon_slave_dcom_byteenable_i,
			avalon_mm_dcom_o.waitrequest => s_dcom_avalon_mm_write_waitrequest,
			dcom_write_registers_o       => s_dcom_write_registers
		);

	-- DCOM Avalon MM Signals Assignments
	avalon_slave_dcom_waitrequest_o <= ('1') when (a_reset = '1') else ((s_dcom_avalon_mm_write_waitrequest) and (s_dcom_avalon_mm_read_waitrequest));

	-- DCOM Avalon MM Master (AVM) Reader Instantiation
	dcom_avm_data_reader_ent_inst : entity work.dcom_avm_data_reader_ent
		port map(
			clk_i                             => a_avs_clock,
			rst_i                             => a_reset,
			avm_master_rd_control_i           => s_avm_data_master_rd_control,
			avm_slave_rd_status_i.readdata    => avalon_master_data_readdata_i,
			avm_slave_rd_status_i.waitrequest => avalon_master_data_waitrequest_i,
			avm_master_rd_status_o            => s_avm_data_master_rd_status,
			avm_slave_rd_control_o.address    => avalon_master_data_address_o,
			avm_slave_rd_control_o.read       => avalon_master_data_read_o
		);

	-- DCOM Tx Avalon MM Master (AVM) Reader Controller Instantiation
	dcom_avm_reader_controller_ent_inst : entity work.dcom_avm_reader_controller_ent
		port map(
			clk_i                                      => a_avs_clock,
			rst_i                                      => a_reset,
			tmr_stop_i                                 => s_dcom_write_registers.data_scheduler_tmr_control_reg.timer_stop,
			tmr_start_i                                => s_dcom_write_registers.data_scheduler_tmr_control_reg.timer_start,
			controller_rd_start_i                      => s_dcom_write_registers.data_scheduler_data_control_reg.rd_start,
			controller_rd_reset_i                      => s_dcom_write_registers.data_scheduler_data_control_reg.rd_reset,
			controller_rd_auto_restart_i               => s_dcom_write_registers.data_scheduler_data_control_reg.rd_auto_restart,
			controller_rd_initial_addr_i(63 downto 32) => s_dcom_write_registers.data_scheduler_data_control_reg.rd_initial_addr_high_dword,
			controller_rd_initial_addr_i(31 downto 0)  => s_dcom_write_registers.data_scheduler_data_control_reg.rd_initial_addr_low_dword,
			controller_rd_length_bytes_i               => s_dcom_write_registers.data_scheduler_data_control_reg.rd_data_length_bytes,
			controller_wr_busy_i                       => '0',
			avm_master_rd_status_i                     => s_avm_data_master_rd_status,
			data_buffer_full_i                         => s_avs_dbuffer_halffull,
			be_buffer_full_i                           => s_avs_bebuffer_halffull,
			--			data_buffer_full_i                         => s_avs_dbuffer_full,
			--			be_buffer_full_i                           => s_avs_bebuffer_full,
			controller_rd_busy_o                       => s_dcom_read_registers.data_scheduler_data_status_reg.rd_busy,
			avm_master_rd_control_o                    => s_avm_data_master_rd_control,
			data_buffer_wrdata_o                       => s_avs_dbuffer_wrdata,
			data_buffer_wrreq_o                        => s_avs_dbuffer_wrreq,
			be_buffer_wrdata_o                         => s_avs_bebuffer_wrdata,
			be_buffer_wrreq_o                          => s_avs_bebuffer_wrreq
		);

	-- Data Buffer Instantiation
	data_buffer_ent_inst : entity work.data_buffer_ent
		port map(
			clk_i                   => a_avs_clock,
			rst_i                   => a_reset,
			tmr_clear_i             => s_dcom_write_registers.data_scheduler_tmr_control_reg.timer_clear,
			tmr_stop_i              => s_dcom_write_registers.data_scheduler_tmr_control_reg.timer_stop,
			tmr_start_i             => s_dcom_write_registers.data_scheduler_tmr_control_reg.timer_start,
			avs_dbuffer_wrdata_i    => s_avs_dbuffer_wrdata,
			avs_dbuffer_wrreq_i     => s_avs_dbuffer_wrreq,
			avs_bebuffer_wrdata_i   => s_avs_bebuffer_wrdata,
			avs_bebuffer_wrreq_i    => s_avs_bebuffer_wrreq,
			dcrtl_dbuffer_rdreq_i   => s_dcrtl_dbuffer_rdreq,
			dbuff_empty_o           => s_dcom_read_registers.data_scheduler_buffer_status_reg.data_buffer_empty,
			dbuff_full_o            => s_dcom_read_registers.data_scheduler_buffer_status_reg.data_buffer_full,
			dbuff_usedw_o           => s_dcom_read_registers.data_scheduler_buffer_status_reg.data_buffer_used(14 downto 3),
			avs_dbuffer_halffull_o  => s_avs_dbuffer_halffull,
			avs_dbuffer_full_o      => s_avs_dbuffer_full,
			avs_bebuffer_halffull_o => s_avs_bebuffer_halffull,
			avs_bebuffer_full_o     => s_avs_bebuffer_full,
			dcrtl_dbuffer_rddata_o  => s_dcrtl_dbuffer_rddata,
			dcrtl_dbuffer_empty_o   => s_dcrtl_dbuffer_empty
		);
	s_dcom_read_registers.data_scheduler_buffer_status_reg.data_buffer_used(15)         <= '0';
	s_dcom_read_registers.data_scheduler_buffer_status_reg.data_buffer_used(2 downto 0) <= (others => '0');

	-- Data Controller Instantiation
	data_controller_ent_inst : entity work.data_controller_ent
		generic map(
			g_WORD_WIDTH        => 8,
			g_DATA_LENGTH_WORDS => 2,
			g_DATA_TIME_WORDS   => 4
		)
		port map(
			clk_i            => a_avs_clock,
			rst_i            => a_reset,
			tmr_time_i       => s_dcom_read_registers.data_scheduler_tmr_status_reg.timer_current_time,
			tmr_stop_i       => s_dcom_write_registers.data_scheduler_tmr_control_reg.timer_stop,
			tmr_start_i      => s_dcom_write_registers.data_scheduler_tmr_control_reg.timer_start,
			dctrl_send_eep_i => s_dcom_write_registers.data_scheduler_pkt_config_reg.send_eep,
			dctrl_send_eop_i => s_dcom_write_registers.data_scheduler_pkt_config_reg.send_eop,
			dbuffer_empty_i  => s_dcrtl_dbuffer_empty,
			dbuffer_rddata_i => s_dcrtl_dbuffer_rddata,
			spw_tx_ready_i   => s_dctrl_spw_tx_ready,
			dctrl_tx_begin_o => s_dctrl_tx_begin,
			dctrl_tx_ended_o => s_dctrl_tx_ended,
			dbuffer_rdreq_o  => s_dcrtl_dbuffer_rdreq,
			spw_tx_write_o   => s_dctrl_spw_tx_write,
			spw_tx_flag_o    => s_dctrl_spw_tx_flag,
			spw_tx_data_o    => s_dctrl_spw_tx_data
		);

	-- Data Scheduler Instantiation
	data_scheduler_ent_inst : entity work.data_scheduler_ent
		generic map(
			g_TIMER_CLKDIV_WIDTH => 32,
			g_TIMER_TIME_WIDTH   => 32
		)
		port map(
			clk_i             => a_avs_clock,
			rst_i             => a_reset,
			tmr_run_on_sync_i => s_dcom_write_registers.data_scheduler_tmr_config_reg.timer_run_on_sync,
			tmr_clk_div_i     => s_dcom_write_registers.data_scheduler_tmr_config_reg.timer_clk_div,
			tmr_time_in_i     => s_dcom_write_registers.data_scheduler_tmr_config_reg.timer_start_time,
			tmr_clear_i       => s_dcom_write_registers.data_scheduler_tmr_control_reg.timer_clear,
			tmr_stop_i        => s_dcom_write_registers.data_scheduler_tmr_control_reg.timer_stop,
			tmr_run_i         => s_dcom_write_registers.data_scheduler_tmr_control_reg.timer_run,
			tmr_start_i       => s_dcom_write_registers.data_scheduler_tmr_control_reg.timer_start,
			sync_i            => s_sync_in_trigger,
			tmr_cleared_o     => s_dcom_read_registers.data_scheduler_tmr_status_reg.timer_cleared,
			tmr_running_o     => s_dcom_read_registers.data_scheduler_tmr_status_reg.timer_running,
			tmr_started_o     => s_dcom_read_registers.data_scheduler_tmr_status_reg.timer_started,
			tmr_stopped_o     => s_dcom_read_registers.data_scheduler_tmr_status_reg.timer_stopped,
			tmr_time_out_o    => s_dcom_read_registers.data_scheduler_tmr_status_reg.timer_current_time
		);

	-- RMAP (TEMP)
	rmap_target_top_inst : entity work.rmap_target_top
		generic map(
			g_VERIFY_BUFFER_WIDTH  => 8,
			g_MEMORY_ADDRESS_WIDTH => 32,
			g_DATA_LENGTH_WIDTH    => 24,
			g_MEMORY_ACCESS_WIDTH  => 0
		)
		port map(
			clk_i                      => a_avs_clock,
			rst_i                      => a_reset,
			spw_flag_i                 => s_rmap_spw_flag,
			mem_flag_i                 => s_rmap_mem_flag,
			spw_control_o              => s_rmap_spw_control,
			conf_target_enable_i       => s_dcom_write_registers.rmap_codec_config_reg.rmap_target_enable,
			conf_target_logical_addr_i => s_dcom_write_registers.rmap_codec_config_reg.rmap_target_logical_addr,
			conf_target_key_i          => s_dcom_write_registers.rmap_codec_config_reg.rmap_target_key,
			rmap_errinj_en_i           => s_dcom_write_registers.rmap_error_injection_control_reg.rmap_errinj_trigger,
			rmap_errinj_id_i           => s_dcom_write_registers.rmap_error_injection_control_reg.rmap_errinj_err_id,
			rmap_errinj_val_i          => s_dcom_write_registers.rmap_error_injection_control_reg.rmap_errinj_value,
			mem_control_o              => s_rmap_mem_control,
			mem_wr_byte_address_o      => s_rmap_mem_wr_byte_address,
			mem_rd_byte_address_o      => s_rmap_mem_rd_byte_address,
			stat_command_received_o    => s_dcom_read_registers.rmap_codec_status_reg.rmap_stat_command_received,
			stat_write_requested_o     => s_dcom_read_registers.rmap_codec_status_reg.rmap_stat_write_requested,
			stat_write_authorized_o    => s_dcom_read_registers.rmap_codec_status_reg.rmap_stat_write_authorized,
			stat_write_finished_o      => open,
			stat_read_requested_o      => s_dcom_read_registers.rmap_codec_status_reg.rmap_stat_read_requested,
			stat_read_authorized_o     => s_dcom_read_registers.rmap_codec_status_reg.rmap_stat_read_authorized,
			stat_read_finished_o       => open,
			stat_reply_sended_o        => s_dcom_read_registers.rmap_codec_status_reg.rmap_stat_reply_sended,
			stat_discarded_package_o   => s_dcom_read_registers.rmap_codec_status_reg.rmap_stat_discarded_package,
			err_early_eop_o            => s_dcom_read_registers.rmap_codec_status_reg.rmap_err_early_eop,
			err_eep_o                  => s_dcom_read_registers.rmap_codec_status_reg.rmap_err_eep,
			err_header_crc_o           => s_dcom_read_registers.rmap_codec_status_reg.rmap_err_header_crc,
			err_unused_packet_type_o   => s_dcom_read_registers.rmap_codec_status_reg.rmap_err_unused_packet_type,
			err_invalid_command_code_o => s_dcom_read_registers.rmap_codec_status_reg.rmap_err_invalid_command_code,
			err_too_much_data_o        => s_dcom_read_registers.rmap_codec_status_reg.rmap_err_too_much_data,
			err_invalid_data_crc_o     => s_dcom_read_registers.rmap_codec_status_reg.rmap_err_invalid_data_crc
		);

	-- rmap memory area master signals assignments
	-- rmap master codec
	codec_rmap_wr_address_o           <= s_rmap_mem_wr_byte_address;
	codec_rmap_write_o                <= s_rmap_mem_control.write.write;
	codec_rmap_writedata_o            <= s_rmap_mem_control.write.data;
	s_rmap_mem_flag.write.error       <= '0';
	s_rmap_mem_flag.write.waitrequest <= codec_rmap_wr_waitrequest_i;
	codec_rmap_rd_address_o           <= s_rmap_mem_rd_byte_address;
	codec_rmap_read_o                 <= s_rmap_mem_control.read.read;
	s_rmap_mem_flag.read.error        <= '0';
	s_rmap_mem_flag.read.data         <= codec_rmap_readdata_i;
	s_rmap_mem_flag.read.waitrequest  <= codec_rmap_rd_waitrequest_i;

	-- rmap memory area address offset assignments
	rmap_mem_addr_offset_o <= s_dcom_write_registers.rmap_mem_area_config_reg.rmap_mem_area_addr_offset;

	-- spw mux tx 1 command muxing
	s_mux_tx_1_command.txwrite <= (s_dctrl_spw_tx_write);
	s_mux_tx_1_command.txflag  <= (s_dctrl_spw_tx_flag);
	s_mux_tx_1_command.txdata  <= (s_dctrl_spw_tx_data);
	-- spw mux tx 1 status muxing
	s_dctrl_spw_tx_ready       <= (s_mux_tx_1_status.txrdy);
	-- spw mux tx 2 command muxing
	s_mux_tx_2_command.txwrite <= '0';
	s_mux_tx_2_command.txflag  <= '0';
	s_mux_tx_2_command.txdata  <= (others => '0');
	-- spw mux tx 2 status muxing

	-- spw mux
	-- tx 0 / rx 0 -> rmap
	-- tx 1        -> data controller
	-- tx 2        -> nothing 
	spw_mux_ent_inst : entity work.spw_mux_ent
		port map(
			clk_i                          => a_avs_clock,
			rst_i                          => a_reset,
			tmr_clear_i                    => s_dcom_write_registers.data_scheduler_tmr_control_reg.timer_clear,
			tmr_stop_i                     => s_dcom_write_registers.data_scheduler_tmr_control_reg.timer_stop,
			tmr_start_i                    => s_dcom_write_registers.data_scheduler_tmr_control_reg.timer_start,
			spw_codec_rx_status_i          => s_mux_rx_channel_status,
			spw_codec_tx_status_i          => s_mux_tx_channel_status,
			spw_mux_rx_0_command_i.rxread  => s_rmap_spw_control.receiver.read,
			spw_mux_tx_0_command_i.txwrite => s_rmap_spw_control.transmitter.write,
			spw_mux_tx_0_command_i.txflag  => s_rmap_spw_control.transmitter.flag,
			spw_mux_tx_0_command_i.txdata  => s_rmap_spw_control.transmitter.data,
			spw_mux_tx_1_command_i         => s_mux_tx_1_command,
			spw_mux_tx_2_command_i         => s_mux_tx_2_command,
			spw_codec_rx_command_o         => s_mux_rx_channel_command,
			spw_codec_tx_command_o         => s_mux_tx_channel_command,
			spw_mux_rx_0_status_o.rxvalid  => s_rmap_spw_flag.receiver.valid,
			spw_mux_rx_0_status_o.rxhalff  => s_dummy_spw_mux_rx0_rxhalff,
			spw_mux_rx_0_status_o.rxflag   => s_rmap_spw_flag.receiver.flag,
			spw_mux_rx_0_status_o.rxdata   => s_rmap_spw_flag.receiver.data,
			spw_mux_tx_0_status_o.txrdy    => s_rmap_spw_flag.transmitter.ready,
			spw_mux_tx_0_status_o.txhalff  => s_dummy_spw_mux_tx0_txhalff,
			spw_mux_tx_1_status_o          => s_mux_tx_1_status,
			spw_mux_tx_2_status_o          => s_mux_tx_2_status
		);

	-- SpaceWire Controller Signals Assignments
	s_dcom_read_registers.spw_link_status_reg.spw_link_started                 <= spw_link_status_started_i;
	s_dcom_read_registers.spw_link_status_reg.spw_link_connecting              <= spw_link_status_connecting_i;
	s_dcom_read_registers.spw_link_status_reg.spw_link_running                 <= spw_link_status_running_i;
	s_dcom_read_registers.spw_link_status_reg.spw_err_disconnect               <= spw_link_error_errdisc_i;
	s_dcom_read_registers.spw_link_status_reg.spw_err_parity                   <= spw_link_error_errpar_i;
	s_dcom_read_registers.spw_link_status_reg.spw_err_escape                   <= spw_link_error_erresc_i;
	s_dcom_read_registers.spw_link_status_reg.spw_err_credit                   <= spw_link_error_errcred_i;
	s_rxtc_tick_out                                                            <= spw_timecode_rx_tick_out_i;
	s_dcom_read_registers.spw_timecode_status_reg.timecode_rx_control          <= spw_timecode_rx_ctrl_out_i;
	s_dcom_read_registers.spw_timecode_status_reg.timecode_rx_time             <= spw_timecode_rx_time_out_i;
	s_mux_rx_channel_status.rxvalid                                            <= spw_data_rx_status_rxvalid_i;
	s_mux_rx_channel_status.rxhalff                                            <= spw_data_rx_status_rxhalff_i;
	s_mux_rx_channel_status.rxflag                                             <= spw_data_rx_status_rxflag_i;
	s_mux_rx_channel_status.rxdata                                             <= spw_data_rx_status_rxdata_i;
	s_mux_tx_channel_status.txrdy                                              <= spw_data_tx_status_txrdy_i;
	s_mux_tx_channel_status.txhalff                                            <= spw_data_tx_status_txhalff_i;
	s_dcom_read_registers.spw_codec_errinj_status_reg.errinj_ctrl_errinj_busy  <= spw_errinj_ctrl_errinj_busy_i;
	s_dcom_read_registers.spw_codec_errinj_status_reg.errinj_ctrl_errinj_ready <= spw_errinj_ctrl_errinj_ready_i;
	spw_link_command_autostart_o                                               <= s_dcom_write_registers.spw_link_config_reg.spw_lnkcfg_autostart;
	spw_link_command_linkstart_o                                               <= s_dcom_write_registers.spw_link_config_reg.spw_lnkcfg_linkstart;
	spw_link_command_linkdis_o                                                 <= s_dcom_write_registers.spw_link_config_reg.spw_lnkcfg_disconnect;
	spw_link_command_txdivcnt_o                                                <= s_dcom_write_registers.spw_link_config_reg.spw_lnkcfg_txdivcnt;
	spw_timecode_tx_tick_in_o                                                  <= s_dcom_write_registers.spw_timecode_control_reg.timecode_tx_send;
	spw_timecode_tx_ctrl_in_o                                                  <= s_dcom_write_registers.spw_timecode_control_reg.timecode_tx_control;
	spw_timecode_tx_time_in_o                                                  <= s_dcom_write_registers.spw_timecode_control_reg.timecode_tx_time;
	spw_data_rx_command_rxread_o                                               <= s_mux_rx_channel_command.rxread;
	spw_data_tx_command_txwrite_o                                              <= s_mux_tx_channel_command.txwrite;
	spw_data_tx_command_txflag_o                                               <= s_mux_tx_channel_command.txflag;
	spw_data_tx_command_txdata_o                                               <= s_mux_tx_channel_command.txdata;
	spw_errinj_ctrl_start_errinj_o                                             <= s_dcom_write_registers.spw_codec_errinj_control_reg.errinj_ctrl_start_errinj;
	spw_errinj_ctrl_reset_errinj_o                                             <= s_dcom_write_registers.spw_codec_errinj_control_reg.errinj_ctrl_reset_errinj;
	spw_errinj_ctrl_errinj_code_o                                              <= s_dcom_write_registers.spw_codec_errinj_control_reg.errinj_ctrl_errinj_code;

	p_timecode_rx_flag_manager : process(a_avs_clock, a_reset) is
	begin
		if (a_reset = '1') then
			s_dcom_read_registers.spw_timecode_status_reg.timecode_rx_received <= '0';
		elsif rising_edge(a_avs_clock) then
			-- check if a command to to clear the timecode received flag was received
			if (s_dcom_write_registers.spw_timecode_control_reg.timecode_rx_received_clear = '1') then
				s_dcom_read_registers.spw_timecode_status_reg.timecode_rx_received <= '0';
			end if;
			-- check if a timecode was received
			if (s_rxtc_tick_out = '1') then
				s_dcom_read_registers.spw_timecode_status_reg.timecode_rx_received <= '1';
			end if;
		end if;
	end process p_timecode_rx_flag_manager;

	p_dcom_tx_irq_manager : process(a_avs_clock, a_reset) is
	begin
		if (a_reset = '1') then
			s_dcom_read_registers.data_scheduler_irq_flags_reg.irq_tx_begin_flag <= '0';
			s_dcom_read_registers.data_scheduler_irq_flags_reg.irq_tx_end_flag   <= '0';
			s_txirq_tx_begin_delayed                                             <= '0';
			s_txirq_tx_ended_delayed                                             <= '0';
		elsif rising_edge(a_avs_clock) then
			-- flag clear
			if (s_dcom_write_registers.data_scheduler_irq_flags_clear_reg.irq_tx_begin_flag_clear = '1') then
				s_dcom_read_registers.data_scheduler_irq_flags_reg.irq_tx_begin_flag <= '0';
			end if;
			if (s_dcom_write_registers.data_scheduler_irq_flags_clear_reg.irq_tx_end_flag_clear = '1') then
				s_dcom_read_registers.data_scheduler_irq_flags_reg.irq_tx_end_flag <= '0';
			end if;
			-- check if the global interrupt is enabled
			if (s_dcom_write_registers.dcom_irq_control_reg.dcom_global_irq_en = '1') then
				if (s_dcom_write_registers.data_scheduler_irq_control_reg.irq_tx_begin_en = '1') then
					-- detect a rising edge in the signal
					if (((s_txirq_tx_begin_delayed = '0') and (s_dctrl_tx_begin = '1'))) then
						s_dcom_read_registers.data_scheduler_irq_flags_reg.irq_tx_begin_flag <= '1';
					end if;
				end if;
				if (s_dcom_write_registers.data_scheduler_irq_control_reg.irq_tx_end_en = '1') then
					-- detect a rising edge in the signal
					if (((s_txirq_tx_ended_delayed = '0') and (s_dctrl_tx_ended = '1'))) then
						s_dcom_read_registers.data_scheduler_irq_flags_reg.irq_tx_end_flag <= '1';
					end if;
				end if;
			end if;
			-- delay signals
			s_txirq_tx_begin_delayed <= s_dctrl_tx_begin;
			s_txirq_tx_ended_delayed <= s_dctrl_tx_ended;
		end if;
	end process p_dcom_tx_irq_manager;
	tx_interrupt_sender_irq_o <= ('0') when (a_reset = '1') else ((s_dcom_read_registers.data_scheduler_irq_flags_reg.irq_tx_begin_flag) or (s_dcom_read_registers.data_scheduler_irq_flags_reg.irq_tx_end_flag));

	-- DCOM Report IRQ Manager Instantiation
	dcom_rprt_irq_manager_ent_inst : entity work.dcom_rprt_irq_manager_ent
		port map(
			clk_i                                              => a_avs_clock,
			rst_i                                              => a_reset,
			irq_manager_stop_i                                 => '0',
			irq_manager_start_i                                => '1',
			global_irq_en_i                                    => s_dcom_write_registers.dcom_irq_control_reg.dcom_global_irq_en,
			irq_watches_i.rprt_spw_link_running                => s_dcom_read_registers.spw_link_status_reg.spw_link_running,
			irq_watches_i.rprt_spw_err_disconnect              => s_dcom_read_registers.spw_link_status_reg.spw_err_disconnect,
			irq_watches_i.rprt_spw_err_parity                  => s_dcom_read_registers.spw_link_status_reg.spw_err_parity,
			irq_watches_i.rprt_spw_err_escape                  => s_dcom_read_registers.spw_link_status_reg.spw_err_escape,
			irq_watches_i.rprt_spw_err_credit                  => s_dcom_read_registers.spw_link_status_reg.spw_err_credit,
			irq_watches_i.rprt_rx_timecode_received            => s_dcom_read_registers.spw_timecode_status_reg.timecode_rx_received,
			irq_watches_i.rprt_rmap_err_early_eop              => s_dcom_read_registers.rmap_codec_status_reg.rmap_err_early_eop,
			irq_watches_i.rprt_rmap_err_eep                    => s_dcom_read_registers.rmap_codec_status_reg.rmap_err_eep,
			irq_watches_i.rprt_rmap_err_header_crc             => s_dcom_read_registers.rmap_codec_status_reg.rmap_err_header_crc,
			irq_watches_i.rprt_rmap_err_unused_packet_type     => s_dcom_read_registers.rmap_codec_status_reg.rmap_err_unused_packet_type,
			irq_watches_i.rprt_rmap_err_invalid_command_code   => s_dcom_read_registers.rmap_codec_status_reg.rmap_err_invalid_command_code,
			irq_watches_i.rprt_rmap_err_too_much_data          => s_dcom_read_registers.rmap_codec_status_reg.rmap_err_too_much_data,
			irq_watches_i.rprt_rmap_err_invalid_data_crc       => s_dcom_read_registers.rmap_codec_status_reg.rmap_err_invalid_data_crc,
			irq_flags_en_i.rprt_spw_link_connected             => s_dcom_write_registers.report_irq_control_reg.irq_rprt_spw_link_connected_en,
			irq_flags_en_i.rprt_spw_link_disconnected          => s_dcom_write_registers.report_irq_control_reg.irq_rprt_spw_link_disconnected_en,
			irq_flags_en_i.rprt_spw_err_disconnect             => s_dcom_write_registers.report_irq_control_reg.irq_rprt_spw_err_disconnect_en,
			irq_flags_en_i.rprt_spw_err_parity                 => s_dcom_write_registers.report_irq_control_reg.irq_rprt_spw_err_parity_en,
			irq_flags_en_i.rprt_spw_err_escape                 => s_dcom_write_registers.report_irq_control_reg.irq_rprt_spw_err_escape_en,
			irq_flags_en_i.rprt_spw_err_credit                 => s_dcom_write_registers.report_irq_control_reg.irq_rprt_spw_err_credit_en,
			irq_flags_en_i.rprt_rx_timecode_received           => s_dcom_write_registers.report_irq_control_reg.irq_rprt_rx_timecode_received_en,
			irq_flags_en_i.rprt_rmap_err_early_eop             => s_dcom_write_registers.report_irq_control_reg.irq_rprt_rmap_err_early_eop_en,
			irq_flags_en_i.rprt_rmap_err_eep                   => s_dcom_write_registers.report_irq_control_reg.irq_rprt_rmap_err_eep_en,
			irq_flags_en_i.rprt_rmap_err_header_crc            => s_dcom_write_registers.report_irq_control_reg.irq_rprt_rmap_err_header_crc_en,
			irq_flags_en_i.rprt_rmap_err_unused_packet_type    => s_dcom_write_registers.report_irq_control_reg.irq_rprt_rmap_err_unused_packet_type_en,
			irq_flags_en_i.rprt_rmap_err_invalid_command_code  => s_dcom_write_registers.report_irq_control_reg.irq_rprt_rmap_err_invalid_command_code_en,
			irq_flags_en_i.rprt_rmap_err_too_much_data         => s_dcom_write_registers.report_irq_control_reg.irq_rprt_rmap_err_too_much_data_en,
			irq_flags_en_i.rprt_rmap_err_invalid_data_crc      => s_dcom_write_registers.report_irq_control_reg.irq_rprt_rmap_err_invalid_data_crc_en,
			irq_flags_clr_i.rprt_spw_link_connected            => s_dcom_write_registers.report_irq_flags_clear_reg.irq_rprt_spw_link_connected_flag_clear,
			irq_flags_clr_i.rprt_spw_link_disconnected         => s_dcom_write_registers.report_irq_flags_clear_reg.irq_rprt_spw_link_disconnected_flag_clear,
			irq_flags_clr_i.rprt_spw_err_disconnect            => s_dcom_write_registers.report_irq_flags_clear_reg.irq_rprt_spw_err_disconnect_flag_clear,
			irq_flags_clr_i.rprt_spw_err_parity                => s_dcom_write_registers.report_irq_flags_clear_reg.irq_rprt_spw_err_parity_flag_clear,
			irq_flags_clr_i.rprt_spw_err_escape                => s_dcom_write_registers.report_irq_flags_clear_reg.irq_rprt_spw_err_escape_flag_clear,
			irq_flags_clr_i.rprt_spw_err_credit                => s_dcom_write_registers.report_irq_flags_clear_reg.irq_rprt_spw_err_credit_flag_clear,
			irq_flags_clr_i.rprt_rx_timecode_received          => s_dcom_write_registers.report_irq_flags_clear_reg.irq_rprt_rx_timecode_received_flag_clear,
			irq_flags_clr_i.rprt_rmap_err_early_eop            => s_dcom_write_registers.report_irq_flags_clear_reg.irq_rprt_rmap_err_early_eop_flag_clear,
			irq_flags_clr_i.rprt_rmap_err_eep                  => s_dcom_write_registers.report_irq_flags_clear_reg.irq_rprt_rmap_err_eep_flag_clear,
			irq_flags_clr_i.rprt_rmap_err_header_crc           => s_dcom_write_registers.report_irq_flags_clear_reg.irq_rprt_rmap_err_header_crc_flag_clear,
			irq_flags_clr_i.rprt_rmap_err_unused_packet_type   => s_dcom_write_registers.report_irq_flags_clear_reg.irq_rprt_rmap_err_unused_packet_type_flag_clear,
			irq_flags_clr_i.rprt_rmap_err_invalid_command_code => s_dcom_write_registers.report_irq_flags_clear_reg.irq_rprt_rmap_err_invalid_command_code_flag_clear,
			irq_flags_clr_i.rprt_rmap_err_too_much_data        => s_dcom_write_registers.report_irq_flags_clear_reg.irq_rprt_rmap_err_too_much_data_flag_clear,
			irq_flags_clr_i.rprt_rmap_err_invalid_data_crc     => s_dcom_write_registers.report_irq_flags_clear_reg.irq_rprt_rmap_err_invalid_data_crc_flag_clear,
			irq_flags_o.rprt_spw_link_connected                => s_dcom_read_registers.report_irq_flags_reg.irq_rprt_spw_link_connected_flag,
			irq_flags_o.rprt_spw_link_disconnected             => s_dcom_read_registers.report_irq_flags_reg.irq_rprt_spw_link_disconnected_flag,
			irq_flags_o.rprt_spw_err_disconnect                => s_dcom_read_registers.report_irq_flags_reg.irq_rprt_spw_err_disconnect_flag,
			irq_flags_o.rprt_spw_err_parity                    => s_dcom_read_registers.report_irq_flags_reg.irq_rprt_spw_err_parity_flag,
			irq_flags_o.rprt_spw_err_escape                    => s_dcom_read_registers.report_irq_flags_reg.irq_rprt_spw_err_escape_flag,
			irq_flags_o.rprt_spw_err_credit                    => s_dcom_read_registers.report_irq_flags_reg.irq_rprt_spw_err_credit_flag,
			irq_flags_o.rprt_rx_timecode_received              => s_dcom_read_registers.report_irq_flags_reg.irq_rprt_rx_timecode_received_flag,
			irq_flags_o.rprt_rmap_err_early_eop                => s_dcom_read_registers.report_irq_flags_reg.irq_rprt_rmap_err_early_eop_flag,
			irq_flags_o.rprt_rmap_err_eep                      => s_dcom_read_registers.report_irq_flags_reg.irq_rprt_rmap_err_eep_flag,
			irq_flags_o.rprt_rmap_err_header_crc               => s_dcom_read_registers.report_irq_flags_reg.irq_rprt_rmap_err_header_crc_flag,
			irq_flags_o.rprt_rmap_err_unused_packet_type       => s_dcom_read_registers.report_irq_flags_reg.irq_rprt_rmap_err_unused_packet_type_flag,
			irq_flags_o.rprt_rmap_err_invalid_command_code     => s_dcom_read_registers.report_irq_flags_reg.irq_rprt_rmap_err_invalid_command_code_flag,
			irq_flags_o.rprt_rmap_err_too_much_data            => s_dcom_read_registers.report_irq_flags_reg.irq_rprt_rmap_err_too_much_data_flag,
			irq_flags_o.rprt_rmap_err_invalid_data_crc         => s_dcom_read_registers.report_irq_flags_reg.irq_rprt_rmap_err_invalid_data_crc_flag,
			irq_o                                              => rprt_interrupt_sender_irq_o
		);

	-- Sync In Trigger Generator
	p_sync_in_triger : process(a_avs_clock, a_reset) is
	begin
		if (a_reset) = '1' then
			s_sync_in_trigger <= '0';
			s_sync_in_delayed <= '1';
		elsif rising_edge(a_avs_clock) then
			-- trigger signal
			s_sync_in_trigger <= '0';
			-- edge detection
			if ((s_sync_in_delayed = '0') and (s_sync_channel_i_n = '1')) then
				s_sync_in_trigger <= '1';
			end if;
			-- delay signals
			s_sync_in_delayed <= s_sync_channel_i_n;
		end if;
	end process p_sync_in_triger;

	-- SpaceWire Codec Dummy Reader
	p_spw_codec_dummy_read : process(a_avs_clock, a_reset) is
	begin
		if (a_reset = '1') then
			s_spw_dummy_rxread <= '0';
		elsif rising_edge(a_avs_clock) then
			s_spw_dummy_rxread <= '0';
			if (s_spw_dummy_rxvalid = '1') then
				s_spw_dummy_rxread <= '1';
			end if;
		end if;
	end process p_spw_codec_dummy_read;

end architecture rtl;                   -- of dcom_v2_top
