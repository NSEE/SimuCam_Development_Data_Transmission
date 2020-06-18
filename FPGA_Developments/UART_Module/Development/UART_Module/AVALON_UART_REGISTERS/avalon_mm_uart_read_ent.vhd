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
						avalon_mm_uart_o.readdata(0) <= uart_write_registers_i.tx_buffer_control_reg.tx_wrreq;
					end if;

				when (16#01#) =>
					-- UART Tx Buffer Control Register : Tx Buffer Write Data
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(7 downto 0) <= uart_write_registers_i.tx_buffer_control_reg.tx_wrdata;
					end if;

				when (16#02#) =>
					-- UART Tx Buffer Status Register : Tx Buffer Full
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(0) <= uart_read_registers_i.tx_buffer_status_reg.tx_full;
					end if;

				when (16#03#) =>
					-- UART Tx Buffer Status Register : Tx Buffer Used Words [Bytes]
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(7 downto 0) <= uart_read_registers_i.tx_buffer_status_reg.tx_usedw(7 downto 0);
					end if;
					if (avalon_mm_uart_i.byteenable(1) = '1') then
						avalon_mm_uart_o.readdata(14 downto 8) <= uart_read_registers_i.tx_buffer_status_reg.tx_usedw(14 downto 8);
					end if;

				when (16#04#) =>
					-- UART Rx Buffer Control Register : Rx Buffer Read Requisition
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(0) <= uart_write_registers_i.rx_buffer_control_reg.rx_rdreq;
					end if;

				when (16#05#) =>
					-- UART Rx Buffer Status Register : Rx Buffer Empty
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(0) <= uart_read_registers_i.rx_buffer_status_reg.rx_empty;
					end if;

				when (16#06#) =>
					-- UART Rx Buffer Status Register : Rx Buffer Read Data
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(7 downto 0) <= uart_read_registers_i.rx_buffer_status_reg.rx_rddata;
					end if;
					-- UART Rx Buffer Status Register : Rx Buffer Used Words [Bytes]
					if (avalon_mm_uart_i.byteenable(2) = '1') then
						avalon_mm_uart_o.readdata(23 downto 16) <= uart_read_registers_i.rx_buffer_status_reg.rx_usedw(7 downto 0);
					end if;
					if (avalon_mm_uart_i.byteenable(3) = '1') then
						avalon_mm_uart_o.readdata(30 downto 24) <= uart_read_registers_i.rx_buffer_status_reg.rx_usedw(14 downto 8);
					end if;

				when (16#07#) =>
					-- UART Tx Data Control Register : Tx Initial Read Address [High Dword]
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(7 downto 0) <= uart_write_registers_i.tx_data_control_reg.tx_rd_initial_addr_high_dword(7 downto 0);
					end if;
					if (avalon_mm_uart_i.byteenable(1) = '1') then
						avalon_mm_uart_o.readdata(15 downto 8) <= uart_write_registers_i.tx_data_control_reg.tx_rd_initial_addr_high_dword(15 downto 8);
					end if;
					if (avalon_mm_uart_i.byteenable(2) = '1') then
						avalon_mm_uart_o.readdata(23 downto 16) <= uart_write_registers_i.tx_data_control_reg.tx_rd_initial_addr_high_dword(23 downto 16);
					end if;
					if (avalon_mm_uart_i.byteenable(3) = '1') then
						avalon_mm_uart_o.readdata(31 downto 24) <= uart_write_registers_i.tx_data_control_reg.tx_rd_initial_addr_high_dword(31 downto 24);
					end if;

				when (16#08#) =>
					-- UART Tx Data Control Register : Tx Initial Read Address [Low Dword]
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(7 downto 0) <= uart_write_registers_i.tx_data_control_reg.tx_rd_initial_addr_low_dword(7 downto 0);
					end if;
					if (avalon_mm_uart_i.byteenable(1) = '1') then
						avalon_mm_uart_o.readdata(15 downto 8) <= uart_write_registers_i.tx_data_control_reg.tx_rd_initial_addr_low_dword(15 downto 8);
					end if;
					if (avalon_mm_uart_i.byteenable(2) = '1') then
						avalon_mm_uart_o.readdata(23 downto 16) <= uart_write_registers_i.tx_data_control_reg.tx_rd_initial_addr_low_dword(23 downto 16);
					end if;
					if (avalon_mm_uart_i.byteenable(3) = '1') then
						avalon_mm_uart_o.readdata(31 downto 24) <= uart_write_registers_i.tx_data_control_reg.tx_rd_initial_addr_low_dword(31 downto 24);
					end if;

				when (16#09#) =>
					-- UART Tx Data Control Register : Tx Read Data Length [Bytes]
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(7 downto 0) <= uart_write_registers_i.tx_data_control_reg.tx_rd_data_length_bytes(7 downto 0);
					end if;
					if (avalon_mm_uart_i.byteenable(1) = '1') then
						avalon_mm_uart_o.readdata(15 downto 8) <= uart_write_registers_i.tx_data_control_reg.tx_rd_data_length_bytes(15 downto 8);
					end if;
					if (avalon_mm_uart_i.byteenable(2) = '1') then
						avalon_mm_uart_o.readdata(23 downto 16) <= uart_write_registers_i.tx_data_control_reg.tx_rd_data_length_bytes(23 downto 16);
					end if;
					if (avalon_mm_uart_i.byteenable(3) = '1') then
						avalon_mm_uart_o.readdata(31 downto 24) <= uart_write_registers_i.tx_data_control_reg.tx_rd_data_length_bytes(31 downto 24);
					end if;

				when (16#0A#) =>
					-- UART Tx Data Control Register : Tx Data Read Start
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(0) <= uart_write_registers_i.tx_data_control_reg.tx_rd_start;
					end if;

				when (16#0B#) =>
					-- UART Tx Data Control Register : Tx Data Read Reset
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(0) <= uart_write_registers_i.tx_data_control_reg.tx_rd_reset;
					end if;

				when (16#0C#) =>
					-- UART Tx Data Status Register : Tx Data Read Busy
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(0) <= uart_read_registers_i.tx_data_status_reg.tx_rd_busy;
					end if;

				when (16#0D#) =>
					-- UART Rx Data Control Register : Rx Initial Write Address [High Dword]
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(7 downto 0) <= uart_write_registers_i.rx_data_control_reg.rx_wr_initial_addr_high_dword(7 downto 0);
					end if;
					if (avalon_mm_uart_i.byteenable(1) = '1') then
						avalon_mm_uart_o.readdata(15 downto 8) <= uart_write_registers_i.rx_data_control_reg.rx_wr_initial_addr_high_dword(15 downto 8);
					end if;
					if (avalon_mm_uart_i.byteenable(2) = '1') then
						avalon_mm_uart_o.readdata(23 downto 16) <= uart_write_registers_i.rx_data_control_reg.rx_wr_initial_addr_high_dword(23 downto 16);
					end if;
					if (avalon_mm_uart_i.byteenable(3) = '1') then
						avalon_mm_uart_o.readdata(31 downto 24) <= uart_write_registers_i.rx_data_control_reg.rx_wr_initial_addr_high_dword(31 downto 24);
					end if;

				when (16#0E#) =>
					-- UART Rx Data Control Register : Rx Initial Write Address [Low Dword]
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(7 downto 0) <= uart_write_registers_i.rx_data_control_reg.rx_wr_initial_addr_low_dword(7 downto 0);
					end if;
					if (avalon_mm_uart_i.byteenable(1) = '1') then
						avalon_mm_uart_o.readdata(15 downto 8) <= uart_write_registers_i.rx_data_control_reg.rx_wr_initial_addr_low_dword(15 downto 8);
					end if;
					if (avalon_mm_uart_i.byteenable(2) = '1') then
						avalon_mm_uart_o.readdata(23 downto 16) <= uart_write_registers_i.rx_data_control_reg.rx_wr_initial_addr_low_dword(23 downto 16);
					end if;
					if (avalon_mm_uart_i.byteenable(3) = '1') then
						avalon_mm_uart_o.readdata(31 downto 24) <= uart_write_registers_i.rx_data_control_reg.rx_wr_initial_addr_low_dword(31 downto 24);
					end if;

				when (16#0F#) =>
					-- UART Rx Data Control Register : Rx Write Data Length [Bytes]
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(7 downto 0) <= uart_write_registers_i.rx_data_control_reg.rx_wr_data_length_bytes(7 downto 0);
					end if;
					if (avalon_mm_uart_i.byteenable(1) = '1') then
						avalon_mm_uart_o.readdata(15 downto 8) <= uart_write_registers_i.rx_data_control_reg.rx_wr_data_length_bytes(15 downto 8);
					end if;
					if (avalon_mm_uart_i.byteenable(2) = '1') then
						avalon_mm_uart_o.readdata(23 downto 16) <= uart_write_registers_i.rx_data_control_reg.rx_wr_data_length_bytes(23 downto 16);
					end if;
					if (avalon_mm_uart_i.byteenable(3) = '1') then
						avalon_mm_uart_o.readdata(31 downto 24) <= uart_write_registers_i.rx_data_control_reg.rx_wr_data_length_bytes(31 downto 24);
					end if;

				when (16#10#) =>
					-- UART Rx Data Control Register : Rx Data Write Start
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(0) <= uart_write_registers_i.rx_data_control_reg.rx_wr_start;
					end if;

				when (16#11#) =>
					-- UART Rx Data Control Register : Rx Data Write Reset
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(0) <= uart_write_registers_i.rx_data_control_reg.rx_wr_reset;
					end if;

				when (16#12#) =>
					-- UART Rx Data Status Register : Rx Data Write Busy
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						avalon_mm_uart_o.readdata(0) <= uart_read_registers_i.rx_data_status_reg.rx_wr_busy;
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
