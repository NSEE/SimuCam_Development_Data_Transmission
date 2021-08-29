library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.avalon_mm_dcom_pkg.all;
use work.avalon_mm_dcom_registers_pkg.all;

entity dcom_config_avalon_mm_stimulli is
    port(
        clk_i                       : in  std_logic;
        rst_i                       : in  std_logic;
        avs_config_rd_regs_i        : in  t_dcom_read_registers;
        avs_config_wr_regs_o        : out t_dcom_write_registers;
        avs_config_rd_readdata_o    : out std_logic_vector(31 downto 0);
        avs_config_rd_waitrequest_o : out std_logic;
        avs_config_wr_waitrequest_o : out std_logic
    );
end entity dcom_config_avalon_mm_stimulli;

architecture RTL of dcom_config_avalon_mm_stimulli is

    signal s_counter : natural := 0;

begin

    p_dcom_config_avalon_mm_stimulli : process(clk_i, rst_i) is
        procedure p_reset_registers is
        begin

            -- Write Registers Reset/Default State

            -- Dcom Device Address Register : Dcom Device Base Address
            avs_config_wr_regs_o.dcom_dev_addr_reg.dcom_dev_base_addr                                         <= (others => '0');
            -- Dcom IRQ Control Register : Dcom Global IRQ Enable
            avs_config_wr_regs_o.dcom_irq_control_reg.dcom_global_irq_en                                      <= '0';
            -- SpaceWire Device Address Register : SpaceWire Device Base Address
            avs_config_wr_regs_o.spw_dev_addr_reg.spw_dev_base_addr                                           <= (others => '0');
            -- SpaceWire Link Config Register : SpaceWire Link Config Enable
            avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_enable                                        <= '0';
            -- SpaceWire Link Config Register : SpaceWire Link Config Disconnect
            avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_disconnect                                    <= '0';
            -- SpaceWire Link Config Register : SpaceWire Link Config Linkstart
            avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_linkstart                                     <= '0';
            -- SpaceWire Link Config Register : SpaceWire Link Config Autostart
            avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_autostart                                     <= '0';
            -- SpaceWire Link Config Register : SpaceWire Link Config TxDivCnt
            avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_txdivcnt                                      <= x"01";
            -- SpaceWire Timecode Control Register : SpaceWire Timecode Tx Time
            avs_config_wr_regs_o.spw_timecode_control_reg.timecode_tx_time                                    <= (others => '0');
            -- SpaceWire Timecode Control Register : SpaceWire Timecode Tx Control
            avs_config_wr_regs_o.spw_timecode_control_reg.timecode_tx_control                                 <= (others => '0');
            -- SpaceWire Timecode Control Register : SpaceWire Timecode Tx Send
            avs_config_wr_regs_o.spw_timecode_control_reg.timecode_tx_send                                    <= '0';
            -- SpaceWire Timecode Control Register : SpaceWire Timecode Rx Received Clear
            avs_config_wr_regs_o.spw_timecode_control_reg.timecode_rx_received_clear                          <= '0';
            -- SpaceWire Codec Error Injection Control Register : Start SpaceWire Codec Error Injection
            avs_config_wr_regs_o.spw_codec_errinj_control_reg.errinj_ctrl_start_errinj                        <= '0';
            -- SpaceWire Codec Error Injection Control Register : Reset SpaceWire Codec Error Injection
            avs_config_wr_regs_o.spw_codec_errinj_control_reg.errinj_ctrl_reset_errinj                        <= '0';
            -- SpaceWire Codec Error Injection Control Register : SpaceWire Codec Error Injection Error Code
            avs_config_wr_regs_o.spw_codec_errinj_control_reg.errinj_ctrl_errinj_code                         <= (others => '0');
            -- Data Scheduler Device Address Register : Data Scheduler Device Base Address
            avs_config_wr_regs_o.data_scheduler_dev_addr_reg.data_scheduler_dev_base_addr                     <= (others => '0');
            -- Data Scheduler Timer Control Register : Data Scheduler Timer Start
            avs_config_wr_regs_o.data_scheduler_tmr_control_reg.timer_start                                   <= '0';
            -- Data Scheduler Timer Control Register : Data Scheduler Timer Run
            avs_config_wr_regs_o.data_scheduler_tmr_control_reg.timer_run                                     <= '0';
            -- Data Scheduler Timer Control Register : Data Scheduler Timer Stop
            avs_config_wr_regs_o.data_scheduler_tmr_control_reg.timer_stop                                    <= '0';
            -- Data Scheduler Timer Control Register : Data Scheduler Timer Clear
            avs_config_wr_regs_o.data_scheduler_tmr_control_reg.timer_clear                                   <= '0';
            -- Data Scheduler Timer Config Register : Data Scheduler Timer Run on Sync
            avs_config_wr_regs_o.data_scheduler_tmr_config_reg.timer_run_on_sync                              <= '1';
            -- Data Scheduler Timer Config Register : Data Scheduler Timer Clock Div
            avs_config_wr_regs_o.data_scheduler_tmr_config_reg.timer_clk_div                                  <= (others => '0');
            -- Data Scheduler Timer Config Register : Data Scheduler Timer Start Time
            avs_config_wr_regs_o.data_scheduler_tmr_config_reg.timer_start_time                               <= (others => '0');
            -- Data Scheduler Packet Config Register : Data Scheduler Send EOP with Packet
            avs_config_wr_regs_o.data_scheduler_pkt_config_reg.send_eop                                       <= '1';
            -- Data Scheduler Packet Config Register : Data Scheduler Send EEP with Packet
            avs_config_wr_regs_o.data_scheduler_pkt_config_reg.send_eep                                       <= '0';
            -- Data Scheduler Data Control Register : Data Scheduler Initial Read Address [High Dword]
            avs_config_wr_regs_o.data_scheduler_data_control_reg.rd_initial_addr_high_dword                   <= (others => '0');
            -- Data Scheduler Data Control Register : Data Scheduler Initial Read Address [Low Dword]
            avs_config_wr_regs_o.data_scheduler_data_control_reg.rd_initial_addr_low_dword                    <= (others => '0');
            -- Data Scheduler Data Control Register : Data Scheduler Read Data Length [Bytes]
            avs_config_wr_regs_o.data_scheduler_data_control_reg.rd_data_length_bytes                         <= (others => '0');
            -- Data Scheduler Data Control Register : Data Scheduler Data Read Start
            avs_config_wr_regs_o.data_scheduler_data_control_reg.rd_start                                     <= '0';
            -- Data Scheduler Data Control Register : Data Scheduler Data Read Reset
            avs_config_wr_regs_o.data_scheduler_data_control_reg.rd_reset                                     <= '0';
            -- Data Scheduler Data Control Register : Data Scheduler Data Read Auto Restart
            avs_config_wr_regs_o.data_scheduler_data_control_reg.rd_auto_restart                              <= '0';
            -- Data Scheduler IRQ Control Register : Data Scheduler Tx End IRQ Enable
            avs_config_wr_regs_o.data_scheduler_irq_control_reg.irq_tx_end_en                                 <= '0';
            -- Data Scheduler IRQ Control Register : Data Scheduler Tx Begin IRQ Enable
            avs_config_wr_regs_o.data_scheduler_irq_control_reg.irq_tx_begin_en                               <= '0';
            -- Data Scheduler IRQ Flags Clear Register : Data Scheduler Tx End IRQ Flag Clear
            avs_config_wr_regs_o.data_scheduler_irq_flags_clear_reg.irq_tx_end_flag_clear                     <= '0';
            -- Data Scheduler IRQ Flags Clear Register : Data Scheduler Tx Begin IRQ Flag Clear
            avs_config_wr_regs_o.data_scheduler_irq_flags_clear_reg.irq_tx_begin_flag_clear                   <= '0';
            -- RMAP Device Address Register : RMAP Device Base Address
            avs_config_wr_regs_o.rmap_dev_addr_reg.rmap_dev_base_addr                                         <= (others => '0');
            -- RMAP Echoing Mode Config Register : RMAP Echoing Mode Enable
            avs_config_wr_regs_o.rmap_echoing_mode_config_reg.rmap_echoing_mode_enable                        <= '0';
            -- RMAP Echoing Mode Config Register : RMAP Echoing ID Enable
            avs_config_wr_regs_o.rmap_echoing_mode_config_reg.rmap_echoing_id_enable                          <= '0';
            -- RMAP Codec Config Register : RMAP Target Enable
            avs_config_wr_regs_o.rmap_codec_config_reg.rmap_target_enable                                     <= '1';
            -- RMAP Codec Config Register : RMAP Target Logical Address
            avs_config_wr_regs_o.rmap_codec_config_reg.rmap_target_logical_addr                               <= x"00";
            -- RMAP Codec Config Register : RMAP Target Key
            avs_config_wr_regs_o.rmap_codec_config_reg.rmap_target_key                                        <= x"00";
            -- RMAP Memory Area Config Register : RMAP Memory Area Address Offset
            avs_config_wr_regs_o.rmap_mem_area_config_reg.rmap_mem_area_addr_offset                           <= (others => '0');
            -- RMAP Memory Area Pointer Register : RMAP Memory Area Pointer
            avs_config_wr_regs_o.rmap_mem_area_ptr_reg.rmap_mem_area_ptr                                      <= (others => '0');
            -- RMAP Error Injection Control Register : Reset RMAP Error
            avs_config_wr_regs_o.rmap_error_injection_control_reg.rmap_errinj_reset                           <= '0';
            -- RMAP Error Injection Control Register : Trigger RMAP Error
            avs_config_wr_regs_o.rmap_error_injection_control_reg.rmap_errinj_trigger                         <= '0';
            -- RMAP Error Injection Control Register : Error ID of RMAP Error
            avs_config_wr_regs_o.rmap_error_injection_control_reg.rmap_errinj_err_id                          <= (others => '0');
            -- RMAP Error Injection Control Register : Value of RMAP Error
            avs_config_wr_regs_o.rmap_error_injection_control_reg.rmap_errinj_value                           <= (others => '0');
            -- RMAP Error Injection Control Register : Repetitions of RMAP Error
            avs_config_wr_regs_o.rmap_error_injection_control_reg.rmap_errinj_repeats                         <= (others => '0');
            -- Report Device Address Register : Report Device Base Address
            avs_config_wr_regs_o.rprt_dev_addr_reg.rprt_dev_base_addr                                         <= (others => '0');
            -- Report IRQ Control Register : Report SpW Link Connected IRQ Enable
            avs_config_wr_regs_o.report_irq_control_reg.irq_rprt_spw_link_connected_en                        <= '0';
            -- Report IRQ Control Register : Report SpW Link Disconnected IRQ Enable
            avs_config_wr_regs_o.report_irq_control_reg.irq_rprt_spw_link_disconnected_en                     <= '0';
            -- Report IRQ Control Register : Report SpW Error Disconnect IRQ Enable
            avs_config_wr_regs_o.report_irq_control_reg.irq_rprt_spw_err_disconnect_en                        <= '0';
            -- Report IRQ Control Register : Report SpW Error Parity IRQ Enable
            avs_config_wr_regs_o.report_irq_control_reg.irq_rprt_spw_err_parity_en                            <= '0';
            -- Report IRQ Control Register : Report SpW Error Escape IRQ Enable
            avs_config_wr_regs_o.report_irq_control_reg.irq_rprt_spw_err_escape_en                            <= '0';
            -- Report IRQ Control Register : Report SpW Error Credit IRQ Enable
            avs_config_wr_regs_o.report_irq_control_reg.irq_rprt_spw_err_credit_en                            <= '0';
            -- Report IRQ Control Register : Report Rx Timecode Received IRQ Enable
            avs_config_wr_regs_o.report_irq_control_reg.irq_rprt_rx_timecode_received_en                      <= '0';
            -- Report IRQ Control Register : Report Rmap Error Early EOP IRQ Enable
            avs_config_wr_regs_o.report_irq_control_reg.irq_rprt_rmap_err_early_eop_en                        <= '0';
            -- Report IRQ Control Register : Report Rmap Error EEP IRQ Enable
            avs_config_wr_regs_o.report_irq_control_reg.irq_rprt_rmap_err_eep_en                              <= '0';
            -- Report IRQ Control Register : Report Rmap Error Header CRC IRQ Enable
            avs_config_wr_regs_o.report_irq_control_reg.irq_rprt_rmap_err_header_crc_en                       <= '0';
            -- Report IRQ Control Register : Report Rmap Error Unused Packet Type IRQ Enable
            avs_config_wr_regs_o.report_irq_control_reg.irq_rprt_rmap_err_unused_packet_type_en               <= '0';
            -- Report IRQ Control Register : Report Rmap Error Invalid Command Code IRQ Enable
            avs_config_wr_regs_o.report_irq_control_reg.irq_rprt_rmap_err_invalid_command_code_en             <= '0';
            -- Report IRQ Control Register : Report Rmap Error Too Much Data IRQ Enable
            avs_config_wr_regs_o.report_irq_control_reg.irq_rprt_rmap_err_too_much_data_en                    <= '0';
            -- Report IRQ Control Register : Report Rmap Error Invalid Data Crc IRQ Enable
            avs_config_wr_regs_o.report_irq_control_reg.irq_rprt_rmap_err_invalid_data_crc_en                 <= '0';
            -- Report IRQ Flags Clear Register : Report SpW Link Connected IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_spw_link_connected_flag_clear            <= '0';
            -- Report IRQ Flags Clear Register : Report SpW Link Disconnected IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_spw_link_disconnected_flag_clear         <= '0';
            -- Report IRQ Flags Clear Register : Report SpW Error Disconnect IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_spw_err_disconnect_flag_clear            <= '0';
            -- Report IRQ Flags Clear Register : Report SpW Error Parity IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_spw_err_parity_flag_clear                <= '0';
            -- Report IRQ Flags Clear Register : Report SpW Error Escape IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_spw_err_escape_flag_clear                <= '0';
            -- Report IRQ Flags Clear Register : Report SpW Error Credit IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_spw_err_credit_flag_clear                <= '0';
            -- Report IRQ Flags Clear Register : Report Rx Timecode Received IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_rx_timecode_received_flag_clear          <= '0';
            -- Report IRQ Flags Clear Register : Report Rmap Error Early EOP IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_rmap_err_early_eop_flag_clear            <= '0';
            -- Report IRQ Flags Clear Register : Report Rmap Error EEP IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_rmap_err_eep_flag_clear                  <= '0';
            -- Report IRQ Flags Clear Register : Report Rmap Error Header CRC IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_rmap_err_header_crc_flag_clear           <= '0';
            -- Report IRQ Flags Clear Register : Report Rmap Error Unused Packet Type IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_rmap_err_unused_packet_type_flag_clear   <= '0';
            -- Report IRQ Flags Clear Register : Report Rmap Error Invalid Command Code IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_rmap_err_invalid_command_code_flag_clear <= '0';
            -- Report IRQ Flags Clear Register : Report Rmap Error Too Much Data IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_rmap_err_too_much_data_flag_clear        <= '0';
            -- Report IRQ Flags Clear Register : Report Rmap Error Invalid Data Crc IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_rmap_err_invalid_data_crc_flag_clear     <= '0';

        end procedure p_reset_registers;

        procedure p_control_triggers is
        begin

            -- Write Registers Triggers Reset

            -- SpaceWire Timecode Control Register : SpaceWire Timecode Tx Send
            avs_config_wr_regs_o.spw_timecode_control_reg.timecode_tx_send                                    <= '0';
            -- SpaceWire Timecode Control Register : SpaceWire Timecode Rx Received Clear
            avs_config_wr_regs_o.spw_timecode_control_reg.timecode_rx_received_clear                          <= '0';
            -- SpaceWire Codec Error Injection Control Register : Start SpaceWire Codec Error Injection
            avs_config_wr_regs_o.spw_codec_errinj_control_reg.errinj_ctrl_start_errinj                        <= '0';
            -- SpaceWire Codec Error Injection Control Register : Reset SpaceWire Codec Error Injection
            avs_config_wr_regs_o.spw_codec_errinj_control_reg.errinj_ctrl_reset_errinj                        <= '0';
            -- Data Scheduler Timer Control Register : Data Scheduler Timer Start
            avs_config_wr_regs_o.data_scheduler_tmr_control_reg.timer_start                                   <= '0';
            -- Data Scheduler Timer Control Register : Data Scheduler Timer Run
            avs_config_wr_regs_o.data_scheduler_tmr_control_reg.timer_run                                     <= '0';
            -- Data Scheduler Timer Control Register : Data Scheduler Timer Stop
            avs_config_wr_regs_o.data_scheduler_tmr_control_reg.timer_stop                                    <= '0';
            -- Data Scheduler Timer Control Register : Data Scheduler Timer Clear
            avs_config_wr_regs_o.data_scheduler_tmr_control_reg.timer_clear                                   <= '0';
            -- Data Scheduler Data Control Register : Data Scheduler Data Read Start
            avs_config_wr_regs_o.data_scheduler_data_control_reg.rd_start                                     <= '0';
            -- Data Scheduler Data Control Register : Data Scheduler Data Read Reset
            avs_config_wr_regs_o.data_scheduler_data_control_reg.rd_reset                                     <= '0';
            -- Data Scheduler IRQ Flags Clear Register : Data Scheduler Tx End IRQ Flag Clear
            avs_config_wr_regs_o.data_scheduler_irq_flags_clear_reg.irq_tx_end_flag_clear                     <= '0';
            -- Data Scheduler IRQ Flags Clear Register : Data Scheduler Tx Begin IRQ Flag Clear
            avs_config_wr_regs_o.data_scheduler_irq_flags_clear_reg.irq_tx_begin_flag_clear                   <= '0';
            -- RMAP Error Injection Control Register : Reset RMAP Error
            avs_config_wr_regs_o.rmap_error_injection_control_reg.rmap_errinj_reset                           <= '0';
            -- RMAP Error Injection Control Register : Trigger RMAP Error
            avs_config_wr_regs_o.rmap_error_injection_control_reg.rmap_errinj_trigger                         <= '0';
            -- Report IRQ Flags Clear Register : Report SpW Link Connected IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_spw_link_connected_flag_clear            <= '0';
            -- Report IRQ Flags Clear Register : Report SpW Link Disconnected IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_spw_link_disconnected_flag_clear         <= '0';
            -- Report IRQ Flags Clear Register : Report SpW Error Disconnect IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_spw_err_disconnect_flag_clear            <= '0';
            -- Report IRQ Flags Clear Register : Report SpW Error Parity IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_spw_err_parity_flag_clear                <= '0';
            -- Report IRQ Flags Clear Register : Report SpW Error Escape IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_spw_err_escape_flag_clear                <= '0';
            -- Report IRQ Flags Clear Register : Report SpW Error Credit IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_spw_err_credit_flag_clear                <= '0';
            -- Report IRQ Flags Clear Register : Report Rx Timecode Received IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_rx_timecode_received_flag_clear          <= '0';
            -- Report IRQ Flags Clear Register : Report Rmap Error Early EOP IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_rmap_err_early_eop_flag_clear            <= '0';
            -- Report IRQ Flags Clear Register : Report Rmap Error EEP IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_rmap_err_eep_flag_clear                  <= '0';
            -- Report IRQ Flags Clear Register : Report Rmap Error Header CRC IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_rmap_err_header_crc_flag_clear           <= '0';
            -- Report IRQ Flags Clear Register : Report Rmap Error Unused Packet Type IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_rmap_err_unused_packet_type_flag_clear   <= '0';
            -- Report IRQ Flags Clear Register : Report Rmap Error Invalid Command Code IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_rmap_err_invalid_command_code_flag_clear <= '0';
            -- Report IRQ Flags Clear Register : Report Rmap Error Too Much Data IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_rmap_err_too_much_data_flag_clear        <= '0';
            -- Report IRQ Flags Clear Register : Report Rmap Error Invalid Data Crc IRQ Flag Clear
            avs_config_wr_regs_o.report_irq_flags_clear_reg.irq_rprt_rmap_err_invalid_data_crc_flag_clear     <= '0';

        end procedure p_control_triggers;

    begin
        if (rst_i = '1') then

            s_counter <= 0;
            p_reset_registers;

        elsif rising_edge(clk_i) then

            s_counter <= s_counter + 1;
            p_control_triggers;
            case s_counter is

                when 5 =>
                    avs_config_wr_regs_o.rmap_codec_config_reg.rmap_target_enable       <= '0';
                    avs_config_wr_regs_o.rmap_codec_config_reg.rmap_target_logical_addr <= x"00";
                    avs_config_wr_regs_o.rmap_codec_config_reg.rmap_target_key          <= x"00";

                    avs_config_wr_regs_o.rmap_echoing_mode_config_reg.rmap_echoing_mode_enable <= '1';
                    avs_config_wr_regs_o.rmap_echoing_mode_config_reg.rmap_echoing_id_enable   <= '1';

                    avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_enable     <= '1';
                    avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_disconnect <= '0';
                    avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_linkstart  <= '1';
                    avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_autostart  <= '1';
                    avs_config_wr_regs_o.spw_link_config_reg.spw_lnkcfg_txdivcnt   <= x"01";

                    avs_config_wr_regs_o.data_scheduler_tmr_config_reg.timer_run_on_sync <= '0';
                    avs_config_wr_regs_o.data_scheduler_tmr_config_reg.timer_clk_div     <= (others => '0');
                    avs_config_wr_regs_o.data_scheduler_tmr_config_reg.timer_start_time  <= (others => '0');

                    avs_config_wr_regs_o.data_scheduler_pkt_config_reg.send_eop <= '1';
                    avs_config_wr_regs_o.data_scheduler_pkt_config_reg.send_eep <= '0';

                    avs_config_wr_regs_o.data_scheduler_tmr_control_reg.timer_stop <= '1';

                when 10 =>
                    avs_config_wr_regs_o.data_scheduler_tmr_control_reg.timer_clear <= '1';

                when 15 =>
                    avs_config_wr_regs_o.data_scheduler_tmr_control_reg.timer_start <= '1';

                when 25 =>
                    avs_config_wr_regs_o.data_scheduler_data_control_reg.rd_initial_addr_high_dword <= (others => '0');
                    avs_config_wr_regs_o.data_scheduler_data_control_reg.rd_initial_addr_low_dword  <= (others => '0');
                    avs_config_wr_regs_o.data_scheduler_data_control_reg.rd_data_length_bytes       <= std_logic_vector(to_unsigned(8 + 16 - 1, 32));
                    avs_config_wr_regs_o.data_scheduler_data_control_reg.rd_start                   <= '1';
                    avs_config_wr_regs_o.data_scheduler_data_control_reg.rd_reset                   <= '0';
                    avs_config_wr_regs_o.data_scheduler_data_control_reg.rd_auto_restart            <= '0';

                when 50 =>
                    avs_config_wr_regs_o.data_scheduler_tmr_control_reg.timer_run <= '1';

                when others =>
                    null;

            end case;

        end if;
    end process p_dcom_config_avalon_mm_stimulli;

    avs_config_rd_readdata_o    <= (others => '0');
    avs_config_rd_waitrequest_o <= '1';
    avs_config_wr_waitrequest_o <= '1';

end architecture RTL;
