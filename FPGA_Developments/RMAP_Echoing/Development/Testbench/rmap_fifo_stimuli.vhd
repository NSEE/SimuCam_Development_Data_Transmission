library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rmap_fifo_stimuli is
    port(
        clk_i                          : in  std_logic;
        rst_i                          : in  std_logic;
        rmap_ch1_wr_fifo_wrdata_flag_o : out std_logic;
        rmap_ch1_wr_fifo_wrdata_data_o : out std_logic_vector(7 downto 0);
        rmap_ch1_wr_fifo_wrreq_o       : out std_logic;
        rmap_ch1_rd_fifo_wrdata_flag_o : out std_logic;
        rmap_ch1_rd_fifo_wrdata_data_o : out std_logic_vector(7 downto 0);
        rmap_ch1_rd_fifo_wrreq_o       : out std_logic;
        rmap_ch2_wr_fifo_wrdata_flag_o : out std_logic;
        rmap_ch2_wr_fifo_wrdata_data_o : out std_logic_vector(7 downto 0);
        rmap_ch2_wr_fifo_wrreq_o       : out std_logic;
        rmap_ch2_rd_fifo_wrdata_flag_o : out std_logic;
        rmap_ch2_rd_fifo_wrdata_data_o : out std_logic_vector(7 downto 0);
        rmap_ch2_rd_fifo_wrreq_o       : out std_logic;
        rmap_ch3_wr_fifo_wrdata_flag_o : out std_logic;
        rmap_ch3_wr_fifo_wrdata_data_o : out std_logic_vector(7 downto 0);
        rmap_ch3_wr_fifo_wrreq_o       : out std_logic;
        rmap_ch3_rd_fifo_wrdata_flag_o : out std_logic;
        rmap_ch3_rd_fifo_wrdata_data_o : out std_logic_vector(7 downto 0);
        rmap_ch3_rd_fifo_wrreq_o       : out std_logic;
        rmap_ch4_wr_fifo_wrdata_flag_o : out std_logic;
        rmap_ch4_wr_fifo_wrdata_data_o : out std_logic_vector(7 downto 0);
        rmap_ch4_wr_fifo_wrreq_o       : out std_logic;
        rmap_ch4_rd_fifo_wrdata_flag_o : out std_logic;
        rmap_ch4_rd_fifo_wrdata_data_o : out std_logic_vector(7 downto 0);
        rmap_ch4_rd_fifo_wrreq_o       : out std_logic;
        rmap_ch5_wr_fifo_wrdata_flag_o : out std_logic;
        rmap_ch5_wr_fifo_wrdata_data_o : out std_logic_vector(7 downto 0);
        rmap_ch5_wr_fifo_wrreq_o       : out std_logic;
        rmap_ch5_rd_fifo_wrdata_flag_o : out std_logic;
        rmap_ch5_rd_fifo_wrdata_data_o : out std_logic_vector(7 downto 0);
        rmap_ch5_rd_fifo_wrreq_o       : out std_logic;
        rmap_ch6_wr_fifo_wrdata_flag_o : out std_logic;
        rmap_ch6_wr_fifo_wrdata_data_o : out std_logic_vector(7 downto 0);
        rmap_ch6_wr_fifo_wrreq_o       : out std_logic;
        rmap_ch6_rd_fifo_wrdata_flag_o : out std_logic;
        rmap_ch6_rd_fifo_wrdata_data_o : out std_logic_vector(7 downto 0);
        rmap_ch6_rd_fifo_wrreq_o       : out std_logic;
        rmap_ch7_wr_fifo_wrdata_flag_o : out std_logic;
        rmap_ch7_wr_fifo_wrdata_data_o : out std_logic_vector(7 downto 0);
        rmap_ch7_wr_fifo_wrreq_o       : out std_logic;
        rmap_ch7_rd_fifo_wrdata_flag_o : out std_logic;
        rmap_ch7_rd_fifo_wrdata_data_o : out std_logic_vector(7 downto 0);
        rmap_ch7_rd_fifo_wrreq_o       : out std_logic
    );
end entity rmap_fifo_stimuli;

architecture RTL of rmap_fifo_stimuli is
    -- ccd image data
    constant c_RMAP_FIFODATA_LENGTH : natural                                         := 207;
    signal s_rmap_fifodata_cnt      : natural range 0 to (c_RMAP_FIFODATA_LENGTH - 1) := 0;
    type t_rmap_fifodata is array (0 to (c_RMAP_FIFODATA_LENGTH - 1)) of std_logic_vector(8 downto 0);
    constant c_RMAP_FIFODATA        : t_rmap_fifodata                                 := (
        "010000001",                    -- 0x81
        "000000001",                    -- 0x01
        "010100000",                    -- 0xA0
        "010100001",                    -- 0xA1
        "010100010",                    -- 0xA2
        "010100011",                    -- 0xA3
        "010100100",                    -- 0xA4
        "010100101",                    -- 0xA5
        "010100110",                    -- 0xA6
        "010100111",                    -- 0xA7
        "010101000",                    -- 0xA8
        "010101001",                    -- 0xA9
        "010101001",                    -- 0xA9
        "010101010",                    -- 0xAA
        "010101011",                    -- 0xAB
        "010101100",                    -- 0xAC
        "010101101",                    -- 0xAD
        "010101110",                    -- 0xAE
        "010101111",                    -- 0xAF
        "010110000",                    -- 0xB0
        "010110001",                    -- 0xB1
        "010110010",                    -- 0xB2
        "010110011",                    -- 0xB3
        "010110100",                    -- 0xB4
        "010110101",                    -- 0xB5
        "010110110",                    -- 0xB6
        "010110111",                    -- 0xB7
        "010111000",                    -- 0xB8
        "010111001",                    -- 0xB9
        "010111001",                    -- 0xB9
        "010111010",                    -- 0xBA
        "010111011",                    -- 0xBB
        "010111100",                    -- 0xBC
        "010111101",                    -- 0xBD
        "010111110",                    -- 0xBE
        "010111111",                    -- 0xBF
        "010100000",                    -- 0xA0
        "010100001",                    -- 0xA1
        "010100010",                    -- 0xA2
        "010100011",                    -- 0xA3
        "010100100",                    -- 0xA4
        "010100101",                    -- 0xA5
        "010100110",                    -- 0xA6
        "010100111",                    -- 0xA7
        "010101000",                    -- 0xA8
        "010101001",                    -- 0xA9
        "010101001",                    -- 0xA9
        "010101010",                    -- 0xAA
        "010101011",                    -- 0xAB
        "010101100",                    -- 0xAC
        "010101101",                    -- 0xAD
        "010101110",                    -- 0xAE
        "010101111",                    -- 0xAF
        "010110000",                    -- 0xB0
        "010110001",                    -- 0xB1
        "010110010",                    -- 0xB2
        "010110011",                    -- 0xB3
        "010110100",                    -- 0xB4
        "010110101",                    -- 0xB5
        "010110110",                    -- 0xB6
        "010110111",                    -- 0xB7
        "010111000",                    -- 0xB8
        "010111001",                    -- 0xB9
        "010111001",                    -- 0xB9
        "010111010",                    -- 0xBA
        "010111011",                    -- 0xBB
        "010111100",                    -- 0xBC
        "010111101",                    -- 0xBD
        "010111110",                    -- 0xBE
        "010111111",                    -- 0xBF
        "010100000",                    -- 0xA0
        "010100001",                    -- 0xA1
        "010100010",                    -- 0xA2
        "010100011",                    -- 0xA3
        "010100100",                    -- 0xA4
        "010100101",                    -- 0xA5
        "010100110",                    -- 0xA6
        "010100111",                    -- 0xA7
        "010101000",                    -- 0xA8
        "010101001",                    -- 0xA9
        "010101001",                    -- 0xA9
        "010101010",                    -- 0xAA
        "010101011",                    -- 0xAB
        "010101100",                    -- 0xAC
        "010101101",                    -- 0xAD
        "010101110",                    -- 0xAE
        "010101111",                    -- 0xAF
        "010110000",                    -- 0xB0
        "010110001",                    -- 0xB1
        "010110010",                    -- 0xB2
        "010110011",                    -- 0xB3
        "010110100",                    -- 0xB4
        "010110101",                    -- 0xB5
        "010110110",                    -- 0xB6
        "010110111",                    -- 0xB7
        "010111000",                    -- 0xB8
        "010111001",                    -- 0xB9
        "010111001",                    -- 0xB9
        "010111010",                    -- 0xBA
        "010111011",                    -- 0xBB
        "010111100",                    -- 0xBC
        "010111101",                    -- 0xBD
        "010111110",                    -- 0xBE
        "010111111",                    -- 0xBF
        "010100000",                    -- 0xA0
        "010100001",                    -- 0xA1
        "010100010",                    -- 0xA2
        "010100011",                    -- 0xA3
        "010100100",                    -- 0xA4
        "010100101",                    -- 0xA5
        "010100110",                    -- 0xA6
        "010100111",                    -- 0xA7
        "010101000",                    -- 0xA8
        "010101001",                    -- 0xA9
        "010101001",                    -- 0xA9
        "010101010",                    -- 0xAA
        "010101011",                    -- 0xAB
        "010101100",                    -- 0xAC
        "010101101",                    -- 0xAD
        "010101110",                    -- 0xAE
        "010101111",                    -- 0xAF
        "010110000",                    -- 0xB0
        "010110001",                    -- 0xB1
        "010110010",                    -- 0xB2
        "010110011",                    -- 0xB3
        "010110100",                    -- 0xB4
        "010110101",                    -- 0xB5
        "010110110",                    -- 0xB6
        "010110111",                    -- 0xB7
        "010111000",                    -- 0xB8
        "010111001",                    -- 0xB9
        "010111001",                    -- 0xB9
        "010111010",                    -- 0xBA
        "010111011",                    -- 0xBB
        "010111100",                    -- 0xBC
        "010111101",                    -- 0xBD
        "010111110",                    -- 0xBE
        "010111111",                    -- 0xBF
        "010100000",                    -- 0xA0
        "010100001",                    -- 0xA1
        "010100010",                    -- 0xA2
        "010100011",                    -- 0xA3
        "010100100",                    -- 0xA4
        "010100101",                    -- 0xA5
        "010100110",                    -- 0xA6
        "010100111",                    -- 0xA7
        "010101000",                    -- 0xA8
        "010101001",                    -- 0xA9
        "010101001",                    -- 0xA9
        "010101010",                    -- 0xAA
        "010101011",                    -- 0xAB
        "010101100",                    -- 0xAC
        "010101101",                    -- 0xAD
        "010101110",                    -- 0xAE
        "010101111",                    -- 0xAF
        "010110000",                    -- 0xB0
        "010110001",                    -- 0xB1
        "010110010",                    -- 0xB2
        "010110011",                    -- 0xB3
        "010110100",                    -- 0xB4
        "010110101",                    -- 0xB5
        "010110110",                    -- 0xB6
        "010110111",                    -- 0xB7
        "010111000",                    -- 0xB8
        "010111001",                    -- 0xB9
        "010111001",                    -- 0xB9
        "010111010",                    -- 0xBA
        "010111011",                    -- 0xBB
        "010111100",                    -- 0xBC
        "010111101",                    -- 0xBD
        "010111110",                    -- 0xBE
        "010111111",                    -- 0xBF
        "010100000",                    -- 0xA0
        "010100001",                    -- 0xA1
        "010100010",                    -- 0xA2
        "010100011",                    -- 0xA3
        "010100100",                    -- 0xA4
        "010100101",                    -- 0xA5
        "010100110",                    -- 0xA6
        "010100111",                    -- 0xA7
        "010101000",                    -- 0xA8
        "010101001",                    -- 0xA9
        "010101001",                    -- 0xA9
        "010101010",                    -- 0xAA
        "010101011",                    -- 0xAB
        "010101100",                    -- 0xAC
        "010101101",                    -- 0xAD
        "010101110",                    -- 0xAE
        "010101111",                    -- 0xAF
        "010110000",                    -- 0xB0
        "010110001",                    -- 0xB1
        "010110010",                    -- 0xB2
        "010110011",                    -- 0xB3
        "010110100",                    -- 0xB4
        "010110101",                    -- 0xB5
        "010110110",                    -- 0xB6
        "010110111",                    -- 0xB7
        "010111000",                    -- 0xB8
        "010111001",                    -- 0xB9
        "010111001",                    -- 0xB9
        "010111010",                    -- 0xBA
        "010111011",                    -- 0xBB
        "010111100",                    -- 0xBC
        "010111101",                    -- 0xBD
        "010111110",                    -- 0xBE
        "010111111",                    -- 0xBF
        "100000000"                     -- EOP
    );

    signal s_counter : natural := 0;

    constant c_CH1_WR_TIME : natural := 1000;
    constant c_CH1_RD_TIME : natural := 1500;
    constant c_CH2_WR_TIME : natural := 2000;
    constant c_CH2_RD_TIME : natural := 2500;
    constant c_CH3_WR_TIME : natural := 3000;
    constant c_CH3_RD_TIME : natural := 3500;
    constant c_CH4_WR_TIME : natural := 4000;
    constant c_CH4_RD_TIME : natural := 4500;
    constant c_CH5_WR_TIME : natural := 5000;
    constant c_CH5_RD_TIME : natural := 5500;
    constant c_CH6_WR_TIME : natural := 6000;
    constant c_CH6_RD_TIME : natural := 6500;
    constant c_CH7_WR_TIME : natural := 7000;
    constant c_CH7_RD_TIME : natural := 7500;

    constant c_DELAY_TIME : natural := 100;

begin

    p_rmap_fifo_stimuli : process(clk_i, rst_i) is
    begin
        if (rst_i = '1') then

            rmap_ch1_wr_fifo_wrdata_flag_o <= '0';
            rmap_ch1_wr_fifo_wrdata_data_o <= (others => '0');
            rmap_ch1_wr_fifo_wrreq_o       <= '0';
            rmap_ch1_rd_fifo_wrdata_flag_o <= '0';
            rmap_ch1_rd_fifo_wrdata_data_o <= (others => '0');
            rmap_ch1_rd_fifo_wrreq_o       <= '0';
            rmap_ch2_wr_fifo_wrdata_flag_o <= '0';
            rmap_ch2_wr_fifo_wrdata_data_o <= (others => '0');
            rmap_ch2_wr_fifo_wrreq_o       <= '0';
            rmap_ch2_rd_fifo_wrdata_flag_o <= '0';
            rmap_ch2_rd_fifo_wrdata_data_o <= (others => '0');
            rmap_ch2_rd_fifo_wrreq_o       <= '0';
            rmap_ch3_wr_fifo_wrdata_flag_o <= '0';
            rmap_ch3_wr_fifo_wrdata_data_o <= (others => '0');
            rmap_ch3_wr_fifo_wrreq_o       <= '0';
            rmap_ch3_rd_fifo_wrdata_flag_o <= '0';
            rmap_ch3_rd_fifo_wrdata_data_o <= (others => '0');
            rmap_ch3_rd_fifo_wrreq_o       <= '0';
            rmap_ch4_wr_fifo_wrdata_flag_o <= '0';
            rmap_ch4_wr_fifo_wrdata_data_o <= (others => '0');
            rmap_ch4_wr_fifo_wrreq_o       <= '0';
            rmap_ch4_rd_fifo_wrdata_flag_o <= '0';
            rmap_ch4_rd_fifo_wrdata_data_o <= (others => '0');
            rmap_ch4_rd_fifo_wrreq_o       <= '0';
            rmap_ch5_wr_fifo_wrdata_flag_o <= '0';
            rmap_ch5_wr_fifo_wrdata_data_o <= (others => '0');
            rmap_ch5_wr_fifo_wrreq_o       <= '0';
            rmap_ch5_rd_fifo_wrdata_flag_o <= '0';
            rmap_ch5_rd_fifo_wrdata_data_o <= (others => '0');
            rmap_ch5_rd_fifo_wrreq_o       <= '0';
            rmap_ch6_wr_fifo_wrdata_flag_o <= '0';
            rmap_ch6_wr_fifo_wrdata_data_o <= (others => '0');
            rmap_ch6_wr_fifo_wrreq_o       <= '0';
            rmap_ch6_rd_fifo_wrdata_flag_o <= '0';
            rmap_ch6_rd_fifo_wrdata_data_o <= (others => '0');
            rmap_ch6_rd_fifo_wrreq_o       <= '0';
            rmap_ch7_wr_fifo_wrdata_flag_o <= '0';
            rmap_ch7_wr_fifo_wrdata_data_o <= (others => '0');
            rmap_ch7_wr_fifo_wrreq_o       <= '0';
            rmap_ch7_rd_fifo_wrdata_flag_o <= '0';
            rmap_ch7_rd_fifo_wrdata_data_o <= (others => '0');
            rmap_ch7_rd_fifo_wrreq_o       <= '0';
            s_rmap_fifodata_cnt            <= 0;
            s_counter                      <= 0;
        --						s_counter              <= 9000;

        elsif rising_edge(clk_i) then

            rmap_ch1_wr_fifo_wrdata_flag_o <= '0';
            rmap_ch1_wr_fifo_wrdata_data_o <= (others => '0');
            rmap_ch1_wr_fifo_wrreq_o       <= '0';
            rmap_ch1_rd_fifo_wrdata_flag_o <= '0';
            rmap_ch1_rd_fifo_wrdata_data_o <= (others => '0');
            rmap_ch1_rd_fifo_wrreq_o       <= '0';
            rmap_ch2_wr_fifo_wrdata_flag_o <= '0';
            rmap_ch2_wr_fifo_wrdata_data_o <= (others => '0');
            rmap_ch2_wr_fifo_wrreq_o       <= '0';
            rmap_ch2_rd_fifo_wrdata_flag_o <= '0';
            rmap_ch2_rd_fifo_wrdata_data_o <= (others => '0');
            rmap_ch2_rd_fifo_wrreq_o       <= '0';
            rmap_ch3_wr_fifo_wrdata_flag_o <= '0';
            rmap_ch3_wr_fifo_wrdata_data_o <= (others => '0');
            rmap_ch3_wr_fifo_wrreq_o       <= '0';
            rmap_ch3_rd_fifo_wrdata_flag_o <= '0';
            rmap_ch3_rd_fifo_wrdata_data_o <= (others => '0');
            rmap_ch3_rd_fifo_wrreq_o       <= '0';
            rmap_ch4_wr_fifo_wrdata_flag_o <= '0';
            rmap_ch4_wr_fifo_wrdata_data_o <= (others => '0');
            rmap_ch4_wr_fifo_wrreq_o       <= '0';
            rmap_ch4_rd_fifo_wrdata_flag_o <= '0';
            rmap_ch4_rd_fifo_wrdata_data_o <= (others => '0');
            rmap_ch4_rd_fifo_wrreq_o       <= '0';
            rmap_ch5_wr_fifo_wrdata_flag_o <= '0';
            rmap_ch5_wr_fifo_wrdata_data_o <= (others => '0');
            rmap_ch5_wr_fifo_wrreq_o       <= '0';
            rmap_ch5_rd_fifo_wrdata_flag_o <= '0';
            rmap_ch5_rd_fifo_wrdata_data_o <= (others => '0');
            rmap_ch5_rd_fifo_wrreq_o       <= '0';
            rmap_ch6_wr_fifo_wrdata_flag_o <= '0';
            rmap_ch6_wr_fifo_wrdata_data_o <= (others => '0');
            rmap_ch6_wr_fifo_wrreq_o       <= '0';
            rmap_ch6_rd_fifo_wrdata_flag_o <= '0';
            rmap_ch6_rd_fifo_wrdata_data_o <= (others => '0');
            rmap_ch6_rd_fifo_wrreq_o       <= '0';
            rmap_ch7_wr_fifo_wrdata_flag_o <= '0';
            rmap_ch7_wr_fifo_wrdata_data_o <= (others => '0');
            rmap_ch7_wr_fifo_wrreq_o       <= '0';
            rmap_ch7_rd_fifo_wrdata_flag_o <= '0';
            rmap_ch7_rd_fifo_wrdata_data_o <= (others => '0');
            rmap_ch7_rd_fifo_wrreq_o       <= '0';
            s_counter                      <= s_counter + 1;

            case (s_counter) is

                -- channel 1 - write

                when c_CH1_WR_TIME =>
                    rmap_ch1_wr_fifo_wrdata_flag_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(8);
                    rmap_ch1_wr_fifo_wrdata_data_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(7 downto 0);
                    rmap_ch1_wr_fifo_wrreq_o       <= '1';

                when c_CH1_WR_TIME + 1 =>
                    s_counter <= c_CH1_WR_TIME;
                    if (s_rmap_fifodata_cnt = (c_RMAP_FIFODATA_LENGTH - 1)) then
                        s_rmap_fifodata_cnt <= 0;
                        s_counter           <= c_CH1_RD_TIME - c_DELAY_TIME;
                    else
                        s_rmap_fifodata_cnt <= s_rmap_fifodata_cnt + 1;
                    end if;

                -- channel 1 - read

                when c_CH1_RD_TIME =>
                    rmap_ch1_rd_fifo_wrdata_flag_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(8);
                    rmap_ch1_rd_fifo_wrdata_data_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(7 downto 0);
                    rmap_ch1_rd_fifo_wrreq_o       <= '1';

                when c_CH1_RD_TIME + 1 =>
                    s_counter <= c_CH1_RD_TIME;
                    if (s_rmap_fifodata_cnt = (c_RMAP_FIFODATA_LENGTH - 1)) then
                        s_rmap_fifodata_cnt <= 0;
                        s_counter           <= c_CH2_WR_TIME - c_DELAY_TIME;
                    else
                        s_rmap_fifodata_cnt <= s_rmap_fifodata_cnt + 1;
                    end if;

                -- channel 2 - write

                when c_CH2_WR_TIME =>
                    rmap_ch2_wr_fifo_wrdata_flag_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(8);
                    rmap_ch2_wr_fifo_wrdata_data_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(7 downto 0);
                    rmap_ch2_wr_fifo_wrreq_o       <= '1';

                when c_CH2_WR_TIME + 1 =>
                    s_counter <= c_CH2_WR_TIME;
                    if (s_rmap_fifodata_cnt = (c_RMAP_FIFODATA_LENGTH - 1)) then
                        s_rmap_fifodata_cnt <= 0;
                        s_counter           <= c_CH2_RD_TIME - c_DELAY_TIME;
                    else
                        s_rmap_fifodata_cnt <= s_rmap_fifodata_cnt + 1;
                    end if;

                -- channel 2 - read

                when c_CH2_RD_TIME =>
                    rmap_ch2_rd_fifo_wrdata_flag_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(8);
                    rmap_ch2_rd_fifo_wrdata_data_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(7 downto 0);
                    rmap_ch2_rd_fifo_wrreq_o       <= '1';

                when c_CH2_RD_TIME + 1 =>
                    s_counter <= c_CH2_RD_TIME;
                    if (s_rmap_fifodata_cnt = (c_RMAP_FIFODATA_LENGTH - 1)) then
                        s_rmap_fifodata_cnt <= 0;
                        s_counter           <= c_CH3_WR_TIME - c_DELAY_TIME;
                    else
                        s_rmap_fifodata_cnt <= s_rmap_fifodata_cnt + 1;
                    end if;

                -- channel 3 - write

                when c_CH3_WR_TIME =>
                    rmap_ch3_wr_fifo_wrdata_flag_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(8);
                    rmap_ch3_wr_fifo_wrdata_data_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(7 downto 0);
                    rmap_ch3_wr_fifo_wrreq_o       <= '1';

                when c_CH3_WR_TIME + 1 =>
                    s_counter <= c_CH3_WR_TIME;
                    if (s_rmap_fifodata_cnt = (c_RMAP_FIFODATA_LENGTH - 1)) then
                        s_rmap_fifodata_cnt <= 0;
                        s_counter           <= c_CH3_RD_TIME - c_DELAY_TIME;
                    else
                        s_rmap_fifodata_cnt <= s_rmap_fifodata_cnt + 1;
                    end if;

                -- channel 3 - read

                when c_CH3_RD_TIME =>
                    rmap_ch3_rd_fifo_wrdata_flag_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(8);
                    rmap_ch3_rd_fifo_wrdata_data_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(7 downto 0);
                    rmap_ch3_rd_fifo_wrreq_o       <= '1';

                when c_CH3_RD_TIME + 1 =>
                    s_counter <= c_CH3_RD_TIME;
                    if (s_rmap_fifodata_cnt = (c_RMAP_FIFODATA_LENGTH - 1)) then
                        s_rmap_fifodata_cnt <= 0;
                        s_counter           <= c_CH4_WR_TIME - c_DELAY_TIME;
                    else
                        s_rmap_fifodata_cnt <= s_rmap_fifodata_cnt + 1;
                    end if;

                -- channel 4 - write

                when c_CH4_WR_TIME =>
                    rmap_ch4_wr_fifo_wrdata_flag_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(8);
                    rmap_ch4_wr_fifo_wrdata_data_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(7 downto 0);
                    rmap_ch4_wr_fifo_wrreq_o       <= '1';

                when c_CH4_WR_TIME + 1 =>
                    s_counter <= c_CH4_WR_TIME;
                    if (s_rmap_fifodata_cnt = (c_RMAP_FIFODATA_LENGTH - 1)) then
                        s_rmap_fifodata_cnt <= 0;
                        s_counter           <= c_CH4_RD_TIME - c_DELAY_TIME;
                    else
                        s_rmap_fifodata_cnt <= s_rmap_fifodata_cnt + 1;
                    end if;

                -- channel 4 - read

                when c_CH4_RD_TIME =>
                    rmap_ch4_rd_fifo_wrdata_flag_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(8);
                    rmap_ch4_rd_fifo_wrdata_data_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(7 downto 0);
                    rmap_ch4_rd_fifo_wrreq_o       <= '1';

                when c_CH4_RD_TIME + 1 =>
                    s_counter <= c_CH4_RD_TIME;
                    if (s_rmap_fifodata_cnt = (c_RMAP_FIFODATA_LENGTH - 1)) then
                        s_rmap_fifodata_cnt <= 0;
                        s_counter           <= c_CH5_WR_TIME - c_DELAY_TIME;
                    else
                        s_rmap_fifodata_cnt <= s_rmap_fifodata_cnt + 1;
                    end if;

                -- channel 5 - write

                when c_CH5_WR_TIME =>
                    rmap_ch5_wr_fifo_wrdata_flag_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(8);
                    rmap_ch5_wr_fifo_wrdata_data_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(7 downto 0);
                    rmap_ch5_wr_fifo_wrreq_o       <= '1';

                when c_CH5_WR_TIME + 1 =>
                    s_counter <= c_CH5_WR_TIME;
                    if (s_rmap_fifodata_cnt = (c_RMAP_FIFODATA_LENGTH - 1)) then
                        s_rmap_fifodata_cnt <= 0;
                        s_counter           <= c_CH5_RD_TIME - c_DELAY_TIME;
                    else
                        s_rmap_fifodata_cnt <= s_rmap_fifodata_cnt + 1;
                    end if;

                -- channel 5 - read

                when c_CH5_RD_TIME =>
                    rmap_ch5_rd_fifo_wrdata_flag_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(8);
                    rmap_ch5_rd_fifo_wrdata_data_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(7 downto 0);
                    rmap_ch5_rd_fifo_wrreq_o       <= '1';

                when c_CH5_RD_TIME + 1 =>
                    s_counter <= c_CH5_RD_TIME;
                    if (s_rmap_fifodata_cnt = (c_RMAP_FIFODATA_LENGTH - 1)) then
                        s_rmap_fifodata_cnt <= 0;
                        s_counter           <= c_CH6_WR_TIME - c_DELAY_TIME;
                    else
                        s_rmap_fifodata_cnt <= s_rmap_fifodata_cnt + 1;
                    end if;

                -- channel 6 - write

                when c_CH6_WR_TIME =>
                    rmap_ch6_wr_fifo_wrdata_flag_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(8);
                    rmap_ch6_wr_fifo_wrdata_data_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(7 downto 0);
                    rmap_ch6_wr_fifo_wrreq_o       <= '1';

                when c_CH6_WR_TIME + 1 =>
                    s_counter <= c_CH6_WR_TIME;
                    if (s_rmap_fifodata_cnt = (c_RMAP_FIFODATA_LENGTH - 1)) then
                        s_rmap_fifodata_cnt <= 0;
                        s_counter           <= c_CH6_RD_TIME - c_DELAY_TIME;
                    else
                        s_rmap_fifodata_cnt <= s_rmap_fifodata_cnt + 1;
                    end if;

                -- channel 6 - read

                when c_CH6_RD_TIME =>
                    rmap_ch6_rd_fifo_wrdata_flag_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(8);
                    rmap_ch6_rd_fifo_wrdata_data_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(7 downto 0);
                    rmap_ch6_rd_fifo_wrreq_o       <= '1';

                when c_CH6_RD_TIME + 1 =>
                    s_counter <= c_CH6_RD_TIME;
                    if (s_rmap_fifodata_cnt = (c_RMAP_FIFODATA_LENGTH - 1)) then
                        s_rmap_fifodata_cnt <= 0;
                        s_counter           <= c_CH7_WR_TIME - c_DELAY_TIME;
                    else
                        s_rmap_fifodata_cnt <= s_rmap_fifodata_cnt + 1;
                    end if;

                -- channel 7 - write

                when c_CH7_WR_TIME =>
                    rmap_ch7_wr_fifo_wrdata_flag_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(8);
                    rmap_ch7_wr_fifo_wrdata_data_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(7 downto 0);
                    rmap_ch7_wr_fifo_wrreq_o       <= '1';

                when c_CH7_WR_TIME + 1 =>
                    s_counter <= c_CH7_WR_TIME;
                    if (s_rmap_fifodata_cnt = (c_RMAP_FIFODATA_LENGTH - 1)) then
                        s_rmap_fifodata_cnt <= 0;
                        s_counter           <= c_CH7_RD_TIME - c_DELAY_TIME;
                    else
                        s_rmap_fifodata_cnt <= s_rmap_fifodata_cnt + 1;
                    end if;

                -- channel 7 - read

                when c_CH7_RD_TIME =>
                    rmap_ch7_rd_fifo_wrdata_flag_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(8);
                    rmap_ch7_rd_fifo_wrdata_data_o <= c_RMAP_FIFODATA(s_rmap_fifodata_cnt)(7 downto 0);
                    rmap_ch7_rd_fifo_wrreq_o       <= '1';

                when c_CH7_RD_TIME + 1 =>
                    s_counter <= c_CH7_RD_TIME;
                    if (s_rmap_fifodata_cnt = (c_RMAP_FIFODATA_LENGTH - 1)) then
                        s_rmap_fifodata_cnt <= 0;
--                        s_counter           <= c_CH7_RD_TIME + c_DELAY_TIME;
                        s_counter           <= c_CH1_WR_TIME - c_DELAY_TIME;
                    else
                        s_rmap_fifodata_cnt <= s_rmap_fifodata_cnt + 1;
                    end if;

                when others =>
                    null;

            end case;

        end if;
    end process p_rmap_fifo_stimuli;

end architecture RTL;
