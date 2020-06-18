library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_top is
end entity testbench_top;

architecture RTL of testbench_top is

	-- clk and rst signals
	signal clk50 : std_logic := '0';
	signal rst   : std_logic := '1';

	-- dut signals
	signal br115200 : std_logic := '0';
	signal brdelay1 : std_logic := '1';
	signal brdelay2 : std_logic := '0';
	signal brsignal : std_logic := '1';

	-- config_avalon_stimuli signals
	signal s_config_avalon_stimuli_mm_readdata    : std_logic_vector(31 downto 0); -- -- avalon_mm.readdata
	signal s_config_avalon_stimuli_mm_waitrequest : std_logic; --                                     --          .waitrequest
	signal s_config_avalon_stimuli_mm_address     : std_logic_vector(7 downto 0); --          .address
	signal s_config_avalon_stimuli_mm_write       : std_logic; --                                     --          .write
	signal s_config_avalon_stimuli_mm_writedata   : std_logic_vector(31 downto 0); -- --          .writedata
	signal s_config_avalon_stimuli_mm_read        : std_logic; --                                     --          .read

begin

	clk50 <= not clk50 after 10 ns;     -- 50 MHz
	rst   <= '0' after 100 ns;

	--	br115200 <= not br115200 after 8680.56 * 0.55 ns; -- 115200 - 45% bps
	br115200 <= not br115200 after 8680.56 ns; -- 115200 bps
	--	br115200 <= not br115200 after 8680.56 * 1.45 ns; -- 115200 + 45% bps
	brdelay1 <= '0' after 34722240 ps;
	brdelay2 <= '1' after 121527840 ps;
	--	brsignal <= (br115200) or (brdelay1) or (brdelay2);
	brsignal <= (br115200) or (brdelay1);

	config_avalon_stimuli_inst : entity work.config_avalon_stimuli
		generic map(
			g_ADDRESS_WIDTH => 8,
			g_DATA_WIDTH    => 32
		)
		port map(
			clk_i                   => clk50,
			rst_i                   => rst,
			avalon_mm_readdata_i    => s_config_avalon_stimuli_mm_readdata,
			avalon_mm_waitrequest_i => s_config_avalon_stimuli_mm_waitrequest,
			avalon_mm_address_o     => s_config_avalon_stimuli_mm_address,
			avalon_mm_write_o       => s_config_avalon_stimuli_mm_write,
			avalon_mm_writedata_o   => s_config_avalon_stimuli_mm_writedata,
			avalon_mm_read_o        => s_config_avalon_stimuli_mm_read
		);

	uart_module_top_inst : entity work.uart_module_top
		port map(
			reset_sink_reset_i                => rst,
			clock_sink_100_clk_i              => clk50,
			avalon_slave_uart_address_i       => s_config_avalon_stimuli_mm_address,
			avalon_slave_uart_byteenable_i    => (others => '1'),
			avalon_slave_uart_write_i         => s_config_avalon_stimuli_mm_write,
			avalon_slave_uart_writedata_i     => s_config_avalon_stimuli_mm_writedata,
			avalon_slave_uart_read_i          => s_config_avalon_stimuli_mm_read,
			avalon_slave_uart_readdata_o      => s_config_avalon_stimuli_mm_readdata,
			avalon_slave_uart_waitrequest_o   => s_config_avalon_stimuli_mm_waitrequest,
			avalon_master_data_readdata_i     => (others => '0'),
			avalon_master_data_waitrequest_i  => '1',
			avalon_master_data_address_o      => open,
			avalon_master_data_read_o         => open,
			avalon_master_data_write_o        => open,
			avalon_master_data_writedata_o    => open,
			avalon_master_rs232_readdata_i    => (others => '0'),
			avalon_master_rs232_waitrequest_i => '1',
			avalon_master_rs232_address_o     => open,
			avalon_master_rs232_write_o       => open,
			avalon_master_rs232_writedata_o   => open,
			avalon_master_rs232_read_o        => open
		);

end architecture RTL;
