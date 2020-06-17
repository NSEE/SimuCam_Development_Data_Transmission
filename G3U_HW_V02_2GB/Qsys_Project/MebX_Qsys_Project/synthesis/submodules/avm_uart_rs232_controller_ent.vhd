library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity avm_uart_rs232_controller_ent is
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		tx_data_fifo_empty_i    : in  std_logic;
		tx_data_fifo_rddata_i   : in  std_logic_vector(7 downto 0);
		rx_data_fifo_full_i     : in  std_logic;
		avm_rs232_readdata_i    : in  std_logic_vector(15 downto 0);
		avm_rs232_waitrequest_i : in  std_logic;
		tx_data_fifo_rdreq_o    : out std_logic;
		rx_data_fifo_wrreq_o    : out std_logic;
		rx_data_fifo_wrdata_o   : out std_logic_vector(7 downto 0);
		avm_rs232_address_o     : out std_logic_vector(5 downto 0);
		avm_rs232_write_o       : out std_logic;
		avm_rs232_writedata_o   : out std_logic_vector(15 downto 0);
		avm_rs232_read_o        : out std_logic
	);
end entity avm_uart_rs232_controller_ent;

architecture RTL of avm_uart_rs232_controller_ent is

begin

	p_avm_uart_rs232_controller : process(clk_i, rst_i) is
		variable v_cnt      : natural   := 0;
		variable v_tx_ready : std_logic := '0';
		variable v_rx_ready : std_logic := '0';
	begin
		if (rst_i = '1') then
			avm_rs232_address_o   <= (others => '0');
			avm_rs232_read_o      <= '0';
			avm_rs232_write_o     <= '0';
			avm_rs232_writedata_o <= (others => '0');
			rx_data_fifo_wrdata_o <= (others => '0');
			tx_data_fifo_rdreq_o  <= '0';
			rx_data_fifo_wrreq_o  <= '0';
			v_cnt                 := 0;
			v_tx_ready            := '0';
			v_tx_ready            := '0';
		elsif rising_edge(clk_i) then

			avm_rs232_address_o   <= (others => '0');
			avm_rs232_read_o      <= '0';
			avm_rs232_write_o     <= '0';
			avm_rs232_writedata_o <= (others => '0');
			rx_data_fifo_wrdata_o <= (others => '0');
			tx_data_fifo_rdreq_o  <= '0';
			rx_data_fifo_wrreq_o  <= '0';

			case (v_cnt) is

				-- get status
				when 10 =>
					avm_rs232_address_o <= std_logic_vector(to_unsigned(8, avm_rs232_address_o'length)); -- status reg
					avm_rs232_read_o    <= '1';

				when 11 =>
					if (avm_rs232_waitrequest_i = '1') then
						avm_rs232_address_o <= std_logic_vector(to_unsigned(8, avm_rs232_address_o'length)); -- status reg
						avm_rs232_read_o    <= '1';
						v_cnt               := 10;
						v_tx_ready          := '0';
						v_rx_ready          := '0';
					else
						v_tx_ready := avm_rs232_readdata_i(6);
						v_rx_ready := avm_rs232_readdata_i(7);
						if ((v_tx_ready = '1') and (tx_data_fifo_empty_i = '0')) then
							v_cnt := 20;
						elsif ((v_rx_ready = '1') and (rx_data_fifo_full_i = '0')) then
							v_cnt := 30;
						else
							v_cnt := 0;
						end if;
					end if;

				-- tx data
				when 25 =>
					avm_rs232_address_o                <= std_logic_vector(to_unsigned(4, avm_rs232_address_o'length)); -- tx data reg
					avm_rs232_write_o                  <= '1';
					avm_rs232_writedata_o(15 downto 8) <= x"00";
					avm_rs232_writedata_o(7 downto 0)  <= tx_data_fifo_rddata_i;
					tx_data_fifo_rdreq_o               <= '0';

				when 26 =>
					if (avm_rs232_waitrequest_i = '1') then
						avm_rs232_address_o                <= std_logic_vector(to_unsigned(4, avm_rs232_address_o'length)); -- tx data reg
						avm_rs232_write_o                  <= '1';
						avm_rs232_writedata_o(15 downto 8) <= x"00";
						avm_rs232_writedata_o(7 downto 0)  <= tx_data_fifo_rddata_i;
						tx_data_fifo_rdreq_o               <= '0';
						v_cnt                              := 25;
					else
						tx_data_fifo_rdreq_o <= '1';
						v_cnt                := 0;
					end if;

				-- rx data
				when 35 =>
					avm_rs232_address_o   <= std_logic_vector(to_unsigned(0, avm_rs232_address_o'length)); -- rx data reg
					avm_rs232_read_o      <= '1';
					rx_data_fifo_wrdata_o <= (others => '0');
					rx_data_fifo_wrreq_o  <= '0';

				when 36 =>
					if (avm_rs232_waitrequest_i = '1') then
						avm_rs232_address_o   <= std_logic_vector(to_unsigned(0, avm_rs232_address_o'length)); -- rx data reg
						avm_rs232_read_o      <= '1';
						rx_data_fifo_wrdata_o <= (others => '0');
						rx_data_fifo_wrreq_o  <= '0';
						v_cnt                 := 35;
					else
						rx_data_fifo_wrdata_o <= avm_rs232_readdata_i(7 downto 0);
						rx_data_fifo_wrreq_o  <= '1';
						v_cnt                 := 0;
					end if;

				when others =>
					null;

			end case;

			v_cnt := v_cnt + 1;

		end if;
	end process p_avm_uart_rs232_controller;

end architecture RTL;
