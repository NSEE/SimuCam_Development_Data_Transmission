library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.srme_tb_avs_pkg.all;

entity testbench_top is
end entity testbench_top;

architecture RTL of testbench_top is

	-- clk and rst signals
	signal clk100 : std_logic := '0';
	signal rst    : std_logic := '1';

	-- dut signals

	-- rmap_avalon_stimuli signals
	signal s_rmap_avalon_stimuli_mm_readdata    : std_logic_vector(31 downto 0);
	signal s_rmap_avalon_stimuli_mm_waitrequest : std_logic;
	signal s_rmap_avalon_stimuli_mm_address     : std_logic_vector(11 downto 0);
	signal s_rmap_avalon_stimuli_mm_write       : std_logic;
	signal s_rmap_avalon_stimuli_mm_writedata   : std_logic_vector(31 downto 0);
	signal s_rmap_avalon_stimuli_mm_read        : std_logic;

	-- fee 0 rmap stimuli signals
	signal s_fee_0_rmap_stimuli_wr_address     : std_logic_vector(31 downto 0);
	signal s_fee_0_rmap_stimuli_write          : std_logic;
	signal s_fee_0_rmap_stimuli_writedata      : std_logic_vector(7 downto 0);
	signal s_fee_0_rmap_stimuli_rd_address     : std_logic_vector(31 downto 0);
	signal s_fee_0_rmap_stimuli_read           : std_logic;
	signal s_fee_0_rmap_stimuli_wr_waitrequest : std_logic;
	signal s_fee_0_rmap_stimuli_readdata       : std_logic_vector(7 downto 0);
	signal s_fee_0_rmap_stimuli_rd_waitrequest : std_logic;

	-- avm signals
	signal s_avm_readdata    : std_logic_vector(7 downto 0);
	signal s_avm_waitrequest : std_logic;
	signal s_avm_address     : std_logic_vector(63 downto 0);
	signal s_avm_write       : std_logic;
	signal s_avm_writedata   : std_logic_vector(7 downto 0);
	signal s_avm_read        : std_logic;

	-- tb avs signals
	signal s_tb_avs_rd_waitrequest : std_logic;
	signal s_tb_avs_wr_waitrequest : std_logic;

begin

	clk100 <= not clk100 after 5 ns;    -- 100 MHz
	rst    <= '0' after 100 ns;

	rmap_avalon_stimuli_inst : entity work.rmap_avalon_stimuli
		generic map(
			g_ADDRESS_WIDTH => 12,
			g_DATA_WIDTH    => 32
		)
		port map(
			clk_i                   => clk100,
			rst_i                   => rst,
			avalon_mm_readdata_i    => s_rmap_avalon_stimuli_mm_readdata,
			avalon_mm_waitrequest_i => s_rmap_avalon_stimuli_mm_waitrequest,
			avalon_mm_address_o     => s_rmap_avalon_stimuli_mm_address,
			avalon_mm_write_o       => s_rmap_avalon_stimuli_mm_write,
			avalon_mm_writedata_o   => s_rmap_avalon_stimuli_mm_writedata,
			avalon_mm_read_o        => s_rmap_avalon_stimuli_mm_read
		);

	fee_0_rmap_stimuli_inst : entity work.fee_0_rmap_stimuli
		generic map(
			g_ADDRESS_WIDTH => 32,
			g_DATA_WIDTH    => 8
		)
		port map(
			clk_i                       => clk100,
			rst_i                       => rst,
			fee_0_rmap_wr_waitrequest_i => s_fee_0_rmap_stimuli_wr_waitrequest,
			fee_0_rmap_readdata_i       => s_fee_0_rmap_stimuli_readdata,
			fee_0_rmap_rd_waitrequest_i => s_fee_0_rmap_stimuli_rd_waitrequest,
			fee_0_rmap_wr_address_o     => s_fee_0_rmap_stimuli_wr_address,
			fee_0_rmap_write_o          => s_fee_0_rmap_stimuli_write,
			fee_0_rmap_writedata_o      => s_fee_0_rmap_stimuli_writedata,
			fee_0_rmap_rd_address_o     => s_fee_0_rmap_stimuli_rd_address,
			fee_0_rmap_read_o           => s_fee_0_rmap_stimuli_read
		);

	srme_rmap_memory_subunit_area_top_inst : entity work.srme_rmap_memory_subunit_area_top
		port map(
			reset_i                         => rst,
			clk_100_i                       => clk100,
			subunit_0_rmap_wr_address_i     => s_fee_0_rmap_stimuli_wr_address,
			subunit_0_rmap_write_i          => s_fee_0_rmap_stimuli_write,
			subunit_0_rmap_writedata_i      => s_fee_0_rmap_stimuli_writedata,
			subunit_0_rmap_rd_address_i     => s_fee_0_rmap_stimuli_rd_address,
			subunit_0_rmap_read_i           => s_fee_0_rmap_stimuli_read,
			subunit_0_rmap_wr_waitrequest_o => s_fee_0_rmap_stimuli_wr_waitrequest,
			subunit_0_rmap_readdata_o       => s_fee_0_rmap_stimuli_readdata,
			subunit_0_rmap_rd_waitrequest_o => s_fee_0_rmap_stimuli_rd_waitrequest,
			rmap_mem_addr_offset_i          => (others => '0')
		);

	srme_tb_avs_read_ent_inst : entity work.srme_tb_avs_read_ent
		port map(
			clk_i                               => clk100,
			rst_i                               => rst,
			srme_tb_avs_avalon_mm_i.address     => s_avm_address,
			srme_tb_avs_avalon_mm_i.read        => s_avm_read,
			srme_tb_avs_avalon_mm_i.byteenable  => (others => '1'),
			srme_tb_avs_avalon_mm_o.readdata    => s_avm_readdata,
			srme_tb_avs_avalon_mm_o.waitrequest => s_tb_avs_rd_waitrequest
		);

	srme_tb_avs_write_ent_inst : entity work.srme_tb_avs_write_ent
		port map(
			clk_i                               => clk100,
			rst_i                               => rst,
			srme_tb_avs_avalon_mm_i.address     => s_avm_address,
			srme_tb_avs_avalon_mm_i.write       => s_avm_write,
			srme_tb_avs_avalon_mm_i.writedata   => s_avm_writedata,
			srme_tb_avs_avalon_mm_i.byteenable  => (others => '1'),
			srme_tb_avs_avalon_mm_o.waitrequest => s_tb_avs_wr_waitrequest
		);

end architecture RTL;
