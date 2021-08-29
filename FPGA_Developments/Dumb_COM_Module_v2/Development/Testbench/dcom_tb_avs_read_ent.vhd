library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

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

    constant c_DCOM_TB_AVS_AVALON_MM_ADRESS_SHIFT : natural := integer(ceil(log2(real(c_DCOM_TB_AVS_AVALON_MM_DATA_SIZE / c_DCOM_TB_AVS_AVALON_MM_SYMBOL_SIZE))));

    -- testbench data
    constant c_TESTBENCH_DATA_LENGTH : natural                                          := 3;
    signal s_testebench_data_cnt     : natural range 0 to (c_TESTBENCH_DATA_LENGTH - 1) := 0;
    type t_testbench_data is array (0 to (c_TESTBENCH_DATA_LENGTH - 1)) of std_logic_vector((c_DCOM_TB_AVS_AVALON_MM_DATA_SIZE - 1) downto 0);
    constant c_TESTBENCH_DATASET     : t_testbench_data                                 := (
        x"1000010000000000",
        x"7766554433221100",
        x"FFEEDDCCBBAA9988"
    );

begin

    p_dcom_tb_avs_read : process(clk_i, rst_i) is
        procedure p_readdata(read_address_i : std_logic_vector) is
            variable v_read_word_addr : natural range 0 to (c_TESTBENCH_DATA_LENGTH - 1) := 0;
        begin

            -- set read word addr
            v_read_word_addr := to_integer(unsigned(read_address_i((c_DCOM_TB_AVS_AVALON_MM_ADRESS_SIZE - 1) downto c_DCOM_TB_AVS_AVALON_MM_ADRESS_SHIFT))) mod (c_TESTBENCH_DATA_LENGTH);

            -- return imgdata
            dcom_tb_avs_avalon_mm_o.readdata <= c_TESTBENCH_DATASET(v_read_word_addr);

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
                dcom_tb_avs_avalon_mm_o.waitrequest <= '0';
                p_readdata(dcom_tb_avs_avalon_mm_i.address);
            end if;
        end if;
    end process p_dcom_tb_avs_read;

end architecture rtl;
