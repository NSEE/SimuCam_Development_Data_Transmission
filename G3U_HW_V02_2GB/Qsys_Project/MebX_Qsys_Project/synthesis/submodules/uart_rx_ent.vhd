library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx_ent is
	port(
		-- general inputs
		clk_i                 : in  std_logic;
		rst_i                 : in  std_logic;
		-- specific inputs
		uart_rx_i             : in  std_logic;
		uart_rx_fifo_full_i   : in  std_logic;
		-- specific outputs
		uart_rx_fifo_wrreq_o  : out std_logic;
		uart_rx_fifo_wrdata_o : out std_logic_vector(7 downto 0)
	);
end entity uart_rx_ent;

architecture RTL of uart_rx_ent is

	type t_uart_rx_states is (
		START_BIT,                      -- uart rx waiting for start bit
		DATA_BITS,                      -- uart rx data bits reception 
		STOP_BIT                        -- uart rx stop bit reception
	);
	signal s_uart_tx_state : t_uart_rx_states;

	constant c_UART_RX_DATA_SIZE      : natural                                                   := 8;
	constant c_UART_RX_BAUD_RATE_SIZE : natural                                                   := 16;
	constant c_UART_RX_BAUD_RATE_DIV  : std_logic_vector((c_UART_RX_BAUD_RATE_SIZE - 1) downto 0) := X"01B2"; -- Baud Rate of 115200 bps @ 50 MHz [err = 0,006%]

	signal s_data_word     : std_logic_vector((c_UART_RX_DATA_SIZE - 1) downto 0);
	signal s_data_word_cnt : natural range 0 to (c_UART_RX_DATA_SIZE - 1);
	signal s_baud_rate_cnt : std_logic_vector((c_UART_RX_BAUD_RATE_SIZE - 1) downto 0);

	signal s_uart_rx_delayed : std_logic;

	signal s_receiving : std_logic;

	signal s_sampled : std_logic;

	signal s_sampled_bit : std_logic;

	signal s_sample_cnt : natural := 0;

begin

	p_uart_rx : process(clk_i, rst_i) is
		variable v_uart_tx_state : t_uart_rx_states := START_BIT;
	begin
		if (rst_i = '1') then
			-- fsm state reset
			s_uart_tx_state       <= START_BIT;
			v_uart_tx_state       := START_BIT;
			-- internal signals reset
			s_data_word           <= (others => '0');
			s_data_word_cnt       <= 0;
			s_baud_rate_cnt       <= (others => '0');
			s_uart_rx_delayed     <= '0';
			s_receiving           <= '0';
			s_sampled             <= '0';
			s_sampled_bit         <= '0';
			s_sample_cnt          <= 0;
			-- outputs reset
			uart_rx_fifo_wrreq_o  <= '0';
			uart_rx_fifo_wrdata_o <= (others => '0');
		elsif (rising_edge(clk_i)) then

			-- Baud Rate generation

			-- check if in receiving
			if (s_receiving = '0') then
				-- keep baud rate counter a zero
				s_baud_rate_cnt <= (others => '0');
				--check is a start condition ocurred (falling edge)
				if ((uart_rx_i = '0') and (s_uart_rx_delayed = '1')) then
					-- start condition ocurred (falling edge)
					-- enter in receiving
					s_receiving     <= '1';
					-- increment the baud rate counter
					s_baud_rate_cnt <= std_logic_vector(unsigned(s_baud_rate_cnt) + 1);
				end if;
			else
				-- in receiving
				-- check if the baud rate counter is going to overflow 
				if (unsigned(s_baud_rate_cnt) = (unsigned(c_UART_RX_BAUD_RATE_DIV) - 1)) then
					-- baud rate counter is going to overflow
					-- reset the baud rate counter
					s_baud_rate_cnt <= (others => '0');
				else
					-- a transition has not happened in the uart rx and the baud rate counter is not going to overflow
					-- increment the baud rate counter
					s_baud_rate_cnt <= std_logic_vector(unsigned(s_baud_rate_cnt) + 1);
				end if;
				-- check if a transition happened in the uart rx
				if (((uart_rx_i) xor (s_uart_rx_delayed)) = '1') then
					-- a transition happened in the uart rx
					-- check if signal was already sampled or not
					if (s_sampled = '0') then
						-- signal already sampled, reset the baud rate counter
--						s_baud_rate_cnt <= (others => '0');
					else
						-- signal not sampled yet, set the baud rate counter to overflow
--						s_baud_rate_cnt <= std_logic_vector(unsigned(c_UART_RX_BAUD_RATE_DIV) - 1);
					end if;
					-- reset the baud rate counter
					--					s_baud_rate_cnt <= (others => '0');

					--					s_baud_rate_cnt <= std_logic_vector(unsigned(c_UART_RX_BAUD_RATE_DIV) - 1);
				end if;
			end if;
			-- delay uart rx
			s_uart_rx_delayed <= uart_rx_i;

			--			-- check if in receiving
			--			if (s_receiving = '0') then
			--				-- not receiving
			--				-- keep baud rate counter a zero
			--				s_baud_rate_cnt <= (others => '0');
			--				--check is a start condition ocurred (falling edge)
			--				if ((uart_rx_i = '0') and (s_uart_rx_delayed = '1')) then
			--					-- enter in receiving
			--					s_receiving <= '1';
			--				end if;
			--			end if;

			-- States transitions FSM
			case (s_uart_tx_state) is

				-- state "START_BIT"
				when START_BIT =>
					-- uart rx waiting for start bit
					-- default state transition
					s_uart_tx_state       <= START_BIT;
					v_uart_tx_state       := START_BIT;
					-- default internal signal values
					uart_rx_fifo_wrreq_o  <= '0';
					uart_rx_fifo_wrdata_o <= (others => '0');
					s_data_word           <= (others => '0');
					s_data_word_cnt       <= 0;
					-- conditional state transition
					-- check if in receiving
					--					if (s_receiving = '0') then
					--						-- not receiving
					--						-- keep baud rate counter a zero
					--						s_baud_rate_cnt <= (others => '0');
					--						--check is a start condition ocurred (falling edge)
					--						if ((uart_rx_i = '0') and (s_uart_rx_delayed = '1')) then
					--							-- enter in receiving
					--							s_receiving <= '1';
					--						end if;
					--					else
					if (uart_rx_i = '1') then
						s_sample_cnt <= s_sample_cnt + 1;
					end if;
					-- receiving, check if it it data sampling time	
					if (unsigned(s_baud_rate_cnt) = unsigned(c_UART_RX_BAUD_RATE_DIV) / 2) then
						-- data sampling time
						s_sampled_bit <= uart_rx_i;
						s_sampled     <= '1';
					-- check if the current bit ended
					--					elsif ((unsigned(s_baud_rate_cnt) = (unsigned(c_UART_RX_BAUD_RATE_DIV) - 1)) or (s_new_bit = '1')) then
					elsif ((unsigned(s_baud_rate_cnt) = (unsigned(c_UART_RX_BAUD_RATE_DIV) - 1))) then
						-- current bit ended
						s_baud_rate_cnt <= (others => '0');
						s_sampled       <= '0';
						-- check if a start bit was received
						--						if (s_sampled_bit = '0') then
						if (s_sample_cnt < (unsigned(c_UART_RX_BAUD_RATE_DIV) / 2)) then -- bit = '0'
							-- start bit received, go to data bits processing
							s_uart_tx_state <= DATA_BITS;
							v_uart_tx_state := DATA_BITS;
						end if;
						s_sample_cnt    <= 0;
					end if;
				--					end if;

				-- state "DATA_BITS"
				when DATA_BITS =>
					-- uart rx data bits reception
					-- default state transition
					s_uart_tx_state       <= DATA_BITS;
					v_uart_tx_state       := DATA_BITS;
					-- default internal signal values
					uart_rx_fifo_wrreq_o  <= '0';
					uart_rx_fifo_wrdata_o <= (others => '0');
					-- conditional state transition
					if (uart_rx_i = '1') then
						s_sample_cnt <= s_sample_cnt + 1;
					end if;
					-- check if it it data sampling time
					if (unsigned(s_baud_rate_cnt) = (unsigned(c_UART_RX_BAUD_RATE_DIV) / 2)) then
						-- data sampling time
						s_sampled_bit <= uart_rx_i;
						s_sampled     <= '1';
					-- check if the current bit ended
					--					elsif ((unsigned(s_baud_rate_cnt) = (unsigned(c_UART_RX_BAUD_RATE_DIV) - 1)) or (s_new_bit = '1')) then
					elsif ((unsigned(s_baud_rate_cnt) = (unsigned(c_UART_RX_BAUD_RATE_DIV) - 1))) then
						-- current bit ended
						s_baud_rate_cnt <= (others => '0');
						s_sampled       <= '0';
						--						s_data_word(s_data_word_cnt) <= s_sampled_bit;
						if (s_sample_cnt < (unsigned(c_UART_RX_BAUD_RATE_DIV) / 2)) then -- bit = '0'
							s_data_word(s_data_word_cnt) <= '0';
						else            -- bit = '1'
							s_data_word(s_data_word_cnt) <= '1';
						end if;
						s_sample_cnt    <= 0;
						-- check if the data word ended
						if (s_data_word_cnt = (c_UART_RX_DATA_SIZE - 1)) then
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
					-- uart rx stop bit reception
					-- default state transition
					s_uart_tx_state <= STOP_BIT;
					v_uart_tx_state := STOP_BIT;
					-- conditional state transition
					if (uart_rx_i = '1') then
						s_sample_cnt <= s_sample_cnt + 1;
					end if;
					-- check if it it data sampling time
					if (unsigned(s_baud_rate_cnt) = (unsigned(c_UART_RX_BAUD_RATE_DIV) / 2)) then
						-- data sampling time
						s_sampled_bit <= uart_rx_i;
						s_sampled     <= '1';
					-- check if the current bit ended
					--					elsif ((unsigned(s_baud_rate_cnt) = (unsigned(c_UART_RX_BAUD_RATE_DIV) - 1)) or (s_new_bit = '1')) then
					elsif ((unsigned(s_baud_rate_cnt) = (unsigned(c_UART_RX_BAUD_RATE_DIV) - 1))) then
						-- current bit ended
						s_baud_rate_cnt <= (others => '0');
						s_sampled       <= '0';
						-- check if a stop bit was received
						--						if (s_sampled_bit = '1') then
						if (s_sample_cnt >= (unsigned(c_UART_RX_BAUD_RATE_DIV) / 2)) then -- bit = '1'
							-- start bit received, return to wait for another start bit
							s_uart_tx_state       <= START_BIT;
							v_uart_tx_state       := START_BIT;
							-- record data word
							uart_rx_fifo_wrreq_o  <= '1';
							uart_rx_fifo_wrdata_o <= s_data_word;
						else
							s_uart_tx_state       <= START_BIT;
							v_uart_tx_state       := START_BIT;
							uart_rx_fifo_wrreq_o  <= '1';
							uart_rx_fifo_wrdata_o <= s_data_word;
						end if;
						s_sample_cnt    <= 0;
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
			--					-- uart rx waiting for start bit
			--					-- default output signals
			----					uart_rx_fifo_wrreq_o  <= '0';
			----					uart_rx_fifo_wrdata_o <= (others => '0');
			--				-- conditional output signals
			--
			--				-- state "DATA_BITS"
			--				when DATA_BITS =>
			--					-- uart rx data bits reception
			--					-- default output signals
			----					uart_rx_fifo_wrreq_o  <= '0';
			----					uart_rx_fifo_wrdata_o <= (others => '0');
			--				-- conditional output signals
			--
			--				-- state "STOP_BIT"
			--				when STOP_BIT =>
			--					-- uart rx stop bit reception
			--					-- default output signals
			--					--					uart_rx_fifo_wrreq_o  <= '1';
			--					--					uart_rx_fifo_wrdata_o <= s_data_word;
			--					-- conditional output signals
			--
			--		end case;

		end if;
	end process p_uart_rx;

end architecture RTL;
