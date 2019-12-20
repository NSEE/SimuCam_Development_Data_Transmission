library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package avalon_mm_pkg is

	constant c_AVALON_MM_ADRESS_SIZE : natural := 8;
	constant c_AVALON_MM_DATA_SIZE   : natural := 32;
	constant c_AVALON_MM_SYMBOL_SIZE : natural := 8;

	subtype t_avalon_mm_address is natural range 0 to ((2 ** c_AVALON_MM_ADRESS_SIZE) - 1);

	type t_avalon_mm_read_in is record
		address    : std_logic_vector((c_AVALON_MM_ADRESS_SIZE - 1) downto 0);
		read       : std_logic;
		byteenable : std_logic_vector(((c_AVALON_MM_DATA_SIZE / c_AVALON_MM_SYMBOL_SIZE) - 1) downto 0);
	end record t_avalon_mm_read_in;

	type t_avalon_mm_read_out is record
		readdata    : std_logic_vector((c_AVALON_MM_DATA_SIZE - 1) downto 0);
		waitrequest : std_logic;
	end record t_avalon_mm_read_out;

	type t_avalon_mm_write_in is record
		address    : std_logic_vector((c_AVALON_MM_ADRESS_SIZE - 1) downto 0);
		write      : std_logic;
		writedata  : std_logic_vector((c_AVALON_MM_DATA_SIZE - 1) downto 0);
		byteenable : std_logic_vector(((c_AVALON_MM_DATA_SIZE / c_AVALON_MM_SYMBOL_SIZE) - 1) downto 0);
	end record t_avalon_mm_write_in;

	type t_avalon_mm_write_out is record
		waitrequest : std_logic;
	end record t_avalon_mm_write_out;

end package avalon_mm_pkg;
