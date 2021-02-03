library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package comm_irq_manager_pkg is

	type t_ftdi_dcom_rprt_manager_watches is record
		rprt_spw_link_running              : std_logic;
		rprt_spw_err_disconnect            : std_logic;
		rprt_spw_err_parity                : std_logic;
		rprt_spw_err_escape                : std_logic;
		rprt_spw_err_credit                : std_logic;
		rprt_rx_timecode_received          : std_logic;
		rprt_rmap_err_early_eop            : std_logic;
		rprt_rmap_err_eep                  : std_logic;
		rprt_rmap_err_header_crc           : std_logic;
		rprt_rmap_err_unused_packet_type   : std_logic;
		rprt_rmap_err_invalid_command_code : std_logic;
		rprt_rmap_err_too_much_data        : std_logic;
		rprt_rmap_err_invalid_data_crc     : std_logic;
	end record t_ftdi_dcom_rprt_manager_watches;

	--	type t_ftdi_dcom_rprt_manager_contexts is record
	--		dummy : std_logic;
	--	end record t_ftdi_dcom_rprt_manager_contexts;

	type t_ftdi_dcom_rprt_manager_flags is record
		rprt_spw_link_connected            : std_logic;
		rprt_spw_link_disconnected         : std_logic;
		rprt_spw_err_disconnect            : std_logic;
		rprt_spw_err_parity                : std_logic;
		rprt_spw_err_escape                : std_logic;
		rprt_spw_err_credit                : std_logic;
		rprt_rx_timecode_received          : std_logic;
		rprt_rmap_err_early_eop            : std_logic;
		rprt_rmap_err_eep                  : std_logic;
		rprt_rmap_err_header_crc           : std_logic;
		rprt_rmap_err_unused_packet_type   : std_logic;
		rprt_rmap_err_invalid_command_code : std_logic;
		rprt_rmap_err_too_much_data        : std_logic;
		rprt_rmap_err_invalid_data_crc     : std_logic;
	end record t_ftdi_dcom_rprt_manager_flags;

	constant c_DCOM_RPRT_IRQ_MANAGER_WATCHES_RST : t_ftdi_dcom_rprt_manager_watches := (
		rprt_spw_link_running              => '0',
		rprt_spw_err_disconnect            => '0',
		rprt_spw_err_parity                => '0',
		rprt_spw_err_escape                => '0',
		rprt_spw_err_credit                => '0',
		rprt_rx_timecode_received          => '0',
		rprt_rmap_err_early_eop            => '0',
		rprt_rmap_err_eep                  => '0',
		rprt_rmap_err_header_crc           => '0',
		rprt_rmap_err_unused_packet_type   => '0',
		rprt_rmap_err_invalid_command_code => '0',
		rprt_rmap_err_too_much_data        => '0',
		rprt_rmap_err_invalid_data_crc     => '0'
	);

	--	constant c_DCOM_ERRS_IRQ_MANAGER_CONTEXTS_RST : t_ftdi_dcom_rprt_manager_contexts := (
	--		dummy => '0'
	--	);

	constant c_DCOM_RPRT_IRQ_MANAGER_FLAGS_RST : t_ftdi_dcom_rprt_manager_flags := (
		rprt_spw_link_connected            => '0',
		rprt_spw_link_disconnected         => '0',
		rprt_spw_err_disconnect            => '0',
		rprt_spw_err_parity                => '0',
		rprt_spw_err_escape                => '0',
		rprt_spw_err_credit                => '0',
		rprt_rx_timecode_received          => '0',
		rprt_rmap_err_early_eop            => '0',
		rprt_rmap_err_eep                  => '0',
		rprt_rmap_err_header_crc           => '0',
		rprt_rmap_err_unused_packet_type   => '0',
		rprt_rmap_err_invalid_command_code => '0',
		rprt_rmap_err_too_much_data        => '0',
		rprt_rmap_err_invalid_data_crc     => '0'
	);
end package comm_irq_manager_pkg;

package body comm_irq_manager_pkg is

end package body comm_irq_manager_pkg;
