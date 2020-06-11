onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group config_stimuli /testbench_top/config_avalon_stimuli_inst/clk_i
add wave -noupdate -group config_stimuli /testbench_top/config_avalon_stimuli_inst/rst_i
add wave -noupdate -group config_stimuli /testbench_top/config_avalon_stimuli_inst/avalon_mm_readdata_i
add wave -noupdate -group config_stimuli /testbench_top/config_avalon_stimuli_inst/avalon_mm_waitrequest_i
add wave -noupdate -group config_stimuli /testbench_top/config_avalon_stimuli_inst/avalon_mm_address_o
add wave -noupdate -group config_stimuli /testbench_top/config_avalon_stimuli_inst/avalon_mm_write_o
add wave -noupdate -group config_stimuli /testbench_top/config_avalon_stimuli_inst/avalon_mm_writedata_o
add wave -noupdate -group config_stimuli /testbench_top/config_avalon_stimuli_inst/avalon_mm_read_o
add wave -noupdate -group config_stimuli /testbench_top/config_avalon_stimuli_inst/s_counter
add wave -noupdate -group buffer_stimuli /testbench_top/avalon_buffer_stimuli_inst/clk_i
add wave -noupdate -group buffer_stimuli /testbench_top/avalon_buffer_stimuli_inst/rst_i
add wave -noupdate -group buffer_stimuli /testbench_top/avalon_buffer_stimuli_inst/avalon_mm_waitrequest_i
add wave -noupdate -group buffer_stimuli /testbench_top/avalon_buffer_stimuli_inst/avalon_mm_address_o
add wave -noupdate -group buffer_stimuli /testbench_top/avalon_buffer_stimuli_inst/avalon_mm_write_o
add wave -noupdate -group buffer_stimuli /testbench_top/avalon_buffer_stimuli_inst/avalon_mm_writedata_o
add wave -noupdate -group buffer_stimuli /testbench_top/avalon_buffer_stimuli_inst/avalon_mm_byteenable_o
add wave -noupdate -group buffer_stimuli /testbench_top/avalon_buffer_stimuli_inst/s_counter
add wave -noupdate -group buffer_stimuli /testbench_top/avalon_buffer_stimuli_inst/s_address_cnt
add wave -noupdate -group buffer_stimuli /testbench_top/avalon_buffer_stimuli_inst/s_mask_cnt
add wave -noupdate -group buffer_stimuli /testbench_top/avalon_buffer_stimuli_inst/s_times_cnt
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/reset_sink_reset
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/data_in
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/data_out
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/strobe_in
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/strobe_out
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/sync_channel
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/clock_sink_100_clk
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/clock_sink_200_clk
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/avalon_slave_data_buffer_address
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/avalon_slave_data_buffer_write
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/avalon_slave_data_buffer_writedata
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/avalon_slave_data_buffer_byteenable
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/avalon_slave_data_buffer_waitrequest
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/avalon_slave_dcom_address
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/avalon_slave_dcom_write
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/avalon_slave_dcom_read
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/avalon_slave_dcom_readdata
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/avalon_slave_dcom_writedata
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/avalon_slave_dcom_waitrequest
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/tx_interrupt_sender_irq
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_dcom_avalon_mm_read_waitrequest
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_dcom_avalon_mm_write_waitrequest
add wave -noupdate -group dcom_v1 -expand -subitemconfig {/testbench_top/dcom_v1_top_inst/s_dcom_write_registers.data_scheduler_timer_clkdiv_reg {-height 15 -childformat {{/testbench_top/dcom_v1_top_inst/s_dcom_write_registers.data_scheduler_timer_clkdiv_reg.timer_clk_div -radix unsigned}}} /testbench_top/dcom_v1_top_inst/s_dcom_write_registers.data_scheduler_timer_clkdiv_reg.timer_clk_div {-height 15 -radix unsigned} /testbench_top/dcom_v1_top_inst/s_dcom_write_registers.data_scheduler_timer_time_in_reg {-height 15 -childformat {{/testbench_top/dcom_v1_top_inst/s_dcom_write_registers.data_scheduler_timer_time_in_reg.timer_time_in -radix unsigned}}} /testbench_top/dcom_v1_top_inst/s_dcom_write_registers.data_scheduler_timer_time_in_reg.timer_time_in {-height 15 -radix unsigned} /testbench_top/dcom_v1_top_inst/s_dcom_write_registers.data_scheduler_timer_control_reg -expand /testbench_top/dcom_v1_top_inst/s_dcom_write_registers.dcom_irq_flags_clear_reg -expand} /testbench_top/dcom_v1_top_inst/s_dcom_write_registers
add wave -noupdate -group dcom_v1 -expand /testbench_top/dcom_v1_top_inst/s_dcom_read_registers
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_avs_dbuffer_wrdata
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_avs_dbuffer_wrreq
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_avs_dbuffer_full
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_avs_bebuffer_wrdata
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_avs_bebuffer_wrreq
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_avs_bebuffer_full
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_dcrtl_dbuffer_rddata
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_dcrtl_dbuffer_rdreq
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_dcrtl_dbuffer_empty
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_dctrl_tx_begin
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_dctrl_tx_ended
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_dctrl_spw_tx_ready
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_dctrl_spw_tx_write
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_dctrl_spw_tx_flag
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_dctrl_spw_tx_data
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_spw_codec_link_command_clk100
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_spw_codec_link_status_clk100
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_spw_codec_link_error_clk100
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_spw_codec_timecode_rx_clk100
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_spw_codec_data_rx_status_clk100
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_spw_codec_data_tx_status_clk100
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_spw_codec_timecode_tx_clk100
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_spw_codec_data_rx_command_clk100
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_spw_codec_data_tx_command_clk100
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_spw_codec_link_command_clk200
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_spw_codec_link_status_clk200
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_spw_codec_link_error_clk200
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_spw_codec_timecode_rx_clk200
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_spw_codec_data_rx_status_clk200
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_spw_codec_data_tx_status_clk200
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_spw_codec_timecode_tx_clk200
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_spw_codec_data_rx_command_clk200
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_spw_codec_data_tx_command_clk200
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_rxtc_tick_out
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_txirq_tx_begin_delayed
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_txirq_tx_ended_delayed
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_sync_in_trigger
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_sync_in_delayed
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_sync_channel_n
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_spw_dummy_rxvalid
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/s_spw_dummy_rxread
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/a_reset
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/a_avs_clock
add wave -noupdate -group dcom_v1 /testbench_top/dcom_v1_top_inst/a_spw_clock
add wave -noupdate -group dcom_rd /testbench_top/dcom_v1_top_inst/avalon_mm_dcom_read_ent_inst/clk_i
add wave -noupdate -group dcom_rd /testbench_top/dcom_v1_top_inst/avalon_mm_dcom_read_ent_inst/rst_i
add wave -noupdate -group dcom_rd /testbench_top/dcom_v1_top_inst/avalon_mm_dcom_read_ent_inst/avalon_mm_dcom_i
add wave -noupdate -group dcom_rd /testbench_top/dcom_v1_top_inst/avalon_mm_dcom_read_ent_inst/dcom_write_registers_i
add wave -noupdate -group dcom_rd /testbench_top/dcom_v1_top_inst/avalon_mm_dcom_read_ent_inst/dcom_read_registers_i
add wave -noupdate -group dcom_rd /testbench_top/dcom_v1_top_inst/avalon_mm_dcom_read_ent_inst/avalon_mm_dcom_o
add wave -noupdate -group dcom_wr /testbench_top/dcom_v1_top_inst/avalon_mm_dcom_write_ent_inst/clk_i
add wave -noupdate -group dcom_wr /testbench_top/dcom_v1_top_inst/avalon_mm_dcom_write_ent_inst/rst_i
add wave -noupdate -group dcom_wr /testbench_top/dcom_v1_top_inst/avalon_mm_dcom_write_ent_inst/avalon_mm_dcom_i
add wave -noupdate -group dcom_wr /testbench_top/dcom_v1_top_inst/avalon_mm_dcom_write_ent_inst/avalon_mm_dcom_o
add wave -noupdate -group dcom_wr /testbench_top/dcom_v1_top_inst/avalon_mm_dcom_write_ent_inst/dcom_write_registers_o
add wave -noupdate -group data_buffer_wr /testbench_top/dcom_v1_top_inst/avalon_mm_data_buffer_write_ent_inst/clk_i
add wave -noupdate -group data_buffer_wr /testbench_top/dcom_v1_top_inst/avalon_mm_data_buffer_write_ent_inst/rst_i
add wave -noupdate -group data_buffer_wr /testbench_top/dcom_v1_top_inst/avalon_mm_data_buffer_write_ent_inst/avalon_mm_data_buffer_i
add wave -noupdate -group data_buffer_wr /testbench_top/dcom_v1_top_inst/avalon_mm_data_buffer_write_ent_inst/avs_dbuffer_full_i
add wave -noupdate -group data_buffer_wr /testbench_top/dcom_v1_top_inst/avalon_mm_data_buffer_write_ent_inst/avs_bebuffer_full_i
add wave -noupdate -group data_buffer_wr /testbench_top/dcom_v1_top_inst/avalon_mm_data_buffer_write_ent_inst/avalon_mm_data_buffer_o
add wave -noupdate -group data_buffer_wr /testbench_top/dcom_v1_top_inst/avalon_mm_data_buffer_write_ent_inst/avs_dbuffer_wrreq_o
add wave -noupdate -group data_buffer_wr -radix hexadecimal /testbench_top/dcom_v1_top_inst/avalon_mm_data_buffer_write_ent_inst/avs_dbuffer_wrdata_o
add wave -noupdate -group data_buffer_wr /testbench_top/dcom_v1_top_inst/avalon_mm_data_buffer_write_ent_inst/avs_bebuffer_wrreq_o
add wave -noupdate -group data_buffer_wr /testbench_top/dcom_v1_top_inst/avalon_mm_data_buffer_write_ent_inst/avs_bebuffer_wrdata_o
add wave -noupdate -group data_buffer_wr /testbench_top/dcom_v1_top_inst/avalon_mm_data_buffer_write_ent_inst/s_data_written
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/clk_i
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/rst_i
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/tmr_clear_i
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/tmr_stop_i
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/tmr_start_i
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/avs_dbuffer_wrdata_i
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/avs_dbuffer_wrreq_i
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/avs_bebuffer_wrdata_i
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/avs_bebuffer_wrreq_i
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/dcrtl_dbuffer_rdreq_i
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/dbuff_empty_o
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/dbuff_full_o
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/dbuff_usedw_o
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/avs_dbuffer_full_o
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/avs_bebuffer_full_o
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/dcrtl_dbuffer_rddata_o
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/dcrtl_dbuffer_empty_o
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/s_avs_dbuffer_fifo
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/s_avs_dbuffer_sclr
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/s_avs_bebuffer_fifo
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/s_avs_bebuffer_sclr
add wave -noupdate -group data_buffer -childformat {{/testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/s_dctrl_dbuffer_fifo.data -radix unsigned}} -expand -subitemconfig {/testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/s_dctrl_dbuffer_fifo.data {-height 15 -radix unsigned}} /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/s_dctrl_dbuffer_fifo
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/s_dctrl_dbuffer_sclr
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/s_data_buffer_state
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/s_byte_counter
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/s_avs_dbuffer_data_bytes
add wave -noupdate -group data_buffer /testbench_top/dcom_v1_top_inst/data_buffer_ent_inst/s_avs_bebuffer_data_bits
add wave -noupdate -group data_controller /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/clk_i
add wave -noupdate -group data_controller /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/rst_i
add wave -noupdate -group data_controller -radix unsigned /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/tmr_time_i
add wave -noupdate -group data_controller /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/tmr_stop_i
add wave -noupdate -group data_controller /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/tmr_start_i
add wave -noupdate -group data_controller /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/dctrl_send_eep_i
add wave -noupdate -group data_controller /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/dctrl_send_eop_i
add wave -noupdate -group data_controller /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/dbuffer_empty_i
add wave -noupdate -group data_controller -radix unsigned /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/dbuffer_rddata_i
add wave -noupdate -group data_controller /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/spw_tx_ready_i
add wave -noupdate -group data_controller /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/dctrl_tx_begin_o
add wave -noupdate -group data_controller /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/dctrl_tx_ended_o
add wave -noupdate -group data_controller /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/dbuffer_rdreq_o
add wave -noupdate -group data_controller /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/spw_tx_write_o
add wave -noupdate -group data_controller /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/spw_tx_flag_o
add wave -noupdate -group data_controller -radix unsigned /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/spw_tx_data_o
add wave -noupdate -group data_controller /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/s_data_controller_state
add wave -noupdate -group data_controller /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/s_data_controller_return_state
add wave -noupdate -group data_controller -radix unsigned /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/s_word_counter
add wave -noupdate -group data_controller -radix unsigned /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/s_data_packet_length
add wave -noupdate -group data_controller -radix hexadecimal -childformat {{/testbench_top/dcom_v1_top_inst/data_controller_ent_inst/s_data_packet_length_words(0) -radix hexadecimal} {/testbench_top/dcom_v1_top_inst/data_controller_ent_inst/s_data_packet_length_words(1) -radix hexadecimal}} -subitemconfig {/testbench_top/dcom_v1_top_inst/data_controller_ent_inst/s_data_packet_length_words(0) {-height 15 -radix hexadecimal} /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/s_data_packet_length_words(1) {-height 15 -radix hexadecimal}} /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/s_data_packet_length_words
add wave -noupdate -group data_controller -radix unsigned /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/s_data_packet_time
add wave -noupdate -group data_controller -radix hexadecimal -childformat {{/testbench_top/dcom_v1_top_inst/data_controller_ent_inst/s_data_packet_time_words(0) -radix hexadecimal} {/testbench_top/dcom_v1_top_inst/data_controller_ent_inst/s_data_packet_time_words(1) -radix hexadecimal} {/testbench_top/dcom_v1_top_inst/data_controller_ent_inst/s_data_packet_time_words(2) -radix hexadecimal} {/testbench_top/dcom_v1_top_inst/data_controller_ent_inst/s_data_packet_time_words(3) -radix hexadecimal}} -subitemconfig {/testbench_top/dcom_v1_top_inst/data_controller_ent_inst/s_data_packet_time_words(0) {-height 15 -radix hexadecimal} /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/s_data_packet_time_words(1) {-height 15 -radix hexadecimal} /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/s_data_packet_time_words(2) {-height 15 -radix hexadecimal} /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/s_data_packet_time_words(3) {-height 15 -radix hexadecimal}} /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/s_data_packet_time_words
add wave -noupdate -group data_controller /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/s_spw_transmitting
add wave -noupdate -group data_controller /testbench_top/dcom_v1_top_inst/data_controller_ent_inst/s_alignment_counter
add wave -noupdate -group data_scheduler /testbench_top/dcom_v1_top_inst/data_scheduler_ent_inst/clk_i
add wave -noupdate -group data_scheduler /testbench_top/dcom_v1_top_inst/data_scheduler_ent_inst/rst_i
add wave -noupdate -group data_scheduler /testbench_top/dcom_v1_top_inst/data_scheduler_ent_inst/tmr_run_on_sync_i
add wave -noupdate -group data_scheduler -radix unsigned /testbench_top/dcom_v1_top_inst/data_scheduler_ent_inst/tmr_clk_div_i
add wave -noupdate -group data_scheduler -radix unsigned /testbench_top/dcom_v1_top_inst/data_scheduler_ent_inst/tmr_time_in_i
add wave -noupdate -group data_scheduler /testbench_top/dcom_v1_top_inst/data_scheduler_ent_inst/tmr_clear_i
add wave -noupdate -group data_scheduler /testbench_top/dcom_v1_top_inst/data_scheduler_ent_inst/tmr_stop_i
add wave -noupdate -group data_scheduler /testbench_top/dcom_v1_top_inst/data_scheduler_ent_inst/tmr_run_i
add wave -noupdate -group data_scheduler /testbench_top/dcom_v1_top_inst/data_scheduler_ent_inst/tmr_start_i
add wave -noupdate -group data_scheduler /testbench_top/dcom_v1_top_inst/data_scheduler_ent_inst/sync_i
add wave -noupdate -group data_scheduler /testbench_top/dcom_v1_top_inst/data_scheduler_ent_inst/tmr_cleared_o
add wave -noupdate -group data_scheduler /testbench_top/dcom_v1_top_inst/data_scheduler_ent_inst/tmr_running_o
add wave -noupdate -group data_scheduler /testbench_top/dcom_v1_top_inst/data_scheduler_ent_inst/tmr_started_o
add wave -noupdate -group data_scheduler /testbench_top/dcom_v1_top_inst/data_scheduler_ent_inst/tmr_stopped_o
add wave -noupdate -group data_scheduler -radix unsigned /testbench_top/dcom_v1_top_inst/data_scheduler_ent_inst/tmr_time_out_o
add wave -noupdate -group data_scheduler /testbench_top/dcom_v1_top_inst/data_scheduler_ent_inst/s_data_scheduler_state
add wave -noupdate -group data_scheduler -radix unsigned /testbench_top/dcom_v1_top_inst/data_scheduler_ent_inst/s_tmr_time
add wave -noupdate -group data_scheduler -radix unsigned /testbench_top/dcom_v1_top_inst/data_scheduler_ent_inst/s_tmr_registered_clkdiv
add wave -noupdate -group data_scheduler -radix unsigned /testbench_top/dcom_v1_top_inst/data_scheduler_ent_inst/s_tmr_evt_counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 273
configure wave -valuecolwidth 132
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {525 us}
