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

	--
	constant c_SRME_SUBUNIT_MEMORY_AREA_WIDTH     : natural                                                            := 12; -- 2**12 = 4096 bytes of memory area
	constant c_SRME_SUBUNIT_MEMORY_AREA_LENGTH    : natural                                                            := 2**c_SRME_SUBUNIT_MEMORY_AREA_WIDTH; -- 2**12 = 4096 bytes of memory area
	constant c_SRME_SUBUNIT_MEMORY_AREA_ADDR_MASK : std_logic_vector((31 - c_SRME_SUBUNIT_MEMORY_AREA_WIDTH) downto 0) := (others => '0');

	constant c_SRME_SUBUNIT_MEMORY_AREA_RD_DELAY : natural := 2; -- necessary clock cicles to ensure read value is valid after an address change

	type t_rmap_memory_area_wr_control is record
		wr_address : std_logic_vector((c_SRME_SUBUNIT_MEMORY_AREA_WIDTH - 1) downto 0);
		wr_data    : std_logic_vector(7 downto 0);
		write      : std_logic;
	end record t_rmap_memory_area_wr_control;

	type t_rmap_memory_area_rd_control is record
		rd_address : std_logic_vector((c_SRME_SUBUNIT_MEMORY_AREA_WIDTH - 1) downto 0);
	end record t_rmap_memory_area_rd_control;

	type t_rmap_memory_area_rd_status is record
		rd_data : std_logic_vector(7 downto 0);
	end record t_rmap_memory_area_rd_status;

end package srme_rmap_mem_area_subunit_pkg;

package body srme_rmap_mem_area_subunit_pkg is
end package body srme_rmap_mem_area_subunit_pkg;
