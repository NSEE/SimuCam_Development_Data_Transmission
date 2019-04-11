library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_data_buffer_pkg.all;

entity avalon_mm_data_buffer_write_ent is
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		avalon_mm_data_buffer_i : in  t_avalon_mm_data_buffer_write_in;
		avs_dbuffer_full_i      : in  std_logic;
		avs_bebuffer_full_i     : in  std_logic;
		avalon_mm_data_buffer_o : out t_avalon_mm_data_buffer_write_out;
		avs_dbuffer_wrreq_o     : out std_logic;
		avs_dbuffer_wrdata_o    : out std_logic_vector((c_AVALON_MM_DATA_BUFFER_DATA_SIZE - 1) downto 0);
		avs_bebuffer_wrreq_o    : out std_logic;
		avs_bebuffer_wrdata_o   : out std_logic_vector(((c_AVALON_MM_DATA_BUFFER_DATA_SIZE / c_AVALON_MM_DATA_BUFFER_SYMBOL_SIZE) - 1) downto 0)
	);
end entity avalon_mm_data_buffer_write_ent;

architecture RTL of avalon_mm_data_buffer_write_ent is

	signal s_data_written : std_logic;

begin

	p_avalon_mm_data_buffer_write : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			avs_dbuffer_wrreq_o   <= '0';
			avs_dbuffer_wrdata_o  <= (others => '0');
			avs_bebuffer_wrreq_o  <= '0';
			avs_bebuffer_wrdata_o <= (others => '0');
			s_data_written        <= '0';
		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin
			avs_dbuffer_wrreq_o   <= '0';
			avs_dbuffer_wrdata_o  <= (others => '0');
			avs_bebuffer_wrreq_o  <= '0';
			avs_bebuffer_wrdata_o <= (others => '0');
			s_data_written        <= '0';
		end procedure p_control_triggers;

		procedure p_writedata(write_address_i : t_avalon_mm_data_buffer_address) is
		begin

			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				when 0 to 2047 =>

					if (s_data_written = '0') then
						if ((avs_dbuffer_full_i = '0') and (avs_bebuffer_full_i = '0')) then
							avs_dbuffer_wrreq_o   <= '1';
							avs_dbuffer_wrdata_o  <= avalon_mm_data_buffer_i.writedata;
							avs_bebuffer_wrreq_o  <= '1';
							avs_bebuffer_wrdata_o <= avalon_mm_data_buffer_i.byteenable;
						end if;
						s_data_written <= '1';
					end if;

				when others =>
					null;
			end case;

		end procedure p_writedata;

		variable v_write_address : t_avalon_mm_data_buffer_address := 0;
	begin
		if (rst_i = '1') then
			avalon_mm_data_buffer_o.waitrequest <= '1';
			v_write_address                     := 0;
			p_reset_registers;
		elsif (rising_edge(clk_i)) then
			avalon_mm_data_buffer_o.waitrequest <= '1';
			p_control_triggers;
			if (avalon_mm_data_buffer_i.write = '1') then
				avalon_mm_data_buffer_o.waitrequest <= '0';
				v_write_address                     := to_integer(unsigned(avalon_mm_data_buffer_i.address));
				p_writedata(v_write_address);
			end if;
		end if;
	end process p_avalon_mm_data_buffer_write;

end architecture RTL;
