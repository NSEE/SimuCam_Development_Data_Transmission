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
		avalon_slave_data_buffer_address     : in  std_logic_vector(11 downto 0) := (others => '0'); -- avalon_slave_data_buffer.address
		avalon_slave_data_buffer_write       : in  std_logic                     := '0'; --          --                         .write
		avalon_slave_data_buffer_writedata   : in  std_logic_vector(63 downto 0) := (others => '0'); --                         .writedata
		avalon_slave_data_buffer_byteenable  : in  std_logic_vector(7 downto 0)  := (others => '0'); --                         .byteenable
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

	-- Alias --

	-- Common Ports Alias
	alias a_spw_clock is clock_sink_200_clk;
	alias a_avs_clock is clock_sink_100_clk;
	alias a_reset is reset_sink_reset;

	-- Signals --

	-- DCOM Avalon MM Read Signals
	signal s_dcom_avalon_mm_read_waitrequest : std_logic;

	-- DCOM Avalon MM Write Signals
	signal s_dcom_avalon_mm_write_waitrequest : std_logic;

	-- DCOM Avalon MM Registers Signals
	signal s_dcom_write_registers : t_dcom_write_registers;
	signal s_dcom_read_registers  : t_dcom_read_registers;

	-- Data Buffer Signals
	signal s_avs_dbuffer_wrdata   : std_logic_vector((c_AVS_DBUFFER_DATA_WIDTH - 1) downto 0);
	signal s_avs_dbuffer_wrreq    : std_logic;
	signal s_avs_dbuffer_full     : std_logic;
	signal s_avs_bebuffer_wrdata  : std_logic_vector((c_AVS_BEBUFFER_DATA_WIDTH - 1) downto 0);
	signal s_avs_bebuffer_wrreq   : std_logic;
	signal s_avs_bebuffer_full    : std_logic;
	signal s_dcrtl_dbuffer_rddata : std_logic_vector((c_DCTRL_DBUFFER_DATA_WIDTH - 1) downto 0);
	signal s_dcrtl_dbuffer_rdreq  : std_logic;
	signal s_dcrtl_dbuffer_empty  : std_logic;

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
	signal s_sync_channel_n : std_logic;

	-- Spw Codec Rx Dummy Reader Signals
	signal s_spw_dummy_rxvalid : std_logic;
	signal s_spw_dummy_rxread  : std_logic;

begin

	-- Sync Polarity Fix Assignments (timing issues, need to be changed)
	s_sync_channel_n <= not sync_channel;

	-- DCOM Avalon MM Read Instantiation
	avalon_mm_dcom_read_ent_inst : entity work.avalon_mm_dcom_read_ent
		port map(
			clk_i                        => a_avs_clock,
			rst_i                        => a_reset,
			avalon_mm_dcom_i.address     => avalon_slave_dcom_address,
			avalon_mm_dcom_i.read        => avalon_slave_dcom_read,
			dcom_write_registers_i       => s_dcom_write_registers,
			dcom_read_registers_i        => s_dcom_read_registers,
			avalon_mm_dcom_o.readdata    => avalon_slave_dcom_readdata,
			avalon_mm_dcom_o.waitrequest => s_dcom_avalon_mm_read_waitrequest
		);

	-- DCOM Avalon MM Write Instantiation
	avalon_mm_dcom_write_ent_inst : entity work.avalon_mm_dcom_write_ent
		port map(
			clk_i                        => a_avs_clock,
			rst_i                        => a_reset,
			avalon_mm_dcom_i.address     => avalon_slave_dcom_address,
			avalon_mm_dcom_i.write       => avalon_slave_dcom_write,
			avalon_mm_dcom_i.writedata   => avalon_slave_dcom_writedata,
			avalon_mm_dcom_o.waitrequest => s_dcom_avalon_mm_write_waitrequest,
			dcom_write_registers_o       => s_dcom_write_registers
		);

	-- DCOM Avalon MM Signals Assignments
	avalon_slave_dcom_waitrequest <= ('1') when (a_reset = '1') else ((s_dcom_avalon_mm_write_waitrequest) and (s_dcom_avalon_mm_read_waitrequest));

	-- Data Buffer Avalon MM Write Instantiation
	avalon_mm_data_buffer_write_ent_inst : entity work.avalon_mm_data_buffer_write_ent
		port map(
			clk_i                               => a_avs_clock,
			rst_i                               => a_reset,
			avalon_mm_data_buffer_i.address     => avalon_slave_data_buffer_address,
			avalon_mm_data_buffer_i.write       => avalon_slave_data_buffer_write,
			avalon_mm_data_buffer_i.writedata   => avalon_slave_data_buffer_writedata,
			avalon_mm_data_buffer_i.byteenable  => avalon_slave_data_buffer_byteenable,
			avs_dbuffer_full_i                  => s_avs_dbuffer_full,
			avs_bebuffer_full_i                 => s_avs_bebuffer_full,
			avalon_mm_data_buffer_o.waitrequest => avalon_slave_data_buffer_waitrequest,
			avs_dbuffer_wrreq_o                 => s_avs_dbuffer_wrreq,
			avs_dbuffer_wrdata_o                => s_avs_dbuffer_wrdata,
			avs_bebuffer_wrreq_o                => s_avs_bebuffer_wrreq,
			avs_bebuffer_wrdata_o               => s_avs_bebuffer_wrdata
		);

	-- Data Buffer Instantiation
	data_buffer_ent_inst : entity work.data_buffer_ent
		port map(
			clk_i                  => a_avs_clock,
			rst_i                  => a_reset,
			tmr_clear_i            => s_dcom_write_registers.data_scheduler_timer_control_reg.timer_clear,
			tmr_stop_i             => s_dcom_write_registers.data_scheduler_timer_control_reg.timer_stop,
			tmr_start_i            => s_dcom_write_registers.data_scheduler_timer_control_reg.timer_start,
			avs_dbuffer_wrdata_i   => s_avs_dbuffer_wrdata,
			avs_dbuffer_wrreq_i    => s_avs_dbuffer_wrreq,
			avs_bebuffer_wrdata_i  => s_avs_bebuffer_wrdata,
			avs_bebuffer_wrreq_i   => s_avs_bebuffer_wrreq,
			dcrtl_dbuffer_rdreq_i  => s_dcrtl_dbuffer_rdreq,
			dbuff_empty_o          => s_dcom_read_registers.data_buffers_status_reg.data_buffer_empty,
			dbuff_full_o           => s_dcom_read_registers.data_buffers_status_reg.data_buffer_full,
			dbuff_usedw_o          => s_dcom_read_registers.data_buffers_status_reg.data_buffer_used,
			avs_dbuffer_full_o     => s_avs_dbuffer_full,
			avs_bebuffer_full_o    => s_avs_bebuffer_full,
			dcrtl_dbuffer_rddata_o => s_dcrtl_dbuffer_rddata,
			dcrtl_dbuffer_empty_o  => s_dcrtl_dbuffer_empty
		);

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
			tmr_time_i       => s_dcom_read_registers.data_scheduler_timer_time_out_reg.timer_time_out,
			tmr_clear_i      => s_dcom_write_registers.data_scheduler_timer_control_reg.timer_clear,
			tmr_stop_i       => s_dcom_write_registers.data_scheduler_timer_control_reg.timer_stop,
			tmr_start_i      => s_dcom_write_registers.data_scheduler_timer_control_reg.timer_start,
			dctrl_send_eep_i => s_dcom_write_registers.data_controller_config_reg.send_eep,
			dctrl_send_eop_i => s_dcom_write_registers.data_controller_config_reg.send_eop,
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
			tmr_run_on_sync_i => s_dcom_write_registers.data_scheduler_timer_config_reg.timer_start_on_sync,
			tmr_clk_div_i     => s_dcom_write_registers.data_scheduler_timer_clkdiv_reg.timer_clk_div,
			tmr_time_in_i     => s_dcom_write_registers.data_scheduler_timer_time_in_reg.timer_time_in,
			tmr_clear_i       => s_dcom_write_registers.data_scheduler_timer_control_reg.timer_clear,
			tmr_stop_i        => s_dcom_write_registers.data_scheduler_timer_control_reg.timer_stop,
			tmr_run_i         => s_dcom_write_registers.data_scheduler_timer_control_reg.timer_run,
			tmr_start_i       => s_dcom_write_registers.data_scheduler_timer_control_reg.timer_start,
			sync_i            => s_sync_in_trigger,
			tmr_cleared_o     => s_dcom_read_registers.data_scheduler_timer_status_reg.timer_cleared,
			tmr_running_o     => s_dcom_read_registers.data_scheduler_timer_status_reg.timer_running,
			tmr_started_o     => s_dcom_read_registers.data_scheduler_timer_status_reg.timer_started,
			tmr_stopped_o     => s_dcom_read_registers.data_scheduler_timer_status_reg.timer_stopped,
			tmr_time_out_o    => s_dcom_read_registers.data_scheduler_timer_time_out_reg.timer_time_out
		);

	-- SpaceWire Signals Assignments
	s_spw_codec_link_command_clk100.autostart                     <= s_dcom_write_registers.spw_link_config_reg.spw_lnkcfg_autostart;
	s_spw_codec_link_command_clk100.linkstart                     <= s_dcom_write_registers.spw_link_config_reg.spw_lnkcfg_linkstart;
	s_spw_codec_link_command_clk100.linkdis                       <= s_dcom_write_registers.spw_link_config_reg.spw_lnkcfg_disconnect;
	s_spw_codec_link_command_clk100.txdivcnt                      <= s_dcom_write_registers.spw_link_config_reg.spw_lnkcfg_txdivcnt;
	s_dcom_read_registers.spw_link_status_reg.spw_link_started    <= s_spw_codec_link_status_clk100.started;
	s_dcom_read_registers.spw_link_status_reg.spw_link_connecting <= s_spw_codec_link_status_clk100.connecting;
	s_dcom_read_registers.spw_link_status_reg.spw_link_running    <= s_spw_codec_link_status_clk100.running;
	s_dcom_read_registers.spw_link_status_reg.spw_err_disconnect  <= s_spw_codec_link_error_clk100.errdisc;
	s_dcom_read_registers.spw_link_status_reg.spw_err_parity      <= s_spw_codec_link_error_clk100.errpar;
	s_dcom_read_registers.spw_link_status_reg.spw_err_escape      <= s_spw_codec_link_error_clk100.erresc;
	s_dcom_read_registers.spw_link_status_reg.spw_err_credit      <= s_spw_codec_link_error_clk100.errcred;
	s_rxtc_tick_out                                               <= s_spw_codec_timecode_rx_clk100.tick_out;
	s_dcom_read_registers.spw_timecode_rx_reg.timecode_rx_control <= s_spw_codec_timecode_rx_clk100.ctrl_out;
	s_dcom_read_registers.spw_timecode_rx_reg.timecode_rx_time    <= s_spw_codec_timecode_rx_clk100.time_out;
	s_spw_dummy_rxvalid                                           <= s_spw_codec_data_rx_status_clk100.rxvalid;
	--	s_spw_codec_data_rx_status_clk100.rxhalff;
	--	s_spw_codec_data_rx_status_clk100.rxflag;
	--	s_spw_codec_data_rx_status_clk100.rxdata;
	s_dctrl_spw_tx_ready                                          <= s_spw_codec_data_tx_status_clk100.txrdy;
	--	s_spw_codec_data_tx_status_clk100.txhalff;
	s_spw_codec_timecode_tx_clk100.tick_in                        <= s_dcom_write_registers.spw_timecode_tx_rxctrl_reg.timecode_tx_send;
	s_spw_codec_timecode_tx_clk100.ctrl_in                        <= s_dcom_write_registers.spw_timecode_tx_rxctrl_reg.timecode_tx_control;
	s_spw_codec_timecode_tx_clk100.time_in                        <= s_dcom_write_registers.spw_timecode_tx_rxctrl_reg.timecode_tx_time;
	s_spw_codec_data_rx_command_clk100.rxread                     <= s_spw_dummy_rxread;
	s_spw_codec_data_tx_command_clk100.txwrite                    <= s_dctrl_spw_tx_write;
	s_spw_codec_data_tx_command_clk100.txflag                     <= s_dctrl_spw_tx_flag;
	s_spw_codec_data_tx_command_clk100.txdata                     <= s_dctrl_spw_tx_data;

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

	p_timecode_rx_flag_manager : process(a_avs_clock, a_reset) is
	begin
		if (a_reset = '1') then
			s_dcom_read_registers.spw_timecode_rx_reg.timecode_rx_received <= '0';
		elsif rising_edge(a_avs_clock) then
			-- check if a command to to clear the timecode received flag was received
			if (s_dcom_write_registers.spw_timecode_tx_rxctrl_reg.timecode_rx_received_clr = '1') then
				s_dcom_read_registers.spw_timecode_rx_reg.timecode_rx_received <= '0';
			end if;
			-- check if a timecode was received
			if (s_rxtc_tick_out = '1') then
				s_dcom_read_registers.spw_timecode_rx_reg.timecode_rx_received <= '1';
			end if;
		end if;
	end process p_timecode_rx_flag_manager;

	p_dcom_tx_irq_manager : process(a_avs_clock, a_reset) is
	begin
		if (a_reset = '1') then
			s_dcom_read_registers.dcom_irq_flags_reg.dcom_tx_begin_flag <= '0';
			s_dcom_read_registers.dcom_irq_flags_reg.dcom_tx_end_flag   <= '0';
			s_txirq_tx_begin_delayed                                    <= '0';
			s_txirq_tx_ended_delayed                                    <= '0';
		elsif rising_edge(a_avs_clock) then
			-- flag clear
			if (s_dcom_write_registers.dcom_irq_flags_clear_reg.dcom_tx_begin_flag_clear = '1') then
				s_dcom_read_registers.dcom_irq_flags_reg.dcom_tx_begin_flag <= '0';
			end if;
			if (s_dcom_write_registers.dcom_irq_flags_clear_reg.dcom_tx_end_flag_clear = '1') then
				s_dcom_read_registers.dcom_irq_flags_reg.dcom_tx_end_flag <= '0';
			end if;
			-- check if the global interrupt is enabled
			if (s_dcom_write_registers.dcom_irq_control_reg.dcom_global_irq_en = '1') then
				if (s_dcom_write_registers.dcom_irq_control_reg.dcom_tx_begin_en = '1') then
					-- detect a rising edge in the signal
					if (((s_txirq_tx_begin_delayed = '0') and (s_dctrl_tx_begin = '1'))) then
						s_dcom_read_registers.dcom_irq_flags_reg.dcom_tx_begin_flag <= '1';
					end if;
				end if;
				if (s_dcom_write_registers.dcom_irq_control_reg.dcom_tx_end_en = '1') then
					-- detect a rising edge in the signal
					if (((s_txirq_tx_ended_delayed = '0') and (s_dctrl_tx_ended = '1'))) then
						s_dcom_read_registers.dcom_irq_flags_reg.dcom_tx_end_flag <= '1';
					end if;
				end if;
			end if;
			-- delay signals
			s_txirq_tx_begin_delayed <= s_dctrl_tx_begin;
			s_txirq_tx_ended_delayed <= s_dctrl_tx_ended;
		end if;
	end process p_dcom_tx_irq_manager;
	tx_interrupt_sender_irq <= ('0') when (a_reset = '1') else ((s_dcom_read_registers.dcom_irq_flags_reg.dcom_tx_begin_flag) or (s_dcom_read_registers.dcom_irq_flags_reg.dcom_tx_end_flag));

	-- Sync In Trigger Generator
	p_sync_in_triger : process(a_avs_clock, a_reset) is
	begin
		if (a_reset) = '1' then
			s_sync_in_trigger <= '0';
			s_sync_in_delayed <= '0';
		elsif rising_edge(a_avs_clock) then
			-- trigger signal
			s_sync_in_trigger <= '0';
			-- edge detection
			if ((s_sync_in_delayed = '0') and (s_sync_channel_n = '1')) then
				s_sync_in_trigger <= '1';
			end if;
			-- delay signals
			s_sync_in_delayed <= s_sync_channel_n;
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

end architecture rtl;                   -- of dcom_v1_top
