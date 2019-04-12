library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity avalon_buffer_stimuli is
	generic(
		g_ADDRESS_WIDTH    : natural range 1 to 64;
		g_DATA_WIDTH       : natural range 1 to 64;
		g_BYTEENABLE_WIDTH : natural range 1 to 8
	);
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		avalon_mm_waitrequest_i : in  std_logic; --                                     -- avalon_mm.waitrequest
		avalon_mm_address_o     : out std_logic_vector((g_ADDRESS_WIDTH - 1) downto 0); --          .address
		avalon_mm_write_o       : out std_logic; --                                     --          .write
		avalon_mm_writedata_o   : out std_logic_vector((g_DATA_WIDTH - 1) downto 0); --  --          .writedata
		avalon_mm_byteenable_o  : out std_logic_vector((g_BYTEENABLE_WIDTH - 1) downto 0) --  --          .writedata
	);
end entity avalon_buffer_stimuli;

architecture RTL of avalon_buffer_stimuli is

	function f_next_data(
		curr_data_i   : natural range 0 to 255;
		start_value_i : natural range 0 to 255;
		final_value_i : natural range 0 to 255;
		step_i        : natural range 0 to 255;
		inc_i         : std_logic
	) return natural is
		variable v_next_data : natural range 0 to 255;
	begin

		if (inc_i = '1') then
			if (curr_data_i >= final_value_i) then
				v_next_data := start_value_i;
			else
				v_next_data := curr_data_i + step_i;
			end if;
		else
			if (curr_data_i <= final_value_i) then
				v_next_data := start_value_i;
			else
				v_next_data := curr_data_i - step_i;
			end if;
		end if;

		return v_next_data;
	end function f_next_data;

	--	constant c_RESET_DATA : natural := 255;
	--	constant c_FINAL_DATA : natural := 1;

	constant c_RESET_DATA : natural := 0;
	constant c_FINAL_DATA : natural := 255;

	signal s_counter     : natural                                     := 0;
	signal s_address_cnt : natural range 0 to (2**g_ADDRESS_WIDTH - 1) := 0;
	signal s_mask_cnt    : natural range 0 to 16                       := 0;
	signal s_times_cnt   : natural                                     := 0;

begin

	p_avalon_buffer_stimuli : process(clk_i, rst_i) is
		variable v_data_cnt        : natural range 0 to 255 := c_RESET_DATA;
		variable v_registered_data : std_logic_vector(63 downto 0);
	begin
		if (rst_i = '1') then

			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
						s_counter             <= 0;
--			s_counter             <= 5000;
			--			s_counter             <= 900;
			s_address_cnt         <= 0;
			s_mask_cnt            <= 0;
			s_times_cnt           <= 0;
			v_data_cnt            := c_RESET_DATA;
			v_registered_data     := (others => '0');

		elsif rising_edge(clk_i) then

			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			s_counter             <= s_counter + 1;

			case s_counter is

				when 2500 to 2501 =>
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(0, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '1';
					avalon_mm_writedata_o               <= (others => '0');
					avalon_mm_writedata_o(63 downto 32) <= std_logic_vector(to_unsigned(50, 32)); -- data time
					avalon_mm_writedata_o(31 downto 16) <= std_logic_vector(to_unsigned(25, 16)); -- data length
					avalon_mm_writedata_o(15 downto 8)  <= std_logic_vector(to_unsigned(0, 8)); -- data
					avalon_mm_writedata_o(7 downto 0)   <= std_logic_vector(to_unsigned(1, 8)); -- data
					avalon_mm_byteenable_o              <= "11111111";

				when 2503 to 2504 =>
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(1, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '1';
					avalon_mm_writedata_o               <= (others => '0');
					avalon_mm_writedata_o(63 downto 56) <= std_logic_vector(to_unsigned(2, 8)); -- data
					avalon_mm_writedata_o(55 downto 48) <= std_logic_vector(to_unsigned(3, 8)); -- data
					avalon_mm_writedata_o(47 downto 40) <= std_logic_vector(to_unsigned(4, 8)); -- data
					avalon_mm_writedata_o(39 downto 32) <= std_logic_vector(to_unsigned(5, 8)); -- data
					avalon_mm_writedata_o(31 downto 24) <= std_logic_vector(to_unsigned(6, 8)); -- data
					avalon_mm_writedata_o(23 downto 16) <= std_logic_vector(to_unsigned(7, 8)); -- data
					avalon_mm_writedata_o(15 downto 8)  <= std_logic_vector(to_unsigned(8, 8)); -- data
					avalon_mm_writedata_o(7 downto 0)   <= std_logic_vector(to_unsigned(9, 8)); -- data
					avalon_mm_byteenable_o              <= "11111111";

				when 2506 to 2507 =>
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(2, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '1';
					avalon_mm_writedata_o               <= (others => '0');
					avalon_mm_writedata_o(63 downto 56) <= std_logic_vector(to_unsigned(10, 8)); -- data
					avalon_mm_writedata_o(55 downto 48) <= std_logic_vector(to_unsigned(11, 8)); -- data
					avalon_mm_writedata_o(47 downto 40) <= std_logic_vector(to_unsigned(12, 8)); -- data
					avalon_mm_writedata_o(39 downto 32) <= std_logic_vector(to_unsigned(13, 8)); -- data
					avalon_mm_writedata_o(31 downto 24) <= std_logic_vector(to_unsigned(14, 8)); -- data
					avalon_mm_writedata_o(23 downto 16) <= std_logic_vector(to_unsigned(15, 8)); -- data
					avalon_mm_writedata_o(15 downto 8)  <= std_logic_vector(to_unsigned(16, 8)); -- data
					avalon_mm_writedata_o(7 downto 0)   <= std_logic_vector(to_unsigned(17, 8)); -- data
					avalon_mm_byteenable_o              <= "11111111";

				when 2509 to 2510 =>
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(3, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '1';
					avalon_mm_writedata_o               <= (others => '0');
					avalon_mm_writedata_o(63 downto 56) <= std_logic_vector(to_unsigned(18, 8)); -- data
					avalon_mm_writedata_o(55 downto 48) <= std_logic_vector(to_unsigned(19, 8)); -- data
					avalon_mm_writedata_o(47 downto 40) <= std_logic_vector(to_unsigned(20, 8)); -- data
					avalon_mm_writedata_o(39 downto 32) <= std_logic_vector(to_unsigned(21, 8)); -- data
					avalon_mm_writedata_o(31 downto 24) <= std_logic_vector(to_unsigned(22, 8)); -- data
					avalon_mm_writedata_o(23 downto 16) <= std_logic_vector(to_unsigned(23, 8)); -- data
					avalon_mm_writedata_o(15 downto 8)  <= std_logic_vector(to_unsigned(24, 8)); -- data
					avalon_mm_writedata_o(7 downto 0)   <= std_logic_vector(to_unsigned(25, 8)); -- data
					avalon_mm_byteenable_o              <= "11111111";

				--				when 2500 =>
				--					-- register write
				--					avalon_mm_address_o   <= std_logic_vector(to_unsigned(s_address_cnt, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o     <= '1';
				--					v_registered_data     := (others => '0');
				--					if (s_mask_cnt < 16) then
				--						s_mask_cnt <= s_mask_cnt + 1;
				--						--						v_registered_data(7 downto 0)   := std_logic_vector(to_unsigned(v_data_cnt, 8));
				--						--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 2, '0');
				--						--						v_registered_data(15 downto 8)  := std_logic_vector(to_unsigned(v_data_cnt, 8));
				--						--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 2, '0');
				--						--						v_registered_data(23 downto 16) := std_logic_vector(to_unsigned(v_data_cnt, 8));
				--						--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 2, '0');
				--						--						v_registered_data(31 downto 24) := std_logic_vector(to_unsigned(v_data_cnt, 8));
				--						--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 2, '0');
				--						--						v_registered_data(39 downto 32) := std_logic_vector(to_unsigned(v_data_cnt, 8));
				--						--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 2, '0');
				--						--						v_registered_data(47 downto 40) := std_logic_vector(to_unsigned(v_data_cnt, 8));
				--						--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 2, '0');
				--						--						v_registered_data(55 downto 48) := std_logic_vector(to_unsigned(v_data_cnt, 8));
				--						--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 2, '0');
				--						--						v_registered_data(63 downto 56) := std_logic_vector(to_unsigned(v_data_cnt, 8));
				--						--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 2, '0');
				--
				--						v_registered_data(7 downto 0)   := std_logic_vector(to_unsigned(v_data_cnt, 8));
				--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 1, '1');
				--						v_registered_data(15 downto 8)  := std_logic_vector(to_unsigned(v_data_cnt, 8));
				--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 1, '1');
				--						v_registered_data(23 downto 16) := std_logic_vector(to_unsigned(v_data_cnt, 8));
				--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 1, '1');
				--						v_registered_data(31 downto 24) := std_logic_vector(to_unsigned(v_data_cnt, 8));
				--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 1, '1');
				--						v_registered_data(39 downto 32) := std_logic_vector(to_unsigned(v_data_cnt, 8));
				--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 1, '1');
				--						v_registered_data(47 downto 40) := std_logic_vector(to_unsigned(v_data_cnt, 8));
				--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 1, '1');
				--						v_registered_data(55 downto 48) := std_logic_vector(to_unsigned(v_data_cnt, 8));
				--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 1, '1');
				--						v_registered_data(63 downto 56) := std_logic_vector(to_unsigned(v_data_cnt, 8));
				--						v_data_cnt                      := f_next_data(v_data_cnt, c_RESET_DATA, c_FINAL_DATA, 1, '1');
				--					else
				--						s_mask_cnt        <= 0;
				--						v_registered_data := (others => '1');
				--						--						v_registered_data := x"AAAAAAAAAAAAAAAA";
				--					end if;
				--					avalon_mm_writedata_o <= v_registered_data;
				--					avalon_mm_writedata_o <= v_registered_data;
				--
				--				when 2501 =>
				--					avalon_mm_address_o   <= std_logic_vector(to_unsigned(s_address_cnt, g_ADDRESS_WIDTH));
				--					avalon_mm_write_o     <= '1';
				--					avalon_mm_writedata_o <= v_registered_data;
				--
				--				when 2502 =>
				--					s_counter     <= 2500;
				--					s_address_cnt <= s_address_cnt + 1;
				--					--if (s_address_cnt = (2**g_ADDRESS_WIDTH - 2)) then
				--					--					if (s_address_cnt = (1020 - 1)) then
				--					if (s_address_cnt = (272 - 1)) then
				--						--					if (s_address_cnt = (68 - 1)) then
				--						if (s_times_cnt < 1000) then
				--							--						if (s_times_cnt < 1) then
				--							--							s_counter     <= 2000;
				--							s_counter     <= 2450;
				--							s_address_cnt <= 0;
				--							s_times_cnt   <= s_times_cnt + 1;
				--						else
				--							s_counter     <= 5000;
				--							s_address_cnt <= 0;
				--							s_times_cnt   <= 0;
				--						end if;
				--					end if;

				when others =>
					null;

			end case;

		end if;
	end process p_avalon_buffer_stimuli;

end architecture RTL;
