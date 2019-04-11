-- dcom_v1_top.vhd

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
use work.avalon_mm_data_buffer_pkg.all;
use work.data_buffer_pkg.all;
use work.spw_codec_pkg.all;

entity dcom_v1_top is
	port(
		reset_sink_reset                     : in  std_logic                     := '0'; --          --               reset_sink.reset
		data_in                              : in  std_logic                     := '0'; --          --          spw_conduit_end.data_in_signal
		data_out                             : out std_logic; --                                     --                         .data_out_signal
		strobe_in                            : in  std_logic                     := '0'; --          --                         .strobe_in_signal
		strobe_out                           : out std_logic; --                                     --                         .strobe_out_signal
		sync_channel                         : in  std_logic                     := '0'; --          --         sync_conduit_end.sync_channel_signal
		clock_sink_100_clk                   : in  std_logic                     := '0'; --          --           clock_sink_100.clk
		clock_sink_200_clk                   : in  std_logic                     := '0'; --          --           clock_sink_200.clk
		avalon_slave_data_buffer_address     : in  std_logic_vector(9 downto 0)  := (others => '0'); -- avalon_slave_data_buffer.address
		avalon_slave_data_buffer_write       : in  std_logic                     := '0'; --          --                         .write
		avalon_slave_data_buffer_writedata   : in  std_logic_vector(63 downto 0) := (others => '0'); --                         .writedata
		avalon_slave_data_buffer_waitrequest : out std_logic; --                                     --                         .waitrequest
		avalon_slave_dcom_address            : in  std_logic_vector(7 downto 0)  := (others => '0'); --        avalon_slave_dcom.address
		avalon_slave_dcom_write              : in  std_logic                     := '0'; --          --                         .write
		avalon_slave_dcom_read               : in  std_logic                     := '0'; --          --                         .read
		avalon_slave_dcom_readdata           : out std_logic_vector(31 downto 0); --                 --                         .readdata
		avalon_slave_dcom_writedata          : in  std_logic_vector(31 downto 0) := (others => '0'); --                         .writedata
		avalon_slave_dcom_waitrequest        : out std_logic; --                                     --                         .waitrequest
		tx_interrupt_sender_irq              : out std_logic --                                      --      tx_interrupt_sender.irq
	);
end entity dcom_v1_top;

architecture rtl of dcom_v1_top is

	-- alias for commom ports
	alias a_spw_clock is clock_sink_200_clk;
	alias a_avs_clock is clock_sink_100_clk;
	alias a_reset is reset_sink_reset;

	-- dummy ports

	-- signals

	-- interrupt edge detection signals

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

	-- timecode manager
	signal s_timecode_tick    : std_logic;
	signal s_timecode_control : std_logic_vector(1 downto 0);
	signal s_timecode_counter : std_logic_vector(5 downto 0);
	signal s_current_timecode : std_logic_vector(7 downto 0);

	-- sync edge detection
	signal s_sync_in_trigger : std_logic;
	signal s_sync_in_delayed : std_logic;

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

	-- dummy
	signal s_dummy_spw_mux_tx0_txhalff  : std_logic;
	signal s_dummy_timecode_rx_tick_out : std_logic;
	signal s_dummy_timecode_rx_ctrl_out : std_logic_vector(1 downto 0);
	signal s_dummy_timecode_rx_time_out : std_logic_vector(5 downto 0);

	-- sync_in polarity fix (timing issues, need to be improved!!!)
	signal s_sync_channel_n : std_logic;

begin

	-- DCOM Avalon MM Read Instantiation
	avalon_mm_dcom_read_ent_inst : entity work.avalon_mm_dcom_read_ent
		port map(
			clk_i                  => a_avs_clock,
			rst_i                  => a_reset,
			avalon_mm_dcom_i       => avalon_mm_dcom_i,
			dcom_write_registers_i => dcom_write_registers_i,
			dcom_read_registers_i  => dcom_read_registers_i,
			avalon_mm_dcom_o       => avalon_mm_dcom_o
		);

	-- DCOM Avalon MM Write Instantiation
	avalon_mm_dcom_write_ent_inst : entity work.avalon_mm_dcom_write_ent
		port map(
			clk_i                  => a_avs_clock,
			rst_i                  => a_reset,
			avalon_mm_dcom_i       => avalon_mm_dcom_i,
			avalon_mm_dcom_o       => avalon_mm_dcom_o,
			dcom_write_registers_o => dcom_write_registers_o
		);

	-- Data Buffer Avalon MM Write Instantiation
	avalon_mm_data_buffer_write_ent_inst : entity work.avalon_mm_data_buffer_write_ent
		port map(
			clk_i                   => a_avs_clock,
			rst_i                   => a_reset,
			avalon_mm_data_buffer_i => avalon_mm_data_buffer_i,
			avs_dbuffer_full_i      => avs_dbuffer_full_i,
			avs_bebuffer_full_i     => avs_bebuffer_full_i,
			avalon_mm_data_buffer_o => avalon_mm_data_buffer_o,
			avs_dbuffer_wrreq_o     => avs_dbuffer_wrreq_o,
			avs_dbuffer_wrdata_o    => avs_dbuffer_wrdata_o,
			avs_bebuffer_wrreq_o    => avs_bebuffer_wrreq_o,
			avs_bebuffer_wrdata_o   => avs_bebuffer_wrdata_o
		);

	-- Data Buffer Instantiation
	data_buffer_ent_inst : entity work.data_buffer_ent
		port map(
			clk_i                  => a_avs_clock,
			rst_i                  => a_reset,
			tmr_clear_i            => tmr_clear_i,
			tmr_stop_i             => tmr_stop_i,
			tmr_start_i            => tmr_start_i,
			avs_dbuffer_wrdata_i   => avs_dbuffer_wrdata_i,
			avs_dbuffer_wrreq_i    => avs_dbuffer_wrreq_i,
			avs_bebuffer_wrdata_i  => avs_bebuffer_wrdata_i,
			avs_bebuffer_wrreq_i   => avs_bebuffer_wrreq_i,
			dcrtl_dbuffer_rdreq_i  => dcrtl_dbuffer_rdreq_i,
			dbuff_empty_o          => dbuff_empty_o,
			dbuff_full_o           => dbuff_full_o,
			dbuff_usedw_o          => dbuff_usedw_o,
			avs_dbuffer_full_o     => avs_dbuffer_full_o,
			avs_bebuffer_full_o    => avs_bebuffer_full_o,
			dcrtl_dbuffer_rddata_o => dcrtl_dbuffer_rddata_o,
			dcrtl_dbuffer_empty_o  => dcrtl_dbuffer_empty_o
		);

	-- Data Controller Instantiation
	data_controller_ent_inst : entity work.data_controller_ent
		generic map(
			g_WORD_WIDTH        => g_WORD_WIDTH,
			g_DATA_LENGTH_WORDS => g_DATA_LENGTH_WORDS,
			g_DATA_TIME_WORDS   => g_DATA_TIME_WORDS
		)
		port map(
			clk_i            => a_avs_clock,
			rst_i            => a_reset,
			tmr_time_i       => tmr_time_i,
			tmr_stop_i       => tmr_stop_i,
			tmr_clear_i      => tmr_clear_i,
			tmr_start_i      => tmr_start_i,
			dctrl_send_eep_i => dctrl_send_eep_i,
			dctrl_send_eop_i => dctrl_send_eop_i,
			dbuffer_empty_i  => dbuffer_empty_i,
			dbuffer_rddata_i => dbuffer_rddata_i,
			spw_tx_ready_i   => spw_tx_ready_i,
			dctrl_tx_begin_o => dctrl_tx_begin_o,
			dctrl_tx_ended_o => dctrl_tx_ended_o,
			dbuffer_rdreq_o  => dbuffer_rdreq_o,
			spw_tx_write_o   => spw_tx_write_o,
			spw_tx_flag_o    => spw_tx_flag_o,
			spw_tx_data_o    => spw_tx_data_o
		);

	-- Data Scheduler Instantiation
	data_scheduler_ent_inst : entity work.data_scheduler_ent
		generic map(
			g_TIMER_CLKDIV_WIDTH => g_TIMER_CLKDIV_WIDTH,
			g_TIMER_TIME_WIDTH   => g_TIMER_TIME_WIDTH
		)
		port map(
			clk_i             => a_avs_clock,
			rst_i             => a_reset,
			tmr_run_on_sync_i => tmr_run_on_sync_i,
			tmr_clk_div_i     => tmr_clk_div_i,
			tmr_time_in_i     => tmr_time_in_i,
			tmr_clear_i       => tmr_clear_i,
			tmr_stop_i        => tmr_stop_i,
			tmr_run_i         => tmr_run_i,
			tmr_start_i       => tmr_start_i,
			sync_i            => sync_i,
			tmr_cleared_o     => tmr_cleared_o,
			tmr_running_o     => tmr_running_o,
			tmr_started_o     => tmr_started_o,
			tmr_stopped_o     => tmr_stopped_o,
			tmr_time_out_o    => tmr_time_out_o
		);

	-- SpaceWire Signals Assignments
	s_spw_codec_link_command_clk100.autostart;
	s_spw_codec_link_command_clk100.linkstart;
	s_spw_codec_link_command_clk100.linkdis;
	s_spw_codec_link_command_clk100.txdivcnt;
	s_spw_codec_link_status_clk100.started;
	s_spw_codec_link_status_clk100.connecting;
	s_spw_codec_link_status_clk100.running;
	s_spw_codec_link_error_clk100.errdisc;
	s_spw_codec_link_error_clk100.errpar;
	s_spw_codec_link_error_clk100.erresc;
	s_spw_codec_link_error_clk100.errcred;
	s_spw_codec_timecode_rx_clk100.tick_out;
	s_spw_codec_timecode_rx_clk100.ctrl_out;
	s_spw_codec_timecode_rx_clk100.time_out;
	s_spw_codec_data_rx_status_clk100.rxvalid;
	s_spw_codec_data_rx_status_clk100.rxhalff;
	s_spw_codec_data_rx_status_clk100.rxflag;
	s_spw_codec_data_rx_status_clk100.rxdata;
	s_spw_codec_data_tx_status_clk100.txrdy;
	s_spw_codec_data_tx_status_clk100.txhalff;
	s_spw_codec_timecode_tx_clk100.tick_in;
	s_spw_codec_timecode_tx_clk100.ctrl_in;
	s_spw_codec_timecode_tx_clk100.time_in;
	s_spw_codec_data_rx_command_clk100.rxread;
	s_spw_codec_data_tx_command_clk100.txwrite;
	s_spw_codec_data_tx_command_clk100.txflag;
	s_spw_codec_data_tx_command_clk100.txdata;

	-- SpaceWire Clock Synchronization Instantiation
	spw_clk_synchronization_ent_inst : entity work.spw_clk_synchronization_ent
		port map(
			clk_100_i                          => a_avs_clock,
			clk_200_i                          => a_spw_clock,
			rst_i                              => a_reset,
			spw_codec_link_command_clk100_i    => s_spw_codec_link_command_clk100,
			spw_codec_timecode_tx_clk100_i     => s_spw_codec_timecode_tx_clk100,
			spw_codec_data_rx_command_clk100_i => s_spw_codec_data_rx_command_clk100,
			spw_codec_data_tx_command_clk100_i => s_spw_codec_data_tx_command_clk100,
			spw_codec_link_status_clk200_i     => s_spw_codec_link_status_clk200,
			spw_codec_link_error_clk200_i      => s_spw_codec_link_error_clk200,
			spw_codec_timecode_rx_clk200_i     => s_spw_codec_timecode_rx_clk200,
			spw_codec_data_rx_status_clk200_i  => s_spw_codec_data_rx_status_clk200,
			spw_codec_data_tx_status_clk200_i  => s_spw_codec_data_tx_status_clk200,
			spw_codec_link_status_clk100_o     => s_spw_codec_link_status_clk100,
			spw_codec_link_error_clk100_o      => s_spw_codec_link_error_clk100,
			spw_codec_timecode_rx_clk100_o     => s_spw_codec_timecode_rx_clk100,
			spw_codec_data_rx_status_clk100_o  => s_spw_codec_data_rx_status_clk100,
			spw_codec_data_tx_status_clk100_o  => s_spw_codec_data_tx_status_clk100,
			spw_codec_link_command_clk200_o    => s_spw_codec_link_command_clk200,
			spw_codec_timecode_tx_clk200_o     => s_spw_codec_timecode_tx_clk200,
			spw_codec_data_rx_command_clk200_o => s_spw_codec_data_rx_command_clk200,
			spw_codec_data_tx_command_clk200_o => s_spw_codec_data_tx_command_clk200
		);

	-- SpaceWire Light Codec Instantiation
	spw_codec_ent_inst : entity work.spw_codec_ent
		port map(
			clk_200_i                         => a_spw_clock,
			rst_i                             => a_reset,
			spw_codec_link_command_i          => s_spw_codec_link_command_clk200,
			spw_codec_ds_encoding_rx_i.spw_di => data_in,
			spw_codec_ds_encoding_rx_i.spw_si => strobe_in,
			spw_codec_timecode_tx_i           => s_spw_codec_timecode_tx_clk200,
			spw_codec_data_rx_command_i       => s_spw_codec_data_rx_command_clk200,
			spw_codec_data_tx_command_i       => s_spw_codec_data_tx_command_clk200,
			spw_codec_link_status_o           => s_spw_codec_link_status_clk200,
			spw_codec_ds_encoding_tx_o.spw_do => data_out,
			spw_codec_ds_encoding_tx_o.spw_so => strobe_out,
			spw_codec_link_error_o            => s_spw_codec_link_error_clk200,
			spw_codec_timecode_rx_o           => s_spw_codec_timecode_rx_clk200,
			spw_codec_data_rx_status_o        => s_spw_codec_data_rx_status_clk200,
			spw_codec_data_tx_status_o        => s_spw_codec_data_tx_status_clk200
		);

end architecture rtl;                   -- of dcom_v1_top
