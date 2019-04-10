library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_controller_ent is
	port(
		clk_i            : in  std_logic;
		rst_i            : in  std_logic;
		tmr_time_i       : in  std_logic_vector(31 downto 0);
		tmr_stop_i       : in  std_logic;
		tmr_clear_i      : in  std_logic;
		tmr_start_i      : in  std_logic;
		dctrl_send_eep_i : in  std_logic;
		dctrl_send_eop_i : in  std_logic;
		dbuffer_empty_i  : in  std_logic;
		dbuffer_rddata_i : in  std_logic_vector(7 downto 0);
		spw_tx_ready_i   : in  std_logic;
		dctrl_tx_begin_o : out std_logic;
		dctrl_tx_ended_o : out std_logic;
		dbuffer_rdreq_o  : out std_logic;
		spw_tx_write_o   : out std_logic;
		spw_tx_flag_o    : out std_logic;
		spw_tx_data_o    : out std_logic_vector(7 downto 0)
	);
end entity data_controller_ent;

architecture RTL of data_controller_ent is

begin

end architecture RTL;
