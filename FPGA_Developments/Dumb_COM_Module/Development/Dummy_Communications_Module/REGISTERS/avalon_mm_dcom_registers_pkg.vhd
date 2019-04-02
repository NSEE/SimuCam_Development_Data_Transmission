library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package avalon_mm_dcom_registers_pkg is

	type t_dcom_spw_link_status_rd_reg is record
		spw_link_running    : std_logic;
		spw_link_connecting : std_logic;
		spw_link_started    : std_logic;
		spw_err_disconnect  : std_logic;
		spw_err_parity      : std_logic;
		spw_err_escape      : std_logic;
		spw_err_credit      : std_logic;
	end record t_dcom_spw_link_status_rd_reg;

	type t_dcom_spw_link_config_wr_reg is record
		spw_lnkcfg_disconnect : std_logic;
		spw_lnkcfg_linkstart  : std_logic;
		spw_lnkcfg_autostart  : std_logic;
		spw_lnkcfg_txdivcnt   : std_logic_vector(7 downto 0);
	end record t_dcom_spw_link_config_wr_reg;

	type t_dcom_spw_timecode_rx_rd_reg is record
		timecode_rx_time     : std_logic_vector(5 downto 0);
		timecode_rx_control  : std_logic_vector(1 downto 0);
		timecode_rx_received : std_logic;
	end record t_dcom_spw_timecode_rx_rd_reg;

	type t_dcom_spw_timecode_tx_rxctrl_wr_reg is record
		timecode_tx_time         : std_logic_vector(5 downto 0);
		timecode_tx_control      : std_logic_vector(1 downto 0);
		timecode_tx_send         : std_logic;
		timecode_rx_received_clr : std_logic;
	end record t_dcom_spw_timecode_tx_rxctrl_wr_reg;

	type t_dcom_data_buffers_status_rd_reg is record
		data_buffer_used  : std_logic_vector(15 downto 0);
		data_buffer_empty : std_logic;
		data_buffer_full  : std_logic;
	end record t_dcom_data_buffers_status_rd_reg;

	type t_dcom_data_controller_config_wr_reg is record
		send_eop : std_logic;
		send_eep : std_logic;
	end record t_dcom_data_controller_config_wr_reg;

	type t_dcom_data_scheduler_timer_config_wr_reg is record
		timer_start_on_sync : std_logic;
	end record t_dcom_data_scheduler_timer_config_wr_reg;

	type t_dcom_data_scheduler_timer_clkdiv_wr_reg is record
		timer_clk_div : std_logic_vector(31 downto 0);
	end record t_dcom_data_scheduler_timer_clkdiv_wr_reg;

	type t_dcom_data_scheduler_timer_status_rd_reg is record
		timer_stopped : std_logic;
		timer_started : std_logic;
		timer_running : std_logic;
		timer_cleared : std_logic;
	end record t_dcom_data_scheduler_timer_status_rd_reg;

	type t_dcom_data_scheduler_timer_time_wr_reg is record
		timer_time : std_logic_vector(31 downto 0);
	end record t_dcom_data_scheduler_timer_time_wr_reg;

	type t_dcom_data_scheduler_timer_control_wr_reg is record
		timer_start : std_logic;
		timer_run   : std_logic;
		timer_stop  : std_logic;
		timer_clear : std_logic;
	end record t_dcom_data_scheduler_timer_control_wr_reg;

	type t_dcom_dcom_irq_control_wr_reg is record
		dcom_tx_end_en     : std_logic;
		dcom_tx_begin_en   : std_logic;
		dcom_global_irq_en : std_logic;
	end record t_dcom_dcom_irq_control_wr_reg;

	type t_dcom_dcom_irq_flags_rd_reg is record
		dcom_tx_end_flag   : std_logic;
		dcom_tx_begin_flag : std_logic;
	end record t_dcom_dcom_irq_flags_rd_reg;

	type t_dcom_dcom_irq_flags_clear_wr_reg is record
		dcom_tx_end_flag_clear   : std_logic;
		dcom_tx_begin_flag_clear : std_logic;
	end record t_dcom_dcom_irq_flags_clear_wr_reg;

	type t_dcom_write_registers is record
		spw_link_config_reg              : t_dcom_spw_link_config_wr_reg;
		spw_timecode_tx_rxctrl_reg       : t_dcom_spw_timecode_tx_rxctrl_wr_reg;
		data_controller_config_reg       : t_dcom_data_controller_config_wr_reg;
		data_scheduler_timer_config_reg  : t_dcom_data_scheduler_timer_config_wr_reg;
		data_scheduler_timer_clkdiv_reg  : t_dcom_data_scheduler_timer_clkdiv_wr_reg;
		data_scheduler_timer_time_reg    : t_dcom_data_scheduler_timer_time_wr_reg;
		data_scheduler_timer_control_reg : t_dcom_data_scheduler_timer_control_wr_reg;
		dcom_irq_control_reg             : t_dcom_dcom_irq_control_wr_reg;
		dcom_irq_flags_clear_reg         : t_dcom_dcom_irq_flags_clear_wr_reg;
	end record t_dcom_write_registers;

	type t_dcom_read_registers is record
		spw_link_status_reg             : t_dcom_spw_link_status_rd_reg;
		spw_timecode_rx_reg             : t_dcom_spw_timecode_rx_rd_reg;
		data_buffers_status_reg         : t_dcom_data_buffers_status_rd_reg;
		data_scheduler_timer_status_reg : t_dcom_data_scheduler_timer_status_rd_reg;
		dcom_irq_flags_reg              : t_dcom_dcom_irq_flags_rd_reg;
	end record t_dcom_read_registers;

end package avalon_mm_dcom_registers_pkg;

package body avalon_mm_dcom_registers_pkg is

end package body avalon_mm_dcom_registers_pkg;
