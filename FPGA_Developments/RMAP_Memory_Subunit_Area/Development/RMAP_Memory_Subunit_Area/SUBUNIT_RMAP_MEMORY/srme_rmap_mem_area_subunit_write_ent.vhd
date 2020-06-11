library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.srme_rmap_mem_area_subunit_pkg.all;
use work.srme_avalon_mm_rmap_subunit_pkg.all;

entity srme_rmap_mem_area_subunit_write_ent is
	port(
		clk_i                     : in  std_logic;
		rst_i                     : in  std_logic;
		subunit_rmap_i            : in  t_srme_subunit_rmap_write_in;
		avalon_mm_rmap_i          : in  t_srme_avalon_mm_rmap_subunit_write_in;
		subunit_mem_addr_offset_i : in  std_logic_vector(31 downto 0);
		subunit_rmap_o            : out t_srme_subunit_rmap_write_out;
		avalon_mm_rmap_o          : out t_srme_avalon_mm_rmap_subunit_write_out;
		rmap_registers_wr_o       : out t_rmap_memory_wr_area
	);
end entity srme_rmap_mem_area_subunit_write_ent;

architecture RTL of srme_rmap_mem_area_subunit_write_ent is

	signal s_data_acquired : std_logic;

begin

	p_srme_rmap_mem_area_subunit_write : process(clk_i, rst_i) is
		procedure p_subunit_reg_reset is
		begin

			-- Write Registers Reset/Default State

			-- RMAP Area Register : Subunit Area Array
			rmap_registers_wr_o.reg_subunit_area <= (others => x"00");

		end procedure p_subunit_reg_reset;

		procedure p_subunit_reg_trigger is
		begin

			-- Write Registers Triggers Reset
			null;

		end procedure p_subunit_reg_trigger;

		procedure p_subunit_mem_wr(wr_addr_i : std_logic_vector) is
			variable v_wr_addr : natural range (t_subunit_area_wr_reg'low) to (t_subunit_area_wr_reg'high);
		begin

			-- MemArea Write Data

			-- check if the write address is valid (uper address bits are the same as the offset)
			if (wr_addr_i(31 downto c_SRME_SUBUNIT_MEMORY_AREA_WIDTH) = subunit_mem_addr_offset_i(31 downto c_SRME_SUBUNIT_MEMORY_AREA_WIDTH)) then
				-- write address is valid, perform write
				v_wr_addr                                       := to_integer(unsigned(wr_addr_i((c_SRME_SUBUNIT_MEMORY_AREA_WIDTH - 1) downto 0)));
				rmap_registers_wr_o.reg_subunit_area(v_wr_addr) <= subunit_rmap_i.writedata;
			else
				-- write address is not valid, do nothing
				null;
			end if;

		end procedure p_subunit_mem_wr;

		-- p_avalon_mm_rmap_write

		procedure p_avs_writedata(write_address_i : t_srme_avalon_mm_rmap_subunit_address) is
		begin

			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				when others =>
					-- No register associated to the address, do nothing
					null;

			end case;

		end procedure p_avs_writedata;

		variable v_subunit_write_address : std_logic_vector(31 downto 0)         := (others => '0');
		variable v_avs_write_address     : t_srme_avalon_mm_rmap_subunit_address := 0;
	begin
		if (rst_i = '1') then
			subunit_rmap_o.waitrequest   <= '1';
			avalon_mm_rmap_o.waitrequest <= '1';
			s_data_acquired              <= '0';
			p_subunit_reg_reset;
			v_subunit_write_address      := (others => '0');
			v_avs_write_address          := 0;
		elsif (rising_edge(clk_i)) then

			subunit_rmap_o.waitrequest   <= '1';
			avalon_mm_rmap_o.waitrequest <= '1';
			p_subunit_reg_trigger;
			s_data_acquired              <= '0';
			if (subunit_rmap_i.write = '1') then
				v_subunit_write_address    := subunit_rmap_i.address;
				subunit_rmap_o.waitrequest <= '0';
				s_data_acquired            <= '1';
				if (s_data_acquired = '0') then
					p_subunit_mem_wr(v_subunit_write_address);
				end if;
			elsif (avalon_mm_rmap_i.write = '1') then
				v_avs_write_address          := to_integer(unsigned(avalon_mm_rmap_i.address));
				avalon_mm_rmap_o.waitrequest <= '0';
				s_data_acquired              <= '1';
				if (s_data_acquired = '0') then
					p_avs_writedata(v_avs_write_address);
				end if;
			end if;

		end if;
	end process p_srme_rmap_mem_area_subunit_write;

end architecture RTL;
