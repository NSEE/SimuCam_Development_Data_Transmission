onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/clk50_clk
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/rs232_uart_rxd
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/rs232_uart_txd
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/rs232_uart_cts_n
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/rs232_uart_rts_n
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/rs232_uart_irq_irq
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/rst_reset_n
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/uart_module_uart_txd_signal
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/uart_module_uart_rxd_signal
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/uart_module_uart_rts_signal
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/uart_module_uart_cts_signal
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/uart_module_top_0_avalon_slave_address
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/uart_module_top_0_avalon_slave_read
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/uart_module_top_0_avalon_slave_write
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/uart_module_top_0_avalon_slave_waitrequest
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/uart_module_top_0_avalon_slave_writedata
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/uart_module_top_0_avalon_slave_readdata
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/uart_module_top_0_avalon_master_readdata
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/uart_module_top_0_avalon_master_waitrequest
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/uart_module_top_0_avalon_master_address
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/uart_module_top_0_avalon_master_read
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/uart_module_top_0_avalon_master_write
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/uart_module_top_0_avalon_master_writedata
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/mm_interconnect_0_rs232_uart_s1_chipselect
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/mm_interconnect_0_rs232_uart_s1_readdata
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/mm_interconnect_0_rs232_uart_s1_address
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/mm_interconnect_0_rs232_uart_s1_read
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/mm_interconnect_0_rs232_uart_s1_begintransfer
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/mm_interconnect_0_rs232_uart_s1_write
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/mm_interconnect_0_rs232_uart_s1_writedata
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/rst_controller_reset_out_reset
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/rst_reset_n_ports_inv
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/mm_interconnect_0_rs232_uart_s1_read_ports_inv
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/mm_interconnect_0_rs232_uart_s1_write_ports_inv
add wave -noupdate -group mebx_qsys_project /mebx_qsys_project/rst_controller_reset_out_reset_ports_inv
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/address
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/begintransfer
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/chipselect
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/clk
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/cts_n
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/read_n
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/reset_n
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/rxd
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/write_n
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/writedata
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/dataavailable
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/irq
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/readdata
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/readyfordata
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/rts_n
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/txd
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/baud_divisor
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/break_detect
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/clk_en
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/do_force_break
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/framing_error
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/internal_dataavailable
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/internal_irq
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/internal_readdata
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/internal_readyfordata
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/internal_rts_n
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/internal_txd
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/parity_error
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/rx_char_ready
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/rx_data
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/rx_overrun
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/rx_rd_strobe
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/status_wr_strobe
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/tx_data
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/tx_overrun
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/tx_ready
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/tx_shift_empty
add wave -noupdate -group rs232_uart /mebx_qsys_project/rs232_uart/tx_wr_strobe
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/reset_sink_reset
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/clock_sink_clk
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/uart_txd
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/uart_rxd
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/uart_rts
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/uart_cts
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/avalon_slave_address
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/avalon_slave_read
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/avalon_slave_write
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/avalon_slave_waitrequest
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/avalon_slave_writedata
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/avalon_slave_readdata
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/avalon_master_address
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/avalon_master_read
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/avalon_master_write
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/avalon_master_writedata
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/avalon_master_readdata
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/avalon_master_waitrequest
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/s_write_registers
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/s_read_registers
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/s_avalon_mm_read_waitrequest
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/s_avalon_mm_write_waitrequest
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/s_tx_data_fifo_rdreq
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/s_tx_data_fifo_empty
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/s_tx_data_fifo_rddata
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/s_rx_data_fifo_wrreq
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/s_rx_data_fifo_full
add wave -noupdate -group uart_module_top_0 /mebx_qsys_project/uart_module_top_0/s_rx_data_fifo_wrdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3970 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 546
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
WaveRestoreZoom {0 ps} {18299 ps}
