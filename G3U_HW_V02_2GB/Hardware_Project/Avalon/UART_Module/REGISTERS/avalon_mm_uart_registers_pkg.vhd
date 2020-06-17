library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package avalon_mm_uart_registers_pkg is

	-- Address Constants

	-- Allowed Addresses
	constant c_AVALON_MM_UART_MIN_ADDR : natural range 0 to 255 := 16#00#;
	constant c_AVALON_MM_UART_MAX_ADDR : natural range 0 to 255 := 16#12#;

	-- Registers Types

	-- UART Tx Buffer Control Register
	type t_uart_tx_buffer_control_wr_reg is record
		tx_wrreq  : std_logic;          -- Tx Buffer Write Requisition
		tx_wrdata : std_logic_vector(7 downto 0); -- Tx Buffer Write Data
	end record t_uart_tx_buffer_control_wr_reg;

	-- UART Tx Buffer Status Register
	type t_uart_tx_buffer_status_rd_reg is record
		tx_full  : std_logic;           -- Tx Buffer Full
		tx_usedw : std_logic_vector(14 downto 0); -- Tx Buffer Used Words [Bytes]
	end record t_uart_tx_buffer_status_rd_reg;

	-- UART Rx Buffer Control Register
	type t_uart_rx_buffer_control_wr_reg is record
		rx_rdreq : std_logic;           -- Rx Buffer Read Requisition
	end record t_uart_rx_buffer_control_wr_reg;

	-- UART Rx Buffer Status Register
	type t_uart_rx_buffer_status_rd_reg is record
		rx_empty  : std_logic;          -- Rx Buffer Empty
		rx_rddata : std_logic_vector(7 downto 0); -- Rx Buffer Read Data
		rx_usedw  : std_logic_vector(14 downto 0); -- Rx Buffer Used Words [Bytes]
	end record t_uart_rx_buffer_status_rd_reg;

	-- UART Tx Data Control Register
	type t_uart_tx_data_control_wr_reg is record
		tx_rd_initial_addr_high_dword : std_logic_vector(31 downto 0); -- Tx Initial Read Address [High Dword]
		tx_rd_initial_addr_low_dword  : std_logic_vector(31 downto 0); -- Tx Initial Read Address [Low Dword]
		tx_rd_data_length_bytes       : std_logic_vector(31 downto 0); -- Tx Read Data Length [Bytes]
		tx_rd_start                   : std_logic; -- Tx Data Read Start
		tx_rd_reset                   : std_logic; -- Tx Data Read Reset
	end record t_uart_tx_data_control_wr_reg;

	-- UART Tx Data Status Register
	type t_uart_tx_data_status_rd_reg is record
		tx_rd_busy : std_logic;         -- Tx Data Read Busy
	end record t_uart_tx_data_status_rd_reg;

	-- UART Rx Data Control Register
	type t_uart_rx_data_control_wr_reg is record
		rx_wr_initial_addr_high_dword : std_logic_vector(31 downto 0); -- Rx Initial Write Address [High Dword]
		rx_wr_initial_addr_low_dword  : std_logic_vector(31 downto 0); -- Rx Initial Write Address [Low Dword]
		rx_wr_data_length_bytes       : std_logic_vector(31 downto 0); -- Rx Write Data Length [Bytes]
		rx_wr_start                   : std_logic; -- Rx Data Write Start
		rx_wr_reset                   : std_logic; -- Rx Data Write Reset
	end record t_uart_rx_data_control_wr_reg;

	-- UART Rx Data Status Register
	type t_uart_rx_data_status_rd_reg is record
		rx_wr_busy : std_logic;         -- Rx Data Write Busy
	end record t_uart_rx_data_status_rd_reg;

	-- Avalon MM Types

	-- Avalon MM Read/Write Registers
	type t_uart_write_registers is record
		tx_buffer_control_reg : t_uart_tx_buffer_control_wr_reg; -- UART Tx Buffer Control Register
		rx_buffer_control_reg : t_uart_rx_buffer_control_wr_reg; -- UART Rx Buffer Control Register
		tx_data_control_reg   : t_uart_tx_data_control_wr_reg; -- UART Tx Data Control Register
		rx_data_control_reg   : t_uart_rx_data_control_wr_reg; -- UART Rx Data Control Register
	end record t_uart_write_registers;

	-- Avalon MM Read-Only Registers
	type t_uart_read_registers is record
		tx_buffer_status_reg : t_uart_tx_buffer_status_rd_reg; -- UART Tx Buffer Status Register
		rx_buffer_status_reg : t_uart_rx_buffer_status_rd_reg; -- UART Rx Buffer Status Register
		tx_data_status_reg   : t_uart_tx_data_status_rd_reg; -- UART Tx Data Status Register
		rx_data_status_reg   : t_uart_rx_data_status_rd_reg; -- UART Rx Data Status Register
	end record t_uart_read_registers;

end package avalon_mm_uart_registers_pkg;

package body avalon_mm_uart_registers_pkg is

end package body avalon_mm_uart_registers_pkg;
