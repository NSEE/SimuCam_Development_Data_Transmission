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

                when x"0000000000000000" => dcom_tb_avs_avalon_mm_o.readdata <= x"00000019000003E8";
                when x"0000000000000008" => dcom_tb_avs_avalon_mm_o.readdata <= x"0100000100000228";
                when x"0000000000000010" => dcom_tb_avs_avalon_mm_o.readdata <= x"8877665544332211";
                when x"0000000000000018" => dcom_tb_avs_avalon_mm_o.readdata <= x"D7FFEEDDCCBBAA99";
                when x"0000000000000020" => dcom_tb_avs_avalon_mm_o.readdata <= x"0000000000000012";
                when x"0000000000000028" => dcom_tb_avs_avalon_mm_o.readdata <= x"00000019000007D0";
                when x"0000000000000030" => dcom_tb_avs_avalon_mm_o.readdata <= x"0200000100000228";
                when x"0000000000000038" => dcom_tb_avs_avalon_mm_o.readdata <= x"8877665544332211";
                when x"0000000000000040" => dcom_tb_avs_avalon_mm_o.readdata <= x"3FFFEEDDCCBBAA99";
                when x"0000000000000048" => dcom_tb_avs_avalon_mm_o.readdata <= x"000000000000005F";
                when x"0000000000000050" => dcom_tb_avs_avalon_mm_o.readdata <= x"0000001900000BB8";
                when x"0000000000000058" => dcom_tb_avs_avalon_mm_o.readdata <= x"0300000100000228";
                when x"0000000000000060" => dcom_tb_avs_avalon_mm_o.readdata <= x"8877665544332211";
                when x"0000000000000068" => dcom_tb_avs_avalon_mm_o.readdata <= x"97FFEEDDCCBBAA99";
                when x"0000000000000070" => dcom_tb_avs_avalon_mm_o.readdata <= x"000000000000007B";
                when x"0000000000000078" => dcom_tb_avs_avalon_mm_o.readdata <= x"0000001900000FA0";
                when x"0000000000000080" => dcom_tb_avs_avalon_mm_o.readdata <= x"0400000100000228";
                when x"0000000000000088" => dcom_tb_avs_avalon_mm_o.readdata <= x"8877665544332211";
                when x"0000000000000090" => dcom_tb_avs_avalon_mm_o.readdata <= x"FFFFEEDDCCBBAA99";
                when x"0000000000000098" => dcom_tb_avs_avalon_mm_o.readdata <= x"00000000000000E4";
                when x"00000000000000A0" => dcom_tb_avs_avalon_mm_o.readdata <= x"0000001900001388";
                when x"00000000000000A8" => dcom_tb_avs_avalon_mm_o.readdata <= x"0500000100000228";
                when x"00000000000000B0" => dcom_tb_avs_avalon_mm_o.readdata <= x"8877665544332211";
                when x"00000000000000B8" => dcom_tb_avs_avalon_mm_o.readdata <= x"57FFEEDDCCBBAA99";
                when x"00000000000000C0" => dcom_tb_avs_avalon_mm_o.readdata <= x"00000000000000C0";
                when x"00000000000000C8" => dcom_tb_avs_avalon_mm_o.readdata <= x"0000000000000000";
                when x"00000000000000D0" => dcom_tb_avs_avalon_mm_o.readdata <= x"0000000000000000";
                when x"00000000000000D8" => dcom_tb_avs_avalon_mm_o.readdata <= x"0000000000000000";
                when x"00000000000000E0" => dcom_tb_avs_avalon_mm_o.readdata <= x"0000000000000000";
                when x"00000000000000E8" => dcom_tb_avs_avalon_mm_o.readdata <= x"0000000000000000";
                when x"00000000000000F0" => dcom_tb_avs_avalon_mm_o.readdata <= x"0000000000000000";
                when x"00000000000000F8" => dcom_tb_avs_avalon_mm_o.readdata <= x"0000000000000000";

                --when x"0000000000000000" => 
                --                    dcom_tb_avs_avalon_mm_o.readdata(31 downto 0)  <= std_logic_vector(to_unsigned(1000, 32)); -- data time
                --                    dcom_tb_avs_avalon_mm_o.readdata(63 downto 32) <= std_logic_vector(to_unsigned(25, 32)); -- data length
                --when x"0000000000000008" => dcom_tb_avs_avalon_mm_o.readdata <= x"0102030405060708";
                --when x"0000000000000010" => dcom_tb_avs_avalon_mm_o.readdata <= x"090A0B0C0D0E0F10";
                --when x"0000000000000018" => dcom_tb_avs_avalon_mm_o.readdata <= x"1112131415161718";
                --when x"0000000000000020" => dcom_tb_avs_avalon_mm_o.readdata <= x"1900000000000000";
                --when x"0000000000000028" => 
                --                    dcom_tb_avs_avalon_mm_o.readdata(31 downto 0)  <= std_logic_vector(to_unsigned(2000, 32)); -- data time
                --                    dcom_tb_avs_avalon_mm_o.readdata(63 downto 32) <= std_logic_vector(to_unsigned(25, 32)); -- data length
                --when x"0000000000000030" => dcom_tb_avs_avalon_mm_o.readdata <= x"0102030405060708";
                --when x"0000000000000038" => dcom_tb_avs_avalon_mm_o.readdata <= x"090A0B0C0D0E0F10";
                --when x"0000000000000040" => dcom_tb_avs_avalon_mm_o.readdata <= x"1112131415161718";
                --when x"0000000000000048" => dcom_tb_avs_avalon_mm_o.readdata <= x"1900000000000000";
                --when x"0000000000000050" => 
                --                    dcom_tb_avs_avalon_mm_o.readdata(31 downto 0)  <= std_logic_vector(to_unsigned(3000, 32)); -- data time
                --                    dcom_tb_avs_avalon_mm_o.readdata(63 downto 32) <= std_logic_vector(to_unsigned(25, 32)); -- data length
                --when x"0000000000000058" => dcom_tb_avs_avalon_mm_o.readdata <= x"0102030405060708";
                --when x"0000000000000060" => dcom_tb_avs_avalon_mm_o.readdata <= x"090A0B0C0D0E0F10";
                --when x"0000000000000068" => dcom_tb_avs_avalon_mm_o.readdata <= x"1112131415161718";
                --when x"0000000000000070" => dcom_tb_avs_avalon_mm_o.readdata <= x"1900000000000000";
                --when x"0000000000000078" => 
                --                    dcom_tb_avs_avalon_mm_o.readdata(31 downto 0)  <= std_logic_vector(to_unsigned(4000, 32)); -- data time
                --                    dcom_tb_avs_avalon_mm_o.readdata(63 downto 32) <= std_logic_vector(to_unsigned(25, 32)); -- data length
                --when x"0000000000000080" => dcom_tb_avs_avalon_mm_o.readdata <= x"0102030405060708";
                --when x"0000000000000088" => dcom_tb_avs_avalon_mm_o.readdata <= x"090A0B0C0D0E0F10";
                --when x"0000000000000090" => dcom_tb_avs_avalon_mm_o.readdata <= x"1112131415161718";
                --when x"0000000000000098" => dcom_tb_avs_avalon_mm_o.readdata <= x"1900000000000000";
                --when x"00000000000000A0" => 
                --                    dcom_tb_avs_avalon_mm_o.readdata(31 downto 0)  <= std_logic_vector(to_unsigned(5000, 32)); -- data time
                --                    dcom_tb_avs_avalon_mm_o.readdata(63 downto 32) <= std_logic_vector(to_unsigned(25, 32)); -- data length
                --when x"00000000000000A8" => dcom_tb_avs_avalon_mm_o.readdata <= x"0102030405060708";
                --when x"00000000000000B0" => dcom_tb_avs_avalon_mm_o.readdata <= x"090A0B0C0D0E0F10";
                --when x"00000000000000B8" => dcom_tb_avs_avalon_mm_o.readdata <= x"1112131415161718";
                --when x"00000000000000C0" => dcom_tb_avs_avalon_mm_o.readdata <= x"1900000000000000";
                --when x"00000000000000C8" => 
                --                    dcom_tb_avs_avalon_mm_o.readdata(31 downto 0)  <= std_logic_vector(to_unsigned(6000, 32)); -- data time
                --                    dcom_tb_avs_avalon_mm_o.readdata(63 downto 32) <= std_logic_vector(to_unsigned(25, 32)); -- data length
                --when x"00000000000000D0" => dcom_tb_avs_avalon_mm_o.readdata <= x"0102030405060708";
                --when x"00000000000000D8" => dcom_tb_avs_avalon_mm_o.readdata <= x"090A0B0C0D0E0F10";
                --when x"00000000000000E0" => dcom_tb_avs_avalon_mm_o.readdata <= x"1112131415161718";
                --when x"00000000000000E8" => dcom_tb_avs_avalon_mm_o.readdata <= x"1900000000000000";
                --when x"00000000000000F0" => 
                --                    dcom_tb_avs_avalon_mm_o.readdata(31 downto 0)  <= std_logic_vector(to_unsigned(7000, 32)); -- data time
                --                    dcom_tb_avs_avalon_mm_o.readdata(63 downto 32) <= std_logic_vector(to_unsigned(25, 32)); -- data length
                --when x"00000000000000F8" => dcom_tb_avs_avalon_mm_o.readdata <= x"0102030405060708";
                --when x"0000000000000100" => dcom_tb_avs_avalon_mm_o.readdata <= x"090A0B0C0D0E0F10";
                --when x"0000000000000108" => dcom_tb_avs_avalon_mm_o.readdata <= x"1112131415161718";
                --when x"0000000000000110" => dcom_tb_avs_avalon_mm_o.readdata <= x"1900000000000000";

                when others =>
                    -- No register associated to the address, return with 0x00000000
                    dcom_tb_avs_avalon_mm_o.readdata <= (others => '0');

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
