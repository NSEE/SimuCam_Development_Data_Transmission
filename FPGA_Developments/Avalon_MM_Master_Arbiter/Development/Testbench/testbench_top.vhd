library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avma_avm_arbiter_pkg.all;
use work.avalon_slave_stimulli_pkg.all;

entity testbench_top is
end entity testbench_top;

architecture RTL of testbench_top is

    -- clk and rst signals --
    signal clk100 : std_logic := '0';
    signal rst    : std_logic := '1';

    -- dut signals --

    -- dut avm 0 signals --
    signal s_dut_avm_0_address     : std_logic_vector((c_AVMA_AVM_ARBITER_ADRESS_SIZE - 1) downto 0);
    signal s_dut_avm_0_read        : std_logic;
    signal s_dut_avm_0_write       : std_logic;
    signal s_dut_avm_0_writedata   : std_logic_vector((c_AVMA_AVM_ARBITER_DATA_SIZE - 1) downto 0);
    --    signal s_dut_avm_0_byteenable  : std_logic_vector(((c_AVMA_AVM_ARBITER_DATA_SIZE / c_AVMA_AVM_ARBITER_SYMBOL_SIZE) - 1) downto 0);
    signal s_dut_avm_0_readdata    : std_logic_vector((c_AVMA_AVM_ARBITER_DATA_SIZE - 1) downto 0);
    signal s_dut_avm_0_waitrequest : std_logic;

    -- dut avm 1 signals --
    signal s_dut_avm_1_address     : std_logic_vector((c_AVMA_AVM_ARBITER_ADRESS_SIZE - 1) downto 0);
    signal s_dut_avm_1_read        : std_logic;
    signal s_dut_avm_1_write       : std_logic;
    signal s_dut_avm_1_writedata   : std_logic_vector((c_AVMA_AVM_ARBITER_DATA_SIZE - 1) downto 0);
    --    signal s_dut_avm_1_byteenable  : std_logic_vector(((c_AVMA_AVM_ARBITER_DATA_SIZE / c_AVMA_AVM_ARBITER_SYMBOL_SIZE) - 1) downto 0);
    signal s_dut_avm_1_readdata    : std_logic_vector((c_AVMA_AVM_ARBITER_DATA_SIZE - 1) downto 0);
    signal s_dut_avm_1_waitrequest : std_logic;

    -- dut avm 2 signals --
    signal s_dut_avm_2_address     : std_logic_vector((c_AVMA_AVM_ARBITER_ADRESS_SIZE - 1) downto 0);
    signal s_dut_avm_2_read        : std_logic;
    signal s_dut_avm_2_write       : std_logic;
    signal s_dut_avm_2_writedata   : std_logic_vector((c_AVMA_AVM_ARBITER_DATA_SIZE - 1) downto 0);
    --    signal s_dut_avm_2_byteenable  : std_logic_vector(((c_AVMA_AVM_ARBITER_DATA_SIZE / c_AVMA_AVM_ARBITER_SYMBOL_SIZE) - 1) downto 0);
    signal s_dut_avm_2_readdata    : std_logic_vector((c_AVMA_AVM_ARBITER_DATA_SIZE - 1) downto 0);
    signal s_dut_avm_2_waitrequest : std_logic;

    -- dut avm 3 signals --
    signal s_dut_avm_3_address     : std_logic_vector((c_AVMA_AVM_ARBITER_ADRESS_SIZE - 1) downto 0);
    signal s_dut_avm_3_read        : std_logic;
    signal s_dut_avm_3_write       : std_logic;
    signal s_dut_avm_3_writedata   : std_logic_vector((c_AVMA_AVM_ARBITER_DATA_SIZE - 1) downto 0);
    --    signal s_dut_avm_3_byteenable  : std_logic_vector(((c_AVMA_AVM_ARBITER_DATA_SIZE / c_AVMA_AVM_ARBITER_SYMBOL_SIZE) - 1) downto 0);
    signal s_dut_avm_3_readdata    : std_logic_vector((c_AVMA_AVM_ARBITER_DATA_SIZE - 1) downto 0);
    signal s_dut_avm_3_waitrequest : std_logic;

    -- dut avm 4 signals --
    signal s_dut_avm_4_address     : std_logic_vector((c_AVMA_AVM_ARBITER_ADRESS_SIZE - 1) downto 0);
    signal s_dut_avm_4_read        : std_logic;
    signal s_dut_avm_4_write       : std_logic;
    signal s_dut_avm_4_writedata   : std_logic_vector((c_AVMA_AVM_ARBITER_DATA_SIZE - 1) downto 0);
    --    signal s_dut_avm_4_byteenable  : std_logic_vector(((c_AVMA_AVM_ARBITER_DATA_SIZE / c_AVMA_AVM_ARBITER_SYMBOL_SIZE) - 1) downto 0);
    signal s_dut_avm_4_readdata    : std_logic_vector((c_AVMA_AVM_ARBITER_DATA_SIZE - 1) downto 0);
    signal s_dut_avm_4_waitrequest : std_logic;

    -- dut avm 5 signals --
    signal s_dut_avm_5_address     : std_logic_vector((c_AVMA_AVM_ARBITER_ADRESS_SIZE - 1) downto 0);
    signal s_dut_avm_5_read        : std_logic;
    signal s_dut_avm_5_write       : std_logic;
    signal s_dut_avm_5_writedata   : std_logic_vector((c_AVMA_AVM_ARBITER_DATA_SIZE - 1) downto 0);
    --    signal s_dut_avm_5_byteenable  : std_logic_vector(((c_AVMA_AVM_ARBITER_DATA_SIZE / c_AVMA_AVM_ARBITER_SYMBOL_SIZE) - 1) downto 0);
    signal s_dut_avm_5_readdata    : std_logic_vector((c_AVMA_AVM_ARBITER_DATA_SIZE - 1) downto 0);
    signal s_dut_avm_5_waitrequest : std_logic;

    -- dut avm 6 signals --
    signal s_dut_avm_6_address     : std_logic_vector((c_AVMA_AVM_ARBITER_ADRESS_SIZE - 1) downto 0);
    signal s_dut_avm_6_read        : std_logic;
    signal s_dut_avm_6_write       : std_logic;
    signal s_dut_avm_6_writedata   : std_logic_vector((c_AVMA_AVM_ARBITER_DATA_SIZE - 1) downto 0);
    --    signal s_dut_avm_6_byteenable  : std_logic_vector(((c_AVMA_AVM_ARBITER_DATA_SIZE / c_AVMA_AVM_ARBITER_SYMBOL_SIZE) - 1) downto 0);
    signal s_dut_avm_6_readdata    : std_logic_vector((c_AVMA_AVM_ARBITER_DATA_SIZE - 1) downto 0);
    signal s_dut_avm_6_waitrequest : std_logic;

    -- dut avm 7 signals --
    signal s_dut_avm_7_address     : std_logic_vector((c_AVMA_AVM_ARBITER_ADRESS_SIZE - 1) downto 0);
    signal s_dut_avm_7_read        : std_logic;
    signal s_dut_avm_7_write       : std_logic;
    signal s_dut_avm_7_writedata   : std_logic_vector((c_AVMA_AVM_ARBITER_DATA_SIZE - 1) downto 0);
    --    signal s_dut_avm_7_byteenable  : std_logic_vector(((c_AVMA_AVM_ARBITER_DATA_SIZE / c_AVMA_AVM_ARBITER_SYMBOL_SIZE) - 1) downto 0);
    signal s_dut_avm_7_readdata    : std_logic_vector((c_AVMA_AVM_ARBITER_DATA_SIZE - 1) downto 0);
    signal s_dut_avm_7_waitrequest : std_logic;

    -- dut avs signals --
    signal s_dut_avs_address        : std_logic_vector((c_AVMA_AVM_ARBITER_ADRESS_SIZE - 1) downto 0);
    signal s_dut_avs_read           : std_logic;
    signal s_dut_avs_write          : std_logic;
    signal s_dut_avs_writedata      : std_logic_vector((c_AVMA_AVM_ARBITER_DATA_SIZE - 1) downto 0);
    --    signal s_dut_avs_byteenable    : std_logic_vector(((c_AVMA_AVM_ARBITER_DATA_SIZE / c_AVMA_AVM_ARBITER_SYMBOL_SIZE) - 1) downto 0);
    signal s_dut_avs_readdata       : std_logic_vector((c_AVMA_AVM_ARBITER_DATA_SIZE - 1) downto 0);
    signal s_dut_avs_waitrequest    : std_logic;
    signal s_dut_avs_rd_waitrequest : std_logic;
    signal s_dut_avs_wr_waitrequest : std_logic;

begin

    clk100 <= not clk100 after 5 ns;    -- 100 MHz
    rst    <= '0' after 100 ns;

    avma_avalon_mm_master_arbiter_top_inst : entity work.avma_avalon_mm_master_arbiter_top
        port map(
            reset_i             => rst,
            clk_100_i           => clk100,
            --
            avm_0_address_i     => s_dut_avm_0_address,
            avm_0_read_i        => s_dut_avm_0_read,
            --            avm_0_write_i       => s_dut_avm_0_write,
            --            avm_0_writedata_i   => s_dut_avm_0_writedata,
            --            avm_0_byteenable_i  => s_dut_avm_0_byteenable,
            avm_0_readdata_o    => s_dut_avm_0_readdata,
            avm_0_waitrequest_o => s_dut_avm_0_waitrequest,
            --
            avm_1_address_i     => s_dut_avm_1_address,
            avm_1_read_i        => s_dut_avm_1_read,
            --            avm_1_write_i       => s_dut_avm_1_write,
            --            avm_1_writedata_i   => s_dut_avm_1_writedata,
            --            avm_1_byteenable_i  => s_dut_avm_1_byteenable,
            avm_1_readdata_o    => s_dut_avm_1_readdata,
            avm_1_waitrequest_o => s_dut_avm_1_waitrequest,
            --
            avm_2_address_i     => s_dut_avm_2_address,
            avm_2_read_i        => s_dut_avm_2_read,
            --            avm_2_write_i       => s_dut_avm_2_write,
            --            avm_2_writedata_i   => s_dut_avm_2_writedata,
            --            avm_2_byteenable_i  => s_dut_avm_2_byteenable,
            avm_2_readdata_o    => s_dut_avm_2_readdata,
            avm_2_waitrequest_o => s_dut_avm_2_waitrequest,
            --
            avm_3_address_i     => s_dut_avm_3_address,
            avm_3_read_i        => s_dut_avm_3_read,
            --            avm_3_write_i       => s_dut_avm_3_write,
            --            avm_3_writedata_i   => s_dut_avm_3_writedata,
            --            avm_3_byteenable_i  => s_dut_avm_3_byteenable,
            avm_3_readdata_o    => s_dut_avm_3_readdata,
            avm_3_waitrequest_o => s_dut_avm_3_waitrequest,
            --
            avm_4_address_i     => s_dut_avm_4_address,
            avm_4_read_i        => s_dut_avm_4_read,
            --            avm_4_write_i       => s_dut_avm_4_write,
            --            avm_4_writedata_i   => s_dut_avm_4_writedata,
            --            avm_4_byteenable_i  => s_dut_avm_4_byteenable,
            avm_4_readdata_o    => s_dut_avm_4_readdata,
            avm_4_waitrequest_o => s_dut_avm_4_waitrequest,
            --
            avm_5_address_i     => s_dut_avm_5_address,
            avm_5_read_i        => s_dut_avm_5_read,
            --            avm_5_write_i       => s_dut_avm_5_write,
            --            avm_5_writedata_i   => s_dut_avm_5_writedata,
            --            avm_5_byteenable_i  => s_dut_avm_5_byteenable,
            avm_5_readdata_o    => s_dut_avm_5_readdata,
            avm_5_waitrequest_o => s_dut_avm_5_waitrequest,
            --
            avm_6_address_i     => s_dut_avm_6_address,
            avm_6_read_i        => s_dut_avm_6_read,
            --            avm_6_write_i       => s_dut_avm_6_write,
            --            avm_6_writedata_i   => s_dut_avm_6_writedata,
            --            avm_6_byteenable_i  => s_dut_avm_6_byteenable,
            avm_6_readdata_o    => s_dut_avm_6_readdata,
            avm_6_waitrequest_o => s_dut_avm_6_waitrequest,
            --
            avm_7_address_i     => s_dut_avm_7_address,
            avm_7_read_i        => s_dut_avm_7_read,
            --            avm_7_write_i       => s_dut_avm_7_write,
            --            avm_7_writedata_i   => s_dut_avm_7_writedata,
            --            avm_7_byteenable_i  => s_dut_avm_7_byteenable,
            avm_7_readdata_o    => s_dut_avm_7_readdata,
            avm_7_waitrequest_o => s_dut_avm_7_waitrequest,
            --
            avs_readdata_i      => s_dut_avs_readdata,
            avs_waitrequest_i   => s_dut_avs_waitrequest,
            avs_address_o       => s_dut_avs_address,
            avs_read_o          => s_dut_avs_read
            --            avs_write_o         => s_dut_avs_write,
            --            avs_writedata_o     => s_dut_avs_writedata,
            --            avs_byteenable_o    => s_dut_avs_byteenable
        );

    avalon_master_0_stimuli_inst : entity work.avalon_master_0_stimuli
        generic map(
            g_ADDRESS_WIDTH => 64,
            g_DATA_WIDTH    => 64
        )
        port map(
            clk_i                   => clk100,
            rst_i                   => rst,
            avalon_mm_readdata_i    => s_dut_avm_0_readdata,
            avalon_mm_waitrequest_i => s_dut_avm_0_waitrequest,
            avalon_mm_address_o     => s_dut_avm_0_address,
            avalon_mm_write_o       => s_dut_avm_0_write,
            avalon_mm_writedata_o   => s_dut_avm_0_writedata,
            avalon_mm_read_o        => s_dut_avm_0_read
        );

    avalon_master_1_stimuli_inst : entity work.avalon_master_1_stimuli
        generic map(
            g_ADDRESS_WIDTH => 64,
            g_DATA_WIDTH    => 64
        )
        port map(
            clk_i                   => clk100,
            rst_i                   => rst,
            avalon_mm_readdata_i    => s_dut_avm_1_readdata,
            avalon_mm_waitrequest_i => s_dut_avm_1_waitrequest,
            avalon_mm_address_o     => s_dut_avm_1_address,
            avalon_mm_write_o       => s_dut_avm_1_write,
            avalon_mm_writedata_o   => s_dut_avm_1_writedata,
            avalon_mm_read_o        => s_dut_avm_1_read
        );

    avalon_master_2_stimuli_inst : entity work.avalon_master_2_stimuli
        generic map(
            g_ADDRESS_WIDTH => 64,
            g_DATA_WIDTH    => 64
        )
        port map(
            clk_i                   => clk100,
            rst_i                   => rst,
            avalon_mm_readdata_i    => s_dut_avm_2_readdata,
            avalon_mm_waitrequest_i => s_dut_avm_2_waitrequest,
            avalon_mm_address_o     => s_dut_avm_2_address,
            avalon_mm_write_o       => s_dut_avm_2_write,
            avalon_mm_writedata_o   => s_dut_avm_2_writedata,
            avalon_mm_read_o        => s_dut_avm_2_read
        );

    avalon_master_3_stimuli_inst : entity work.avalon_master_3_stimuli
        generic map(
            g_ADDRESS_WIDTH => 64,
            g_DATA_WIDTH    => 64
        )
        port map(
            clk_i                   => clk100,
            rst_i                   => rst,
            avalon_mm_readdata_i    => s_dut_avm_3_readdata,
            avalon_mm_waitrequest_i => s_dut_avm_3_waitrequest,
            avalon_mm_address_o     => s_dut_avm_3_address,
            avalon_mm_write_o       => s_dut_avm_3_write,
            avalon_mm_writedata_o   => s_dut_avm_3_writedata,
            avalon_mm_read_o        => s_dut_avm_3_read
        );

    avalon_master_4_stimuli_inst : entity work.avalon_master_4_stimuli
        generic map(
            g_ADDRESS_WIDTH => 64,
            g_DATA_WIDTH    => 64
        )
        port map(
            clk_i                   => clk100,
            rst_i                   => rst,
            avalon_mm_readdata_i    => s_dut_avm_4_readdata,
            avalon_mm_waitrequest_i => s_dut_avm_4_waitrequest,
            avalon_mm_address_o     => s_dut_avm_4_address,
            avalon_mm_write_o       => s_dut_avm_4_write,
            avalon_mm_writedata_o   => s_dut_avm_4_writedata,
            avalon_mm_read_o        => s_dut_avm_4_read
        );

    avalon_master_5_stimuli_inst : entity work.avalon_master_5_stimuli
        generic map(
            g_ADDRESS_WIDTH => 64,
            g_DATA_WIDTH    => 64
        )
        port map(
            clk_i                   => clk100,
            rst_i                   => rst,
            avalon_mm_readdata_i    => s_dut_avm_5_readdata,
            avalon_mm_waitrequest_i => s_dut_avm_5_waitrequest,
            avalon_mm_address_o     => s_dut_avm_5_address,
            avalon_mm_write_o       => s_dut_avm_5_write,
            avalon_mm_writedata_o   => s_dut_avm_5_writedata,
            avalon_mm_read_o        => s_dut_avm_5_read
        );

    avalon_master_6_stimuli_inst : entity work.avalon_master_6_stimuli
        generic map(
            g_ADDRESS_WIDTH => 64,
            g_DATA_WIDTH    => 64
        )
        port map(
            clk_i                   => clk100,
            rst_i                   => rst,
            avalon_mm_readdata_i    => s_dut_avm_6_readdata,
            avalon_mm_waitrequest_i => s_dut_avm_6_waitrequest,
            avalon_mm_address_o     => s_dut_avm_6_address,
            avalon_mm_write_o       => s_dut_avm_6_write,
            avalon_mm_writedata_o   => s_dut_avm_6_writedata,
            avalon_mm_read_o        => s_dut_avm_6_read
        );

    avalon_master_7_stimuli_inst : entity work.avalon_master_7_stimuli
        generic map(
            g_ADDRESS_WIDTH => 64,
            g_DATA_WIDTH    => 64
        )
        port map(
            clk_i                   => clk100,
            rst_i                   => rst,
            avalon_mm_readdata_i    => s_dut_avm_7_readdata,
            avalon_mm_waitrequest_i => s_dut_avm_7_waitrequest,
            avalon_mm_address_o     => s_dut_avm_7_address,
            avalon_mm_write_o       => s_dut_avm_7_write,
            avalon_mm_writedata_o   => s_dut_avm_7_writedata,
            avalon_mm_read_o        => s_dut_avm_7_read
        );

    avalon_slave_stimulli_read_inst : entity work.avalon_slave_stimulli_read
        port map(
            clk_i                   => clk100,
            rst_i                   => rst,
            avalon_mm_i.address     => s_dut_avs_address,
            avalon_mm_i.read        => s_dut_avs_read,
            avalon_mm_i.byteenable  => "11111111",
            avalon_mm_o.readdata    => s_dut_avs_readdata,
            avalon_mm_o.waitrequest => s_dut_avs_rd_waitrequest
        );

    avalon_slave_stimulli_write_inst : entity work.avalon_slave_stimulli_write
        port map(
            clk_i                   => clk100,
            rst_i                   => rst,
            avalon_mm_i.address     => s_dut_avs_address,
            avalon_mm_i.write       => s_dut_avs_write,
            avalon_mm_i.writedata   => s_dut_avs_writedata,
            avalon_mm_i.byteenable  => "11111111",
            avalon_mm_o.waitrequest => s_dut_avs_wr_waitrequest
        );

    s_dut_avs_waitrequest <= (s_dut_avs_rd_waitrequest) and (s_dut_avs_wr_waitrequest);

end architecture RTL;
