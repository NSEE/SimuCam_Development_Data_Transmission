library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package avalon_mm_registers_pkg is
	-- Address Constants

	-- Allowed Addresses
	constant c_AVALON_MM_MIN_ADDR : natural range 0 to 255 := 16#00#;
	constant c_AVALON_MM_MAX_ADDR : natural range 0 to 255 := 16#07#;

	-- Registers Types

	-- Avalon MM Types

	-- Avalon MM Read/Write Registers
	type t_write_registers is record
		uart_tx_wrreq  : std_logic;
		uart_tx_wrdata : std_logic_vector(7 downto 0);
		uart_rx_rdreq  : std_logic;
	end record t_write_registers;

	-- Avalon MM Read-Only Registers
	type t_read_registers is record
		uart_tx_full   : std_logic;
		uart_tx_usedw  : std_logic_vector(14 downto 0);
		uart_rx_empty  : std_logic;
		uart_rx_rddata : std_logic_vector(7 downto 0);
		uart_rx_usedw  : std_logic_vector(14 downto 0);
	end record t_read_registers;

end package avalon_mm_registers_pkg;

package body avalon_mm_registers_pkg is

end package body avalon_mm_registers_pkg;
