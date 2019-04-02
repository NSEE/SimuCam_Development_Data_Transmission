library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_data_buffer_pkg.all;

entity avalon_mm_data_buffer_write_ent is
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		avalon_mm_data_buffer_i : in  t_avalon_mm_data_buffer_write_in;
		avalon_mm_data_buffer_o : out t_avalon_mm_data_buffer_write_out;
		channel_data_write_o    : out std_logic;
		channel_data_o          : out std_logic_vector(63 downto 0)
	);
end entity avalon_mm_data_buffer_write_ent;

architecture RTL of avalon_mm_data_buffer_write_ent is

begin

	p_avalon_mm_data_buffer_write : process(clk_i, rst_i) is
		procedure p_reset_registers is
		begin
			channel_data_write_o <= '0';
			channel_data_o       <= (others => '0');
		end procedure p_reset_registers;

		procedure p_control_triggers is
		begin
			channel_data_write_o <= '0';
			channel_data_o       <= (others => '0');
		end procedure p_control_triggers;

		procedure p_writedata(write_address_i : t_avalon_mm_data_buffer_address) is
		begin

			-- Registers Write Data
			case (write_address_i) is
				-- Case for access to all registers address

				when 0 to 1024 =>       --TODO: confirmar tamanho de dados
				--TODO: confirmar funcinamento do modulo
					channel_data_write_o <= '1';
					channel_data_o       <= f_pixels_data_little_to_big_endian(avalon_mm_data_buffer_i.writedata);

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
