	component MebX_Qsys_Project is
		port (
			button_export                                                           : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			clk50_clk                                                               : in    std_logic                     := 'X';             -- clk
			csense_adc_fo_export                                                    : out   std_logic;                                        -- export
			csense_cs_n_export                                                      : out   std_logic_vector(1 downto 0);                     -- export
			csense_sck_export                                                       : out   std_logic;                                        -- export
			csense_sdi_export                                                       : out   std_logic;                                        -- export
			csense_sdo_export                                                       : in    std_logic                     := 'X';             -- export
			ctrl_io_lvds_export                                                     : out   std_logic_vector(3 downto 0);                     -- export
			dcom_a_conduit_end_data_in_signal                                       : in    std_logic                     := 'X';             -- data_in_signal
			dcom_a_conduit_end_data_out_signal                                      : out   std_logic;                                        -- data_out_signal
			dcom_a_conduit_end_strobe_in_signal                                     : in    std_logic                     := 'X';             -- strobe_in_signal
			dcom_a_conduit_end_strobe_out_signal                                    : out   std_logic;                                        -- strobe_out_signal
			dcom_a_sync_end_sync_channel_signal                                     : in    std_logic                     := 'X';             -- sync_channel_signal
			dcom_b_conduit_end_data_in_signal                                       : in    std_logic                     := 'X';             -- data_in_signal
			dcom_b_conduit_end_data_out_signal                                      : out   std_logic;                                        -- data_out_signal
			dcom_b_conduit_end_strobe_in_signal                                     : in    std_logic                     := 'X';             -- strobe_in_signal
			dcom_b_conduit_end_strobe_out_signal                                    : out   std_logic;                                        -- strobe_out_signal
			dcom_b_sync_end_sync_channel_signal                                     : in    std_logic                     := 'X';             -- sync_channel_signal
			dcom_c_conduit_end_data_in_signal                                       : in    std_logic                     := 'X';             -- data_in_signal
			dcom_c_conduit_end_data_out_signal                                      : out   std_logic;                                        -- data_out_signal
			dcom_c_conduit_end_strobe_in_signal                                     : in    std_logic                     := 'X';             -- strobe_in_signal
			dcom_c_conduit_end_strobe_out_signal                                    : out   std_logic;                                        -- strobe_out_signal
			dcom_c_sync_end_sync_channel_signal                                     : in    std_logic                     := 'X';             -- sync_channel_signal
			dcom_d_conduit_end_data_in_signal                                       : in    std_logic                     := 'X';             -- data_in_signal
			dcom_d_conduit_end_data_out_signal                                      : out   std_logic;                                        -- data_out_signal
			dcom_d_conduit_end_strobe_in_signal                                     : in    std_logic                     := 'X';             -- strobe_in_signal
			dcom_d_conduit_end_strobe_out_signal                                    : out   std_logic;                                        -- strobe_out_signal
			dcom_d_sync_end_sync_channel_signal                                     : in    std_logic                     := 'X';             -- sync_channel_signal
			dcom_e_conduit_end_data_in_signal                                       : in    std_logic                     := 'X';             -- data_in_signal
			dcom_e_conduit_end_data_out_signal                                      : out   std_logic;                                        -- data_out_signal
			dcom_e_conduit_end_strobe_in_signal                                     : in    std_logic                     := 'X';             -- strobe_in_signal
			dcom_e_conduit_end_strobe_out_signal                                    : out   std_logic;                                        -- strobe_out_signal
			dcom_e_sync_end_sync_channel_signal                                     : in    std_logic                     := 'X';             -- sync_channel_signal
			dcom_f_conduit_end_data_in_signal                                       : in    std_logic                     := 'X';             -- data_in_signal
			dcom_f_conduit_end_data_out_signal                                      : out   std_logic;                                        -- data_out_signal
			dcom_f_conduit_end_strobe_in_signal                                     : in    std_logic                     := 'X';             -- strobe_in_signal
			dcom_f_conduit_end_strobe_out_signal                                    : out   std_logic;                                        -- strobe_out_signal
			dcom_f_sync_end_sync_channel_signal                                     : in    std_logic                     := 'X';             -- sync_channel_signal
			dcom_g_conduit_end_data_in_signal                                       : in    std_logic                     := 'X';             -- data_in_signal
			dcom_g_conduit_end_data_out_signal                                      : out   std_logic;                                        -- data_out_signal
			dcom_g_conduit_end_strobe_in_signal                                     : in    std_logic                     := 'X';             -- strobe_in_signal
			dcom_g_conduit_end_strobe_out_signal                                    : out   std_logic;                                        -- strobe_out_signal
			dcom_g_sync_end_sync_channel_signal                                     : in    std_logic                     := 'X';             -- sync_channel_signal
			dcom_h_conduit_end_data_in_signal                                       : in    std_logic                     := 'X';             -- data_in_signal
			dcom_h_conduit_end_data_out_signal                                      : out   std_logic;                                        -- data_out_signal
			dcom_h_conduit_end_strobe_in_signal                                     : in    std_logic                     := 'X';             -- strobe_in_signal
			dcom_h_conduit_end_strobe_out_signal                                    : out   std_logic;                                        -- strobe_out_signal
			dcom_h_sync_end_sync_channel_signal                                     : in    std_logic                     := 'X';             -- sync_channel_signal
			dip_export                                                              : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- export
			dumb_communication_module_v1_timer_avalon_slave_data_buffer_address     : in    std_logic_vector(11 downto 0) := (others => 'X'); -- address
			dumb_communication_module_v1_timer_avalon_slave_data_buffer_write       : in    std_logic                     := 'X';             -- write
			dumb_communication_module_v1_timer_avalon_slave_data_buffer_writedata   : in    std_logic_vector(63 downto 0) := (others => 'X'); -- writedata
			dumb_communication_module_v1_timer_avalon_slave_data_buffer_waitrequest : out   std_logic;                                        -- waitrequest
			dumb_communication_module_v1_timer_avalon_slave_data_buffer_byteenable  : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- byteenable
			dumb_communication_module_v1_timer_spw_conduit_end_data_in_signal       : in    std_logic                     := 'X';             -- data_in_signal
			dumb_communication_module_v1_timer_spw_conduit_end_data_out_signal      : out   std_logic;                                        -- data_out_signal
			dumb_communication_module_v1_timer_spw_conduit_end_strobe_in_signal     : in    std_logic                     := 'X';             -- strobe_in_signal
			dumb_communication_module_v1_timer_spw_conduit_end_strobe_out_signal    : out   std_logic;                                        -- strobe_out_signal
			dumb_communication_module_v1_timer_sync_conduit_end_sync_channel_signal : in    std_logic                     := 'X';             -- sync_channel_signal
			dumb_communication_module_v1_timer_tx_interrupt_sender_irq              : out   std_logic;                                        -- irq
			ext_export                                                              : in    std_logic                     := 'X';             -- export
			led_de4_export                                                          : out   std_logic_vector(7 downto 0);                     -- export
			led_painel_export                                                       : out   std_logic_vector(20 downto 0);                    -- export
			m1_ddr2_i2c_scl_export                                                  : out   std_logic;                                        -- export
			m1_ddr2_i2c_sda_export                                                  : inout std_logic                     := 'X';             -- export
			m1_ddr2_memory_mem_a                                                    : out   std_logic_vector(13 downto 0);                    -- mem_a
			m1_ddr2_memory_mem_ba                                                   : out   std_logic_vector(2 downto 0);                     -- mem_ba
			m1_ddr2_memory_mem_ck                                                   : out   std_logic_vector(1 downto 0);                     -- mem_ck
			m1_ddr2_memory_mem_ck_n                                                 : out   std_logic_vector(1 downto 0);                     -- mem_ck_n
			m1_ddr2_memory_mem_cke                                                  : out   std_logic_vector(1 downto 0);                     -- mem_cke
			m1_ddr2_memory_mem_cs_n                                                 : out   std_logic_vector(1 downto 0);                     -- mem_cs_n
			m1_ddr2_memory_mem_dm                                                   : out   std_logic_vector(7 downto 0);                     -- mem_dm
			m1_ddr2_memory_mem_ras_n                                                : out   std_logic_vector(0 downto 0);                     -- mem_ras_n
			m1_ddr2_memory_mem_cas_n                                                : out   std_logic_vector(0 downto 0);                     -- mem_cas_n
			m1_ddr2_memory_mem_we_n                                                 : out   std_logic_vector(0 downto 0);                     -- mem_we_n
			m1_ddr2_memory_mem_dq                                                   : inout std_logic_vector(63 downto 0) := (others => 'X'); -- mem_dq
			m1_ddr2_memory_mem_dqs                                                  : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dqs
			m1_ddr2_memory_mem_dqs_n                                                : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dqs_n
			m1_ddr2_memory_mem_odt                                                  : out   std_logic_vector(1 downto 0);                     -- mem_odt
			m1_ddr2_memory_pll_ref_clk_clk                                          : in    std_logic                     := 'X';             -- clk
			m1_ddr2_memory_status_local_init_done                                   : out   std_logic;                                        -- local_init_done
			m1_ddr2_memory_status_local_cal_success                                 : out   std_logic;                                        -- local_cal_success
			m1_ddr2_memory_status_local_cal_fail                                    : out   std_logic;                                        -- local_cal_fail
			m1_ddr2_oct_rdn                                                         : in    std_logic                     := 'X';             -- rdn
			m1_ddr2_oct_rup                                                         : in    std_logic                     := 'X';             -- rup
			m2_ddr2_i2c_scl_export                                                  : out   std_logic;                                        -- export
			m2_ddr2_i2c_sda_export                                                  : inout std_logic                     := 'X';             -- export
			m2_ddr2_memory_mem_a                                                    : out   std_logic_vector(13 downto 0);                    -- mem_a
			m2_ddr2_memory_mem_ba                                                   : out   std_logic_vector(2 downto 0);                     -- mem_ba
			m2_ddr2_memory_mem_ck                                                   : out   std_logic_vector(1 downto 0);                     -- mem_ck
			m2_ddr2_memory_mem_ck_n                                                 : out   std_logic_vector(1 downto 0);                     -- mem_ck_n
			m2_ddr2_memory_mem_cke                                                  : out   std_logic_vector(1 downto 0);                     -- mem_cke
			m2_ddr2_memory_mem_cs_n                                                 : out   std_logic_vector(1 downto 0);                     -- mem_cs_n
			m2_ddr2_memory_mem_dm                                                   : out   std_logic_vector(7 downto 0);                     -- mem_dm
			m2_ddr2_memory_mem_ras_n                                                : out   std_logic_vector(0 downto 0);                     -- mem_ras_n
			m2_ddr2_memory_mem_cas_n                                                : out   std_logic_vector(0 downto 0);                     -- mem_cas_n
			m2_ddr2_memory_mem_we_n                                                 : out   std_logic_vector(0 downto 0);                     -- mem_we_n
			m2_ddr2_memory_mem_dq                                                   : inout std_logic_vector(63 downto 0) := (others => 'X'); -- mem_dq
			m2_ddr2_memory_mem_dqs                                                  : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dqs
			m2_ddr2_memory_mem_dqs_n                                                : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dqs_n
			m2_ddr2_memory_mem_odt                                                  : out   std_logic_vector(1 downto 0);                     -- mem_odt
			m2_ddr2_memory_dll_sharing_dll_pll_locked                               : in    std_logic                     := 'X';             -- dll_pll_locked
			m2_ddr2_memory_dll_sharing_dll_delayctrl                                : out   std_logic_vector(5 downto 0);                     -- dll_delayctrl
			m2_ddr2_memory_pll_sharing_pll_mem_clk                                  : out   std_logic;                                        -- pll_mem_clk
			m2_ddr2_memory_pll_sharing_pll_write_clk                                : out   std_logic;                                        -- pll_write_clk
			m2_ddr2_memory_pll_sharing_pll_locked                                   : out   std_logic;                                        -- pll_locked
			m2_ddr2_memory_pll_sharing_pll_write_clk_pre_phy_clk                    : out   std_logic;                                        -- pll_write_clk_pre_phy_clk
			m2_ddr2_memory_pll_sharing_pll_addr_cmd_clk                             : out   std_logic;                                        -- pll_addr_cmd_clk
			m2_ddr2_memory_pll_sharing_pll_avl_clk                                  : out   std_logic;                                        -- pll_avl_clk
			m2_ddr2_memory_pll_sharing_pll_config_clk                               : out   std_logic;                                        -- pll_config_clk
			m2_ddr2_memory_status_local_init_done                                   : out   std_logic;                                        -- local_init_done
			m2_ddr2_memory_status_local_cal_success                                 : out   std_logic;                                        -- local_cal_success
			m2_ddr2_memory_status_local_cal_fail                                    : out   std_logic;                                        -- local_cal_fail
			m2_ddr2_oct_rdn                                                         : in    std_logic                     := 'X';             -- rdn
			m2_ddr2_oct_rup                                                         : in    std_logic                     := 'X';             -- rup
			rs232_uart_rxd                                                          : in    std_logic                     := 'X';             -- rxd
			rs232_uart_txd                                                          : out   std_logic;                                        -- txd
			rst_reset_n                                                             : in    std_logic                     := 'X';             -- reset_n
			rtcc_alarm_export                                                       : in    std_logic                     := 'X';             -- export
			rtcc_cs_n_export                                                        : out   std_logic;                                        -- export
			rtcc_sck_export                                                         : out   std_logic;                                        -- export
			rtcc_sdi_export                                                         : out   std_logic;                                        -- export
			rtcc_sdo_export                                                         : in    std_logic                     := 'X';             -- export
			sd_card_ip_b_SD_cmd                                                     : inout std_logic                     := 'X';             -- b_SD_cmd
			sd_card_ip_b_SD_dat                                                     : inout std_logic                     := 'X';             -- b_SD_dat
			sd_card_ip_b_SD_dat3                                                    : inout std_logic                     := 'X';             -- b_SD_dat3
			sd_card_ip_o_SD_clock                                                   : out   std_logic;                                        -- o_SD_clock
			sd_card_wp_n_io_export                                                  : in    std_logic                     := 'X';             -- export
			ssdp_ssdp0                                                              : out   std_logic_vector(7 downto 0);                     -- ssdp0
			ssdp_ssdp1                                                              : out   std_logic_vector(7 downto 0);                     -- ssdp1
			sync_in_conduit                                                         : in    std_logic                     := 'X';             -- conduit
			sync_out_conduit                                                        : out   std_logic;                                        -- conduit
			sync_spwa_conduit                                                       : out   std_logic;                                        -- conduit
			sync_spwb_conduit                                                       : out   std_logic;                                        -- conduit
			sync_spwc_conduit                                                       : out   std_logic;                                        -- conduit
			sync_spwd_conduit                                                       : out   std_logic;                                        -- conduit
			sync_spwe_conduit                                                       : out   std_logic;                                        -- conduit
			sync_spwf_conduit                                                       : out   std_logic;                                        -- conduit
			sync_spwg_conduit                                                       : out   std_logic;                                        -- conduit
			sync_spwh_conduit                                                       : out   std_logic;                                        -- conduit
			temp_scl_export                                                         : out   std_logic;                                        -- export
			temp_sda_export                                                         : inout std_logic                     := 'X';             -- export
			timer_1ms_external_port_export                                          : out   std_logic;                                        -- export
			timer_1us_external_port_export                                          : out   std_logic;                                        -- export
			tristate_conduit_tcm_address_out                                        : out   std_logic_vector(25 downto 0);                    -- tcm_address_out
			tristate_conduit_tcm_read_n_out                                         : out   std_logic_vector(0 downto 0);                     -- tcm_read_n_out
			tristate_conduit_tcm_write_n_out                                        : out   std_logic_vector(0 downto 0);                     -- tcm_write_n_out
			tristate_conduit_tcm_data_out                                           : inout std_logic_vector(15 downto 0) := (others => 'X'); -- tcm_data_out
			tristate_conduit_tcm_chipselect_n_out                                   : out   std_logic_vector(0 downto 0);                     -- tcm_chipselect_n_out
			tse_clk_clk                                                             : in    std_logic                     := 'X';             -- clk
			tse_led_crs                                                             : out   std_logic;                                        -- crs
			tse_led_link                                                            : out   std_logic;                                        -- link
			tse_led_panel_link                                                      : out   std_logic;                                        -- panel_link
			tse_led_col                                                             : out   std_logic;                                        -- col
			tse_led_an                                                              : out   std_logic;                                        -- an
			tse_led_char_err                                                        : out   std_logic;                                        -- char_err
			tse_led_disp_err                                                        : out   std_logic;                                        -- disp_err
			tse_mac_mac_misc_connection_xon_gen                                     : in    std_logic                     := 'X';             -- xon_gen
			tse_mac_mac_misc_connection_xoff_gen                                    : in    std_logic                     := 'X';             -- xoff_gen
			tse_mac_mac_misc_connection_magic_wakeup                                : out   std_logic;                                        -- magic_wakeup
			tse_mac_mac_misc_connection_magic_sleep_n                               : in    std_logic                     := 'X';             -- magic_sleep_n
			tse_mac_mac_misc_connection_ff_tx_crc_fwd                               : in    std_logic                     := 'X';             -- ff_tx_crc_fwd
			tse_mac_mac_misc_connection_ff_tx_septy                                 : out   std_logic;                                        -- ff_tx_septy
			tse_mac_mac_misc_connection_tx_ff_uflow                                 : out   std_logic;                                        -- tx_ff_uflow
			tse_mac_mac_misc_connection_ff_tx_a_full                                : out   std_logic;                                        -- ff_tx_a_full
			tse_mac_mac_misc_connection_ff_tx_a_empty                               : out   std_logic;                                        -- ff_tx_a_empty
			tse_mac_mac_misc_connection_rx_err_stat                                 : out   std_logic_vector(17 downto 0);                    -- rx_err_stat
			tse_mac_mac_misc_connection_rx_frm_type                                 : out   std_logic_vector(3 downto 0);                     -- rx_frm_type
			tse_mac_mac_misc_connection_ff_rx_dsav                                  : out   std_logic;                                        -- ff_rx_dsav
			tse_mac_mac_misc_connection_ff_rx_a_full                                : out   std_logic;                                        -- ff_rx_a_full
			tse_mac_mac_misc_connection_ff_rx_a_empty                               : out   std_logic;                                        -- ff_rx_a_empty
			tse_mac_serdes_control_connection_export                                : out   std_logic;                                        -- export
			tse_mdio_mdc                                                            : out   std_logic;                                        -- mdc
			tse_mdio_mdio_in                                                        : in    std_logic                     := 'X';             -- mdio_in
			tse_mdio_mdio_out                                                       : out   std_logic;                                        -- mdio_out
			tse_mdio_mdio_oen                                                       : out   std_logic;                                        -- mdio_oen
			tse_serial_txp                                                          : out   std_logic;                                        -- txp
			tse_serial_rxp                                                          : in    std_logic                     := 'X';             -- rxp
			eth_rst_export                                                          : out   std_logic                                         -- export
		);
	end component MebX_Qsys_Project;

	u0 : component MebX_Qsys_Project
		port map (
			button_export                                                           => CONNECTED_TO_button_export,                                                           --                                                      button.export
			clk50_clk                                                               => CONNECTED_TO_clk50_clk,                                                               --                                                       clk50.clk
			csense_adc_fo_export                                                    => CONNECTED_TO_csense_adc_fo_export,                                                    --                                               csense_adc_fo.export
			csense_cs_n_export                                                      => CONNECTED_TO_csense_cs_n_export,                                                      --                                                 csense_cs_n.export
			csense_sck_export                                                       => CONNECTED_TO_csense_sck_export,                                                       --                                                  csense_sck.export
			csense_sdi_export                                                       => CONNECTED_TO_csense_sdi_export,                                                       --                                                  csense_sdi.export
			csense_sdo_export                                                       => CONNECTED_TO_csense_sdo_export,                                                       --                                                  csense_sdo.export
			ctrl_io_lvds_export                                                     => CONNECTED_TO_ctrl_io_lvds_export,                                                     --                                                ctrl_io_lvds.export
			dcom_a_conduit_end_data_in_signal                                       => CONNECTED_TO_dcom_a_conduit_end_data_in_signal,                                       --                                          dcom_a_conduit_end.data_in_signal
			dcom_a_conduit_end_data_out_signal                                      => CONNECTED_TO_dcom_a_conduit_end_data_out_signal,                                      --                                                            .data_out_signal
			dcom_a_conduit_end_strobe_in_signal                                     => CONNECTED_TO_dcom_a_conduit_end_strobe_in_signal,                                     --                                                            .strobe_in_signal
			dcom_a_conduit_end_strobe_out_signal                                    => CONNECTED_TO_dcom_a_conduit_end_strobe_out_signal,                                    --                                                            .strobe_out_signal
			dcom_a_sync_end_sync_channel_signal                                     => CONNECTED_TO_dcom_a_sync_end_sync_channel_signal,                                     --                                             dcom_a_sync_end.sync_channel_signal
			dcom_b_conduit_end_data_in_signal                                       => CONNECTED_TO_dcom_b_conduit_end_data_in_signal,                                       --                                          dcom_b_conduit_end.data_in_signal
			dcom_b_conduit_end_data_out_signal                                      => CONNECTED_TO_dcom_b_conduit_end_data_out_signal,                                      --                                                            .data_out_signal
			dcom_b_conduit_end_strobe_in_signal                                     => CONNECTED_TO_dcom_b_conduit_end_strobe_in_signal,                                     --                                                            .strobe_in_signal
			dcom_b_conduit_end_strobe_out_signal                                    => CONNECTED_TO_dcom_b_conduit_end_strobe_out_signal,                                    --                                                            .strobe_out_signal
			dcom_b_sync_end_sync_channel_signal                                     => CONNECTED_TO_dcom_b_sync_end_sync_channel_signal,                                     --                                             dcom_b_sync_end.sync_channel_signal
			dcom_c_conduit_end_data_in_signal                                       => CONNECTED_TO_dcom_c_conduit_end_data_in_signal,                                       --                                          dcom_c_conduit_end.data_in_signal
			dcom_c_conduit_end_data_out_signal                                      => CONNECTED_TO_dcom_c_conduit_end_data_out_signal,                                      --                                                            .data_out_signal
			dcom_c_conduit_end_strobe_in_signal                                     => CONNECTED_TO_dcom_c_conduit_end_strobe_in_signal,                                     --                                                            .strobe_in_signal
			dcom_c_conduit_end_strobe_out_signal                                    => CONNECTED_TO_dcom_c_conduit_end_strobe_out_signal,                                    --                                                            .strobe_out_signal
			dcom_c_sync_end_sync_channel_signal                                     => CONNECTED_TO_dcom_c_sync_end_sync_channel_signal,                                     --                                             dcom_c_sync_end.sync_channel_signal
			dcom_d_conduit_end_data_in_signal                                       => CONNECTED_TO_dcom_d_conduit_end_data_in_signal,                                       --                                          dcom_d_conduit_end.data_in_signal
			dcom_d_conduit_end_data_out_signal                                      => CONNECTED_TO_dcom_d_conduit_end_data_out_signal,                                      --                                                            .data_out_signal
			dcom_d_conduit_end_strobe_in_signal                                     => CONNECTED_TO_dcom_d_conduit_end_strobe_in_signal,                                     --                                                            .strobe_in_signal
			dcom_d_conduit_end_strobe_out_signal                                    => CONNECTED_TO_dcom_d_conduit_end_strobe_out_signal,                                    --                                                            .strobe_out_signal
			dcom_d_sync_end_sync_channel_signal                                     => CONNECTED_TO_dcom_d_sync_end_sync_channel_signal,                                     --                                             dcom_d_sync_end.sync_channel_signal
			dcom_e_conduit_end_data_in_signal                                       => CONNECTED_TO_dcom_e_conduit_end_data_in_signal,                                       --                                          dcom_e_conduit_end.data_in_signal
			dcom_e_conduit_end_data_out_signal                                      => CONNECTED_TO_dcom_e_conduit_end_data_out_signal,                                      --                                                            .data_out_signal
			dcom_e_conduit_end_strobe_in_signal                                     => CONNECTED_TO_dcom_e_conduit_end_strobe_in_signal,                                     --                                                            .strobe_in_signal
			dcom_e_conduit_end_strobe_out_signal                                    => CONNECTED_TO_dcom_e_conduit_end_strobe_out_signal,                                    --                                                            .strobe_out_signal
			dcom_e_sync_end_sync_channel_signal                                     => CONNECTED_TO_dcom_e_sync_end_sync_channel_signal,                                     --                                             dcom_e_sync_end.sync_channel_signal
			dcom_f_conduit_end_data_in_signal                                       => CONNECTED_TO_dcom_f_conduit_end_data_in_signal,                                       --                                          dcom_f_conduit_end.data_in_signal
			dcom_f_conduit_end_data_out_signal                                      => CONNECTED_TO_dcom_f_conduit_end_data_out_signal,                                      --                                                            .data_out_signal
			dcom_f_conduit_end_strobe_in_signal                                     => CONNECTED_TO_dcom_f_conduit_end_strobe_in_signal,                                     --                                                            .strobe_in_signal
			dcom_f_conduit_end_strobe_out_signal                                    => CONNECTED_TO_dcom_f_conduit_end_strobe_out_signal,                                    --                                                            .strobe_out_signal
			dcom_f_sync_end_sync_channel_signal                                     => CONNECTED_TO_dcom_f_sync_end_sync_channel_signal,                                     --                                             dcom_f_sync_end.sync_channel_signal
			dcom_g_conduit_end_data_in_signal                                       => CONNECTED_TO_dcom_g_conduit_end_data_in_signal,                                       --                                          dcom_g_conduit_end.data_in_signal
			dcom_g_conduit_end_data_out_signal                                      => CONNECTED_TO_dcom_g_conduit_end_data_out_signal,                                      --                                                            .data_out_signal
			dcom_g_conduit_end_strobe_in_signal                                     => CONNECTED_TO_dcom_g_conduit_end_strobe_in_signal,                                     --                                                            .strobe_in_signal
			dcom_g_conduit_end_strobe_out_signal                                    => CONNECTED_TO_dcom_g_conduit_end_strobe_out_signal,                                    --                                                            .strobe_out_signal
			dcom_g_sync_end_sync_channel_signal                                     => CONNECTED_TO_dcom_g_sync_end_sync_channel_signal,                                     --                                             dcom_g_sync_end.sync_channel_signal
			dcom_h_conduit_end_data_in_signal                                       => CONNECTED_TO_dcom_h_conduit_end_data_in_signal,                                       --                                          dcom_h_conduit_end.data_in_signal
			dcom_h_conduit_end_data_out_signal                                      => CONNECTED_TO_dcom_h_conduit_end_data_out_signal,                                      --                                                            .data_out_signal
			dcom_h_conduit_end_strobe_in_signal                                     => CONNECTED_TO_dcom_h_conduit_end_strobe_in_signal,                                     --                                                            .strobe_in_signal
			dcom_h_conduit_end_strobe_out_signal                                    => CONNECTED_TO_dcom_h_conduit_end_strobe_out_signal,                                    --                                                            .strobe_out_signal
			dcom_h_sync_end_sync_channel_signal                                     => CONNECTED_TO_dcom_h_sync_end_sync_channel_signal,                                     --                                             dcom_h_sync_end.sync_channel_signal
			dip_export                                                              => CONNECTED_TO_dip_export,                                                              --                                                         dip.export
			dumb_communication_module_v1_timer_avalon_slave_data_buffer_address     => CONNECTED_TO_dumb_communication_module_v1_timer_avalon_slave_data_buffer_address,     -- dumb_communication_module_v1_timer_avalon_slave_data_buffer.address
			dumb_communication_module_v1_timer_avalon_slave_data_buffer_write       => CONNECTED_TO_dumb_communication_module_v1_timer_avalon_slave_data_buffer_write,       --                                                            .write
			dumb_communication_module_v1_timer_avalon_slave_data_buffer_writedata   => CONNECTED_TO_dumb_communication_module_v1_timer_avalon_slave_data_buffer_writedata,   --                                                            .writedata
			dumb_communication_module_v1_timer_avalon_slave_data_buffer_waitrequest => CONNECTED_TO_dumb_communication_module_v1_timer_avalon_slave_data_buffer_waitrequest, --                                                            .waitrequest
			dumb_communication_module_v1_timer_avalon_slave_data_buffer_byteenable  => CONNECTED_TO_dumb_communication_module_v1_timer_avalon_slave_data_buffer_byteenable,  --                                                            .byteenable
			dumb_communication_module_v1_timer_spw_conduit_end_data_in_signal       => CONNECTED_TO_dumb_communication_module_v1_timer_spw_conduit_end_data_in_signal,       --          dumb_communication_module_v1_timer_spw_conduit_end.data_in_signal
			dumb_communication_module_v1_timer_spw_conduit_end_data_out_signal      => CONNECTED_TO_dumb_communication_module_v1_timer_spw_conduit_end_data_out_signal,      --                                                            .data_out_signal
			dumb_communication_module_v1_timer_spw_conduit_end_strobe_in_signal     => CONNECTED_TO_dumb_communication_module_v1_timer_spw_conduit_end_strobe_in_signal,     --                                                            .strobe_in_signal
			dumb_communication_module_v1_timer_spw_conduit_end_strobe_out_signal    => CONNECTED_TO_dumb_communication_module_v1_timer_spw_conduit_end_strobe_out_signal,    --                                                            .strobe_out_signal
			dumb_communication_module_v1_timer_sync_conduit_end_sync_channel_signal => CONNECTED_TO_dumb_communication_module_v1_timer_sync_conduit_end_sync_channel_signal, --         dumb_communication_module_v1_timer_sync_conduit_end.sync_channel_signal
			dumb_communication_module_v1_timer_tx_interrupt_sender_irq              => CONNECTED_TO_dumb_communication_module_v1_timer_tx_interrupt_sender_irq,              --      dumb_communication_module_v1_timer_tx_interrupt_sender.irq
			ext_export                                                              => CONNECTED_TO_ext_export,                                                              --                                                         ext.export
			led_de4_export                                                          => CONNECTED_TO_led_de4_export,                                                          --                                                     led_de4.export
			led_painel_export                                                       => CONNECTED_TO_led_painel_export,                                                       --                                                  led_painel.export
			m1_ddr2_i2c_scl_export                                                  => CONNECTED_TO_m1_ddr2_i2c_scl_export,                                                  --                                             m1_ddr2_i2c_scl.export
			m1_ddr2_i2c_sda_export                                                  => CONNECTED_TO_m1_ddr2_i2c_sda_export,                                                  --                                             m1_ddr2_i2c_sda.export
			m1_ddr2_memory_mem_a                                                    => CONNECTED_TO_m1_ddr2_memory_mem_a,                                                    --                                              m1_ddr2_memory.mem_a
			m1_ddr2_memory_mem_ba                                                   => CONNECTED_TO_m1_ddr2_memory_mem_ba,                                                   --                                                            .mem_ba
			m1_ddr2_memory_mem_ck                                                   => CONNECTED_TO_m1_ddr2_memory_mem_ck,                                                   --                                                            .mem_ck
			m1_ddr2_memory_mem_ck_n                                                 => CONNECTED_TO_m1_ddr2_memory_mem_ck_n,                                                 --                                                            .mem_ck_n
			m1_ddr2_memory_mem_cke                                                  => CONNECTED_TO_m1_ddr2_memory_mem_cke,                                                  --                                                            .mem_cke
			m1_ddr2_memory_mem_cs_n                                                 => CONNECTED_TO_m1_ddr2_memory_mem_cs_n,                                                 --                                                            .mem_cs_n
			m1_ddr2_memory_mem_dm                                                   => CONNECTED_TO_m1_ddr2_memory_mem_dm,                                                   --                                                            .mem_dm
			m1_ddr2_memory_mem_ras_n                                                => CONNECTED_TO_m1_ddr2_memory_mem_ras_n,                                                --                                                            .mem_ras_n
			m1_ddr2_memory_mem_cas_n                                                => CONNECTED_TO_m1_ddr2_memory_mem_cas_n,                                                --                                                            .mem_cas_n
			m1_ddr2_memory_mem_we_n                                                 => CONNECTED_TO_m1_ddr2_memory_mem_we_n,                                                 --                                                            .mem_we_n
			m1_ddr2_memory_mem_dq                                                   => CONNECTED_TO_m1_ddr2_memory_mem_dq,                                                   --                                                            .mem_dq
			m1_ddr2_memory_mem_dqs                                                  => CONNECTED_TO_m1_ddr2_memory_mem_dqs,                                                  --                                                            .mem_dqs
			m1_ddr2_memory_mem_dqs_n                                                => CONNECTED_TO_m1_ddr2_memory_mem_dqs_n,                                                --                                                            .mem_dqs_n
			m1_ddr2_memory_mem_odt                                                  => CONNECTED_TO_m1_ddr2_memory_mem_odt,                                                  --                                                            .mem_odt
			m1_ddr2_memory_pll_ref_clk_clk                                          => CONNECTED_TO_m1_ddr2_memory_pll_ref_clk_clk,                                          --                                  m1_ddr2_memory_pll_ref_clk.clk
			m1_ddr2_memory_status_local_init_done                                   => CONNECTED_TO_m1_ddr2_memory_status_local_init_done,                                   --                                       m1_ddr2_memory_status.local_init_done
			m1_ddr2_memory_status_local_cal_success                                 => CONNECTED_TO_m1_ddr2_memory_status_local_cal_success,                                 --                                                            .local_cal_success
			m1_ddr2_memory_status_local_cal_fail                                    => CONNECTED_TO_m1_ddr2_memory_status_local_cal_fail,                                    --                                                            .local_cal_fail
			m1_ddr2_oct_rdn                                                         => CONNECTED_TO_m1_ddr2_oct_rdn,                                                         --                                                 m1_ddr2_oct.rdn
			m1_ddr2_oct_rup                                                         => CONNECTED_TO_m1_ddr2_oct_rup,                                                         --                                                            .rup
			m2_ddr2_i2c_scl_export                                                  => CONNECTED_TO_m2_ddr2_i2c_scl_export,                                                  --                                             m2_ddr2_i2c_scl.export
			m2_ddr2_i2c_sda_export                                                  => CONNECTED_TO_m2_ddr2_i2c_sda_export,                                                  --                                             m2_ddr2_i2c_sda.export
			m2_ddr2_memory_mem_a                                                    => CONNECTED_TO_m2_ddr2_memory_mem_a,                                                    --                                              m2_ddr2_memory.mem_a
			m2_ddr2_memory_mem_ba                                                   => CONNECTED_TO_m2_ddr2_memory_mem_ba,                                                   --                                                            .mem_ba
			m2_ddr2_memory_mem_ck                                                   => CONNECTED_TO_m2_ddr2_memory_mem_ck,                                                   --                                                            .mem_ck
			m2_ddr2_memory_mem_ck_n                                                 => CONNECTED_TO_m2_ddr2_memory_mem_ck_n,                                                 --                                                            .mem_ck_n
			m2_ddr2_memory_mem_cke                                                  => CONNECTED_TO_m2_ddr2_memory_mem_cke,                                                  --                                                            .mem_cke
			m2_ddr2_memory_mem_cs_n                                                 => CONNECTED_TO_m2_ddr2_memory_mem_cs_n,                                                 --                                                            .mem_cs_n
			m2_ddr2_memory_mem_dm                                                   => CONNECTED_TO_m2_ddr2_memory_mem_dm,                                                   --                                                            .mem_dm
			m2_ddr2_memory_mem_ras_n                                                => CONNECTED_TO_m2_ddr2_memory_mem_ras_n,                                                --                                                            .mem_ras_n
			m2_ddr2_memory_mem_cas_n                                                => CONNECTED_TO_m2_ddr2_memory_mem_cas_n,                                                --                                                            .mem_cas_n
			m2_ddr2_memory_mem_we_n                                                 => CONNECTED_TO_m2_ddr2_memory_mem_we_n,                                                 --                                                            .mem_we_n
			m2_ddr2_memory_mem_dq                                                   => CONNECTED_TO_m2_ddr2_memory_mem_dq,                                                   --                                                            .mem_dq
			m2_ddr2_memory_mem_dqs                                                  => CONNECTED_TO_m2_ddr2_memory_mem_dqs,                                                  --                                                            .mem_dqs
			m2_ddr2_memory_mem_dqs_n                                                => CONNECTED_TO_m2_ddr2_memory_mem_dqs_n,                                                --                                                            .mem_dqs_n
			m2_ddr2_memory_mem_odt                                                  => CONNECTED_TO_m2_ddr2_memory_mem_odt,                                                  --                                                            .mem_odt
			m2_ddr2_memory_dll_sharing_dll_pll_locked                               => CONNECTED_TO_m2_ddr2_memory_dll_sharing_dll_pll_locked,                               --                                  m2_ddr2_memory_dll_sharing.dll_pll_locked
			m2_ddr2_memory_dll_sharing_dll_delayctrl                                => CONNECTED_TO_m2_ddr2_memory_dll_sharing_dll_delayctrl,                                --                                                            .dll_delayctrl
			m2_ddr2_memory_pll_sharing_pll_mem_clk                                  => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_mem_clk,                                  --                                  m2_ddr2_memory_pll_sharing.pll_mem_clk
			m2_ddr2_memory_pll_sharing_pll_write_clk                                => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_write_clk,                                --                                                            .pll_write_clk
			m2_ddr2_memory_pll_sharing_pll_locked                                   => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_locked,                                   --                                                            .pll_locked
			m2_ddr2_memory_pll_sharing_pll_write_clk_pre_phy_clk                    => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_write_clk_pre_phy_clk,                    --                                                            .pll_write_clk_pre_phy_clk
			m2_ddr2_memory_pll_sharing_pll_addr_cmd_clk                             => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_addr_cmd_clk,                             --                                                            .pll_addr_cmd_clk
			m2_ddr2_memory_pll_sharing_pll_avl_clk                                  => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_avl_clk,                                  --                                                            .pll_avl_clk
			m2_ddr2_memory_pll_sharing_pll_config_clk                               => CONNECTED_TO_m2_ddr2_memory_pll_sharing_pll_config_clk,                               --                                                            .pll_config_clk
			m2_ddr2_memory_status_local_init_done                                   => CONNECTED_TO_m2_ddr2_memory_status_local_init_done,                                   --                                       m2_ddr2_memory_status.local_init_done
			m2_ddr2_memory_status_local_cal_success                                 => CONNECTED_TO_m2_ddr2_memory_status_local_cal_success,                                 --                                                            .local_cal_success
			m2_ddr2_memory_status_local_cal_fail                                    => CONNECTED_TO_m2_ddr2_memory_status_local_cal_fail,                                    --                                                            .local_cal_fail
			m2_ddr2_oct_rdn                                                         => CONNECTED_TO_m2_ddr2_oct_rdn,                                                         --                                                 m2_ddr2_oct.rdn
			m2_ddr2_oct_rup                                                         => CONNECTED_TO_m2_ddr2_oct_rup,                                                         --                                                            .rup
			rs232_uart_rxd                                                          => CONNECTED_TO_rs232_uart_rxd,                                                          --                                                  rs232_uart.rxd
			rs232_uart_txd                                                          => CONNECTED_TO_rs232_uart_txd,                                                          --                                                            .txd
			rst_reset_n                                                             => CONNECTED_TO_rst_reset_n,                                                             --                                                         rst.reset_n
			rtcc_alarm_export                                                       => CONNECTED_TO_rtcc_alarm_export,                                                       --                                                  rtcc_alarm.export
			rtcc_cs_n_export                                                        => CONNECTED_TO_rtcc_cs_n_export,                                                        --                                                   rtcc_cs_n.export
			rtcc_sck_export                                                         => CONNECTED_TO_rtcc_sck_export,                                                         --                                                    rtcc_sck.export
			rtcc_sdi_export                                                         => CONNECTED_TO_rtcc_sdi_export,                                                         --                                                    rtcc_sdi.export
			rtcc_sdo_export                                                         => CONNECTED_TO_rtcc_sdo_export,                                                         --                                                    rtcc_sdo.export
			sd_card_ip_b_SD_cmd                                                     => CONNECTED_TO_sd_card_ip_b_SD_cmd,                                                     --                                                  sd_card_ip.b_SD_cmd
			sd_card_ip_b_SD_dat                                                     => CONNECTED_TO_sd_card_ip_b_SD_dat,                                                     --                                                            .b_SD_dat
			sd_card_ip_b_SD_dat3                                                    => CONNECTED_TO_sd_card_ip_b_SD_dat3,                                                    --                                                            .b_SD_dat3
			sd_card_ip_o_SD_clock                                                   => CONNECTED_TO_sd_card_ip_o_SD_clock,                                                   --                                                            .o_SD_clock
			sd_card_wp_n_io_export                                                  => CONNECTED_TO_sd_card_wp_n_io_export,                                                  --                                             sd_card_wp_n_io.export
			ssdp_ssdp0                                                              => CONNECTED_TO_ssdp_ssdp0,                                                              --                                                        ssdp.ssdp0
			ssdp_ssdp1                                                              => CONNECTED_TO_ssdp_ssdp1,                                                              --                                                            .ssdp1
			sync_in_conduit                                                         => CONNECTED_TO_sync_in_conduit,                                                         --                                                     sync_in.conduit
			sync_out_conduit                                                        => CONNECTED_TO_sync_out_conduit,                                                        --                                                    sync_out.conduit
			sync_spwa_conduit                                                       => CONNECTED_TO_sync_spwa_conduit,                                                       --                                                   sync_spwa.conduit
			sync_spwb_conduit                                                       => CONNECTED_TO_sync_spwb_conduit,                                                       --                                                   sync_spwb.conduit
			sync_spwc_conduit                                                       => CONNECTED_TO_sync_spwc_conduit,                                                       --                                                   sync_spwc.conduit
			sync_spwd_conduit                                                       => CONNECTED_TO_sync_spwd_conduit,                                                       --                                                   sync_spwd.conduit
			sync_spwe_conduit                                                       => CONNECTED_TO_sync_spwe_conduit,                                                       --                                                   sync_spwe.conduit
			sync_spwf_conduit                                                       => CONNECTED_TO_sync_spwf_conduit,                                                       --                                                   sync_spwf.conduit
			sync_spwg_conduit                                                       => CONNECTED_TO_sync_spwg_conduit,                                                       --                                                   sync_spwg.conduit
			sync_spwh_conduit                                                       => CONNECTED_TO_sync_spwh_conduit,                                                       --                                                   sync_spwh.conduit
			temp_scl_export                                                         => CONNECTED_TO_temp_scl_export,                                                         --                                                    temp_scl.export
			temp_sda_export                                                         => CONNECTED_TO_temp_sda_export,                                                         --                                                    temp_sda.export
			timer_1ms_external_port_export                                          => CONNECTED_TO_timer_1ms_external_port_export,                                          --                                     timer_1ms_external_port.export
			timer_1us_external_port_export                                          => CONNECTED_TO_timer_1us_external_port_export,                                          --                                     timer_1us_external_port.export
			tristate_conduit_tcm_address_out                                        => CONNECTED_TO_tristate_conduit_tcm_address_out,                                        --                                            tristate_conduit.tcm_address_out
			tristate_conduit_tcm_read_n_out                                         => CONNECTED_TO_tristate_conduit_tcm_read_n_out,                                         --                                                            .tcm_read_n_out
			tristate_conduit_tcm_write_n_out                                        => CONNECTED_TO_tristate_conduit_tcm_write_n_out,                                        --                                                            .tcm_write_n_out
			tristate_conduit_tcm_data_out                                           => CONNECTED_TO_tristate_conduit_tcm_data_out,                                           --                                                            .tcm_data_out
			tristate_conduit_tcm_chipselect_n_out                                   => CONNECTED_TO_tristate_conduit_tcm_chipselect_n_out,                                   --                                                            .tcm_chipselect_n_out
			tse_clk_clk                                                             => CONNECTED_TO_tse_clk_clk,                                                             --                                                     tse_clk.clk
			tse_led_crs                                                             => CONNECTED_TO_tse_led_crs,                                                             --                                                     tse_led.crs
			tse_led_link                                                            => CONNECTED_TO_tse_led_link,                                                            --                                                            .link
			tse_led_panel_link                                                      => CONNECTED_TO_tse_led_panel_link,                                                      --                                                            .panel_link
			tse_led_col                                                             => CONNECTED_TO_tse_led_col,                                                             --                                                            .col
			tse_led_an                                                              => CONNECTED_TO_tse_led_an,                                                              --                                                            .an
			tse_led_char_err                                                        => CONNECTED_TO_tse_led_char_err,                                                        --                                                            .char_err
			tse_led_disp_err                                                        => CONNECTED_TO_tse_led_disp_err,                                                        --                                                            .disp_err
			tse_mac_mac_misc_connection_xon_gen                                     => CONNECTED_TO_tse_mac_mac_misc_connection_xon_gen,                                     --                                 tse_mac_mac_misc_connection.xon_gen
			tse_mac_mac_misc_connection_xoff_gen                                    => CONNECTED_TO_tse_mac_mac_misc_connection_xoff_gen,                                    --                                                            .xoff_gen
			tse_mac_mac_misc_connection_magic_wakeup                                => CONNECTED_TO_tse_mac_mac_misc_connection_magic_wakeup,                                --                                                            .magic_wakeup
			tse_mac_mac_misc_connection_magic_sleep_n                               => CONNECTED_TO_tse_mac_mac_misc_connection_magic_sleep_n,                               --                                                            .magic_sleep_n
			tse_mac_mac_misc_connection_ff_tx_crc_fwd                               => CONNECTED_TO_tse_mac_mac_misc_connection_ff_tx_crc_fwd,                               --                                                            .ff_tx_crc_fwd
			tse_mac_mac_misc_connection_ff_tx_septy                                 => CONNECTED_TO_tse_mac_mac_misc_connection_ff_tx_septy,                                 --                                                            .ff_tx_septy
			tse_mac_mac_misc_connection_tx_ff_uflow                                 => CONNECTED_TO_tse_mac_mac_misc_connection_tx_ff_uflow,                                 --                                                            .tx_ff_uflow
			tse_mac_mac_misc_connection_ff_tx_a_full                                => CONNECTED_TO_tse_mac_mac_misc_connection_ff_tx_a_full,                                --                                                            .ff_tx_a_full
			tse_mac_mac_misc_connection_ff_tx_a_empty                               => CONNECTED_TO_tse_mac_mac_misc_connection_ff_tx_a_empty,                               --                                                            .ff_tx_a_empty
			tse_mac_mac_misc_connection_rx_err_stat                                 => CONNECTED_TO_tse_mac_mac_misc_connection_rx_err_stat,                                 --                                                            .rx_err_stat
			tse_mac_mac_misc_connection_rx_frm_type                                 => CONNECTED_TO_tse_mac_mac_misc_connection_rx_frm_type,                                 --                                                            .rx_frm_type
			tse_mac_mac_misc_connection_ff_rx_dsav                                  => CONNECTED_TO_tse_mac_mac_misc_connection_ff_rx_dsav,                                  --                                                            .ff_rx_dsav
			tse_mac_mac_misc_connection_ff_rx_a_full                                => CONNECTED_TO_tse_mac_mac_misc_connection_ff_rx_a_full,                                --                                                            .ff_rx_a_full
			tse_mac_mac_misc_connection_ff_rx_a_empty                               => CONNECTED_TO_tse_mac_mac_misc_connection_ff_rx_a_empty,                               --                                                            .ff_rx_a_empty
			tse_mac_serdes_control_connection_export                                => CONNECTED_TO_tse_mac_serdes_control_connection_export,                                --                           tse_mac_serdes_control_connection.export
			tse_mdio_mdc                                                            => CONNECTED_TO_tse_mdio_mdc,                                                            --                                                    tse_mdio.mdc
			tse_mdio_mdio_in                                                        => CONNECTED_TO_tse_mdio_mdio_in,                                                        --                                                            .mdio_in
			tse_mdio_mdio_out                                                       => CONNECTED_TO_tse_mdio_mdio_out,                                                       --                                                            .mdio_out
			tse_mdio_mdio_oen                                                       => CONNECTED_TO_tse_mdio_mdio_oen,                                                       --                                                            .mdio_oen
			tse_serial_txp                                                          => CONNECTED_TO_tse_serial_txp,                                                          --                                                  tse_serial.txp
			tse_serial_rxp                                                          => CONNECTED_TO_tse_serial_rxp,                                                          --                                                            .rxp
			eth_rst_export                                                          => CONNECTED_TO_eth_rst_export                                                           --                                                     eth_rst.export
		);

