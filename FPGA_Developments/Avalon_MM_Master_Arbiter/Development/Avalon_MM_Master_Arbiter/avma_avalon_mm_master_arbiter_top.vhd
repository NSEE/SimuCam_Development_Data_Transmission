-- avma_avalon_mm_master_arbiter_top.vhd

-- This file was auto-generated as a prototype implementation of a module
-- created in component editor.  It ties off all outputs to ground and
-- ignores all inputs.  It needs to be edited to make it do something
-- useful.
-- 
-- This file will not be automatically regenerated.  You should check it in
-- to your version control system if you want to keep it.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.avma_avm_arbiter_pkg.all;

entity avma_avalon_mm_master_arbiter_top is
    port(
        reset_i             : in  std_logic                     := '0'; --          --         reset_sink.reset
        clk_100_i           : in  std_logic                     := '0'; --          --  clock_sink_100mhz.clk
        avm_0_address_i     : in  std_logic_vector(63 downto 0) := (others => '0'); -- avalon_mm_master_0.address
        avm_0_read_i        : in  std_logic                     := '0'; --          --                   .read
        --        avm_0_write_i       : in  std_logic                     := '0'; --          --                   .write
        --        avm_0_writedata_i   : in  std_logic_vector(63 downto 0) := (others => '0'); --                   .writedata
        --        avm_0_byteenable_i  : in  std_logic_vector(3 downto 0)  := (others => '0'); --                   .byteenable
        avm_0_readdata_o    : out std_logic_vector(63 downto 0); --                 --                   .readdata
        avm_0_waitrequest_o : out std_logic; --                                     --                   .waitrequest
        avm_1_address_i     : in  std_logic_vector(63 downto 0) := (others => '0'); -- avalon_mm_master_1.address
        avm_1_read_i        : in  std_logic                     := '0'; --          --                   .read
        --        avm_1_write_i       : in  std_logic                     := '0'; --          --                   .write
        --        avm_1_writedata_i   : in  std_logic_vector(63 downto 0) := (others => '0'); --                   .writedata
        --        avm_1_byteenable_i  : in  std_logic_vector(3 downto 0)  := (others => '0'); --                   .byteenable
        avm_1_readdata_o    : out std_logic_vector(63 downto 0); --                 --                   .readdata
        avm_1_waitrequest_o : out std_logic; --                                     --                   .waitrequest
        avm_2_address_i     : in  std_logic_vector(63 downto 0) := (others => '0'); -- avalon_mm_master_2.address
        avm_2_read_i        : in  std_logic                     := '0'; --          --                   .read
        --        avm_2_write_i       : in  std_logic                     := '0'; --          --                   .write
        --        avm_2_writedata_i   : in  std_logic_vector(63 downto 0) := (others => '0'); --                   .writedata
        --        avm_2_byteenable_i  : in  std_logic_vector(3 downto 0)  := (others => '0'); --                   .byteenable
        avm_2_readdata_o    : out std_logic_vector(63 downto 0); --                 --                   .readdata
        avm_2_waitrequest_o : out std_logic; --                                     --                   .waitrequest
        avm_3_address_i     : in  std_logic_vector(63 downto 0) := (others => '0'); -- avalon_mm_master_3.address
        avm_3_read_i        : in  std_logic                     := '0'; --          --                   .read
        --        avm_3_write_i       : in  std_logic                     := '0'; --          --                   .write
        --        avm_3_writedata_i   : in  std_logic_vector(63 downto 0) := (others => '0'); --                   .writedata
        --        avm_3_byteenable_i  : in  std_logic_vector(3 downto 0)  := (others => '0'); --                   .byteenable
        avm_3_readdata_o    : out std_logic_vector(63 downto 0); --                 --                   .readdata
        avm_3_waitrequest_o : out std_logic; --                                     --                   .waitrequest
        avm_4_address_i     : in  std_logic_vector(63 downto 0) := (others => '0'); -- avalon_mm_master_4.address
        avm_4_read_i        : in  std_logic                     := '0'; --          --                   .read
        --        avm_4_write_i       : in  std_logic                     := '0'; --          --                   .write
        --        avm_4_writedata_i   : in  std_logic_vector(63 downto 0) := (others => '0'); --                   .writedata
        --        avm_4_byteenable_i  : in  std_logic_vector(3 downto 0)  := (others => '0'); --                   .byteenable
        avm_4_readdata_o    : out std_logic_vector(63 downto 0); --                 --                   .readdata
        avm_4_waitrequest_o : out std_logic; --                                     --                   .waitrequest
        avm_5_address_i     : in  std_logic_vector(63 downto 0) := (others => '0'); -- avalon_mm_master_5.address
        avm_5_read_i        : in  std_logic                     := '0'; --          --                   .read
        --        avm_5_write_i       : in  std_logic                     := '0'; --          --                   .write
        --        avm_5_writedata_i   : in  std_logic_vector(63 downto 0) := (others => '0'); --                   .writedata
        --        avm_5_byteenable_i  : in  std_logic_vector(3 downto 0)  := (others => '0'); --                   .byteenable
        avm_5_readdata_o    : out std_logic_vector(63 downto 0); --                 --                   .readdata
        avm_5_waitrequest_o : out std_logic; --                                     --                   .waitrequest
        avm_6_address_i     : in  std_logic_vector(63 downto 0) := (others => '0'); -- avalon_mm_master_6.address
        avm_6_read_i        : in  std_logic                     := '0'; --          --                   .read
        --        avm_6_write_i       : in  std_logic                     := '0'; --          --                   .write
        --        avm_6_writedata_i   : in  std_logic_vector(63 downto 0) := (others => '0'); --                   .writedata
        --        avm_6_byteenable_i  : in  std_logic_vector(3 downto 0)  := (others => '0'); --                   .byteenable
        avm_6_readdata_o    : out std_logic_vector(63 downto 0); --                 --                   .readdata
        avm_6_waitrequest_o : out std_logic; --                                     --                   .waitrequest
        avm_7_address_i     : in  std_logic_vector(63 downto 0) := (others => '0'); -- avalon_mm_master_7.address
        avm_7_read_i        : in  std_logic                     := '0'; --          --                   .read
        --        avm_7_write_i       : in  std_logic                     := '0'; --          --                   .write
        --        avm_7_writedata_i   : in  std_logic_vector(63 downto 0) := (others => '0'); --                   .writedata
        --        avm_7_byteenable_i  : in  std_logic_vector(3 downto 0)  := (others => '0'); --                   .byteenable
        avm_7_readdata_o    : out std_logic_vector(63 downto 0); --                 --                   .readdata
        avm_7_waitrequest_o : out std_logic; --                                     --                   .waitrequest
        avs_readdata_i      : in  std_logic_vector(63 downto 0) := (others => '0'); --    avalon_mm_slave.readdata
        avs_waitrequest_i   : in  std_logic                     := '0'; --          --                   .waitrequest
        avs_address_o       : out std_logic_vector(63 downto 0); --                 --                   .address
        avs_read_o          : out std_logic ---                                     --                   .read
        --        avs_write_o         : out std_logic; --                                     --                   .write
        --        avs_writedata_o     : out std_logic_vector(63 downto 0); --                 --                   .writedata
        --        avs_byteenable_o    : out std_logic_vector(3 downto 0)  := (others => '0') ---                   .byteenable
    );
end entity avma_avalon_mm_master_arbiter_top;

architecture rtl of avma_avalon_mm_master_arbiter_top is

    -- alias --
    alias a_avs_clock is clk_100_i;
    alias a_reset is reset_i;

    -- signals --

begin

    avma_avm_arbiter_ent_inst : entity work.avma_avm_arbiter_ent
        port map(
            clk_i                            => a_avs_clock,
            rst_i                            => a_reset,
            --
            avalon_mm_master_0_i.address     => avm_0_address_i,
            avalon_mm_master_0_i.read        => avm_0_read_i,
            --            avalon_mm_master_0_i.write       => avm_0_write_i,
            --            avalon_mm_master_0_i.writedata   => avm_0_writedata_i,
            --            avalon_mm_master_0_i.byteenable  => avm_0_byteenable_i,
            --
            avalon_mm_master_1_i.address     => avm_1_address_i,
            avalon_mm_master_1_i.read        => avm_1_read_i,
            --            avalon_mm_master_1_i.write       => avm_1_write_i,
            --            avalon_mm_master_1_i.writedata   => avm_1_writedata_i,
            --            avalon_mm_master_1_i.byteenable  => avm_1_byteenable_i,
            --
            avalon_mm_master_2_i.address     => avm_2_address_i,
            avalon_mm_master_2_i.read        => avm_2_read_i,
            --            avalon_mm_master_2_i.write       => avm_2_write_i,
            --            avalon_mm_master_2_i.writedata   => avm_2_writedata_i,
            --            avalon_mm_master_2_i.byteenable  => avm_2_byteenable_i,
            --
            avalon_mm_master_3_i.address     => avm_3_address_i,
            avalon_mm_master_3_i.read        => avm_3_read_i,
            --            avalon_mm_master_3_i.write       => avm_3_write_i,
            --            avalon_mm_master_3_i.writedata   => avm_3_writedata_i,
            --            avalon_mm_master_3_i.byteenable  => avm_3_byteenable_i,
            --
            avalon_mm_master_4_i.address     => avm_4_address_i,
            avalon_mm_master_4_i.read        => avm_4_read_i,
            --            avalon_mm_master_4_i.write       => avm_4_write_i,
            --            avalon_mm_master_4_i.writedata   => avm_4_writedata_i,
            --            avalon_mm_master_4_i.byteenable  => avm_4_byteenable_i,
            --
            avalon_mm_master_5_i.address     => avm_5_address_i,
            avalon_mm_master_5_i.read        => avm_5_read_i,
            --            avalon_mm_master_5_i.write       => avm_5_write_i,
            --            avalon_mm_master_5_i.writedata   => avm_5_writedata_i,
            --            avalon_mm_master_5_i.byteenable  => avm_5_byteenable_i,
            --
            avalon_mm_master_6_i.address     => avm_6_address_i,
            avalon_mm_master_6_i.read        => avm_6_read_i,
            --            avalon_mm_master_6_i.write       => avm_6_write_i,
            --            avalon_mm_master_6_i.writedata   => avm_6_writedata_i,
            --            avalon_mm_master_6_i.byteenable  => avm_6_byteenable_i,
            --
            avalon_mm_master_7_i.address     => avm_7_address_i,
            avalon_mm_master_7_i.read        => avm_7_read_i,
            --            avalon_mm_master_7_i.write       => avm_7_write_i,
            --            avalon_mm_master_7_i.writedata   => avm_7_writedata_i,
            --            avalon_mm_master_7_i.byteenable  => avm_7_byteenable_i,
            --
            avalon_mm_slave_i.readdata       => avs_readdata_i,
            avalon_mm_slave_i.waitrequest    => avs_waitrequest_i,
            --
            avalon_mm_master_0_o.readdata    => avm_0_readdata_o,
            avalon_mm_master_0_o.waitrequest => avm_0_waitrequest_o,
            --
            avalon_mm_master_1_o.readdata    => avm_1_readdata_o,
            avalon_mm_master_1_o.waitrequest => avm_1_waitrequest_o,
            --
            avalon_mm_master_2_o.readdata    => avm_2_readdata_o,
            avalon_mm_master_2_o.waitrequest => avm_2_waitrequest_o,
            --
            avalon_mm_master_3_o.readdata    => avm_3_readdata_o,
            avalon_mm_master_3_o.waitrequest => avm_3_waitrequest_o,
            --
            avalon_mm_master_4_o.readdata    => avm_4_readdata_o,
            avalon_mm_master_4_o.waitrequest => avm_4_waitrequest_o,
            --
            avalon_mm_master_5_o.readdata    => avm_5_readdata_o,
            avalon_mm_master_5_o.waitrequest => avm_5_waitrequest_o,
            --
            avalon_mm_master_6_o.readdata    => avm_6_readdata_o,
            avalon_mm_master_6_o.waitrequest => avm_6_waitrequest_o,
            --
            avalon_mm_master_7_o.readdata    => avm_7_readdata_o,
            avalon_mm_master_7_o.waitrequest => avm_7_waitrequest_o,
            --
            avalon_mm_slave_o.address        => avs_address_o,
            avalon_mm_slave_o.read           => avs_read_o
            --            avalon_mm_slave_o.write          => avs_write_o,
            --            avalon_mm_slave_o.writedata      => avs_writedata_o,
            --            avalon_mm_slave_o.byteenable     => avs_byteenable_o
        );

end architecture rtl;                   -- of avma_avalon_mm_master_arbiter_top
