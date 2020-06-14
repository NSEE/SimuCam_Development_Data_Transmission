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
		avs_0_rmap_address_i            : in  std_logic_vector(11 downto 0) := (others => '0'); --              avalon_rmap_slave_0.address
		avs_0_rmap_byteenable_i         : in  std_logic_vector(3 downto 0)  := (others => '0'); --                                 .byteenable
		avs_0_rmap_write_i              : in  std_logic                     := '0'; --          --                                 .write
		avs_0_rmap_writedata_i          : in  std_logic_vector(31 downto 0) := (others => '0'); --                                 .writedata
		avs_0_rmap_read_i               : in  std_logic                     := '0'; --          --                                 .read
		avs_0_rmap_readdata_o           : out std_logic_vector(31 downto 0); --                 --                                 .readdata
		avs_0_rmap_waitrequest_o        : out std_logic; --                                     --                                 .waitrequest
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

	signal s_rmap_mem_area_wr_control  : t_rmap_memory_area_wr_control;
	signal s_rmap_mem_area_rd_control  : t_rmap_memory_area_rd_control;
	signal s_rmap_mem_area_rd_status   : t_rmap_memory_area_rd_status;
	signal s_rmap_mem_area_ram_address : std_logic_vector((c_SRME_SUBUNIT_MEMORY_AREA_WIDTH - 1) downto 0);
	-- avs 0 signals
	signal s_avs_0_rmap_wr_waitrequest : std_logic;
	signal s_avs_0_rmap_rd_waitrequest : std_logic;
	-- subunit rmap signals
	signal s_subunit_wr_rmap_in        : t_srme_subunit_rmap_write_in;
	signal s_subunit_wr_rmap_out       : t_srme_subunit_rmap_write_out;
	signal s_subunit_rd_rmap_in        : t_srme_subunit_rmap_read_in;
	signal s_subunit_rd_rmap_out       : t_srme_subunit_rmap_read_out;
	-- avs rmap signals
	signal s_avalon_mm_wr_rmap_in      : t_srme_avalon_mm_rmap_subunit_write_in;
	signal s_avalon_mm_wr_rmap_out     : t_srme_avalon_mm_rmap_subunit_write_out;
	signal s_avalon_mm_rd_rmap_in      : t_srme_avalon_mm_rmap_subunit_read_in;
	signal s_avalon_mm_rd_rmap_out     : t_srme_avalon_mm_rmap_subunit_read_out;

begin

	srme_mem_area_altsyncram_inst : entity work.srme_mem_area_altsyncram
		port map(
			aclr    => a_reset,
			address => s_rmap_mem_area_ram_address,
			clock   => a_avs_clock,
			data    => s_rmap_mem_area_wr_control.wr_data,
			wren    => s_rmap_mem_area_wr_control.write,
			q       => s_rmap_mem_area_rd_status.rd_data
		);
	s_rmap_mem_area_ram_address <= (s_rmap_mem_area_wr_control.wr_address) or (s_rmap_mem_area_rd_control.rd_address);

	srme_rmap_mem_area_subunit_arbiter_ent_inst : entity work.srme_rmap_mem_area_subunit_arbiter_ent
		port map(
			clk_i                             => a_avs_clock,
			rst_i                             => a_reset,
			subunit_0_wr_rmap_i.address       => subunit_0_rmap_wr_address_i,
			subunit_0_wr_rmap_i.write         => subunit_0_rmap_write_i,
			subunit_0_wr_rmap_i.writedata     => subunit_0_rmap_writedata_i,
			subunit_0_rd_rmap_i.address       => subunit_0_rmap_rd_address_i,
			subunit_0_rd_rmap_i.read          => subunit_0_rmap_read_i,
			subunit_1_wr_rmap_i               => c_SRME_SUBUNIT_RMAP_WRITE_IN_RST,
			subunit_1_rd_rmap_i               => c_SRME_SUBUNIT_RMAP_READ_IN_RST,
			avalon_0_mm_wr_rmap_i.address     => avs_0_rmap_address_i,
			avalon_0_mm_wr_rmap_i.write       => avs_0_rmap_write_i,
			avalon_0_mm_wr_rmap_i.writedata   => avs_0_rmap_writedata_i,
			avalon_0_mm_wr_rmap_i.byteenable  => avs_0_rmap_byteenable_i,
			avalon_0_mm_rd_rmap_i.address     => avs_0_rmap_address_i,
			avalon_0_mm_rd_rmap_i.read        => avs_0_rmap_read_i,
			avalon_0_mm_rd_rmap_i.byteenable  => avs_0_rmap_byteenable_i,
			subunit_wr_rmap_i                 => s_subunit_wr_rmap_out,
			subunit_rd_rmap_i                 => s_subunit_rd_rmap_out,
			avalon_mm_wr_rmap_i               => s_avalon_mm_wr_rmap_out,
			avalon_mm_rd_rmap_i               => s_avalon_mm_rd_rmap_out,
			subunit_0_wr_rmap_o.waitrequest   => subunit_0_rmap_wr_waitrequest_o,
			subunit_0_rd_rmap_o.readdata      => subunit_0_rmap_readdata_o,
			subunit_0_rd_rmap_o.waitrequest   => subunit_0_rmap_rd_waitrequest_o,
			subunit_1_wr_rmap_o               => open,
			avalon_0_mm_wr_rmap_o.waitrequest => s_avs_0_rmap_wr_waitrequest,
			avalon_0_mm_rd_rmap_o.readdata    => avs_0_rmap_readdata_o,
			avalon_0_mm_rd_rmap_o.waitrequest => s_avs_0_rmap_rd_waitrequest,
			subunit_wr_rmap_o                 => s_subunit_wr_rmap_in,
			subunit_rd_rmap_o                 => s_subunit_rd_rmap_in,
			avalon_mm_wr_rmap_o               => s_avalon_mm_wr_rmap_in,
			avalon_mm_rd_rmap_o               => s_avalon_mm_rd_rmap_in
		);
	avs_0_rmap_waitrequest_o <= (s_avs_0_rmap_wr_waitrequest) and (s_avs_0_rmap_rd_waitrequest);

	srme_rmap_mem_area_subunit_read_ent_inst : entity work.srme_rmap_mem_area_subunit_read_ent
		port map(
			clk_i                      => a_avs_clock,
			rst_i                      => a_reset,
			subunit_rmap_i             => s_subunit_rd_rmap_in,
			avalon_mm_rmap_i           => s_avalon_mm_rd_rmap_in,
			subunit_mem_addr_offset_i  => rmap_mem_addr_offset_i,
			rmap_mem_area_rd_status_i  => s_rmap_mem_area_rd_status,
			subunit_rmap_o             => s_subunit_rd_rmap_out,
			avalon_mm_rmap_o           => s_avalon_mm_rd_rmap_out,
			rmap_mem_area_rd_control_o => s_rmap_mem_area_rd_control
		);

	srme_rmap_mem_area_subunit_write_ent_inst : entity work.srme_rmap_mem_area_subunit_write_ent
		port map(
			clk_i                      => a_avs_clock,
			rst_i                      => a_reset,
			subunit_rmap_i             => s_subunit_wr_rmap_in,
			avalon_mm_rmap_i           => s_avalon_mm_wr_rmap_in,
			subunit_mem_addr_offset_i  => rmap_mem_addr_offset_i,
			subunit_rmap_o             => s_subunit_wr_rmap_out,
			avalon_mm_rmap_o           => s_avalon_mm_wr_rmap_out,
			rmap_mem_area_wr_control_o => s_rmap_mem_area_wr_control
		);

end architecture rtl;                   -- of srme_rmap_memory_subunit_area_top
