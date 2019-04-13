library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package data_buffer_pkg is

	constant c_AVS_DBUFFER_DATA_WIDTH  : natural range 8 to 256 := 64;
	constant c_AVS_BEBUFFER_DATA_WIDTH : natural range 1 to 32  := 8;
	constant c_AVS_BUFFER_USED_WIDTH   : natural range 1 to 16  := 11; -- 2**11 = 2048

	constant c_DCTRL_DBUFFER_DATA_WIDTH : natural range 8 to 256 := 8;
	constant c_DCTRL_BUFFER_USED_WIDTH  : natural range 1 to 16  := 9; -- 2**9 = 512

	-- type for the avs data buffer 
	type t_avs_dbuffer_fifo is record
		data  : std_logic_vector((c_AVS_DBUFFER_DATA_WIDTH - 1) downto 0);
		rdreq : std_logic;
		sclr  : std_logic;
		wrreq : std_logic;
		empty : std_logic;
		full  : std_logic;
		q     : std_logic_vector((c_AVS_DBUFFER_DATA_WIDTH - 1) downto 0);
		usedw : std_logic_vector((c_AVS_BUFFER_USED_WIDTH - 1) downto 0);
	end record t_avs_dbuffer_fifo;
	signal s_avs_dbuffer_fifo : t_avs_dbuffer_fifo;

	-- type for the avs byte enable buffer
	type t_avs_bebuffer_fifo is record
		data  : std_logic_vector((c_AVS_BEBUFFER_DATA_WIDTH - 1) downto 0);
		rdreq : std_logic;
		sclr  : std_logic;
		wrreq : std_logic;
		empty : std_logic;
		full  : std_logic;
		q     : std_logic_vector((c_AVS_BEBUFFER_DATA_WIDTH - 1) downto 0);
		usedw : std_logic_vector((c_AVS_BUFFER_USED_WIDTH - 1) downto 0);
	end record t_avs_bebuffer_fifo;
	signal s_avs_bebuffer_fifo : t_avs_bebuffer_fifo;

	-- type for the data controller data buffer
	type t_dctrl_dbuffer_fifo is record
		data  : std_logic_vector((c_DCTRL_DBUFFER_DATA_WIDTH - 1) downto 0);
		rdreq : std_logic;
		sclr  : std_logic;
		wrreq : std_logic;
		empty : std_logic;
		full  : std_logic;
		q     : std_logic_vector((c_DCTRL_DBUFFER_DATA_WIDTH - 1) downto 0);
		usedw : std_logic_vector((c_DCTRL_BUFFER_USED_WIDTH - 1) downto 0);
	end record t_dctrl_dbuffer_fifo;
	signal s_dctrl_dbuffer_fifo : t_dctrl_dbuffer_fifo;

end package data_buffer_pkg;

package body data_buffer_pkg is

end package body data_buffer_pkg;
