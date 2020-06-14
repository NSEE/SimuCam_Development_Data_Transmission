library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.srme_rmap_mem_area_subunit_pkg.all;
use work.srme_avalon_mm_rmap_subunit_pkg.all;

entity srme_rmap_mem_area_subunit_write_ent is
	port(
		clk_i                      : in  std_logic;
		rst_i                      : in  std_logic;
		subunit_rmap_i             : in  t_srme_subunit_rmap_write_in;
		avalon_mm_rmap_i           : in  t_srme_avalon_mm_rmap_subunit_write_in;
		subunit_mem_addr_offset_i  : in  std_logic_vector(31 downto 0);
		subunit_rmap_o             : out t_srme_subunit_rmap_write_out;
		avalon_mm_rmap_o           : out t_srme_avalon_mm_rmap_subunit_write_out;
		rmap_mem_area_wr_control_o : out t_rmap_memory_area_wr_control
	);
end entity srme_rmap_mem_area_subunit_write_ent;

architecture RTL of srme_rmap_mem_area_subunit_write_ent is

	signal s_data_acquired : std_logic;

begin

	p_srme_rmap_mem_area_subunit_write : process(clk_i, rst_i) is
		procedure p_subunit_reg_reset is
		begin

			-- Write Control Reset/Default State

			rmap_mem_area_wr_control_o.wr_address <= (others => '0');
			rmap_mem_area_wr_control_o.wr_data    <= (others => '0');
			rmap_mem_area_wr_control_o.write      <= '0';

		end procedure p_subunit_reg_reset;

		procedure p_subunit_reg_trigger is
		begin

			-- Write Control Triggers Reset

			rmap_mem_area_wr_control_o.wr_address <= (others => '0');
			rmap_mem_area_wr_control_o.wr_data    <= (others => '0');
			rmap_mem_area_wr_control_o.write      <= '0';

		end procedure p_subunit_reg_trigger;

		procedure p_subunit_mem_wr(wr_addr_i : std_logic_vector) is
		begin

			-- MemArea Write Data

			-- check if the write address is valid (uper address bits are the same as the offset)
			if (wr_addr_i(31 downto c_SRME_SUBUNIT_MEMORY_AREA_WIDTH) = subunit_mem_addr_offset_i(31 downto c_SRME_SUBUNIT_MEMORY_AREA_WIDTH)) then
				-- write address is valid, perform write
				rmap_mem_area_wr_control_o.wr_address <= wr_addr_i((c_SRME_SUBUNIT_MEMORY_AREA_WIDTH - 1) downto 0);
				rmap_mem_area_wr_control_o.wr_data    <= subunit_rmap_i.writedata;
				rmap_mem_area_wr_control_o.write      <= '1';
			else
				-- write address is not valid, do nothing
				rmap_mem_area_wr_control_o.wr_address <= (others => '0');
				rmap_mem_area_wr_control_o.wr_data    <= (others => '0');
				rmap_mem_area_wr_control_o.write      <= '0';
			end if;

		end procedure p_subunit_mem_wr;

		-- p_avalon_mm_rmap_write

		procedure p_avs_writedata(write_address_i : t_srme_avalon_mm_rmap_subunit_address) is
		begin

			-- Registers Write Data

			-- Full Memoery Address: DWord Address (11 downto 3) | Byte Address (1 downto 0)
			---- DWord Address (11 downto 2) is from Avalon Address 
			---- Byte Address (1 downto 0) is from Byte Enable

			case (avalon_mm_rmap_i.byteenable) is

				when "0001" =>
					-- first byte
					rmap_mem_area_wr_control_o.wr_address(11 downto 2) <= write_address_i(9 downto 0);
					rmap_mem_area_wr_control_o.wr_address(1 downto 0)  <= "00"; -- Byte Address = 0
					rmap_mem_area_wr_control_o.wr_data                 <= avalon_mm_rmap_i.writedata(7 downto 0);
					rmap_mem_area_wr_control_o.write                   <= '1';

				when "0010" =>
					-- second byte
					rmap_mem_area_wr_control_o.wr_address(11 downto 2) <= write_address_i(9 downto 0);
					rmap_mem_area_wr_control_o.wr_address(1 downto 0)  <= "01"; -- Byte Address = 1
					rmap_mem_area_wr_control_o.wr_data                 <= avalon_mm_rmap_i.writedata(15 downto 8);
					rmap_mem_area_wr_control_o.write                   <= '1';

				when "0100" =>
					-- third byte
					rmap_mem_area_wr_control_o.wr_address(11 downto 2) <= write_address_i(9 downto 0);
					rmap_mem_area_wr_control_o.wr_address(1 downto 0)  <= "10"; -- Byte Address = 2
					rmap_mem_area_wr_control_o.wr_data                 <= avalon_mm_rmap_i.writedata(23 downto 16);
					rmap_mem_area_wr_control_o.write                   <= '1';

				when "1000" =>
					-- fourth byte
					rmap_mem_area_wr_control_o.wr_address(11 downto 2) <= write_address_i(9 downto 0);
					rmap_mem_area_wr_control_o.wr_address(1 downto 0)  <= "11"; -- Byte Address = 3
					rmap_mem_area_wr_control_o.wr_data                 <= avalon_mm_rmap_i.writedata(31 downto 24);
					rmap_mem_area_wr_control_o.write                   <= '1';

				when others =>
					-- more than one byte selected, do nothing 
					null;

			end case;

		end procedure p_avs_writedata;

		variable v_subunit_write_address : std_logic_vector(31 downto 0)         := (others => '0');
		variable v_avs_write_address     : t_srme_avalon_mm_rmap_subunit_address := (others => '0');
	begin
		if (rst_i = '1') then
			subunit_rmap_o.waitrequest   <= '1';
			avalon_mm_rmap_o.waitrequest <= '1';
			s_data_acquired              <= '0';
			p_subunit_reg_reset;
			v_subunit_write_address      := (others => '0');
			v_avs_write_address          := (others => '0');
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
				v_avs_write_address          := avalon_mm_rmap_i.address;
				avalon_mm_rmap_o.waitrequest <= '0';
				s_data_acquired              <= '1';
				if (s_data_acquired = '0') then
					p_avs_writedata(v_avs_write_address);
				end if;
			end if;

		end if;
	end process p_srme_rmap_mem_area_subunit_write;

end architecture RTL;
