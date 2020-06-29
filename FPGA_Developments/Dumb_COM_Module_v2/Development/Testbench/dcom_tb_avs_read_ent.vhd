library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.dcom_tb_avs_pkg.all;

entity dcom_tb_avs_read_ent is
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		dcom_tb_avs_avalon_mm_i : in  t_dcom_tb_avs_avalon_mm_read_in;
		dcom_tb_avs_avalon_mm_o : out t_dcom_tb_avs_avalon_mm_read_out
	);
end entity dcom_tb_avs_read_ent;

architecture rtl of dcom_tb_avs_read_ent is

begin

	p_dcom_tb_avs_read : process(clk_i, rst_i) is
		procedure p_readdata(read_address_i : t_dcom_tb_avs_avalon_mm_address) is
		begin

			-- Registers Data Read
			case (read_address_i) is
				-- Case for access to all registers address

				when x"0000000000000000" =>
					dcom_tb_avs_avalon_mm_o.readdata(31 downto 0)  <= std_logic_vector(to_unsigned(1000, 32)); -- data time
					dcom_tb_avs_avalon_mm_o.readdata(47 downto 32) <= std_logic_vector(to_unsigned(3000, 16)); -- data length
					dcom_tb_avs_avalon_mm_o.readdata(55 downto 48) <= std_logic_vector(to_unsigned(16#AA#, 8)); -- data 0
					dcom_tb_avs_avalon_mm_o.readdata(63 downto 56) <= std_logic_vector(to_unsigned(16#BB#, 8)); -- data 1

				when others =>
					-- No register associated to the address, return with 0x00000000
					dcom_tb_avs_avalon_mm_o.readdata <= (others => '1');

			end case;

		end procedure p_readdata;

		variable v_read_address : t_dcom_tb_avs_avalon_mm_address := (others => '0');
	begin
		if (rst_i = '1') then
			dcom_tb_avs_avalon_mm_o.readdata    <= (others => '0');
			dcom_tb_avs_avalon_mm_o.waitrequest <= '1';
			v_read_address                      := (others => '0');
		elsif (rising_edge(clk_i)) then
			dcom_tb_avs_avalon_mm_o.readdata    <= (others => '0');
			dcom_tb_avs_avalon_mm_o.waitrequest <= '1';
			if (dcom_tb_avs_avalon_mm_i.read = '1') then
				v_read_address                      := unsigned(dcom_tb_avs_avalon_mm_i.address);
				dcom_tb_avs_avalon_mm_o.waitrequest <= '0';
				p_readdata(v_read_address);
			end if;
		end if;
	end process p_dcom_tb_avs_read;

end architecture rtl;
