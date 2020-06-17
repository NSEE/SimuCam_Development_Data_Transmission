library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package avalon_mm_uart_registers_pkg is

	-- Address Constants

	-- Allowed Addresses
	constant c_AVALON_MM_UART_MIN_ADDR : natural range 0 to 255 := 16#00#;
	constant c_AVALON_MM_UART_MAX_ADDR : natural range 0 to 255 := 16#06#;

	-- Registers Types

	-- UART Tx Buffer Control Register
	type t_uart_uart_tx_buffer_control_wr_reg is record
		uart_tx_wrreq  : std_logic;     -- Tx Buffer Write Requisition
		uart_tx_wrdata : std_logic_vector(7 downto 0); -- Tx Buffer Write Data
	end record t_uart_uart_tx_buffer_control_wr_reg;

	-- UART Tx Buffer Status Register
	type t_uart_uart_tx_buffer_status_rd_reg is record
		uart_tx_full  : std_logic;      -- Tx Buffer Full
		uart_tx_usedw : std_logic_vector(14 downto 0); -- Tx Buffer Used Words [Bytes]
	end record t_uart_uart_tx_buffer_status_rd_reg;

	-- UART Rx Buffer Control Register
	type t_uart_uart_rx_buffer_control_wr_reg is record
		uart_rx_rdreq : std_logic;      -- Rx Buffer Read Requisition
	end record t_uart_uart_rx_buffer_control_wr_reg;

	-- UART Rx Buffer Status Register
	type t_uart_uart_rx_buffer_status_rd_reg is record
		uart_rx_empty  : std_logic;     -- Rx Buffer Empty
		uart_rx_rddata : std_logic_vector(7 downto 0); -- Rx Buffer Read Data
		uart_rx_usedw  : std_logic_vector(14 downto 0); -- Rx Buffer Used Words [Bytes]
	end record t_uart_uart_rx_buffer_status_rd_reg;

	-- Avalon MM Types

	-- Avalon MM Read/Write Registers
	type t_uart_write_registers is record
		uart_tx_buffer_control_reg : t_uart_uart_tx_buffer_control_wr_reg; -- UART Tx Buffer Control Register
		uart_rx_buffer_control_reg : t_uart_uart_rx_buffer_control_wr_reg; -- UART Rx Buffer Control Register
	end record t_uart_write_registers;

	-- Avalon MM Read-Only Registers
	type t_uart_read_registers is record
		uart_tx_buffer_status_reg : t_uart_uart_tx_buffer_status_rd_reg; -- UART Tx Buffer Status Register
		uart_rx_buffer_status_reg : t_uart_uart_rx_buffer_status_rd_reg; -- UART Rx Buffer Status Register
	end record t_uart_read_registers;

end package avalon_mm_uart_registers_pkg;

package body avalon_mm_uart_registers_pkg is

end package body avalon_mm_uart_registers_pkg;
