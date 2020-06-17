library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_uart_pkg.all;
use work.avalon_mm_uart_registers_pkg.all;

entity avalon_mm_uart_write_ent is
	port(
		clk_i                  : in  std_logic;
		rst_i                  : in  std_logic;
		avalon_mm_uart_i       : in  t_avalon_mm_uart_write_in;
		avalon_mm_uart_o       : out t_avalon_mm_uart_write_out;
		uart_write_registers_o : out t_uart_write_registers
	);
end entity avalon_mm_uart_write_ent;

architecture RTL of avalon_mm_uart_write_ent is

	signal s_data_acquired : std_logic;

begin

	p_avalon_mm_uart_write : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin

			-- Write Registers Reset/Default State

			-- UART Tx Buffer Control Register : Tx Buffer Write Requisition
			uart_write_registers_o.tx_buffer_control_reg.tx_wrreq                    <= '0';
			-- UART Tx Buffer Control Register : Tx Buffer Write Data
			uart_write_registers_o.tx_buffer_control_reg.tx_wrdata                   <= (others => '0');
			-- UART Rx Buffer Control Register : Rx Buffer Read Requisition
			uart_write_registers_o.rx_buffer_control_reg.rx_rdreq                    <= '0';
			-- UART Tx Data Control Register : Tx Initial Read Address [High Dword]
			uart_write_registers_o.tx_data_control_reg.tx_rd_initial_addr_high_dword <= (others => '0');
			-- UART Tx Data Control Register : Tx Initial Read Address [Low Dword]
			uart_write_registers_o.tx_data_control_reg.tx_rd_initial_addr_low_dword  <= (others => '0');
			-- UART Tx Data Control Register : Tx Read Data Length [Bytes]
			uart_write_registers_o.tx_data_control_reg.tx_rd_data_length_bytes       <= (others => '0');
			-- UART Tx Data Control Register : Tx Data Read Start
			uart_write_registers_o.tx_data_control_reg.tx_rd_start                   <= '0';
			-- UART Tx Data Control Register : Tx Data Read Reset
			uart_write_registers_o.tx_data_control_reg.tx_rd_reset                   <= '0';
			-- UART Rx Data Control Register : Rx Initial Write Address [High Dword]
			uart_write_registers_o.rx_data_control_reg.rx_wr_initial_addr_high_dword <= (others => '0');
			-- UART Rx Data Control Register : Rx Initial Write Address [Low Dword]
			uart_write_registers_o.rx_data_control_reg.rx_wr_initial_addr_low_dword  <= (others => '0');
			-- UART Rx Data Control Register : Rx Write Data Length [Bytes]
			uart_write_registers_o.rx_data_control_reg.rx_wr_data_length_bytes       <= (others => '0');
			-- UART Rx Data Control Register : Rx Data Write Start
			uart_write_registers_o.rx_data_control_reg.rx_wr_start                   <= '0';
			-- UART Rx Data Control Register : Rx Data Write Reset
			uart_write_registers_o.rx_data_control_reg.rx_wr_reset                   <= '0';

		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin

			-- Write Registers Triggers Reset

			-- UART Tx Buffer Control Register : Tx Buffer Write Requisition
			uart_write_registers_o.tx_buffer_control_reg.tx_wrreq  <= '0';
			-- UART Rx Buffer Control Register : Rx Buffer Read Requisition
			uart_write_registers_o.rx_buffer_control_reg.rx_rdreq  <= '0';
			-- UART Tx Data Control Register : Tx Data Read Start
			uart_write_registers_o.tx_data_control_reg.tx_rd_start <= '0';
			-- UART Tx Data Control Register : Tx Data Read Reset
			uart_write_registers_o.tx_data_control_reg.tx_rd_reset <= '0';
			-- UART Rx Data Control Register : Rx Data Write Start
			uart_write_registers_o.rx_data_control_reg.rx_wr_start <= '0';
			-- UART Rx Data Control Register : Rx Data Write Reset
			uart_write_registers_o.rx_data_control_reg.rx_wr_reset <= '0';

		end procedure p_control_triggers;

		procedure p_writedata(write_address_i : t_avalon_mm_uart_address) is
		begin

			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				when (16#00#) =>
					-- UART Tx Buffer Control Register : Tx Buffer Write Requisition
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						uart_write_registers_o.tx_buffer_control_reg.tx_wrreq <= avalon_mm_uart_i.writedata(0);
					end if;

				when (16#01#) =>
					-- UART Tx Buffer Control Register : Tx Buffer Write Data
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						uart_write_registers_o.tx_buffer_control_reg.tx_wrdata <= avalon_mm_uart_i.writedata(7 downto 0);
					end if;

				when (16#04#) =>
					-- UART Rx Buffer Control Register : Rx Buffer Read Requisition
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						uart_write_registers_o.rx_buffer_control_reg.rx_rdreq <= avalon_mm_uart_i.writedata(0);
					end if;

				when (16#07#) =>
					-- UART Tx Data Control Register : Tx Initial Read Address [High Dword]
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						uart_write_registers_o.tx_data_control_reg.tx_rd_initial_addr_high_dword(7 downto 0) <= avalon_mm_uart_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_uart_i.byteenable(1) = '1') then
						uart_write_registers_o.tx_data_control_reg.tx_rd_initial_addr_high_dword(15 downto 8) <= avalon_mm_uart_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_uart_i.byteenable(2) = '1') then
						uart_write_registers_o.tx_data_control_reg.tx_rd_initial_addr_high_dword(23 downto 16) <= avalon_mm_uart_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_uart_i.byteenable(3) = '1') then
						uart_write_registers_o.tx_data_control_reg.tx_rd_initial_addr_high_dword(31 downto 24) <= avalon_mm_uart_i.writedata(31 downto 24);
					end if;

				when (16#08#) =>
					-- UART Tx Data Control Register : Tx Initial Read Address [Low Dword]
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						uart_write_registers_o.tx_data_control_reg.tx_rd_initial_addr_low_dword(7 downto 0) <= avalon_mm_uart_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_uart_i.byteenable(1) = '1') then
						uart_write_registers_o.tx_data_control_reg.tx_rd_initial_addr_low_dword(15 downto 8) <= avalon_mm_uart_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_uart_i.byteenable(2) = '1') then
						uart_write_registers_o.tx_data_control_reg.tx_rd_initial_addr_low_dword(23 downto 16) <= avalon_mm_uart_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_uart_i.byteenable(3) = '1') then
						uart_write_registers_o.tx_data_control_reg.tx_rd_initial_addr_low_dword(31 downto 24) <= avalon_mm_uart_i.writedata(31 downto 24);
					end if;

				when (16#09#) =>
					-- UART Tx Data Control Register : Tx Read Data Length [Bytes]
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						uart_write_registers_o.tx_data_control_reg.tx_rd_data_length_bytes(7 downto 0) <= avalon_mm_uart_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_uart_i.byteenable(1) = '1') then
						uart_write_registers_o.tx_data_control_reg.tx_rd_data_length_bytes(15 downto 8) <= avalon_mm_uart_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_uart_i.byteenable(2) = '1') then
						uart_write_registers_o.tx_data_control_reg.tx_rd_data_length_bytes(23 downto 16) <= avalon_mm_uart_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_uart_i.byteenable(3) = '1') then
						uart_write_registers_o.tx_data_control_reg.tx_rd_data_length_bytes(31 downto 24) <= avalon_mm_uart_i.writedata(31 downto 24);
					end if;

				when (16#0A#) =>
					-- UART Tx Data Control Register : Tx Data Read Start
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						uart_write_registers_o.tx_data_control_reg.tx_rd_start <= avalon_mm_uart_i.writedata(0);
					end if;

				when (16#0B#) =>
					-- UART Tx Data Control Register : Tx Data Read Reset
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						uart_write_registers_o.tx_data_control_reg.tx_rd_reset <= avalon_mm_uart_i.writedata(0);
					end if;

				when (16#0D#) =>
					-- UART Rx Data Control Register : Rx Initial Write Address [High Dword]
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						uart_write_registers_o.rx_data_control_reg.rx_wr_initial_addr_high_dword(7 downto 0) <= avalon_mm_uart_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_uart_i.byteenable(1) = '1') then
						uart_write_registers_o.rx_data_control_reg.rx_wr_initial_addr_high_dword(15 downto 8) <= avalon_mm_uart_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_uart_i.byteenable(2) = '1') then
						uart_write_registers_o.rx_data_control_reg.rx_wr_initial_addr_high_dword(23 downto 16) <= avalon_mm_uart_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_uart_i.byteenable(3) = '1') then
						uart_write_registers_o.rx_data_control_reg.rx_wr_initial_addr_high_dword(31 downto 24) <= avalon_mm_uart_i.writedata(31 downto 24);
					end if;

				when (16#0E#) =>
					-- UART Rx Data Control Register : Rx Initial Write Address [Low Dword]
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						uart_write_registers_o.rx_data_control_reg.rx_wr_initial_addr_low_dword(7 downto 0) <= avalon_mm_uart_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_uart_i.byteenable(1) = '1') then
						uart_write_registers_o.rx_data_control_reg.rx_wr_initial_addr_low_dword(15 downto 8) <= avalon_mm_uart_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_uart_i.byteenable(2) = '1') then
						uart_write_registers_o.rx_data_control_reg.rx_wr_initial_addr_low_dword(23 downto 16) <= avalon_mm_uart_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_uart_i.byteenable(3) = '1') then
						uart_write_registers_o.rx_data_control_reg.rx_wr_initial_addr_low_dword(31 downto 24) <= avalon_mm_uart_i.writedata(31 downto 24);
					end if;

				when (16#0F#) =>
					-- UART Rx Data Control Register : Rx Write Data Length [Bytes]
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						uart_write_registers_o.rx_data_control_reg.rx_wr_data_length_bytes(7 downto 0) <= avalon_mm_uart_i.writedata(7 downto 0);
					end if;
					if (avalon_mm_uart_i.byteenable(1) = '1') then
						uart_write_registers_o.rx_data_control_reg.rx_wr_data_length_bytes(15 downto 8) <= avalon_mm_uart_i.writedata(15 downto 8);
					end if;
					if (avalon_mm_uart_i.byteenable(2) = '1') then
						uart_write_registers_o.rx_data_control_reg.rx_wr_data_length_bytes(23 downto 16) <= avalon_mm_uart_i.writedata(23 downto 16);
					end if;
					if (avalon_mm_uart_i.byteenable(3) = '1') then
						uart_write_registers_o.rx_data_control_reg.rx_wr_data_length_bytes(31 downto 24) <= avalon_mm_uart_i.writedata(31 downto 24);
					end if;

				when (16#10#) =>
					-- UART Rx Data Control Register : Rx Data Write Start
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						uart_write_registers_o.rx_data_control_reg.rx_wr_start <= avalon_mm_uart_i.writedata(0);
					end if;

				when (16#11#) =>
					-- UART Rx Data Control Register : Rx Data Write Reset
					if (avalon_mm_uart_i.byteenable(0) = '1') then
						uart_write_registers_o.rx_data_control_reg.rx_wr_reset <= avalon_mm_uart_i.writedata(0);
					end if;

				when others =>
					-- No register associated to the address, do nothing
					null;

			end case;

		end procedure p_writedata;

		variable v_write_address : t_avalon_mm_uart_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_uart_o.waitrequest <= '1';
			s_data_acquired              <= '0';
			v_write_address              := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			avalon_mm_uart_o.waitrequest <= '1';
			p_control_triggers;
			s_data_acquired              <= '0';
			if (avalon_mm_uart_i.write = '1') then
				v_write_address := to_integer(unsigned(avalon_mm_uart_i.address));
				-- check if the address is allowed
				if ((v_write_address >= c_AVALON_MM_UART_MIN_ADDR) and (v_write_address <= c_AVALON_MM_UART_MAX_ADDR)) then
					avalon_mm_uart_o.waitrequest <= '0';
					s_data_acquired              <= '1';
					if (s_data_acquired = '0') then
						p_writedata(v_write_address);
					end if;
				end if;
			end if;
		end if;
	end process p_avalon_mm_uart_write;

end architecture RTL;
