library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_uart_pkg.all;
use work.avalon_mm_uart_registers_pkg.all;

entity avalon_mm_uart_read_ent is
	port(
		clk_i                  : in  std_logic;
		rst_i                  : in  std_logic;
		avalon_mm_uart_i       : in  t_avalon_mm_uart_read_in;
		uart_write_registers_i : in  t_uart_write_registers;
		uart_read_registers_i  : in  t_uart_read_registers;
		avalon_mm_uart_o       : out t_avalon_mm_uart_read_out
	);
end entity avalon_mm_uart_read_ent;

architecture RTL of avalon_mm_uart_read_ent is

begin

	p_avalon_mm_uart_read : process(clk_i, rst_i) is
		procedure p_readdata(read_address_i : t_avalon_mm_uart_address) is
		begin

			-- Registers Data Read
			case (read_address_i) is
				-- Case for access to all registers address

				when (16#00#) =>
					-- UART Tx Buffer Control Register : Tx Buffer Write Requisition
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(0) <= uart_write_registers_i.uart_tx_buffer_control_reg.uart_tx_wrreq;
					end if;

				when (16#01#) =>
					-- UART Tx Buffer Control Register : Tx Buffer Write Data
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(7 downto 0) <= uart_write_registers_i.uart_tx_buffer_control_reg.uart_tx_wrdata;
					end if;

				when (16#02#) =>
					-- UART Tx Buffer Status Register : Tx Buffer Full
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(0) <= uart_read_registers_i.uart_tx_buffer_status_reg.uart_tx_full;
					end if;

				when (16#03#) =>
					-- UART Tx Buffer Status Register : Tx Buffer Used Words [Bytes]
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(7 downto 0) <= uart_read_registers_i.uart_tx_buffer_status_reg.uart_tx_usedw(7 downto 0);
					end if;
					if (avalon_mm_uart_i.byteenable(1) = '1') then
						avalon_mm_uart_o.readdata(14 downto 8) <= uart_read_registers_i.uart_tx_buffer_status_reg.uart_tx_usedw(14 downto 8);
					end if;

				when (16#04#) =>
					-- UART Rx Buffer Control Register : Rx Buffer Read Requisition
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(0) <= uart_write_registers_i.uart_rx_buffer_control_reg.uart_rx_rdreq;
					end if;

				when (16#05#) =>
					-- UART Rx Buffer Status Register : Rx Buffer Empty
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(0) <= uart_read_registers_i.uart_rx_buffer_status_reg.uart_rx_empty;
					end if;

				when (16#06#) =>
					-- UART Rx Buffer Status Register : Rx Buffer Read Data
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(7 downto 0) <= uart_read_registers_i.uart_rx_buffer_status_reg.uart_rx_rddata;
					end if;
					-- UART Rx Buffer Status Register : Rx Buffer Used Words [Bytes]
					if (avalon_mm_uart_i.byteenable(2) = '1') then
						avalon_mm_uart_o.readdata(23 downto 16) <= uart_read_registers_i.uart_rx_buffer_status_reg.uart_rx_usedw(7 downto 0);
					end if;
					if (avalon_mm_uart_i.byteenable(3) = '1') then
						avalon_mm_uart_o.readdata(30 downto 24) <= uart_read_registers_i.uart_rx_buffer_status_reg.uart_rx_usedw(14 downto 8);
					end if;

				when others =>
					-- No register associated to the address, return with 0x00000000
					avalon_mm_uart_o.readdata <= (others => '0');

			end case;

		end procedure p_readdata;

		variable v_read_address : t_avalon_mm_uart_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_uart_o.readdata    <= (others => '0');
			avalon_mm_uart_o.waitrequest <= '1';
			v_read_address               := 0;
		elsif (rising_edge(clk_i)) then
			avalon_mm_uart_o.readdata    <= (others => '0');
			avalon_mm_uart_o.waitrequest <= '1';
			if (avalon_mm_uart_i.read = '1') then
				v_read_address := to_integer(unsigned(avalon_mm_uart_i.address));
				-- check if the address is allowed
				if ((v_read_address >= c_AVALON_MM_UART_MIN_ADDR) and (v_read_address <= c_AVALON_MM_UART_MAX_ADDR)) then
					avalon_mm_uart_o.waitrequest <= '0';
					p_readdata(v_read_address);
				end if;
			end if;
		end if;

	end process p_avalon_mm_uart_read;

end architecture RTL;
