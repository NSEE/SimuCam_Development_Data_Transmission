library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_top is
end entity testbench_top;

architecture RTL of testbench_top is

	-- clk and rst signals
	signal clk200 : std_logic := '0';
	signal clk100 : std_logic := '0';
	signal rst    : std_logic := '1';

	-- dut signals

	-- irq signal
	signal s_irq_tx : std_logic;

	-- sync signal
	signal s_sync : std_logic;

	-- config_avalon_stimuli signals
	signal s_config_avalon_stimuli_mm_readdata    : std_logic_vector(31 downto 0); -- avalon_mm.readdata
	signal s_config_avalon_stimuli_mm_waitrequest : std_logic; --                  --          .waitrequest
	signal s_config_avalon_stimuli_mm_address     : std_logic_vector(7 downto 0); ---          .address
	signal s_config_avalon_stimuli_mm_write       : std_logic; --                  --          .write
	signal s_config_avalon_stimuli_mm_writedata   : std_logic_vector(31 downto 0); --          .writedata
	signal s_config_avalon_stimuli_mm_read        : std_logic; --                  --          .read

	-- avm signals
	signal s_avm_readdata    : std_logic_vector(63 downto 0);
	signal s_avm_waitrequest : std_logic;
	signal s_avm_address     : std_logic_vector(63 downto 0);
	signal s_avm_read        : std_logic;

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

	dcom_tb_avs_read_ent_inst : entity work.dcom_tb_avs_read_ent
		port map(
			clk_i                               => clk100,
			rst_i                               => rst,
			dcom_tb_avs_avalon_mm_i.address     => s_avm_address,
			dcom_tb_avs_avalon_mm_i.read        => s_avm_read,
			dcom_tb_avs_avalon_mm_i.byteenable  => (others => '1'),
			dcom_tb_avs_avalon_mm_o.readdata    => s_avm_readdata,
			dcom_tb_avs_avalon_mm_o.waitrequest => s_avm_waitrequest
		);

	dcom_v2_top_inst : entity work.dcom_v2_top
		port map(
			reset_sink_reset_i               => rst,
--			sync_channel_i                   => s_sync,
			sync_channel_i                   => '0',
			clock_sink_100_clk_i             => clk100,
			avalon_master_data_readdata_i    => s_avm_readdata,
			avalon_master_data_waitrequest_i => s_avm_waitrequest,
			avalon_master_data_address_o     => s_avm_address,
			avalon_master_data_read_o        => s_avm_read,
			avalon_slave_dcom_address_i      => s_config_avalon_stimuli_mm_address,
--			avalon_slave_dcom_byteenable_i   => (others => '1'),
			avalon_slave_dcom_write_i        => s_config_avalon_stimuli_mm_write,
			avalon_slave_dcom_read_i         => s_config_avalon_stimuli_mm_read,
			avalon_slave_dcom_writedata_i    => s_config_avalon_stimuli_mm_writedata,
			avalon_slave_dcom_readdata_o     => s_config_avalon_stimuli_mm_readdata,
			avalon_slave_dcom_waitrequest_o  => s_config_avalon_stimuli_mm_waitrequest,
			tx_interrupt_sender_irq_o        => s_irq_tx,
			spw_link_status_started_i        => '0',
			spw_link_status_connecting_i     => '0',
			spw_link_status_running_i        => '0',
			spw_link_error_errdisc_i         => '0',
			spw_link_error_errpar_i          => '0',
			spw_link_error_erresc_i          => '0',
			spw_link_error_errcred_i         => '0',
			spw_timecode_rx_tick_out_i       => '0',
			spw_timecode_rx_ctrl_out_i       => (others => '0'),
			spw_timecode_rx_time_out_i       => (others => '0'),
			spw_data_rx_status_rxvalid_i     => '0',
			spw_data_rx_status_rxhalff_i     => '0',
			spw_data_rx_status_rxflag_i      => '0',
			spw_data_rx_status_rxdata_i      => (others => '0'),
			spw_data_tx_status_txrdy_i       => '1',
			spw_data_tx_status_txhalff_i     => '0',
			spw_link_command_autostart_o     => open,
			spw_link_command_linkstart_o     => open,
			spw_link_command_linkdis_o       => open,
			spw_link_command_txdivcnt_o      => open,
			spw_timecode_tx_tick_in_o        => open,
			spw_timecode_tx_ctrl_in_o        => open,
			spw_timecode_tx_time_in_o        => open,
			spw_data_rx_command_rxread_o     => open,
			spw_data_tx_command_txwrite_o    => open,
			spw_data_tx_command_txflag_o     => open,
			spw_data_tx_command_txdata_o     => open,
			codec_rmap_wr_waitrequest_i      => '0',
			codec_rmap_readdata_i            => (others => '0'),
			codec_rmap_rd_waitrequest_i      => '0',
			codec_rmap_wr_address_o          => open,
			codec_rmap_write_o               => open,
			codec_rmap_writedata_o           => open,
			codec_rmap_rd_address_o          => open,
			codec_rmap_read_o                => open,
			rmap_mem_addr_offset_o           => open
		);

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

end architecture RTL;
