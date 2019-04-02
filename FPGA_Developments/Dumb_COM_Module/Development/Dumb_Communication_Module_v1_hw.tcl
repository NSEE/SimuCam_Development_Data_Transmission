# TCL File Generated by Component Editor 16.1
# Tue Apr 02 12:27:36 BRT 2019
# DO NOT MODIFY


# 
# Dumb_Communication_Module_v1 "DCOM_v1" v1
#  2019.04.02.12:27:36
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module Dumb_Communication_Module_v1
# 
set_module_property DESCRIPTION ""
set_module_property NAME Dumb_Communication_Module_v1
set_module_property VERSION 1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME DCOM_v1
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset SIM_VHDL SIM_VHDL "" ""
set_fileset_property SIM_VHDL TOP_LEVEL comm_v1_50_top
set_fileset_property SIM_VHDL ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VHDL ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file dcom_v1_top.vhd VHDL PATH dcom_v1_top.vhd

add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL dcom_v1_top
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file dcom_v1_top.vhd VHDL PATH dcom_v1_top.vhd TOP_LEVEL_FILE


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

add_interface_port reset_sink reset_sink_reset reset Input 1


# 
# connection point spw_conduit_end
# 
add_interface spw_conduit_end conduit end
set_interface_property spw_conduit_end associatedClock clock_sink_200
set_interface_property spw_conduit_end associatedReset reset_sink
set_interface_property spw_conduit_end ENABLED true
set_interface_property spw_conduit_end EXPORT_OF ""
set_interface_property spw_conduit_end PORT_NAME_MAP ""
set_interface_property spw_conduit_end CMSIS_SVD_VARIABLES ""
set_interface_property spw_conduit_end SVD_ADDRESS_GROUP ""

add_interface_port spw_conduit_end data_in data_in_signal Input 1
add_interface_port spw_conduit_end data_out data_out_signal Output 1
add_interface_port spw_conduit_end strobe_in strobe_in_signal Input 1
add_interface_port spw_conduit_end strobe_out strobe_out_signal Output 1


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

add_interface_port sync_conduit_end sync_channel sync_channel_signal Input 1


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

add_interface_port clock_sink_100 clock_sink_100_clk clk Input 1


# 
# connection point clock_sink_200
# 
add_interface clock_sink_200 clock end
set_interface_property clock_sink_200 clockRate 200000000
set_interface_property clock_sink_200 ENABLED true
set_interface_property clock_sink_200 EXPORT_OF ""
set_interface_property clock_sink_200 PORT_NAME_MAP ""
set_interface_property clock_sink_200 CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink_200 SVD_ADDRESS_GROUP ""

add_interface_port clock_sink_200 clock_sink_200_clk clk Input 1


# 
# connection point avalon_slave_data_buffer
# 
add_interface avalon_slave_data_buffer avalon end
set_interface_property avalon_slave_data_buffer addressUnits WORDS
set_interface_property avalon_slave_data_buffer associatedClock clock_sink_100
set_interface_property avalon_slave_data_buffer associatedReset reset_sink
set_interface_property avalon_slave_data_buffer bitsPerSymbol 8
set_interface_property avalon_slave_data_buffer burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_data_buffer burstcountUnits WORDS
set_interface_property avalon_slave_data_buffer explicitAddressSpan 0
set_interface_property avalon_slave_data_buffer holdTime 0
set_interface_property avalon_slave_data_buffer linewrapBursts false
set_interface_property avalon_slave_data_buffer maximumPendingReadTransactions 0
set_interface_property avalon_slave_data_buffer maximumPendingWriteTransactions 0
set_interface_property avalon_slave_data_buffer readLatency 0
set_interface_property avalon_slave_data_buffer readWaitTime 1
set_interface_property avalon_slave_data_buffer setupTime 0
set_interface_property avalon_slave_data_buffer timingUnits Cycles
set_interface_property avalon_slave_data_buffer writeWaitTime 0
set_interface_property avalon_slave_data_buffer ENABLED true
set_interface_property avalon_slave_data_buffer EXPORT_OF ""
set_interface_property avalon_slave_data_buffer PORT_NAME_MAP ""
set_interface_property avalon_slave_data_buffer CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave_data_buffer SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave_data_buffer avalon_slave_data_buffer_address address Input 10
add_interface_port avalon_slave_data_buffer avalon_slave_data_buffer_write write Input 1
add_interface_port avalon_slave_data_buffer avalon_slave_data_buffer_writedata writedata Input 64
add_interface_port avalon_slave_data_buffer avalon_slave_data_buffer_waitrequest waitrequest Output 1
set_interface_assignment avalon_slave_data_buffer embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave_data_buffer embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave_data_buffer embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave_data_buffer embeddedsw.configuration.isPrintableDevice 0


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

add_interface_port avalon_slave_dcom avalon_slave_dcom_address address Input 8
add_interface_port avalon_slave_dcom avalon_slave_dcom_write write Input 1
add_interface_port avalon_slave_dcom avalon_slave_dcom_read read Input 1
add_interface_port avalon_slave_dcom avalon_slave_dcom_readdata readdata Output 32
add_interface_port avalon_slave_dcom avalon_slave_dcom_writedata writedata Input 32
add_interface_port avalon_slave_dcom avalon_slave_dcom_waitrequest waitrequest Output 1
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

add_interface_port tx_interrupt_sender tx_interrupt_sender_irq irq Output 1

