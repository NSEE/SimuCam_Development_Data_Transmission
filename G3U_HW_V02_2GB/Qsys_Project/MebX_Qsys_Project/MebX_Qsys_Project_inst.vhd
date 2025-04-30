	component MebX_Qsys_Project is
		port (
			clk50_clk                                : in  std_logic                     := 'X';             -- clk
			rst_reset_n                              : in  std_logic                     := 'X';             -- reset_n
			spwc_a_enable_spw_rx_enable_signal       : in  std_logic                     := 'X';             -- spw_rx_enable_signal
			spwc_a_enable_spw_tx_enable_signal       : in  std_logic                     := 'X';             -- spw_tx_enable_signal
			spwc_a_leds_spw_red_status_led_signal    : out std_logic;                                        -- spw_red_status_led_signal
			spwc_a_leds_spw_green_status_led_signal  : out std_logic;                                        -- spw_green_status_led_signal
			spwc_a_lvds_spw_lvds_p_data_in_signal    : in  std_logic                     := 'X';             -- spw_lvds_p_data_in_signal
			spwc_a_lvds_spw_lvds_n_data_in_signal    : in  std_logic                     := 'X';             -- spw_lvds_n_data_in_signal
			spwc_a_lvds_spw_lvds_p_data_out_signal   : out std_logic;                                        -- spw_lvds_p_data_out_signal
			spwc_a_lvds_spw_lvds_n_data_out_signal   : out std_logic;                                        -- spw_lvds_n_data_out_signal
			spwc_a_lvds_spw_lvds_p_strobe_out_signal : out std_logic;                                        -- spw_lvds_p_strobe_out_signal
			spwc_a_lvds_spw_lvds_n_strobe_out_signal : out std_logic;                                        -- spw_lvds_n_strobe_out_signal
			spwc_a_lvds_spw_lvds_p_strobe_in_signal  : in  std_logic                     := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_a_lvds_spw_lvds_n_strobe_in_signal  : in  std_logic                     := 'X';             -- spw_lvds_n_strobe_in_signal
			spwc_b_enable_spw_rx_enable_signal       : in  std_logic                     := 'X';             -- spw_rx_enable_signal
			spwc_b_enable_spw_tx_enable_signal       : in  std_logic                     := 'X';             -- spw_tx_enable_signal
			spwc_b_leds_spw_red_status_led_signal    : out std_logic;                                        -- spw_red_status_led_signal
			spwc_b_leds_spw_green_status_led_signal  : out std_logic;                                        -- spw_green_status_led_signal
			spwc_b_lvds_spw_lvds_p_data_in_signal    : in  std_logic                     := 'X';             -- spw_lvds_p_data_in_signal
			spwc_b_lvds_spw_lvds_n_data_in_signal    : in  std_logic                     := 'X';             -- spw_lvds_n_data_in_signal
			spwc_b_lvds_spw_lvds_p_data_out_signal   : out std_logic;                                        -- spw_lvds_p_data_out_signal
			spwc_b_lvds_spw_lvds_n_data_out_signal   : out std_logic;                                        -- spw_lvds_n_data_out_signal
			spwc_b_lvds_spw_lvds_p_strobe_out_signal : out std_logic;                                        -- spw_lvds_p_strobe_out_signal
			spwc_b_lvds_spw_lvds_n_strobe_out_signal : out std_logic;                                        -- spw_lvds_n_strobe_out_signal
			spwc_b_lvds_spw_lvds_p_strobe_in_signal  : in  std_logic                     := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_b_lvds_spw_lvds_n_strobe_in_signal  : in  std_logic                     := 'X';             -- spw_lvds_n_strobe_in_signal
			spwc_c_enable_spw_rx_enable_signal       : in  std_logic                     := 'X';             -- spw_rx_enable_signal
			spwc_c_enable_spw_tx_enable_signal       : in  std_logic                     := 'X';             -- spw_tx_enable_signal
			spwc_c_leds_spw_red_status_led_signal    : out std_logic;                                        -- spw_red_status_led_signal
			spwc_c_leds_spw_green_status_led_signal  : out std_logic;                                        -- spw_green_status_led_signal
			spwc_c_lvds_spw_lvds_p_data_in_signal    : in  std_logic                     := 'X';             -- spw_lvds_p_data_in_signal
			spwc_c_lvds_spw_lvds_n_data_in_signal    : in  std_logic                     := 'X';             -- spw_lvds_n_data_in_signal
			spwc_c_lvds_spw_lvds_p_data_out_signal   : out std_logic;                                        -- spw_lvds_p_data_out_signal
			spwc_c_lvds_spw_lvds_n_data_out_signal   : out std_logic;                                        -- spw_lvds_n_data_out_signal
			spwc_c_lvds_spw_lvds_p_strobe_out_signal : out std_logic;                                        -- spw_lvds_p_strobe_out_signal
			spwc_c_lvds_spw_lvds_n_strobe_out_signal : out std_logic;                                        -- spw_lvds_n_strobe_out_signal
			spwc_c_lvds_spw_lvds_p_strobe_in_signal  : in  std_logic                     := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_c_lvds_spw_lvds_n_strobe_in_signal  : in  std_logic                     := 'X';             -- spw_lvds_n_strobe_in_signal
			spwc_d_enable_spw_rx_enable_signal       : in  std_logic                     := 'X';             -- spw_rx_enable_signal
			spwc_d_enable_spw_tx_enable_signal       : in  std_logic                     := 'X';             -- spw_tx_enable_signal
			spwc_d_leds_spw_red_status_led_signal    : out std_logic;                                        -- spw_red_status_led_signal
			spwc_d_leds_spw_green_status_led_signal  : out std_logic;                                        -- spw_green_status_led_signal
			spwc_d_lvds_spw_lvds_p_data_in_signal    : in  std_logic                     := 'X';             -- spw_lvds_p_data_in_signal
			spwc_d_lvds_spw_lvds_n_data_in_signal    : in  std_logic                     := 'X';             -- spw_lvds_n_data_in_signal
			spwc_d_lvds_spw_lvds_p_data_out_signal   : out std_logic;                                        -- spw_lvds_p_data_out_signal
			spwc_d_lvds_spw_lvds_n_data_out_signal   : out std_logic;                                        -- spw_lvds_n_data_out_signal
			spwc_d_lvds_spw_lvds_p_strobe_out_signal : out std_logic;                                        -- spw_lvds_p_strobe_out_signal
			spwc_d_lvds_spw_lvds_n_strobe_out_signal : out std_logic;                                        -- spw_lvds_n_strobe_out_signal
			spwc_d_lvds_spw_lvds_p_strobe_in_signal  : in  std_logic                     := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_d_lvds_spw_lvds_n_strobe_in_signal  : in  std_logic                     := 'X';             -- spw_lvds_n_strobe_in_signal
			spwc_e_enable_spw_rx_enable_signal       : in  std_logic                     := 'X';             -- spw_rx_enable_signal
			spwc_e_enable_spw_tx_enable_signal       : in  std_logic                     := 'X';             -- spw_tx_enable_signal
			spwc_e_leds_spw_red_status_led_signal    : out std_logic;                                        -- spw_red_status_led_signal
			spwc_e_leds_spw_green_status_led_signal  : out std_logic;                                        -- spw_green_status_led_signal
			spwc_e_lvds_spw_lvds_p_data_in_signal    : in  std_logic                     := 'X';             -- spw_lvds_p_data_in_signal
			spwc_e_lvds_spw_lvds_n_data_in_signal    : in  std_logic                     := 'X';             -- spw_lvds_n_data_in_signal
			spwc_e_lvds_spw_lvds_p_data_out_signal   : out std_logic;                                        -- spw_lvds_p_data_out_signal
			spwc_e_lvds_spw_lvds_n_data_out_signal   : out std_logic;                                        -- spw_lvds_n_data_out_signal
			spwc_e_lvds_spw_lvds_p_strobe_out_signal : out std_logic;                                        -- spw_lvds_p_strobe_out_signal
			spwc_e_lvds_spw_lvds_n_strobe_out_signal : out std_logic;                                        -- spw_lvds_n_strobe_out_signal
			spwc_e_lvds_spw_lvds_p_strobe_in_signal  : in  std_logic                     := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_e_lvds_spw_lvds_n_strobe_in_signal  : in  std_logic                     := 'X';             -- spw_lvds_n_strobe_in_signal
			spwc_f_enable_spw_rx_enable_signal       : in  std_logic                     := 'X';             -- spw_rx_enable_signal
			spwc_f_enable_spw_tx_enable_signal       : in  std_logic                     := 'X';             -- spw_tx_enable_signal
			spwc_f_leds_spw_red_status_led_signal    : out std_logic;                                        -- spw_red_status_led_signal
			spwc_f_leds_spw_green_status_led_signal  : out std_logic;                                        -- spw_green_status_led_signal
			spwc_f_lvds_spw_lvds_p_data_in_signal    : in  std_logic                     := 'X';             -- spw_lvds_p_data_in_signal
			spwc_f_lvds_spw_lvds_n_data_in_signal    : in  std_logic                     := 'X';             -- spw_lvds_n_data_in_signal
			spwc_f_lvds_spw_lvds_p_data_out_signal   : out std_logic;                                        -- spw_lvds_p_data_out_signal
			spwc_f_lvds_spw_lvds_n_data_out_signal   : out std_logic;                                        -- spw_lvds_n_data_out_signal
			spwc_f_lvds_spw_lvds_p_strobe_out_signal : out std_logic;                                        -- spw_lvds_p_strobe_out_signal
			spwc_f_lvds_spw_lvds_n_strobe_out_signal : out std_logic;                                        -- spw_lvds_n_strobe_out_signal
			spwc_f_lvds_spw_lvds_p_strobe_in_signal  : in  std_logic                     := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_f_lvds_spw_lvds_n_strobe_in_signal  : in  std_logic                     := 'X';             -- spw_lvds_n_strobe_in_signal
			spwc_g_enable_spw_rx_enable_signal       : in  std_logic                     := 'X';             -- spw_rx_enable_signal
			spwc_g_enable_spw_tx_enable_signal       : in  std_logic                     := 'X';             -- spw_tx_enable_signal
			spwc_g_leds_spw_red_status_led_signal    : out std_logic;                                        -- spw_red_status_led_signal
			spwc_g_leds_spw_green_status_led_signal  : out std_logic;                                        -- spw_green_status_led_signal
			spwc_g_lvds_spw_lvds_p_data_in_signal    : in  std_logic                     := 'X';             -- spw_lvds_p_data_in_signal
			spwc_g_lvds_spw_lvds_n_data_in_signal    : in  std_logic                     := 'X';             -- spw_lvds_n_data_in_signal
			spwc_g_lvds_spw_lvds_p_data_out_signal   : out std_logic;                                        -- spw_lvds_p_data_out_signal
			spwc_g_lvds_spw_lvds_n_data_out_signal   : out std_logic;                                        -- spw_lvds_n_data_out_signal
			spwc_g_lvds_spw_lvds_p_strobe_out_signal : out std_logic;                                        -- spw_lvds_p_strobe_out_signal
			spwc_g_lvds_spw_lvds_n_strobe_out_signal : out std_logic;                                        -- spw_lvds_n_strobe_out_signal
			spwc_g_lvds_spw_lvds_p_strobe_in_signal  : in  std_logic                     := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_g_lvds_spw_lvds_n_strobe_in_signal  : in  std_logic                     := 'X';             -- spw_lvds_n_strobe_in_signal
			spwc_h_enable_spw_rx_enable_signal       : in  std_logic                     := 'X';             -- spw_rx_enable_signal
			spwc_h_enable_spw_tx_enable_signal       : in  std_logic                     := 'X';             -- spw_tx_enable_signal
			spwc_h_leds_spw_red_status_led_signal    : out std_logic;                                        -- spw_red_status_led_signal
			spwc_h_leds_spw_green_status_led_signal  : out std_logic;                                        -- spw_green_status_led_signal
			spwc_h_lvds_spw_lvds_p_data_in_signal    : in  std_logic                     := 'X';             -- spw_lvds_p_data_in_signal
			spwc_h_lvds_spw_lvds_n_data_in_signal    : in  std_logic                     := 'X';             -- spw_lvds_n_data_in_signal
			spwc_h_lvds_spw_lvds_p_data_out_signal   : out std_logic;                                        -- spw_lvds_p_data_out_signal
			spwc_h_lvds_spw_lvds_n_data_out_signal   : out std_logic;                                        -- spw_lvds_n_data_out_signal
			spwc_h_lvds_spw_lvds_p_strobe_out_signal : out std_logic;                                        -- spw_lvds_p_strobe_out_signal
			spwc_h_lvds_spw_lvds_n_strobe_out_signal : out std_logic;                                        -- spw_lvds_n_strobe_out_signal
			spwc_h_lvds_spw_lvds_p_strobe_in_signal  : in  std_logic                     := 'X';             -- spw_lvds_p_strobe_in_signal
			spwc_h_lvds_spw_lvds_n_strobe_in_signal  : in  std_logic                     := 'X';             -- spw_lvds_n_strobe_in_signal
			altpll_0_locked_conduit_export           : out std_logic;                                        -- export
			altpll_0_areset_conduit_export           : in  std_logic                     := 'X';             -- export
			altpll_0_pll_slave_read                  : in  std_logic                     := 'X';             -- read
			altpll_0_pll_slave_write                 : in  std_logic                     := 'X';             -- write
			altpll_0_pll_slave_address               : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- address
			altpll_0_pll_slave_readdata              : out std_logic_vector(31 downto 0);                    -- readdata
			altpll_0_pll_slave_writedata             : in  std_logic_vector(31 downto 0) := (others => 'X')  -- writedata
		);
	end component MebX_Qsys_Project;

	u0 : component MebX_Qsys_Project
		port map (
			clk50_clk                                => CONNECTED_TO_clk50_clk,                                --                   clk50.clk
			rst_reset_n                              => CONNECTED_TO_rst_reset_n,                              --                     rst.reset_n
			spwc_a_enable_spw_rx_enable_signal       => CONNECTED_TO_spwc_a_enable_spw_rx_enable_signal,       --           spwc_a_enable.spw_rx_enable_signal
			spwc_a_enable_spw_tx_enable_signal       => CONNECTED_TO_spwc_a_enable_spw_tx_enable_signal,       --                        .spw_tx_enable_signal
			spwc_a_leds_spw_red_status_led_signal    => CONNECTED_TO_spwc_a_leds_spw_red_status_led_signal,    --             spwc_a_leds.spw_red_status_led_signal
			spwc_a_leds_spw_green_status_led_signal  => CONNECTED_TO_spwc_a_leds_spw_green_status_led_signal,  --                        .spw_green_status_led_signal
			spwc_a_lvds_spw_lvds_p_data_in_signal    => CONNECTED_TO_spwc_a_lvds_spw_lvds_p_data_in_signal,    --             spwc_a_lvds.spw_lvds_p_data_in_signal
			spwc_a_lvds_spw_lvds_n_data_in_signal    => CONNECTED_TO_spwc_a_lvds_spw_lvds_n_data_in_signal,    --                        .spw_lvds_n_data_in_signal
			spwc_a_lvds_spw_lvds_p_data_out_signal   => CONNECTED_TO_spwc_a_lvds_spw_lvds_p_data_out_signal,   --                        .spw_lvds_p_data_out_signal
			spwc_a_lvds_spw_lvds_n_data_out_signal   => CONNECTED_TO_spwc_a_lvds_spw_lvds_n_data_out_signal,   --                        .spw_lvds_n_data_out_signal
			spwc_a_lvds_spw_lvds_p_strobe_out_signal => CONNECTED_TO_spwc_a_lvds_spw_lvds_p_strobe_out_signal, --                        .spw_lvds_p_strobe_out_signal
			spwc_a_lvds_spw_lvds_n_strobe_out_signal => CONNECTED_TO_spwc_a_lvds_spw_lvds_n_strobe_out_signal, --                        .spw_lvds_n_strobe_out_signal
			spwc_a_lvds_spw_lvds_p_strobe_in_signal  => CONNECTED_TO_spwc_a_lvds_spw_lvds_p_strobe_in_signal,  --                        .spw_lvds_p_strobe_in_signal
			spwc_a_lvds_spw_lvds_n_strobe_in_signal  => CONNECTED_TO_spwc_a_lvds_spw_lvds_n_strobe_in_signal,  --                        .spw_lvds_n_strobe_in_signal
			spwc_b_enable_spw_rx_enable_signal       => CONNECTED_TO_spwc_b_enable_spw_rx_enable_signal,       --           spwc_b_enable.spw_rx_enable_signal
			spwc_b_enable_spw_tx_enable_signal       => CONNECTED_TO_spwc_b_enable_spw_tx_enable_signal,       --                        .spw_tx_enable_signal
			spwc_b_leds_spw_red_status_led_signal    => CONNECTED_TO_spwc_b_leds_spw_red_status_led_signal,    --             spwc_b_leds.spw_red_status_led_signal
			spwc_b_leds_spw_green_status_led_signal  => CONNECTED_TO_spwc_b_leds_spw_green_status_led_signal,  --                        .spw_green_status_led_signal
			spwc_b_lvds_spw_lvds_p_data_in_signal    => CONNECTED_TO_spwc_b_lvds_spw_lvds_p_data_in_signal,    --             spwc_b_lvds.spw_lvds_p_data_in_signal
			spwc_b_lvds_spw_lvds_n_data_in_signal    => CONNECTED_TO_spwc_b_lvds_spw_lvds_n_data_in_signal,    --                        .spw_lvds_n_data_in_signal
			spwc_b_lvds_spw_lvds_p_data_out_signal   => CONNECTED_TO_spwc_b_lvds_spw_lvds_p_data_out_signal,   --                        .spw_lvds_p_data_out_signal
			spwc_b_lvds_spw_lvds_n_data_out_signal   => CONNECTED_TO_spwc_b_lvds_spw_lvds_n_data_out_signal,   --                        .spw_lvds_n_data_out_signal
			spwc_b_lvds_spw_lvds_p_strobe_out_signal => CONNECTED_TO_spwc_b_lvds_spw_lvds_p_strobe_out_signal, --                        .spw_lvds_p_strobe_out_signal
			spwc_b_lvds_spw_lvds_n_strobe_out_signal => CONNECTED_TO_spwc_b_lvds_spw_lvds_n_strobe_out_signal, --                        .spw_lvds_n_strobe_out_signal
			spwc_b_lvds_spw_lvds_p_strobe_in_signal  => CONNECTED_TO_spwc_b_lvds_spw_lvds_p_strobe_in_signal,  --                        .spw_lvds_p_strobe_in_signal
			spwc_b_lvds_spw_lvds_n_strobe_in_signal  => CONNECTED_TO_spwc_b_lvds_spw_lvds_n_strobe_in_signal,  --                        .spw_lvds_n_strobe_in_signal
			spwc_c_enable_spw_rx_enable_signal       => CONNECTED_TO_spwc_c_enable_spw_rx_enable_signal,       --           spwc_c_enable.spw_rx_enable_signal
			spwc_c_enable_spw_tx_enable_signal       => CONNECTED_TO_spwc_c_enable_spw_tx_enable_signal,       --                        .spw_tx_enable_signal
			spwc_c_leds_spw_red_status_led_signal    => CONNECTED_TO_spwc_c_leds_spw_red_status_led_signal,    --             spwc_c_leds.spw_red_status_led_signal
			spwc_c_leds_spw_green_status_led_signal  => CONNECTED_TO_spwc_c_leds_spw_green_status_led_signal,  --                        .spw_green_status_led_signal
			spwc_c_lvds_spw_lvds_p_data_in_signal    => CONNECTED_TO_spwc_c_lvds_spw_lvds_p_data_in_signal,    --             spwc_c_lvds.spw_lvds_p_data_in_signal
			spwc_c_lvds_spw_lvds_n_data_in_signal    => CONNECTED_TO_spwc_c_lvds_spw_lvds_n_data_in_signal,    --                        .spw_lvds_n_data_in_signal
			spwc_c_lvds_spw_lvds_p_data_out_signal   => CONNECTED_TO_spwc_c_lvds_spw_lvds_p_data_out_signal,   --                        .spw_lvds_p_data_out_signal
			spwc_c_lvds_spw_lvds_n_data_out_signal   => CONNECTED_TO_spwc_c_lvds_spw_lvds_n_data_out_signal,   --                        .spw_lvds_n_data_out_signal
			spwc_c_lvds_spw_lvds_p_strobe_out_signal => CONNECTED_TO_spwc_c_lvds_spw_lvds_p_strobe_out_signal, --                        .spw_lvds_p_strobe_out_signal
			spwc_c_lvds_spw_lvds_n_strobe_out_signal => CONNECTED_TO_spwc_c_lvds_spw_lvds_n_strobe_out_signal, --                        .spw_lvds_n_strobe_out_signal
			spwc_c_lvds_spw_lvds_p_strobe_in_signal  => CONNECTED_TO_spwc_c_lvds_spw_lvds_p_strobe_in_signal,  --                        .spw_lvds_p_strobe_in_signal
			spwc_c_lvds_spw_lvds_n_strobe_in_signal  => CONNECTED_TO_spwc_c_lvds_spw_lvds_n_strobe_in_signal,  --                        .spw_lvds_n_strobe_in_signal
			spwc_d_enable_spw_rx_enable_signal       => CONNECTED_TO_spwc_d_enable_spw_rx_enable_signal,       --           spwc_d_enable.spw_rx_enable_signal
			spwc_d_enable_spw_tx_enable_signal       => CONNECTED_TO_spwc_d_enable_spw_tx_enable_signal,       --                        .spw_tx_enable_signal
			spwc_d_leds_spw_red_status_led_signal    => CONNECTED_TO_spwc_d_leds_spw_red_status_led_signal,    --             spwc_d_leds.spw_red_status_led_signal
			spwc_d_leds_spw_green_status_led_signal  => CONNECTED_TO_spwc_d_leds_spw_green_status_led_signal,  --                        .spw_green_status_led_signal
			spwc_d_lvds_spw_lvds_p_data_in_signal    => CONNECTED_TO_spwc_d_lvds_spw_lvds_p_data_in_signal,    --             spwc_d_lvds.spw_lvds_p_data_in_signal
			spwc_d_lvds_spw_lvds_n_data_in_signal    => CONNECTED_TO_spwc_d_lvds_spw_lvds_n_data_in_signal,    --                        .spw_lvds_n_data_in_signal
			spwc_d_lvds_spw_lvds_p_data_out_signal   => CONNECTED_TO_spwc_d_lvds_spw_lvds_p_data_out_signal,   --                        .spw_lvds_p_data_out_signal
			spwc_d_lvds_spw_lvds_n_data_out_signal   => CONNECTED_TO_spwc_d_lvds_spw_lvds_n_data_out_signal,   --                        .spw_lvds_n_data_out_signal
			spwc_d_lvds_spw_lvds_p_strobe_out_signal => CONNECTED_TO_spwc_d_lvds_spw_lvds_p_strobe_out_signal, --                        .spw_lvds_p_strobe_out_signal
			spwc_d_lvds_spw_lvds_n_strobe_out_signal => CONNECTED_TO_spwc_d_lvds_spw_lvds_n_strobe_out_signal, --                        .spw_lvds_n_strobe_out_signal
			spwc_d_lvds_spw_lvds_p_strobe_in_signal  => CONNECTED_TO_spwc_d_lvds_spw_lvds_p_strobe_in_signal,  --                        .spw_lvds_p_strobe_in_signal
			spwc_d_lvds_spw_lvds_n_strobe_in_signal  => CONNECTED_TO_spwc_d_lvds_spw_lvds_n_strobe_in_signal,  --                        .spw_lvds_n_strobe_in_signal
			spwc_e_enable_spw_rx_enable_signal       => CONNECTED_TO_spwc_e_enable_spw_rx_enable_signal,       --           spwc_e_enable.spw_rx_enable_signal
			spwc_e_enable_spw_tx_enable_signal       => CONNECTED_TO_spwc_e_enable_spw_tx_enable_signal,       --                        .spw_tx_enable_signal
			spwc_e_leds_spw_red_status_led_signal    => CONNECTED_TO_spwc_e_leds_spw_red_status_led_signal,    --             spwc_e_leds.spw_red_status_led_signal
			spwc_e_leds_spw_green_status_led_signal  => CONNECTED_TO_spwc_e_leds_spw_green_status_led_signal,  --                        .spw_green_status_led_signal
			spwc_e_lvds_spw_lvds_p_data_in_signal    => CONNECTED_TO_spwc_e_lvds_spw_lvds_p_data_in_signal,    --             spwc_e_lvds.spw_lvds_p_data_in_signal
			spwc_e_lvds_spw_lvds_n_data_in_signal    => CONNECTED_TO_spwc_e_lvds_spw_lvds_n_data_in_signal,    --                        .spw_lvds_n_data_in_signal
			spwc_e_lvds_spw_lvds_p_data_out_signal   => CONNECTED_TO_spwc_e_lvds_spw_lvds_p_data_out_signal,   --                        .spw_lvds_p_data_out_signal
			spwc_e_lvds_spw_lvds_n_data_out_signal   => CONNECTED_TO_spwc_e_lvds_spw_lvds_n_data_out_signal,   --                        .spw_lvds_n_data_out_signal
			spwc_e_lvds_spw_lvds_p_strobe_out_signal => CONNECTED_TO_spwc_e_lvds_spw_lvds_p_strobe_out_signal, --                        .spw_lvds_p_strobe_out_signal
			spwc_e_lvds_spw_lvds_n_strobe_out_signal => CONNECTED_TO_spwc_e_lvds_spw_lvds_n_strobe_out_signal, --                        .spw_lvds_n_strobe_out_signal
			spwc_e_lvds_spw_lvds_p_strobe_in_signal  => CONNECTED_TO_spwc_e_lvds_spw_lvds_p_strobe_in_signal,  --                        .spw_lvds_p_strobe_in_signal
			spwc_e_lvds_spw_lvds_n_strobe_in_signal  => CONNECTED_TO_spwc_e_lvds_spw_lvds_n_strobe_in_signal,  --                        .spw_lvds_n_strobe_in_signal
			spwc_f_enable_spw_rx_enable_signal       => CONNECTED_TO_spwc_f_enable_spw_rx_enable_signal,       --           spwc_f_enable.spw_rx_enable_signal
			spwc_f_enable_spw_tx_enable_signal       => CONNECTED_TO_spwc_f_enable_spw_tx_enable_signal,       --                        .spw_tx_enable_signal
			spwc_f_leds_spw_red_status_led_signal    => CONNECTED_TO_spwc_f_leds_spw_red_status_led_signal,    --             spwc_f_leds.spw_red_status_led_signal
			spwc_f_leds_spw_green_status_led_signal  => CONNECTED_TO_spwc_f_leds_spw_green_status_led_signal,  --                        .spw_green_status_led_signal
			spwc_f_lvds_spw_lvds_p_data_in_signal    => CONNECTED_TO_spwc_f_lvds_spw_lvds_p_data_in_signal,    --             spwc_f_lvds.spw_lvds_p_data_in_signal
			spwc_f_lvds_spw_lvds_n_data_in_signal    => CONNECTED_TO_spwc_f_lvds_spw_lvds_n_data_in_signal,    --                        .spw_lvds_n_data_in_signal
			spwc_f_lvds_spw_lvds_p_data_out_signal   => CONNECTED_TO_spwc_f_lvds_spw_lvds_p_data_out_signal,   --                        .spw_lvds_p_data_out_signal
			spwc_f_lvds_spw_lvds_n_data_out_signal   => CONNECTED_TO_spwc_f_lvds_spw_lvds_n_data_out_signal,   --                        .spw_lvds_n_data_out_signal
			spwc_f_lvds_spw_lvds_p_strobe_out_signal => CONNECTED_TO_spwc_f_lvds_spw_lvds_p_strobe_out_signal, --                        .spw_lvds_p_strobe_out_signal
			spwc_f_lvds_spw_lvds_n_strobe_out_signal => CONNECTED_TO_spwc_f_lvds_spw_lvds_n_strobe_out_signal, --                        .spw_lvds_n_strobe_out_signal
			spwc_f_lvds_spw_lvds_p_strobe_in_signal  => CONNECTED_TO_spwc_f_lvds_spw_lvds_p_strobe_in_signal,  --                        .spw_lvds_p_strobe_in_signal
			spwc_f_lvds_spw_lvds_n_strobe_in_signal  => CONNECTED_TO_spwc_f_lvds_spw_lvds_n_strobe_in_signal,  --                        .spw_lvds_n_strobe_in_signal
			spwc_g_enable_spw_rx_enable_signal       => CONNECTED_TO_spwc_g_enable_spw_rx_enable_signal,       --           spwc_g_enable.spw_rx_enable_signal
			spwc_g_enable_spw_tx_enable_signal       => CONNECTED_TO_spwc_g_enable_spw_tx_enable_signal,       --                        .spw_tx_enable_signal
			spwc_g_leds_spw_red_status_led_signal    => CONNECTED_TO_spwc_g_leds_spw_red_status_led_signal,    --             spwc_g_leds.spw_red_status_led_signal
			spwc_g_leds_spw_green_status_led_signal  => CONNECTED_TO_spwc_g_leds_spw_green_status_led_signal,  --                        .spw_green_status_led_signal
			spwc_g_lvds_spw_lvds_p_data_in_signal    => CONNECTED_TO_spwc_g_lvds_spw_lvds_p_data_in_signal,    --             spwc_g_lvds.spw_lvds_p_data_in_signal
			spwc_g_lvds_spw_lvds_n_data_in_signal    => CONNECTED_TO_spwc_g_lvds_spw_lvds_n_data_in_signal,    --                        .spw_lvds_n_data_in_signal
			spwc_g_lvds_spw_lvds_p_data_out_signal   => CONNECTED_TO_spwc_g_lvds_spw_lvds_p_data_out_signal,   --                        .spw_lvds_p_data_out_signal
			spwc_g_lvds_spw_lvds_n_data_out_signal   => CONNECTED_TO_spwc_g_lvds_spw_lvds_n_data_out_signal,   --                        .spw_lvds_n_data_out_signal
			spwc_g_lvds_spw_lvds_p_strobe_out_signal => CONNECTED_TO_spwc_g_lvds_spw_lvds_p_strobe_out_signal, --                        .spw_lvds_p_strobe_out_signal
			spwc_g_lvds_spw_lvds_n_strobe_out_signal => CONNECTED_TO_spwc_g_lvds_spw_lvds_n_strobe_out_signal, --                        .spw_lvds_n_strobe_out_signal
			spwc_g_lvds_spw_lvds_p_strobe_in_signal  => CONNECTED_TO_spwc_g_lvds_spw_lvds_p_strobe_in_signal,  --                        .spw_lvds_p_strobe_in_signal
			spwc_g_lvds_spw_lvds_n_strobe_in_signal  => CONNECTED_TO_spwc_g_lvds_spw_lvds_n_strobe_in_signal,  --                        .spw_lvds_n_strobe_in_signal
			spwc_h_enable_spw_rx_enable_signal       => CONNECTED_TO_spwc_h_enable_spw_rx_enable_signal,       --           spwc_h_enable.spw_rx_enable_signal
			spwc_h_enable_spw_tx_enable_signal       => CONNECTED_TO_spwc_h_enable_spw_tx_enable_signal,       --                        .spw_tx_enable_signal
			spwc_h_leds_spw_red_status_led_signal    => CONNECTED_TO_spwc_h_leds_spw_red_status_led_signal,    --             spwc_h_leds.spw_red_status_led_signal
			spwc_h_leds_spw_green_status_led_signal  => CONNECTED_TO_spwc_h_leds_spw_green_status_led_signal,  --                        .spw_green_status_led_signal
			spwc_h_lvds_spw_lvds_p_data_in_signal    => CONNECTED_TO_spwc_h_lvds_spw_lvds_p_data_in_signal,    --             spwc_h_lvds.spw_lvds_p_data_in_signal
			spwc_h_lvds_spw_lvds_n_data_in_signal    => CONNECTED_TO_spwc_h_lvds_spw_lvds_n_data_in_signal,    --                        .spw_lvds_n_data_in_signal
			spwc_h_lvds_spw_lvds_p_data_out_signal   => CONNECTED_TO_spwc_h_lvds_spw_lvds_p_data_out_signal,   --                        .spw_lvds_p_data_out_signal
			spwc_h_lvds_spw_lvds_n_data_out_signal   => CONNECTED_TO_spwc_h_lvds_spw_lvds_n_data_out_signal,   --                        .spw_lvds_n_data_out_signal
			spwc_h_lvds_spw_lvds_p_strobe_out_signal => CONNECTED_TO_spwc_h_lvds_spw_lvds_p_strobe_out_signal, --                        .spw_lvds_p_strobe_out_signal
			spwc_h_lvds_spw_lvds_n_strobe_out_signal => CONNECTED_TO_spwc_h_lvds_spw_lvds_n_strobe_out_signal, --                        .spw_lvds_n_strobe_out_signal
			spwc_h_lvds_spw_lvds_p_strobe_in_signal  => CONNECTED_TO_spwc_h_lvds_spw_lvds_p_strobe_in_signal,  --                        .spw_lvds_p_strobe_in_signal
			spwc_h_lvds_spw_lvds_n_strobe_in_signal  => CONNECTED_TO_spwc_h_lvds_spw_lvds_n_strobe_in_signal,  --                        .spw_lvds_n_strobe_in_signal
			altpll_0_locked_conduit_export           => CONNECTED_TO_altpll_0_locked_conduit_export,           -- altpll_0_locked_conduit.export
			altpll_0_areset_conduit_export           => CONNECTED_TO_altpll_0_areset_conduit_export,           -- altpll_0_areset_conduit.export
			altpll_0_pll_slave_read                  => CONNECTED_TO_altpll_0_pll_slave_read,                  --      altpll_0_pll_slave.read
			altpll_0_pll_slave_write                 => CONNECTED_TO_altpll_0_pll_slave_write,                 --                        .write
			altpll_0_pll_slave_address               => CONNECTED_TO_altpll_0_pll_slave_address,               --                        .address
			altpll_0_pll_slave_readdata              => CONNECTED_TO_altpll_0_pll_slave_readdata,              --                        .readdata
			altpll_0_pll_slave_writedata             => CONNECTED_TO_altpll_0_pll_slave_writedata              --                        .writedata
		);

