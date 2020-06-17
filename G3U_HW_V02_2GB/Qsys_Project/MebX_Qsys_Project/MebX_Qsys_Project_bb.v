
module MebX_Qsys_Project (
	button_export,
	clk50_clk,
	csense_adc_fo_export,
	csense_cs_n_export,
	csense_sck_export,
	csense_sdi_export,
	csense_sdo_export,
	ctrl_io_lvds_export,
	dcom_1_sync_end_sync_channel_signal,
	dcom_2_sync_end_sync_channel_signal,
	dcom_3_sync_end_sync_channel_signal,
	dcom_4_sync_end_sync_channel_signal,
	dcom_5_sync_end_sync_channel_signal,
	dcom_6_sync_end_sync_channel_signal,
	dcom_7_sync_end_sync_channel_signal,
	dcom_8_sync_end_sync_channel_signal,
	dip_export,
	dumb_communication_module_v2_timer_avalon_slave_data_buffer_address,
	dumb_communication_module_v2_timer_avalon_slave_data_buffer_byteenable,
	dumb_communication_module_v2_timer_avalon_slave_data_buffer_write,
	dumb_communication_module_v2_timer_avalon_slave_data_buffer_writedata,
	dumb_communication_module_v2_timer_avalon_slave_data_buffer_waitrequest,
	dumb_communication_module_v2_timer_conduit_end_rmap_master_codec_wr_waitrequest_signal,
	dumb_communication_module_v2_timer_conduit_end_rmap_master_codec_readdata_signal,
	dumb_communication_module_v2_timer_conduit_end_rmap_master_codec_rd_waitrequest_signal,
	dumb_communication_module_v2_timer_conduit_end_rmap_master_codec_wr_address_signal,
	dumb_communication_module_v2_timer_conduit_end_rmap_master_codec_write_signal,
	dumb_communication_module_v2_timer_conduit_end_rmap_master_codec_writedata_signal,
	dumb_communication_module_v2_timer_conduit_end_rmap_master_codec_rd_address_signal,
	dumb_communication_module_v2_timer_conduit_end_rmap_master_codec_read_signal,
	dumb_communication_module_v2_timer_conduit_end_rmap_mem_configs_out_mem_addr_offset_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_link_status_started_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_link_status_connecting_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_link_status_running_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_link_error_errdisc_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_link_error_errpar_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_link_error_erresc_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_link_error_errcred_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_timecode_rx_tick_out_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_timecode_rx_ctrl_out_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_timecode_rx_time_out_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_data_rx_status_rxvalid_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_data_rx_status_rxhalff_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_data_rx_status_rxflag_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_data_rx_status_rxdata_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_data_tx_status_txrdy_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_data_tx_status_txhalff_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_link_command_autostart_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_link_command_linkstart_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_link_command_linkdis_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_link_command_txdivcnt_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_timecode_tx_tick_in_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_timecode_tx_ctrl_in_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_timecode_tx_time_in_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_data_rx_command_rxread_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_data_tx_command_txwrite_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_data_tx_command_txflag_signal,
	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_data_tx_command_txdata_signal,
	dumb_communication_module_v2_timer_sync_conduit_end_sync_channel_signal,
	dumb_communication_module_v2_timer_tx_interrupt_sender_irq,
	eth_rst_export,
	ext_export,
	led_de4_export,
	led_painel_export,
	m1_ddr2_i2c_scl_export,
	m1_ddr2_i2c_sda_export,
	m1_ddr2_memory_mem_a,
	m1_ddr2_memory_mem_ba,
	m1_ddr2_memory_mem_ck,
	m1_ddr2_memory_mem_ck_n,
	m1_ddr2_memory_mem_cke,
	m1_ddr2_memory_mem_cs_n,
	m1_ddr2_memory_mem_dm,
	m1_ddr2_memory_mem_ras_n,
	m1_ddr2_memory_mem_cas_n,
	m1_ddr2_memory_mem_we_n,
	m1_ddr2_memory_mem_dq,
	m1_ddr2_memory_mem_dqs,
	m1_ddr2_memory_mem_dqs_n,
	m1_ddr2_memory_mem_odt,
	m1_ddr2_memory_pll_ref_clk_clk,
	m1_ddr2_memory_status_local_init_done,
	m1_ddr2_memory_status_local_cal_success,
	m1_ddr2_memory_status_local_cal_fail,
	m1_ddr2_oct_rdn,
	m1_ddr2_oct_rup,
	m2_ddr2_i2c_scl_export,
	m2_ddr2_i2c_sda_export,
	m2_ddr2_memory_mem_a,
	m2_ddr2_memory_mem_ba,
	m2_ddr2_memory_mem_ck,
	m2_ddr2_memory_mem_ck_n,
	m2_ddr2_memory_mem_cke,
	m2_ddr2_memory_mem_cs_n,
	m2_ddr2_memory_mem_dm,
	m2_ddr2_memory_mem_ras_n,
	m2_ddr2_memory_mem_cas_n,
	m2_ddr2_memory_mem_we_n,
	m2_ddr2_memory_mem_dq,
	m2_ddr2_memory_mem_dqs,
	m2_ddr2_memory_mem_dqs_n,
	m2_ddr2_memory_mem_odt,
	m2_ddr2_memory_dll_sharing_dll_pll_locked,
	m2_ddr2_memory_dll_sharing_dll_delayctrl,
	m2_ddr2_memory_pll_sharing_pll_mem_clk,
	m2_ddr2_memory_pll_sharing_pll_write_clk,
	m2_ddr2_memory_pll_sharing_pll_locked,
	m2_ddr2_memory_pll_sharing_pll_write_clk_pre_phy_clk,
	m2_ddr2_memory_pll_sharing_pll_addr_cmd_clk,
	m2_ddr2_memory_pll_sharing_pll_avl_clk,
	m2_ddr2_memory_pll_sharing_pll_config_clk,
	m2_ddr2_memory_status_local_init_done,
	m2_ddr2_memory_status_local_cal_success,
	m2_ddr2_memory_status_local_cal_fail,
	m2_ddr2_oct_rdn,
	m2_ddr2_oct_rup,
	rs232_uart_rxd,
	rs232_uart_txd,
	rst_reset_n,
	rst_controller_conduit_reset_input_t_reset_input_signal,
	rst_controller_conduit_simucam_reset_t_simucam_reset_signal,
	rtcc_alarm_export,
	rtcc_cs_n_export,
	rtcc_sck_export,
	rtcc_sdi_export,
	rtcc_sdo_export,
	sd_card_ip_b_SD_cmd,
	sd_card_ip_b_SD_dat,
	sd_card_ip_b_SD_dat3,
	sd_card_ip_o_SD_clock,
	sd_card_wp_n_io_export,
	spwc_a_leds_spw_red_status_led_signal,
	spwc_a_leds_spw_green_status_led_signal,
	spwc_a_lvds_spw_data_in_signal,
	spwc_a_lvds_spw_data_out_signal,
	spwc_a_lvds_spw_strobe_out_signal,
	spwc_a_lvds_spw_strobe_in_signal,
	spwc_b_leds_spw_red_status_led_signal,
	spwc_b_leds_spw_green_status_led_signal,
	spwc_b_lvds_spw_data_in_signal,
	spwc_b_lvds_spw_data_out_signal,
	spwc_b_lvds_spw_strobe_out_signal,
	spwc_b_lvds_spw_strobe_in_signal,
	spwc_c_leds_spw_red_status_led_signal,
	spwc_c_leds_spw_green_status_led_signal,
	spwc_c_lvds_spw_data_in_signal,
	spwc_c_lvds_spw_data_out_signal,
	spwc_c_lvds_spw_strobe_out_signal,
	spwc_c_lvds_spw_strobe_in_signal,
	spwc_d_leds_spw_red_status_led_signal,
	spwc_d_leds_spw_green_status_led_signal,
	spwc_d_lvds_spw_data_in_signal,
	spwc_d_lvds_spw_data_out_signal,
	spwc_d_lvds_spw_strobe_out_signal,
	spwc_d_lvds_spw_strobe_in_signal,
	spwc_e_leds_spw_red_status_led_signal,
	spwc_e_leds_spw_green_status_led_signal,
	spwc_e_lvds_spw_data_in_signal,
	spwc_e_lvds_spw_data_out_signal,
	spwc_e_lvds_spw_strobe_out_signal,
	spwc_e_lvds_spw_strobe_in_signal,
	spwc_f_leds_spw_red_status_led_signal,
	spwc_f_leds_spw_green_status_led_signal,
	spwc_f_lvds_spw_data_in_signal,
	spwc_f_lvds_spw_data_out_signal,
	spwc_f_lvds_spw_strobe_out_signal,
	spwc_f_lvds_spw_strobe_in_signal,
	spwc_g_leds_spw_red_status_led_signal,
	spwc_g_leds_spw_green_status_led_signal,
	spwc_g_lvds_spw_data_in_signal,
	spwc_g_lvds_spw_data_out_signal,
	spwc_g_lvds_spw_strobe_out_signal,
	spwc_g_lvds_spw_strobe_in_signal,
	spwc_h_leds_spw_red_status_led_signal,
	spwc_h_leds_spw_green_status_led_signal,
	spwc_h_lvds_spw_data_in_signal,
	spwc_h_lvds_spw_data_out_signal,
	spwc_h_lvds_spw_strobe_out_signal,
	spwc_h_lvds_spw_strobe_in_signal,
	ssdp_ssdp0,
	ssdp_ssdp1,
	sync_in_conduit,
	sync_out_conduit,
	sync_spw1_conduit,
	sync_spw2_conduit,
	sync_spw3_conduit,
	sync_spw4_conduit,
	sync_spw5_conduit,
	sync_spw6_conduit,
	sync_spw7_conduit,
	sync_spw8_conduit,
	temp_scl_export,
	temp_sda_export,
	timer_1ms_external_port_export,
	timer_1us_external_port_export,
	tristate_conduit_tcm_address_out,
	tristate_conduit_tcm_read_n_out,
	tristate_conduit_tcm_write_n_out,
	tristate_conduit_tcm_data_out,
	tristate_conduit_tcm_chipselect_n_out);	

	input	[3:0]	button_export;
	input		clk50_clk;
	output		csense_adc_fo_export;
	output	[1:0]	csense_cs_n_export;
	output		csense_sck_export;
	output		csense_sdi_export;
	input		csense_sdo_export;
	output	[3:0]	ctrl_io_lvds_export;
	input		dcom_1_sync_end_sync_channel_signal;
	input		dcom_2_sync_end_sync_channel_signal;
	input		dcom_3_sync_end_sync_channel_signal;
	input		dcom_4_sync_end_sync_channel_signal;
	input		dcom_5_sync_end_sync_channel_signal;
	input		dcom_6_sync_end_sync_channel_signal;
	input		dcom_7_sync_end_sync_channel_signal;
	input		dcom_8_sync_end_sync_channel_signal;
	input	[7:0]	dip_export;
	input	[11:0]	dumb_communication_module_v2_timer_avalon_slave_data_buffer_address;
	input	[7:0]	dumb_communication_module_v2_timer_avalon_slave_data_buffer_byteenable;
	input		dumb_communication_module_v2_timer_avalon_slave_data_buffer_write;
	input	[63:0]	dumb_communication_module_v2_timer_avalon_slave_data_buffer_writedata;
	output		dumb_communication_module_v2_timer_avalon_slave_data_buffer_waitrequest;
	input		dumb_communication_module_v2_timer_conduit_end_rmap_master_codec_wr_waitrequest_signal;
	input	[7:0]	dumb_communication_module_v2_timer_conduit_end_rmap_master_codec_readdata_signal;
	input		dumb_communication_module_v2_timer_conduit_end_rmap_master_codec_rd_waitrequest_signal;
	output	[31:0]	dumb_communication_module_v2_timer_conduit_end_rmap_master_codec_wr_address_signal;
	output		dumb_communication_module_v2_timer_conduit_end_rmap_master_codec_write_signal;
	output	[7:0]	dumb_communication_module_v2_timer_conduit_end_rmap_master_codec_writedata_signal;
	output	[31:0]	dumb_communication_module_v2_timer_conduit_end_rmap_master_codec_rd_address_signal;
	output		dumb_communication_module_v2_timer_conduit_end_rmap_master_codec_read_signal;
	output	[31:0]	dumb_communication_module_v2_timer_conduit_end_rmap_mem_configs_out_mem_addr_offset_signal;
	input		dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_link_status_started_signal;
	input		dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_link_status_connecting_signal;
	input		dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_link_status_running_signal;
	input		dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_link_error_errdisc_signal;
	input		dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_link_error_errpar_signal;
	input		dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_link_error_erresc_signal;
	input		dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_link_error_errcred_signal;
	input		dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_timecode_rx_tick_out_signal;
	input	[1:0]	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_timecode_rx_ctrl_out_signal;
	input	[5:0]	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_timecode_rx_time_out_signal;
	input		dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_data_rx_status_rxvalid_signal;
	input		dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_data_rx_status_rxhalff_signal;
	input		dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_data_rx_status_rxflag_signal;
	input	[7:0]	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_data_rx_status_rxdata_signal;
	input		dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_data_tx_status_txrdy_signal;
	input		dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_data_tx_status_txhalff_signal;
	output		dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_link_command_autostart_signal;
	output		dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_link_command_linkstart_signal;
	output		dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_link_command_linkdis_signal;
	output	[7:0]	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_link_command_txdivcnt_signal;
	output		dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_timecode_tx_tick_in_signal;
	output	[1:0]	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_timecode_tx_ctrl_in_signal;
	output	[5:0]	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_timecode_tx_time_in_signal;
	output		dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_data_rx_command_rxread_signal;
	output		dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_data_tx_command_txwrite_signal;
	output		dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_data_tx_command_txflag_signal;
	output	[7:0]	dumb_communication_module_v2_timer_conduit_end_spacewire_controller_spw_data_tx_command_txdata_signal;
	input		dumb_communication_module_v2_timer_sync_conduit_end_sync_channel_signal;
	output		dumb_communication_module_v2_timer_tx_interrupt_sender_irq;
	output		eth_rst_export;
	input		ext_export;
	output	[7:0]	led_de4_export;
	output	[20:0]	led_painel_export;
	output		m1_ddr2_i2c_scl_export;
	inout		m1_ddr2_i2c_sda_export;
	output	[13:0]	m1_ddr2_memory_mem_a;
	output	[2:0]	m1_ddr2_memory_mem_ba;
	output	[1:0]	m1_ddr2_memory_mem_ck;
	output	[1:0]	m1_ddr2_memory_mem_ck_n;
	output	[1:0]	m1_ddr2_memory_mem_cke;
	output	[1:0]	m1_ddr2_memory_mem_cs_n;
	output	[7:0]	m1_ddr2_memory_mem_dm;
	output	[0:0]	m1_ddr2_memory_mem_ras_n;
	output	[0:0]	m1_ddr2_memory_mem_cas_n;
	output	[0:0]	m1_ddr2_memory_mem_we_n;
	inout	[63:0]	m1_ddr2_memory_mem_dq;
	inout	[7:0]	m1_ddr2_memory_mem_dqs;
	inout	[7:0]	m1_ddr2_memory_mem_dqs_n;
	output	[1:0]	m1_ddr2_memory_mem_odt;
	input		m1_ddr2_memory_pll_ref_clk_clk;
	output		m1_ddr2_memory_status_local_init_done;
	output		m1_ddr2_memory_status_local_cal_success;
	output		m1_ddr2_memory_status_local_cal_fail;
	input		m1_ddr2_oct_rdn;
	input		m1_ddr2_oct_rup;
	output		m2_ddr2_i2c_scl_export;
	inout		m2_ddr2_i2c_sda_export;
	output	[13:0]	m2_ddr2_memory_mem_a;
	output	[2:0]	m2_ddr2_memory_mem_ba;
	output	[1:0]	m2_ddr2_memory_mem_ck;
	output	[1:0]	m2_ddr2_memory_mem_ck_n;
	output	[1:0]	m2_ddr2_memory_mem_cke;
	output	[1:0]	m2_ddr2_memory_mem_cs_n;
	output	[7:0]	m2_ddr2_memory_mem_dm;
	output	[0:0]	m2_ddr2_memory_mem_ras_n;
	output	[0:0]	m2_ddr2_memory_mem_cas_n;
	output	[0:0]	m2_ddr2_memory_mem_we_n;
	inout	[63:0]	m2_ddr2_memory_mem_dq;
	inout	[7:0]	m2_ddr2_memory_mem_dqs;
	inout	[7:0]	m2_ddr2_memory_mem_dqs_n;
	output	[1:0]	m2_ddr2_memory_mem_odt;
	input		m2_ddr2_memory_dll_sharing_dll_pll_locked;
	output	[5:0]	m2_ddr2_memory_dll_sharing_dll_delayctrl;
	output		m2_ddr2_memory_pll_sharing_pll_mem_clk;
	output		m2_ddr2_memory_pll_sharing_pll_write_clk;
	output		m2_ddr2_memory_pll_sharing_pll_locked;
	output		m2_ddr2_memory_pll_sharing_pll_write_clk_pre_phy_clk;
	output		m2_ddr2_memory_pll_sharing_pll_addr_cmd_clk;
	output		m2_ddr2_memory_pll_sharing_pll_avl_clk;
	output		m2_ddr2_memory_pll_sharing_pll_config_clk;
	output		m2_ddr2_memory_status_local_init_done;
	output		m2_ddr2_memory_status_local_cal_success;
	output		m2_ddr2_memory_status_local_cal_fail;
	input		m2_ddr2_oct_rdn;
	input		m2_ddr2_oct_rup;
	input		rs232_uart_rxd;
	output		rs232_uart_txd;
	input		rst_reset_n;
	input		rst_controller_conduit_reset_input_t_reset_input_signal;
	output		rst_controller_conduit_simucam_reset_t_simucam_reset_signal;
	input		rtcc_alarm_export;
	output		rtcc_cs_n_export;
	output		rtcc_sck_export;
	output		rtcc_sdi_export;
	input		rtcc_sdo_export;
	inout		sd_card_ip_b_SD_cmd;
	inout		sd_card_ip_b_SD_dat;
	inout		sd_card_ip_b_SD_dat3;
	output		sd_card_ip_o_SD_clock;
	input		sd_card_wp_n_io_export;
	output		spwc_a_leds_spw_red_status_led_signal;
	output		spwc_a_leds_spw_green_status_led_signal;
	input		spwc_a_lvds_spw_data_in_signal;
	output		spwc_a_lvds_spw_data_out_signal;
	output		spwc_a_lvds_spw_strobe_out_signal;
	input		spwc_a_lvds_spw_strobe_in_signal;
	output		spwc_b_leds_spw_red_status_led_signal;
	output		spwc_b_leds_spw_green_status_led_signal;
	input		spwc_b_lvds_spw_data_in_signal;
	output		spwc_b_lvds_spw_data_out_signal;
	output		spwc_b_lvds_spw_strobe_out_signal;
	input		spwc_b_lvds_spw_strobe_in_signal;
	output		spwc_c_leds_spw_red_status_led_signal;
	output		spwc_c_leds_spw_green_status_led_signal;
	input		spwc_c_lvds_spw_data_in_signal;
	output		spwc_c_lvds_spw_data_out_signal;
	output		spwc_c_lvds_spw_strobe_out_signal;
	input		spwc_c_lvds_spw_strobe_in_signal;
	output		spwc_d_leds_spw_red_status_led_signal;
	output		spwc_d_leds_spw_green_status_led_signal;
	input		spwc_d_lvds_spw_data_in_signal;
	output		spwc_d_lvds_spw_data_out_signal;
	output		spwc_d_lvds_spw_strobe_out_signal;
	input		spwc_d_lvds_spw_strobe_in_signal;
	output		spwc_e_leds_spw_red_status_led_signal;
	output		spwc_e_leds_spw_green_status_led_signal;
	input		spwc_e_lvds_spw_data_in_signal;
	output		spwc_e_lvds_spw_data_out_signal;
	output		spwc_e_lvds_spw_strobe_out_signal;
	input		spwc_e_lvds_spw_strobe_in_signal;
	output		spwc_f_leds_spw_red_status_led_signal;
	output		spwc_f_leds_spw_green_status_led_signal;
	input		spwc_f_lvds_spw_data_in_signal;
	output		spwc_f_lvds_spw_data_out_signal;
	output		spwc_f_lvds_spw_strobe_out_signal;
	input		spwc_f_lvds_spw_strobe_in_signal;
	output		spwc_g_leds_spw_red_status_led_signal;
	output		spwc_g_leds_spw_green_status_led_signal;
	input		spwc_g_lvds_spw_data_in_signal;
	output		spwc_g_lvds_spw_data_out_signal;
	output		spwc_g_lvds_spw_strobe_out_signal;
	input		spwc_g_lvds_spw_strobe_in_signal;
	output		spwc_h_leds_spw_red_status_led_signal;
	output		spwc_h_leds_spw_green_status_led_signal;
	input		spwc_h_lvds_spw_data_in_signal;
	output		spwc_h_lvds_spw_data_out_signal;
	output		spwc_h_lvds_spw_strobe_out_signal;
	input		spwc_h_lvds_spw_strobe_in_signal;
	output	[7:0]	ssdp_ssdp0;
	output	[7:0]	ssdp_ssdp1;
	input		sync_in_conduit;
	output		sync_out_conduit;
	output		sync_spw1_conduit;
	output		sync_spw2_conduit;
	output		sync_spw3_conduit;
	output		sync_spw4_conduit;
	output		sync_spw5_conduit;
	output		sync_spw6_conduit;
	output		sync_spw7_conduit;
	output		sync_spw8_conduit;
	output		temp_scl_export;
	inout		temp_sda_export;
	output		timer_1ms_external_port_export;
	output		timer_1us_external_port_export;
	output	[25:0]	tristate_conduit_tcm_address_out;
	output	[0:0]	tristate_conduit_tcm_read_n_out;
	output	[0:0]	tristate_conduit_tcm_write_n_out;
	inout	[15:0]	tristate_conduit_tcm_data_out;
	output	[0:0]	tristate_conduit_tcm_chipselect_n_out;
endmodule
