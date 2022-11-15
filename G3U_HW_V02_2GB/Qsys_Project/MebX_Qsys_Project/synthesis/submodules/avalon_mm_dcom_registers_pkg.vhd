
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package avalon_mm_dcom_registers_pkg is

    -- Address Constants

    -- Allowed Addresses
    constant c_AVALON_MM_DCOM_MIN_ADDR : natural range 0 to 255 := 16#00#;
    constant c_AVALON_MM_DCOM_MAX_ADDR : natural range 0 to 255 := 16#83#;

    -- Registers Types

    -- Dcom Device Address Register
    type t_dcom_dcom_dev_addr_wr_reg is record
        dcom_dev_base_addr : std_logic_vector(31 downto 0); -- Dcom Device Base Address
    end record t_dcom_dcom_dev_addr_wr_reg;

    -- Dcom IRQ Control Register
    type t_dcom_dcom_irq_control_wr_reg is record
        dcom_global_irq_en : std_logic; -- Dcom Global IRQ Enable
    end record t_dcom_dcom_irq_control_wr_reg;

    -- SpaceWire Device Address Register
    type t_dcom_spw_dev_addr_wr_reg is record
        spw_dev_base_addr : std_logic_vector(31 downto 0); -- SpaceWire Device Base Address
    end record t_dcom_spw_dev_addr_wr_reg;

    -- SpaceWire Link Config Register
    type t_dcom_spw_link_config_wr_reg is record
        spw_lnkcfg_enable     : std_logic; -- SpaceWire Link Config Enable
        spw_lnkcfg_disconnect : std_logic; -- SpaceWire Link Config Disconnect
        spw_lnkcfg_linkstart  : std_logic; -- SpaceWire Link Config Linkstart
        spw_lnkcfg_autostart  : std_logic; -- SpaceWire Link Config Autostart
        spw_lnkcfg_txdivcnt   : std_logic_vector(7 downto 0); -- SpaceWire Link Config TxDivCnt
    end record t_dcom_spw_link_config_wr_reg;

    -- SpaceWire Link Status Register
    type t_dcom_spw_link_status_rd_reg is record
        spw_link_running    : std_logic; -- SpaceWire Link Running
        spw_link_connecting : std_logic; -- SpaceWire Link Connecting
        spw_link_started    : std_logic; -- SpaceWire Link Started
        spw_err_disconnect  : std_logic; -- SpaceWire Error Disconnect
        spw_err_parity      : std_logic; -- SpaceWire Error Parity
        spw_err_escape      : std_logic; -- SpaceWire Error Escape
        spw_err_credit      : std_logic; -- SpaceWire Error Credit
    end record t_dcom_spw_link_status_rd_reg;

    -- SpaceWire Timecode Control Register
    type t_dcom_spw_timecode_control_wr_reg is record
        timecode_tx_time           : std_logic_vector(5 downto 0); -- SpaceWire Timecode Tx Time
        timecode_tx_control        : std_logic_vector(1 downto 0); -- SpaceWire Timecode Tx Control
        timecode_tx_send           : std_logic; -- SpaceWire Timecode Tx Send
        timecode_rx_received_clear : std_logic; -- SpaceWire Timecode Rx Received Clear
    end record t_dcom_spw_timecode_control_wr_reg;

    -- SpaceWire Timecode Status Register
    type t_dcom_spw_timecode_status_rd_reg is record
        timecode_rx_time     : std_logic_vector(5 downto 0); -- SpaceWire Timecode Rx Time
        timecode_rx_control  : std_logic_vector(1 downto 0); -- SpaceWire Timecode Rx Control
        timecode_rx_received : std_logic; -- SpaceWire Timecode Rx Received
    end record t_dcom_spw_timecode_status_rd_reg;

    -- SpaceWire Codec Error Injection Control Register
    type t_domm_spw_codec_errinj_control_wr_reg is record
        errinj_ctrl_start_errinj : std_logic; -- Start SpaceWire Codec Error Injection
        errinj_ctrl_reset_errinj : std_logic; -- Reset SpaceWire Codec Error Injection
        errinj_ctrl_errinj_code  : std_logic_vector(3 downto 0); -- SpaceWire Codec Error Injection Error Code
    end record t_domm_spw_codec_errinj_control_wr_reg;

    -- SpaceWire Codec Error Injection Status Register
    type t_domm_spw_codec_errinj_status_rd_reg is record
        errinj_ctrl_errinj_busy  : std_logic; -- SpaceWire Codec Error Injection is Busy
        errinj_ctrl_errinj_ready : std_logic; -- SpaceWire Codec Error Injection is Ready
    end record t_domm_spw_codec_errinj_status_rd_reg;

    -- Data Scheduler Device Address Register
    type t_dcom_data_scheduler_dev_addr_wr_reg is record
        data_scheduler_dev_base_addr : std_logic_vector(31 downto 0); -- Data Scheduler Device Base Address
    end record t_dcom_data_scheduler_dev_addr_wr_reg;

    -- Data Scheduler Timer Control Register
    type t_dcom_data_scheduler_tmr_control_wr_reg is record
        timer_start : std_logic;        -- Data Scheduler Timer Start
        timer_run   : std_logic;        -- Data Scheduler Timer Run
        timer_stop  : std_logic;        -- Data Scheduler Timer Stop
        timer_clear : std_logic;        -- Data Scheduler Timer Clear
    end record t_dcom_data_scheduler_tmr_control_wr_reg;

    -- Data Scheduler Timer Config Register
    type t_dcom_data_scheduler_tmr_config_wr_reg is record
        timer_run_on_sync : std_logic;  -- Data Scheduler Timer Run on Sync
        timer_clk_div     : std_logic_vector(31 downto 0); -- Data Scheduler Timer Clock Div
        timer_start_time  : std_logic_vector(31 downto 0); -- Data Scheduler Timer Start Time
    end record t_dcom_data_scheduler_tmr_config_wr_reg;

    -- Data Scheduler Timer Status Register
    type t_dcom_data_scheduler_tmr_status_rd_reg is record
        timer_stopped      : std_logic; -- Data Scheduler Timer Stopped
        timer_started      : std_logic; -- Data Scheduler Timer Started
        timer_running      : std_logic; -- Data Scheduler Timer Running
        timer_cleared      : std_logic; -- Data Scheduler Timer Cleared
        timer_current_time : std_logic_vector(31 downto 0); -- Data Scheduler Timer Time
    end record t_dcom_data_scheduler_tmr_status_rd_reg;

    -- Data Scheduler Packet Config Register
    type t_dcom_data_scheduler_pkt_config_wr_reg is record
        send_eop : std_logic;           -- Data Scheduler Send EOP with Packet
        send_eep : std_logic;           -- Data Scheduler Send EEP with Packet
    end record t_dcom_data_scheduler_pkt_config_wr_reg;

    -- Data Scheduler Buffer Status Register
    type t_dcom_data_scheduler_buffer_status_rd_reg is record
        data_buffer_used  : std_logic_vector(15 downto 0); -- Data Scheduler Buffer Used [Bytes]
        data_buffer_empty : std_logic;  -- Data Scheduler Buffer Empty
        data_buffer_full  : std_logic;  -- Data Scheduler Buffer Full
    end record t_dcom_data_scheduler_buffer_status_rd_reg;

    -- Data Scheduler Data Control Register
    type t_dcom_data_scheduler_data_control_wr_reg is record
        rd_initial_addr_high_dword : std_logic_vector(31 downto 0); -- Data Scheduler Initial Read Address [High Dword]
        rd_initial_addr_low_dword  : std_logic_vector(31 downto 0); -- Data Scheduler Initial Read Address [Low Dword]
        rd_data_length_bytes       : std_logic_vector(31 downto 0); -- Data Scheduler Read Data Length [Bytes]
        rd_start                   : std_logic; -- Data Scheduler Data Read Start
        rd_reset                   : std_logic; -- Data Scheduler Data Read Reset
        rd_auto_restart            : std_logic; -- Data Scheduler Data Read Auto Restart
        data_eep_injection_en      : std_logic; -- Data Scheduler Data EEP Injection Enable
        data_eep_injection_cnt     : std_logic_vector(31 downto 0); -- Data Scheduler Data EEP Injection Counter
    end record t_dcom_data_scheduler_data_control_wr_reg;

    -- Data Scheduler Data Status Register
    type t_dcom_data_scheduler_data_status_rd_reg is record
        rd_busy : std_logic;            -- Data Scheduler Data Read Busy
    end record t_dcom_data_scheduler_data_status_rd_reg;

    -- Data Scheduler IRQ Control Register
    type t_dcom_data_scheduler_irq_control_wr_reg is record
        irq_tx_end_en   : std_logic;    -- Data Scheduler Tx End IRQ Enable
        irq_tx_begin_en : std_logic;    -- Data Scheduler Tx Begin IRQ Enable
    end record t_dcom_data_scheduler_irq_control_wr_reg;

    -- Data Scheduler IRQ Flags Register
    type t_dcom_data_scheduler_irq_flags_rd_reg is record
        irq_tx_end_flag   : std_logic;  -- Data Scheduler Tx End IRQ Flag
        irq_tx_begin_flag : std_logic;  -- Data Scheduler Tx Begin IRQ Flag
    end record t_dcom_data_scheduler_irq_flags_rd_reg;

    -- Data Scheduler IRQ Flags Clear Register
    type t_dcom_data_scheduler_irq_flags_clear_wr_reg is record
        irq_tx_end_flag_clear   : std_logic; -- Data Scheduler Tx End IRQ Flag Clear
        irq_tx_begin_flag_clear : std_logic; -- Data Scheduler Tx Begin IRQ Flag Clear
    end record t_dcom_data_scheduler_irq_flags_clear_wr_reg;

    -- RMAP Device Address Register
    type t_dcom_rmap_dev_addr_wr_reg is record
        rmap_dev_base_addr : std_logic_vector(31 downto 0); -- RMAP Device Base Address
    end record t_dcom_rmap_dev_addr_wr_reg;

    -- RMAP Echoing Mode Config Register
    type t_dcom_rmap_echoing_mode_config_wr_reg is record
        rmap_echoing_mode_enable : std_logic; -- RMAP Echoing Mode Enable
        rmap_echoing_id_enable   : std_logic; -- RMAP Echoing ID Enable
    end record t_dcom_rmap_echoing_mode_config_wr_reg;

    -- RMAP Codec Config Register
    type t_dcom_rmap_codec_config_wr_reg is record
        rmap_target_enable         : std_logic; -- RMAP Target Enable
        rmap_target_logical_addr   : std_logic_vector(7 downto 0); -- RMAP Target Logical Address
        rmap_target_key            : std_logic_vector(7 downto 0); -- RMAP Target Key
        rmap_target_unalignment_en : std_logic; -- RMAP Unalignment Enable
        rmap_target_word_width     : std_logic_vector(2 downto 0); -- RMAP Word Width
    end record t_dcom_rmap_codec_config_wr_reg;

    -- RMAP Codec Status Register
    type t_dcom_rmap_codec_status_rd_reg is record
        rmap_stat_command_received    : std_logic; -- RMAP Status Command Received
        rmap_stat_write_requested     : std_logic; -- RMAP Status Write Requested
        rmap_stat_write_authorized    : std_logic; -- RMAP Status Write Authorized
        rmap_stat_read_requested      : std_logic; -- RMAP Status Read Requested
        rmap_stat_read_authorized     : std_logic; -- RMAP Status Read Authorized
        rmap_stat_reply_sended        : std_logic; -- RMAP Status Reply Sended
        rmap_stat_discarded_package   : std_logic; -- RMAP Status Discarded Package
        rmap_err_early_eop            : std_logic; -- RMAP Error Early EOP
        rmap_err_eep                  : std_logic; -- RMAP Error EEP
        rmap_err_header_crc           : std_logic; -- RMAP Error Header CRC
        rmap_err_unused_packet_type   : std_logic; -- RMAP Error Unused Packet Type
        rmap_err_invalid_command_code : std_logic; -- RMAP Error Invalid Command Code
        rmap_err_too_much_data        : std_logic; -- RMAP Error Too Much Data
        rmap_err_invalid_data_crc     : std_logic; -- RMAP Error Invalid Data CRC
    end record t_dcom_rmap_codec_status_rd_reg;

    -- RMAP Memory Area Config Register
    type t_dcom_rmap_mem_area_config_wr_reg is record
        rmap_mem_area_addr_offset : std_logic_vector(31 downto 0); -- RMAP Memory Area Address Offset
    end record t_dcom_rmap_mem_area_config_wr_reg;

    -- RMAP Memory Area Pointer Register
    type t_dcom_rmap_mem_area_ptr_wr_reg is record
        rmap_mem_area_ptr : std_logic_vector(31 downto 0); -- RMAP Memory Area Pointer
    end record t_dcom_rmap_mem_area_ptr_wr_reg;

    -- RMAP Error Injection Control Register
    type t_domm_rmap_error_injection_control_wr_reg is record
        rmap_errinj_reset   : std_logic; -- Reset RMAP Error
        rmap_errinj_trigger : std_logic; -- Trigger RMAP Error
        rmap_errinj_err_id  : std_logic_vector(7 downto 0); -- Error ID of RMAP Error
        rmap_errinj_value   : std_logic_vector(31 downto 0); -- Value of RMAP Error
        rmap_errinj_repeats : std_logic_vector(15 downto 0); -- Repetitions of RMAP Error
    end record t_domm_rmap_error_injection_control_wr_reg;

    -- Report Device Address Register
    type t_dcom_rprt_dev_addr_wr_reg is record
        rprt_dev_base_addr : std_logic_vector(31 downto 0); -- Report Device Base Address
    end record t_dcom_rprt_dev_addr_wr_reg;

    -- Report IRQ Control Register
    type t_dcom_report_irq_control_wr_reg is record
        irq_rprt_spw_link_connected_en            : std_logic; -- Report SpW Link Connected IRQ Enable
        irq_rprt_spw_link_disconnected_en         : std_logic; -- Report SpW Link Disconnected IRQ Enable
        irq_rprt_spw_err_disconnect_en            : std_logic; -- Report SpW Error Disconnect IRQ Enable
        irq_rprt_spw_err_parity_en                : std_logic; -- Report SpW Error Parity IRQ Enable
        irq_rprt_spw_err_escape_en                : std_logic; -- Report SpW Error Escape IRQ Enable
        irq_rprt_spw_err_credit_en                : std_logic; -- Report SpW Error Credit IRQ Enable
        irq_rprt_rx_timecode_received_en          : std_logic; -- Report Rx Timecode Received IRQ Enable
        irq_rprt_rmap_err_early_eop_en            : std_logic; -- Report Rmap Error Early EOP IRQ Enable
        irq_rprt_rmap_err_eep_en                  : std_logic; -- Report Rmap Error EEP IRQ Enable
        irq_rprt_rmap_err_header_crc_en           : std_logic; -- Report Rmap Error Header CRC IRQ Enable
        irq_rprt_rmap_err_unused_packet_type_en   : std_logic; -- Report Rmap Error Unused Packet Type IRQ Enable
        irq_rprt_rmap_err_invalid_command_code_en : std_logic; -- Report Rmap Error Invalid Command Code IRQ Enable
        irq_rprt_rmap_err_too_much_data_en        : std_logic; -- Report Rmap Error Too Much Data IRQ Enable
        irq_rprt_rmap_err_invalid_data_crc_en     : std_logic; -- Report Rmap Error Invalid Data Crc IRQ Enable
    end record t_dcom_report_irq_control_wr_reg;

    -- Report IRQ Flags Register
    type t_dcom_report_irq_flags_rd_reg is record
        irq_rprt_spw_link_connected_flag            : std_logic; -- Report SpW Link Connected IRQ Flag
        irq_rprt_spw_link_disconnected_flag         : std_logic; -- Report SpW Link Disconnected IRQ Flag
        irq_rprt_spw_err_disconnect_flag            : std_logic; -- Report SpW Error Disconnect IRQ Flag
        irq_rprt_spw_err_parity_flag                : std_logic; -- Report SpW Error Parity IRQ Flag
        irq_rprt_spw_err_escape_flag                : std_logic; -- Report SpW Error Escape IRQ Flag
        irq_rprt_spw_err_credit_flag                : std_logic; -- Report SpW Error Credit IRQ Flag
        irq_rprt_rx_timecode_received_flag          : std_logic; -- Report Rx Timecode Received IRQ Flag
        irq_rprt_rmap_err_early_eop_flag            : std_logic; -- Report Rmap Error Early EOP IRQ Flag
        irq_rprt_rmap_err_eep_flag                  : std_logic; -- Report Rmap Error EEP IRQ Flag
        irq_rprt_rmap_err_header_crc_flag           : std_logic; -- Report Rmap Error Header CRC IRQ Flag
        irq_rprt_rmap_err_unused_packet_type_flag   : std_logic; -- Report Rmap Error Unused Packet Type IRQ Flag
        irq_rprt_rmap_err_invalid_command_code_flag : std_logic; -- Report Rmap Error Invalid Command Code IRQ Flag
        irq_rprt_rmap_err_too_much_data_flag        : std_logic; -- Report Rmap Error Too Much Data IRQ Flag
        irq_rprt_rmap_err_invalid_data_crc_flag     : std_logic; -- Report Rmap Error Invalid Data Crc IRQ Flag
    end record t_dcom_report_irq_flags_rd_reg;

    -- Report IRQ Flags Clear Register
    type t_dcom_report_irq_flags_clear_wr_reg is record
        irq_rprt_spw_link_connected_flag_clear            : std_logic; -- Report SpW Link Connected IRQ Flag Clear
        irq_rprt_spw_link_disconnected_flag_clear         : std_logic; -- Report SpW Link Disconnected IRQ Flag Clear
        irq_rprt_spw_err_disconnect_flag_clear            : std_logic; -- Report SpW Error Disconnect IRQ Flag Clear
        irq_rprt_spw_err_parity_flag_clear                : std_logic; -- Report SpW Error Parity IRQ Flag Clear
        irq_rprt_spw_err_escape_flag_clear                : std_logic; -- Report SpW Error Escape IRQ Flag Clear
        irq_rprt_spw_err_credit_flag_clear                : std_logic; -- Report SpW Error Credit IRQ Flag Clear
        irq_rprt_rx_timecode_received_flag_clear          : std_logic; -- Report Rx Timecode Received IRQ Flag Clear
        irq_rprt_rmap_err_early_eop_flag_clear            : std_logic; -- Report Rmap Error Early EOP IRQ Flag Clear
        irq_rprt_rmap_err_eep_flag_clear                  : std_logic; -- Report Rmap Error EEP IRQ Flag Clear
        irq_rprt_rmap_err_header_crc_flag_clear           : std_logic; -- Report Rmap Error Header CRC IRQ Flag Clear
        irq_rprt_rmap_err_unused_packet_type_flag_clear   : std_logic; -- Report Rmap Error Unused Packet Type IRQ Flag Clear
        irq_rprt_rmap_err_invalid_command_code_flag_clear : std_logic; -- Report Rmap Error Invalid Command Code IRQ Flag Clear
        irq_rprt_rmap_err_too_much_data_flag_clear        : std_logic; -- Report Rmap Error Too Much Data IRQ Flag Clear
        irq_rprt_rmap_err_invalid_data_crc_flag_clear     : std_logic; -- Report Rmap Error Invalid Data Crc IRQ Flag Clear
    end record t_dcom_report_irq_flags_clear_wr_reg;

    -- Avalon MM Types

    -- Avalon MM Read/Write Registers
    type t_dcom_write_registers is record
        dcom_dev_addr_reg                  : t_dcom_dcom_dev_addr_wr_reg; -- Dcom Device Address Register
        dcom_irq_control_reg               : t_dcom_dcom_irq_control_wr_reg; -- Dcom IRQ Control Register
        spw_dev_addr_reg                   : t_dcom_spw_dev_addr_wr_reg; -- SpaceWire Device Address Register
        spw_link_config_reg                : t_dcom_spw_link_config_wr_reg; -- SpaceWire Link Config Register
        spw_timecode_control_reg           : t_dcom_spw_timecode_control_wr_reg; -- SpaceWire Timecode Control Register
        spw_codec_errinj_control_reg       : t_domm_spw_codec_errinj_control_wr_reg; -- SpaceWire Codec Error Injection Control Register
        data_scheduler_dev_addr_reg        : t_dcom_data_scheduler_dev_addr_wr_reg; -- Data Scheduler Device Address Register
        data_scheduler_tmr_control_reg     : t_dcom_data_scheduler_tmr_control_wr_reg; -- Data Scheduler Timer Control Register
        data_scheduler_tmr_config_reg      : t_dcom_data_scheduler_tmr_config_wr_reg; -- Data Scheduler Timer Config Register
        data_scheduler_pkt_config_reg      : t_dcom_data_scheduler_pkt_config_wr_reg; -- Data Scheduler Packet Config Register
        data_scheduler_data_control_reg    : t_dcom_data_scheduler_data_control_wr_reg; -- Data Scheduler Data Control Register
        data_scheduler_irq_control_reg     : t_dcom_data_scheduler_irq_control_wr_reg; -- Data Scheduler IRQ Control Register
        data_scheduler_irq_flags_clear_reg : t_dcom_data_scheduler_irq_flags_clear_wr_reg; -- Data Scheduler IRQ Flags Clear Register
        rmap_dev_addr_reg                  : t_dcom_rmap_dev_addr_wr_reg; -- RMAP Device Address Register
        rmap_echoing_mode_config_reg       : t_dcom_rmap_echoing_mode_config_wr_reg; -- RMAP Echoing Mode Config Register
        rmap_codec_config_reg              : t_dcom_rmap_codec_config_wr_reg; -- RMAP Codec Config Register
        rmap_mem_area_config_reg           : t_dcom_rmap_mem_area_config_wr_reg; -- RMAP Memory Area Config Register
        rmap_mem_area_ptr_reg              : t_dcom_rmap_mem_area_ptr_wr_reg; -- RMAP Memory Area Pointer Register
        rmap_error_injection_control_reg   : t_domm_rmap_error_injection_control_wr_reg; -- RMAP Error Injection Control Register
        rprt_dev_addr_reg                  : t_dcom_rprt_dev_addr_wr_reg; -- Report Device Address Register
        report_irq_control_reg             : t_dcom_report_irq_control_wr_reg; -- Report IRQ Control Register
        report_irq_flags_clear_reg         : t_dcom_report_irq_flags_clear_wr_reg; -- Report IRQ Flags Clear Register
    end record t_dcom_write_registers;

    -- Avalon MM Read-Only Registers
    type t_dcom_read_registers is record
        spw_link_status_reg              : t_dcom_spw_link_status_rd_reg; -- SpaceWire Link Status Register
        spw_timecode_status_reg          : t_dcom_spw_timecode_status_rd_reg; -- SpaceWire Timecode Status Register
        spw_codec_errinj_status_reg      : t_domm_spw_codec_errinj_status_rd_reg; -- SpaceWire Codec Error Injection Status Register
        data_scheduler_tmr_status_reg    : t_dcom_data_scheduler_tmr_status_rd_reg; -- Data Scheduler Timer Status Register
        data_scheduler_buffer_status_reg : t_dcom_data_scheduler_buffer_status_rd_reg; -- Data Scheduler Buffer Status Register
        data_scheduler_data_status_reg   : t_dcom_data_scheduler_data_status_rd_reg; -- Data Scheduler Data Status Register
        data_scheduler_irq_flags_reg     : t_dcom_data_scheduler_irq_flags_rd_reg; -- Data Scheduler IRQ Flags Register
        rmap_codec_status_reg            : t_dcom_rmap_codec_status_rd_reg; -- RMAP Codec Status Register
        report_irq_flags_reg             : t_dcom_report_irq_flags_rd_reg; -- Report IRQ Flags Register
    end record t_dcom_read_registers;

end package avalon_mm_dcom_registers_pkg;

package body avalon_mm_dcom_registers_pkg is

end package body avalon_mm_dcom_registers_pkg;
