library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity config_avalon_stimuli is
	generic(
		g_ADDRESS_WIDTH : natural range 1 to 64;
		g_DATA_WIDTH    : natural range 1 to 64
	);
	port(
		clk_i                   : in  std_logic;
		rst_i                   : in  std_logic;
		avalon_mm_readdata_i    : in  std_logic_vector((g_DATA_WIDTH - 1) downto 0); -- -- avalon_mm.readdata
		avalon_mm_waitrequest_i : in  std_logic; --                                     --          .waitrequest
		avalon_mm_address_o     : out std_logic_vector((g_ADDRESS_WIDTH - 1) downto 0); --          .address
		avalon_mm_write_o       : out std_logic; --                                     --          .write
		avalon_mm_writedata_o   : out std_logic_vector((g_DATA_WIDTH - 1) downto 0); -- --          .writedata
		avalon_mm_read_o        : out std_logic --                                      --          .read
	);
end entity config_avalon_stimuli;

architecture RTL of config_avalon_stimuli is

	signal s_counter : natural := 0;

begin

	p_config_avalon_stimuli : process(clk_i, rst_i) is
	begin
		if (rst_i = '1') then

			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			avalon_mm_read_o      <= '0';
			s_counter             <= 0;

		elsif rising_edge(clk_i) then

			avalon_mm_address_o   <= (others => '0');
			avalon_mm_write_o     <= '0';
			avalon_mm_writedata_o <= (others => '0');
			avalon_mm_read_o      <= '0';
			s_counter             <= s_counter + 1;

			case s_counter is

				-- spw_link_config_status_reg
				when 500 to 501 =>
					-- register write
					avalon_mm_address_o                 <= std_logic_vector(to_unsigned(16#00#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                   <= '1';
					avalon_mm_writedata_o               <= (others => '0');
					avalon_mm_writedata_o(0)            <= '0'; -- spw_lnkcfg_disconnect           
					avalon_mm_writedata_o(1)            <= '1'; -- spw_lnkcfg_linkstart            
					avalon_mm_writedata_o(2)            <= '0'; -- spw_lnkcfg_autostart            
					avalon_mm_writedata_o(31 downto 24) <= x"02"; -- spw_lnkcfg_txdivcnt    
					avalon_mm_read_o                    <= '0';

				-- spw_timecode_tx_rxctrl_reg
				when 550 to 551 =>
					-- register write
					avalon_mm_address_o               <= std_logic_vector(to_unsigned(16#01#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                 <= '1';
					avalon_mm_writedata_o             <= (others => '0');
					avalon_mm_writedata_o(5 downto 0) <= "000000"; -- timecode_tx_time         
					avalon_mm_writedata_o(7 downto 6) <= "00"; -- timecode_tx_control      
					avalon_mm_writedata_o(8)          <= '0'; -- timecode_tx_send         
					avalon_mm_writedata_o(24)         <= '0'; -- timecode_rx_received_clr 
					avalon_mm_read_o                  <= '0';

				-- data_controller_config_reg
				when 600 to 601 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#03#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '1'; -- send_eop                 
					avalon_mm_writedata_o(1) <= '1'; -- send_eep       
					avalon_mm_read_o         <= '0';

				-- data_scheduler_timer_config_reg
				when 650 to 651 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#04#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '1'; -- timer_start_on_sync 
					avalon_mm_read_o         <= '0';

				-- data_scheduler_timer_clkdiv_reg
				when 700 to 701 =>
					-- register write
					avalon_mm_address_o                <= std_logic_vector(to_unsigned(16#05#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                  <= '1';
					avalon_mm_writedata_o              <= (others => '0');
					avalon_mm_writedata_o(31 downto 0) <= std_logic_vector(to_unsigned(9, 32)); -- timer_clk_div    
					avalon_mm_read_o                   <= '0';

				-- data_scheduler_timer_time_in_reg
				when 750 to 751 =>
					-- register write
					avalon_mm_address_o                <= std_logic_vector(to_unsigned(16#07#, g_ADDRESS_WIDTH));
					avalon_mm_write_o                  <= '1';
					avalon_mm_writedata_o              <= (others => '0');
					avalon_mm_writedata_o(31 downto 0) <= std_logic_vector(to_unsigned(0, 32)); -- timer_time_in      
					avalon_mm_read_o                   <= '0';

				-- data_scheduler_timer_control_reg
				when 800 to 801 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#08#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '1'; -- timer_start        
					avalon_mm_writedata_o(1) <= '0'; -- timer_run          
					avalon_mm_writedata_o(2) <= '0'; -- timer_stop         
					avalon_mm_writedata_o(3) <= '0'; -- timer_clear        
					avalon_mm_read_o         <= '0';
					
--				-- data_scheduler_timer_control_reg
--				when 20630 to 20631 =>
--					-- register write
--					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#08#, g_ADDRESS_WIDTH));
--					avalon_mm_write_o        <= '1';
--					avalon_mm_writedata_o    <= (others => '0');
--					avalon_mm_writedata_o(0) <= '0'; -- timer_start        
--					avalon_mm_writedata_o(1) <= '0'; -- timer_run          
--					avalon_mm_writedata_o(2) <= '0'; -- timer_stop         
--					avalon_mm_writedata_o(3) <= '1'; -- timer_clear        
--					avalon_mm_read_o         <= '0';

--				-- data_scheduler_timer_control_reg
--				when 20300 to 20301 =>
--					-- register write
--					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#08#, g_ADDRESS_WIDTH));
--					avalon_mm_write_o        <= '1';
--					avalon_mm_writedata_o    <= (others => '0');
--					avalon_mm_writedata_o(0) <= '0'; -- timer_start        
--					avalon_mm_writedata_o(1) <= '0'; -- timer_run          
--					avalon_mm_writedata_o(2) <= '1'; -- timer_stop         
--					avalon_mm_writedata_o(3) <= '0'; -- timer_clear        
--					avalon_mm_read_o         <= '0';

				-- dcom_irq_control_reg
				when 850 to 851 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#09#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '1'; -- dcom_tx_end_en                 
					avalon_mm_writedata_o(1) <= '1'; -- dcom_tx_begin_en               
					avalon_mm_writedata_o(8) <= '1'; -- dcom_global_irq_en   
					avalon_mm_read_o         <= '0';

				-- dcom_irq_flags_clear_reg
				when 900 to 901 =>
					-- register write
					avalon_mm_address_o      <= std_logic_vector(to_unsigned(16#0B#, g_ADDRESS_WIDTH));
					avalon_mm_write_o        <= '1';
					avalon_mm_writedata_o    <= (others => '0');
					avalon_mm_writedata_o(0) <= '0'; -- dcom_tx_end_flag_clear     
					avalon_mm_writedata_o(1) <= '0'; -- dcom_tx_begin_flag_clear   
					avalon_mm_read_o         <= '0';

				when others =>
					null;

			end case;

		end if;
	end process p_config_avalon_stimuli;

end architecture RTL;
