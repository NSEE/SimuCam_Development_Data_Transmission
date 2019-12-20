onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group uart_top /testbench_top/uart_module_top_inst/reset_sink_reset
add wave -noupdate -expand -group uart_top /testbench_top/uart_module_top_inst/clock_sink_clk
add wave -noupdate -expand -group uart_top /testbench_top/uart_module_top_inst/uart_txd
add wave -noupdate -expand -group uart_top /testbench_top/uart_module_top_inst/uart_rxd
add wave -noupdate -expand -group uart_top /testbench_top/uart_module_top_inst/uart_rts
add wave -noupdate -expand -group uart_top /testbench_top/uart_module_top_inst/uart_cts
add wave -noupdate -expand -group uart_top /testbench_top/uart_module_top_inst/avalon_slave_address
add wave -noupdate -expand -group uart_top /testbench_top/uart_module_top_inst/avalon_slave_read
add wave -noupdate -expand -group uart_top /testbench_top/uart_module_top_inst/avalon_slave_write
add wave -noupdate -expand -group uart_top /testbench_top/uart_module_top_inst/avalon_slave_waitrequest
add wave -noupdate -expand -group uart_top /testbench_top/uart_module_top_inst/avalon_slave_writedata
add wave -noupdate -expand -group uart_top /testbench_top/uart_module_top_inst/avalon_slave_readdata
add wave -noupdate -expand -group uart_top /testbench_top/uart_module_top_inst/s_write_registers
add wave -noupdate -expand -group uart_top /testbench_top/uart_module_top_inst/s_read_registers
add wave -noupdate -expand -group uart_top /testbench_top/uart_module_top_inst/s_avalon_mm_read_waitrequest
add wave -noupdate -expand -group uart_top /testbench_top/uart_module_top_inst/s_avalon_mm_write_waitrequest
add wave -noupdate -expand -group uart_top /testbench_top/uart_module_top_inst/s_tx_data_fifo_rdreq
add wave -noupdate -expand -group uart_top /testbench_top/uart_module_top_inst/s_tx_data_fifo_empty
add wave -noupdate -expand -group uart_top /testbench_top/uart_module_top_inst/s_tx_data_fifo_rddata
add wave -noupdate -expand -group uart_top /testbench_top/uart_module_top_inst/s_rx_data_fifo_wrreq
add wave -noupdate -expand -group uart_top /testbench_top/uart_module_top_inst/s_rx_data_fifo_full
add wave -noupdate -expand -group uart_top /testbench_top/uart_module_top_inst/s_rx_data_fifo_wrdata
add wave -noupdate -expand -group uart_tx /testbench_top/uart_module_top_inst/uart_tx_ent_inst/clk_i
add wave -noupdate -expand -group uart_tx /testbench_top/uart_module_top_inst/uart_tx_ent_inst/rst_i
add wave -noupdate -expand -group uart_tx /testbench_top/uart_module_top_inst/uart_tx_ent_inst/uart_tx_fifo_empty_i
add wave -noupdate -expand -group uart_tx /testbench_top/uart_module_top_inst/uart_tx_ent_inst/uart_tx_fifo_rddata_i
add wave -noupdate -expand -group uart_tx /testbench_top/uart_module_top_inst/uart_tx_ent_inst/uart_tx_o
add wave -noupdate -expand -group uart_tx /testbench_top/uart_module_top_inst/uart_tx_ent_inst/uart_tx_fifo_rdreq_o
add wave -noupdate -expand -group uart_tx /testbench_top/uart_module_top_inst/uart_tx_ent_inst/s_uart_tx_state
add wave -noupdate -expand -group uart_tx /testbench_top/uart_module_top_inst/uart_tx_ent_inst/s_data_word
add wave -noupdate -expand -group uart_tx /testbench_top/uart_module_top_inst/uart_tx_ent_inst/s_data_word_cnt
add wave -noupdate -expand -group uart_tx /testbench_top/uart_module_top_inst/uart_tx_ent_inst/s_baud_rate_cnt
add wave -noupdate -expand -group uart_tx /testbench_top/uart_module_top_inst/uart_tx_ent_inst/s_transmitting
add wave -noupdate -expand -group uart_rx /testbench_top/uart_module_top_inst/uart_rx_ent_inst/clk_i
add wave -noupdate -expand -group uart_rx /testbench_top/uart_module_top_inst/uart_rx_ent_inst/rst_i
add wave -noupdate -expand -group uart_rx /testbench_top/uart_module_top_inst/uart_rx_ent_inst/uart_rx_i
add wave -noupdate -expand -group uart_rx /testbench_top/uart_module_top_inst/uart_rx_ent_inst/uart_rx_fifo_full_i
add wave -noupdate -expand -group uart_rx /testbench_top/uart_module_top_inst/uart_rx_ent_inst/uart_rx_fifo_wrreq_o
add wave -noupdate -expand -group uart_rx /testbench_top/uart_module_top_inst/uart_rx_ent_inst/uart_rx_fifo_wrdata_o
add wave -noupdate -expand -group uart_rx /testbench_top/uart_module_top_inst/uart_rx_ent_inst/s_uart_tx_state
add wave -noupdate -expand -group uart_rx /testbench_top/uart_module_top_inst/uart_rx_ent_inst/s_data_word
add wave -noupdate -expand -group uart_rx /testbench_top/uart_module_top_inst/uart_rx_ent_inst/s_data_word_cnt
add wave -noupdate -expand -group uart_rx /testbench_top/uart_module_top_inst/uart_rx_ent_inst/s_baud_rate_cnt
add wave -noupdate -expand -group uart_rx /testbench_top/uart_module_top_inst/uart_rx_ent_inst/s_uart_rx_delayed
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6532 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 289
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {9506 ps}
