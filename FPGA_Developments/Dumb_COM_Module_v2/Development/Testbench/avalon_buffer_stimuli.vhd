library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity avalon_buffer_stimuli is
    generic(
        g_ADDRESS_WIDTH    : natural range 1 to 64;
        g_DATA_WIDTH       : natural range 1 to 256;
        g_BYTEENABLE_WIDTH : natural range 1 to 8
    );
    port(
        clk_i                   : in  std_logic;
        rst_i                   : in  std_logic;
        avalon_mm_waitrequest_i : in  std_logic; --                                          -- avalon_mm.waitrequest
        avalon_mm_address_o     : out std_logic_vector((g_ADDRESS_WIDTH - 1) downto 0); --   --          .address
        avalon_mm_write_o       : out std_logic; --                                          --          .write
        avalon_mm_writedata_o   : out std_logic_vector((g_DATA_WIDTH - 1) downto 0); --      --          .writedata
        avalon_mm_byteenable_o  : out std_logic_vector((g_BYTEENABLE_WIDTH - 1) downto 0) -- --          .writedata
    );
end entity avalon_buffer_stimuli;

architecture RTL of avalon_buffer_stimuli is

    signal s_counter     : natural                                     := 0;
    signal s_address_cnt : natural range 0 to (2**g_ADDRESS_WIDTH - 1) := 0;
    signal s_times_cnt   : natural                                     := 0;

    -- Write Payload
    constant c_DCOM_WR_PAYLOAD_LENGTH : natural                                           := 60;
    signal s_dcom_wr_payload_cnt      : natural range 0 to (c_DCOM_WR_PAYLOAD_LENGTH - 1) := 0;
    type t_dcom_prot_write_payload is array (0 to (c_DCOM_WR_PAYLOAD_LENGTH - 1)) of std_logic_vector(g_DATA_WIDTH downto 0);
    constant c_DCOM_WR_PAYLOAD_DATA   : t_dcom_prot_write_payload                         := (
        x"123456789ABCDEF1", x"23456789ABCDEF12", x"3456789ABCDEF123", x"456789ABCDEF1234",
        x"56789ABCDEF12345", x"6789ABCDEF123456", x"789ABCDEF1234567", x"89ABCDEF12345678",
        x"9ABCDEF123456789", x"ABCDEF123456789A", x"BCDEF123456789AB", x"CDEF123456789ABC",
        x"DEF123456789ABCD", x"EF123456789ABCDE", x"F123456789ABCDEF", x"123456789ABCDEF1",
        x"23456789ABCDEF12", x"3456789ABCDEF123", x"456789ABCDEF1234", x"56789ABCDEF12345",
        x"6789ABCDEF123456", x"789ABCDEF1234567", x"89ABCDEF12345678", x"9ABCDEF123456789",
        x"ABCDEF123456789A", x"BCDEF123456789AB", x"CDEF123456789ABC", x"DEF123456789ABCD",
        x"EF123456789ABCDE", x"F123456789ABCDEF", x"123456789ABCDEF1", x"23456789ABCDEF12",
        x"3456789ABCDEF123", x"456789ABCDEF1234", x"56789ABCDEF12345", x"6789ABCDEF123456",
        x"789ABCDEF1234567", x"89ABCDEF12345678", x"9ABCDEF123456789", x"ABCDEF123456789A",
        x"BCDEF123456789AB", x"CDEF123456789ABC", x"DEF123456789ABCD", x"EF123456789ABCDE",
        x"F123456789ABCDEF", x"123456789ABCDEF1", x"23456789ABCDEF12", x"3456789ABCDEF123",
        x"456789ABCDEF1234", x"56789ABCDEF12345", x"6789ABCDEF123456", x"789ABCDEF1234567",
        x"89ABCDEF12345678", x"9ABCDEF123456789", x"ABCDEF123456789A", x"BCDEF123456789AB",
        x"CDEF123456789ABC", x"DEF123456789ABCD", x"EF123456789ABCDE", x"F123456789ABCDEF"
    );

begin

    p_avalon_buffer_stimuli : process(clk_i, rst_i) is
    begin
        if (rst_i = '1') then

            avalon_mm_address_o   <= (others => '0');
            avalon_mm_write_o     <= '0';
            avalon_mm_writedata_o <= (others => '0');
            s_dcom_wr_payload_cnt <= 0;
            s_counter             <= 0;
            s_address_cnt         <= 0;
            s_times_cnt           <= 0;

        elsif rising_edge(clk_i) then

            avalon_mm_address_o   <= (others => '0');
            avalon_mm_write_o     <= '0';
            avalon_mm_writedata_o <= (others => '0');
            s_counter             <= s_counter + 1;

            case s_counter is

                when 100 =>
                    -- register write
                    avalon_mm_address_o   <= std_logic_vector(to_unsigned(s_address_cnt, g_ADDRESS_WIDTH));
                    avalon_mm_write_o     <= '1';
                    avalon_mm_writedata_o <= c_DCOM_WR_PAYLOAD_DATA(s_dcom_wr_payload_cnt);

                when 101 =>
                    if (avalon_mm_waitrequest_i = '1') then
                        s_counter <= 101;
                    end if;
                    -- register write
                    avalon_mm_address_o   <= std_logic_vector(to_unsigned(s_address_cnt, g_ADDRESS_WIDTH));
                    avalon_mm_write_o     <= '1';
                    avalon_mm_writedata_o <= c_DCOM_WR_PAYLOAD_DATA(s_dcom_wr_payload_cnt);

                when 102 =>
                    s_counter     <= 100;
                    if (s_dcom_wr_payload_cnt = (c_DCOM_WR_PAYLOAD_LENGTH - 1)) then
                        s_dcom_wr_payload_cnt <= 0;
                    else
                        s_dcom_wr_payload_cnt <= s_dcom_wr_payload_cnt + 1;
                    end if;
                    s_address_cnt <= s_address_cnt + 1;
                    if (s_address_cnt = ((2 ** g_ADDRESS_WIDTH) - 1)) then
                        --                    if (s_address_cnt = (16 - 1)) then
                        if (s_times_cnt < (1 - 1)) then
                            s_counter     <= 100;
                            s_address_cnt <= 0;
                            s_times_cnt   <= s_times_cnt + 1;
                        else
                            s_counter     <= 5000;
                            s_address_cnt <= 0;
                            s_times_cnt   <= 0;
                        end if;
                    end if;

                when others =>
                    null;

            end case;

        end if;
    end process p_avalon_buffer_stimuli;

end architecture RTL;
