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
use work.uart_avm_data_pkg.all;

entity uart_module_top is
	port(
		reset_sink_reset_i                : in  std_logic                     := '0'; --          --          reset_sink.reset
		clock_sink_100_clk_i              : in  std_logic                     := '0'; --          --      clock_sink_100.clk
		avalon_slave_uart_address_i       : in  std_logic_vector(7 downto 0)  := (others => '0'); --   avalon_slave_uart.address
		avalon_slave_uart_byteenable_i    : in  std_logic_vector(3 downto 0)  := (others => '0'); --                    .byteenable
		avalon_slave_uart_write_i         : in  std_logic                     := '0'; --          --                    .write
		avalon_slave_uart_writedata_i     : in  std_logic_vector(31 downto 0) := (others => '0'); --                    .writedata
		avalon_slave_uart_read_i          : in  std_logic                     := '0'; --          --                    .read
		avalon_slave_uart_readdata_o      : out std_logic_vector(31 downto 0); --                 --                    .readdata
		avalon_slave_uart_waitrequest_o   : out std_logic; --                                     --                    .waitrequest
		avalon_master_data_readdata_i     : in  std_logic_vector(7 downto 0)  := (others => '0'); --  avalon_master_data.readdata
		avalon_master_data_waitrequest_i  : in  std_logic                     := '0'; --          --                    .waitrequest
		avalon_master_data_address_o      : out std_logic_vector(63 downto 0); --                 --                    .address
		avalon_master_data_read_o         : out std_logic; --                                     --                    .read
		avalon_master_data_write_o        : out std_logic; --                                     --                    .write
		avalon_master_data_writedata_o    : out std_logic_vector(7 downto 0); --                  --                    .writedata
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
	signal s_tx_data_fifo_wrreq  : std_logic;
	signal s_tx_data_fifo_empty  : std_logic;
	signal s_tx_data_fifo_rddata : std_logic_vector(7 downto 0);
	signal s_tx_data_fifo_wrdata : std_logic_vector(7 downto 0);

	-- UART Rx Buffer Signals
	signal s_rx_data_fifo_rdreq  : std_logic;
	signal s_rx_data_fifo_wrreq  : std_logic;
	signal s_rx_data_fifo_full   : std_logic;
	signal s_rx_data_fifo_wrdata : std_logic_vector(7 downto 0);

	-- UART AVM Data Signals
	signal s_avm_data_master_rd_control   : t_uart_avm_data_master_rd_control;
	signal s_avm_data_master_rd_status    : t_uart_avm_data_master_rd_status;
	signal s_avm_slave_rd_control_address : std_logic_vector((c_UART_AVM_DATA_ADRESS_SIZE - 1) downto 0);
	signal s_avm_data_master_wr_control   : t_uart_avm_data_master_wr_control;
	signal s_avm_data_master_wr_status    : t_uart_avm_data_master_wr_status;
	signal s_avm_slave_wr_control_address : std_logic_vector((c_UART_AVM_DATA_ADRESS_SIZE - 1) downto 0);

	-- UART AVM Controller Signals
	signal s_tx_avm_reader_wrreq  : std_logic;
	signal s_rx_avm_writer_rdreq  : std_logic;
	signal s_tx_avm_reader_wrdata : std_logic_vector(7 downto 0);

	-- UART Tx Buffer Write Manager
	signal s_tx_buffer_manager_wrreq  : std_logic;
	signal s_tx_buffer_manager_wrdata : std_logic_vector(7 downto 0);

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

	-- UART Avalon MM Master (AVM) Reader Instantiation
	uart_avm_data_reader_ent_inst : entity work.uart_avm_data_reader_ent
		port map(
			clk_i                             => a_avs_clock,
			rst_i                             => a_reset,
			avm_master_rd_control_i           => s_avm_data_master_rd_control,
			avm_slave_rd_status_i.readdata    => avalon_master_data_readdata_i,
			avm_slave_rd_status_i.waitrequest => avalon_master_data_waitrequest_i,
			avm_master_rd_status_o            => s_avm_data_master_rd_status,
			avm_slave_rd_control_o.address    => s_avm_slave_rd_control_address,
			avm_slave_rd_control_o.read       => avalon_master_data_read_o
		);

	-- UART Tx Avalon MM Master (AVM) Reader Controller Instantiation
	uart_tx_avm_reader_controller_ent_inst : entity work.uart_tx_avm_reader_controller_ent
		port map(
			clk_i                                      => a_avs_clock,
			rst_i                                      => a_reset,
			controller_rd_start_i                      => s_uart_wr_regs.tx_data_control_reg.tx_rd_start,
			controller_rd_reset_i                      => s_uart_wr_regs.tx_data_control_reg.tx_rd_reset,
			controller_rd_initial_addr_i(63 downto 32) => s_uart_wr_regs.tx_data_control_reg.tx_rd_initial_addr_high_dword,
			controller_rd_initial_addr_i(31 downto 0)  => s_uart_wr_regs.tx_data_control_reg.tx_rd_initial_addr_low_dword,
			controller_rd_length_bytes_i               => s_uart_wr_regs.tx_data_control_reg.tx_rd_data_length_bytes,
			controller_wr_busy_i                       => s_uart_rd_regs.rx_data_status_reg.rx_wr_busy,
			avm_master_rd_status_i                     => s_avm_data_master_rd_status,
			tx_buffer_full_i                           => s_uart_rd_regs.tx_buffer_status_reg.tx_full,
			controller_rd_busy_o                       => s_uart_rd_regs.tx_data_status_reg.tx_rd_busy,
			avm_master_rd_control_o                    => s_avm_data_master_rd_control,
			tx_buffer_wrdata_o                         => s_tx_avm_reader_wrdata,
			tx_buffer_wrreq_o                          => s_tx_avm_reader_wrreq
		);

	-- UART Tx Buffer Instantiation
	tx_data_fifo_sc_fifo_inst : entity work.data_fifo_sc_fifo
		port map(
			aclr  => a_reset,
			clock => a_avs_clock,
			data  => s_tx_data_fifo_wrdata,
			rdreq => s_tx_data_fifo_rdreq,
			sclr  => a_reset,
			wrreq => s_tx_data_fifo_wrreq,
			empty => s_tx_data_fifo_empty,
			full  => s_uart_rd_regs.tx_buffer_status_reg.tx_full,
			q     => s_tx_data_fifo_rddata,
			usedw => s_uart_rd_regs.tx_buffer_status_reg.tx_usedw
		);

	-- UART Avalon MM Master (AVM) Writer Instantiation
	uart_avm_data_writer_ent_inst : entity work.uart_avm_data_writer_ent
		port map(
			clk_i                             => a_avs_clock,
			rst_i                             => a_reset,
			avm_master_wr_control_i           => s_avm_data_master_wr_control,
			avm_slave_wr_status_i.waitrequest => avalon_master_data_waitrequest_i,
			avm_master_wr_status_o            => s_avm_data_master_wr_status,
			avm_slave_wr_control_o.address    => s_avm_slave_wr_control_address,
			avm_slave_wr_control_o.write      => avalon_master_data_write_o,
			avm_slave_wr_control_o.writedata  => avalon_master_data_writedata_o
		);

	-- UART Rx Avalon MM Master (AVM) Writer Controller Instantiation
	uart_rx_avm_writer_controller_ent_inst : entity work.uart_rx_avm_writer_controller_ent
		port map(
			clk_i                                      => a_avs_clock,
			rst_i                                      => a_reset,
			controller_wr_start_i                      => s_uart_wr_regs.rx_data_control_reg.rx_wr_start,
			controller_wr_reset_i                      => s_uart_wr_regs.rx_data_control_reg.rx_wr_reset,
			controller_wr_initial_addr_i(63 downto 32) => s_uart_wr_regs.rx_data_control_reg.rx_wr_initial_addr_high_dword,
			controller_wr_initial_addr_i(31 downto 0)  => s_uart_wr_regs.rx_data_control_reg.rx_wr_initial_addr_low_dword,
			controller_wr_length_bytes_i               => s_uart_wr_regs.rx_data_control_reg.rx_wr_data_length_bytes,
			controller_rd_busy_i                       => s_uart_rd_regs.tx_data_status_reg.tx_rd_busy,
			avm_master_wr_status_i                     => s_avm_data_master_wr_status,
			rx_buffer_empty_i                          => s_uart_rd_regs.rx_buffer_status_reg.rx_empty,
			rx_buffer_rddata_i                         => s_uart_rd_regs.rx_buffer_status_reg.rx_rddata,
			controller_wr_busy_o                       => s_uart_rd_regs.rx_data_status_reg.rx_wr_busy,
			avm_master_wr_control_o                    => s_avm_data_master_wr_control,
			rx_buffer_rdreq_o                          => s_rx_avm_writer_rdreq
		);

	-- UART Rx Buffer Instantiation
	rx_data_fifo_sc_fifo_inst : entity work.data_fifo_sc_fifo
		port map(
			aclr  => a_reset,
			clock => a_avs_clock,
			data  => s_rx_data_fifo_wrdata,
			rdreq => s_rx_data_fifo_rdreq,
			sclr  => a_reset,
			wrreq => s_rx_data_fifo_wrreq,
			empty => s_uart_rd_regs.rx_buffer_status_reg.rx_empty,
			full  => s_rx_data_fifo_full,
			q     => s_uart_rd_regs.rx_buffer_status_reg.rx_rddata,
			usedw => s_uart_rd_regs.rx_buffer_status_reg.rx_usedw
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

	-- UART Tx Buffer Write Data Manager
	p_tx_buffer_wrdata_manager : process(a_avs_clock, a_reset) is
	begin
		if (a_reset = '1') then
			s_tx_buffer_manager_wrreq  <= '0';
			s_tx_buffer_manager_wrdata <= (others => '0');
		elsif rising_edge(a_avs_clock) then

			-- check if a write from the avalon slave uart was requested
			if (s_uart_wr_regs.tx_buffer_control_reg.tx_wrreq = '1') then
				-- a write from the avalon slave uart was requested
				-- write avalon slave uart data
				s_tx_buffer_manager_wrreq  <= '1';
				s_tx_buffer_manager_wrdata <= s_uart_wr_regs.tx_buffer_control_reg.tx_wrdata;
			else
				-- a write from the avalon slave uart was not requested
				-- keep the write signals cleared
				s_tx_buffer_manager_wrreq  <= '0';
				s_tx_buffer_manager_wrdata <= (others => '0');
			end if;

		end if;
	end process p_tx_buffer_wrdata_manager;

	-- Signals Assignments --
	-- Uart Avalon Assignments
	avalon_slave_uart_waitrequest_o <= ('1') when (a_reset = '1') else ((s_avalon_mm_read_waitrequest) and (s_avalon_mm_write_waitrequest));

	-- Data Avalon Assignments
	avalon_master_data_address_o <= (s_avm_slave_rd_control_address) or (s_avm_slave_wr_control_address);

	-- Tx Buffer Assignments
	s_tx_data_fifo_wrreq  <= (s_tx_buffer_manager_wrreq) or (s_tx_avm_reader_wrreq);
	s_tx_data_fifo_wrdata <= (s_tx_buffer_manager_wrdata) or (s_tx_avm_reader_wrdata);

	-- Rx Buffer Assignments
	s_rx_data_fifo_rdreq <= (s_uart_wr_regs.rx_buffer_control_reg.rx_rdreq) or (s_rx_avm_writer_rdreq);

end architecture rtl;                   -- of uart_module_top
