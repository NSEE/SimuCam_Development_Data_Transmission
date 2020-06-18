library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package dcom_avm_data_pkg is

	constant c_DCOM_AVM_DATA_ADRESS_SIZE : natural := 64;
	constant c_DCOM_AVM_DATA_DATA_SIZE   : natural := 64;
	constant c_DCOM_AVM_DATA_SYMBOL_SIZE : natural := 8;

	--

	type t_dcom_avm_data_master_rd_control is record
		rd_req     : std_logic;
		rd_address : std_logic_vector((c_DCOM_AVM_DATA_ADRESS_SIZE - 1) downto 0);
	end record t_dcom_avm_data_master_rd_control;

	type t_dcom_avm_data_master_rd_status is record
		rd_able  : std_logic;
		rd_data  : std_logic_vector((c_DCOM_AVM_DATA_DATA_SIZE - 1) downto 0);
		rd_valid : std_logic;
	end record t_dcom_avm_data_master_rd_status;

	constant c_DCOM_AVM_DATA_MASTER_RD_CONTROL_RST : t_dcom_avm_data_master_rd_control := (
		rd_req     => '0',
		rd_address => (others => '0')
	);

	constant c_DCOM_AVM_DATA_MASTER_RD_STATUS_RST : t_dcom_avm_data_master_rd_status := (
		rd_able  => '0',
		rd_data  => (others => '0'),
		rd_valid => '0'
	);

	--

	type t_dcom_avm_data_slave_rd_status is record
		readdata    : std_logic_vector((c_DCOM_AVM_DATA_DATA_SIZE - 1) downto 0);
		waitrequest : std_logic;
	end record t_dcom_avm_data_slave_rd_status;

	type t_dcom_avm_data_slave_rd_control is record
		address : std_logic_vector((c_DCOM_AVM_DATA_ADRESS_SIZE - 1) downto 0);
		read    : std_logic;
	end record t_dcom_avm_data_slave_rd_control;

	constant c_DCOM_AVM_DATA_SLAVE_RD_STATUS_RST : t_dcom_avm_data_slave_rd_status := (
		readdata    => (others => '0'),
		waitrequest => '1'
	);

	constant c_DCOM_AVM_DATA_SLAVE_RD_CONTROL_RST : t_dcom_avm_data_slave_rd_control := (
		address => (others => '0'),
		read    => '0'
	);

end package dcom_avm_data_pkg;

package body dcom_avm_data_pkg is

end package body dcom_avm_data_pkg;
