library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spwpkg.all;

entity testbench_top is
end entity testbench_top;

architecture RTL of testbench_top is

	-- clk and rst signals
	signal clk200 : std_logic := '0';
	signal clk100 : std_logic := '0';
	signal rst    : std_logic := '1';

	-- dut signals

	-- lvds signals (comm)
	signal s_spw_codec_comm_di : std_logic;
	signal s_spw_codec_comm_do : std_logic;
	signal s_spw_codec_comm_si : std_logic;
	signal s_spw_codec_comm_so : std_logic;

	-- lvds signals (dummy)
	signal s_spw_codec_dummy_di : std_logic;
	signal s_spw_codec_dummy_do : std_logic;
	signal s_spw_codec_dummy_si : std_logic;
	signal s_spw_codec_dummy_so : std_logic;

	-- spacewire clock signal
	signal s_spw_clock : std_logic;

	-- irq signal
	signal s_irq_tx : std_logic;

	-- sync signal
	signal s_sync : std_logic;

	-- config_avalon_stimuli signals
	signal s_config_avalon_stimuli_mm_readdata    : std_logic_vector(31 downto 0); -- -- avalon_mm.readdata
	signal s_config_avalon_stimuli_mm_waitrequest : std_logic; --                                     --          .waitrequest
	signal s_config_avalon_stimuli_mm_address     : std_logic_vector(7 downto 0); --          .address
	signal s_config_avalon_stimuli_mm_write       : std_logic; --                                     --          .write
	signal s_config_avalon_stimuli_mm_writedata   : std_logic_vector(31 downto 0); -- --          .writedata
	signal s_config_avalon_stimuli_mm_read        : std_logic; --                                     --          .read

	-- avalon_buffer_stimuli signals
	signal s_avalon_buffer_stimuli_mm_waitrequest : std_logic; --                                     -- avalon_mm.waitrequest
	signal s_avalon_buffer_stimuli_mm_address     : std_logic_vector(11 downto 0); --          .address
	signal s_avalon_buffer_stimuli_mm_write       : std_logic; --                                     --          .write
	signal s_avalon_buffer_stimuli_mm_writedata   : std_logic_vector(63 downto 0); -- --          .writedata
	signal s_avalon_buffer_stimuli_mm_byteenable  : std_logic_vector(7 downto 0);

	type t_rmap_target_spw_tx_flag is record
		ready : std_logic;
		error : std_logic;
	end record t_rmap_target_spw_tx_flag;

	type t_rmap_target_spw_tx_control is record
		write : std_logic;
		flag  : std_logic;
		data  : std_logic_vector(7 downto 0);
	end record t_rmap_target_spw_tx_control;

	--dummy
	signal s_dummy_spw_tx_flag    : t_rmap_target_spw_tx_flag;
	signal s_dummy_spw_tx_control : t_rmap_target_spw_tx_control;

	signal s_dummy_spw_rxvalid : std_logic;
	signal s_dummy_spw_rxhalff : std_logic;
	signal s_dummy_spw_rxflag  : std_logic;
	signal s_dummy_spw_rxdata  : std_logic_vector(7 downto 0);
	signal s_dummy_spw_rxread  : std_logic;

	signal s_delay_trigger  : std_logic;
	signal s_delay_timer    : std_logic_vector(7 downto 0);
	signal s_delay_busy     : std_logic;
	signal s_delay_finished : std_logic;

begin

	clk200 <= not clk200 after 2.5 ns;  -- 200 MHz
	clk100 <= not clk100 after 5 ns;    -- 100 MHz
	rst    <= '0' after 100 ns;

	config_avalon_stimuli_inst : entity work.config_avalon_stimuli
		generic map(
			g_ADDRESS_WIDTH => 8,
			g_DATA_WIDTH    => 32
		)
		port map(
			clk_i                   => clk100,
			rst_i                   => rst,
			avalon_mm_readdata_i    => s_config_avalon_stimuli_mm_readdata,
			avalon_mm_waitrequest_i => s_config_avalon_stimuli_mm_waitrequest,
			avalon_mm_address_o     => s_config_avalon_stimuli_mm_address,
			avalon_mm_write_o       => s_config_avalon_stimuli_mm_write,
			avalon_mm_writedata_o   => s_config_avalon_stimuli_mm_writedata,
			avalon_mm_read_o        => s_config_avalon_stimuli_mm_read
		);

	avalon_buffer_stimuli_inst : entity work.avalon_buffer_stimuli
		generic map(
			g_ADDRESS_WIDTH    => 12,
			g_DATA_WIDTH       => 64,
			g_BYTEENABLE_WIDTH => 8
		)
		port map(
			clk_i                   => clk100,
			rst_i                   => rst,
			avalon_mm_waitrequest_i => s_avalon_buffer_stimuli_mm_waitrequest,
			avalon_mm_address_o     => s_avalon_buffer_stimuli_mm_address,
			avalon_mm_write_o       => s_avalon_buffer_stimuli_mm_write,
			avalon_mm_writedata_o   => s_avalon_buffer_stimuli_mm_writedata,
			avalon_mm_byteenable_o  => s_avalon_buffer_stimuli_mm_byteenable
		);

	dcom_v1_top_inst : entity work.dcom_v1_top
		port map(
			reset_sink_reset                     => rst,
			data_in                              => s_spw_codec_comm_di,
			data_out                             => s_spw_codec_comm_do,
			strobe_in                            => s_spw_codec_comm_si,
			strobe_out                           => s_spw_codec_comm_so,
			sync_channel                         => s_sync,
			clock_sink_100_clk                   => clk100,
			clock_sink_200_clk                   => clk200,
			avalon_slave_data_buffer_address     => s_avalon_buffer_stimuli_mm_address,
			avalon_slave_data_buffer_write       => s_avalon_buffer_stimuli_mm_write,
			avalon_slave_data_buffer_writedata   => s_avalon_buffer_stimuli_mm_writedata,
			avalon_slave_data_buffer_byteenable  => s_avalon_buffer_stimuli_mm_byteenable,
			avalon_slave_data_buffer_waitrequest => s_avalon_buffer_stimuli_mm_waitrequest,
			avalon_slave_dcom_address            => s_config_avalon_stimuli_mm_address,
			avalon_slave_dcom_write              => s_config_avalon_stimuli_mm_write,
			avalon_slave_dcom_read               => s_config_avalon_stimuli_mm_read,
			avalon_slave_dcom_readdata           => s_config_avalon_stimuli_mm_readdata,
			avalon_slave_dcom_writedata          => s_config_avalon_stimuli_mm_writedata,
			avalon_slave_dcom_waitrequest        => s_config_avalon_stimuli_mm_waitrequest,
			tx_interrupt_sender_irq              => s_irq_tx
		);

	--	s_spw_codec_comm_di <= s_spw_codec_comm_do;
	--	s_spw_codec_comm_si <= s_spw_codec_comm_so;

	s_spw_clock <= (s_spw_codec_comm_so) xor (s_spw_codec_comm_do);

	p_sync_generator : process(clk100, rst) is
		variable v_sync_div_cnt : natural := 0;
	begin
		if (rst = '1') then
			s_sync         <= '0';
			v_sync_div_cnt := 0;
		elsif rising_edge(clk100) then
			if (v_sync_div_cnt = 10000) then
				if (s_sync = '0') then
					s_sync         <= '1';
					v_sync_div_cnt := 0;
				else
					s_sync         <= '0';
					v_sync_div_cnt := 10001;
				end if;
				--				v_sync_div_cnt := 0;
			end if;
			v_sync_div_cnt := v_sync_div_cnt + 1;
			--			s_sync         <= '0';
		end if;
	end process p_sync_generator;

	-- spw connection
	-- SpaceWire Light Codec Component 
	spw_stimuli_spwstream_inst : entity work.spwstream
		generic map(
			sysfreq         => 100000000.0,
			txclkfreq       => 0.0,
			rximpl          => impl_generic,
			rxchunk         => 1,
			tximpl          => impl_generic,
			rxfifosize_bits => 11,
			txfifosize_bits => 11
		)
		port map(
			clk        => clk100,
			rxclk      => clk100,
			txclk      => clk100,
			rst        => rst,
			autostart  => '1',
			linkstart  => '1',
			linkdis    => '0',
			txdivcnt   => x"01",
			tick_in    => '0',
			ctrl_in    => "00",
			time_in    => "000000",
			txwrite    => s_dummy_spw_tx_control.write,
			txflag     => s_dummy_spw_tx_control.flag,
			txdata     => s_dummy_spw_tx_control.data,
			txrdy      => s_dummy_spw_tx_flag.ready,
			txhalff    => open,
			tick_out   => open,
			ctrl_out   => open,
			time_out   => open,
			rxvalid    => s_dummy_spw_rxvalid,
			rxhalff    => s_dummy_spw_rxhalff,
			rxflag     => s_dummy_spw_rxflag,
			rxdata     => s_dummy_spw_rxdata,
			rxread     => s_dummy_spw_rxread,
			started    => open,
			connecting => open,
			running    => open,
			errdisc    => open,
			errpar     => open,
			erresc     => open,
			errcred    => open,
			spw_di     => s_spw_codec_dummy_di,
			spw_si     => s_spw_codec_dummy_si,
			spw_do     => s_spw_codec_dummy_do,
			spw_so     => s_spw_codec_dummy_so
		);

	p_codec_dummy_read : process(clk100, rst) is
		variable v_time_counter : natural := 0;
		variable v_data_counter : natural := 0;
	begin
		if (rst = '1') then
			s_dummy_spw_rxread <= '0';
			s_delay_timer      <= std_logic_vector(to_unsigned(0, s_delay_timer'length));
			s_delay_trigger    <= '0';
		elsif rising_edge(clk100) then
			v_time_counter     := v_time_counter + 1;
			s_dummy_spw_rxread <= '0';
			if (s_dummy_spw_rxvalid = '1') then
				s_dummy_spw_rxread <= '1';

				-- check incoming data
				if (s_dummy_spw_rxdata = x"00") then
					--assert false report "Wrong Spw Rx Data" severity error;
				end if;
			end if;

			if ((s_dummy_spw_rxvalid = '1') and (s_dummy_spw_rxread = '1')) then
				v_data_counter := v_data_counter + 1;
			end if;

			s_delay_timer <= std_logic_vector(to_unsigned(10, s_delay_timer'length));
			if (v_time_counter = 1000) then
				s_delay_trigger <= '1';
			else
				s_delay_trigger <= '0';
			end if;

		end if;
	end process p_codec_dummy_read;

	s_spw_codec_comm_di  <= s_spw_codec_dummy_do;
	s_spw_codec_comm_si  <= s_spw_codec_dummy_so;
	s_spw_codec_dummy_di <= s_spw_codec_comm_do;
	s_spw_codec_dummy_si <= s_spw_codec_comm_so;

end architecture RTL;
