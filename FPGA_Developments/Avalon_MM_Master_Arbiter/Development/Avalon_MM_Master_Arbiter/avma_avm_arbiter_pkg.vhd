library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package avma_avm_arbiter_pkg is

    constant c_AVMA_AVM_ARBITER_ADRESS_SIZE : natural := 64;
    constant c_AVMA_AVM_ARBITER_DATA_SIZE   : natural := 64;
    constant c_AVMA_AVM_ARBITER_SYMBOL_SIZE : natural := 8;

    type t_avma_avm_arbiter_in is record
        address : std_logic_vector((c_AVMA_AVM_ARBITER_ADRESS_SIZE - 1) downto 0);
        read    : std_logic;
        --        write     : std_logic;
        --        writedata : std_logic_vector((c_AVMA_AVM_ARBITER_DATA_SIZE - 1) downto 0);
        --        byteenable : std_logic_vector(((c_AVMA_AVM_ARBITER_DATA_SIZE / c_AVMA_AVM_ARBITER_SYMBOL_SIZE) - 1) downto 0);
    end record t_avma_avm_arbiter_in;

    type t_avma_avm_arbiter_out is record
        readdata    : std_logic_vector((c_AVMA_AVM_ARBITER_DATA_SIZE - 1) downto 0);
        waitrequest : std_logic;
    end record t_avma_avm_arbiter_out;

    constant c_AVMA_AVM_ARBITER_IN_RST : t_avma_avm_arbiter_in := (
        address => (others => '0'),
        read    => '0'
        --        write     => '0',
        --        writedata => (others => '0'),
        --        byteenable => (others => '0')
    );

    constant c_AVMA_AVM_ARBITER_OUT_RST : t_avma_avm_arbiter_out := (
        readdata    => (others => '0'),
        waitrequest => '1'
    );

end package avma_avm_arbiter_pkg;

package body avma_avm_arbiter_pkg is
end package body avma_avm_arbiter_pkg;
