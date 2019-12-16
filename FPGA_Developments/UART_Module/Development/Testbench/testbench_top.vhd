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
			reset_sink_reset         => rst,
			clock_sink_clk           => clk50,
			uart_txd                 => open,
			uart_rxd                 => '1',
			uart_rts                 => '1',
			uart_cts                 => open,
			avalon_slave_address     => s_config_avalon_stimuli_mm_address,
			avalon_slave_read        => s_config_avalon_stimuli_mm_read,
			avalon_slave_write       => s_config_avalon_stimuli_mm_write,
			avalon_slave_waitrequest => s_config_avalon_stimuli_mm_waitrequest,
			avalon_slave_writedata   => s_config_avalon_stimuli_mm_writedata,
			avalon_slave_readdata    => s_config_avalon_stimuli_mm_readdata
		);

end architecture RTL;
