library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity config_avalon_stimuli is
	generic(
		g_ADDRESS_WIDTH : natural range 1 to 64;
		g_DATA_WIDTH    : natural range 1 to 64
	);
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		avalon_mm_readdata_i    : in  std_logic_vector((g_DATA_WIDTH - 1) downto 0); -- -- avalon_mm.readdata
		avalon_mm_waitrequest_i : in  std_logic; --                                     --          .waitrequest
		avalon_mm_address_o     : out std_logic_vector((g_ADDRESS_WIDTH - 1) downto 0); --          .address
		avalon_mm_write_o       : out std_logic; --                                     --          .write
		avalon_mm_writedata_o   : out std_logic_vector((g_DATA_WIDTH - 1) downto 0); -- --          .writedata
		avalon_mm_read_o        : out std_logic --                                      --          .read
	);
end entity config_avalon_stimuli;

architecture RTL of config_avalon_stimuli is

	signal s_counter : natural := 0;

begin

	p_config_avalon_stimuli : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			avalon_mm_read_o      <= '0';
			s_counter             <= 0;

		elsif rising_edge(clk_i) then

			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			avalon_mm_read_o      <= '0';
			s_counter             <= s_counter + 1;

			case s_counter is

				-- timer_clear
				when 500 to 501 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#1F#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '1'; -- timer_clear           
					avalon_mm_read_o         <= '0';

				-- timer_start
				when 550 to 551 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#1C#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '1'; -- timer_start 
					avalon_mm_read_o         <= '0';

				-- rd_data_length_bytes
				when 600 to 601 =>
					-- register write
					avalon_mm_address_o   <= std_logic_vector(to_unsigned(16#2F#, g_ADDRESS_WIDTH));
					avalon_mm_write_o     <= '1';
--					avalon_mm_writedata_o <= std_logic_vector(to_unsigned(16384, 32));
					avalon_mm_writedata_o <= std_logic_vector(to_unsigned(511, 32));
					avalon_mm_read_o      <= '0';

				-- rd_start
				when 650 to 651 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#30#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '1'; -- rd_start 
					avalon_mm_read_o         <= '0';
					
				-- timer_run
				when 1000 to 1001 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#1D#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '1'; -- timer_run
					avalon_mm_read_o         <= '0';

				when others =>
					null;

			end case;

		end if;
	end process p_config_avalon_stimuli;

end architecture RTL;
