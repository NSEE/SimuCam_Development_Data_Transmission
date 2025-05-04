-- spwr_spacewire_router_top.vhd

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
use work.spwr_data_controller_pkg.all;
use work.spwr_crossbar_switch_pkg.all;

entity spwr_spacewire_router_top is
    port(
        reset_sink_reset_i                 : in  std_logic                    := '0'; --          --                       reset_sink.reset
        clock_sink_100_clk_i               : in  std_logic                    := '0'; --          --                   clock_sink_100.clk
        spw_ch1_link_status_started_i      : in  std_logic                    := '0'; --          -- conduit_end_spacewire_ch1_controller.spw_link_status_started_signal
        spw_ch1_link_status_connecting_i   : in  std_logic                    := '0'; --          --                                     .spw_link_status_connecting_signal
        spw_ch1_link_status_running_i      : in  std_logic                    := '0'; --          --                                     .spw_link_status_running_signal
        spw_ch1_link_error_errdisc_i       : in  std_logic                    := '0'; --          --                                     .spw_link_error_errdisc_signal
        spw_ch1_link_error_errpar_i        : in  std_logic                    := '0'; --          --                                     .spw_link_error_errpar_signal
        spw_ch1_link_error_erresc_i        : in  std_logic                    := '0'; --          --                                     .spw_link_error_erresc_signal
        spw_ch1_link_error_errcred_i       : in  std_logic                    := '0'; --          --                                     .spw_link_error_errcred_signal		
        spw_ch1_timecode_rx_tick_out_i     : in  std_logic                    := '0'; --          --                                     .spw_timecode_rx_tick_out_signal
        spw_ch1_timecode_rx_ctrl_out_i     : in  std_logic_vector(1 downto 0) := (others => '0'); --                                     .spw_timecode_rx_ctrl_out_signal
        spw_ch1_timecode_rx_time_out_i     : in  std_logic_vector(5 downto 0) := (others => '0'); --                                     .spw_timecode_rx_time_out_signal
        spw_ch1_data_rx_status_rxvalid_i   : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxvalid_signal
        spw_ch1_data_rx_status_rxhalff_i   : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxhalff_signal
        spw_ch1_data_rx_status_rxflag_i    : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxflag_signal
        spw_ch1_data_rx_status_rxdata_i    : in  std_logic_vector(7 downto 0) := (others => '0'); --                                     .spw_data_rx_status_rxdata_signal
        spw_ch1_data_tx_status_txrdy_i     : in  std_logic                    := '0'; --          --                                     .spw_data_tx_status_txrdy_signal
        spw_ch1_data_tx_status_txhalff_i   : in  std_logic                    := '0'; --          --                                     .spw_data_tx_status_txhalff_signal
        spw_ch1_errinj_ctrl_errinj_busy_i  : in  std_logic                    := '0'; --          --                                     .spw_errinj_ctrl_errinj_busy_signal
        spw_ch1_errinj_ctrl_errinj_ready_i : in  std_logic                    := '0'; --          --                                     .spw_errinj_ctrl_errinj_ready_signal
        spw_ch1_link_command_enable_o      : out std_logic; --                                     --                                     .spw_link_command_enable_signal
        spw_ch1_link_command_autostart_o   : out std_logic; --                                     --                                     .spw_link_command_autostart_signal
        spw_ch1_link_command_linkstart_o   : out std_logic; --                                     --                                     .spw_link_command_linkstart_signal
        spw_ch1_link_command_linkdis_o     : out std_logic; --                                     --                                     .spw_link_command_linkdis_signal
        spw_ch1_link_command_txdivcnt_o    : out std_logic_vector(7 downto 0); --                  --                                     .spw_link_command_txdivcnt_signal
        spw_ch1_timecode_tx_tick_in_o      : out std_logic; --                                     --                                     .spw_timecode_tx_tick_in_signal
        spw_ch1_timecode_tx_ctrl_in_o      : out std_logic_vector(1 downto 0); --                  --                                     .spw_timecode_tx_ctrl_in_signal
        spw_ch1_timecode_tx_time_in_o      : out std_logic_vector(5 downto 0); --                  --                                     .spw_timecode_tx_time_in_signal
        spw_ch1_data_rx_command_rxread_o   : out std_logic; --                                     --                                     .spw_data_rx_command_rxread_signal
        spw_ch1_data_tx_command_txwrite_o  : out std_logic; --                                     --                                     .spw_data_tx_command_txwrite_signal
        spw_ch1_data_tx_command_txflag_o   : out std_logic; --                                     --                                     .spw_data_tx_command_txflag_signal
        spw_ch1_data_tx_command_txdata_o   : out std_logic_vector(7 downto 0); --                  --                                     .spw_data_tx_command_txdata_signal
        spw_ch1_errinj_ctrl_start_errinj_o : out std_logic; --                                     --                                     .spw_errinj_ctrl_start_errinj_signal
        spw_ch1_errinj_ctrl_reset_errinj_o : out std_logic; --                                     --                                     .spw_errinj_ctrl_reset_errinj_signal
        spw_ch1_errinj_ctrl_errinj_code_o  : out std_logic_vector(3 downto 0); --                  --                                     .spw_errinj_ctrl_errinj_code_signal
        spw_ch2_link_status_started_i      : in  std_logic                    := '0'; --          -- conduit_end_spacewire_ch2_controller.spw_link_status_started_signal
        spw_ch2_link_status_connecting_i   : in  std_logic                    := '0'; --          --                                     .spw_link_status_connecting_signal
        spw_ch2_link_status_running_i      : in  std_logic                    := '0'; --          --                                     .spw_link_status_running_signal
        spw_ch2_link_error_errdisc_i       : in  std_logic                    := '0'; --          --                                     .spw_link_error_errdisc_signal
        spw_ch2_link_error_errpar_i        : in  std_logic                    := '0'; --          --                                     .spw_link_error_errpar_signal
        spw_ch2_link_error_erresc_i        : in  std_logic                    := '0'; --          --                                     .spw_link_error_erresc_signal
        spw_ch2_link_error_errcred_i       : in  std_logic                    := '0'; --          --                                     .spw_link_error_errcred_signal		
        spw_ch2_timecode_rx_tick_out_i     : in  std_logic                    := '0'; --          --                                     .spw_timecode_rx_tick_out_signal
        spw_ch2_timecode_rx_ctrl_out_i     : in  std_logic_vector(1 downto 0) := (others => '0'); --                                     .spw_timecode_rx_ctrl_out_signal
        spw_ch2_timecode_rx_time_out_i     : in  std_logic_vector(5 downto 0) := (others => '0'); --                                     .spw_timecode_rx_time_out_signal
        spw_ch2_data_rx_status_rxvalid_i   : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxvalid_signal
        spw_ch2_data_rx_status_rxhalff_i   : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxhalff_signal
        spw_ch2_data_rx_status_rxflag_i    : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxflag_signal
        spw_ch2_data_rx_status_rxdata_i    : in  std_logic_vector(7 downto 0) := (others => '0'); --                                     .spw_data_rx_status_rxdata_signal
        spw_ch2_data_tx_status_txrdy_i     : in  std_logic                    := '0'; --          --                                     .spw_data_tx_status_txrdy_signal
        spw_ch2_data_tx_status_txhalff_i   : in  std_logic                    := '0'; --          --                                     .spw_data_tx_status_txhalff_signal
        spw_ch2_errinj_ctrl_errinj_busy_i  : in  std_logic                    := '0'; --          --                                     .spw_errinj_ctrl_errinj_busy_signal
        spw_ch2_errinj_ctrl_errinj_ready_i : in  std_logic                    := '0'; --          --                                     .spw_errinj_ctrl_errinj_ready_signal
        spw_ch2_link_command_enable_o      : out std_logic; --                                     --                                     .spw_link_command_enable_signal
        spw_ch2_link_command_autostart_o   : out std_logic; --                                     --                                     .spw_link_command_autostart_signal
        spw_ch2_link_command_linkstart_o   : out std_logic; --                                     --                                     .spw_link_command_linkstart_signal
        spw_ch2_link_command_linkdis_o     : out std_logic; --                                     --                                     .spw_link_command_linkdis_signal
        spw_ch2_link_command_txdivcnt_o    : out std_logic_vector(7 downto 0); --                  --                                     .spw_link_command_txdivcnt_signal
        spw_ch2_timecode_tx_tick_in_o      : out std_logic; --                                     --                                     .spw_timecode_tx_tick_in_signal
        spw_ch2_timecode_tx_ctrl_in_o      : out std_logic_vector(1 downto 0); --                  --                                     .spw_timecode_tx_ctrl_in_signal
        spw_ch2_timecode_tx_time_in_o      : out std_logic_vector(5 downto 0); --                  --                                     .spw_timecode_tx_time_in_signal
        spw_ch2_data_rx_command_rxread_o   : out std_logic; --                                     --                                     .spw_data_rx_command_rxread_signal
        spw_ch2_data_tx_command_txwrite_o  : out std_logic; --                                     --                                     .spw_data_tx_command_txwrite_signal
        spw_ch2_data_tx_command_txflag_o   : out std_logic; --                                     --                                     .spw_data_tx_command_txflag_signal
        spw_ch2_data_tx_command_txdata_o   : out std_logic_vector(7 downto 0); --                  --                                     .spw_data_tx_command_txdata_signal
        spw_ch2_errinj_ctrl_start_errinj_o : out std_logic; --                                     --                                     .spw_errinj_ctrl_start_errinj_signal
        spw_ch2_errinj_ctrl_reset_errinj_o : out std_logic; --                                     --                                     .spw_errinj_ctrl_reset_errinj_signal
        spw_ch2_errinj_ctrl_errinj_code_o  : out std_logic_vector(3 downto 0); --                  --                                     .spw_errinj_ctrl_errinj_code_signal
        spw_ch3_link_status_started_i      : in  std_logic                    := '0'; --          -- conduit_end_spacewire_ch3_controller.spw_link_status_started_signal
        spw_ch3_link_status_connecting_i   : in  std_logic                    := '0'; --          --                                     .spw_link_status_connecting_signal
        spw_ch3_link_status_running_i      : in  std_logic                    := '0'; --          --                                     .spw_link_status_running_signal
        spw_ch3_link_error_errdisc_i       : in  std_logic                    := '0'; --          --                                     .spw_link_error_errdisc_signal
        spw_ch3_link_error_errpar_i        : in  std_logic                    := '0'; --          --                                     .spw_link_error_errpar_signal
        spw_ch3_link_error_erresc_i        : in  std_logic                    := '0'; --          --                                     .spw_link_error_erresc_signal
        spw_ch3_link_error_errcred_i       : in  std_logic                    := '0'; --          --                                     .spw_link_error_errcred_signal		
        spw_ch3_timecode_rx_tick_out_i     : in  std_logic                    := '0'; --          --                                     .spw_timecode_rx_tick_out_signal
        spw_ch3_timecode_rx_ctrl_out_i     : in  std_logic_vector(1 downto 0) := (others => '0'); --                                     .spw_timecode_rx_ctrl_out_signal
        spw_ch3_timecode_rx_time_out_i     : in  std_logic_vector(5 downto 0) := (others => '0'); --                                     .spw_timecode_rx_time_out_signal
        spw_ch3_data_rx_status_rxvalid_i   : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxvalid_signal
        spw_ch3_data_rx_status_rxhalff_i   : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxhalff_signal
        spw_ch3_data_rx_status_rxflag_i    : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxflag_signal
        spw_ch3_data_rx_status_rxdata_i    : in  std_logic_vector(7 downto 0) := (others => '0'); --                                     .spw_data_rx_status_rxdata_signal
        spw_ch3_data_tx_status_txrdy_i     : in  std_logic                    := '0'; --          --                                     .spw_data_tx_status_txrdy_signal
        spw_ch3_data_tx_status_txhalff_i   : in  std_logic                    := '0'; --          --                                     .spw_data_tx_status_txhalff_signal
        spw_ch3_errinj_ctrl_errinj_busy_i  : in  std_logic                    := '0'; --          --                                     .spw_errinj_ctrl_errinj_busy_signal
        spw_ch3_errinj_ctrl_errinj_ready_i : in  std_logic                    := '0'; --          --                                     .spw_errinj_ctrl_errinj_ready_signal
        spw_ch3_link_command_enable_o      : out std_logic; --                                     --                                     .spw_link_command_enable_signal
        spw_ch3_link_command_autostart_o   : out std_logic; --                                     --                                     .spw_link_command_autostart_signal
        spw_ch3_link_command_linkstart_o   : out std_logic; --                                     --                                     .spw_link_command_linkstart_signal
        spw_ch3_link_command_linkdis_o     : out std_logic; --                                     --                                     .spw_link_command_linkdis_signal
        spw_ch3_link_command_txdivcnt_o    : out std_logic_vector(7 downto 0); --                  --                                     .spw_link_command_txdivcnt_signal
        spw_ch3_timecode_tx_tick_in_o      : out std_logic; --                                     --                                     .spw_timecode_tx_tick_in_signal
        spw_ch3_timecode_tx_ctrl_in_o      : out std_logic_vector(1 downto 0); --                  --                                     .spw_timecode_tx_ctrl_in_signal
        spw_ch3_timecode_tx_time_in_o      : out std_logic_vector(5 downto 0); --                  --                                     .spw_timecode_tx_time_in_signal
        spw_ch3_data_rx_command_rxread_o   : out std_logic; --                                     --                                     .spw_data_rx_command_rxread_signal
        spw_ch3_data_tx_command_txwrite_o  : out std_logic; --                                     --                                     .spw_data_tx_command_txwrite_signal
        spw_ch3_data_tx_command_txflag_o   : out std_logic; --                                     --                                     .spw_data_tx_command_txflag_signal
        spw_ch3_data_tx_command_txdata_o   : out std_logic_vector(7 downto 0); --                  --                                     .spw_data_tx_command_txdata_signal
        spw_ch3_errinj_ctrl_start_errinj_o : out std_logic; --                                     --                                     .spw_errinj_ctrl_start_errinj_signal
        spw_ch3_errinj_ctrl_reset_errinj_o : out std_logic; --                                     --                                     .spw_errinj_ctrl_reset_errinj_signal
        spw_ch3_errinj_ctrl_errinj_code_o  : out std_logic_vector(3 downto 0); --                  --                                     .spw_errinj_ctrl_errinj_code_signal
        spw_ch4_link_status_started_i      : in  std_logic                    := '0'; --          -- conduit_end_spacewire_ch4_controller.spw_link_status_started_signal
        spw_ch4_link_status_connecting_i   : in  std_logic                    := '0'; --          --                                     .spw_link_status_connecting_signal
        spw_ch4_link_status_running_i      : in  std_logic                    := '0'; --          --                                     .spw_link_status_running_signal
        spw_ch4_link_error_errdisc_i       : in  std_logic                    := '0'; --          --                                     .spw_link_error_errdisc_signal
        spw_ch4_link_error_errpar_i        : in  std_logic                    := '0'; --          --                                     .spw_link_error_errpar_signal
        spw_ch4_link_error_erresc_i        : in  std_logic                    := '0'; --          --                                     .spw_link_error_erresc_signal
        spw_ch4_link_error_errcred_i       : in  std_logic                    := '0'; --          --                                     .spw_link_error_errcred_signal		
        spw_ch4_timecode_rx_tick_out_i     : in  std_logic                    := '0'; --          --                                     .spw_timecode_rx_tick_out_signal
        spw_ch4_timecode_rx_ctrl_out_i     : in  std_logic_vector(1 downto 0) := (others => '0'); --                                     .spw_timecode_rx_ctrl_out_signal
        spw_ch4_timecode_rx_time_out_i     : in  std_logic_vector(5 downto 0) := (others => '0'); --                                     .spw_timecode_rx_time_out_signal
        spw_ch4_data_rx_status_rxvalid_i   : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxvalid_signal
        spw_ch4_data_rx_status_rxhalff_i   : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxhalff_signal
        spw_ch4_data_rx_status_rxflag_i    : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxflag_signal
        spw_ch4_data_rx_status_rxdata_i    : in  std_logic_vector(7 downto 0) := (others => '0'); --                                     .spw_data_rx_status_rxdata_signal
        spw_ch4_data_tx_status_txrdy_i     : in  std_logic                    := '0'; --          --                                     .spw_data_tx_status_txrdy_signal
        spw_ch4_data_tx_status_txhalff_i   : in  std_logic                    := '0'; --          --                                     .spw_data_tx_status_txhalff_signal
        spw_ch4_errinj_ctrl_errinj_busy_i  : in  std_logic                    := '0'; --          --                                     .spw_errinj_ctrl_errinj_busy_signal
        spw_ch4_errinj_ctrl_errinj_ready_i : in  std_logic                    := '0'; --          --                                     .spw_errinj_ctrl_errinj_ready_signal
        spw_ch4_link_command_enable_o      : out std_logic; --                                     --                                     .spw_link_command_enable_signal
        spw_ch4_link_command_autostart_o   : out std_logic; --                                     --                                     .spw_link_command_autostart_signal
        spw_ch4_link_command_linkstart_o   : out std_logic; --                                     --                                     .spw_link_command_linkstart_signal
        spw_ch4_link_command_linkdis_o     : out std_logic; --                                     --                                     .spw_link_command_linkdis_signal
        spw_ch4_link_command_txdivcnt_o    : out std_logic_vector(7 downto 0); --                  --                                     .spw_link_command_txdivcnt_signal
        spw_ch4_timecode_tx_tick_in_o      : out std_logic; --                                     --                                     .spw_timecode_tx_tick_in_signal
        spw_ch4_timecode_tx_ctrl_in_o      : out std_logic_vector(1 downto 0); --                  --                                     .spw_timecode_tx_ctrl_in_signal
        spw_ch4_timecode_tx_time_in_o      : out std_logic_vector(5 downto 0); --                  --                                     .spw_timecode_tx_time_in_signal
        spw_ch4_data_rx_command_rxread_o   : out std_logic; --                                     --                                     .spw_data_rx_command_rxread_signal
        spw_ch4_data_tx_command_txwrite_o  : out std_logic; --                                     --                                     .spw_data_tx_command_txwrite_signal
        spw_ch4_data_tx_command_txflag_o   : out std_logic; --                                     --                                     .spw_data_tx_command_txflag_signal
        spw_ch4_data_tx_command_txdata_o   : out std_logic_vector(7 downto 0); --                  --                                     .spw_data_tx_command_txdata_signal
        spw_ch4_errinj_ctrl_start_errinj_o : out std_logic; --                                     --                                     .spw_errinj_ctrl_start_errinj_signal
        spw_ch4_errinj_ctrl_reset_errinj_o : out std_logic; --                                     --                                     .spw_errinj_ctrl_reset_errinj_signal
        spw_ch4_errinj_ctrl_errinj_code_o  : out std_logic_vector(3 downto 0); --                  --                                     .spw_errinj_ctrl_errinj_code_signal
        spw_ch5_link_status_started_i      : in  std_logic                    := '0'; --          -- conduit_end_spacewire_ch5_controller.spw_link_status_started_signal
        spw_ch5_link_status_connecting_i   : in  std_logic                    := '0'; --          --                                     .spw_link_status_connecting_signal
        spw_ch5_link_status_running_i      : in  std_logic                    := '0'; --          --                                     .spw_link_status_running_signal
        spw_ch5_link_error_errdisc_i       : in  std_logic                    := '0'; --          --                                     .spw_link_error_errdisc_signal
        spw_ch5_link_error_errpar_i        : in  std_logic                    := '0'; --          --                                     .spw_link_error_errpar_signal
        spw_ch5_link_error_erresc_i        : in  std_logic                    := '0'; --          --                                     .spw_link_error_erresc_signal
        spw_ch5_link_error_errcred_i       : in  std_logic                    := '0'; --          --                                     .spw_link_error_errcred_signal		
        spw_ch5_timecode_rx_tick_out_i     : in  std_logic                    := '0'; --          --                                     .spw_timecode_rx_tick_out_signal
        spw_ch5_timecode_rx_ctrl_out_i     : in  std_logic_vector(1 downto 0) := (others => '0'); --                                     .spw_timecode_rx_ctrl_out_signal
        spw_ch5_timecode_rx_time_out_i     : in  std_logic_vector(5 downto 0) := (others => '0'); --                                     .spw_timecode_rx_time_out_signal
        spw_ch5_data_rx_status_rxvalid_i   : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxvalid_signal
        spw_ch5_data_rx_status_rxhalff_i   : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxhalff_signal
        spw_ch5_data_rx_status_rxflag_i    : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxflag_signal
        spw_ch5_data_rx_status_rxdata_i    : in  std_logic_vector(7 downto 0) := (others => '0'); --                                     .spw_data_rx_status_rxdata_signal
        spw_ch5_data_tx_status_txrdy_i     : in  std_logic                    := '0'; --          --                                     .spw_data_tx_status_txrdy_signal
        spw_ch5_data_tx_status_txhalff_i   : in  std_logic                    := '0'; --          --                                     .spw_data_tx_status_txhalff_signal
        spw_ch5_errinj_ctrl_errinj_busy_i  : in  std_logic                    := '0'; --          --                                     .spw_errinj_ctrl_errinj_busy_signal
        spw_ch5_errinj_ctrl_errinj_ready_i : in  std_logic                    := '0'; --          --                                     .spw_errinj_ctrl_errinj_ready_signal
        spw_ch5_link_command_enable_o      : out std_logic; --                                     --                                     .spw_link_command_enable_signal
        spw_ch5_link_command_autostart_o   : out std_logic; --                                     --                                     .spw_link_command_autostart_signal
        spw_ch5_link_command_linkstart_o   : out std_logic; --                                     --                                     .spw_link_command_linkstart_signal
        spw_ch5_link_command_linkdis_o     : out std_logic; --                                     --                                     .spw_link_command_linkdis_signal
        spw_ch5_link_command_txdivcnt_o    : out std_logic_vector(7 downto 0); --                  --                                     .spw_link_command_txdivcnt_signal
        spw_ch5_timecode_tx_tick_in_o      : out std_logic; --                                     --                                     .spw_timecode_tx_tick_in_signal
        spw_ch5_timecode_tx_ctrl_in_o      : out std_logic_vector(1 downto 0); --                  --                                     .spw_timecode_tx_ctrl_in_signal
        spw_ch5_timecode_tx_time_in_o      : out std_logic_vector(5 downto 0); --                  --                                     .spw_timecode_tx_time_in_signal
        spw_ch5_data_rx_command_rxread_o   : out std_logic; --                                     --                                     .spw_data_rx_command_rxread_signal
        spw_ch5_data_tx_command_txwrite_o  : out std_logic; --                                     --                                     .spw_data_tx_command_txwrite_signal
        spw_ch5_data_tx_command_txflag_o   : out std_logic; --                                     --                                     .spw_data_tx_command_txflag_signal
        spw_ch5_data_tx_command_txdata_o   : out std_logic_vector(7 downto 0); --                  --                                     .spw_data_tx_command_txdata_signal
        spw_ch5_errinj_ctrl_start_errinj_o : out std_logic; --                                     --                                     .spw_errinj_ctrl_start_errinj_signal
        spw_ch5_errinj_ctrl_reset_errinj_o : out std_logic; --                                     --                                     .spw_errinj_ctrl_reset_errinj_signal
        spw_ch5_errinj_ctrl_errinj_code_o  : out std_logic_vector(3 downto 0); --                  --                                     .spw_errinj_ctrl_errinj_code_signal
        spw_ch6_link_status_started_i      : in  std_logic                    := '0'; --          -- conduit_end_spacewire_ch6_controller.spw_link_status_started_signal
        spw_ch6_link_status_connecting_i   : in  std_logic                    := '0'; --          --                                     .spw_link_status_connecting_signal
        spw_ch6_link_status_running_i      : in  std_logic                    := '0'; --          --                                     .spw_link_status_running_signal
        spw_ch6_link_error_errdisc_i       : in  std_logic                    := '0'; --          --                                     .spw_link_error_errdisc_signal
        spw_ch6_link_error_errpar_i        : in  std_logic                    := '0'; --          --                                     .spw_link_error_errpar_signal
        spw_ch6_link_error_erresc_i        : in  std_logic                    := '0'; --          --                                     .spw_link_error_erresc_signal
        spw_ch6_link_error_errcred_i       : in  std_logic                    := '0'; --          --                                     .spw_link_error_errcred_signal		
        spw_ch6_timecode_rx_tick_out_i     : in  std_logic                    := '0'; --          --                                     .spw_timecode_rx_tick_out_signal
        spw_ch6_timecode_rx_ctrl_out_i     : in  std_logic_vector(1 downto 0) := (others => '0'); --                                     .spw_timecode_rx_ctrl_out_signal
        spw_ch6_timecode_rx_time_out_i     : in  std_logic_vector(5 downto 0) := (others => '0'); --                                     .spw_timecode_rx_time_out_signal
        spw_ch6_data_rx_status_rxvalid_i   : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxvalid_signal
        spw_ch6_data_rx_status_rxhalff_i   : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxhalff_signal
        spw_ch6_data_rx_status_rxflag_i    : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxflag_signal
        spw_ch6_data_rx_status_rxdata_i    : in  std_logic_vector(7 downto 0) := (others => '0'); --                                     .spw_data_rx_status_rxdata_signal
        spw_ch6_data_tx_status_txrdy_i     : in  std_logic                    := '0'; --          --                                     .spw_data_tx_status_txrdy_signal
        spw_ch6_data_tx_status_txhalff_i   : in  std_logic                    := '0'; --          --                                     .spw_data_tx_status_txhalff_signal
        spw_ch6_errinj_ctrl_errinj_busy_i  : in  std_logic                    := '0'; --          --                                     .spw_errinj_ctrl_errinj_busy_signal
        spw_ch6_errinj_ctrl_errinj_ready_i : in  std_logic                    := '0'; --          --                                     .spw_errinj_ctrl_errinj_ready_signal
        spw_ch6_link_command_enable_o      : out std_logic; --                                     --                                     .spw_link_command_enable_signal
        spw_ch6_link_command_autostart_o   : out std_logic; --                                     --                                     .spw_link_command_autostart_signal
        spw_ch6_link_command_linkstart_o   : out std_logic; --                                     --                                     .spw_link_command_linkstart_signal
        spw_ch6_link_command_linkdis_o     : out std_logic; --                                     --                                     .spw_link_command_linkdis_signal
        spw_ch6_link_command_txdivcnt_o    : out std_logic_vector(7 downto 0); --                  --                                     .spw_link_command_txdivcnt_signal
        spw_ch6_timecode_tx_tick_in_o      : out std_logic; --                                     --                                     .spw_timecode_tx_tick_in_signal
        spw_ch6_timecode_tx_ctrl_in_o      : out std_logic_vector(1 downto 0); --                  --                                     .spw_timecode_tx_ctrl_in_signal
        spw_ch6_timecode_tx_time_in_o      : out std_logic_vector(5 downto 0); --                  --                                     .spw_timecode_tx_time_in_signal
        spw_ch6_data_rx_command_rxread_o   : out std_logic; --                                     --                                     .spw_data_rx_command_rxread_signal
        spw_ch6_data_tx_command_txwrite_o  : out std_logic; --                                     --                                     .spw_data_tx_command_txwrite_signal
        spw_ch6_data_tx_command_txflag_o   : out std_logic; --                                     --                                     .spw_data_tx_command_txflag_signal
        spw_ch6_data_tx_command_txdata_o   : out std_logic_vector(7 downto 0); --                  --                                     .spw_data_tx_command_txdata_signal
        spw_ch6_errinj_ctrl_start_errinj_o : out std_logic; --                                     --                                     .spw_errinj_ctrl_start_errinj_signal
        spw_ch6_errinj_ctrl_reset_errinj_o : out std_logic; --                                     --                                     .spw_errinj_ctrl_reset_errinj_signal
        spw_ch6_errinj_ctrl_errinj_code_o  : out std_logic_vector(3 downto 0); --                  --                                     .spw_errinj_ctrl_errinj_code_signal
        spw_ch7_link_status_started_i      : in  std_logic                    := '0'; --          -- conduit_end_spacewire_ch7_controller.spw_link_status_started_signal
        spw_ch7_link_status_connecting_i   : in  std_logic                    := '0'; --          --                                     .spw_link_status_connecting_signal
        spw_ch7_link_status_running_i      : in  std_logic                    := '0'; --          --                                     .spw_link_status_running_signal
        spw_ch7_link_error_errdisc_i       : in  std_logic                    := '0'; --          --                                     .spw_link_error_errdisc_signal
        spw_ch7_link_error_errpar_i        : in  std_logic                    := '0'; --          --                                     .spw_link_error_errpar_signal
        spw_ch7_link_error_erresc_i        : in  std_logic                    := '0'; --          --                                     .spw_link_error_erresc_signal
        spw_ch7_link_error_errcred_i       : in  std_logic                    := '0'; --          --                                     .spw_link_error_errcred_signal		
        spw_ch7_timecode_rx_tick_out_i     : in  std_logic                    := '0'; --          --                                     .spw_timecode_rx_tick_out_signal
        spw_ch7_timecode_rx_ctrl_out_i     : in  std_logic_vector(1 downto 0) := (others => '0'); --                                     .spw_timecode_rx_ctrl_out_signal
        spw_ch7_timecode_rx_time_out_i     : in  std_logic_vector(5 downto 0) := (others => '0'); --                                     .spw_timecode_rx_time_out_signal
        spw_ch7_data_rx_status_rxvalid_i   : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxvalid_signal
        spw_ch7_data_rx_status_rxhalff_i   : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxhalff_signal
        spw_ch7_data_rx_status_rxflag_i    : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxflag_signal
        spw_ch7_data_rx_status_rxdata_i    : in  std_logic_vector(7 downto 0) := (others => '0'); --                                     .spw_data_rx_status_rxdata_signal
        spw_ch7_data_tx_status_txrdy_i     : in  std_logic                    := '0'; --          --                                     .spw_data_tx_status_txrdy_signal
        spw_ch7_data_tx_status_txhalff_i   : in  std_logic                    := '0'; --          --                                     .spw_data_tx_status_txhalff_signal
        spw_ch7_errinj_ctrl_errinj_busy_i  : in  std_logic                    := '0'; --          --                                     .spw_errinj_ctrl_errinj_busy_signal
        spw_ch7_errinj_ctrl_errinj_ready_i : in  std_logic                    := '0'; --          --                                     .spw_errinj_ctrl_errinj_ready_signal
        spw_ch7_link_command_enable_o      : out std_logic; --                                     --                                     .spw_link_command_enable_signal
        spw_ch7_link_command_autostart_o   : out std_logic; --                                     --                                     .spw_link_command_autostart_signal
        spw_ch7_link_command_linkstart_o   : out std_logic; --                                     --                                     .spw_link_command_linkstart_signal
        spw_ch7_link_command_linkdis_o     : out std_logic; --                                     --                                     .spw_link_command_linkdis_signal
        spw_ch7_link_command_txdivcnt_o    : out std_logic_vector(7 downto 0); --                  --                                     .spw_link_command_txdivcnt_signal
        spw_ch7_timecode_tx_tick_in_o      : out std_logic; --                                     --                                     .spw_timecode_tx_tick_in_signal
        spw_ch7_timecode_tx_ctrl_in_o      : out std_logic_vector(1 downto 0); --                  --                                     .spw_timecode_tx_ctrl_in_signal
        spw_ch7_timecode_tx_time_in_o      : out std_logic_vector(5 downto 0); --                  --                                     .spw_timecode_tx_time_in_signal
        spw_ch7_data_rx_command_rxread_o   : out std_logic; --                                     --                                     .spw_data_rx_command_rxread_signal
        spw_ch7_data_tx_command_txwrite_o  : out std_logic; --                                     --                                     .spw_data_tx_command_txwrite_signal
        spw_ch7_data_tx_command_txflag_o   : out std_logic; --                                     --                                     .spw_data_tx_command_txflag_signal
        spw_ch7_data_tx_command_txdata_o   : out std_logic_vector(7 downto 0); --                  --                                     .spw_data_tx_command_txdata_signal
        spw_ch7_errinj_ctrl_start_errinj_o : out std_logic; --                                     --                                     .spw_errinj_ctrl_start_errinj_signal
        spw_ch7_errinj_ctrl_reset_errinj_o : out std_logic; --                                     --                                     .spw_errinj_ctrl_reset_errinj_signal
        spw_ch7_errinj_ctrl_errinj_code_o  : out std_logic_vector(3 downto 0); --                  --                                     .spw_errinj_ctrl_errinj_code_signal
        spw_ch8_link_status_started_i      : in  std_logic                    := '0'; --          -- conduit_end_spacewire_ch8_controller.spw_link_status_started_signal
        spw_ch8_link_status_connecting_i   : in  std_logic                    := '0'; --          --                                     .spw_link_status_connecting_signal
        spw_ch8_link_status_running_i      : in  std_logic                    := '0'; --          --                                     .spw_link_status_running_signal
        spw_ch8_link_error_errdisc_i       : in  std_logic                    := '0'; --          --                                     .spw_link_error_errdisc_signal
        spw_ch8_link_error_errpar_i        : in  std_logic                    := '0'; --          --                                     .spw_link_error_errpar_signal
        spw_ch8_link_error_erresc_i        : in  std_logic                    := '0'; --          --                                     .spw_link_error_erresc_signal
        spw_ch8_link_error_errcred_i       : in  std_logic                    := '0'; --          --                                     .spw_link_error_errcred_signal		
        spw_ch8_timecode_rx_tick_out_i     : in  std_logic                    := '0'; --          --                                     .spw_timecode_rx_tick_out_signal
        spw_ch8_timecode_rx_ctrl_out_i     : in  std_logic_vector(1 downto 0) := (others => '0'); --                                     .spw_timecode_rx_ctrl_out_signal
        spw_ch8_timecode_rx_time_out_i     : in  std_logic_vector(5 downto 0) := (others => '0'); --                                     .spw_timecode_rx_time_out_signal
        spw_ch8_data_rx_status_rxvalid_i   : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxvalid_signal
        spw_ch8_data_rx_status_rxhalff_i   : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxhalff_signal
        spw_ch8_data_rx_status_rxflag_i    : in  std_logic                    := '0'; --          --                                     .spw_data_rx_status_rxflag_signal
        spw_ch8_data_rx_status_rxdata_i    : in  std_logic_vector(7 downto 0) := (others => '0'); --                                     .spw_data_rx_status_rxdata_signal
        spw_ch8_data_tx_status_txrdy_i     : in  std_logic                    := '0'; --          --                                     .spw_data_tx_status_txrdy_signal
        spw_ch8_data_tx_status_txhalff_i   : in  std_logic                    := '0'; --          --                                     .spw_data_tx_status_txhalff_signal
        spw_ch8_errinj_ctrl_errinj_busy_i  : in  std_logic                    := '0'; --          --                                     .spw_errinj_ctrl_errinj_busy_signal
        spw_ch8_errinj_ctrl_errinj_ready_i : in  std_logic                    := '0'; --          --                                     .spw_errinj_ctrl_errinj_ready_signal
        spw_ch8_link_command_enable_o      : out std_logic; --                                     --                                     .spw_link_command_enable_signal
        spw_ch8_link_command_autostart_o   : out std_logic; --                                     --                                     .spw_link_command_autostart_signal
        spw_ch8_link_command_linkstart_o   : out std_logic; --                                     --                                     .spw_link_command_linkstart_signal
        spw_ch8_link_command_linkdis_o     : out std_logic; --                                     --                                     .spw_link_command_linkdis_signal
        spw_ch8_link_command_txdivcnt_o    : out std_logic_vector(7 downto 0); --                  --                                     .spw_link_command_txdivcnt_signal
        spw_ch8_timecode_tx_tick_in_o      : out std_logic; --                                     --                                     .spw_timecode_tx_tick_in_signal
        spw_ch8_timecode_tx_ctrl_in_o      : out std_logic_vector(1 downto 0); --                  --                                     .spw_timecode_tx_ctrl_in_signal
        spw_ch8_timecode_tx_time_in_o      : out std_logic_vector(5 downto 0); --                  --                                     .spw_timecode_tx_time_in_signal
        spw_ch8_data_rx_command_rxread_o   : out std_logic; --                                     --                                     .spw_data_rx_command_rxread_signal
        spw_ch8_data_tx_command_txwrite_o  : out std_logic; --                                     --                                     .spw_data_tx_command_txwrite_signal
        spw_ch8_data_tx_command_txflag_o   : out std_logic; --                                     --                                     .spw_data_tx_command_txflag_signal
        spw_ch8_data_tx_command_txdata_o   : out std_logic_vector(7 downto 0); --                  --                                     .spw_data_tx_command_txdata_signal
        spw_ch8_errinj_ctrl_start_errinj_o : out std_logic; --                                     --                                     .spw_errinj_ctrl_start_errinj_signal
        spw_ch8_errinj_ctrl_reset_errinj_o : out std_logic; --                                     --                                     .spw_errinj_ctrl_reset_errinj_signal
        spw_ch8_errinj_ctrl_errinj_code_o  : out std_logic_vector(3 downto 0) ---                  --                                     .spw_errinj_ctrl_errinj_code_signal
    );
end entity spwr_spacewire_router_top;

architecture rtl of spwr_spacewire_router_top is

    -- Alias --

    -- Common Ports Alias
    alias a_clock is clock_sink_100_clk_i;
    alias a_reset     is reset_sink_reset_i;

    -- Signals -- 

    -- Constant for SpaceWire Router Channels
    constant c_SPW_ROUTER_CHANNELS : integer := 8; -- Adjust the value as needed

    -- Routing table: first 32 entries = index value, rest = 0
    constant spw_router_routing_table : routing_table_t := (
        -- First 32 entries (0 to 31) = their index values
        0      => "000000",             -- Entry 0 = 0 (6-bit representation)
        1      => "000001",             -- Entry 1 = 1
        2      => "000010",             -- Entry 2 = 2
        3      => "000011",             -- Entry 3 = 3
        4      => "000100",             -- Entry 4 = 4
        5      => "000101",             -- Entry 5 = 5
        6      => "000110",             -- Entry 6 = 6
        7      => "000111",             -- Entry 7 = 7
        8      => "001000",             -- Entry 8 = 8
        9      => "001001",             -- Entry 9 = 9
        10     => "001010",             -- Entry 10 = 10
        11     => "001011",             -- Entry 11 = 11
        12     => "001100",             -- Entry 12 = 12
        13     => "001101",             -- Entry 13 = 13
        14     => "001110",             -- Entry 14 = 14
        15     => "001111",             -- Entry 15 = 15
        16     => "010000",             -- Entry 16 = 16
        17     => "010001",             -- Entry 17 = 17
        18     => "010010",             -- Entry 18 = 18
        19     => "010011",             -- Entry 19 = 19
        20     => "010100",             -- Entry 20 = 20
        21     => "010101",             -- Entry 21 = 21
        22     => "010110",             -- Entry 22 = 22
        23     => "010111",             -- Entry 23 = 23
        24     => "011000",             -- Entry 24 = 24
        25     => "011001",             -- Entry 25 = 25
        26     => "011010",             -- Entry 26 = 26
        27     => "011011",             -- Entry 27 = 27
        28     => "011100",             -- Entry 28 = 28
        29     => "011101",             -- Entry 29 = 29
        30     => "011110",             -- Entry 30 = 30
        31     => "011111",             -- Entry 31 = 31
        32     => "100000",             -- Entry 32 = 32
        -- All remaining entries (33 to 255) are zero
        others => "000000"
    );

    -- Data Controller to Crossbar connection signals
	
	--  CH-1 : data-controller → crossbar
    signal spw_ch1_txdata_ready_i       : std_logic                    := '0';
    signal crossbar_switch_ch1_select_o : std_logic_vector(5 downto 0) := (others => '0');
    signal spw_ch1_txdata_data_o        : std_logic_vector(7 downto 0) := (others => '0');
    signal spw_ch1_txdata_flag_o        : std_logic                    := '0';
    signal spw_ch1_txdata_write_o       : std_logic                    := '0';

    --  CH-2 : data-controller → crossbar
    signal spw_ch2_txdata_ready_i       : std_logic                    := '0';
    signal crossbar_switch_ch2_select_o : std_logic_vector(5 downto 0) := (others => '0');
    signal spw_ch2_txdata_data_o        : std_logic_vector(7 downto 0) := (others => '0');
    signal spw_ch2_txdata_flag_o        : std_logic                    := '0';
    signal spw_ch2_txdata_write_o       : std_logic                    := '0';
	
    --  CH-3 : data-controller → crossbar
    signal spw_ch3_txdata_ready_i       : std_logic                    := '0';
    signal crossbar_switch_ch3_select_o : std_logic_vector(5 downto 0) := (others => '0');
    signal spw_ch3_txdata_data_o        : std_logic_vector(7 downto 0) := (others => '0');
    signal spw_ch3_txdata_flag_o        : std_logic                    := '0';
    signal spw_ch3_txdata_write_o       : std_logic                    := '0';

    --  CH-4 : data-controller → crossbar
    signal spw_ch4_txdata_ready_i       : std_logic                    := '0';
    signal crossbar_switch_ch4_select_o : std_logic_vector(5 downto 0) := (others => '0');
    signal spw_ch4_txdata_data_o        : std_logic_vector(7 downto 0) := (others => '0');
    signal spw_ch4_txdata_flag_o        : std_logic                    := '0';
    signal spw_ch4_txdata_write_o       : std_logic                    := '0';

    --  CH-5 : data-controller → crossbar
    signal spw_ch5_txdata_ready_i       : std_logic                    := '0';
    signal crossbar_switch_ch5_select_o : std_logic_vector(5 downto 0) := (others => '0');
    signal spw_ch5_txdata_data_o        : std_logic_vector(7 downto 0) := (others => '0');
    signal spw_ch5_txdata_flag_o        : std_logic                    := '0';
    signal spw_ch5_txdata_write_o       : std_logic                    := '0';

    --  CH-6 : data-controller → crossbar
    signal spw_ch6_txdata_ready_i       : std_logic                    := '0';
    signal crossbar_switch_ch6_select_o : std_logic_vector(5 downto 0) := (others => '0');
    signal spw_ch6_txdata_data_o        : std_logic_vector(7 downto 0) := (others => '0');
    signal spw_ch6_txdata_flag_o        : std_logic                    := '0';
    signal spw_ch6_txdata_write_o       : std_logic                    := '0';

    --  CH-7 : data-controller → crossbar
    signal spw_ch7_txdata_ready_i       : std_logic                    := '0';
    signal crossbar_switch_ch7_select_o : std_logic_vector(5 downto 0) := (others => '0');
    signal spw_ch7_txdata_data_o        : std_logic_vector(7 downto 0) := (others => '0');
    signal spw_ch7_txdata_flag_o        : std_logic                    := '0';
    signal spw_ch7_txdata_write_o       : std_logic                    := '0';

    --  CH-8 : data-controller → crossbar
    signal spw_ch8_txdata_ready_i       : std_logic                    := '0';
    signal crossbar_switch_ch8_select_o : std_logic_vector(5 downto 0) := (others => '0');
    signal spw_ch8_txdata_data_o        : std_logic_vector(7 downto 0) := (others => '0');
    signal spw_ch8_txdata_flag_o        : std_logic                    := '0';
    signal spw_ch8_txdata_write_o       : std_logic                    := '0';


    -- Crossbar to Arbiter connection signals
    signal data_arbiter_write_allowed_i : t_2d_slv(0 to c_SPW_ROUTER_CHANNELS, 0 to c_SPW_ROUTER_CHANNELS + 1);
    signal data_arbiter_write_request_o : t_2d_slv(0 to c_SPW_ROUTER_CHANNELS, 0 to c_SPW_ROUTER_CHANNELS + 1);
    signal in_spw_txdata_write_i        : t_1d_sl(0 to c_SPW_ROUTER_CHANNELS)   := (others => '0');
    signal in_spw_txdata_data_i         : t_1d_slv8(0 to c_SPW_ROUTER_CHANNELS) := (others => (others => '0'));
    signal in_spw_txdata_flag_i         : t_1d_sl(0 to c_SPW_ROUTER_CHANNELS)   := (others => '0');
    signal in_spw_txdata_ready_o        : t_1d_sl(0 to c_SPW_ROUTER_CHANNELS)   := (others => '0');
    signal crossbar_switch_select_i     : t_1d_slv6(0 to c_SPW_ROUTER_CHANNELS) := (others => (others => '0'));

    -- Crossbar output signals
    signal out_spw_txdata_write_o : t_1d_sl(0 to c_SPW_ROUTER_CHANNELS + 1)   := (others => '0');
    signal out_spw_txdata_data_o  : t_1d_slv8(0 to c_SPW_ROUTER_CHANNELS + 1) := (others => (others => '0'));
    signal out_spw_txdata_flag_o  : t_1d_sl(0 to c_SPW_ROUTER_CHANNELS + 1)   := (others => '0');
    signal out_spw_txdata_ready_i : t_1d_sl(0 to c_SPW_ROUTER_CHANNELS + 1)   := (others => '0');

    -- Arbiter signals

    --  CH-1 → arbiter handshake
    signal darb_ch1_data_arbiter_write_request_i : std_logic_vector(0 to c_SPW_ROUTER_CHANNELS);
    signal darb_ch1_data_arbiter_write_allowed_o : std_logic_vector(0 to c_SPW_ROUTER_CHANNELS);
    signal darb_ch1_in_spw_txdata_write_i        : std_logic;
    signal darb_ch1_in_spw_txdata_data_i         : std_logic_vector(7 downto 0);
    signal darb_ch1_in_spw_txdata_flag_i         : std_logic;
    signal darb_ch1_in_spw_txdata_ready_o        : std_logic;

    --  CH-2 → arbiter handshake
    signal darb_ch2_data_arbiter_write_request_i : std_logic_vector(0 to c_SPW_ROUTER_CHANNELS);
    signal darb_ch2_data_arbiter_write_allowed_o : std_logic_vector(0 to c_SPW_ROUTER_CHANNELS);
    signal darb_ch2_in_spw_txdata_write_i        : std_logic;
    signal darb_ch2_in_spw_txdata_data_i         : std_logic_vector(7 downto 0);
    signal darb_ch2_in_spw_txdata_flag_i         : std_logic;
    signal darb_ch2_in_spw_txdata_ready_o        : std_logic;

    --  CH-3 → arbiter handshake
    signal darb_ch3_data_arbiter_write_request_i : std_logic_vector(0 to c_SPW_ROUTER_CHANNELS);
    signal darb_ch3_data_arbiter_write_allowed_o : std_logic_vector(0 to c_SPW_ROUTER_CHANNELS);
    signal darb_ch3_in_spw_txdata_write_i        : std_logic;
    signal darb_ch3_in_spw_txdata_data_i         : std_logic_vector(7 downto 0);
    signal darb_ch3_in_spw_txdata_flag_i         : std_logic;
    signal darb_ch3_in_spw_txdata_ready_o        : std_logic;

    --  CH-4 → arbiter handshake
    signal darb_ch4_data_arbiter_write_request_i : std_logic_vector(0 to c_SPW_ROUTER_CHANNELS);
    signal darb_ch4_data_arbiter_write_allowed_o : std_logic_vector(0 to c_SPW_ROUTER_CHANNELS);
    signal darb_ch4_in_spw_txdata_write_i        : std_logic;
    signal darb_ch4_in_spw_txdata_data_i         : std_logic_vector(7 downto 0);
    signal darb_ch4_in_spw_txdata_flag_i         : std_logic;
    signal darb_ch4_in_spw_txdata_ready_o        : std_logic;

    --  CH-5 → arbiter handshake
    signal darb_ch5_data_arbiter_write_request_i : std_logic_vector(0 to c_SPW_ROUTER_CHANNELS);
    signal darb_ch5_data_arbiter_write_allowed_o : std_logic_vector(0 to c_SPW_ROUTER_CHANNELS);
    signal darb_ch5_in_spw_txdata_write_i        : std_logic;
    signal darb_ch5_in_spw_txdata_data_i         : std_logic_vector(7 downto 0);
    signal darb_ch5_in_spw_txdata_flag_i         : std_logic;
    signal darb_ch5_in_spw_txdata_ready_o        : std_logic;

    --  CH-6 → arbiter handshake
    signal darb_ch6_data_arbiter_write_request_i : std_logic_vector(0 to c_SPW_ROUTER_CHANNELS);
    signal darb_ch6_data_arbiter_write_allowed_o : std_logic_vector(0 to c_SPW_ROUTER_CHANNELS);
    signal darb_ch6_in_spw_txdata_write_i        : std_logic;
    signal darb_ch6_in_spw_txdata_data_i         : std_logic_vector(7 downto 0);
    signal darb_ch6_in_spw_txdata_flag_i         : std_logic;
    signal darb_ch6_in_spw_txdata_ready_o        : std_logic;

    --  CH-7 → arbiter handshake
    signal darb_ch7_data_arbiter_write_request_i : std_logic_vector(0 to c_SPW_ROUTER_CHANNELS);
    signal darb_ch7_data_arbiter_write_allowed_o : std_logic_vector(0 to c_SPW_ROUTER_CHANNELS);
    signal darb_ch7_in_spw_txdata_write_i        : std_logic;
    signal darb_ch7_in_spw_txdata_data_i         : std_logic_vector(7 downto 0);
    signal darb_ch7_in_spw_txdata_flag_i         : std_logic;
    signal darb_ch7_in_spw_txdata_ready_o        : std_logic;

    --  CH-8 → arbiter handshake
    signal darb_ch8_data_arbiter_write_request_i : std_logic_vector(0 to c_SPW_ROUTER_CHANNELS);
    signal darb_ch8_data_arbiter_write_allowed_o : std_logic_vector(0 to c_SPW_ROUTER_CHANNELS);
    signal darb_ch8_in_spw_txdata_write_i        : std_logic;
    signal darb_ch8_in_spw_txdata_data_i         : std_logic_vector(7 downto 0);
    signal darb_ch8_in_spw_txdata_flag_i         : std_logic;
    signal darb_ch8_in_spw_txdata_ready_o        : std_logic;

    --  CH-9 (discard channel) → arbiter handshake
    signal darb_ch9_data_arbiter_write_request_i : std_logic_vector(0 to c_SPW_ROUTER_CHANNELS);
    signal darb_ch9_data_arbiter_write_allowed_o : std_logic_vector(0 to c_SPW_ROUTER_CHANNELS);
    signal darb_ch9_in_spw_txdata_write_i        : std_logic;
    signal darb_ch9_in_spw_txdata_data_i         : std_logic_vector(7 downto 0);
    signal darb_ch9_in_spw_txdata_flag_i         : std_logic;
    signal darb_ch9_in_spw_txdata_ready_o        : std_logic;

begin

    spwr_data_controller_ent_ch1_inst : entity work.spwr_data_controller_ent
        port map(
            clk_i                      => a_clock,
            rst_i                      => a_reset,
            spw_router_routing_table_i => spw_router_routing_table,
            spw_txdata_ready_i         => spw_ch1_txdata_ready_i,
            spw_rxdata_data_i          => spw_ch1_data_rx_status_rxdata_i,
            spw_rxdata_flag_i          => spw_ch1_data_rx_status_rxflag_i,
            spw_rxdata_ready_i         => spw_ch1_data_rx_status_rxvalid_i,
            crossbar_switch_select_o   => crossbar_switch_ch1_select_o,
            spw_txdata_data_o          => spw_ch1_txdata_data_o,
            spw_txdata_flag_o          => spw_ch1_txdata_flag_o,
            spw_txdata_write_o         => spw_ch1_txdata_write_o,
            spw_rxdata_read_o          => spw_ch1_data_rx_command_rxread_o
        );

    spwr_data_controller_ent_ch2_inst : entity work.spwr_data_controller_ent
        port map(
            clk_i                      => a_clock,
            rst_i                      => a_reset,
            spw_router_routing_table_i => spw_router_routing_table,
            spw_txdata_ready_i         => spw_ch2_txdata_ready_i,
            spw_rxdata_data_i          => spw_ch2_data_rx_status_rxdata_i,
            spw_rxdata_flag_i          => spw_ch2_data_rx_status_rxflag_i,
            spw_rxdata_ready_i         => spw_ch2_data_rx_status_rxvalid_i,
            crossbar_switch_select_o   => crossbar_switch_ch2_select_o,
            spw_txdata_data_o          => spw_ch2_txdata_data_o,
            spw_txdata_flag_o          => spw_ch2_txdata_flag_o,
            spw_txdata_write_o         => spw_ch2_txdata_write_o,
            spw_rxdata_read_o          => spw_ch2_data_rx_command_rxread_o
        );

        spwr_data_controller_ent_ch3_inst : entity work.spwr_data_controller_ent
        port map(
            clk_i                      => a_clock,
            rst_i                      => a_reset,
            spw_router_routing_table_i => spw_router_routing_table,
            spw_txdata_ready_i         => spw_ch3_txdata_ready_i,
            spw_rxdata_data_i          => spw_ch3_data_rx_status_rxdata_i,
            spw_rxdata_flag_i          => spw_ch3_data_rx_status_rxflag_i,
            spw_rxdata_ready_i         => spw_ch3_data_rx_status_rxvalid_i,
            crossbar_switch_select_o   => crossbar_switch_ch3_select_o,
            spw_txdata_data_o          => spw_ch3_txdata_data_o,
            spw_txdata_flag_o          => spw_ch3_txdata_flag_o,
            spw_txdata_write_o         => spw_ch3_txdata_write_o,
            spw_rxdata_read_o          => spw_ch3_data_rx_command_rxread_o
        );

    spwr_data_controller_ent_ch4_inst : entity work.spwr_data_controller_ent
        port map(
            clk_i                      => a_clock,
            rst_i                      => a_reset,
            spw_router_routing_table_i => spw_router_routing_table,
            spw_txdata_ready_i         => spw_ch4_txdata_ready_i,
            spw_rxdata_data_i          => spw_ch4_data_rx_status_rxdata_i,
            spw_rxdata_flag_i          => spw_ch4_data_rx_status_rxflag_i,
            spw_rxdata_ready_i         => spw_ch4_data_rx_status_rxvalid_i,
            crossbar_switch_select_o   => crossbar_switch_ch4_select_o,
            spw_txdata_data_o          => spw_ch4_txdata_data_o,
            spw_txdata_flag_o          => spw_ch4_txdata_flag_o,
            spw_txdata_write_o         => spw_ch4_txdata_write_o,
            spw_rxdata_read_o          => spw_ch4_data_rx_command_rxread_o
        );

    spwr_data_controller_ent_ch5_inst : entity work.spwr_data_controller_ent
        port map(
            clk_i                      => a_clock,
            rst_i                      => a_reset,
            spw_router_routing_table_i => spw_router_routing_table,
            spw_txdata_ready_i         => spw_ch5_txdata_ready_i,
            spw_rxdata_data_i          => spw_ch5_data_rx_status_rxdata_i,
            spw_rxdata_flag_i          => spw_ch5_data_rx_status_rxflag_i,
            spw_rxdata_ready_i         => spw_ch5_data_rx_status_rxvalid_i,
            crossbar_switch_select_o   => crossbar_switch_ch5_select_o,
            spw_txdata_data_o          => spw_ch5_txdata_data_o,
            spw_txdata_flag_o          => spw_ch5_txdata_flag_o,
            spw_txdata_write_o         => spw_ch5_txdata_write_o,
            spw_rxdata_read_o          => spw_ch5_data_rx_command_rxread_o
        );

    spwr_data_controller_ent_ch6_inst : entity work.spwr_data_controller_ent
        port map(
            clk_i                      => a_clock,
            rst_i                      => a_reset,
            spw_router_routing_table_i => spw_router_routing_table,
            spw_txdata_ready_i         => spw_ch6_txdata_ready_i,
            spw_rxdata_data_i          => spw_ch6_data_rx_status_rxdata_i,
            spw_rxdata_flag_i          => spw_ch6_data_rx_status_rxflag_i,
            spw_rxdata_ready_i         => spw_ch6_data_rx_status_rxvalid_i,
            crossbar_switch_select_o   => crossbar_switch_ch6_select_o,
            spw_txdata_data_o          => spw_ch6_txdata_data_o,
            spw_txdata_flag_o          => spw_ch6_txdata_flag_o,
            spw_txdata_write_o         => spw_ch6_txdata_write_o,
            spw_rxdata_read_o          => spw_ch6_data_rx_command_rxread_o
        );

    spwr_data_controller_ent_ch7_inst : entity work.spwr_data_controller_ent
        port map(
            clk_i                      => a_clock,
            rst_i                      => a_reset,
            spw_router_routing_table_i => spw_router_routing_table,
            spw_txdata_ready_i         => spw_ch7_txdata_ready_i,
            spw_rxdata_data_i          => spw_ch7_data_rx_status_rxdata_i,
            spw_rxdata_flag_i          => spw_ch7_data_rx_status_rxflag_i,
            spw_rxdata_ready_i         => spw_ch7_data_rx_status_rxvalid_i,
            crossbar_switch_select_o   => crossbar_switch_ch7_select_o,
            spw_txdata_data_o          => spw_ch7_txdata_data_o,
            spw_txdata_flag_o          => spw_ch7_txdata_flag_o,
            spw_txdata_write_o         => spw_ch7_txdata_write_o,
            spw_rxdata_read_o          => spw_ch7_data_rx_command_rxread_o
        );

    spwr_data_controller_ent_ch8_inst : entity work.spwr_data_controller_ent
        port map(
            clk_i                      => a_clock,
            rst_i                      => a_reset,
            spw_router_routing_table_i => spw_router_routing_table,
            spw_txdata_ready_i         => spw_ch8_txdata_ready_i,
            spw_rxdata_data_i          => spw_ch8_data_rx_status_rxdata_i,
            spw_rxdata_flag_i          => spw_ch8_data_rx_status_rxflag_i,
            spw_rxdata_ready_i         => spw_ch8_data_rx_status_rxvalid_i,
            crossbar_switch_select_o   => crossbar_switch_ch8_select_o,
            spw_txdata_data_o          => spw_ch8_txdata_data_o,
            spw_txdata_flag_o          => spw_ch8_txdata_flag_o,
            spw_txdata_write_o         => spw_ch8_txdata_write_o,
            spw_rxdata_read_o          => spw_ch8_data_rx_command_rxread_o
        );

    spwr_crossbar_switch_ent_inst : entity work.spwr_crossbar_switch_ent
        generic map(
            g_RESET_DELAY         => 2,
            g_SPW_ROUTER_CHANNELS => c_SPW_ROUTER_CHANNELS
        )
        port map(
            clock_i                      => a_clock,
            reset_i                      => a_reset,
            data_arbiter_write_allowed_i => data_arbiter_write_allowed_i,
            data_arbiter_write_request_o => data_arbiter_write_request_o,
            in_spw_txdata_write_i        => in_spw_txdata_write_i,
            in_spw_txdata_data_i         => in_spw_txdata_data_i,
            in_spw_txdata_flag_i         => in_spw_txdata_flag_i,
            in_spw_txdata_ready_o        => in_spw_txdata_ready_o,
            out_spw_txdata_write_o       => out_spw_txdata_write_o,
            out_spw_txdata_data_o        => out_spw_txdata_data_o,
            out_spw_txdata_flag_o        => out_spw_txdata_flag_o,
            out_spw_txdata_ready_i       => out_spw_txdata_ready_i,
            crossbar_switch_select_i     => crossbar_switch_select_i
        );

    spwr_data_arbiter_ent_ch1_inst : entity work.spwr_data_arbiter_ent
        generic map(
            g_RESET_DELAY         => 2,
            g_SPW_ROUTER_CHANNELS => c_SPW_ROUTER_CHANNELS
        )
        port map(
            clock_i                      => a_clock,
            reset_i                      => a_reset,
            data_arbiter_write_request_i => darb_ch1_data_arbiter_write_request_i,
            data_arbiter_write_allowed_o => darb_ch1_data_arbiter_write_allowed_o,
            in_spw_txdata_write_i        => darb_ch1_in_spw_txdata_write_i,
            in_spw_txdata_data_i         => darb_ch1_in_spw_txdata_data_i,
            in_spw_txdata_flag_i         => darb_ch1_in_spw_txdata_flag_i,
            in_spw_txdata_ready_o        => darb_ch1_in_spw_txdata_ready_o,
            out_spw_txdata_write_o       => spw_ch1_data_tx_command_txwrite_o,
            out_spw_txdata_data_o        => spw_ch1_data_tx_command_txdata_o,
            out_spw_txdata_flag_o        => spw_ch1_data_tx_command_txflag_o,
            out_spw_txdata_ready_i       => spw_ch1_data_tx_status_txrdy_i
        );

    spwr_data_arbiter_ent_ch2_inst : entity work.spwr_data_arbiter_ent
        generic map(
            g_RESET_DELAY         => 2,
            g_SPW_ROUTER_CHANNELS => c_SPW_ROUTER_CHANNELS
        )
        port map(
            clock_i                      => a_clock,
            reset_i                      => a_reset,
            data_arbiter_write_request_i => darb_ch2_data_arbiter_write_request_i,
            data_arbiter_write_allowed_o => darb_ch2_data_arbiter_write_allowed_o,
            in_spw_txdata_write_i        => darb_ch2_in_spw_txdata_write_i,
            in_spw_txdata_data_i         => darb_ch2_in_spw_txdata_data_i,
            in_spw_txdata_flag_i         => darb_ch2_in_spw_txdata_flag_i,
            in_spw_txdata_ready_o        => darb_ch2_in_spw_txdata_ready_o,
            out_spw_txdata_write_o       => spw_ch2_data_tx_command_txwrite_o,
            out_spw_txdata_data_o        => spw_ch2_data_tx_command_txdata_o,
            out_spw_txdata_flag_o        => spw_ch2_data_tx_command_txflag_o,
            out_spw_txdata_ready_i       => spw_ch2_data_tx_status_txrdy_i
        );

        spwr_data_arbiter_ent_ch3_inst : entity work.spwr_data_arbiter_ent
        generic map(
            g_RESET_DELAY         => 2,
            g_SPW_ROUTER_CHANNELS => c_SPW_ROUTER_CHANNELS
        )
        port map(
            clock_i                      => a_clock,
            reset_i                      => a_reset,
            data_arbiter_write_request_i => darb_ch3_data_arbiter_write_request_i,
            data_arbiter_write_allowed_o => darb_ch3_data_arbiter_write_allowed_o,
            in_spw_txdata_write_i        => darb_ch3_in_spw_txdata_write_i,
            in_spw_txdata_data_i         => darb_ch3_in_spw_txdata_data_i,
            in_spw_txdata_flag_i         => darb_ch3_in_spw_txdata_flag_i,
            in_spw_txdata_ready_o        => darb_ch3_in_spw_txdata_ready_o,
            out_spw_txdata_write_o       => spw_ch3_data_tx_command_txwrite_o,
            out_spw_txdata_data_o        => spw_ch3_data_tx_command_txdata_o,
            out_spw_txdata_flag_o        => spw_ch3_data_tx_command_txflag_o,
            out_spw_txdata_ready_i       => spw_ch3_data_tx_status_txrdy_i
        );

    spwr_data_arbiter_ent_ch4_inst : entity work.spwr_data_arbiter_ent
        generic map(
            g_RESET_DELAY         => 2,
            g_SPW_ROUTER_CHANNELS => c_SPW_ROUTER_CHANNELS
        )
        port map(
            clock_i                      => a_clock,
            reset_i                      => a_reset,
            data_arbiter_write_request_i => darb_ch4_data_arbiter_write_request_i,
            data_arbiter_write_allowed_o => darb_ch4_data_arbiter_write_allowed_o,
            in_spw_txdata_write_i        => darb_ch4_in_spw_txdata_write_i,
            in_spw_txdata_data_i         => darb_ch4_in_spw_txdata_data_i,
            in_spw_txdata_flag_i         => darb_ch4_in_spw_txdata_flag_i,
            in_spw_txdata_ready_o        => darb_ch4_in_spw_txdata_ready_o,
            out_spw_txdata_write_o       => spw_ch4_data_tx_command_txwrite_o,
            out_spw_txdata_data_o        => spw_ch4_data_tx_command_txdata_o,
            out_spw_txdata_flag_o        => spw_ch4_data_tx_command_txflag_o,
            out_spw_txdata_ready_i       => spw_ch4_data_tx_status_txrdy_i
        );

    spwr_data_arbiter_ent_ch5_inst : entity work.spwr_data_arbiter_ent
        generic map(
            g_RESET_DELAY         => 2,
            g_SPW_ROUTER_CHANNELS => c_SPW_ROUTER_CHANNELS
        )
        port map(
            clock_i                      => a_clock,
            reset_i                      => a_reset,
            data_arbiter_write_request_i => darb_ch5_data_arbiter_write_request_i,
            data_arbiter_write_allowed_o => darb_ch5_data_arbiter_write_allowed_o,
            in_spw_txdata_write_i        => darb_ch5_in_spw_txdata_write_i,
            in_spw_txdata_data_i         => darb_ch5_in_spw_txdata_data_i,
            in_spw_txdata_flag_i         => darb_ch5_in_spw_txdata_flag_i,
            in_spw_txdata_ready_o        => darb_ch5_in_spw_txdata_ready_o,
            out_spw_txdata_write_o       => spw_ch5_data_tx_command_txwrite_o,
            out_spw_txdata_data_o        => spw_ch5_data_tx_command_txdata_o,
            out_spw_txdata_flag_o        => spw_ch5_data_tx_command_txflag_o,
            out_spw_txdata_ready_i       => spw_ch5_data_tx_status_txrdy_i
        );

    spwr_data_arbiter_ent_ch6_inst : entity work.spwr_data_arbiter_ent
        generic map(
            g_RESET_DELAY         => 2,
            g_SPW_ROUTER_CHANNELS => c_SPW_ROUTER_CHANNELS
        )
        port map(
            clock_i                      => a_clock,
            reset_i                      => a_reset,
            data_arbiter_write_request_i => darb_ch6_data_arbiter_write_request_i,
            data_arbiter_write_allowed_o => darb_ch6_data_arbiter_write_allowed_o,
            in_spw_txdata_write_i        => darb_ch6_in_spw_txdata_write_i,
            in_spw_txdata_data_i         => darb_ch6_in_spw_txdata_data_i,
            in_spw_txdata_flag_i         => darb_ch6_in_spw_txdata_flag_i,
            in_spw_txdata_ready_o        => darb_ch6_in_spw_txdata_ready_o,
            out_spw_txdata_write_o       => spw_ch6_data_tx_command_txwrite_o,
            out_spw_txdata_data_o        => spw_ch6_data_tx_command_txdata_o,
            out_spw_txdata_flag_o        => spw_ch6_data_tx_command_txflag_o,
            out_spw_txdata_ready_i       => spw_ch6_data_tx_status_txrdy_i
        );

    spwr_data_arbiter_ent_ch7_inst : entity work.spwr_data_arbiter_ent
        generic map(
            g_RESET_DELAY         => 2,
            g_SPW_ROUTER_CHANNELS => c_SPW_ROUTER_CHANNELS
        )
        port map(
            clock_i                      => a_clock,
            reset_i                      => a_reset,
            data_arbiter_write_request_i => darb_ch7_data_arbiter_write_request_i,
            data_arbiter_write_allowed_o => darb_ch7_data_arbiter_write_allowed_o,
            in_spw_txdata_write_i        => darb_ch7_in_spw_txdata_write_i,
            in_spw_txdata_data_i         => darb_ch7_in_spw_txdata_data_i,
            in_spw_txdata_flag_i         => darb_ch7_in_spw_txdata_flag_i,
            in_spw_txdata_ready_o        => darb_ch7_in_spw_txdata_ready_o,
            out_spw_txdata_write_o       => spw_ch7_data_tx_command_txwrite_o,
            out_spw_txdata_data_o        => spw_ch7_data_tx_command_txdata_o,
            out_spw_txdata_flag_o        => spw_ch7_data_tx_command_txflag_o,
            out_spw_txdata_ready_i       => spw_ch7_data_tx_status_txrdy_i
        );

    spwr_data_arbiter_ent_ch8_inst : entity work.spwr_data_arbiter_ent
        generic map(
            g_RESET_DELAY         => 2,
            g_SPW_ROUTER_CHANNELS => c_SPW_ROUTER_CHANNELS
        )
        port map(
            clock_i                      => a_clock,
            reset_i                      => a_reset,
            data_arbiter_write_request_i => darb_ch8_data_arbiter_write_request_i,
            data_arbiter_write_allowed_o => darb_ch8_data_arbiter_write_allowed_o,
            in_spw_txdata_write_i        => darb_ch8_in_spw_txdata_write_i,
            in_spw_txdata_data_i         => darb_ch8_in_spw_txdata_data_i,
            in_spw_txdata_flag_i         => darb_ch8_in_spw_txdata_flag_i,
            in_spw_txdata_ready_o        => darb_ch8_in_spw_txdata_ready_o,
            out_spw_txdata_write_o       => spw_ch8_data_tx_command_txwrite_o,
            out_spw_txdata_data_o        => spw_ch8_data_tx_command_txdata_o,
            out_spw_txdata_flag_o        => spw_ch8_data_tx_command_txflag_o,
            out_spw_txdata_ready_i       => spw_ch8_data_tx_status_txrdy_i
        );

        spwr_data_discard_ent_ch9_inst : entity work.spwr_data_discard_ent
        generic map(
            g_RESET_DELAY         => 2,
            g_SPW_ROUTER_CHANNELS => c_SPW_ROUTER_CHANNELS
        )
        port map(
            clock_i                      => a_clock,
            reset_i                      => a_reset,
            data_arbiter_write_request_i => darb_ch9_data_arbiter_write_request_i,
            data_arbiter_write_allowed_o => darb_ch9_data_arbiter_write_allowed_o,
            in_spw_txdata_write_i        => darb_ch9_in_spw_txdata_write_i,
            in_spw_txdata_data_i         => darb_ch9_in_spw_txdata_data_i,
            in_spw_txdata_flag_i         => darb_ch9_in_spw_txdata_flag_i,
            in_spw_txdata_ready_o        => darb_ch9_in_spw_txdata_ready_o
        );

        in_spw_txdata_write_i(1)    <= spw_ch1_txdata_write_o;
        in_spw_txdata_data_i(1)     <= spw_ch1_txdata_data_o;
        in_spw_txdata_flag_i(1)     <= spw_ch1_txdata_flag_o;
        spw_ch1_txdata_ready_i      <= in_spw_txdata_ready_o(1);
        crossbar_switch_select_i(1) <= crossbar_switch_ch1_select_o;
    
        in_spw_txdata_write_i(2)    <= spw_ch2_txdata_write_o;
        in_spw_txdata_data_i(2)     <= spw_ch2_txdata_data_o;
        in_spw_txdata_flag_i(2)     <= spw_ch2_txdata_flag_o;
        spw_ch2_txdata_ready_i      <= in_spw_txdata_ready_o(2);
        crossbar_switch_select_i(2) <= crossbar_switch_ch2_select_o;

        in_spw_txdata_write_i(3)    <= spw_ch3_txdata_write_o;
        in_spw_txdata_data_i(3)     <= spw_ch3_txdata_data_o;
        in_spw_txdata_flag_i(3)     <= spw_ch3_txdata_flag_o;
        spw_ch3_txdata_ready_i      <= in_spw_txdata_ready_o(3);
        crossbar_switch_select_i(3) <= crossbar_switch_ch3_select_o;
    
        in_spw_txdata_write_i(4)    <= spw_ch4_txdata_write_o;
        in_spw_txdata_data_i(4)     <= spw_ch4_txdata_data_o;
        in_spw_txdata_flag_i(4)     <= spw_ch4_txdata_flag_o;
        spw_ch4_txdata_ready_i      <= in_spw_txdata_ready_o(4);
        crossbar_switch_select_i(4) <= crossbar_switch_ch4_select_o;
    
        in_spw_txdata_write_i(5)    <= spw_ch5_txdata_write_o;
        in_spw_txdata_data_i(5)     <= spw_ch5_txdata_data_o;
        in_spw_txdata_flag_i(5)     <= spw_ch5_txdata_flag_o;
        spw_ch5_txdata_ready_i      <= in_spw_txdata_ready_o(5);
        crossbar_switch_select_i(5) <= crossbar_switch_ch5_select_o;
    
        in_spw_txdata_write_i(6)    <= spw_ch6_txdata_write_o;
        in_spw_txdata_data_i(6)     <= spw_ch6_txdata_data_o;
        in_spw_txdata_flag_i(6)     <= spw_ch6_txdata_flag_o;
        spw_ch6_txdata_ready_i      <= in_spw_txdata_ready_o(6);
        crossbar_switch_select_i(6) <= crossbar_switch_ch6_select_o;
    
        in_spw_txdata_write_i(7)    <= spw_ch7_txdata_write_o;
        in_spw_txdata_data_i(7)     <= spw_ch7_txdata_data_o;
        in_spw_txdata_flag_i(7)     <= spw_ch7_txdata_flag_o;
        spw_ch7_txdata_ready_i      <= in_spw_txdata_ready_o(7);
        crossbar_switch_select_i(7) <= crossbar_switch_ch7_select_o;
    
        in_spw_txdata_write_i(8)    <= spw_ch8_txdata_write_o;
        in_spw_txdata_data_i(8)     <= spw_ch8_txdata_data_o;
        in_spw_txdata_flag_i(8)     <= spw_ch8_txdata_flag_o;
        spw_ch8_txdata_ready_i      <= in_spw_txdata_ready_o(8);
        crossbar_switch_select_i(8) <= crossbar_switch_ch8_select_o;

    -- Extract requests from crossbar to arbiter (for output channel 1)
    data_arbiter_write_request : for i in 0 to c_SPW_ROUTER_CHANNELS generate
        darb_ch1_data_arbiter_write_request_i(i) <= data_arbiter_write_request_o(i, 1);
    end generate data_arbiter_write_request;

    -- And for the reverse direction (arbiter allowed signals to crossbar)
    data_arbiter_write_allowed : for i in 0 to c_SPW_ROUTER_CHANNELS generate
        data_arbiter_write_allowed_i(i, 1) <= darb_ch1_data_arbiter_write_allowed_o(i);
    end generate data_arbiter_write_allowed;

    darb_ch1_in_spw_txdata_write_i <= out_spw_txdata_write_o(1);
    darb_ch1_in_spw_txdata_data_i  <= out_spw_txdata_data_o(1);
    darb_ch1_in_spw_txdata_flag_i  <= out_spw_txdata_flag_o(1);
    out_spw_txdata_ready_i(1)      <= darb_ch1_in_spw_txdata_ready_o;

    -- cross-bar → arbiter (output channel 2)
    data_arbiter_write_request_ch2 : for i in 0 to c_SPW_ROUTER_CHANNELS generate
        darb_ch2_data_arbiter_write_request_i(i) <= data_arbiter_write_request_o(i, 2);
    end generate;

    -- arbiter → cross-bar (channel 2)
    data_arbiter_write_allowed_ch2 : for i in 0 to c_SPW_ROUTER_CHANNELS generate
        data_arbiter_write_allowed_i(i, 2) <= darb_ch2_data_arbiter_write_allowed_o(i);
    end generate;

    -- feedback back into arbiter
    darb_ch2_in_spw_txdata_write_i <= out_spw_txdata_write_o(2); -- same bus
    darb_ch2_in_spw_txdata_data_i  <= out_spw_txdata_data_o(2);
    darb_ch2_in_spw_txdata_flag_i  <= out_spw_txdata_flag_o(2);
    out_spw_txdata_ready_i(2)      <= darb_ch2_in_spw_txdata_ready_o;

    -- cross-bar → arbiter (output channel 3)
    data_arbiter_write_request_ch3 : for i in 0 to c_SPW_ROUTER_CHANNELS generate
        darb_ch3_data_arbiter_write_request_i(i) <= data_arbiter_write_request_o(i, 3);
    end generate;

    -- arbiter → cross-bar (channel 3)
    data_arbiter_write_allowed_ch3 : for i in 0 to c_SPW_ROUTER_CHANNELS generate
        data_arbiter_write_allowed_i(i, 3) <= darb_ch3_data_arbiter_write_allowed_o(i);
    end generate;

    -- feedback back into arbiter
    darb_ch3_in_spw_txdata_write_i <= out_spw_txdata_write_o(3);
    darb_ch3_in_spw_txdata_data_i  <= out_spw_txdata_data_o(3);
    darb_ch3_in_spw_txdata_flag_i  <= out_spw_txdata_flag_o(3);
    out_spw_txdata_ready_i(3)      <= darb_ch3_in_spw_txdata_ready_o;

    -- cross-bar → arbiter (output channel 4)
    data_arbiter_write_request_ch4 : for i in 0 to c_SPW_ROUTER_CHANNELS generate
        darb_ch4_data_arbiter_write_request_i(i) <= data_arbiter_write_request_o(i, 4);
    end generate;

    -- arbiter → cross-bar (channel 4)
    data_arbiter_write_allowed_ch4 : for i in 0 to c_SPW_ROUTER_CHANNELS generate
        data_arbiter_write_allowed_i(i, 4) <= darb_ch4_data_arbiter_write_allowed_o(i);
    end generate;

    -- feedback back into arbiter
    darb_ch4_in_spw_txdata_write_i <= out_spw_txdata_write_o(4);
    darb_ch4_in_spw_txdata_data_i  <= out_spw_txdata_data_o(4);
    darb_ch4_in_spw_txdata_flag_i  <= out_spw_txdata_flag_o(4);
    out_spw_txdata_ready_i(4)      <= darb_ch4_in_spw_txdata_ready_o;

    -- cross-bar → arbiter (output channel 5)
    data_arbiter_write_request_ch5 : for i in 0 to c_SPW_ROUTER_CHANNELS generate
        darb_ch5_data_arbiter_write_request_i(i) <= data_arbiter_write_request_o(i, 5);
    end generate;

    -- arbiter → cross-bar (channel 5)
    data_arbiter_write_allowed_ch5 : for i in 0 to c_SPW_ROUTER_CHANNELS generate
        data_arbiter_write_allowed_i(i, 5) <= darb_ch5_data_arbiter_write_allowed_o(i);
    end generate;

    -- feedback back into arbiter
    darb_ch5_in_spw_txdata_write_i <= out_spw_txdata_write_o(5);
    darb_ch5_in_spw_txdata_data_i  <= out_spw_txdata_data_o(5);
    darb_ch5_in_spw_txdata_flag_i  <= out_spw_txdata_flag_o(5);
    out_spw_txdata_ready_i(5)      <= darb_ch5_in_spw_txdata_ready_o;

    -- cross-bar → arbiter (output channel 6)
    data_arbiter_write_request_ch6 : for i in 0 to c_SPW_ROUTER_CHANNELS generate
        darb_ch6_data_arbiter_write_request_i(i) <= data_arbiter_write_request_o(i, 6);
    end generate;

    -- arbiter → cross-bar (channel 6)
    data_arbiter_write_allowed_ch6 : for i in 0 to c_SPW_ROUTER_CHANNELS generate
        data_arbiter_write_allowed_i(i, 6) <= darb_ch6_data_arbiter_write_allowed_o(i);
    end generate;

    -- feedback back into arbiter
    darb_ch6_in_spw_txdata_write_i <= out_spw_txdata_write_o(6);
    darb_ch6_in_spw_txdata_data_i  <= out_spw_txdata_data_o(6);
    darb_ch6_in_spw_txdata_flag_i  <= out_spw_txdata_flag_o(6);
    out_spw_txdata_ready_i(6)      <= darb_ch6_in_spw_txdata_ready_o;

    -- cross-bar → arbiter (output channel 7)
    data_arbiter_write_request_ch7 : for i in 0 to c_SPW_ROUTER_CHANNELS generate
        darb_ch7_data_arbiter_write_request_i(i) <= data_arbiter_write_request_o(i, 7);
    end generate;

    -- arbiter → cross-bar (channel 7)
    data_arbiter_write_allowed_ch7 : for i in 0 to c_SPW_ROUTER_CHANNELS generate
        data_arbiter_write_allowed_i(i, 7) <= darb_ch7_data_arbiter_write_allowed_o(i);
    end generate;

    -- feedback back into arbiter
    darb_ch7_in_spw_txdata_write_i <= out_spw_txdata_write_o(7);
    darb_ch7_in_spw_txdata_data_i  <= out_spw_txdata_data_o(7);
    darb_ch7_in_spw_txdata_flag_i  <= out_spw_txdata_flag_o(7);
    out_spw_txdata_ready_i(7)      <= darb_ch7_in_spw_txdata_ready_o;

    -- cross-bar → arbiter (output channel 8)
    data_arbiter_write_request_ch8 : for i in 0 to c_SPW_ROUTER_CHANNELS generate
        darb_ch8_data_arbiter_write_request_i(i) <= data_arbiter_write_request_o(i, 8);
    end generate;

    -- arbiter → cross-bar (channel 8)
    data_arbiter_write_allowed_ch8 : for i in 0 to c_SPW_ROUTER_CHANNELS generate
        data_arbiter_write_allowed_i(i, 8) <= darb_ch8_data_arbiter_write_allowed_o(i);
    end generate;

    -- feedback back into arbiter
    darb_ch8_in_spw_txdata_write_i <= out_spw_txdata_write_o(8);
    darb_ch8_in_spw_txdata_data_i  <= out_spw_txdata_data_o(8);
    darb_ch8_in_spw_txdata_flag_i  <= out_spw_txdata_flag_o(8);
    out_spw_txdata_ready_i(8)      <= darb_ch8_in_spw_txdata_ready_o;

    -- cross-bar → arbiter (output channel 9 - discard channel)
    data_arbiter_write_request_ch9 : for i in 0 to c_SPW_ROUTER_CHANNELS generate
        darb_ch9_data_arbiter_write_request_i(i) <= data_arbiter_write_request_o(i, 9);
    end generate;

    -- arbiter → cross-bar (channel 9 - discard channel)
    data_arbiter_write_allowed_ch9 : for i in 0 to c_SPW_ROUTER_CHANNELS generate
        data_arbiter_write_allowed_i(i, 9) <= darb_ch9_data_arbiter_write_allowed_o(i);
    end generate;

    -- feedback back into arbiter - discard channel
    darb_ch9_in_spw_txdata_write_i <= out_spw_txdata_write_o(9);
    darb_ch9_in_spw_txdata_data_i  <= out_spw_txdata_data_o(9);
    darb_ch9_in_spw_txdata_flag_i  <= out_spw_txdata_flag_o(9);
    out_spw_txdata_ready_i(9)      <= darb_ch9_in_spw_txdata_ready_o;

    -- SpaceWire Channel Codec Configuration
    p_spwc_codec_config : process(a_clock, a_reset) is
    begin
        if (a_reset = '1') then
		
            spw_ch1_link_command_enable_o      <= '0';
            spw_ch1_link_command_autostart_o   <= '0';
            spw_ch1_link_command_linkstart_o   <= '0';
            spw_ch1_link_command_linkdis_o     <= '0';
            spw_ch1_link_command_txdivcnt_o    <= x"01";
            spw_ch1_timecode_tx_tick_in_o      <= '0';
            spw_ch1_timecode_tx_ctrl_in_o      <= (others => '0');
            spw_ch1_timecode_tx_time_in_o      <= (others => '0');
            spw_ch1_errinj_ctrl_start_errinj_o <= '0';
            spw_ch1_errinj_ctrl_reset_errinj_o <= '0';
            spw_ch1_errinj_ctrl_errinj_code_o  <= (others => '0');
			
            spw_ch2_link_command_enable_o      <= '0';
            spw_ch2_link_command_autostart_o   <= '0';
            spw_ch2_link_command_linkstart_o   <= '0';
            spw_ch2_link_command_linkdis_o     <= '0';
            spw_ch2_link_command_txdivcnt_o    <= x"01";
            spw_ch2_timecode_tx_tick_in_o      <= '0';
            spw_ch2_timecode_tx_ctrl_in_o      <= (others => '0');
            spw_ch2_timecode_tx_time_in_o      <= (others => '0');
            spw_ch2_errinj_ctrl_start_errinj_o <= '0';
            spw_ch2_errinj_ctrl_reset_errinj_o <= '0';
            spw_ch2_errinj_ctrl_errinj_code_o  <= (others => '0');
			
            spw_ch3_link_command_enable_o      <= '0';
            spw_ch3_link_command_autostart_o   <= '0';
            spw_ch3_link_command_linkstart_o   <= '0';
            spw_ch3_link_command_linkdis_o     <= '0';
            spw_ch3_link_command_txdivcnt_o    <= x"01";
            spw_ch3_timecode_tx_tick_in_o      <= '0';
            spw_ch3_timecode_tx_ctrl_in_o      <= (others => '0');
            spw_ch3_timecode_tx_time_in_o      <= (others => '0');
            spw_ch3_errinj_ctrl_start_errinj_o <= '0';
            spw_ch3_errinj_ctrl_reset_errinj_o <= '0';
            spw_ch3_errinj_ctrl_errinj_code_o  <= (others => '0');
			
            spw_ch4_link_command_enable_o      <= '0';
            spw_ch4_link_command_autostart_o   <= '0';
            spw_ch4_link_command_linkstart_o   <= '0';
            spw_ch4_link_command_linkdis_o     <= '0';
            spw_ch4_link_command_txdivcnt_o    <= x"01";
            spw_ch4_timecode_tx_tick_in_o      <= '0';
            spw_ch4_timecode_tx_ctrl_in_o      <= (others => '0');
            spw_ch4_timecode_tx_time_in_o      <= (others => '0');
            spw_ch4_errinj_ctrl_start_errinj_o <= '0';
            spw_ch4_errinj_ctrl_reset_errinj_o <= '0';
            spw_ch4_errinj_ctrl_errinj_code_o  <= (others => '0');
			
            spw_ch5_link_command_enable_o      <= '0';
            spw_ch5_link_command_autostart_o   <= '0';
            spw_ch5_link_command_linkstart_o   <= '0';
            spw_ch5_link_command_linkdis_o     <= '0';
            spw_ch5_link_command_txdivcnt_o    <= x"01";
            spw_ch5_timecode_tx_tick_in_o      <= '0';
            spw_ch5_timecode_tx_ctrl_in_o      <= (others => '0');
            spw_ch5_timecode_tx_time_in_o      <= (others => '0');
            spw_ch5_errinj_ctrl_start_errinj_o <= '0';
            spw_ch5_errinj_ctrl_reset_errinj_o <= '0';
            spw_ch5_errinj_ctrl_errinj_code_o  <= (others => '0');
			
            spw_ch6_link_command_enable_o      <= '0';
            spw_ch6_link_command_autostart_o   <= '0';
            spw_ch6_link_command_linkstart_o   <= '0';
            spw_ch6_link_command_linkdis_o     <= '0';
            spw_ch6_link_command_txdivcnt_o    <= x"01";
            spw_ch6_timecode_tx_tick_in_o      <= '0';
            spw_ch6_timecode_tx_ctrl_in_o      <= (others => '0');
            spw_ch6_timecode_tx_time_in_o      <= (others => '0');
            spw_ch6_errinj_ctrl_start_errinj_o <= '0';
            spw_ch6_errinj_ctrl_reset_errinj_o <= '0';
            spw_ch6_errinj_ctrl_errinj_code_o  <= (others => '0');
			
            spw_ch7_link_command_enable_o      <= '0';
            spw_ch7_link_command_autostart_o   <= '0';
            spw_ch7_link_command_linkstart_o   <= '0';
            spw_ch7_link_command_linkdis_o     <= '0';
            spw_ch7_link_command_txdivcnt_o    <= x"01";
            spw_ch7_timecode_tx_tick_in_o      <= '0';
            spw_ch7_timecode_tx_ctrl_in_o      <= (others => '0');
            spw_ch7_timecode_tx_time_in_o      <= (others => '0');
            spw_ch7_errinj_ctrl_start_errinj_o <= '0';
            spw_ch7_errinj_ctrl_reset_errinj_o <= '0';
            spw_ch7_errinj_ctrl_errinj_code_o  <= (others => '0');
			
            spw_ch8_link_command_enable_o      <= '0';
            spw_ch8_link_command_autostart_o   <= '0';
            spw_ch8_link_command_linkstart_o   <= '0';
            spw_ch8_link_command_linkdis_o     <= '0';
            spw_ch8_link_command_txdivcnt_o    <= x"01";
            spw_ch8_timecode_tx_tick_in_o      <= '0';
            spw_ch8_timecode_tx_ctrl_in_o      <= (others => '0');
            spw_ch8_timecode_tx_time_in_o      <= (others => '0');
            spw_ch8_errinj_ctrl_start_errinj_o <= '0';
            spw_ch8_errinj_ctrl_reset_errinj_o <= '0';
            spw_ch8_errinj_ctrl_errinj_code_o  <= (others => '0');
			
        elsif rising_edge(a_clock) then
		
            spw_ch1_link_command_enable_o      <= '1';
            spw_ch1_link_command_autostart_o   <= '1';
            spw_ch1_link_command_linkstart_o   <= '0';
            spw_ch1_link_command_linkdis_o     <= '0';
            spw_ch1_link_command_txdivcnt_o    <= x"01";
            spw_ch1_timecode_tx_tick_in_o      <= '0';
            spw_ch1_timecode_tx_ctrl_in_o      <= (others => '0');
            spw_ch1_timecode_tx_time_in_o      <= (others => '0');
            spw_ch1_errinj_ctrl_start_errinj_o <= '0';
            spw_ch1_errinj_ctrl_reset_errinj_o <= '0';
            spw_ch1_errinj_ctrl_errinj_code_o  <= (others => '0');
			
            spw_ch2_link_command_enable_o      <= '1';
            spw_ch2_link_command_autostart_o   <= '1';
            spw_ch2_link_command_linkstart_o   <= '0';
            spw_ch2_link_command_linkdis_o     <= '0';
            spw_ch2_link_command_txdivcnt_o    <= x"01";
            spw_ch2_timecode_tx_tick_in_o      <= '0';
            spw_ch2_timecode_tx_ctrl_in_o      <= (others => '0');
            spw_ch2_timecode_tx_time_in_o      <= (others => '0');
            spw_ch2_errinj_ctrl_start_errinj_o <= '0';
            spw_ch2_errinj_ctrl_reset_errinj_o <= '0';
            spw_ch2_errinj_ctrl_errinj_code_o  <= (others => '0');
			
            spw_ch3_link_command_enable_o      <= '1';
            spw_ch3_link_command_autostart_o   <= '1';
            spw_ch3_link_command_linkstart_o   <= '0';
            spw_ch3_link_command_linkdis_o     <= '0';
            spw_ch3_link_command_txdivcnt_o    <= x"01";
            spw_ch3_timecode_tx_tick_in_o      <= '0';
            spw_ch3_timecode_tx_ctrl_in_o      <= (others => '0');
            spw_ch3_timecode_tx_time_in_o      <= (others => '0');
            spw_ch3_errinj_ctrl_start_errinj_o <= '0';
            spw_ch3_errinj_ctrl_reset_errinj_o <= '0';
            spw_ch3_errinj_ctrl_errinj_code_o  <= (others => '0');
			
            spw_ch4_link_command_enable_o      <= '1';
            spw_ch4_link_command_autostart_o   <= '1';
            spw_ch4_link_command_linkstart_o   <= '0';
            spw_ch4_link_command_linkdis_o     <= '0';
            spw_ch4_link_command_txdivcnt_o    <= x"01";
            spw_ch4_timecode_tx_tick_in_o      <= '0';
            spw_ch4_timecode_tx_ctrl_in_o      <= (others => '0');
            spw_ch4_timecode_tx_time_in_o      <= (others => '0');
            spw_ch4_errinj_ctrl_start_errinj_o <= '0';
            spw_ch4_errinj_ctrl_reset_errinj_o <= '0';
            spw_ch4_errinj_ctrl_errinj_code_o  <= (others => '0');
			
            spw_ch5_link_command_enable_o      <= '1';
            spw_ch5_link_command_autostart_o   <= '1';
            spw_ch5_link_command_linkstart_o   <= '0';
            spw_ch5_link_command_linkdis_o     <= '0';
            spw_ch5_link_command_txdivcnt_o    <= x"01";
            spw_ch5_timecode_tx_tick_in_o      <= '0';
            spw_ch5_timecode_tx_ctrl_in_o      <= (others => '0');
            spw_ch5_timecode_tx_time_in_o      <= (others => '0');
            spw_ch5_errinj_ctrl_start_errinj_o <= '0';
            spw_ch5_errinj_ctrl_reset_errinj_o <= '0';
            spw_ch5_errinj_ctrl_errinj_code_o  <= (others => '0');
			
            spw_ch6_link_command_enable_o      <= '1';
            spw_ch6_link_command_autostart_o   <= '1';
            spw_ch6_link_command_linkstart_o   <= '0';
            spw_ch6_link_command_linkdis_o     <= '0';
            spw_ch6_link_command_txdivcnt_o    <= x"01";
            spw_ch6_timecode_tx_tick_in_o      <= '0';
            spw_ch6_timecode_tx_ctrl_in_o      <= (others => '0');
            spw_ch6_timecode_tx_time_in_o      <= (others => '0');
            spw_ch6_errinj_ctrl_start_errinj_o <= '0';
            spw_ch6_errinj_ctrl_reset_errinj_o <= '0';
            spw_ch6_errinj_ctrl_errinj_code_o  <= (others => '0');
			
            spw_ch7_link_command_enable_o      <= '1';
            spw_ch7_link_command_autostart_o   <= '1';
            spw_ch7_link_command_linkstart_o   <= '0';
            spw_ch7_link_command_linkdis_o     <= '0';
            spw_ch7_link_command_txdivcnt_o    <= x"01";
            spw_ch7_timecode_tx_tick_in_o      <= '0';
            spw_ch7_timecode_tx_ctrl_in_o      <= (others => '0');
            spw_ch7_timecode_tx_time_in_o      <= (others => '0');
            spw_ch7_errinj_ctrl_start_errinj_o <= '0';
            spw_ch7_errinj_ctrl_reset_errinj_o <= '0';
            spw_ch7_errinj_ctrl_errinj_code_o  <= (others => '0');
			
            spw_ch8_link_command_enable_o      <= '1';
            spw_ch8_link_command_autostart_o   <= '1';
            spw_ch8_link_command_linkstart_o   <= '0';
            spw_ch8_link_command_linkdis_o     <= '0';
            spw_ch8_link_command_txdivcnt_o    <= x"01";
            spw_ch8_timecode_tx_tick_in_o      <= '0';
            spw_ch8_timecode_tx_ctrl_in_o      <= (others => '0');
            spw_ch8_timecode_tx_time_in_o      <= (others => '0');
            spw_ch8_errinj_ctrl_start_errinj_o <= '0';
            spw_ch8_errinj_ctrl_reset_errinj_o <= '0';
            spw_ch8_errinj_ctrl_errinj_code_o  <= (others => '0');
			
        end if;
    end process p_spwc_codec_config;

end architecture rtl;                   -- of spwr_spacewire_router_top
