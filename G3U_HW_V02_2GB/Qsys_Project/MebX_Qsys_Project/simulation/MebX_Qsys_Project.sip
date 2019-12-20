set_global_assignment -entity "MebX_Qsys_Project" -library "lib_MebX_Qsys_Project" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "MebX_Qsys_Project" -library "lib_MebX_Qsys_Project" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "MebX_Qsys_Project" -library "lib_MebX_Qsys_Project" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_MebX_Qsys_Project" -name SPD_FILE [file join $::quartus(sip_path) "../MebX_Qsys_Project.spd"]
set_global_assignment -library "lib_MebX_Qsys_Project" -name MISC_FILE [file join $::quartus(sip_path) "../../MebX_Qsys_Project.qsys"]

set_global_assignment -library "lib_MebX_Qsys_Project" -name MISC_FILE [file join $::quartus(sip_path) "MebX_Qsys_Project.vhd"]
set_global_assignment -library "lib_MebX_Qsys_Project" -name MISC_FILE [file join $::quartus(sip_path) "mebx_qsys_project_rst_controller_001.vhd"]
set_global_assignment -library "lib_MebX_Qsys_Project" -name MISC_FILE [file join $::quartus(sip_path) "mebx_qsys_project_rst_controller_010.vhd"]
set_global_assignment -library "lib_MebX_Qsys_Project" -name MISC_FILE [file join $::quartus(sip_path) "mebx_qsys_project_rst_controller_011.vhd"]
set_global_assignment -library "lib_MebX_Qsys_Project" -name MISC_FILE [file join $::quartus(sip_path) "mebx_qsys_project_rst_controller_020.vhd"]
set_global_assignment -library "lib_MebX_Qsys_Project" -name MISC_FILE [file join $::quartus(sip_path) "mebx_qsys_project_clock_bridge_afi_50.vhd"]
set_global_assignment -library "lib_MebX_Qsys_Project" -name MISC_FILE [file join $::quartus(sip_path) "mebx_qsys_project_m1_clock_bridge.vhd"]
