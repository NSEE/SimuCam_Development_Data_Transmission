library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package srme_rmap_mem_area_subunit_pkg is

	constant c_SRME_SUBUNIT_RMAP_ADRESS_SIZE : natural := 32;
	constant c_SRME_SUBUNIT_RMAP_DATA_SIZE   : natural := 8;
	constant c_SRME_SUBUNIT_RMAP_SYMBOL_SIZE : natural := 8;

	type t_srme_subunit_rmap_read_in is record
		address : std_logic_vector((c_SRME_SUBUNIT_RMAP_ADRESS_SIZE - 1) downto 0);
		read    : std_logic;
	end record t_srme_subunit_rmap_read_in;

	type t_srme_subunit_rmap_read_out is record
		readdata    : std_logic_vector((c_SRME_SUBUNIT_RMAP_DATA_SIZE - 1) downto 0);
		waitrequest : std_logic;
	end record t_srme_subunit_rmap_read_out;

	type t_srme_subunit_rmap_write_in is record
		address   : std_logic_vector((c_SRME_SUBUNIT_RMAP_ADRESS_SIZE - 1) downto 0);
		write     : std_logic;
		writedata : std_logic_vector((c_SRME_SUBUNIT_RMAP_DATA_SIZE - 1) downto 0);
	end record t_srme_subunit_rmap_write_in;

	type t_srme_subunit_rmap_write_out is record
		waitrequest : std_logic;
	end record t_srme_subunit_rmap_write_out;

	constant c_SRME_SUBUNIT_RMAP_READ_IN_RST : t_srme_subunit_rmap_read_in := (
		address => (others => '0'),
		read    => '0'
	);

	constant c_SRME_SUBUNIT_RMAP_READ_OUT_RST : t_srme_subunit_rmap_read_out := (
		readdata    => (others => '0'),
		waitrequest => '1'
	);

	constant c_SRME_SUBUNIT_RMAP_WRITE_IN_RST : t_srme_subunit_rmap_write_in := (
		address   => (others => '0'),
		write     => '0',
		writedata => (others => '0')
	);

	constant c_SRME_SUBUNIT_RMAP_WRITE_OUT_RST : t_srme_subunit_rmap_write_out := (
		waitrequest => '1'
	);

	-- Address Constants
	constant c_SRME_SUBUNIT_MEMORY_AREA_WIDTH : natural := 8; -- 2**8 = 256 bytes of memory area
	constant c_SRME_SUBUNIT_MEMORY_AREA_ADDR_MASK : std_logic_vector((31 - c_SRME_SUBUNIT_MEMORY_AREA_WIDTH) downto 0) := (others => '0');

	-- Allowed Addresses

	-- Registers Types

	-- RMAP Area Subunit Register
	type t_subunit_area_wr_reg is array (0 to ((2**c_SRME_SUBUNIT_MEMORY_AREA_WIDTH) - 1)) of std_logic_vector(7 downto 0); -- Subunit Area Array

	-- RMAP Read/Write Registers
	type t_rmap_memory_wr_area is record
		reg_subunit_area : t_subunit_area_wr_reg; -- RMAP Area Register

	end record t_rmap_memory_wr_area;

	-- Avalon MM Read-Only Registers
	type t_rmap_memory_rd_area is record
		reg_dummy : std_logic;          -- Dummy Register
	end record t_rmap_memory_rd_area;

end package srme_rmap_mem_area_subunit_pkg;

package body srme_rmap_mem_area_subunit_pkg is
end package body srme_rmap_mem_area_subunit_pkg;
