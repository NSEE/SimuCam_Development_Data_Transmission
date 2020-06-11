-- srme_rmap_memory_subunit_area_top.vhd

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

use work.srme_avalon_mm_rmap_subunit_pkg.all;
use work.srme_rmap_mem_area_subunit_pkg.all;

entity srme_rmap_memory_subunit_area_top is
	port(
		reset_i                         : in  std_logic                     := '0'; --          --                       reset_sink.reset
		clk_100_i                       : in  std_logic                     := '0'; --          --                clock_sink_100mhz.clk
		subunit_0_rmap_wr_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); -- conduit_end_subunit_rmap_slave_0.wr_address_signal
		subunit_0_rmap_write_i          : in  std_logic                     := '0'; --          --                                 .write_signal
		subunit_0_rmap_writedata_i      : in  std_logic_vector(7 downto 0)  := (others => '0'); --                                 .writedata_signal
		subunit_0_rmap_rd_address_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --                                 .rd_address_signal
		subunit_0_rmap_read_i           : in  std_logic                     := '0'; --          --                                 .read_signal
		subunit_0_rmap_wr_waitrequest_o : out std_logic; --                                     --                                 .wr_waitrequest_signal
		subunit_0_rmap_readdata_o       : out std_logic_vector(7 downto 0); --                  --                                 .readdata_signal
		subunit_0_rmap_rd_waitrequest_o : out std_logic; --                                     --                                 .rd_waitrequest_signal
		rmap_mem_addr_offset_i          : in  std_logic_vector(31 downto 0) := (others => '0') ---  conduit_end_rmap_mem_configs_in.mem_addr_offset_signal
	);
end entity srme_rmap_memory_subunit_area_top;

architecture rtl of srme_rmap_memory_subunit_area_top is

	-- alias --
	alias a_avs_clock is clk_100_i;
	alias a_reset is reset_i;

	-- signals --

	-- rmap memory signals
	signal s_rmap_mem_wr_area      : t_rmap_memory_wr_area;
	signal s_rmap_mem_rd_area      : t_rmap_memory_rd_area;
	-- avs 0 signals
	--	signal s_avs_0_rmap_wr_waitrequest : std_logic;
	--	signal s_avs_0_rmap_rd_waitrequest : std_logic;
	-- subunit rmap signals
	signal s_subunit_wr_rmap_in    : t_srme_subunit_rmap_write_in;
	signal s_subunit_wr_rmap_out   : t_srme_subunit_rmap_write_out;
	signal s_subunit_rd_rmap_in    : t_srme_subunit_rmap_read_in;
	signal s_subunit_rd_rmap_out   : t_srme_subunit_rmap_read_out;
	-- avs rmap signals
	signal s_avalon_mm_wr_rmap_in  : t_srme_avalon_mm_rmap_subunit_write_in;
	signal s_avalon_mm_wr_rmap_out : t_srme_avalon_mm_rmap_subunit_write_out;
	signal s_avalon_mm_rd_rmap_in  : t_srme_avalon_mm_rmap_subunit_read_in;
	signal s_avalon_mm_rd_rmap_out : t_srme_avalon_mm_rmap_subunit_read_out;

begin

	srme_rmap_mem_area_subunit_arbiter_ent_inst : entity work.srme_rmap_mem_area_subunit_arbiter_ent
		port map(
			clk_i                            => a_avs_clock,
			rst_i                            => a_reset,
			subunit_0_wr_rmap_i.address      => subunit_0_rmap_wr_address_i,
			subunit_0_wr_rmap_i.write        => subunit_0_rmap_write_i,
			subunit_0_wr_rmap_i.writedata    => subunit_0_rmap_writedata_i,
			subunit_0_rd_rmap_i.address      => subunit_0_rmap_rd_address_i,
			subunit_0_rd_rmap_i.read         => subunit_0_rmap_read_i,
			subunit_1_wr_rmap_i.address      => (others => '0'),
			subunit_1_wr_rmap_i.write        => '0',
			subunit_1_wr_rmap_i.writedata    => (others => '0'),
			subunit_1_rd_rmap_i.address      => (others => '0'),
			subunit_1_rd_rmap_i.read         => '0',
			avalon_0_mm_wr_rmap_i.address    => (others => '0'),
			avalon_0_mm_wr_rmap_i.write      => '0',
			avalon_0_mm_wr_rmap_i.writedata  => (others => '0'),
			avalon_0_mm_wr_rmap_i.byteenable => (others => '0'),
			avalon_0_mm_rd_rmap_i.address    => (others => '0'),
			avalon_0_mm_rd_rmap_i.read       => '0',
			avalon_0_mm_rd_rmap_i.byteenable => (others => '0'),
			subunit_wr_rmap_i                => s_subunit_wr_rmap_out,
			subunit_rd_rmap_i                => s_subunit_rd_rmap_out,
			avalon_mm_wr_rmap_i              => s_avalon_mm_wr_rmap_out,
			avalon_mm_rd_rmap_i              => s_avalon_mm_rd_rmap_out,
			subunit_0_wr_rmap_o.waitrequest  => subunit_0_rmap_wr_waitrequest_o,
			subunit_0_rd_rmap_o.readdata     => subunit_0_rmap_readdata_o,
			subunit_0_rd_rmap_o.waitrequest  => subunit_0_rmap_rd_waitrequest_o,
			subunit_1_wr_rmap_o              => open,
			avalon_0_mm_wr_rmap_o            => open,
			subunit_wr_rmap_o                => s_subunit_wr_rmap_in,
			subunit_rd_rmap_o                => s_subunit_rd_rmap_in,
			avalon_mm_wr_rmap_o              => s_avalon_mm_wr_rmap_in,
			avalon_mm_rd_rmap_o              => s_avalon_mm_rd_rmap_in
		);
	--	avs_0_rmap_waitrequest_o <= (s_avs_0_rmap_wr_waitrequest) and (s_avs_0_rmap_rd_waitrequest);

	srme_rmap_mem_area_subunit_read_ent_inst : entity work.srme_rmap_mem_area_subunit_read_ent
		port map(
			clk_i                     => a_avs_clock,
			rst_i                     => a_reset,
			subunit_rmap_i            => s_subunit_rd_rmap_in,
			avalon_mm_rmap_i          => s_avalon_mm_rd_rmap_in,
			subunit_mem_addr_offset_i => rmap_mem_addr_offset_i,
			rmap_registers_wr_i       => s_rmap_mem_wr_area,
			rmap_registers_rd_i       => s_rmap_mem_rd_area,
			subunit_rmap_o            => s_subunit_rd_rmap_out,
			avalon_mm_rmap_o          => s_avalon_mm_rd_rmap_out
		);

	srme_rmap_mem_area_subunit_write_ent_inst : entity work.srme_rmap_mem_area_subunit_write_ent
		port map(
			clk_i                     => a_avs_clock,
			rst_i                     => a_reset,
			subunit_rmap_i            => s_subunit_wr_rmap_in,
			avalon_mm_rmap_i          => s_avalon_mm_wr_rmap_in,
			subunit_mem_addr_offset_i => rmap_mem_addr_offset_i,
			subunit_rmap_o            => s_subunit_wr_rmap_out,
			avalon_mm_rmap_o          => s_avalon_mm_wr_rmap_out,
			rmap_registers_wr_o       => s_rmap_mem_wr_area
		);

	-- rmap read-only registers assignment
	s_rmap_mem_rd_area.reg_dummy <= '0';

end architecture rtl;                   -- of srme_rmap_memory_subunit_area_top
