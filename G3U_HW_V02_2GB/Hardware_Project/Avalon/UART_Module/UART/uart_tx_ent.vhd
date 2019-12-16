library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx_ent is
	port(
		-- general inputs
		clk_i                 : in  std_logic;
		rst_i                 : in  std_logic;
		-- specific inputs
		uart_tx_fifo_empty_i  : in  std_logic;
		uart_tx_fifo_rddata_i : in  std_logic_vector(7 downto 0);
		-- specific outputs
		uart_tx_o             : out std_logic;
		uart_tx_fifo_rdreq_o  : out std_logic
	);
end entity uart_tx_ent;

architecture RTL of uart_tx_ent is

	type t_uart_tx_states is (
		START_BIT,                      -- uart tx send start bit
		DATA_BITS,                      -- uart tx send data bits 
		STOP_BIT                        -- uart tx send stop bit
	);
	signal s_uart_tx_state : t_uart_tx_states;

	constant c_UART_TX_DATA_SIZE      : natural                                                   := 8;
	constant c_UART_TX_BAUD_RATE_SIZE : natural                                                   := 16;
	constant c_UART_TX_BAUD_RATE_DIV  : std_logic_vector((c_UART_TX_BAUD_RATE_SIZE - 1) downto 0) := X"01B2"; -- Baud Rate of 115200 bps @ 50 MHz [err = 0,006%]

	signal s_data_word     : std_logic_vector((c_UART_TX_DATA_SIZE - 1) downto 0);
	signal s_data_word_cnt : natural range 0 to (c_UART_TX_DATA_SIZE - 1);
	signal s_baud_rate_cnt : std_logic_vector((c_UART_TX_BAUD_RATE_SIZE - 1) downto 0);
	signal s_transmitting  : std_logic;

begin

	p_uart_tx : process(clk_i, rst_i) is
		variable v_uart_tx_state : t_uart_tx_states := START_BIT;
	begin
		if (rst_i = '1') then
			-- fsm state reset
			s_uart_tx_state      <= START_BIT;
			v_uart_tx_state      := START_BIT;
			-- internal signals reset
			s_data_word          <= (others => '0');
			s_data_word_cnt      <= 0;
			s_baud_rate_cnt      <= (others => '0');
			s_transmitting       <= '0';
			-- outputs reset
			uart_tx_o            <= '1';
			uart_tx_fifo_rdreq_o <= '0';
		elsif (rising_edge(clk_i)) then

			-- Baud Rate generation
			-- check if the baud rate counter is going to overflow 
			if (s_baud_rate_cnt = c_UART_TX_BAUD_RATE_DIV) then
				-- baud rate counter is going to overflow
				-- reset the baud rate counter
				s_baud_rate_cnt <= (others => '0');
			else
				-- baud rate counter is not going to overflow
				-- increment the baud rate counter
				s_baud_rate_cnt <= std_logic_vector(unsigned(s_baud_rate_cnt) + 1);
			end if;

			-- States transitions FSM
			case (s_uart_tx_state) is

				-- state "START_BIT"
				when START_BIT =>
					-- uart tx waiting for start bit
					-- default state transition
					s_uart_tx_state      <= START_BIT;
					v_uart_tx_state      := START_BIT;
					-- default internal signal values
					uart_tx_o            <= '1';
					uart_tx_fifo_rdreq_o <= '0';
					s_data_word          <= (others => '0');
					s_data_word_cnt      <= 0;
					-- conditional state transition
					-- check it is not in the middle of a transmission
					if (s_transmitting = '0') then
						-- not in the middle of a transmission
						-- check if there is data in the fifo to be sent
						if (uart_tx_fifo_empty_i = '0') then
							-- there is data in the fifo to be sent
							-- send a start bit
							uart_tx_o            <= '0';
							-- reset the baud rate counter
							s_baud_rate_cnt      <= (others => '0');
							-- register the data word
							s_data_word          <= uart_tx_fifo_rddata_i;
							-- request a read to the fifo
							uart_tx_fifo_rdreq_o <= '1';
							-- set transmission
							s_transmitting       <= '1';
						end if;
					else
						-- in the middle of a transmission
						uart_tx_o <= '0';
						-- check if it it data transmission time
						if (s_baud_rate_cnt = c_UART_tx_BAUD_RATE_DIV) then
							-- data transmission time
							-- clear transmission
							s_transmitting  <= '0';
							-- go to data bits
							s_uart_tx_state <= DATA_BITS;
							v_uart_tx_state := DATA_BITS;
						end if;
					end if;

				-- state "DATA_BITS"
				when DATA_BITS =>
					-- uart tx data bits reception
					-- default state transition
					s_uart_tx_state      <= DATA_BITS;
					v_uart_tx_state      := DATA_BITS;
					-- default internal signal values
					uart_tx_fifo_rdreq_o <= '0';
					uart_tx_o            <= s_data_word(s_data_word_cnt);
					-- conditional state transition
					-- check if it it data transmission time
					if (s_baud_rate_cnt = c_UART_tx_BAUD_RATE_DIV) then
						-- data transmission time
						-- check if the data word ended
						if (s_data_word_cnt = (c_UART_tx_DATA_SIZE - 1)) then
							-- data word ended
							-- reset word bit counter
							s_data_word_cnt <= 0;
							-- go to stop bit
							s_uart_tx_state <= STOP_BIT;
							v_uart_tx_state := STOP_BIT;
						else
							-- data word not finished
							-- increment word bit counter
							s_data_word_cnt <= s_data_word_cnt + 1;
						end if;
					end if;

				-- state "STOP_BIT"
				when STOP_BIT =>
					-- uart tx stop bit reception
					-- default state transition
					s_uart_tx_state <= STOP_BIT;
					v_uart_tx_state := STOP_BIT;
					-- send a stop bit
					uart_tx_o       <= '1';
					-- conditional state transition
					-- check if it it data transmission time
					if (s_baud_rate_cnt = c_UART_tx_BAUD_RATE_DIV) then
						-- data transmission time
						-- go to start bit
						s_uart_tx_state <= START_BIT;
						v_uart_tx_state := START_BIT;
					end if;

				-- all the other states (not defined)
				when others =>
					s_uart_tx_state <= START_BIT;
					v_uart_tx_state := START_BIT;

			end case;

--			-- Output generation FSM
--			case (v_uart_tx_state) is
--
--				-- state "START_BIT"
--				when START_BIT =>
--					-- uart tx waiting for start bit
--					-- default output signals
--					uart_tx_fifo_rdreq_o <= '0';
--					uart_tx_fifo_data_o  <= (others => '0');
--				-- conditional output signals
--
--				-- state "DATA_BITS"
--				when DATA_BITS =>
--					-- uart tx data bits reception
--					-- default output signals
--					uart_tx_fifo_rdreq_o <= '0';
--					uart_tx_fifo_data_o  <= (others => '0');
--				-- conditional output signals
--
--				-- state "STOP_BIT"
--				when STOP_BIT =>
--					-- uart tx stop bit reception
--					-- default output signals
--					uart_tx_fifo_rdreq_o <= '1';
--					uart_tx_fifo_data_o  <= s_data_word;
--					-- conditional output signals
--
--			end case;

		end if;
	end process p_uart_tx;

end architecture RTL;
