library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.data_buffer_pkg.all;

entity data_buffer_ent is
	port(
		clk_i                  : in  std_logic;
		rst_i                  : in  std_logic;
		tmr_clear_i            : in  std_logic;
		tmr_stop_i             : in  std_logic;
		tmr_start_i            : in  std_logic;
		avs_dbuffer_wrdata_i   : in  std_logic_vector((c_AVS_DBUFFER_DATA_WIDTH - 1) downto 0);
		avs_dbuffer_wrreq_i    : in  std_logic;
		avs_bebuffer_wrdata_i  : in  std_logic_vector((c_AVS_BEBUFFER_DATA_WIDTH - 1) downto 0);
		avs_bebuffer_wrreq_i   : in  std_logic;
		dcrtl_dbuffer_rdreq_i  : in  std_logic;
		dbuff_empty_o          : out std_logic;
		dbuff_full_o           : out std_logic;
		dbuff_usedw_o          : out std_logic_vector((c_AVS_BUFFER_USED_WIDTH - 1) downto 0);
		avs_dbuffer_full_o     : out std_logic;
		avs_bebuffer_full_o    : out std_logic;
		dcrtl_dbuffer_rddata_o : out std_logic_vector((c_DCTRL_DBUFFER_DATA_WIDTH - 1) downto 0);
		dcrtl_dbuffer_empty_o  : out std_logic
	);
end entity data_buffer_ent;

architecture RTL of data_buffer_ent is

	-- signals for the avs data buffer 
	signal s_avs_dbuffer_fifo   : t_avs_dbuffer_fifo;
	signal s_avs_dbuffer_sclr   : std_logic;
	-- signals for the avs byte enable buffer
	signal s_avs_bebuffer_fifo  : t_avs_bebuffer_fifo;
	signal s_avs_bebuffer_sclr  : std_logic;
	-- signals for the data controller data buffer
	signal s_dctrl_dbuffer_fifo : t_dctrl_dbuffer_fifo;
	signal s_dctrl_dbuffer_sclr : std_logic;

	type t_data_buffer_fsm is (
		STOPPED,                        -- Stopped, reset all internal signals
		WAIT_AVS_FIFO,                  -- Wait state for the avs data and byte enable fifos to have available data
		FETCH_AVS_DATA,                 -- Fetch data from the avs data and byte enable fifos
		DELAY,                          -- Delay for data fetch
		WAITING_DCTRL_SPACE,            -- Wait state until thete is space in the dctrl data fifo
		WRITE_DCTRL_DATA                -- Write data in the dctrl data fifo
	);
	signal s_data_buffer_state : t_data_buffer_fsm; -- current state

	signal s_byte_counter : natural range 0 to 32 := c_AVS_BEBUFFER_DATA_WIDTH;

	type t_avs_dbuffer_data_bytes is array (0 to (c_AVS_BEBUFFER_DATA_WIDTH - 1)) of std_logic_vector(7 downto 0);
	signal s_avs_dbuffer_data_bytes : t_avs_dbuffer_data_bytes;

	type t_avs_bebuffer_data_bits is array (0 to (c_AVS_BEBUFFER_DATA_WIDTH - 1)) of std_logic;
	signal s_avs_bebuffer_data_bits : t_avs_bebuffer_data_bits;

begin

	-- Data Buffer FSM Process
	p_data_buffer_fsm : process(clk_i, rst_i) is
		variable v_data_buffer_state : t_data_buffer_fsm; -- current state
	begin
		if (rst_i = '1') then
			-- states
			s_data_buffer_state        <= STOPPED;
			v_data_buffer_state        := STOPPED;
			-- internal signals
			s_byte_counter             <= 0;
			-- fifos
			s_avs_dbuffer_fifo.rdreq   <= '0';
			s_avs_dbuffer_fifo.sclr    <= '1';
			s_avs_bebuffer_fifo.rdreq  <= '0';
			s_avs_bebuffer_fifo.sclr   <= '1';
			s_dctrl_dbuffer_fifo.data  <= (others => '0');
			s_dctrl_dbuffer_fifo.sclr  <= '1';
			s_dctrl_dbuffer_fifo.wrreq <= '0';
		-- outputs
		elsif rising_edge(clk_i) then

			-- States transitions FSM
			case (s_data_buffer_state) is

				when STOPPED =>
					-- Stopped, reset all internal signals
					-- default state transition
					s_data_buffer_state        <= STOPPED;
					v_data_buffer_state        := STOPPED;
					-- default internal signal values
					s_avs_dbuffer_fifo.rdreq   <= '0';
					s_avs_dbuffer_fifo.sclr    <= '0';
					s_avs_bebuffer_fifo.rdreq  <= '0';
					s_avs_bebuffer_fifo.sclr   <= '0';
					s_dctrl_dbuffer_fifo.data  <= (others => '0');
					s_dctrl_dbuffer_fifo.sclr  <= '0';
					s_dctrl_dbuffer_fifo.wrreq <= '0';
					s_byte_counter             <= 0;
					-- conditional state transition

					-- check if a command to clear was received
					if (tmr_clear_i = '1') then
						-- clear fifos
						s_avs_dbuffer_fifo.sclr   <= '1';
						s_avs_bebuffer_fifo.sclr  <= '1';
						s_dctrl_dbuffer_fifo.sclr <= '1';
					-- check if a command to start was received
					elsif (tmr_start_i = '1') then
						-- go to wait avs fifo
						s_data_buffer_state <= WAIT_AVS_FIFO;
						v_data_buffer_state := WAIT_AVS_FIFO;
					end if;

				when WAIT_AVS_FIFO =>
					-- Wait state for the avs data and byte enable fifos to have available data
					-- default state transition
					s_data_buffer_state        <= WAIT_AVS_FIFO;
					v_data_buffer_state        := WAIT_AVS_FIFO;
					-- default internal signal values
					s_avs_dbuffer_fifo.rdreq   <= '0';
					s_avs_dbuffer_fifo.sclr    <= '0';
					s_avs_bebuffer_fifo.rdreq  <= '0';
					s_avs_bebuffer_fifo.sclr   <= '0';
					s_dctrl_dbuffer_fifo.data  <= (others => '0');
					s_dctrl_dbuffer_fifo.sclr  <= '0';
					s_dctrl_dbuffer_fifo.wrreq <= '0';
					-- prepare byte counter for multi-byte data
					s_byte_counter             <= c_AVS_BEBUFFER_DATA_WIDTH - 1;
					-- conditional state transition
					-- check if there is data to be fetched from the avs data and byte enable fifos
					if ((s_avs_dbuffer_fifo.empty = '0') and (s_avs_bebuffer_fifo.empty = '0')) then
						-- there is data available
						-- go to fetch state
						s_data_buffer_state <= FETCH_AVS_DATA;
						v_data_buffer_state := FETCH_AVS_DATA;
					end if;

				when FETCH_AVS_DATA =>
					-- Fetch data from the avs data and byte enable fifos
					-- default state transition
					s_data_buffer_state        <= DELAY;
					v_data_buffer_state        := DELAY;
					-- default internal signal values
					s_avs_dbuffer_fifo.rdreq   <= '1';
					s_avs_dbuffer_fifo.sclr    <= '0';
					s_avs_bebuffer_fifo.rdreq  <= '1';
					s_avs_bebuffer_fifo.sclr   <= '0';
					s_dctrl_dbuffer_fifo.data  <= (others => '0');
					s_dctrl_dbuffer_fifo.sclr  <= '0';
					s_dctrl_dbuffer_fifo.wrreq <= '0';
					-- prepare byte counter for multi-byte data
					s_byte_counter             <= c_AVS_BEBUFFER_DATA_WIDTH - 1;
				-- conditional state transition

				when DELAY =>
					-- Delay for data fetch
					-- default state transition
					s_data_buffer_state        <= WAITING_DCTRL_SPACE;
					v_data_buffer_state        := WAITING_DCTRL_SPACE;
					-- default internal signal values
					s_avs_dbuffer_fifo.rdreq   <= '0';
					s_avs_dbuffer_fifo.sclr    <= '0';
					s_avs_bebuffer_fifo.rdreq  <= '0';
					s_avs_bebuffer_fifo.sclr   <= '0';
					s_dctrl_dbuffer_fifo.data  <= (others => '0');
					s_dctrl_dbuffer_fifo.sclr  <= '0';
					s_dctrl_dbuffer_fifo.wrreq <= '0';
					-- prepare byte counter for multi-byte data
					s_byte_counter             <= c_AVS_BEBUFFER_DATA_WIDTH - 1;
				-- conditional state transition

				when WAITING_DCTRL_SPACE =>
					-- Wait state until thete is space in the dctrl data fifo
					-- default state transition
					s_data_buffer_state        <= WAITING_DCTRL_SPACE;
					v_data_buffer_state        := WAITING_DCTRL_SPACE;
					-- default internal signal values
					s_avs_dbuffer_fifo.rdreq   <= '0';
					s_avs_dbuffer_fifo.sclr    <= '0';
					s_avs_bebuffer_fifo.rdreq  <= '0';
					s_avs_bebuffer_fifo.sclr   <= '0';
					s_dctrl_dbuffer_fifo.data  <= (others => '0');
					s_dctrl_dbuffer_fifo.sclr  <= '0';
					s_dctrl_dbuffer_fifo.wrreq <= '0';
					-- conditional state transition
					-- check if the dctrl fifo can receive data
					if (s_dctrl_dbuffer_fifo.full = '0') then
						-- dctrl fifo can receive data
						-- go to write dctrl data
						s_data_buffer_state <= WRITE_DCTRL_DATA;
						v_data_buffer_state := WRITE_DCTRL_DATA;
					end if;

				when WRITE_DCTRL_DATA =>
					-- Write data in the dctrl data fifo
					-- default state transition
					s_data_buffer_state        <= WAITING_DCTRL_SPACE;
					v_data_buffer_state        := WAITING_DCTRL_SPACE;
					-- default internal signal values
					s_avs_dbuffer_fifo.rdreq   <= '0';
					s_avs_dbuffer_fifo.sclr    <= '0';
					s_avs_bebuffer_fifo.rdreq  <= '0';
					s_avs_bebuffer_fifo.sclr   <= '0';
					s_dctrl_dbuffer_fifo.data  <= (others => '0');
					s_dctrl_dbuffer_fifo.sclr  <= '0';
					s_dctrl_dbuffer_fifo.wrreq <= '0';
					s_byte_counter             <= 0;
					-- conditional state transition
					-- check if the current data byte is enabled
					if (s_avs_bebuffer_data_bits(s_byte_counter) = '1') then
						-- current byte enabled, write to fifo
						s_dctrl_dbuffer_fifo.data  <= s_avs_dbuffer_data_bytes(s_byte_counter);
						s_dctrl_dbuffer_fifo.wrreq <= '1';
					end if;
					-- check if all data has been written
					if (s_byte_counter = 0) then
						-- all data written
						-- go to waiting avs data to fetch more data
						s_data_buffer_state <= WAIT_AVS_FIFO;
						v_data_buffer_state := WAIT_AVS_FIFO;
					else
						-- there is still data to be read
						-- update byte counter (for next byte)
						s_byte_counter <= s_byte_counter - 1;
					end if;

			end case;

			-- Output generation FSM
			case (v_data_buffer_state) is

				when STOPPED =>
					-- Stopped, reset all internal signals
					-- default output signals
					-- conditional output signals
					null;

				when WAIT_AVS_FIFO =>
					-- Wait state for the avs data and byte enable fifos to have available data
					-- default output signals
					-- conditional output signals
					null;

				when FETCH_AVS_DATA =>
					-- Fetch data from the avs data and byte enable fifos
					-- default output signals
					-- conditional output signals
					null;

				when DELAY =>
					-- Delay for data fetch
					-- default output signals
					-- conditional output signals
					null;

				when WAITING_DCTRL_SPACE =>
					-- Wait state until thete is space in the dctrl data fifo
					-- default output signals
					-- conditional output signals
					null;

				when WRITE_DCTRL_DATA =>
					-- Write data in the dctrl data fifo
					-- default output signals
					-- conditional output signals
					null;

			end case;

			-- check if a stop was issued
			if (tmr_stop_i = '1') then
				-- stop issued, go to stopped
				s_data_buffer_state <= STOPPED;
				v_data_buffer_state := STOPPED;
			end if;

		end if;
	end process p_data_buffer_fsm;

	-- Avalon Slave Data Buffer Instantiation
	avs_data_buffer_sc_fifo_inst : entity work.avs_data_buffer_sc_fifo
		port map(
			aclr  => rst_i,
			clock => clk_i,
			data  => s_avs_dbuffer_fifo.data,
			rdreq => s_avs_dbuffer_fifo.rdreq,
			sclr  => s_avs_dbuffer_sclr,
			wrreq => s_avs_dbuffer_fifo.wrreq,
			empty => s_avs_dbuffer_fifo.empty,
			full  => s_avs_dbuffer_fifo.full,
			q     => s_avs_dbuffer_fifo.q,
			usedw => s_avs_dbuffer_fifo.usedw
		);

	-- Avalon Slave Byte Enable Buffer Instantiation
	avs_byteen_buffer_sc_fifo_inst : entity work.avs_byteen_buffer_sc_fifo
		port map(
			aclr  => rst_i,
			clock => clk_i,
			data  => s_avs_bebuffer_fifo.data,
			rdreq => s_avs_bebuffer_fifo.rdreq,
			sclr  => s_avs_bebuffer_sclr,
			wrreq => s_avs_bebuffer_fifo.wrreq,
			empty => s_avs_bebuffer_fifo.empty,
			full  => s_avs_bebuffer_fifo.full,
			q     => s_avs_bebuffer_fifo.q,
			usedw => s_avs_bebuffer_fifo.usedw
		);

	-- Data Controller Data Buffer Instantiation
	dctrl_data_buffer_sc_fifo_inst : entity work.dctrl_data_buffer_sc_fifo
		port map(
			aclr  => rst_i,
			clock => clk_i,
			data  => s_dctrl_dbuffer_fifo.data,
			rdreq => s_dctrl_dbuffer_fifo.rdreq,
			sclr  => s_dctrl_dbuffer_sclr,
			wrreq => s_dctrl_dbuffer_fifo.wrreq,
			empty => s_dctrl_dbuffer_fifo.empty,
			full  => s_dctrl_dbuffer_fifo.full,
			q     => s_dctrl_dbuffer_fifo.q,
			usedw => s_dctrl_dbuffer_fifo.usedw
		);

	-- Ports Assignments --

	-- Data Buffer In/Out Assignments
	dbuff_empty_o <= s_avs_dbuffer_fifo.empty;
	dbuff_full_o  <= s_avs_dbuffer_fifo.full;
	dbuff_usedw_o <= s_avs_dbuffer_fifo.usedw;

	-- Avalon Slave Data Buffer In/Out Assignments
	s_avs_dbuffer_fifo.data  <= avs_dbuffer_wrdata_i;
	s_avs_dbuffer_fifo.wrreq <= avs_dbuffer_wrreq_i;
	avs_dbuffer_full_o       <= s_avs_dbuffer_fifo.full;

	-- Avalon Slave Byte Enable Buffer In/Out Assignments
	s_avs_bebuffer_fifo.data  <= avs_bebuffer_wrdata_i;
	s_avs_bebuffer_fifo.wrreq <= avs_bebuffer_wrreq_i;
	avs_bebuffer_full_o       <= s_avs_bebuffer_fifo.full;

	-- Data Controller Data Buffer In/Out Assignments
	s_dctrl_dbuffer_fifo.rdreq <= dcrtl_dbuffer_rdreq_i;
	dcrtl_dbuffer_rddata_o     <= s_dctrl_dbuffer_fifo.q;
	dcrtl_dbuffer_empty_o      <= s_dctrl_dbuffer_fifo.empty;

	-- Signals Assignments --

	-- Avalon Slave Data Buffer Signals Assignments
	s_avs_dbuffer_sclr          <= ('1') when (rst_i = '1') else (s_avs_dbuffer_fifo.sclr);
	s_avs_dbuffer_data_bytes(0) <= s_avs_dbuffer_fifo.q((8 * 8 - 1) downto (7 * 8));
	s_avs_dbuffer_data_bytes(1) <= s_avs_dbuffer_fifo.q((7 * 8 - 1) downto (6 * 8));
	s_avs_dbuffer_data_bytes(2) <= s_avs_dbuffer_fifo.q((6 * 8 - 1) downto (5 * 8));
	s_avs_dbuffer_data_bytes(3) <= s_avs_dbuffer_fifo.q((5 * 8 - 1) downto (4 * 8));
	s_avs_dbuffer_data_bytes(4) <= s_avs_dbuffer_fifo.q((4 * 8 - 1) downto (3 * 8));
	s_avs_dbuffer_data_bytes(5) <= s_avs_dbuffer_fifo.q((3 * 8 - 1) downto (2 * 8));
	s_avs_dbuffer_data_bytes(6) <= s_avs_dbuffer_fifo.q((2 * 8 - 1) downto (1 * 8));
	s_avs_dbuffer_data_bytes(7) <= s_avs_dbuffer_fifo.q((1 * 8 - 1) downto (0 * 8));

	-- Avalon Slave Byte Enable Buffer Signals Assignments
	s_avs_bebuffer_sclr         <= ('1') when (rst_i = '1') else (s_avs_bebuffer_fifo.sclr);
	s_avs_bebuffer_data_bits(0) <= s_avs_bebuffer_fifo.q((8 * 1 - 1));
	s_avs_bebuffer_data_bits(1) <= s_avs_bebuffer_fifo.q((7 * 1 - 1));
	s_avs_bebuffer_data_bits(2) <= s_avs_bebuffer_fifo.q((6 * 1 - 1));
	s_avs_bebuffer_data_bits(3) <= s_avs_bebuffer_fifo.q((5 * 1 - 1));
	s_avs_bebuffer_data_bits(4) <= s_avs_bebuffer_fifo.q((4 * 1 - 1));
	s_avs_bebuffer_data_bits(5) <= s_avs_bebuffer_fifo.q((3 * 1 - 1));
	s_avs_bebuffer_data_bits(6) <= s_avs_bebuffer_fifo.q((2 * 1 - 1));
	s_avs_bebuffer_data_bits(7) <= s_avs_bebuffer_fifo.q((1 * 1 - 1));

	-- Data Controller Data Buffer Signals Assignments
	s_dctrl_dbuffer_sclr <= ('1') when (rst_i = '1') else (s_dctrl_dbuffer_fifo.sclr);

end architecture RTL;
