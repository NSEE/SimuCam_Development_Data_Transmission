library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.srme_rmap_mem_area_subunit_pkg.all;
use work.srme_avalon_mm_rmap_subunit_pkg.all;

entity srme_rmap_mem_area_subunit_read_ent is
	port(
		clk_i                      : in  std_logic;
		rst_i                      : in  std_logic;
		subunit_rmap_i             : in  t_srme_subunit_rmap_read_in;
		avalon_mm_rmap_i           : in  t_srme_avalon_mm_rmap_subunit_read_in;
		subunit_mem_addr_offset_i  : in  std_logic_vector(31 downto 0);
		rmap_mem_area_rd_status_i  : in  t_rmap_memory_area_rd_status;
		subunit_rmap_o             : out t_srme_subunit_rmap_read_out;
		avalon_mm_rmap_o           : out t_srme_avalon_mm_rmap_subunit_read_out;
		rmap_mem_area_rd_control_o : out t_rmap_memory_area_rd_control
	);
end entity srme_rmap_mem_area_subunit_read_ent;

architecture RTL of srme_rmap_mem_area_subunit_read_ent is

	signal s_rd_started   : std_logic;
	signal s_rd_finished  : std_logic;
	signal s_rd_delay_cnt : natural range 0 to c_SRME_SUBUNIT_MEMORY_AREA_RD_DELAY;

begin

	p_srme_rmap_mem_area_subunit_read : process(clk_i, rst_i) is
		procedure p_subunit_reg_reset is
		begin

			-- Read Control Reset/Default State

			rmap_mem_area_rd_control_o.rd_address <= (others => '0');
			s_rd_started                          <= '0';
			s_rd_finished                         <= '0';
			s_rd_delay_cnt                        <= c_SRME_SUBUNIT_MEMORY_AREA_RD_DELAY;

		end procedure p_subunit_reg_reset;

		procedure p_subunit_reg_trigger is
		begin

			-- Read Control Triggers Reset

			rmap_mem_area_rd_control_o.rd_address <= (others => '0');
			s_rd_started                          <= '0';
			s_rd_finished                         <= '0';
			s_rd_delay_cnt                        <= c_SRME_SUBUNIT_MEMORY_AREA_RD_DELAY;

		end procedure p_subunit_reg_trigger;

		procedure p_subunit_rmap_mem_rd(rd_addr_i : std_logic_vector) is
		begin

			-- MemArea Data Read

			-- check if a read was not just finished
			if (s_rd_finished = '0') then
				-- a read was not just finished
				-- check if a read is not already in progress
				if (s_rd_started = '0') then
					-- a read is not already in progress, perform read
					-- check if the read address is valid (uper address bits are the same as the offset)
					if (rd_addr_i(31 downto c_SRME_SUBUNIT_MEMORY_AREA_WIDTH) = subunit_mem_addr_offset_i(31 downto c_SRME_SUBUNIT_MEMORY_AREA_WIDTH)) then
						-- read address is valid, perform read
						rmap_mem_area_rd_control_o.rd_address <= rd_addr_i((c_SRME_SUBUNIT_MEMORY_AREA_WIDTH - 1) downto 0);
						-- set the read started flag
						s_rd_started                          <= '1';
						subunit_rmap_o.readdata               <= (others => '0');
						-- keep waitrequest setted
						subunit_rmap_o.waitrequest            <= '1';
					else
						-- read address is not valid, return zero
						rmap_mem_area_rd_control_o.rd_address <= (others => '0');
						subunit_rmap_o.readdata               <= (others => '0');
					end if;
				else
					-- a read is already in progress, wait read delay
					-- keep the adress signal
					rmap_mem_area_rd_control_o.rd_address <= rd_addr_i((c_SRME_SUBUNIT_MEMORY_AREA_WIDTH - 1) downto 0);
					s_rd_started                          <= '1';
					subunit_rmap_o.readdata               <= (others => '0');
					-- check if the read delay is finished
					if (s_rd_delay_cnt = 0) then
						-- the read delay is finished
						s_rd_started            <= '0';
						s_rd_finished           <= '1';
						-- update readata with valid value
						subunit_rmap_o.readdata <= rmap_mem_area_rd_status_i.rd_data;
					else
						-- the read delay is not finished
						-- decrement the read delay counter
						s_rd_delay_cnt             <= s_rd_delay_cnt - 1;
						-- keep waitrequest setted
						subunit_rmap_o.waitrequest <= '1';
					end if;
				end if;
			else
				-- a read was just finished
				-- keep the  output signals
				rmap_mem_area_rd_control_o.rd_address <= rd_addr_i((c_SRME_SUBUNIT_MEMORY_AREA_WIDTH - 1) downto 0);
				subunit_rmap_o.readdata               <= rmap_mem_area_rd_status_i.rd_data;
				-- clear read finished flag
				s_rd_finished                         <= '0';
			end if;

		end procedure p_subunit_rmap_mem_rd;

		-- p_avalon_mm_rmap_read

		procedure p_avs_readdata(read_address_i : t_srme_avalon_mm_rmap_subunit_address) is
		begin

			-- check if a read was not just finished
			if (s_rd_finished = '0') then
				-- a read was not just finished
				-- check if a read is not already in progress
				if (s_rd_started = '0') then
					-- a read is not already in progress, perform read
					case (avalon_mm_rmap_i.byteenable) is
						when "0001" =>
							-- first byte
							rmap_mem_area_rd_control_o.rd_address(11 downto 2) <= read_address_i(9 downto 0);
							rmap_mem_area_rd_control_o.rd_address(1 downto 0)  <= "00"; -- Byte Address = 0
							-- set the read started flag
							s_rd_started                                       <= '1';
							avalon_mm_rmap_o.readdata                          <= (others => '0');
							-- keep waitrequest setted
							avalon_mm_rmap_o.waitrequest                       <= '1';
						when "0010" =>
							-- second byte
							rmap_mem_area_rd_control_o.rd_address(11 downto 2) <= read_address_i(9 downto 0);
							rmap_mem_area_rd_control_o.rd_address(1 downto 0)  <= "01"; -- Byte Address = 1
							-- set the read started flag
							s_rd_started                                       <= '1';
							avalon_mm_rmap_o.readdata                          <= (others => '0');
							-- keep waitrequest setted
							avalon_mm_rmap_o.waitrequest                       <= '1';
						when "0100" =>
							-- third byte
							rmap_mem_area_rd_control_o.rd_address(11 downto 2) <= read_address_i(9 downto 0);
							rmap_mem_area_rd_control_o.rd_address(1 downto 0)  <= "10"; -- Byte Address = 2
							-- set the read started flag
							s_rd_started                                       <= '1';
							avalon_mm_rmap_o.readdata                          <= (others => '0');
							-- keep waitrequest setted
							avalon_mm_rmap_o.waitrequest                       <= '1';
						when "1000" =>
							-- fourth byte
							rmap_mem_area_rd_control_o.rd_address(11 downto 2) <= read_address_i(9 downto 0);
							rmap_mem_area_rd_control_o.rd_address(1 downto 0)  <= "11"; -- Byte Address = 3
							-- set the read started flag
							s_rd_started                                       <= '1';
							avalon_mm_rmap_o.readdata                          <= (others => '0');
							-- keep waitrequest setted
							avalon_mm_rmap_o.waitrequest                       <= '1';
						when others =>
							-- more than one byte selected, do nothing
							-- clear the read started flag 
							s_rd_started                          <= '0';
							-- read address is not valid, return zero
							rmap_mem_area_rd_control_o.rd_address <= (others => '0');
							avalon_mm_rmap_o.readdata             <= (others => '0');
					end case;
				else
					-- a read is already in progress, wait read delay
					-- keep the adress signal
					case (avalon_mm_rmap_i.byteenable) is
						when "0001" =>
							-- first byte
							rmap_mem_area_rd_control_o.rd_address(11 downto 2) <= read_address_i(9 downto 0);
							rmap_mem_area_rd_control_o.rd_address(1 downto 0)  <= "00"; -- Byte Address = 0
							s_rd_started                                       <= '1';
							avalon_mm_rmap_o.readdata                          <= (others => '0');
						when "0010" =>
							-- second byte
							rmap_mem_area_rd_control_o.rd_address(11 downto 2) <= read_address_i(9 downto 0);
							rmap_mem_area_rd_control_o.rd_address(1 downto 0)  <= "01"; -- Byte Address = 1
							s_rd_started                                       <= '1';
							avalon_mm_rmap_o.readdata                          <= (others => '0');
						when "0100" =>
							-- third byte
							rmap_mem_area_rd_control_o.rd_address(11 downto 2) <= read_address_i(9 downto 0);
							rmap_mem_area_rd_control_o.rd_address(1 downto 0)  <= "10"; -- Byte Address = 2
							s_rd_started                                       <= '1';
							avalon_mm_rmap_o.readdata                          <= (others => '0');
						when "1000" =>
							-- fourth byte
							rmap_mem_area_rd_control_o.rd_address(11 downto 2) <= read_address_i(9 downto 0);
							rmap_mem_area_rd_control_o.rd_address(1 downto 0)  <= "11"; -- Byte Address = 3
							s_rd_started                                       <= '1';
							avalon_mm_rmap_o.readdata                          <= (others => '0');
						when others =>
							-- more than one byte selected, do nothing
							s_rd_started                          <= '0';
							rmap_mem_area_rd_control_o.rd_address <= (others => '0');
							avalon_mm_rmap_o.readdata             <= (others => '0');
					end case;
					-- check if the read delay is finished
					if (s_rd_delay_cnt = 0) then
						-- the read delay is finished
						s_rd_started              <= '0';
						s_rd_finished             <= '1';
						-- update readata with valid value
						avalon_mm_rmap_o.readdata <= (others => '0');
						case (avalon_mm_rmap_i.byteenable) is
							when "0001" =>
								-- first byte
								avalon_mm_rmap_o.readdata(7 downto 0) <= rmap_mem_area_rd_status_i.rd_data;
							when "0010" =>
								-- second byte
								avalon_mm_rmap_o.readdata(15 downto 8) <= rmap_mem_area_rd_status_i.rd_data;
							when "0100" =>
								-- third byte
								avalon_mm_rmap_o.readdata(23 downto 16) <= rmap_mem_area_rd_status_i.rd_data;
							when "1000" =>
								-- fourth byte
								avalon_mm_rmap_o.readdata(31 downto 24) <= rmap_mem_area_rd_status_i.rd_data;
							when others =>
								avalon_mm_rmap_o.readdata <= (others => '0');
						end case;
					else
						-- the read delay is not finished
						-- decrement the read delay counter
						s_rd_delay_cnt               <= s_rd_delay_cnt - 1;
						-- keep waitrequest setted
						avalon_mm_rmap_o.waitrequest <= '1';
					end if;
				end if;
			else
				-- a read was just finished
				-- keep the  output signals
				avalon_mm_rmap_o.readdata <= (others => '0');
				case (avalon_mm_rmap_i.byteenable) is
					when "0001" =>
						-- first byte
						rmap_mem_area_rd_control_o.rd_address(11 downto 2) <= read_address_i(9 downto 0);
						rmap_mem_area_rd_control_o.rd_address(1 downto 0)  <= "00"; -- Byte Address = 0
						avalon_mm_rmap_o.readdata(7 downto 0)              <= rmap_mem_area_rd_status_i.rd_data;
					when "0010" =>
						-- second byte
						rmap_mem_area_rd_control_o.rd_address(11 downto 2) <= read_address_i(9 downto 0);
						rmap_mem_area_rd_control_o.rd_address(1 downto 0)  <= "01"; -- Byte Address = 1
						avalon_mm_rmap_o.readdata(15 downto 8)             <= rmap_mem_area_rd_status_i.rd_data;
					when "0100" =>
						-- third byte
						rmap_mem_area_rd_control_o.rd_address(11 downto 2) <= read_address_i(9 downto 0);
						rmap_mem_area_rd_control_o.rd_address(1 downto 0)  <= "10"; -- Byte Address = 2
						avalon_mm_rmap_o.readdata(23 downto 16)            <= rmap_mem_area_rd_status_i.rd_data;
					when "1000" =>
						-- fourth byte
						rmap_mem_area_rd_control_o.rd_address(11 downto 2) <= read_address_i(9 downto 0);
						rmap_mem_area_rd_control_o.rd_address(1 downto 0)  <= "11"; -- Byte Address = 3
						avalon_mm_rmap_o.readdata(31 downto 24)            <= rmap_mem_area_rd_status_i.rd_data;
					when others =>
						-- more than one byte selected, do nothing
						s_rd_started                          <= '0';
						rmap_mem_area_rd_control_o.rd_address <= (others => '0');
						avalon_mm_rmap_o.readdata             <= (others => '0');
				end case;
				-- clear read finished flag
				s_rd_finished             <= '0';
			end if;

		end procedure p_avs_readdata;

		variable v_subunit_read_address : std_logic_vector(31 downto 0)         := (others => '0');
		variable v_avs_read_address     : t_srme_avalon_mm_rmap_subunit_address := (others => '0');
	begin
		if (rst_i = '1') then
			subunit_rmap_o.readdata      <= (others => '0');
			subunit_rmap_o.waitrequest   <= '1';
			avalon_mm_rmap_o.readdata    <= (others => '0');
			avalon_mm_rmap_o.waitrequest <= '1';
			p_subunit_reg_reset;
			v_subunit_read_address       := (others => '0');
			v_avs_read_address           := (others => '0');
		elsif (rising_edge(clk_i)) then

			subunit_rmap_o.readdata      <= (others => '0');
			subunit_rmap_o.waitrequest   <= '1';
			avalon_mm_rmap_o.readdata    <= (others => '0');
			avalon_mm_rmap_o.waitrequest <= '1';
			p_subunit_reg_trigger;
			if (subunit_rmap_i.read = '1') then
				v_subunit_read_address     := subunit_rmap_i.address;
				subunit_rmap_o.waitrequest <= '0';
				p_subunit_rmap_mem_rd(v_subunit_read_address);
			elsif (avalon_mm_rmap_i.read = '1') then
				v_avs_read_address           := avalon_mm_rmap_i.address;
				avalon_mm_rmap_o.waitrequest <= '0';
				p_avs_readdata(v_avs_read_address);
			end if;

		end if;
	end process p_srme_rmap_mem_area_subunit_read;

end architecture RTL;
