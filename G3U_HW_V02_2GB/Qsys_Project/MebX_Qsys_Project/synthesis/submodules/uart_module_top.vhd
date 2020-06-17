-- uart_module_top.vhd

-- This file was auto-generated as a prototype implementation of a module
-- created in component editor.  It ties off all outputs to ground and
-- ignores all inputs.  It needs to be edited to make it do something
-- useful.
-- 
-- This file will not be automatically regenerated.  You should check it in
-- to your version control system if you want to keep it.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.avalon_mm_uart_pkg.all;
use work.avalon_mm_uart_registers_pkg.all;

entity uart_module_top is
	port(
		reset_sink_reset_i                : in  std_logic                     := '0'; --          --          reset_sink.reset
		clock_sink_100_clk_i              : in  std_logic                     := '0'; --          --      clock_sink_100.clk
		--		uart_rxd_i                        : in  std_logic                     := '0'; --          --         conduit_end.uart_rxd_signal
		--		uart_rts_i                        : in  std_logic                     := '0'; --          --                    .uart_rts_signal
		--		uart_txd_o                        : out std_logic; --                                     --                    .uart_txd_signal
		--		uart_cts_o                        : out std_logic; --                                     --                    .uart_cts_signal
		avalon_slave_uart_address_i       : in  std_logic_vector(7 downto 0)  := (others => '0'); --   avalon_slave_uart.address
		avalon_slave_uart_byteenable_i    : in  std_logic_vector(3 downto 0)  := (others => '0'); --                    .byteenable
		avalon_slave_uart_write_i         : in  std_logic                     := '0'; --          --                    .write
		avalon_slave_uart_writedata_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --                    .writedata
		avalon_slave_uart_read_i          : in  std_logic                     := '0'; --          --                    .read
		avalon_slave_uart_readdata_o      : out std_logic_vector(31 downto 0); --                 --                    .readdata
		avalon_slave_uart_waitrequest_o   : out std_logic; --                                     --                    .waitrequest
		avalon_master_rs232_readdata_i    : in  std_logic_vector(15 downto 0) := (others => '0'); -- avalon_master_rs232.readdata
		avalon_master_rs232_waitrequest_i : in  std_logic                     := '0'; --          --                    .waitrequest
		avalon_master_rs232_address_o     : out std_logic_vector(5 downto 0); --                  --                    .address
		avalon_master_rs232_write_o       : out std_logic; --                                     --                    .write
		avalon_master_rs232_writedata_o   : out std_logic_vector(15 downto 0); --                 --                    .writedata
		avalon_master_rs232_read_o        : out std_logic ---                                     --                    .read
	);
end entity uart_module_top;

architecture rtl of uart_module_top is

	-- Alias --

	-- Common Ports Alias
	alias a_avs_clock is clock_sink_100_clk_i;
	alias a_reset is reset_sink_reset_i;

	-- Signals --

	-- UART Avalon MM Read Signals
	signal s_avalon_mm_read_waitrequest : std_logic;

	-- UART Avalon MM Write Signals
	signal s_avalon_mm_write_waitrequest : std_logic;

	-- UART Avalon MM Registers Signals
	signal s_uart_wr_regs : t_uart_write_registers;
	signal s_uart_rd_regs : t_uart_read_registers;

	-- UART Tx Buffer Signals
	signal s_tx_data_fifo_rdreq  : std_logic;
	signal s_tx_data_fifo_empty  : std_logic;
	signal s_tx_data_fifo_rddata : std_logic_vector(7 downto 0);

	-- UART Rx Buffer Signals
	signal s_rx_data_fifo_wrreq  : std_logic;
	signal s_rx_data_fifo_full   : std_logic;
	signal s_rx_data_fifo_wrdata : std_logic_vector(7 downto 0);

begin

	-- UART Avalon MM Write Instantiation
	avalon_mm_uart_write_ent_inst : entity work.avalon_mm_uart_write_ent
		port map(
			clk_i                        => a_avs_clock,
			rst_i                        => a_reset,
			avalon_mm_uart_i.address     => avalon_slave_uart_address_i,
			avalon_mm_uart_i.writedata   => avalon_slave_uart_writedata_i,
			avalon_mm_uart_i.write       => avalon_slave_uart_write_i,
			avalon_mm_uart_i.byteenable  => avalon_slave_uart_byteenable_i,
			avalon_mm_uart_o.waitrequest => s_avalon_mm_write_waitrequest,
			uart_write_registers_o       => s_uart_wr_regs
		);

	-- UART Avalon MM Read Instantiation
	avalon_mm_uart_read_ent_inst : entity work.avalon_mm_uart_read_ent
		port map(
			clk_i                        => a_avs_clock,
			rst_i                        => a_reset,
			avalon_mm_uart_i.address     => avalon_slave_uart_address_i,
			avalon_mm_uart_i.read        => avalon_slave_uart_read_i,
			avalon_mm_uart_i.byteenable  => avalon_slave_uart_byteenable_i,
			uart_write_registers_i       => s_uart_wr_regs,
			uart_read_registers_i        => s_uart_rd_regs,
			avalon_mm_uart_o.readdata    => avalon_slave_uart_readdata_o,
			avalon_mm_uart_o.waitrequest => s_avalon_mm_read_waitrequest
		);

	avalon_slave_uart_waitrequest_o <= ('1') when (a_reset = '1') else ((s_avalon_mm_read_waitrequest) and (s_avalon_mm_write_waitrequest));

	-- UART Tx Buffer Instantiation
	tx_data_fifo_sc_fifo_inst : entity work.data_fifo_sc_fifo
		port map(
			aclr  => a_reset,
			clock => a_avs_clock,
			data  => s_uart_wr_regs.uart_tx_buffer_control_reg.uart_tx_wrdata,
			rdreq => s_tx_data_fifo_rdreq,
			sclr  => a_reset,
			wrreq => s_uart_wr_regs.uart_tx_buffer_control_reg.uart_tx_wrreq,
			empty => s_tx_data_fifo_empty,
			full  => s_uart_rd_regs.uart_tx_buffer_status_reg.uart_tx_full,
			q     => s_tx_data_fifo_rddata,
			usedw => s_uart_rd_regs.uart_tx_buffer_status_reg.uart_tx_usedw
		);

	-- UART Rx Buffer Instantiation
	rx_data_fifo_sc_fifo_inst : entity work.data_fifo_sc_fifo
		port map(
			aclr  => a_reset,
			clock => a_avs_clock,
			data  => s_rx_data_fifo_wrdata,
			rdreq => s_uart_wr_regs.uart_rx_buffer_control_reg.uart_rx_rdreq,
			sclr  => a_reset,
			wrreq => s_rx_data_fifo_wrreq,
			empty => s_uart_rd_regs.uart_rx_buffer_status_reg.uart_rx_empty,
			full  => s_rx_data_fifo_full,
			q     => s_uart_rd_regs.uart_rx_buffer_status_reg.uart_rx_rddata,
			usedw => s_uart_rd_regs.uart_rx_buffer_status_reg.uart_rx_usedw
		);

	-- UART AVM RS232 Controller Instantiation
	avm_uart_rs232_controller_ent_inst : entity work.avm_uart_rs232_controller_ent
		port map(
			clk_i                   => a_avs_clock,
			rst_i                   => a_reset,
			tx_data_fifo_empty_i    => s_tx_data_fifo_empty,
			tx_data_fifo_rddata_i   => s_tx_data_fifo_rddata,
			rx_data_fifo_full_i     => s_rx_data_fifo_full,
			avm_rs232_readdata_i    => avalon_master_rs232_readdata_i,
			avm_rs232_waitrequest_i => avalon_master_rs232_waitrequest_i,
			tx_data_fifo_rdreq_o    => s_tx_data_fifo_rdreq,
			rx_data_fifo_wrreq_o    => s_rx_data_fifo_wrreq,
			rx_data_fifo_wrdata_o   => s_rx_data_fifo_wrdata,
			avm_rs232_address_o     => avalon_master_rs232_address_o,
			avm_rs232_write_o       => avalon_master_rs232_write_o,
			avm_rs232_writedata_o   => avalon_master_rs232_writedata_o,
			avm_rs232_read_o        => avalon_master_rs232_read_o
		);

		--	uart_tx_ent_inst : entity work.uart_tx_ent
		--		port map(
		--			clk_i                 => clock_sink_clk,
		--			rst_i                 => reset_sink_reset,
		--			uart_tx_fifo_empty_i  => s_tx_data_fifo_empty,
		--			uart_tx_fifo_rddata_i => s_tx_data_fifo_rddata,
		--			uart_tx_o             => uart_txd,
		--			uart_tx_fifo_rdreq_o  => s_tx_data_fifo_rdreq
		--		);
		--	uart_txd_o <= '1';

		--	uart_rx_ent_inst : entity work.uart_rx_ent
		--		port map(
		--			clk_i                 => clock_sink_clk,
		--			rst_i                 => reset_sink_reset,
		--			uart_rx_i             => uart_rxd,
		--			uart_rx_fifo_full_i   => s_rx_data_fifo_full,
		--			uart_rx_fifo_wrreq_o  => s_rx_data_fifo_wrreq,
		--			uart_rx_fifo_wrdata_o => s_rx_data_fifo_wrdata
		--		);
		--	uart_cts_o                 <= ('1') when (s_rx_data_fifo_full = '0') else ('0');

end architecture rtl;                   -- of uart_module_top
