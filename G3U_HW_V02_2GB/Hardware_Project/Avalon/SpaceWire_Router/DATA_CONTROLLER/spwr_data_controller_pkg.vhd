library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package spwr_data_controller_pkg is

  ------------------------------------------------------------------------------
  -- 1) Routing Table Type Declaration
  ------------------------------------------------------------------------------
  type routing_table_t is array (0 to 255) of std_logic_vector(5 downto 0);

  ------------------------------------------------------------------------------
  -- 2) Reset Constant
  ------------------------------------------------------------------------------
  -- c_rst_routing_table: all 256 entries will be "000000".
  ------------------------------------------------------------------------------
  constant c_rst_routing_table : routing_table_t :=
    (others => (others => '0'));

end package spwr_data_controller_pkg;
