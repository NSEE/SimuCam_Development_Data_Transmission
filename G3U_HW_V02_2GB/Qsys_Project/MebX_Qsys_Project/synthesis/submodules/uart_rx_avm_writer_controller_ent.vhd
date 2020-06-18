library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.uart_avm_data_pkg.all;

entity uart_rx_avm_writer_controller_ent is
	port(
		clk_i                        : in  std_logic;
		rst_i                        : in  std_logic;
		controller_wr_start_i        : in  std_logic;
		controller_wr_reset_i        : in  std_logic;
		controller_wr_initial_addr_i : in  std_logic_vector(63 downto 0);
		controller_wr_length_bytes_i : in  std_logic_vector(31 downto 0);
		controller_rd_busy_i         : in  std_logic;
		avm_master_wr_status_i       : in  t_uart_avm_data_master_wr_status;
		rx_buffer_empty_i            : in  std_logic;
		rx_buffer_rddata_i           : in  std_logic_vector(7 downto 0);
		controller_wr_busy_o         : out std_logic;
		avm_master_wr_control_o      : out t_uart_avm_data_master_wr_control;
		rx_buffer_rdreq_o            : out std_logic
	);
end entity uart_rx_avm_writer_controller_ent;

architecture RTL of uart_rx_avm_writer_controller_ent is

	type t_uart_rx_avm_writer_controller_fsm is (
		IDLE,                           -- rx avm writer controller is in idle
		AVM_WAITING,                    -- avm writer is waiting the avm bus be released
		BUFFER_WAITING,                 -- waiting data buffer to have data
		BUFFER_READ,                    -- read data from data buffer
		BUFFER_FETCH,                   -- fetch data from data buffer
		WRITE_START,                    -- start of a avm write
		WRITE_WAITING,                  -- wait for avm write to finish
		FINISHED                        -- rx avm writer controller is finished
	);

	signal s_uart_rx_avm_writer_controller_state : t_uart_rx_avm_writer_controller_fsm;

	signal s_wr_addr_cnt : unsigned(63 downto 0); -- 2^64 bytes of address / 1 byte per word = 2^64 words of addr
	signal s_wr_data_cnt : unsigned(31 downto 0); -- 2^32 bytes of maximum length / 1 byte per write = 2^32 maximum write length

	constant c_WR_ADDR_OVERFLOW_VAL : unsigned((s_wr_addr_cnt'length - 1) downto 0) := (others => '1');

	signal s_registered_rx_buffer_rddata : std_logic_vector((rx_buffer_rddata_i'length - 1) downto 0);

begin

	p_uart_rx_avm_writer_controller : process(clk_i, rst_i) is
		variable v_uart_rx_avm_writer_controller_state : t_uart_rx_avm_writer_controller_fsm := IDLE;
	begin
		if (rst_i = '1') then
			-- fsm state reset
			s_uart_rx_avm_writer_controller_state <= IDLE;
			v_uart_rx_avm_writer_controller_state := IDLE;
			-- internal signals reset
			s_wr_addr_cnt                         <= to_unsigned(0, s_wr_addr_cnt'length);
			s_wr_data_cnt                         <= to_unsigned(0, s_wr_data_cnt'length);
			s_registered_rx_buffer_rddata         <= (others => '0');
			-- outputs reset
			controller_wr_busy_o                  <= '0';
			avm_master_wr_control_o               <= c_UART_AVM_DATA_MASTER_WR_CONTROL_RST;
			rx_buffer_rdreq_o                     <= '0';
		elsif rising_edge(clk_i) then

			-- States Transition --
			-- States transitions FSM
			case (s_uart_rx_avm_writer_controller_state) is

				-- state "IDLE"
				when IDLE =>
					-- rx avm writer controller is in idle
					-- default state transition
					s_uart_rx_avm_writer_controller_state <= IDLE;
					v_uart_rx_avm_writer_controller_state := IDLE;
					-- default internal signal values
					s_wr_addr_cnt                         <= to_unsigned(0, s_wr_addr_cnt'length);
					s_wr_data_cnt                         <= to_unsigned(0, s_wr_data_cnt'length);
					s_registered_rx_buffer_rddata         <= (others => '0');
					-- conditional state transition
					-- check if a write start was requested
					if (controller_wr_start_i = '1') then
						-- write start requested
						-- set write parameters
						-- set the write addr counter to the (write initial addr / 1)
						s_wr_addr_cnt <= unsigned(controller_wr_initial_addr_i);
						-- set the write data counter to the (write data length / 1)
						s_wr_data_cnt <= unsigned(controller_wr_length_bytes_i);
						-- check if the write data length is not already zero
						if (s_wr_data_cnt /= 0) then
							-- the write data length is not already zero
							-- decrement the write data counter
							s_wr_data_cnt <= s_wr_data_cnt - 1;
						end if;
						-- check if the avm reader controller is busy (using the avm bus)
						if (controller_rd_busy_i = '1') then
							-- the avm reader controller is busy (using the avm bus)
							-- go to avm waiting
							s_uart_rx_avm_writer_controller_state <= AVM_WAITING;
							v_uart_rx_avm_writer_controller_state := AVM_WAITING;
						else
							-- the avm reader controller is free (not using the avm bus)
							-- go to buffer waiting
							s_uart_rx_avm_writer_controller_state <= BUFFER_WAITING;
							v_uart_rx_avm_writer_controller_state := BUFFER_WAITING;
						end if;
					end if;

				-- state "AVM_WAITING"
				when AVM_WAITING =>
					-- avm writer is waiting the avm bus be released
					-- default state transition
					s_uart_rx_avm_writer_controller_state <= AVM_WAITING;
					v_uart_rx_avm_writer_controller_state := AVM_WAITING;
					-- default internal signal values
					s_registered_rx_buffer_rddata         <= (others => '0');
					-- conditional state transition
					-- check if the avm reader controller is free (not using the avm bus)
					if (controller_rd_busy_i = '0') then
						-- the avm reader controller is free (not using the avm bus)
						-- go to buffer waiting
						s_uart_rx_avm_writer_controller_state <= BUFFER_WAITING;
						v_uart_rx_avm_writer_controller_state := BUFFER_WAITING;
					end if;

				-- state "BUFFER_WAITING"
				when BUFFER_WAITING =>
					-- waiting data buffer to have data
					-- default state transition
					s_uart_rx_avm_writer_controller_state <= BUFFER_WAITING;
					v_uart_rx_avm_writer_controller_state := BUFFER_WAITING;
					-- default internal signal values
					s_registered_rx_buffer_rddata         <= (others => '0');
					-- conditional state transition
					-- check if the rx data buffer is not empty and the avm write can start
					if ((rx_buffer_empty_i = '0') and (avm_master_wr_status_i.wr_ready = '1')) then
						-- the rx data buffer is ready to be read and not empty and the avm write can start
						-- go to buffer read
						s_uart_rx_avm_writer_controller_state <= BUFFER_READ;
						v_uart_rx_avm_writer_controller_state := BUFFER_READ;
					end if;

				-- state "BUFFER_READ"
				when BUFFER_READ =>
					-- read data from data buffer
					-- default state transition
					s_uart_rx_avm_writer_controller_state <= BUFFER_FETCH;
					v_uart_rx_avm_writer_controller_state := BUFFER_FETCH;
					-- default internal signal values
					s_registered_rx_buffer_rddata         <= rx_buffer_rddata_i;
				-- conditional state transition

				-- state "BUFFER_FETCH"
				when BUFFER_FETCH =>
					-- fetch data from data buffer
					-- default state transition
					s_uart_rx_avm_writer_controller_state <= WRITE_START;
					v_uart_rx_avm_writer_controller_state := WRITE_START;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_START"
				when WRITE_START =>
					-- start of a avm write
					-- default state transition
					s_uart_rx_avm_writer_controller_state <= WRITE_WAITING;
					v_uart_rx_avm_writer_controller_state := WRITE_WAITING;
				-- default internal signal values
				-- conditional state transition

				-- state "WRITE_WAITING"
				when WRITE_WAITING =>
					-- wait for avm write to finish
					-- default state transition
					s_uart_rx_avm_writer_controller_state <= WRITE_WAITING;
					v_uart_rx_avm_writer_controller_state := WRITE_WAITING;
					-- default internal signal values
					-- conditional state transition
					-- check if the avm write is done
					if (avm_master_wr_status_i.wr_done = '1') then
						-- avm write is done
						-- update write addr counter
						-- check if the write addr counter will overflow
						if (s_wr_addr_cnt = c_WR_ADDR_OVERFLOW_VAL) then
							-- the write addr counter will overflow
							-- clear the write addr counter
							s_wr_addr_cnt <= to_unsigned(0, s_wr_addr_cnt'length);
						else
							-- the write addr counter will not overflow
							-- increment the write addr counter
							s_wr_addr_cnt <= s_wr_addr_cnt + 1;
						end if;
						-- check if there is more data to be write
						if (s_wr_data_cnt = 0) then
							-- there is no more data to be write
							-- go to finished
							s_uart_rx_avm_writer_controller_state <= FINISHED;
							v_uart_rx_avm_writer_controller_state := FINISHED;
						else
							-- there is more data to be write
							-- decrement write data counter
							s_wr_data_cnt <= s_wr_data_cnt - 1;
							-- check if the rx data buffer is not empty and the avm write can start
							if ((rx_buffer_empty_i = '0') and (avm_master_wr_status_i.wr_ready = '1')) then
								-- the rx data buffer is ready to be read and not empty and the avm write can start
								-- go to buffer read
								s_uart_rx_avm_writer_controller_state <= BUFFER_READ;
								v_uart_rx_avm_writer_controller_state := BUFFER_READ;
							else
								-- the rx data buffer is not ready to be read or not empty or the avm write cannot start
								-- go to buffer waiting
								s_uart_rx_avm_writer_controller_state <= BUFFER_WAITING;
								v_uart_rx_avm_writer_controller_state := BUFFER_WAITING;
							end if;
						end if;
					end if;

				-- state "FINISHED"
				when FINISHED =>
					-- rx avm writer controller is finished
					-- default state transition
					s_uart_rx_avm_writer_controller_state <= IDLE;
					v_uart_rx_avm_writer_controller_state := IDLE;
					-- default internal signal values
					s_wr_addr_cnt                         <= to_unsigned(0, s_wr_addr_cnt'length);
					s_wr_data_cnt                         <= to_unsigned(0, s_wr_data_cnt'length);
					s_registered_rx_buffer_rddata         <= (others => '0');
				-- conditional state transition

				-- all the other states (not defined)
				when others =>
					s_uart_rx_avm_writer_controller_state <= IDLE;
					v_uart_rx_avm_writer_controller_state := IDLE;

			end case;

			-- check if a reset was requested
			if (controller_wr_reset_i = '1') then
				-- a reset was requested
				-- go to idle
				s_uart_rx_avm_writer_controller_state <= IDLE;
				v_uart_rx_avm_writer_controller_state := IDLE;
			end if;

			-- Output Generation --
			-- Default output generation
			controller_wr_busy_o    <= '0';
			avm_master_wr_control_o <= c_UART_AVM_DATA_MASTER_WR_CONTROL_RST;
			rx_buffer_rdreq_o       <= '0';
			-- Output generation FSM
			case (v_uart_rx_avm_writer_controller_state) is

				-- state "IDLE"
				when IDLE =>
					-- rx avm writer controller is in idle
					-- default output signals
					null;
				-- conditional output signals

				-- state "AVM_WAITING"
				when AVM_WAITING =>
					-- avm writer is waiting the avm bus be released
					-- default output signals
					controller_wr_busy_o <= '1';
				-- conditional output signals

				-- state "BUFFER_WAITING"
				when BUFFER_WAITING =>
					-- waiting data buffer to have data
					-- default output signals
					controller_wr_busy_o <= '1';
				-- conditional output signals

				-- state "BUFFER_READ"
				when BUFFER_READ =>
					-- read data from data buffer
					-- default output signals
					controller_wr_busy_o <= '1';
					rx_buffer_rdreq_o    <= '1';
				-- conditional output signals

				-- state "BUFFER_FETCH"
				when BUFFER_FETCH =>
					-- fetch data from data buffer
					-- default output signals
					controller_wr_busy_o <= '1';
				-- conditional output signals

				-- state "WRITE_START"
				when WRITE_START =>
					-- start of a avm write
					-- default output signals
					controller_wr_busy_o               <= '1';
					avm_master_wr_control_o.wr_req     <= '1';
					avm_master_wr_control_o.wr_address <= std_logic_vector(s_wr_addr_cnt);
					avm_master_wr_control_o.wr_data    <= s_registered_rx_buffer_rddata;
				-- conditional output signals

				-- state "WRITE_WAITING"
				when WRITE_WAITING =>
					-- wait for avm write to finish
					-- default output signals
					controller_wr_busy_o <= '1';
				-- conditional output signals

				-- state "FINISHED"
				when FINISHED =>
					-- rx avm writer controller is finished
					-- default output signals
					controller_wr_busy_o <= '1';
					-- conditional output signals

			end case;

		end if;
	end process p_uart_rx_avm_writer_controller;

end architecture RTL;
