library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.srme_rmap_mem_area_subunit_pkg.all;
use work.srme_avalon_mm_rmap_subunit_pkg.all;

entity srme_rmap_mem_area_subunit_read_ent is
	port(
		clk_i                     : in  std_logic;
		rst_i                     : in  std_logic;
		subunit_rmap_i            : in  t_srme_subunit_rmap_read_in;
		avalon_mm_rmap_i          : in  t_srme_avalon_mm_rmap_subunit_read_in;
		subunit_mem_addr_offset_i : in  std_logic_vector(31 downto 0);
		rmap_registers_wr_i       : in  t_rmap_memory_wr_area;
		rmap_registers_rd_i       : in  t_rmap_memory_rd_area;
		subunit_rmap_o            : out t_srme_subunit_rmap_read_out;
		avalon_mm_rmap_o          : out t_srme_avalon_mm_rmap_subunit_read_out
	);
end entity srme_rmap_mem_area_subunit_read_ent;

architecture RTL of srme_rmap_mem_area_subunit_read_ent is

begin

	p_srme_rmap_mem_area_subunit_read : process(clk_i, rst_i) is
		procedure p_subunit_rmap_mem_rd(rd_addr_i : std_logic_vector) is
			variable v_rd_addr : natural range (t_subunit_area_wr_reg'low) to (t_subunit_area_wr_reg'high);
		begin

			-- MemArea Data Read

			-- check if the read address is valid (uper address bits are the same as the offset)
			if (rd_addr_i(31 downto c_SRME_SUBUNIT_MEMORY_AREA_WIDTH) = subunit_mem_addr_offset_i(31 downto c_SRME_SUBUNIT_MEMORY_AREA_WIDTH)) then
				-- read address is valid, perform read
				v_rd_addr               := to_integer(unsigned(rd_addr_i((c_SRME_SUBUNIT_MEMORY_AREA_WIDTH - 1) downto 0)));
				subunit_rmap_o.readdata <= rmap_registers_wr_i.reg_subunit_area(v_rd_addr);
			else
				-- read address is not valid, return zero
				subunit_rmap_o.readdata <= (others => '0');
			end if;

		end procedure p_subunit_rmap_mem_rd;

		-- p_avalon_mm_rmap_read

		procedure p_avs_readdata(read_address_i : t_srme_avalon_mm_rmap_subunit_address) is
		begin

			-- Registers Data Read
			case (read_address_i) is
				-- Case for access to all registers address

				when others =>
					-- No register associated to the address, return with 0x00000000
					avalon_mm_rmap_o.readdata <= (others => '0');

			end case;

		end procedure p_avs_readdata;

		variable v_subunit_read_address : std_logic_vector(31 downto 0)         := (others => '0');
		variable v_avs_read_address     : t_srme_avalon_mm_rmap_subunit_address := 0;
	begin
		if (rst_i = '1') then
			subunit_rmap_o.readdata      <= (others => '0');
			subunit_rmap_o.waitrequest   <= '1';
			avalon_mm_rmap_o.readdata    <= (others => '0');
			avalon_mm_rmap_o.waitrequest <= '1';
			v_subunit_read_address       := (others => '0');
			v_avs_read_address           := 0;
		elsif (rising_edge(clk_i)) then

			subunit_rmap_o.readdata      <= (others => '0');
			subunit_rmap_o.waitrequest   <= '1';
			avalon_mm_rmap_o.readdata    <= (others => '0');
			avalon_mm_rmap_o.waitrequest <= '1';
			if (subunit_rmap_i.read = '1') then
				v_subunit_read_address     := subunit_rmap_i.address;
				subunit_rmap_o.waitrequest <= '0';
				p_subunit_rmap_mem_rd(v_subunit_read_address);
			elsif (avalon_mm_rmap_i.read = '1') then
				v_avs_read_address           := to_integer(unsigned(avalon_mm_rmap_i.address));
				avalon_mm_rmap_o.waitrequest <= '0';
				p_avs_readdata(v_avs_read_address);
			end if;

		end if;
	end process p_srme_rmap_mem_area_subunit_read;

end architecture RTL;
