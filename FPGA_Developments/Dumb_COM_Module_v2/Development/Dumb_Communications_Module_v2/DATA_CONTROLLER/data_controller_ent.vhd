library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_controller_ent is
    generic(
        g_WORD_WIDTH         : natural range 1 to 64 := 8;
        g_DATA_CONTROL_WORDS : natural range 1 to 4  := 2;
        g_DATA_TIME_WORDS    : natural range 1 to 4  := 4;
        g_DATA_LENGTH_WORDS  : natural range 1 to 4  := 2
    );
    port(
        clk_i                    : in  std_logic;
        rst_i                    : in  std_logic;
        tmr_time_i               : in  std_logic_vector(31 downto 0);
        tmr_stop_i               : in  std_logic;
        tmr_start_i              : in  std_logic;
        dctrl_send_eep_i         : in  std_logic;
        dctrl_send_eop_i         : in  std_logic;
        dbuffer_empty_i          : in  std_logic;
        dbuffer_rddata_i         : in  std_logic_vector(7 downto 0);
        spw_tx_ready_i           : in  std_logic;
        spw_timecode_tick_out_i  : in  std_logic;
        spw_timecode_ctrl_i      : in  std_logic_vector(1 downto 0);
        spw_timecode_time_i      : in  std_logic_vector(5 downto 0);
        dctrl_transmitted_pkts_o : out std_logic_vector(31 downto 0);
        dctrl_tmr_clear_o        : out std_logic;
        dctrl_tx_begin_o         : out std_logic;
        dctrl_tx_ended_o         : out std_logic;
        dbuffer_rdreq_o          : out std_logic;
        spw_tx_write_o           : out std_logic;
        spw_tx_flag_o            : out std_logic;
        spw_tx_data_o            : out std_logic_vector(7 downto 0)
    );
end entity data_controller_ent;

architecture RTL of data_controller_ent is

    constant c_DATA_CONTROL_WIDTH     : natural := g_DATA_CONTROL_WORDS * g_WORD_WIDTH;
    constant c_DATA_TIME_WIDTH        : natural := g_DATA_TIME_WORDS * g_WORD_WIDTH;
    constant c_DATA_LENGTH_WIDTH      : natural := g_DATA_LENGTH_WORDS * g_WORD_WIDTH;
    constant c_MEMORY_ALIGNMENT_WORDS : natural := 8; -- each memory data is 8 words = 256 bits

    constant c_DATA_CONTROL_ID_TRANSMIT_PKT_EOP   : natural := 0;
    constant c_DATA_CONTROL_ID_TRANSMIT_PKT_EEP   : natural := 1;
    constant c_DATA_CONTROL_ID_WAIT_NEXT_TIMECODE : natural := 2;
    constant c_DATA_CONTROL_ID_WAIT_FOR_TIMECODE  : natural := 3;
    constant c_DATA_CONTROL_ID_WAIT_NO_DATA       : natural := 4;

    type t_data_controller_fsm is (
        STOPPED,                        -- Stopped, reset all internal signals
        DATA_PACKET_BEGIN,              -- Data packet begin, set initial signals to begin a data packet transmission
        WAIT_DATA_FIFO,                 -- Wait state for the data fifo to have available data
        FETCH_DATA,                     -- Fetch data from the data fifo
        DELAY,                          -- Delay for data fetch
        DATA_CONTROL,                   -- Get the data control for the current data packet
        DATA_TIME,                      -- Get the data time for the current data packet
        DATA_LENGTH,                    -- Get the data length for the current data packet
        PROCESS_DATA_CONTROL,           -- Process the data control for the current data packet
        WAITING_DATA_TIME,              -- Wait state until the timer time reaches the data time
        DATA_PACKET_START,              -- Data packet start, indicate the start of a data packet transmission
        WAITING_SPW_BUFFER_SPACE,       -- Wait state until thete is space in the spw tx buffer 
        TRANSMIT_DATA,                  -- Transmit a byte from the data packet to the spw tx buffer
        TRANSMIT_EOP,                   -- Transmit an eop to the spw tx buffer
        DATA_PACKET_END,                -- Data packet end, finalize the data packet transmission
        TRANSMIT_EEP,                   -- Transmit an eep to the spw tx buffer
        MEMORY_ALIGNMENT,               -- Align the avs access
        WAIT_TIMECODE,                  -- Wait for a timecode to arrive
        RESET_TIMER                     -- Reset data scheduller timer
    );
    signal s_data_controller_state        : t_data_controller_fsm; -- current state
    signal s_data_controller_return_state : t_data_controller_fsm; -- return state from the wait states

    signal s_word_counter : std_logic_vector((c_DATA_LENGTH_WIDTH - 1) downto 0);

    signal s_data_packet_control       : std_logic_vector((c_DATA_CONTROL_WIDTH - 1) downto 0);
    type t_data_packet_control_words is array (0 to (g_DATA_CONTROL_WORDS - 1)) of std_logic_vector((g_WORD_WIDTH - 1) downto 0);
    signal s_data_packet_control_words : t_data_packet_control_words;

    signal s_data_packet_time       : std_logic_vector((c_DATA_TIME_WIDTH - 1) downto 0);
    type t_data_packet_time_words is array (0 to (g_DATA_TIME_WORDS - 1)) of std_logic_vector((g_WORD_WIDTH - 1) downto 0);
    signal s_data_packet_time_words : t_data_packet_time_words;

    signal s_data_packet_length       : std_logic_vector((c_DATA_LENGTH_WIDTH - 1) downto 0);
    type t_data_packet_length_words is array (0 to (g_DATA_LENGTH_WORDS - 1)) of std_logic_vector((g_WORD_WIDTH - 1) downto 0);
    signal s_data_packet_length_words : t_data_packet_length_words;

    signal s_spw_transmitting : std_logic;

    signal s_alignment_counter : natural range 0 to (c_MEMORY_ALIGNMENT_WORDS - 1);

    signal s_end_pkt_type           : std_logic; -- 0 = EOP / 1 = EEP
    signal s_transmit_data          : std_logic;
    signal s_wait_specific_timecode : std_logic;
    signal s_timecode_to_wait       : std_logic_vector(7 downto 0);

    signal s_transmitted_pkts : unsigned(31 downto 0);

begin

    -- data controller fsm process
    p_data_controller_fsm : process(clk_i, rst_i) is
        variable v_data_controller_state : t_data_controller_fsm; -- current state
    begin
        if (rst_i = '1') then
            -- states
            s_data_controller_state        <= STOPPED;
            v_data_controller_state        := STOPPED;
            s_data_controller_return_state <= STOPPED;
            -- internal signals
            s_word_counter                 <= std_logic_vector(to_unsigned(0, c_DATA_LENGTH_WIDTH));
            s_data_packet_control_words    <= (others => std_logic_vector(to_unsigned(0, g_WORD_WIDTH)));
            s_data_packet_time_words       <= (others => std_logic_vector(to_unsigned(0, g_WORD_WIDTH)));
            s_data_packet_length_words     <= (others => std_logic_vector(to_unsigned(0, g_WORD_WIDTH)));
            s_spw_transmitting             <= '0';
            s_alignment_counter            <= 0;
            s_end_pkt_type                 <= '0';
            s_transmit_data                <= '1';
            s_wait_specific_timecode       <= '0';
            s_timecode_to_wait             <= (others => '0');
            s_transmitted_pkts             <= (others => '0');
            -- outputs
            dctrl_tmr_clear_o              <= '0';
            dctrl_tx_begin_o               <= '0';
            dctrl_tx_ended_o               <= '0';
            dbuffer_rdreq_o                <= '0';
            spw_tx_write_o                 <= '0';
            spw_tx_flag_o                  <= '0';
            spw_tx_data_o                  <= x"00";
        elsif rising_edge(clk_i) then

            -- States transitions FSM
            case (s_data_controller_state) is
                when STOPPED =>
                    -- Stopped, reset all internal signals
                    -- default state transition
                    s_data_controller_state        <= STOPPED;
                    v_data_controller_state        := STOPPED;
                    s_data_controller_return_state <= STOPPED;
                    -- default internal signal values
                    s_word_counter                 <= std_logic_vector(to_unsigned(0, s_word_counter'length));
                    s_data_packet_control_words    <= (others => std_logic_vector(to_unsigned(0, g_WORD_WIDTH)));
                    s_data_packet_time_words       <= (others => std_logic_vector(to_unsigned(0, g_WORD_WIDTH)));
                    s_data_packet_length_words     <= (others => std_logic_vector(to_unsigned(0, g_WORD_WIDTH)));
                    s_spw_transmitting             <= '0';
                    s_alignment_counter            <= 0;
                    s_end_pkt_type                 <= '0';
                    s_transmit_data                <= '1';
                    s_wait_specific_timecode       <= '0';
                    s_timecode_to_wait             <= (others => '0');
                    s_transmitted_pkts             <= (others => '0');
                    -- conditional state transition
                    -- check if a command to start was received
                    if (tmr_start_i = '1') then
                        -- go to data packet begin
                        s_data_controller_state        <= DATA_PACKET_BEGIN;
                        v_data_controller_state        := DATA_PACKET_BEGIN;
                        s_data_controller_return_state <= STOPPED;
                    end if;

                when DATA_PACKET_BEGIN =>
                    -- Data packet begin, set initial signals to begin a data packet transmission
                    -- default state transition
                    s_data_controller_state        <= WAIT_DATA_FIFO;
                    v_data_controller_state        := WAIT_DATA_FIFO;
                    s_data_controller_return_state <= DATA_CONTROL;
                    -- default internal signal values
                    -- prepare word counter for multi-word data (data control)
                    s_word_counter                 <= std_logic_vector(to_unsigned(g_DATA_CONTROL_WORDS, s_word_counter'length) - 1);
                    s_data_packet_control_words    <= (others => std_logic_vector(to_unsigned(0, g_WORD_WIDTH)));
                    s_data_packet_time_words       <= (others => std_logic_vector(to_unsigned(0, g_WORD_WIDTH)));
                    s_data_packet_length_words     <= (others => std_logic_vector(to_unsigned(0, g_WORD_WIDTH)));
                    s_spw_transmitting             <= '0';
                    s_alignment_counter            <= 0;
                    s_end_pkt_type                 <= '0';
                    s_transmit_data                <= '1';
                    s_wait_specific_timecode       <= '0';
                    s_timecode_to_wait             <= (others => '0');
                -- conditional state transition

                when WAIT_DATA_FIFO =>
                    -- Wait state for the data fifo to have available data
                    -- default state transition
                    s_data_controller_state <= WAIT_DATA_FIFO;
                    v_data_controller_state := WAIT_DATA_FIFO;
                    -- default internal signal values
                    -- conditional state transition
                    -- check if there is data to be fetched from the data buffer
                    if (dbuffer_empty_i = '0') then
                        -- there is data available
                        -- go to fetch state
                        s_data_controller_state <= FETCH_DATA;
                        v_data_controller_state := FETCH_DATA;
                    end if;

                when FETCH_DATA =>
                    -- Fetch data from the data fifo
                    -- default state transition
                    s_data_controller_state <= DELAY;
                    v_data_controller_state := DELAY;
                    -- default internal signal values
                    -- update alignment counter
                    if (s_alignment_counter = (c_MEMORY_ALIGNMENT_WORDS - 1)) then
                        s_alignment_counter <= 0;
                    else
                        s_alignment_counter <= s_alignment_counter + 1;
                    end if;
                -- conditional state transition

                when DELAY =>
                    -- Delay for data fetch
                    -- default state transition
                    s_data_controller_state        <= s_data_controller_return_state;
                    v_data_controller_state        := s_data_controller_return_state;
                    s_data_controller_return_state <= STOPPED;
                -- default internal signal values
                -- conditional state transition

                when DATA_CONTROL =>
                    -- Get the data control for the current data packet
                    -- default state transition
                    s_data_controller_state                                           <= WAIT_DATA_FIFO;
                    v_data_controller_state                                           := WAIT_DATA_FIFO;
                    s_data_controller_return_state                                    <= DATA_CONTROL;
                    -- default internal signal values
                    s_word_counter                                                    <= std_logic_vector(to_unsigned(0, s_word_counter'length));
                    s_data_packet_control_words(to_integer(unsigned(s_word_counter))) <= dbuffer_rddata_i;
                    s_spw_transmitting                                                <= '0';
                    -- conditional state transition
                    -- check if all data has been read
                    if (s_word_counter = std_logic_vector(to_unsigned(0, s_word_counter'length))) then
                        -- all data read
                        -- go to next field (data time)
                        s_data_controller_return_state <= DATA_TIME;
                        -- prepare word counter for multi-word data (data time)
                        s_word_counter                 <= std_logic_vector(to_unsigned(g_DATA_TIME_WORDS, s_word_counter'length) - 1);
                    else
                        -- there is still data to be read
                        -- update word counter (for next word)
                        s_word_counter <= std_logic_vector(unsigned(s_word_counter) - 1);
                    end if;

                when DATA_TIME =>
                    -- Get the data time for the current data packet
                    -- default state transition
                    s_data_controller_state                                        <= WAIT_DATA_FIFO;
                    v_data_controller_state                                        := WAIT_DATA_FIFO;
                    s_data_controller_return_state                                 <= DATA_TIME;
                    -- default internal signal values
                    s_word_counter                                                 <= std_logic_vector(to_unsigned(0, s_word_counter'length));
                    s_data_packet_time_words(to_integer(unsigned(s_word_counter))) <= dbuffer_rddata_i;
                    s_spw_transmitting                                             <= '0';
                    -- conditional state transition
                    -- check if all data has been read
                    if (s_word_counter = std_logic_vector(to_unsigned(0, s_word_counter'length))) then
                        -- all data read
                        -- go to next field (data length)
                        s_data_controller_return_state <= DATA_LENGTH;
                        -- prepare word counter for multi-word data (data length)
                        s_word_counter                 <= std_logic_vector(to_unsigned(g_DATA_LENGTH_WORDS, s_word_counter'length) - 1);
                    else
                        -- there is still data to be read
                        -- update word counter (for next word)
                        s_word_counter <= std_logic_vector(unsigned(s_word_counter) - 1);
                    end if;

                when DATA_LENGTH =>
                    -- Get the data length for the current data packet
                    -- default state transition
                    s_data_controller_state                                          <= WAIT_DATA_FIFO;
                    v_data_controller_state                                          := WAIT_DATA_FIFO;
                    s_data_controller_return_state                                   <= DATA_LENGTH;
                    -- default internal signal values
                    s_word_counter                                                   <= std_logic_vector(to_unsigned(0, s_word_counter'length));
                    s_data_packet_length_words(to_integer(unsigned(s_word_counter))) <= dbuffer_rddata_i;
                    s_spw_transmitting                                               <= '0';
                    -- conditional state transition
                    -- check if all data has been read
                    if (s_word_counter = std_logic_vector(to_unsigned(0, s_word_counter'length))) then
                        -- all data read
                        -- go to next field (waiting data time)
                        s_data_controller_state        <= PROCESS_DATA_CONTROL;
                        v_data_controller_state        := PROCESS_DATA_CONTROL;
                        s_data_controller_return_state <= STOPPED;
                        -- clear word counter
                        s_word_counter                 <= std_logic_vector(to_unsigned(0, s_word_counter'length));
                    else
                        -- update word counter (for next word)
                        s_word_counter <= std_logic_vector(unsigned(s_word_counter) - 1);
                    end if;

                when PROCESS_DATA_CONTROL =>
                    -- Process the data control for the current data packet
                    -- default state transition
                    s_data_controller_state        <= WAITING_DATA_TIME;
                    v_data_controller_state        := WAITING_DATA_TIME;
                    s_data_controller_return_state <= STOPPED;
                    -- default internal signal values
                    s_spw_transmitting             <= '0';
                    s_end_pkt_type                 <= '0';
                    s_transmit_data                <= '1';
                    s_wait_specific_timecode       <= '0';
                    s_timecode_to_wait             <= (others => '0');
                    -- conditional state transition
                    -- case for the data control value
                    case (to_integer(unsigned(s_data_packet_control))) is
                        when (c_DATA_CONTROL_ID_TRANSMIT_PKT_EOP) =>
                            -- transmit data packet by spacewire, ending packet in eop
                            null;
                        when (c_DATA_CONTROL_ID_TRANSMIT_PKT_EEP) =>
                            -- transmit data packet by spacewire, ending packet in eep
                            -- set end packet type to eep
                            s_end_pkt_type <= '1';
                        when (c_DATA_CONTROL_ID_WAIT_NEXT_TIMECODE) =>
                            -- wait for next timecode and reset timer
                            -- go to wait timecode
                            s_data_controller_state <= WAIT_TIMECODE;
                            v_data_controller_state := WAIT_TIMECODE;
                        when (c_DATA_CONTROL_ID_WAIT_FOR_TIMECODE) =>
                            -- wait for a specific timecode and reset timer
                            -- set wait specific timecode flag
                            s_wait_specific_timecode <= '1';
                            -- set the timecode to wait for
                            s_timecode_to_wait       <= s_data_packet_time((s_timecode_to_wait'length - 1) downto 0);
                            -- go to wait timecode
                            s_data_controller_state  <= WAIT_TIMECODE;
                            v_data_controller_state  := WAIT_TIMECODE;
                        when (c_DATA_CONTROL_ID_WAIT_NO_DATA) =>
                            -- wait time without transmiting any data by spacewire
                            -- clear the transmit data flag
                            s_transmit_data <= '0';
                        when others =>
                            -- data control not recognized, return to data packet begin
                            s_data_controller_state <= DATA_PACKET_BEGIN;
                            v_data_controller_state := DATA_PACKET_BEGIN;
                    end case;

                when WAITING_DATA_TIME =>
                    -- Wait state until the timer time reaches the data time
                    -- default state transition
                    s_data_controller_state        <= WAITING_DATA_TIME;
                    v_data_controller_state        := WAITING_DATA_TIME;
                    s_data_controller_return_state <= STOPPED;
                    -- default internal signal values
                    s_spw_transmitting             <= '0';
                    -- conditional state transition
                    -- check if the time to send the data packet have arrived
                    if (unsigned(tmr_time_i) >= unsigned(s_data_packet_time((tmr_time_i'length - 1) downto 0))) then
                        -- time to send the data packet arrived
                        -- check if there is data to be transmitted
                        if (s_transmit_data = '1') then
                            -- there is data to be transmitted
                            -- go to data packet start
                            s_data_controller_state <= DATA_PACKET_START;
                            v_data_controller_state := DATA_PACKET_START;
                        else
                            -- there is no data to be transmitted
                            -- check if the avs data need to be aligned
                            if (s_alignment_counter > 0) then
                                -- data need to be aligned
                                -- go to memory alignment
                                s_data_controller_state        <= WAIT_DATA_FIFO;
                                v_data_controller_state        := WAIT_DATA_FIFO;
                                s_data_controller_return_state <= MEMORY_ALIGNMENT;
                            else
                                -- data do not need to be aligned
                                -- return to data packet begin
                                s_data_controller_state        <= DATA_PACKET_BEGIN;
                                v_data_controller_state        := DATA_PACKET_BEGIN;
                                s_data_controller_return_state <= STOPPED;
                            end if;
                        end if;
                    end if;

                when DATA_PACKET_START =>
                    -- Data packet start, indicate the start of a data packet transmission
                    -- default state transition
                    s_data_controller_state        <= WAITING_SPW_BUFFER_SPACE;
                    v_data_controller_state        := WAITING_SPW_BUFFER_SPACE;
                    s_data_controller_return_state <= TRANSMIT_DATA;
                    -- default internal signal values
                    s_word_counter                 <= std_logic_vector(to_unsigned(0, s_word_counter'length));
                    -- conditional state transition
                    -- check if the data length is valid (not zero)
                    if not (s_data_packet_length = std_logic_vector(to_unsigned(0, s_data_packet_length'length))) then
                        -- data length is valid
                        -- prepare word counter for multi-word data (packet data)
                        s_word_counter <= std_logic_vector(unsigned(s_data_packet_length((s_word_counter'length - 1) downto 0)) - 1);
                    else
                        -- data length is not valid (zero)
                        -- go to data packet end
                        s_data_controller_state        <= DATA_PACKET_END;
                        v_data_controller_state        := DATA_PACKET_END;
                        s_data_controller_return_state <= STOPPED;
                    end if;

                when WAITING_SPW_BUFFER_SPACE =>
                    -- Wait state until thete is space in the spw tx buffer
                    -- default state transition
                    s_data_controller_state <= WAITING_SPW_BUFFER_SPACE;
                    v_data_controller_state := WAITING_SPW_BUFFER_SPACE;
                    -- default internal signal values
                    -- conditional state transition
                    -- check if tx buffer can receive data
                    if (spw_tx_ready_i = '1') then
                        -- tx buffer can receive data
                        -- check if the wait is for and eop or eep
                        if ((s_data_controller_return_state = TRANSMIT_EOP) or (s_data_controller_return_state = TRANSMIT_EEP)) then
                            -- wait is for an eop or eep, no need to fetch data from the data fifo
                            s_data_controller_state <= s_data_controller_return_state;
                            v_data_controller_state := s_data_controller_return_state;
                        else
                            -- wait is not for an eop or eep, need to fetch data from the data fifo
                            -- go wait data fifo available
                            s_data_controller_state <= WAIT_DATA_FIFO;
                            v_data_controller_state := WAIT_DATA_FIFO;
                        end if;
                    end if;

                when TRANSMIT_DATA =>
                    -- Transmit a byte from the data packet to the spw tx buffer
                    -- default state transition
                    s_data_controller_state        <= WAITING_SPW_BUFFER_SPACE;
                    v_data_controller_state        := WAITING_SPW_BUFFER_SPACE;
                    s_data_controller_return_state <= TRANSMIT_DATA;
                    -- default internal signal values
                    s_word_counter                 <= std_logic_vector(to_unsigned(0, s_word_counter'length));
                    -- conditional state transition
                    s_spw_transmitting             <= '1';
                    -- check if all data has been read
                    if (s_word_counter = std_logic_vector(to_unsigned(0, s_word_counter'length))) then
                        -- all data read
                        -- verify it an eop need to be transmitted
                        if ((dctrl_send_eop_i = '1') or (dctrl_send_eep_i = '1')) then
                            -- need to send an eop or eep
                            -- go to waiting spw buffer space, returning to transmit eop or eep
                            s_data_controller_return_state <= TRANSMIT_EOP;
                        else
                            -- no need to send an eop
                            -- go to data package end
                            s_data_controller_state        <= DATA_PACKET_END;
                            v_data_controller_state        := DATA_PACKET_END;
                            s_data_controller_return_state <= STOPPED;
                        end if;
                        -- clear word counter
                        s_word_counter <= std_logic_vector(to_unsigned(0, s_word_counter'length));
                    else
                        -- there is still data to be read
                        -- update word counter (for next word)
                        s_word_counter <= std_logic_vector(unsigned(s_word_counter) - 1);
                    end if;

                when TRANSMIT_EOP =>
                    -- Transmit an eop to the spw tx buffer
                    -- default state transition
                    s_data_controller_state        <= DATA_PACKET_END;
                    v_data_controller_state        := DATA_PACKET_END;
                    s_data_controller_return_state <= STOPPED;
                    -- default internal signal values
                    s_spw_transmitting             <= '0';
                -- conditional state transition

                when DATA_PACKET_END =>
                    -- Data packet end, finalize the data packet transmission
                    -- default state transition
                    s_data_controller_state        <= DATA_PACKET_BEGIN;
                    v_data_controller_state        := DATA_PACKET_BEGIN;
                    s_data_controller_return_state <= STOPPED;
                    -- default internal signal values
                    s_word_counter                 <= std_logic_vector(to_unsigned(0, c_DATA_LENGTH_WIDTH));
                    s_data_packet_control_words    <= (others => std_logic_vector(to_unsigned(0, g_WORD_WIDTH)));
                    s_data_packet_time_words       <= (others => std_logic_vector(to_unsigned(0, g_WORD_WIDTH)));
                    s_data_packet_length_words     <= (others => std_logic_vector(to_unsigned(0, g_WORD_WIDTH)));
                    s_spw_transmitting             <= '0';
                    s_transmitted_pkts             <= s_transmitted_pkts + 1;
                    -- conditional state transition
                    -- check if the avs data need to be aligned
                    if (s_alignment_counter > 0) then
                        -- data need to be aligned
                        -- go to memory alignment
                        s_data_controller_state        <= WAIT_DATA_FIFO;
                        v_data_controller_state        := WAIT_DATA_FIFO;
                        s_data_controller_return_state <= MEMORY_ALIGNMENT;
                    end if;

                when TRANSMIT_EEP =>
                    -- Transmit an eep to the spw tx buffer
                    -- default state transition
                    s_data_controller_state        <= STOPPED;
                    v_data_controller_state        := STOPPED;
                    s_data_controller_return_state <= STOPPED;
                    -- default internal signal values
                    s_word_counter                 <= std_logic_vector(to_unsigned(0, c_DATA_LENGTH_WIDTH));
                    s_data_packet_control_words    <= (others => std_logic_vector(to_unsigned(0, g_WORD_WIDTH)));
                    s_data_packet_time_words       <= (others => std_logic_vector(to_unsigned(0, g_WORD_WIDTH)));
                    s_data_packet_length_words     <= (others => std_logic_vector(to_unsigned(0, g_WORD_WIDTH)));
                    s_spw_transmitting             <= '0';
                    s_alignment_counter            <= 0;
                -- conditional state transition

                when MEMORY_ALIGNMENT =>
                    -- Align the avs access
                    -- default state transition
                    s_data_controller_state        <= WAIT_DATA_FIFO;
                    v_data_controller_state        := WAIT_DATA_FIFO;
                    s_data_controller_return_state <= MEMORY_ALIGNMENT;
                    -- default internal signal values
                    s_word_counter                 <= std_logic_vector(to_unsigned(0, s_word_counter'length));
                    -- conditional state transition
                    s_spw_transmitting             <= '0';
                    -- check if the avs data is aligned
                    if (s_alignment_counter = 0) then
                        -- data is aligned
                        -- go to start data packet begin
                        s_data_controller_state        <= DATA_PACKET_BEGIN;
                        v_data_controller_state        := DATA_PACKET_BEGIN;
                        s_data_controller_return_state <= STOPPED;
                        -- clear alignment counter
                        s_alignment_counter            <= 0;
                    end if;

                when WAIT_TIMECODE =>
                    -- Wait for a timecode to arrive
                    -- default state transition
                    s_data_controller_state        <= WAIT_TIMECODE;
                    v_data_controller_state        := WAIT_TIMECODE;
                    s_data_controller_return_state <= STOPPED;
                    -- default internal signal values
                    s_spw_transmitting             <= '0';
                    -- conditional state transition
                    -- check if a timecode have arrived
                    if (spw_timecode_tick_out_i = '1') then
                        -- a timecode have arrived
                        -- check if there is no need to wait for a specific timecode
                        if (s_wait_specific_timecode = '0') then
                            -- there is no need to wait for a specific timecode
                            -- go to reset timer
                            s_data_controller_state <= RESET_TIMER;
                            v_data_controller_state := RESET_TIMER;
                        else
                            -- there is a need to wait for a specific timecode
                            -- check if the timecode is the one to wait for
                            if ((s_timecode_to_wait(7 downto 6) = spw_timecode_ctrl_i) and (s_timecode_to_wait(5 downto 0) = spw_timecode_time_i)) then
                                -- the timecode is the one to wait for
                                -- go to reset timer
                                s_data_controller_state <= RESET_TIMER;
                                v_data_controller_state := RESET_TIMER;
                            end if;
                        end if;
                    end if;

                when RESET_TIMER =>
                    -- Reset data scheduller timer
                    -- default state transition
                    s_data_controller_state        <= DATA_PACKET_BEGIN;
                    v_data_controller_state        := DATA_PACKET_BEGIN;
                    s_data_controller_return_state <= STOPPED;
                    -- default internal signal values
                    s_spw_transmitting             <= '0';
                    -- conditional state transition
                    -- check if the avs data need to be aligned
                    if (s_alignment_counter > 0) then
                        -- data need to be aligned
                        -- go to memory alignment
                        s_data_controller_state        <= WAIT_DATA_FIFO;
                        v_data_controller_state        := WAIT_DATA_FIFO;
                        s_data_controller_return_state <= MEMORY_ALIGNMENT;
                    end if;

            end case;

            -- Output generation FSM
            case (v_data_controller_state) is
                when STOPPED =>
                    -- Stopped, reset all internal signals
                    -- default output signals
                    dctrl_tmr_clear_o <= '0';
                    dctrl_tx_begin_o  <= '0';
                    dctrl_tx_ended_o  <= '0';
                    dbuffer_rdreq_o   <= '0';
                    spw_tx_write_o    <= '0';
                    spw_tx_flag_o     <= '0';
                    spw_tx_data_o     <= x"00";
                -- conditional output signals

                when DATA_PACKET_BEGIN =>
                    -- Data packet begin, set initial signals to begin a data packet transmission
                    -- default output signals
                    dctrl_tmr_clear_o <= '0';
                    dctrl_tx_begin_o  <= '0';
                    dctrl_tx_ended_o  <= '0';
                    dbuffer_rdreq_o   <= '0';
                    spw_tx_write_o    <= '0';
                    spw_tx_flag_o     <= '0';
                    spw_tx_data_o     <= x"00";
                -- conditional output signals

                when WAIT_DATA_FIFO =>
                    -- Wait state for the data fifo to have available data
                    -- default output signals
                    dctrl_tmr_clear_o <= '0';
                    dctrl_tx_begin_o  <= '0';
                    dctrl_tx_ended_o  <= '0';
                    dbuffer_rdreq_o   <= '0';
                    spw_tx_write_o    <= '0';
                    spw_tx_flag_o     <= '0';
                    spw_tx_data_o     <= x"00";
                -- conditional output signals

                when FETCH_DATA =>
                    -- Fetch data from the data fifo
                    -- default output signals
                    dctrl_tmr_clear_o <= '0';
                    dctrl_tx_begin_o  <= '0';
                    dctrl_tx_ended_o  <= '0';
                    -- request a read from the data fifo
                    dbuffer_rdreq_o   <= '1';
                    spw_tx_write_o    <= '0';
                    spw_tx_flag_o     <= '0';
                    spw_tx_data_o     <= x"00";
                -- conditional output signals

                when DELAY =>
                    -- Delay for data fetch
                    -- default output signals
                    dctrl_tmr_clear_o <= '0';
                    dctrl_tx_begin_o  <= '0';
                    dctrl_tx_ended_o  <= '0';
                    dbuffer_rdreq_o   <= '0';
                    spw_tx_write_o    <= '0';
                    spw_tx_flag_o     <= '0';
                    spw_tx_data_o     <= x"00";
                -- conditional output signals

                when DATA_CONTROL =>
                    -- Get the data control for the current data packet
                    -- default output signals
                    dctrl_tmr_clear_o <= '0';
                    dctrl_tx_begin_o  <= '0';
                    dctrl_tx_ended_o  <= '0';
                    dbuffer_rdreq_o   <= '0';
                    spw_tx_write_o    <= '0';
                    spw_tx_flag_o     <= '0';
                    spw_tx_data_o     <= x"00";
                -- conditional output signals

                when DATA_TIME =>
                    -- Get the data time for the current data packet
                    -- default output signals
                    dctrl_tmr_clear_o <= '0';
                    dctrl_tx_begin_o  <= '0';
                    dctrl_tx_ended_o  <= '0';
                    dbuffer_rdreq_o   <= '0';
                    spw_tx_write_o    <= '0';
                    spw_tx_flag_o     <= '0';
                    spw_tx_data_o     <= x"00";
                -- conditional output signals

                when DATA_LENGTH =>
                    -- Get the data length for the current data packet
                    -- default output signals
                    dctrl_tmr_clear_o <= '0';
                    dctrl_tx_begin_o  <= '0';
                    dctrl_tx_ended_o  <= '0';
                    dbuffer_rdreq_o   <= '0';
                    spw_tx_write_o    <= '0';
                    spw_tx_flag_o     <= '0';
                    spw_tx_data_o     <= x"00";
                -- conditional output signals

                when PROCESS_DATA_CONTROL =>
                    -- Process the data control for the current data packet
                    -- default output signals
                    dctrl_tmr_clear_o <= '0';
                    dctrl_tx_begin_o  <= '0';
                    dctrl_tx_ended_o  <= '0';
                    dbuffer_rdreq_o   <= '0';
                    spw_tx_write_o    <= '0';
                    spw_tx_flag_o     <= '0';
                    spw_tx_data_o     <= x"00";
                -- conditional output signals

                when WAITING_DATA_TIME =>
                    -- Wait state until the timer time reaches the data time
                    -- default output signals
                    dctrl_tmr_clear_o <= '0';
                    dctrl_tx_begin_o  <= '0';
                    dctrl_tx_ended_o  <= '0';
                    dbuffer_rdreq_o   <= '0';
                    spw_tx_write_o    <= '0';
                    spw_tx_flag_o     <= '0';
                    spw_tx_data_o     <= x"00";
                -- conditional output signals

                when DATA_PACKET_START =>
                    -- Data packet start, indicate the start of a data packet transmission
                    -- default output signals
                    dctrl_tmr_clear_o <= '0';
                    -- indicates a transmission begin
                    dctrl_tx_begin_o  <= '1';
                    dctrl_tx_ended_o  <= '0';
                    dbuffer_rdreq_o   <= '0';
                    spw_tx_write_o    <= '0';
                    spw_tx_flag_o     <= '0';
                    spw_tx_data_o     <= x"00";
                -- conditional output signals

                when WAITING_SPW_BUFFER_SPACE =>
                    -- Wait state until thete is space in the spw tx buffer
                    -- default output signals
                    dctrl_tmr_clear_o <= '0';
                    dctrl_tx_begin_o  <= '0';
                    dctrl_tx_ended_o  <= '0';
                    dbuffer_rdreq_o   <= '0';
                    spw_tx_write_o    <= '0';
                    spw_tx_flag_o     <= '0';
                    spw_tx_data_o     <= x"00";
                -- conditional output signals

                when TRANSMIT_DATA =>
                    -- Transmit a byte from the data packet to the spw tx buffer
                    -- default output signals
                    dctrl_tmr_clear_o <= '0';
                    dctrl_tx_begin_o  <= '0';
                    dctrl_tx_ended_o  <= '0';
                    dbuffer_rdreq_o   <= '0';
                    -- write the spw data
                    spw_tx_write_o    <= '1';
                    -- clear spw flag (to indicate a data)
                    spw_tx_flag_o     <= '0';
                    -- fill spw data with field data
                    spw_tx_data_o     <= dbuffer_rddata_i;
                -- conditional output signals

                when TRANSMIT_EOP =>
                    -- Transmit an eop to the spw tx buffer
                    -- default output signals
                    dctrl_tmr_clear_o <= '0';
                    dctrl_tx_begin_o  <= '0';
                    dctrl_tx_ended_o  <= '0';
                    dbuffer_rdreq_o   <= '0';
                    -- write the spw data
                    spw_tx_write_o    <= '1';
                    -- set spw flag (to indicate a package end)
                    spw_tx_flag_o     <= '1';
                    -- conditional output signals
                    --                    -- check if an eop need to be sent
                    --                    if (dctrl_send_eop_i = '1') then
                    --                        -- an eop need to be sent
                    --                        -- fill spw data with the eop identifier (0x00)
                    --                        spw_tx_data_o <= x"00";
                    --                    else
                    --                        -- an eep need to be sent
                    --                        -- fill spw data with the eep identifier (0x01)
                    --                        spw_tx_data_o <= x"01";
                    --                    end if;
                    -- check if a packet end need to be sent
                    if ((dctrl_send_eop_i = '1') or (dctrl_send_eep_i = '1')) then
                        -- a packet end need to be sent
                        -- check if the end of packet type is an eop
                        if (s_end_pkt_type = '0') then
                            -- the end of packet type is an eop
                            -- fill spw data with the eop identifier (0x00)
                            spw_tx_data_o <= x"00";
                        else
                            -- the end of packet type is an eep
                            -- fill spw data with the eep identifier (0x01)
                            spw_tx_data_o <= x"01";
                        end if;
                    end if;

                when DATA_PACKET_END =>
                    -- Data packet end, finalize the data packet transmission
                    -- default output signals
                    dctrl_tmr_clear_o <= '0';
                    dctrl_tx_begin_o  <= '0';
                    -- indicates a transmission end
                    dctrl_tx_ended_o  <= '1';
                    dbuffer_rdreq_o   <= '0';
                    spw_tx_write_o    <= '0';
                    spw_tx_flag_o     <= '0';
                    spw_tx_data_o     <= x"00";
                -- conditional output signals

                when TRANSMIT_EEP =>
                    -- Transmit an eep to the spw tx buffer
                    -- default output signals
                    dctrl_tmr_clear_o <= '0';
                    dctrl_tx_begin_o  <= '0';
                    dctrl_tx_ended_o  <= '0';
                    dbuffer_rdreq_o   <= '0';
                    -- write the spw data
                    spw_tx_write_o    <= '1';
                    -- set spw flag (to indicate a package end)
                    spw_tx_flag_o     <= '1';
                    -- fill spw data with the eep identifier (0x01)
                    spw_tx_data_o     <= x"01";
                -- conditional output signals

                when MEMORY_ALIGNMENT =>
                    -- Align the avs access
                    -- default output signals
                    dctrl_tmr_clear_o <= '0';
                    dctrl_tx_begin_o  <= '0';
                    dctrl_tx_ended_o  <= '0';
                    dbuffer_rdreq_o   <= '0';
                    spw_tx_write_o    <= '0';
                    spw_tx_flag_o     <= '0';
                    spw_tx_data_o     <= x"00";
                -- conditional output signals

                when WAIT_TIMECODE =>
                    -- Wait for a timecode to arrive
                    -- default output signals
                    dctrl_tmr_clear_o <= '0';
                    dctrl_tx_begin_o  <= '0';
                    dctrl_tx_ended_o  <= '0';
                    dbuffer_rdreq_o   <= '0';
                    spw_tx_write_o    <= '0';
                    spw_tx_flag_o     <= '0';
                    spw_tx_data_o     <= x"00";
                -- conditional output signals

                when RESET_TIMER =>
                    -- Reset data scheduller timer
                    -- default output signals
                    dctrl_tmr_clear_o <= '1';
                    dctrl_tx_begin_o  <= '0';
                    dctrl_tx_ended_o  <= '0';
                    dbuffer_rdreq_o   <= '0';
                    spw_tx_write_o    <= '0';
                    spw_tx_flag_o     <= '0';
                    spw_tx_data_o     <= x"00";
                    -- conditional output signals

            end case;

            -- check if a stop was issued
            if (tmr_stop_i = '1') then
                -- stop issued, go to stopped
                -- check if the transmitter is in the middle of a transmission (have the spw mux access rights)
                if ((s_spw_transmitting = '1') and (s_data_controller_state /= TRANSMIT_EOP) and (dctrl_send_eep_i = '1')) then
                    -- transmit and eep to release the spw mux and indicate an error
                    s_data_controller_state        <= WAITING_SPW_BUFFER_SPACE;
                    v_data_controller_state        := WAITING_SPW_BUFFER_SPACE;
                    s_data_controller_return_state <= TRANSMIT_EEP;
                else
                    -- no need to release the spw mux and indicate an error, go to stopped
                    s_data_controller_state        <= STOPPED;
                    v_data_controller_state        := STOPPED;
                    s_data_controller_return_state <= STOPPED;
                end if;
            end if;

        end if;
    end process p_data_controller_fsm;

    -- signals assingments

    -- data packet control signal
    g_data_packet_control : for word_cnt in 1 to g_DATA_CONTROL_WORDS generate
        s_data_packet_control(((word_cnt * g_WORD_WIDTH) - 1) downto ((word_cnt - 1) * g_WORD_WIDTH)) <= s_data_packet_control_words(word_cnt - 1);
    end generate g_data_packet_control;

    -- data packet time signal
    g_data_packet_time : for word_cnt in 1 to g_DATA_TIME_WORDS generate
        s_data_packet_time(((word_cnt * g_WORD_WIDTH) - 1) downto ((word_cnt - 1) * g_WORD_WIDTH)) <= s_data_packet_time_words(word_cnt - 1);
    end generate g_data_packet_time;

    -- data packet length signal
    g_data_packet_length : for word_cnt in 1 to g_DATA_LENGTH_WORDS generate
        s_data_packet_length(((word_cnt * g_WORD_WIDTH) - 1) downto ((word_cnt - 1) * g_WORD_WIDTH)) <= s_data_packet_length_words(word_cnt - 1);
    end generate g_data_packet_length;

    -- outputs assingments

    -- data packet transmitted packets output
    dctrl_transmitted_pkts_o <= std_logic_vector(s_transmitted_pkts);

end architecture RTL;
