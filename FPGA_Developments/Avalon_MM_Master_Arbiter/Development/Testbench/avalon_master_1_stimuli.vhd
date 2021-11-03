library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity avalon_master_1_stimuli is
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
end entity avalon_master_1_stimuli;

architecture RTL of avalon_master_1_stimuli is

	signal s_wr_counter : natural := 0;
	signal s_rd_counter : natural := 0;

begin

	p_avalon_master_1_stimuli : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			avalon_mm_read_o      <= '0';
			s_wr_counter          <= 0;
			s_rd_counter          <= 0;

		elsif rising_edge(clk_i) then

			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			avalon_mm_read_o      <= '0';
--			s_wr_counter          <= s_wr_counter + 1;
			s_rd_counter          <= s_rd_counter + 1;

			case s_wr_counter is

				when (500) =>
					-- register write
					if (avalon_mm_waitrequest_i = '1') then
						--					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#00#, g_ADDRESS_WIDTH));
						avalon_mm_address_o                <= std_logic_vector(to_unsigned(16#3D#, g_ADDRESS_WIDTH));
						avalon_mm_write_o                  <= '1';
						avalon_mm_writedata_o              <= (others => '1');
						avalon_mm_writedata_o(23 downto 0) <= x"5E12FA";
						s_wr_counter                       <= s_wr_counter;
					end if;

				when others =>
					null;

			end case;

			case s_rd_counter is

				when (1000) =>
					-- register read
					if (avalon_mm_waitrequest_i = '1') then
						--					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#00#, g_ADDRESS_WIDTH));
						avalon_mm_address_o <= std_logic_vector(to_unsigned(16#3D#, g_ADDRESS_WIDTH));
						avalon_mm_read_o    <= '1';
						s_rd_counter        <= s_rd_counter;
					end if;

				when others =>
					null;

			end case;

		end if;
	end process p_avalon_master_1_stimuli;

end architecture RTL;
