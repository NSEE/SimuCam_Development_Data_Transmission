library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_pkg.all;
use work.avalon_mm_registers_pkg.all;

entity avalon_mm_read_ent is
	port(
		clk_i             : in  std_logic;
		rst_i             : in  std_logic;
		avalon_mm_i       : in  t_avalon_mm_read_in;
		avalon_mm_o       : out t_avalon_mm_read_out;
		write_registers_i : in  t_write_registers;
		read_registers_i  : in  t_read_registers
	);
end entity avalon_mm_read_ent;

architecture rtl of avalon_mm_read_ent is

begin

	p_avalon_mm_read : process(clk_i, rst_i) is
		procedure p_readdata(read_address_i : t_avalon_mm_address) is
		begin

			-- Registers Data Read
			case (read_address_i) is
				-- Case for access to all registers address

				when (16#00#) =>
					avalon_mm_o.readdata(0) <= write_registers_i.uart_tx_wrreq;

				when (16#01#) =>
					avalon_mm_o.readdata(7 downto 0) <= write_registers_i.uart_tx_wrdata;

				when (16#02#) =>
					avalon_mm_o.readdata(0) <= read_registers_i.uart_tx_full;

				when (16#03#) =>
					avalon_mm_o.readdata(0) <= write_registers_i.uart_rx_rdreq;

				when (16#04#) =>
					avalon_mm_o.readdata(0) <= read_registers_i.uart_rx_empty;

				when (16#05#) =>
					avalon_mm_o.readdata(7 downto 0) <= read_registers_i.uart_rx_rddata;

				when others =>
					-- No register associated to the address, return with 0x00000000
					avalon_mm_o.readdata <= (others => '0');

			end case;

		end procedure p_readdata;

		variable v_read_address : t_avalon_mm_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_o.readdata    <= (others => '0');
			avalon_mm_o.waitrequest <= '1';
			v_read_address          := 0;
		elsif (rising_edge(clk_i)) then
			avalon_mm_o.readdata    <= (others => '0');
			avalon_mm_o.waitrequest <= '1';
			if (avalon_mm_i.read = '1') then
				v_read_address := to_integer(unsigned(avalon_mm_i.address));
				-- check if the address is allowed
				if ((v_read_address >= c_AVALON_MM_MIN_ADDR) and (v_read_address <= c_AVALON_MM_MAX_ADDR)) then
					avalon_mm_o.waitrequest <= '0';
					p_readdata(v_read_address);
				end if;
			end if;
		end if;
	end process p_avalon_mm_read;

end architecture rtl;
