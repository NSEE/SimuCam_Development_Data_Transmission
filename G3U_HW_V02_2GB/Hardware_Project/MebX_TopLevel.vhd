-- Bibliotecas
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity MebX_TopLevel is
    port(
        -- Global
        OSC_50_BANK2           : in    std_logic;
        OSC_50_BANK4           : in    std_logic;
        OSC_50_BANK3           : in    std_logic;
        -- RST
        CPU_RESET_n            : in    std_logic;
        RESET_PAINEL_n         : in    std_logic; -- painel GPIO1
        -- LEDs
        LED_DE4                : out   std_logic_vector(7 downto 0);
        -- painel GPIO1
        LED_PAINEL_LED_1G      : out   std_logic;
        LED_PAINEL_LED_1R      : out   std_logic;
        LED_PAINEL_LED_2G      : out   std_logic;
        LED_PAINEL_LED_2R      : out   std_logic;
        LED_PAINEL_LED_3G      : out   std_logic;
        LED_PAINEL_LED_3R      : out   std_logic;
        LED_PAINEL_LED_4G      : out   std_logic;
        LED_PAINEL_LED_4R      : out   std_logic;
        LED_PAINEL_LED_5G      : out   std_logic;
        LED_PAINEL_LED_5R      : out   std_logic;
        LED_PAINEL_LED_6G      : out   std_logic;
        LED_PAINEL_LED_6R      : out   std_logic;
        LED_PAINEL_LED_7G      : out   std_logic;
        LED_PAINEL_LED_7R      : out   std_logic;
        LED_PAINEL_LED_8G      : out   std_logic;
        LED_PAINEL_LED_8R      : out   std_logic;
        LED_PAINEL_LED_POWER   : out   std_logic;
        LED_PAINEL_LED_ST1     : out   std_logic;
        LED_PAINEL_LED_ST2     : out   std_logic;
        LED_PAINEL_LED_ST3     : out   std_logic;
        LED_PAINEL_LED_ST4     : out   std_logic;
        -- Seven Segment Display
        --		SEVEN_SEG_HEX1         : out   std_logic_vector(7 downto 0);
        --		SEVEN_SEG_HEX0         : out   std_logic_vector(7 downto 0);
        -- FANs
        FAN_CTRL               : out   std_logic;
        -- Sinais de controle - placa isoladora - habilitacao dos transmissores SpW e Sinc_out
        EN_ISO_DRIVERS         : out   std_logic;
        -- Sinais externos LVDS HSMC-B
        -- Sinais de controle - placa drivers_lvds
        HSMB_BUFFER_PWDN_N     : out   std_logic;
        HSMB_BUFFER_PEM1       : out   std_logic;
        HSMB_BUFFER_PEM0       : out   std_logic;
        -- SpaceWire A
        HSMB_LVDS_RX_SPWA_DI_P : in    std_logic;
        HSMB_LVDS_RX_SPWA_DI_N : in    std_logic;
        HSMB_LVDS_RX_SPWA_SI_P : in    std_logic;
        HSMB_LVDS_RX_SPWA_SI_N : in    std_logic;
        HSMB_LVDS_TX_SPWA_DO_P : out   std_logic;
        HSMB_LVDS_TX_SPWA_DO_N : out   std_logic;
        HSMB_LVDS_TX_SPWA_SO_P : out   std_logic;
        HSMB_LVDS_TX_SPWA_SO_N : out   std_logic;
        -- SpaceWire B
        HSMB_LVDS_RX_SPWB_DI_P : in    std_logic;
        HSMB_LVDS_RX_SPWB_DI_N : in    std_logic;
        HSMB_LVDS_RX_SPWB_SI_P : in    std_logic;
        HSMB_LVDS_RX_SPWB_SI_N : in    std_logic;
        HSMB_LVDS_TX_SPWB_DO_P : out   std_logic;
        HSMB_LVDS_TX_SPWB_DO_N : out   std_logic;
        HSMB_LVDS_TX_SPWB_SO_P : out   std_logic;
        HSMB_LVDS_TX_SPWB_SO_N : out   std_logic;
        -- SpaceWire C
        HSMB_LVDS_RX_SPWC_DI_P : in    std_logic;
        HSMB_LVDS_RX_SPWC_DI_N : in    std_logic;
        HSMB_LVDS_RX_SPWC_SI_P : in    std_logic;
        HSMB_LVDS_RX_SPWC_SI_N : in    std_logic;
        HSMB_LVDS_TX_SPWC_DO_P : out   std_logic;
        HSMB_LVDS_TX_SPWC_DO_N : out   std_logic;
        HSMB_LVDS_TX_SPWC_SO_P : out   std_logic;
        HSMB_LVDS_TX_SPWC_SO_N : out   std_logic;
        -- SpaceWire D
        HSMB_LVDS_RX_SPWD_DI_P : in    std_logic;
        HSMB_LVDS_RX_SPWD_DI_N : in    std_logic;
        HSMB_LVDS_RX_SPWD_SI_P : in    std_logic;
        HSMB_LVDS_RX_SPWD_SI_N : in    std_logic;
        HSMB_LVDS_TX_SPWD_DO_P : out   std_logic;
        HSMB_LVDS_TX_SPWD_DO_N : out   std_logic;
        HSMB_LVDS_TX_SPWD_SO_P : out   std_logic;
        HSMB_LVDS_TX_SPWD_SO_N : out   std_logic;
        -- SpaceWire E
        HSMB_LVDS_RX_SPWE_DI_P : in    std_logic;
        HSMB_LVDS_RX_SPWE_DI_N : in    std_logic;
        HSMB_LVDS_RX_SPWE_SI_P : in    std_logic;
        HSMB_LVDS_RX_SPWE_SI_N : in    std_logic;
        HSMB_LVDS_TX_SPWE_DO_P : out   std_logic;
        HSMB_LVDS_TX_SPWE_DO_N : out   std_logic;
        HSMB_LVDS_TX_SPWE_SO_P : out   std_logic;
        HSMB_LVDS_TX_SPWE_SO_N : out   std_logic;
        -- SpaceWire F
        HSMB_LVDS_RX_SPWF_DI_P : in    std_logic;
        HSMB_LVDS_RX_SPWF_DI_N : in    std_logic;
        HSMB_LVDS_RX_SPWF_SI_P : in    std_logic;
        HSMB_LVDS_RX_SPWF_SI_N : in    std_logic;
        HSMB_LVDS_TX_SPWF_DO_P : out   std_logic;
        HSMB_LVDS_TX_SPWF_DO_N : out   std_logic;
        HSMB_LVDS_TX_SPWF_SO_P : out   std_logic;
        HSMB_LVDS_TX_SPWF_SO_N : out   std_logic;
        -- SpaceWire G
        HSMB_LVDS_RX_SPWG_DI_P : in    std_logic;
        HSMB_LVDS_RX_SPWG_DI_N : in    std_logic;
        HSMB_LVDS_RX_SPWG_SI_P : in    std_logic;
        HSMB_LVDS_RX_SPWG_SI_N : in    std_logic;
        HSMB_LVDS_TX_SPWG_DO_P : out   std_logic;
        HSMB_LVDS_TX_SPWG_DO_N : out   std_logic;
        HSMB_LVDS_TX_SPWG_SO_P : out   std_logic;
        HSMB_LVDS_TX_SPWG_SO_N : out   std_logic;
        -- SpaceWire H
        HSMB_LVDS_RX_SPWH_DI_P : in    std_logic;
        HSMB_LVDS_RX_SPWH_DI_N : in    std_logic;
        HSMB_LVDS_RX_SPWH_SI_P : in    std_logic;
        HSMB_LVDS_RX_SPWH_SI_N : in    std_logic;
        HSMB_LVDS_TX_SPWH_DO_P : out   std_logic;
        HSMB_LVDS_TX_SPWH_DO_N : out   std_logic;
        HSMB_LVDS_TX_SPWH_SO_P : out   std_logic;
        HSMB_LVDS_TX_SPWH_SO_N : out   std_logic
    );
end entity;

architecture bhv of MebX_TopLevel is

    -----------------------------------------
    -- Clock e reset
    -----------------------------------------
    signal rst_ctrl_input   : std_logic := '0';
    signal simucam_rst      : std_logic := '0';
    signal rst_n            : std_logic;

    -----------------------------------------
    -- LEDs
    -----------------------------------------
    signal leds_b : std_logic_vector(7 downto 0);
    signal leds_p : std_logic_vector(20 downto 0);

    -----------------------------------------
    -- Ctrl io lvds
    -----------------------------------------
    signal ctrl_io_lvds : std_logic_vector(3 downto 0);
    alias a_enable_iso_drivers is ctrl_io_lvds(3);
    alias a_hsmb_buffers_powerdown_n is ctrl_io_lvds(2);
    alias a_hsmb_buffers_preemphasis_1 is ctrl_io_lvds(1);
    alias a_hsmb_buffers_preemphasis_0 is ctrl_io_lvds(0);

    -----------------------------------------
    -- Signals
    -----------------------------------------

    signal iso_logic_enable : std_logic;

    signal spw_a_red_led   : std_logic;
    signal spw_a_green_led : std_logic;
    signal spw_b_red_led   : std_logic;
    signal spw_b_green_led : std_logic;
    signal spw_c_red_led   : std_logic;
    signal spw_c_green_led : std_logic;
    signal spw_d_red_led   : std_logic;
    signal spw_d_green_led : std_logic;
    signal spw_e_red_led   : std_logic;
    signal spw_e_green_led : std_logic;
    signal spw_f_red_led   : std_logic;
    signal spw_f_green_led : std_logic;
    signal spw_g_red_led   : std_logic;
    signal spw_g_green_led : std_logic;
    signal spw_h_red_led   : std_logic;
    signal spw_h_green_led : std_logic;

    -----------------------------------------
    -- Component
    -----------------------------------------

    component MebX_Qsys_Project is
        port(
            rst_reset_n                                                 : in    std_logic;
            --
            clk50_clk                                                   : in    std_logic                     := '0';
            --
            spwc_a_lvds_spw_lvds_p_data_in_signal                       : in    std_logic                     := 'X'; -- spw_lvds_p_data_in_signal
            spwc_a_lvds_spw_lvds_n_data_in_signal                       : in    std_logic                     := 'X'; -- spw_lvds_n_data_in_signal
            spwc_a_lvds_spw_lvds_p_strobe_in_signal                     : in    std_logic                     := 'X'; -- spw_lvds_p_strobe_in_signal
            spwc_a_lvds_spw_lvds_n_strobe_in_signal                     : in    std_logic                     := 'X'; -- spw_lvds_n_strobe_in_signal
            spwc_a_lvds_spw_lvds_p_data_out_signal                      : out   std_logic; --                         -- spw_lvds_p_data_out_signal
            spwc_a_lvds_spw_lvds_n_data_out_signal                      : out   std_logic; --                         -- spw_lvds_n_data_out_signal
            spwc_a_lvds_spw_lvds_p_strobe_out_signal                    : out   std_logic; --                         -- spw_lvds_p_strobe_out_signal
            spwc_a_lvds_spw_lvds_n_strobe_out_signal                    : out   std_logic; --                         -- spw_lvds_n_strobe_out_signal
            --
            spwc_b_lvds_spw_lvds_p_data_in_signal                       : in    std_logic                     := 'X'; -- spw_lvds_p_data_in_signal
            spwc_b_lvds_spw_lvds_n_data_in_signal                       : in    std_logic                     := 'X'; -- spw_lvds_n_data_in_signal
            spwc_b_lvds_spw_lvds_p_strobe_in_signal                     : in    std_logic                     := 'X'; -- spw_lvds_p_strobe_in_signal
            spwc_b_lvds_spw_lvds_n_strobe_in_signal                     : in    std_logic                     := 'X'; -- spw_lvds_n_strobe_in_signal
            spwc_b_lvds_spw_lvds_p_data_out_signal                      : out   std_logic; --                         -- spw_lvds_p_data_out_signal
            spwc_b_lvds_spw_lvds_n_data_out_signal                      : out   std_logic; --                         -- spw_lvds_n_data_out_signal
            spwc_b_lvds_spw_lvds_p_strobe_out_signal                    : out   std_logic; --                         -- spw_lvds_p_strobe_out_signal
            spwc_b_lvds_spw_lvds_n_strobe_out_signal                    : out   std_logic; --                         -- spw_lvds_n_strobe_out_signal
            --
            spwc_c_lvds_spw_lvds_p_data_in_signal                       : in    std_logic                     := 'X'; -- spw_lvds_p_data_in_signal
            spwc_c_lvds_spw_lvds_n_data_in_signal                       : in    std_logic                     := 'X'; -- spw_lvds_n_data_in_signal
            spwc_c_lvds_spw_lvds_p_strobe_in_signal                     : in    std_logic                     := 'X'; -- spw_lvds_p_strobe_in_signal
            spwc_c_lvds_spw_lvds_n_strobe_in_signal                     : in    std_logic                     := 'X'; -- spw_lvds_n_strobe_in_signal
            spwc_c_lvds_spw_lvds_p_data_out_signal                      : out   std_logic; --                         -- spw_lvds_p_data_out_signal
            spwc_c_lvds_spw_lvds_n_data_out_signal                      : out   std_logic; --                         -- spw_lvds_n_data_out_signal
            spwc_c_lvds_spw_lvds_p_strobe_out_signal                    : out   std_logic; --                         -- spw_lvds_p_strobe_out_signal
            spwc_c_lvds_spw_lvds_n_strobe_out_signal                    : out   std_logic; --                         -- spw_lvds_n_strobe_out_signal
            --
            spwc_d_lvds_spw_lvds_p_data_in_signal                       : in    std_logic                     := 'X'; -- spw_lvds_p_data_in_signal
            spwc_d_lvds_spw_lvds_n_data_in_signal                       : in    std_logic                     := 'X'; -- spw_lvds_n_data_in_signal
            spwc_d_lvds_spw_lvds_p_strobe_in_signal                     : in    std_logic                     := 'X'; -- spw_lvds_p_strobe_in_signal
            spwc_d_lvds_spw_lvds_n_strobe_in_signal                     : in    std_logic                     := 'X'; -- spw_lvds_n_strobe_in_signal
            spwc_d_lvds_spw_lvds_p_data_out_signal                      : out   std_logic; --                         -- spw_lvds_p_data_out_signal
            spwc_d_lvds_spw_lvds_n_data_out_signal                      : out   std_logic; --                         -- spw_lvds_n_data_out_signal
            spwc_d_lvds_spw_lvds_p_strobe_out_signal                    : out   std_logic; --                         -- spw_lvds_p_strobe_out_signal
            spwc_d_lvds_spw_lvds_n_strobe_out_signal                    : out   std_logic; --                         -- spw_lvds_n_strobe_out_signal
            --
            spwc_e_lvds_spw_lvds_p_data_in_signal                       : in    std_logic                     := 'X'; -- spw_lvds_p_data_in_signal
            spwc_e_lvds_spw_lvds_n_data_in_signal                       : in    std_logic                     := 'X'; -- spw_lvds_n_data_in_signal
            spwc_e_lvds_spw_lvds_p_strobe_in_signal                     : in    std_logic                     := 'X'; -- spw_lvds_p_strobe_in_signal
            spwc_e_lvds_spw_lvds_n_strobe_in_signal                     : in    std_logic                     := 'X'; -- spw_lvds_n_strobe_in_signal
            spwc_e_lvds_spw_lvds_p_data_out_signal                      : out   std_logic; --                         -- spw_lvds_p_data_out_signal
            spwc_e_lvds_spw_lvds_n_data_out_signal                      : out   std_logic; --                         -- spw_lvds_n_data_out_signal
            spwc_e_lvds_spw_lvds_p_strobe_out_signal                    : out   std_logic; --                         -- spw_lvds_p_strobe_out_signal
            spwc_e_lvds_spw_lvds_n_strobe_out_signal                    : out   std_logic; --                         -- spw_lvds_n_strobe_out_signal
            --
            spwc_f_lvds_spw_lvds_p_data_in_signal                       : in    std_logic                     := 'X'; -- spw_lvds_p_data_in_signal
            spwc_f_lvds_spw_lvds_n_data_in_signal                       : in    std_logic                     := 'X'; -- spw_lvds_n_data_in_signal
            spwc_f_lvds_spw_lvds_p_strobe_in_signal                     : in    std_logic                     := 'X'; -- spw_lvds_p_strobe_in_signal
            spwc_f_lvds_spw_lvds_n_strobe_in_signal                     : in    std_logic                     := 'X'; -- spw_lvds_n_strobe_in_signal
            spwc_f_lvds_spw_lvds_p_data_out_signal                      : out   std_logic; --                         -- spw_lvds_p_data_out_signal
            spwc_f_lvds_spw_lvds_n_data_out_signal                      : out   std_logic; --                         -- spw_lvds_n_data_out_signal
            spwc_f_lvds_spw_lvds_p_strobe_out_signal                    : out   std_logic; --                         -- spw_lvds_p_strobe_out_signal
            spwc_f_lvds_spw_lvds_n_strobe_out_signal                    : out   std_logic; --                         -- spw_lvds_n_strobe_out_signal
            --
            spwc_g_lvds_spw_lvds_p_data_in_signal                       : in    std_logic                     := 'X'; -- spw_lvds_p_data_in_signal
            spwc_g_lvds_spw_lvds_n_data_in_signal                       : in    std_logic                     := 'X'; -- spw_lvds_n_data_in_signal
            spwc_g_lvds_spw_lvds_p_strobe_in_signal                     : in    std_logic                     := 'X'; -- spw_lvds_p_strobe_in_signal
            spwc_g_lvds_spw_lvds_n_strobe_in_signal                     : in    std_logic                     := 'X'; -- spw_lvds_n_strobe_in_signal
            spwc_g_lvds_spw_lvds_p_data_out_signal                      : out   std_logic; --                         -- spw_lvds_p_data_out_signal
            spwc_g_lvds_spw_lvds_n_data_out_signal                      : out   std_logic; --                         -- spw_lvds_n_data_out_signal
            spwc_g_lvds_spw_lvds_p_strobe_out_signal                    : out   std_logic; --                         -- spw_lvds_p_strobe_out_signal
            spwc_g_lvds_spw_lvds_n_strobe_out_signal                    : out   std_logic; --                         -- spw_lvds_n_strobe_out_signal
            --
            spwc_h_lvds_spw_lvds_p_data_in_signal                       : in    std_logic                     := 'X'; -- spw_lvds_p_data_in_signal
            spwc_h_lvds_spw_lvds_n_data_in_signal                       : in    std_logic                     := 'X'; -- spw_lvds_n_data_in_signal
            spwc_h_lvds_spw_lvds_p_strobe_in_signal                     : in    std_logic                     := 'X'; -- spw_lvds_p_strobe_in_signal
            spwc_h_lvds_spw_lvds_n_strobe_in_signal                     : in    std_logic                     := 'X'; -- spw_lvds_n_strobe_in_signal
            spwc_h_lvds_spw_lvds_p_data_out_signal                      : out   std_logic; --                         -- spw_lvds_p_data_out_signal
            spwc_h_lvds_spw_lvds_n_data_out_signal                      : out   std_logic; --                         -- spw_lvds_n_data_out_signal
            spwc_h_lvds_spw_lvds_p_strobe_out_signal                    : out   std_logic; --                         -- spw_lvds_p_strobe_out_signal
            spwc_h_lvds_spw_lvds_n_strobe_out_signal                    : out   std_logic; --                         -- spw_lvds_n_strobe_out_signal
            --
            spwc_a_leds_spw_red_status_led_signal                       : out   std_logic; --                         -- spw_red_status_led_signal
            spwc_a_leds_spw_green_status_led_signal                     : out   std_logic; --                         -- spw_green_status_led_signal
            --
            spwc_b_leds_spw_red_status_led_signal                       : out   std_logic; --                         -- spw_red_status_led_signal
            spwc_b_leds_spw_green_status_led_signal                     : out   std_logic; --                         -- spw_green_status_led_signal
            --
            spwc_c_leds_spw_red_status_led_signal                       : out   std_logic; --                         -- spw_red_status_led_signal
            spwc_c_leds_spw_green_status_led_signal                     : out   std_logic; --                         -- spw_green_status_led_signal
            --
            spwc_d_leds_spw_red_status_led_signal                       : out   std_logic; --                         -- spw_red_status_led_signal
            spwc_d_leds_spw_green_status_led_signal                     : out   std_logic; --                         -- spw_green_status_led_signal
            --
            spwc_e_leds_spw_red_status_led_signal                       : out   std_logic; --                         -- spw_red_status_led_signal
            spwc_e_leds_spw_green_status_led_signal                     : out   std_logic; --                         -- spw_green_status_led_signal
            --
            spwc_f_leds_spw_red_status_led_signal                       : out   std_logic; --                         -- spw_red_status_led_signal
            spwc_f_leds_spw_green_status_led_signal                     : out   std_logic; --                         -- spw_green_status_led_signal
            --
            spwc_g_leds_spw_red_status_led_signal                       : out   std_logic; --                         -- spw_red_status_led_signal
            spwc_g_leds_spw_green_status_led_signal                     : out   std_logic; --                         -- spw_green_status_led_signal
            --
            spwc_h_leds_spw_red_status_led_signal                       : out   std_logic; --                         -- spw_red_status_led_signal
            spwc_h_leds_spw_green_status_led_signal                     : out   std_logic; --                         -- spw_green_status_led_signal
            --
            spwc_a_enable_spw_rx_enable_signal                          : in    std_logic                     := '0'; -- spw_rx_enable_signal
            spwc_a_enable_spw_tx_enable_signal                          : in    std_logic                     := '0'; -- spw_tx_enable_signal
            spwc_b_enable_spw_rx_enable_signal                          : in    std_logic                     := '0'; -- spw_rx_enable_signal
            spwc_b_enable_spw_tx_enable_signal                          : in    std_logic                     := '0'; -- spw_tx_enable_signal
            spwc_c_enable_spw_rx_enable_signal                          : in    std_logic                     := '0'; -- spw_rx_enable_signal
            spwc_c_enable_spw_tx_enable_signal                          : in    std_logic                     := '0'; -- spw_tx_enable_signal
            spwc_d_enable_spw_rx_enable_signal                          : in    std_logic                     := '0'; -- spw_rx_enable_signal
            spwc_d_enable_spw_tx_enable_signal                          : in    std_logic                     := '0'; -- spw_tx_enable_signal
            spwc_e_enable_spw_rx_enable_signal                          : in    std_logic                     := '0'; -- spw_rx_enable_signal
            spwc_e_enable_spw_tx_enable_signal                          : in    std_logic                     := '0'; -- spw_tx_enable_signal
            spwc_f_enable_spw_rx_enable_signal                          : in    std_logic                     := '0'; -- spw_rx_enable_signal
            spwc_f_enable_spw_tx_enable_signal                          : in    std_logic                     := '0'; -- spw_tx_enable_signal
            spwc_g_enable_spw_rx_enable_signal                          : in    std_logic                     := '0'; -- spw_rx_enable_signal
            spwc_g_enable_spw_tx_enable_signal                          : in    std_logic                     := '0'; -- spw_tx_enable_signal
            spwc_h_enable_spw_rx_enable_signal                          : in    std_logic                     := '0'; -- spw_rx_enable_signal
            spwc_h_enable_spw_tx_enable_signal                          : in    std_logic                     := '0' --- spw_tx_enable_signal
            --

        );
    end component MebX_Qsys_Project;

    component pll_125
        port(
            inclk0 : in  std_logic := '0';
            c0     : out std_logic
        );
    end component;

    ------------------------------------------------------------
begin

    --==========--
    -- AVALON
    --==========--
    SOPC_INST : MebX_Qsys_Project
        port map(
            clk50_clk                                                   => OSC_50_Bank4,
            --
            rst_reset_n                                                 => rst_n,
            --
            spwc_a_lvds_spw_lvds_p_data_in_signal                       => HSMB_LVDS_RX_SPWA_DI_P, --                        spwc_a_lvds.spw_lvds_p_data_in_signal
            spwc_a_lvds_spw_lvds_n_data_in_signal                       => HSMB_LVDS_RX_SPWA_DI_N, --                                   .spw_lvds_n_data_in_signal
            spwc_a_lvds_spw_lvds_p_strobe_in_signal                     => HSMB_LVDS_RX_SPWA_SI_P, --                                   .spw_lvds_p_strobe_in_signal
            spwc_a_lvds_spw_lvds_n_strobe_in_signal                     => HSMB_LVDS_RX_SPWA_SI_N, --                                   .spw_lvds_n_strobe_in_signal
            spwc_a_lvds_spw_lvds_p_data_out_signal                      => HSMB_LVDS_TX_SPWA_DO_P, --                                   .spw_lvds_p_data_out_signal
            spwc_a_lvds_spw_lvds_n_data_out_signal                      => HSMB_LVDS_TX_SPWA_DO_N, --                                   .spw_lvds_n_data_out_signal
            spwc_a_lvds_spw_lvds_p_strobe_out_signal                    => HSMB_LVDS_TX_SPWA_SO_P, --                                   .spw_lvds_p_strobe_out_signal
            spwc_a_lvds_spw_lvds_n_strobe_out_signal                    => HSMB_LVDS_TX_SPWA_SO_N, --                                   .spw_lvds_n_strobe_out_signal
            --
            spwc_b_lvds_spw_lvds_p_data_in_signal                       => HSMB_LVDS_RX_SPWB_DI_P, --                        spwc_b_lvds.spw_lvds_p_data_in_signal
            spwc_b_lvds_spw_lvds_n_data_in_signal                       => HSMB_LVDS_RX_SPWB_DI_N, --                                   .spw_lvds_n_data_in_signal
            spwc_b_lvds_spw_lvds_p_strobe_in_signal                     => HSMB_LVDS_RX_SPWB_SI_P, --                                   .spw_lvds_p_strobe_in_signal
            spwc_b_lvds_spw_lvds_n_strobe_in_signal                     => HSMB_LVDS_RX_SPWB_SI_N, --                                   .spw_lvds_n_strobe_in_signal
            spwc_b_lvds_spw_lvds_p_data_out_signal                      => HSMB_LVDS_TX_SPWB_DO_P, --                                   .spw_lvds_p_data_out_signal
            spwc_b_lvds_spw_lvds_n_data_out_signal                      => HSMB_LVDS_TX_SPWB_DO_N, --                                   .spw_lvds_n_data_out_signal
            spwc_b_lvds_spw_lvds_p_strobe_out_signal                    => HSMB_LVDS_TX_SPWB_SO_P, --                                   .spw_lvds_p_strobe_out_signal
            spwc_b_lvds_spw_lvds_n_strobe_out_signal                    => HSMB_LVDS_TX_SPWB_SO_N, --                                   .spw_lvds_n_strobe_out_signal
            --
            spwc_c_lvds_spw_lvds_p_data_in_signal                       => HSMB_LVDS_RX_SPWC_DI_P, --                        spwc_c_lvds.spw_lvds_p_data_in_signal
            spwc_c_lvds_spw_lvds_n_data_in_signal                       => HSMB_LVDS_RX_SPWC_DI_N, --                                   .spw_lvds_n_data_in_signal
            spwc_c_lvds_spw_lvds_p_strobe_in_signal                     => HSMB_LVDS_RX_SPWC_SI_P, --                                   .spw_lvds_p_strobe_in_signal
            spwc_c_lvds_spw_lvds_n_strobe_in_signal                     => HSMB_LVDS_RX_SPWC_SI_N, --                                   .spw_lvds_n_strobe_in_signal
            spwc_c_lvds_spw_lvds_p_data_out_signal                      => HSMB_LVDS_TX_SPWC_DO_P, --                                   .spw_lvds_p_data_out_signal
            spwc_c_lvds_spw_lvds_n_data_out_signal                      => HSMB_LVDS_TX_SPWC_DO_N, --                                   .spw_lvds_n_data_out_signal
            spwc_c_lvds_spw_lvds_p_strobe_out_signal                    => HSMB_LVDS_TX_SPWC_SO_P, --                                   .spw_lvds_p_strobe_out_signal
            spwc_c_lvds_spw_lvds_n_strobe_out_signal                    => HSMB_LVDS_TX_SPWC_SO_N, --                                   .spw_lvds_n_strobe_out_signal
            --
            spwc_d_lvds_spw_lvds_p_data_in_signal                       => HSMB_LVDS_RX_SPWD_DI_P, --                        spwc_d_lvds.spw_lvds_p_data_in_signal
            spwc_d_lvds_spw_lvds_n_data_in_signal                       => HSMB_LVDS_RX_SPWD_DI_N, --                                   .spw_lvds_n_data_in_signal
            spwc_d_lvds_spw_lvds_p_strobe_in_signal                     => HSMB_LVDS_RX_SPWD_SI_P, --                                   .spw_lvds_p_strobe_in_signal
            spwc_d_lvds_spw_lvds_n_strobe_in_signal                     => HSMB_LVDS_RX_SPWD_SI_N, --                                   .spw_lvds_n_strobe_in_signal
            spwc_d_lvds_spw_lvds_p_data_out_signal                      => HSMB_LVDS_TX_SPWD_DO_P, --                                   .spw_lvds_p_data_out_signal
            spwc_d_lvds_spw_lvds_n_data_out_signal                      => HSMB_LVDS_TX_SPWD_DO_N, --                                   .spw_lvds_n_data_out_signal
            spwc_d_lvds_spw_lvds_p_strobe_out_signal                    => HSMB_LVDS_TX_SPWD_SO_P, --                                   .spw_lvds_p_strobe_out_signal
            spwc_d_lvds_spw_lvds_n_strobe_out_signal                    => HSMB_LVDS_TX_SPWD_SO_N, --                                   .spw_lvds_n_strobe_out_signal
            --
            spwc_e_lvds_spw_lvds_p_data_in_signal                       => HSMB_LVDS_RX_SPWE_DI_P, --                        spwc_e_lvds.spw_lvds_p_data_in_signal
            spwc_e_lvds_spw_lvds_n_data_in_signal                       => HSMB_LVDS_RX_SPWE_DI_N, --                                   .spw_lvds_n_data_in_signal
            spwc_e_lvds_spw_lvds_p_strobe_in_signal                     => HSMB_LVDS_RX_SPWE_SI_P, --                                   .spw_lvds_p_strobe_in_signal
            spwc_e_lvds_spw_lvds_n_strobe_in_signal                     => HSMB_LVDS_RX_SPWE_SI_N, --                                   .spw_lvds_n_strobe_in_signal
            spwc_e_lvds_spw_lvds_p_data_out_signal                      => HSMB_LVDS_TX_SPWE_DO_P, --                                   .spw_lvds_p_data_out_signal
            spwc_e_lvds_spw_lvds_n_data_out_signal                      => HSMB_LVDS_TX_SPWE_DO_N, --                                   .spw_lvds_n_data_out_signal
            spwc_e_lvds_spw_lvds_p_strobe_out_signal                    => HSMB_LVDS_TX_SPWE_SO_P, --                                   .spw_lvds_p_strobe_out_signal
            spwc_e_lvds_spw_lvds_n_strobe_out_signal                    => HSMB_LVDS_TX_SPWE_SO_N, --                                   .spw_lvds_n_strobe_out_signal
            --
            spwc_f_lvds_spw_lvds_p_data_in_signal                       => HSMB_LVDS_RX_SPWF_DI_P, --                        spwc_f_lvds.spw_lvds_p_data_in_signal
            spwc_f_lvds_spw_lvds_n_data_in_signal                       => HSMB_LVDS_RX_SPWF_DI_N, --                                   .spw_lvds_n_data_in_signal
            spwc_f_lvds_spw_lvds_p_strobe_in_signal                     => HSMB_LVDS_RX_SPWF_SI_P, --                                   .spw_lvds_p_strobe_in_signal
            spwc_f_lvds_spw_lvds_n_strobe_in_signal                     => HSMB_LVDS_RX_SPWF_SI_N, --                                   .spw_lvds_n_strobe_in_signal
            spwc_f_lvds_spw_lvds_p_data_out_signal                      => HSMB_LVDS_TX_SPWF_DO_P, --                                   .spw_lvds_p_data_out_signal
            spwc_f_lvds_spw_lvds_n_data_out_signal                      => HSMB_LVDS_TX_SPWF_DO_N, --                                   .spw_lvds_n_data_out_signal
            spwc_f_lvds_spw_lvds_p_strobe_out_signal                    => HSMB_LVDS_TX_SPWF_SO_P, --                                   .spw_lvds_p_strobe_out_signal
            spwc_f_lvds_spw_lvds_n_strobe_out_signal                    => HSMB_LVDS_TX_SPWF_SO_N, --                                   .spw_lvds_n_strobe_out_signal
            --
            spwc_g_lvds_spw_lvds_p_data_in_signal                       => HSMB_LVDS_RX_SPWG_DI_P, --                        spwc_g_lvds.spw_lvds_p_data_in_signal
            spwc_g_lvds_spw_lvds_n_data_in_signal                       => HSMB_LVDS_RX_SPWG_DI_N, --                                   .spw_lvds_n_data_in_signal
            spwc_g_lvds_spw_lvds_p_strobe_in_signal                     => HSMB_LVDS_RX_SPWG_SI_P, --                                   .spw_lvds_p_strobe_in_signal
            spwc_g_lvds_spw_lvds_n_strobe_in_signal                     => HSMB_LVDS_RX_SPWG_SI_N, --                                   .spw_lvds_n_strobe_in_signal
            spwc_g_lvds_spw_lvds_p_data_out_signal                      => HSMB_LVDS_TX_SPWG_DO_P, --                                   .spw_lvds_p_data_out_signal
            spwc_g_lvds_spw_lvds_n_data_out_signal                      => HSMB_LVDS_TX_SPWG_DO_N, --                                   .spw_lvds_n_data_out_signal
            spwc_g_lvds_spw_lvds_p_strobe_out_signal                    => HSMB_LVDS_TX_SPWG_SO_P, --                                   .spw_lvds_p_strobe_out_signal
            spwc_g_lvds_spw_lvds_n_strobe_out_signal                    => HSMB_LVDS_TX_SPWG_SO_N, --                                   .spw_lvds_n_strobe_out_signal
            --
            spwc_h_lvds_spw_lvds_p_data_in_signal                       => HSMB_LVDS_RX_SPWH_DI_P, --                        spwc_h_lvds.spw_lvds_p_data_in_signal
            spwc_h_lvds_spw_lvds_n_data_in_signal                       => HSMB_LVDS_RX_SPWH_DI_N, --                                   .spw_lvds_n_data_in_signal
            spwc_h_lvds_spw_lvds_p_strobe_in_signal                     => HSMB_LVDS_RX_SPWH_SI_P, --                                   .spw_lvds_p_strobe_in_signal
            spwc_h_lvds_spw_lvds_n_strobe_in_signal                     => HSMB_LVDS_RX_SPWH_SI_N, --                                   .spw_lvds_n_strobe_in_signal
            spwc_h_lvds_spw_lvds_p_data_out_signal                      => HSMB_LVDS_TX_SPWH_DO_P, --                                   .spw_lvds_p_data_out_signal
            spwc_h_lvds_spw_lvds_n_data_out_signal                      => HSMB_LVDS_TX_SPWH_DO_N, --                                   .spw_lvds_n_data_out_signal
            spwc_h_lvds_spw_lvds_p_strobe_out_signal                    => HSMB_LVDS_TX_SPWH_SO_P, --                                   .spw_lvds_p_strobe_out_signal
            spwc_h_lvds_spw_lvds_n_strobe_out_signal                    => HSMB_LVDS_TX_SPWH_SO_N, --                                   .spw_lvds_n_strobe_out_signal
            --
            spwc_a_leds_spw_red_status_led_signal                       => spw_a_red_led, --       --                        spwc_a_leds.spw_red_status_led_signal
            spwc_a_leds_spw_green_status_led_signal                     => spw_a_green_led, --     --                                   .spw_green_status_led_signal
            --
            spwc_b_leds_spw_red_status_led_signal                       => spw_b_red_led, --       --                        spwc_b_leds.spw_red_status_led_signal
            spwc_b_leds_spw_green_status_led_signal                     => spw_b_green_led, --     --                                   .spw_green_status_led_signal
            --
            spwc_c_leds_spw_red_status_led_signal                       => spw_c_red_led, --       --                        spwc_c_leds.spw_red_status_led_signal
            spwc_c_leds_spw_green_status_led_signal                     => spw_c_green_led, --     --                                   .spw_green_status_led_signal
            --
            spwc_d_leds_spw_red_status_led_signal                       => spw_d_red_led, --       --                        spwc_d_leds.spw_red_status_led_signal
            spwc_d_leds_spw_green_status_led_signal                     => spw_d_green_led, --     --                                   .spw_green_status_led_signal
            --
            spwc_e_leds_spw_red_status_led_signal                       => spw_e_red_led, --       --                        spwc_e_leds.spw_red_status_led_signal
            spwc_e_leds_spw_green_status_led_signal                     => spw_e_green_led, --     --                                   .spw_green_status_led_signal
            --
            spwc_f_leds_spw_red_status_led_signal                       => spw_f_red_led, --       --                        spwc_f_leds.spw_red_status_led_signal
            spwc_f_leds_spw_green_status_led_signal                     => spw_f_green_led, --     --                                   .spw_green_status_led_signal
            --
            spwc_g_leds_spw_red_status_led_signal                       => spw_g_red_led, --       --                        spwc_g_leds.spw_red_status_led_signal
            spwc_g_leds_spw_green_status_led_signal                     => spw_g_green_led, --     --                                   .spw_green_status_led_signal
            --
            spwc_h_leds_spw_red_status_led_signal                       => spw_h_red_led, --       --                        spwc_h_leds.spw_red_status_led_signal
            spwc_h_leds_spw_green_status_led_signal                     => spw_h_green_led, --     --                                   .spw_green_status_led_signal
            --
            spwc_a_enable_spw_rx_enable_signal                          => iso_logic_enable, ----                      spwc_a_enable.spw_rx_enable_signal
            spwc_a_enable_spw_tx_enable_signal                          => iso_logic_enable, ----                                   .spw_tx_enable_signal
            spwc_b_enable_spw_rx_enable_signal                          => iso_logic_enable, ----                      spwc_b_enable.spw_rx_enable_signal
            spwc_b_enable_spw_tx_enable_signal                          => iso_logic_enable, ----                                   .spw_tx_enable_signal
            spwc_c_enable_spw_rx_enable_signal                          => iso_logic_enable, ----                      spwc_c_enable.spw_rx_enable_signal
            spwc_c_enable_spw_tx_enable_signal                          => iso_logic_enable, ----                                   .spw_tx_enable_signal
            spwc_d_enable_spw_rx_enable_signal                          => iso_logic_enable, ----                      spwc_d_enable.spw_rx_enable_signal
            spwc_d_enable_spw_tx_enable_signal                          => iso_logic_enable, ----                                   .spw_tx_enable_signal
            spwc_e_enable_spw_rx_enable_signal                          => iso_logic_enable, ----                      spwc_e_enable.spw_rx_enable_signal
            spwc_e_enable_spw_tx_enable_signal                          => iso_logic_enable, ----                                   .spw_tx_enable_signal
            spwc_f_enable_spw_rx_enable_signal                          => iso_logic_enable, ----                      spwc_f_enable.spw_rx_enable_signal
            spwc_f_enable_spw_tx_enable_signal                          => iso_logic_enable, ----                                   .spw_tx_enable_signal            
            spwc_g_enable_spw_rx_enable_signal                          => iso_logic_enable, ----                      spwc_g_enable.spw_rx_enable_signal
            spwc_g_enable_spw_tx_enable_signal                          => iso_logic_enable, ----                                   .spw_tx_enable_signal            
            spwc_h_enable_spw_rx_enable_signal                          => iso_logic_enable, ----                      spwc_h_enable.spw_rx_enable_signal
            spwc_h_enable_spw_tx_enable_signal                          => iso_logic_enable -----                                   .spw_tx_enable_signal
            --
        );

    --==========--
    -- rst
    --==========--

    rst_ctrl_input <= not (CPU_RESET_n and RESET_PAINEL_n);
    --rst_n          <= not (simucam_rst);
	 rst_n          <= not (rst_ctrl_input);

    --==========--
    -- I/Os
    --==========--    

    -- Ativa ventoinha
    FAN_CTRL <= '1';

    -- LEDs assumem estado diferente no rst.

    LED_DE4(0) <= ('1') when (rst_n = '0') else (leds_b(0));
    LED_DE4(1) <= ('1') when (rst_n = '0') else (leds_b(1));
    LED_DE4(2) <= ('1') when (rst_n = '0') else (leds_b(2));
    LED_DE4(3) <= ('1') when (rst_n = '0') else (leds_b(3));
    LED_DE4(4) <= ('1') when (rst_n = '0') else (leds_b(4));
    LED_DE4(5) <= ('1') when (rst_n = '0') else (leds_b(5));
    LED_DE4(6) <= ('1') when (rst_n = '0') else (leds_b(6));
    LED_DE4(7) <= ('1') when (rst_n = '0') else (leds_b(7));

    LED_PAINEL_LED_1G    <= ('1') when (rst_n = '0') else (leds_p(0) or spw_a_green_led);
    LED_PAINEL_LED_1R    <= ('1') when (rst_n = '0') else (leds_p(1) or spw_a_red_led);
    LED_PAINEL_LED_2G    <= ('1') when (rst_n = '0') else (leds_p(2) or spw_b_green_led);
    LED_PAINEL_LED_2R    <= ('1') when (rst_n = '0') else (leds_p(3) or spw_b_red_led);
    LED_PAINEL_LED_3G    <= ('1') when (rst_n = '0') else (leds_p(4) or spw_c_green_led);
    LED_PAINEL_LED_3R    <= ('1') when (rst_n = '0') else (leds_p(5) or spw_c_red_led);
    LED_PAINEL_LED_4G    <= ('1') when (rst_n = '0') else (leds_p(6) or spw_d_green_led);
    LED_PAINEL_LED_4R    <= ('1') when (rst_n = '0') else (leds_p(7) or spw_d_red_led);
    LED_PAINEL_LED_5G    <= ('1') when (rst_n = '0') else (leds_p(8) or spw_e_green_led);
    LED_PAINEL_LED_5R    <= ('1') when (rst_n = '0') else (leds_p(9) or spw_e_red_led);
    LED_PAINEL_LED_6G    <= ('1') when (rst_n = '0') else (leds_p(10) or spw_f_green_led);
    LED_PAINEL_LED_6R    <= ('1') when (rst_n = '0') else (leds_p(11) or spw_f_red_led);
    LED_PAINEL_LED_7G    <= ('1') when (rst_n = '0') else (leds_p(12) or spw_g_green_led);
    LED_PAINEL_LED_7R    <= ('1') when (rst_n = '0') else (leds_p(13) or spw_g_red_led);
    LED_PAINEL_LED_8G    <= ('1') when (rst_n = '0') else (leds_p(14) or spw_h_green_led);
    LED_PAINEL_LED_8R    <= ('1') when (rst_n = '0') else (leds_p(15) or spw_h_red_led);
    LED_PAINEL_LED_POWER <= ('1') when (rst_n = '0') else (leds_p(16));
    LED_PAINEL_LED_ST1   <= ('1') when (rst_n = '0') else (leds_p(17));
    LED_PAINEL_LED_ST2   <= ('1') when (rst_n = '0') else (leds_p(18));
    LED_PAINEL_LED_ST3   <= ('1') when (rst_n = '0') else (leds_p(19));
    LED_PAINEL_LED_ST4   <= ('1') when (rst_n = '0') else (leds_p(20));

    --==========--
    -- LVDS Drivers control
    --==========--

    -- Comando foi passado para modulo ctrl_io_lvds, via Qsys/Nios
    --	HSMB_BUFFER_PWDN_N	<= '1';
    --	HSMB_BUFFER_PEM0	<= '0';
    --	HSMB_BUFFER_PEM1	<= '0';
    --	EN_ISO_DRIVERS		<= '0';
	
	iso_logic_enable <= '1';
	
	a_enable_iso_drivers         <= '1';
	a_hsmb_buffers_powerdown_n   <= '1';
	a_hsmb_buffers_preemphasis_1 <= '0';
	a_hsmb_buffers_preemphasis_0 <= '0';

    EN_ISO_DRIVERS     <= a_enable_iso_drivers;
    HSMB_BUFFER_PWDN_N <= a_hsmb_buffers_powerdown_n;
    HSMB_BUFFER_PEM1   <= a_hsmb_buffers_preemphasis_1;
    HSMB_BUFFER_PEM0   <= a_hsmb_buffers_preemphasis_0;

end bhv;
