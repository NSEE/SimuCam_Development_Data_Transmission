library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_top is
end entity testbench_top;

architecture RTL of testbench_top is

    -- clk and rst signals
    signal clk100 : std_logic := '0';
    signal rst    : std_logic := '1';

    -- dut signals
    signal s_tb_ch1_wr_wrdata_flag_o : std_logic;
    signal s_tb_ch1_wr_wrdata_data_o : std_logic_vector(7 downto 0);
    signal s_tb_ch1_wr_wrreq_o       : std_logic;
    signal s_tb_ch1_rd_wrdata_flag_o : std_logic;
    signal s_tb_ch1_rd_wrdata_data_o : std_logic_vector(7 downto 0);
    signal s_tb_ch1_rd_wrreq_o       : std_logic;
    signal s_tb_ch2_wr_wrdata_flag_o : std_logic;
    signal s_tb_ch2_wr_wrdata_data_o : std_logic_vector(7 downto 0);
    signal s_tb_ch2_wr_wrreq_o       : std_logic;
    signal s_tb_ch2_rd_wrdata_flag_o : std_logic;
    signal s_tb_ch2_rd_wrdata_data_o : std_logic_vector(7 downto 0);
    signal s_tb_ch2_rd_wrreq_o       : std_logic;
    signal s_tb_ch3_wr_wrdata_flag_o : std_logic;
    signal s_tb_ch3_wr_wrdata_data_o : std_logic_vector(7 downto 0);
    signal s_tb_ch3_wr_wrreq_o       : std_logic;
    signal s_tb_ch3_rd_wrdata_flag_o : std_logic;
    signal s_tb_ch3_rd_wrdata_data_o : std_logic_vector(7 downto 0);
    signal s_tb_ch3_rd_wrreq_o       : std_logic;
    signal s_tb_ch4_wr_wrdata_flag_o : std_logic;
    signal s_tb_ch4_wr_wrdata_data_o : std_logic_vector(7 downto 0);
    signal s_tb_ch4_wr_wrreq_o       : std_logic;
    signal s_tb_ch4_rd_wrdata_flag_o : std_logic;
    signal s_tb_ch4_rd_wrdata_data_o : std_logic_vector(7 downto 0);
    signal s_tb_ch4_rd_wrreq_o       : std_logic;
    signal s_tb_ch5_wr_wrdata_flag_o : std_logic;
    signal s_tb_ch5_wr_wrdata_data_o : std_logic_vector(7 downto 0);
    signal s_tb_ch5_wr_wrreq_o       : std_logic;
    signal s_tb_ch5_rd_wrdata_flag_o : std_logic;
    signal s_tb_ch5_rd_wrdata_data_o : std_logic_vector(7 downto 0);
    signal s_tb_ch5_rd_wrreq_o       : std_logic;
    signal s_tb_ch6_wr_wrdata_flag_o : std_logic;
    signal s_tb_ch6_wr_wrdata_data_o : std_logic_vector(7 downto 0);
    signal s_tb_ch6_wr_wrreq_o       : std_logic;
    signal s_tb_ch6_rd_wrdata_flag_o : std_logic;
    signal s_tb_ch6_rd_wrdata_data_o : std_logic_vector(7 downto 0);
    signal s_tb_ch6_rd_wrreq_o       : std_logic;
    signal s_tb_ch7_wr_wrdata_flag_o : std_logic;
    signal s_tb_ch7_wr_wrdata_data_o : std_logic_vector(7 downto 0);
    signal s_tb_ch7_wr_wrreq_o       : std_logic;
    signal s_tb_ch7_rd_wrdata_flag_o : std_logic;
    signal s_tb_ch7_rd_wrdata_data_o : std_logic_vector(7 downto 0);
    signal s_tb_ch7_rd_wrreq_o       : std_logic;

    signal s_tb_echo_enable : std_logic := '1';

    constant c_ECHO_ID_ENABLE : std_logic := '1';

begin

    clk100 <= not clk100 after 5 ns;    -- 100 MHz
    rst    <= '0' after 100 ns;

    rmap_fifo_stimuli_inst : entity work.rmap_fifo_stimuli
        port map(
            clk_i                          => clk100,
            rst_i                          => rst,
            rmap_ch1_wr_fifo_wrdata_flag_o => s_tb_ch1_wr_wrdata_flag_o,
            rmap_ch1_wr_fifo_wrdata_data_o => s_tb_ch1_wr_wrdata_data_o,
            rmap_ch1_wr_fifo_wrreq_o       => s_tb_ch1_wr_wrreq_o,
            rmap_ch1_rd_fifo_wrdata_flag_o => s_tb_ch1_rd_wrdata_flag_o,
            rmap_ch1_rd_fifo_wrdata_data_o => s_tb_ch1_rd_wrdata_data_o,
            rmap_ch1_rd_fifo_wrreq_o       => s_tb_ch1_rd_wrreq_o,
            rmap_ch2_wr_fifo_wrdata_flag_o => s_tb_ch2_wr_wrdata_flag_o,
            rmap_ch2_wr_fifo_wrdata_data_o => s_tb_ch2_wr_wrdata_data_o,
            rmap_ch2_wr_fifo_wrreq_o       => s_tb_ch2_wr_wrreq_o,
            rmap_ch2_rd_fifo_wrdata_flag_o => s_tb_ch2_rd_wrdata_flag_o,
            rmap_ch2_rd_fifo_wrdata_data_o => s_tb_ch2_rd_wrdata_data_o,
            rmap_ch2_rd_fifo_wrreq_o       => s_tb_ch2_rd_wrreq_o,
            rmap_ch3_wr_fifo_wrdata_flag_o => s_tb_ch3_wr_wrdata_flag_o,
            rmap_ch3_wr_fifo_wrdata_data_o => s_tb_ch3_wr_wrdata_data_o,
            rmap_ch3_wr_fifo_wrreq_o       => s_tb_ch3_wr_wrreq_o,
            rmap_ch3_rd_fifo_wrdata_flag_o => s_tb_ch3_rd_wrdata_flag_o,
            rmap_ch3_rd_fifo_wrdata_data_o => s_tb_ch3_rd_wrdata_data_o,
            rmap_ch3_rd_fifo_wrreq_o       => s_tb_ch3_rd_wrreq_o,
            rmap_ch4_wr_fifo_wrdata_flag_o => s_tb_ch4_wr_wrdata_flag_o,
            rmap_ch4_wr_fifo_wrdata_data_o => s_tb_ch4_wr_wrdata_data_o,
            rmap_ch4_wr_fifo_wrreq_o       => s_tb_ch4_wr_wrreq_o,
            rmap_ch4_rd_fifo_wrdata_flag_o => s_tb_ch4_rd_wrdata_flag_o,
            rmap_ch4_rd_fifo_wrdata_data_o => s_tb_ch4_rd_wrdata_data_o,
            rmap_ch4_rd_fifo_wrreq_o       => s_tb_ch4_rd_wrreq_o,
            rmap_ch5_wr_fifo_wrdata_flag_o => s_tb_ch5_wr_wrdata_flag_o,
            rmap_ch5_wr_fifo_wrdata_data_o => s_tb_ch5_wr_wrdata_data_o,
            rmap_ch5_wr_fifo_wrreq_o       => s_tb_ch5_wr_wrreq_o,
            rmap_ch5_rd_fifo_wrdata_flag_o => s_tb_ch5_rd_wrdata_flag_o,
            rmap_ch5_rd_fifo_wrdata_data_o => s_tb_ch5_rd_wrdata_data_o,
            rmap_ch5_rd_fifo_wrreq_o       => s_tb_ch5_rd_wrreq_o,
            rmap_ch6_wr_fifo_wrdata_flag_o => s_tb_ch6_wr_wrdata_flag_o,
            rmap_ch6_wr_fifo_wrdata_data_o => s_tb_ch6_wr_wrdata_data_o,
            rmap_ch6_wr_fifo_wrreq_o       => s_tb_ch6_wr_wrreq_o,
            rmap_ch6_rd_fifo_wrdata_flag_o => s_tb_ch6_rd_wrdata_flag_o,
            rmap_ch6_rd_fifo_wrdata_data_o => s_tb_ch6_rd_wrdata_data_o,
            rmap_ch6_rd_fifo_wrreq_o       => s_tb_ch6_rd_wrreq_o,
            rmap_ch7_wr_fifo_wrdata_flag_o => s_tb_ch7_wr_wrdata_flag_o,
            rmap_ch7_wr_fifo_wrdata_data_o => s_tb_ch7_wr_wrdata_data_o,
            rmap_ch7_wr_fifo_wrreq_o       => s_tb_ch7_wr_wrreq_o,
            rmap_ch7_rd_fifo_wrdata_flag_o => s_tb_ch7_rd_wrdata_flag_o,
            rmap_ch7_rd_fifo_wrdata_data_o => s_tb_ch7_rd_wrdata_data_o,
            rmap_ch7_rd_fifo_wrreq_o       => s_tb_ch7_rd_wrreq_o
        );

    rmpe_rmap_echoing_top_inst : entity work.rmpe_rmap_echoing_top
        port map(
            reset_i                       => rst,
            clk_100_i                     => clk100,
            rmap_echo_0_echo_en_i         => s_tb_echo_enable,
            rmap_echo_0_echo_id_en_i      => c_ECHO_ID_ENABLE,
            rmap_echo_0_in_fifo_wrflag_i  => s_tb_ch1_wr_wrdata_flag_o,
            rmap_echo_0_in_fifo_wrdata_i  => s_tb_ch1_wr_wrdata_data_o,
            rmap_echo_0_in_fifo_wrreq_i   => s_tb_ch1_wr_wrreq_o,
            rmap_echo_0_out_fifo_wrflag_i => s_tb_ch1_rd_wrdata_flag_o,
            rmap_echo_0_out_fifo_wrdata_i => s_tb_ch1_rd_wrdata_data_o,
            rmap_echo_0_out_fifo_wrreq_i  => s_tb_ch1_rd_wrreq_o,
            rmap_echo_1_echo_en_i         => s_tb_echo_enable,
            rmap_echo_1_echo_id_en_i      => c_ECHO_ID_ENABLE,
            rmap_echo_1_in_fifo_wrflag_i  => s_tb_ch2_wr_wrdata_flag_o,
            rmap_echo_1_in_fifo_wrdata_i  => s_tb_ch2_wr_wrdata_data_o,
            rmap_echo_1_in_fifo_wrreq_i   => s_tb_ch2_wr_wrreq_o,
            rmap_echo_1_out_fifo_wrflag_i => s_tb_ch2_rd_wrdata_flag_o,
            rmap_echo_1_out_fifo_wrdata_i => s_tb_ch2_rd_wrdata_data_o,
            rmap_echo_1_out_fifo_wrreq_i  => s_tb_ch2_rd_wrreq_o,
            rmap_echo_2_echo_en_i         => s_tb_echo_enable,
            rmap_echo_2_echo_id_en_i      => c_ECHO_ID_ENABLE,
            rmap_echo_2_in_fifo_wrflag_i  => s_tb_ch3_wr_wrdata_flag_o,
            rmap_echo_2_in_fifo_wrdata_i  => s_tb_ch3_wr_wrdata_data_o,
            rmap_echo_2_in_fifo_wrreq_i   => s_tb_ch3_wr_wrreq_o,
            rmap_echo_2_out_fifo_wrflag_i => s_tb_ch3_rd_wrdata_flag_o,
            rmap_echo_2_out_fifo_wrdata_i => s_tb_ch3_rd_wrdata_data_o,
            rmap_echo_2_out_fifo_wrreq_i  => s_tb_ch3_rd_wrreq_o,
            rmap_echo_3_echo_en_i         => s_tb_echo_enable,
            rmap_echo_3_echo_id_en_i      => c_ECHO_ID_ENABLE,
            rmap_echo_3_in_fifo_wrflag_i  => s_tb_ch4_wr_wrdata_flag_o,
            rmap_echo_3_in_fifo_wrdata_i  => s_tb_ch4_wr_wrdata_data_o,
            rmap_echo_3_in_fifo_wrreq_i   => s_tb_ch4_wr_wrreq_o,
            rmap_echo_3_out_fifo_wrflag_i => s_tb_ch4_rd_wrdata_flag_o,
            rmap_echo_3_out_fifo_wrdata_i => s_tb_ch4_rd_wrdata_data_o,
            rmap_echo_3_out_fifo_wrreq_i  => s_tb_ch4_rd_wrreq_o,
            rmap_echo_4_echo_en_i         => s_tb_echo_enable,
            rmap_echo_4_echo_id_en_i      => c_ECHO_ID_ENABLE,
            rmap_echo_4_in_fifo_wrflag_i  => s_tb_ch5_wr_wrdata_flag_o,
            rmap_echo_4_in_fifo_wrdata_i  => s_tb_ch5_wr_wrdata_data_o,
            rmap_echo_4_in_fifo_wrreq_i   => s_tb_ch5_wr_wrreq_o,
            rmap_echo_4_out_fifo_wrflag_i => s_tb_ch5_rd_wrdata_flag_o,
            rmap_echo_4_out_fifo_wrdata_i => s_tb_ch5_rd_wrdata_data_o,
            rmap_echo_4_out_fifo_wrreq_i  => s_tb_ch5_rd_wrreq_o,
            rmap_echo_5_echo_en_i         => s_tb_echo_enable,
            rmap_echo_5_echo_id_en_i      => c_ECHO_ID_ENABLE,
            rmap_echo_5_in_fifo_wrflag_i  => s_tb_ch6_wr_wrdata_flag_o,
            rmap_echo_5_in_fifo_wrdata_i  => s_tb_ch6_wr_wrdata_data_o,
            rmap_echo_5_in_fifo_wrreq_i   => s_tb_ch6_wr_wrreq_o,
            rmap_echo_5_out_fifo_wrflag_i => s_tb_ch6_rd_wrdata_flag_o,
            rmap_echo_5_out_fifo_wrdata_i => s_tb_ch6_rd_wrdata_data_o,
            rmap_echo_5_out_fifo_wrreq_i  => s_tb_ch6_rd_wrreq_o,
            rmap_echo_6_echo_en_i         => s_tb_echo_enable,
            rmap_echo_6_echo_id_en_i      => c_ECHO_ID_ENABLE,
            rmap_echo_6_in_fifo_wrflag_i  => s_tb_ch7_wr_wrdata_flag_o,
            rmap_echo_6_in_fifo_wrdata_i  => s_tb_ch7_wr_wrdata_data_o,
            rmap_echo_6_in_fifo_wrreq_i   => s_tb_ch7_wr_wrreq_o,
            rmap_echo_6_out_fifo_wrflag_i => s_tb_ch7_rd_wrdata_flag_o,
            rmap_echo_6_out_fifo_wrdata_i => s_tb_ch7_rd_wrdata_data_o,
            rmap_echo_6_out_fifo_wrreq_i  => s_tb_ch7_rd_wrreq_o,
            spw_link_status_started_i     => '0',
            spw_link_status_connecting_i  => '0',
            spw_link_status_running_i     => '0',
            spw_link_error_errdisc_i      => '0',
            spw_link_error_errpar_i       => '0',
            spw_link_error_erresc_i       => '0',
            spw_link_error_errcred_i      => '0',
            spw_timecode_rx_tick_out_i    => '0',
            spw_timecode_rx_ctrl_out_i    => (others => '0'),
            spw_timecode_rx_time_out_i    => (others => '0'),
            spw_data_rx_status_rxvalid_i  => '0',
            spw_data_rx_status_rxhalff_i  => '0',
            spw_data_rx_status_rxflag_i   => '0',
            spw_data_rx_status_rxdata_i   => (others => '0'),
            spw_data_tx_status_txrdy_i    => '1',
            spw_data_tx_status_txhalff_i  => '0',
            spw_link_command_autostart_o  => open,
            spw_link_command_linkstart_o  => open,
            spw_link_command_linkdis_o    => open,
            spw_link_command_txdivcnt_o   => open,
            spw_timecode_tx_tick_in_o     => open,
            spw_timecode_tx_ctrl_in_o     => open,
            spw_timecode_tx_time_in_o     => open,
            spw_data_rx_command_rxread_o  => open,
            spw_data_tx_command_txwrite_o => open,
            spw_data_tx_command_txflag_o  => open,
            spw_data_tx_command_txdata_o  => open
        );

    s_tb_echo_enable <= '1', '0' after 12.5 us, '1' after 25 us;

end architecture RTL;
