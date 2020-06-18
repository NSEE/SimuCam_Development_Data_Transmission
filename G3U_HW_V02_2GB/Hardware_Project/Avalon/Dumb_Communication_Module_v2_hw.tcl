# TCL File Generated by Component Editor 16.1
# Fri Apr 12 16:30:38 BRT 2019
# DO NOT MODIFY


# 
# Dumb_Communication_Module_v2 "DCOM_v2" v1.1
#  2019.04.12.16:30:38
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module Dumb_Communication_Module_v2
# 
set_module_property DESCRIPTION ""
set_module_property NAME Dumb_Communication_Module_v2
set_module_property VERSION 1.1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME DCOM_v2
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL dcom_v2_top
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file avalon_mm_dcom_registers_pkg.vhd VHDL PATH Dumb_Communications_Module_v2/REGISTERS/avalon_mm_dcom_registers_pkg.vhd
add_fileset_file avalon_mm_dcom_pkg.vhd VHDL PATH Dumb_Communications_Module_v2/AVALON_DCOM_REGISTERS/avalon_mm_dcom_pkg.vhd
add_fileset_file avalon_mm_dcom_read_ent.vhd VHDL PATH Dumb_Communications_Module_v2/AVALON_DCOM_REGISTERS/avalon_mm_dcom_read_ent.vhd
add_fileset_file avalon_mm_dcom_write_ent.vhd VHDL PATH Dumb_Communications_Module_v2/AVALON_DCOM_REGISTERS/avalon_mm_dcom_write_ent.vhd
add_fileset_file avs_byteen_buffer_sc_fifo.vhd VHDL PATH Dumb_Communications_Module_v2/DATA_BUFFER/altera_ipcore/scfifo/avs_byteen_buffer_sc_fifo/avs_byteen_buffer_sc_fifo.vhd
add_fileset_file avs_data_buffer_sc_fifo.vhd VHDL PATH Dumb_Communications_Module_v2/DATA_BUFFER/altera_ipcore/scfifo/avs_data_buffer_sc_fifo/avs_data_buffer_sc_fifo.vhd
add_fileset_file dctrl_data_buffer_sc_fifo.vhd VHDL PATH Dumb_Communications_Module_v2/DATA_BUFFER/altera_ipcore/scfifo/dctrl_data_buffer_sc_fifo/dctrl_data_buffer_sc_fifo.vhd
add_fileset_file data_buffer_pkg.vhd VHDL PATH Dumb_Communications_Module_v2/DATA_BUFFER/data_buffer_pkg.vhd
add_fileset_file data_buffer_ent.vhd VHDL PATH Dumb_Communications_Module_v2/DATA_BUFFER/data_buffer_ent.vhd
add_fileset_file data_controller_ent.vhd VHDL PATH Dumb_Communications_Module_v2/DATA_CONTROLLER/data_controller_ent.vhd
add_fileset_file data_scheduler_ent.vhd VHDL PATH Dumb_Communications_Module_v2/DATA_SCHEDULER/data_scheduler_ent.vhd
add_fileset_file spwpkg.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spacewire_light_codec/spwpkg.vhd
add_fileset_file spwlink.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spacewire_light_codec/spwlink.vhd
add_fileset_file spwram.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spacewire_light_codec/spwram.vhd
add_fileset_file spwrecv.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spacewire_light_codec/spwrecv.vhd
add_fileset_file spwrecvfront_fast.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spacewire_light_codec/spwrecvfront_fast.vhd
add_fileset_file spwrecvfront_generic.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spacewire_light_codec/spwrecvfront_generic.vhd
add_fileset_file spwstream.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spacewire_light_codec/spwstream.vhd
add_fileset_file spwxmit.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spacewire_light_codec/spwxmit.vhd
add_fileset_file spwxmit_fast.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spacewire_light_codec/spwxmit_fast.vhd
add_fileset_file streamtest.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spacewire_light_codec/streamtest.vhd
add_fileset_file syncdff.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spacewire_light_codec/syncdff.vhd
add_fileset_file spw_codec_pkg.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spw_codec_pkg.vhd
add_fileset_file spw_codec.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spw_codec.vhd
add_fileset_file spw_data_dc_fifo.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CLK_SYNCHRONIZATION/altera_ipcore/dcfifo/spw_data_dc_fifo/spw_data_dc_fifo.vhd
add_fileset_file spw_timecode_dc_fifo.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CLK_SYNCHRONIZATION/altera_ipcore/dcfifo/spw_timecode_dc_fifo/spw_timecode_dc_fifo.vhd
add_fileset_file spw_clk_synchronization_ent.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CLK_SYNCHRONIZATION/spw_clk_synchronization_ent.vhd
add_fileset_file rmap_target_crc_pkg.vhd VHDL PATH Dumb_Communications_Module_v2/RMAP_TARGET/rmap_target_crc_pkg.vhd
add_fileset_file rmap_target_pkg.vhd VHDL PATH Dumb_Communications_Module_v2/RMAP_TARGET/rmap_target_pkg.vhd
add_fileset_file rmap_target_command_ent.vhd VHDL PATH Dumb_Communications_Module_v2/RMAP_TARGET/rmap_target_command_ent.vhd
add_fileset_file rmap_target_read_ent.vhd VHDL PATH Dumb_Communications_Module_v2/RMAP_TARGET/rmap_target_read_ent.vhd
add_fileset_file rmap_target_reply_ent.vhd VHDL PATH Dumb_Communications_Module_v2/RMAP_TARGET/rmap_target_reply_ent.vhd
add_fileset_file rmap_target_write_ent.vhd VHDL PATH Dumb_Communications_Module_v2/RMAP_TARGET/rmap_target_write_ent.vhd
add_fileset_file rmap_target_user_ent.vhd VHDL PATH Dumb_Communications_Module_v2/RMAP_TARGET/rmap_target_user_ent.vhd
add_fileset_file rmap_target_top.vhd VHDL PATH Dumb_Communications_Module_v2/RMAP_TARGET/rmap_target_top.vhd
add_fileset_file spw_mux_ent.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_MUX/spw_mux_ent.vhd
add_fileset_file dcom_avm_data_pkg.vhd VHDL PATH Dumb_Communications_Module_v2/DCOM_AVALON_MM_MASTER_DATA/dcom_avm_data_pkg.vhd
add_fileset_file dcom_avm_data_reader_ent.vhd VHDL PATH Dumb_Communications_Module_v2/DCOM_AVALON_MM_MASTER_DATA/dcom_avm_data_reader_ent.vhd
add_fileset_file dcom_avm_reader_controller_ent.vhd VHDL PATH Dumb_Communications_Module_v2/DCOM_AMV_CONTROLLER/dcom_avm_reader_controller_ent.vhd
add_fileset_file dcom_v2_top.vhd VHDL PATH Dumb_Communications_Module_v2/dcom_v2_top.vhd TOP_LEVEL_FILE

add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL dcom_v2_top
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file avalon_mm_dcom_registers_pkg.vhd VHDL PATH Dumb_Communications_Module_v2/REGISTERS/avalon_mm_dcom_registers_pkg.vhd
add_fileset_file avalon_mm_dcom_pkg.vhd VHDL PATH Dumb_Communications_Module_v2/AVALON_DCOM_REGISTERS/avalon_mm_dcom_pkg.vhd
add_fileset_file avalon_mm_dcom_read_ent.vhd VHDL PATH Dumb_Communications_Module_v2/AVALON_DCOM_REGISTERS/avalon_mm_dcom_read_ent.vhd
add_fileset_file avalon_mm_dcom_write_ent.vhd VHDL PATH Dumb_Communications_Module_v2/AVALON_DCOM_REGISTERS/avalon_mm_dcom_write_ent.vhd
add_fileset_file avs_byteen_buffer_sc_fifo.vhd VHDL PATH Dumb_Communications_Module_v2/DATA_BUFFER/altera_ipcore/scfifo/avs_byteen_buffer_sc_fifo/avs_byteen_buffer_sc_fifo.vhd
add_fileset_file avs_data_buffer_sc_fifo.vhd VHDL PATH Dumb_Communications_Module_v2/DATA_BUFFER/altera_ipcore/scfifo/avs_data_buffer_sc_fifo/avs_data_buffer_sc_fifo.vhd
add_fileset_file dctrl_data_buffer_sc_fifo.vhd VHDL PATH Dumb_Communications_Module_v2/DATA_BUFFER/altera_ipcore/scfifo/dctrl_data_buffer_sc_fifo/dctrl_data_buffer_sc_fifo.vhd
add_fileset_file data_buffer_pkg.vhd VHDL PATH Dumb_Communications_Module_v2/DATA_BUFFER/data_buffer_pkg.vhd
add_fileset_file data_buffer_ent.vhd VHDL PATH Dumb_Communications_Module_v2/DATA_BUFFER/data_buffer_ent.vhd
add_fileset_file data_controller_ent.vhd VHDL PATH Dumb_Communications_Module_v2/DATA_CONTROLLER/data_controller_ent.vhd
add_fileset_file data_scheduler_ent.vhd VHDL PATH Dumb_Communications_Module_v2/DATA_SCHEDULER/data_scheduler_ent.vhd
add_fileset_file spwpkg.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spacewire_light_codec/spwpkg.vhd
add_fileset_file spwlink.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spacewire_light_codec/spwlink.vhd
add_fileset_file spwram.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spacewire_light_codec/spwram.vhd
add_fileset_file spwrecv.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spacewire_light_codec/spwrecv.vhd
add_fileset_file spwrecvfront_fast.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spacewire_light_codec/spwrecvfront_fast.vhd
add_fileset_file spwrecvfront_generic.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spacewire_light_codec/spwrecvfront_generic.vhd
add_fileset_file spwstream.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spacewire_light_codec/spwstream.vhd
add_fileset_file spwxmit.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spacewire_light_codec/spwxmit.vhd
add_fileset_file spwxmit_fast.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spacewire_light_codec/spwxmit_fast.vhd
add_fileset_file streamtest.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spacewire_light_codec/streamtest.vhd
add_fileset_file syncdff.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spacewire_light_codec/syncdff.vhd
add_fileset_file spw_codec_pkg.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spw_codec_pkg.vhd
add_fileset_file spw_codec.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CODEC/spw_codec.vhd
add_fileset_file spw_data_dc_fifo.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CLK_SYNCHRONIZATION/altera_ipcore/dcfifo/spw_data_dc_fifo/spw_data_dc_fifo.vhd
add_fileset_file spw_timecode_dc_fifo.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CLK_SYNCHRONIZATION/altera_ipcore/dcfifo/spw_timecode_dc_fifo/spw_timecode_dc_fifo.vhd
add_fileset_file spw_clk_synchronization_ent.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_CLK_SYNCHRONIZATION/spw_clk_synchronization_ent.vhd
add_fileset_file rmap_target_crc_pkg.vhd VHDL PATH Dumb_Communications_Module_v2/RMAP_TARGET/rmap_target_crc_pkg.vhd
add_fileset_file rmap_target_pkg.vhd VHDL PATH Dumb_Communications_Module_v2/RMAP_TARGET/rmap_target_pkg.vhd
add_fileset_file rmap_target_command_ent.vhd VHDL PATH Dumb_Communications_Module_v2/RMAP_TARGET/rmap_target_command_ent.vhd
add_fileset_file rmap_target_read_ent.vhd VHDL PATH Dumb_Communications_Module_v2/RMAP_TARGET/rmap_target_read_ent.vhd
add_fileset_file rmap_target_reply_ent.vhd VHDL PATH Dumb_Communications_Module_v2/RMAP_TARGET/rmap_target_reply_ent.vhd
add_fileset_file rmap_target_write_ent.vhd VHDL PATH Dumb_Communications_Module_v2/RMAP_TARGET/rmap_target_write_ent.vhd
add_fileset_file rmap_target_user_ent.vhd VHDL PATH Dumb_Communications_Module_v2/RMAP_TARGET/rmap_target_user_ent.vhd
add_fileset_file rmap_target_top.vhd VHDL PATH Dumb_Communications_Module_v2/RMAP_TARGET/rmap_target_top.vhd
add_fileset_file spw_mux_ent.vhd VHDL PATH Dumb_Communications_Module_v2/SPW_MUX/spw_mux_ent.vhd
add_fileset_file dcom_avm_data_pkg.vhd VHDL PATH Dumb_Communications_Module_v2/DCOM_AVALON_MM_MASTER_DATA/dcom_avm_data_pkg.vhd
add_fileset_file dcom_avm_data_reader_ent.vhd VHDL PATH Dumb_Communications_Module_v2/DCOM_AVALON_MM_MASTER_DATA/dcom_avm_data_reader_ent.vhd
add_fileset_file dcom_avm_reader_controller_ent.vhd VHDL PATH Dumb_Communications_Module_v2/DCOM_AMV_CONTROLLER/dcom_avm_reader_controller_ent.vhd
add_fileset_file dcom_v2_top.vhd VHDL PATH Dumb_Communications_Module_v2/dcom_v2_top.vhd TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 


# 
# connection point reset_sink
# 
add_interface reset_sink reset end
set_interface_property reset_sink associatedClock clock_sink_100
set_interface_property reset_sink synchronousEdges DEASSERT
set_interface_property reset_sink ENABLED true
set_interface_property reset_sink EXPORT_OF ""
set_interface_property reset_sink PORT_NAME_MAP ""
set_interface_property reset_sink CMSIS_SVD_VARIABLES ""
set_interface_property reset_sink SVD_ADDRESS_GROUP ""

add_interface_port reset_sink reset_sink_reset_i reset Input 1


# 
# connection point sync_conduit_end
# 
add_interface sync_conduit_end conduit end
set_interface_property sync_conduit_end associatedClock clock_sink_100
set_interface_property sync_conduit_end associatedReset reset_sink
set_interface_property sync_conduit_end ENABLED true
set_interface_property sync_conduit_end EXPORT_OF ""
set_interface_property sync_conduit_end PORT_NAME_MAP ""
set_interface_property sync_conduit_end CMSIS_SVD_VARIABLES ""
set_interface_property sync_conduit_end SVD_ADDRESS_GROUP ""

add_interface_port sync_conduit_end sync_channel_i sync_channel_signal Input 1


# 
# connection point clock_sink_100
# 
add_interface clock_sink_100 clock end
set_interface_property clock_sink_100 clockRate 100000000
set_interface_property clock_sink_100 ENABLED true
set_interface_property clock_sink_100 EXPORT_OF ""
set_interface_property clock_sink_100 PORT_NAME_MAP ""
set_interface_property clock_sink_100 CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink_100 SVD_ADDRESS_GROUP ""

add_interface_port clock_sink_100 clock_sink_100_clk_i clk Input 1


# 
# connection point avalon_master_data
# 
add_interface avalon_master_data avalon start
set_interface_property avalon_master_data addressUnits SYMBOLS
set_interface_property avalon_master_data associatedClock clock_sink_100
set_interface_property avalon_master_data associatedReset reset_sink
set_interface_property avalon_master_data bitsPerSymbol 8
set_interface_property avalon_master_data burstOnBurstBoundariesOnly false
set_interface_property avalon_master_data burstcountUnits WORDS
set_interface_property avalon_master_data doStreamReads false
set_interface_property avalon_master_data doStreamWrites false
set_interface_property avalon_master_data holdTime 0
set_interface_property avalon_master_data linewrapBursts false
set_interface_property avalon_master_data maximumPendingReadTransactions 0
set_interface_property avalon_master_data maximumPendingWriteTransactions 0
set_interface_property avalon_master_data readLatency 0
set_interface_property avalon_master_data readWaitTime 1
set_interface_property avalon_master_data setupTime 0
set_interface_property avalon_master_data timingUnits Cycles
set_interface_property avalon_master_data writeWaitTime 0
set_interface_property avalon_master_data ENABLED true
set_interface_property avalon_master_data EXPORT_OF ""
set_interface_property avalon_master_data PORT_NAME_MAP ""
set_interface_property avalon_master_data CMSIS_SVD_VARIABLES ""
set_interface_property avalon_master_data SVD_ADDRESS_GROUP ""

add_interface_port avalon_master_data avalon_master_data_readdata_i readdata Input 64
add_interface_port avalon_master_data avalon_master_data_waitrequest_i waitrequest Input 1
add_interface_port avalon_master_data avalon_master_data_address_o address Output 64
add_interface_port avalon_master_data avalon_master_data_read_o read Output 1


# 
# connection point avalon_slave_dcom
# 
add_interface avalon_slave_dcom avalon end
set_interface_property avalon_slave_dcom addressUnits WORDS
set_interface_property avalon_slave_dcom associatedClock clock_sink_100
set_interface_property avalon_slave_dcom associatedReset reset_sink
set_interface_property avalon_slave_dcom bitsPerSymbol 8
set_interface_property avalon_slave_dcom burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_dcom burstcountUnits WORDS
set_interface_property avalon_slave_dcom explicitAddressSpan 0
set_interface_property avalon_slave_dcom holdTime 0
set_interface_property avalon_slave_dcom linewrapBursts false
set_interface_property avalon_slave_dcom maximumPendingReadTransactions 0
set_interface_property avalon_slave_dcom maximumPendingWriteTransactions 0
set_interface_property avalon_slave_dcom readLatency 0
set_interface_property avalon_slave_dcom readWaitTime 1
set_interface_property avalon_slave_dcom setupTime 0
set_interface_property avalon_slave_dcom timingUnits Cycles
set_interface_property avalon_slave_dcom writeWaitTime 0
set_interface_property avalon_slave_dcom ENABLED true
set_interface_property avalon_slave_dcom EXPORT_OF ""
set_interface_property avalon_slave_dcom PORT_NAME_MAP ""
set_interface_property avalon_slave_dcom CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave_dcom SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave_dcom avalon_slave_dcom_address_i address Input 8
add_interface_port avalon_slave_dcom avalon_slave_dcom_byteenable_i byteenable Input 4
add_interface_port avalon_slave_dcom avalon_slave_dcom_write_i write Input 1
add_interface_port avalon_slave_dcom avalon_slave_dcom_read_i read Input 1
add_interface_port avalon_slave_dcom avalon_slave_dcom_writedata_i writedata Input 32
add_interface_port avalon_slave_dcom avalon_slave_dcom_readdata_o readdata Output 32
add_interface_port avalon_slave_dcom avalon_slave_dcom_waitrequest_o waitrequest Output 1
set_interface_assignment avalon_slave_dcom embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave_dcom embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave_dcom embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave_dcom embeddedsw.configuration.isPrintableDevice 0


# 
# connection point tx_interrupt_sender
# 
add_interface tx_interrupt_sender interrupt end
set_interface_property tx_interrupt_sender associatedAddressablePoint avalon_slave_dcom
set_interface_property tx_interrupt_sender associatedClock clock_sink_100
set_interface_property tx_interrupt_sender associatedReset reset_sink
set_interface_property tx_interrupt_sender bridgedReceiverOffset ""
set_interface_property tx_interrupt_sender bridgesToReceiver ""
set_interface_property tx_interrupt_sender ENABLED true
set_interface_property tx_interrupt_sender EXPORT_OF ""
set_interface_property tx_interrupt_sender PORT_NAME_MAP ""
set_interface_property tx_interrupt_sender CMSIS_SVD_VARIABLES ""
set_interface_property tx_interrupt_sender SVD_ADDRESS_GROUP ""

add_interface_port tx_interrupt_sender tx_interrupt_sender_irq_o irq Output 1


# 
# connection point conduit_end_spacewire_controller
# 
add_interface conduit_end_spacewire_controller conduit end
set_interface_property conduit_end_spacewire_controller associatedClock clock_sink_100
set_interface_property conduit_end_spacewire_controller associatedReset reset_sink
set_interface_property conduit_end_spacewire_controller ENABLED true
set_interface_property conduit_end_spacewire_controller EXPORT_OF ""
set_interface_property conduit_end_spacewire_controller PORT_NAME_MAP ""
set_interface_property conduit_end_spacewire_controller CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_spacewire_controller SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_spacewire_controller spw_link_status_started_i spw_link_status_started_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_link_status_connecting_i spw_link_status_connecting_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_link_status_running_i spw_link_status_running_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_link_error_errdisc_i spw_link_error_errdisc_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_link_error_errpar_i spw_link_error_errpar_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_link_error_erresc_i spw_link_error_erresc_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_link_error_errcred_i spw_link_error_errcred_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_timecode_rx_tick_out_i spw_timecode_rx_tick_out_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_timecode_rx_ctrl_out_i spw_timecode_rx_ctrl_out_signal Input 2
add_interface_port conduit_end_spacewire_controller spw_timecode_rx_time_out_i spw_timecode_rx_time_out_signal Input 6
add_interface_port conduit_end_spacewire_controller spw_data_rx_status_rxvalid_i spw_data_rx_status_rxvalid_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_data_rx_status_rxhalff_i spw_data_rx_status_rxhalff_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_data_rx_status_rxflag_i spw_data_rx_status_rxflag_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_data_rx_status_rxdata_i spw_data_rx_status_rxdata_signal Input 8
add_interface_port conduit_end_spacewire_controller spw_data_tx_status_txrdy_i spw_data_tx_status_txrdy_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_data_tx_status_txhalff_i spw_data_tx_status_txhalff_signal Input 1
add_interface_port conduit_end_spacewire_controller spw_link_command_autostart_o spw_link_command_autostart_signal Output 1
add_interface_port conduit_end_spacewire_controller spw_link_command_linkstart_o spw_link_command_linkstart_signal Output 1
add_interface_port conduit_end_spacewire_controller spw_link_command_linkdis_o spw_link_command_linkdis_signal Output 1
add_interface_port conduit_end_spacewire_controller spw_link_command_txdivcnt_o spw_link_command_txdivcnt_signal Output 8
add_interface_port conduit_end_spacewire_controller spw_timecode_tx_tick_in_o spw_timecode_tx_tick_in_signal Output 1
add_interface_port conduit_end_spacewire_controller spw_timecode_tx_ctrl_in_o spw_timecode_tx_ctrl_in_signal Output 2
add_interface_port conduit_end_spacewire_controller spw_timecode_tx_time_in_o spw_timecode_tx_time_in_signal Output 6
add_interface_port conduit_end_spacewire_controller spw_data_rx_command_rxread_o spw_data_rx_command_rxread_signal Output 1
add_interface_port conduit_end_spacewire_controller spw_data_tx_command_txwrite_o spw_data_tx_command_txwrite_signal Output 1
add_interface_port conduit_end_spacewire_controller spw_data_tx_command_txflag_o spw_data_tx_command_txflag_signal Output 1
add_interface_port conduit_end_spacewire_controller spw_data_tx_command_txdata_o spw_data_tx_command_txdata_signal Output 8


# 
# connection point conduit_end_rmap_master_codec
# 
add_interface conduit_end_rmap_master_codec conduit end
set_interface_property conduit_end_rmap_master_codec associatedClock clock_sink_100
set_interface_property conduit_end_rmap_master_codec associatedReset reset_sink
set_interface_property conduit_end_rmap_master_codec ENABLED true
set_interface_property conduit_end_rmap_master_codec EXPORT_OF ""
set_interface_property conduit_end_rmap_master_codec PORT_NAME_MAP ""
set_interface_property conduit_end_rmap_master_codec CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_rmap_master_codec SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_rmap_master_codec codec_rmap_wr_waitrequest_i wr_waitrequest_signal Input 1
add_interface_port conduit_end_rmap_master_codec codec_rmap_readdata_i readdata_signal Input 8
add_interface_port conduit_end_rmap_master_codec codec_rmap_rd_waitrequest_i rd_waitrequest_signal Input 1
add_interface_port conduit_end_rmap_master_codec codec_rmap_wr_address_o wr_address_signal Output 32
add_interface_port conduit_end_rmap_master_codec codec_rmap_write_o write_signal Output 1
add_interface_port conduit_end_rmap_master_codec codec_rmap_writedata_o writedata_signal Output 8
add_interface_port conduit_end_rmap_master_codec codec_rmap_rd_address_o rd_address_signal Output 32
add_interface_port conduit_end_rmap_master_codec codec_rmap_read_o read_signal Output 1


# 
# connection point conduit_end_rmap_mem_configs_out
# 
add_interface conduit_end_rmap_mem_configs_out conduit end
set_interface_property conduit_end_rmap_mem_configs_out associatedClock clock_sink_100
set_interface_property conduit_end_rmap_mem_configs_out associatedReset reset_sink
set_interface_property conduit_end_rmap_mem_configs_out ENABLED true
set_interface_property conduit_end_rmap_mem_configs_out EXPORT_OF ""
set_interface_property conduit_end_rmap_mem_configs_out PORT_NAME_MAP ""
set_interface_property conduit_end_rmap_mem_configs_out CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_rmap_mem_configs_out SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_rmap_mem_configs_out rmap_mem_addr_offset_o mem_addr_offset_signal Output 32

