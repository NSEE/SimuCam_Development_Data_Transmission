library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- 2D array type definitions for NxN connections
-- Typically you would put these in a package,
-- but for clarity we include them here.
package spwm_crossbar_switch_pkg is
    -- NxN std_logic array: data_arbiter_write_allowed_i, data_arbiter_write_request_o
    subtype t_channel_index is integer range 0 to 255;  -- Enough range for 32 or more channels
    type t_2d_slv is array (t_channel_index range <>, t_channel_index range <>) of std_logic;

    -- NxN std_logic_vector(7 downto 0) is not needed here,
    -- but you might define a 2D array for data if required.

    -- 1D arrays for each channel
    type t_1d_slv8 is array (t_channel_index range <>) of std_logic_vector(7 downto 0);
    type t_1d_sl is array (t_channel_index range <>) of std_logic;
    --
    -- crossbar_switch_select_i is 1D array of 6-bit vectors
    type t_1d_slv6 is array (t_channel_index range <>) of std_logic_vector(5 downto 0);
end package spwm_crossbar_switch_pkg;
