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

use work.avalon_mm_pkg.all;
use work.avalon_mm_registers_pkg.all;

entity uart_module_top is
	port(
		reset_sink_reset          : in  std_logic                     := '0'; --          --   reset_sink.reset
		clock_sink_clk            : in  std_logic                     := '0'; --          --   clock_sink.clk
		uart_txd                  : out std_logic; --                                     --  conduit_end.uart_txd_signal
		uart_rxd                  : in  std_logic                     := '0'; --          --             .uart_rxd_signal
		uart_rts                  : in  std_logic                     := '0'; --          --             .uart_rts_signal
		uart_cts                  : out std_logic; --                                     --             .uart_cts_signal
		avalon_slave_address      : in  std_logic_vector(7 downto 0)  := (others => '0'); -- avalon_slave.address
		avalon_slave_read         : in  std_logic                     := '0'; --          --             .read
		avalon_slave_write        : in  std_logic                     := '0'; --          --             .write
		avalon_slave_waitrequest  : out std_logic; --                                     --             .waitrequest
		avalon_slave_writedata    : in  std_logic_vector(31 downto 0) := (others => '0'); --             .writedata
		avalon_slave_readdata     : out std_logic_vector(31 downto 0); --                 --             .readdata
		avalon_master_address     : out std_logic_vector(5 downto 0); --                  -- avalon_master.address
		avalon_master_read        : out std_logic; --                                     --              .read
		avalon_master_write       : out std_logic; --                                     --              .write
		avalon_master_writedata   : out std_logic_vector(15 downto 0); --                 --              .writedata
		avalon_master_readdata    : in  std_logic_vector(15 downto 0) := (others => '0'); --              .readdata
		avalon_master_waitrequest : in  std_logic                     := '0' --           --              .waitrequest
	);
end entity uart_module_top;

architecture rtl of uart_module_top is

	signal s_write_registers : t_write_registers;
	signal s_read_registers  : t_read_registers;

	signal s_avalon_mm_read_waitrequest  : std_logic;
	signal s_avalon_mm_write_waitrequest : std_logic;

	signal s_tx_data_fifo_rdreq  : std_logic;
	signal s_tx_data_fifo_empty  : std_logic;
	signal s_tx_data_fifo_rddata : std_logic_vector(7 downto 0);

	signal s_rx_data_fifo_wrreq  : std_logic;
	signal s_rx_data_fifo_full   : std_logic;
	signal s_rx_data_fifo_wrdata : std_logic_vector(7 downto 0);

begin

	avalon_mm_write_ent_inst : entity work.avalon_mm_write_ent
		port map(
			clk_i                   => clock_sink_clk,
			rst_i                   => reset_sink_reset,
			avalon_mm_i.address     => avalon_slave_address,
			avalon_mm_i.writedata   => avalon_slave_writedata,
			avalon_mm_i.write       => avalon_slave_write,
			avalon_mm_i.byteenable  => (others => '1'),
			avalon_mm_o.waitrequest => s_avalon_mm_write_waitrequest,
			write_registers_o       => s_write_registers
		);

	avalon_mm_read_ent_inst : entity work.avalon_mm_read_ent
		port map(
			clk_i                   => clock_sink_clk,
			rst_i                   => reset_sink_reset,
			avalon_mm_i.address     => avalon_slave_address,
			avalon_mm_i.read        => avalon_slave_read,
			avalon_mm_i.byteenable  => (others => '1'),
			avalon_mm_o.readdata    => avalon_slave_readdata,
			avalon_mm_o.waitrequest => s_avalon_mm_read_waitrequest,
			write_registers_i       => s_write_registers,
			read_registers_i        => s_read_registers
		);

	tx_data_fifo_sc_fifo_inst : entity work.data_fifo_sc_fifo
		port map(
			aclr  => reset_sink_reset,
			clock => clock_sink_clk,
			data  => s_write_registers.uart_tx_wrdata,
			rdreq => s_tx_data_fifo_rdreq,
			sclr  => reset_sink_reset,
			wrreq => s_write_registers.uart_tx_wrreq,
			empty => s_tx_data_fifo_empty,
			full  => s_read_registers.uart_tx_full,
			q     => s_tx_data_fifo_rddata,
			usedw => s_read_registers.uart_tx_usedw
		);

	rx_data_fifo_sc_fifo_inst : entity work.data_fifo_sc_fifo
		port map(
			aclr  => reset_sink_reset,
			clock => clock_sink_clk,
			data  => s_rx_data_fifo_wrdata,
			rdreq => s_write_registers.uart_rx_rdreq,
			sclr  => reset_sink_reset,
			wrreq => s_rx_data_fifo_wrreq,
			empty => s_read_registers.uart_rx_empty,
			full  => s_rx_data_fifo_full,
			q     => s_read_registers.uart_rx_rddata,
			usedw => s_read_registers.uart_rx_usedw
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
	uart_txd <= '1';

	--	uart_rx_ent_inst : entity work.uart_rx_ent
	--		port map(
	--			clk_i                 => clock_sink_clk,
	--			rst_i                 => reset_sink_reset,
	--			uart_rx_i             => uart_rxd,
	--			uart_rx_fifo_full_i   => s_rx_data_fifo_full,
	--			uart_rx_fifo_wrreq_o  => s_rx_data_fifo_wrreq,
	--			uart_rx_fifo_wrdata_o => s_rx_data_fifo_wrdata
	--		);

	uart_cts                 <= ('1') when (s_rx_data_fifo_full = '0') else ('0');
	avalon_slave_waitrequest <= ('1') when (reset_sink_reset = '1') else ((s_avalon_mm_read_waitrequest) and (s_avalon_mm_write_waitrequest));

	p_avalon_master_controller : process(clock_sink_clk, reset_sink_reset) is
		variable v_cnt      : natural   := 0;
		variable v_tx_ready : std_logic := '0';
		variable v_rx_ready : std_logic := '0';
	begin
		if (reset_sink_reset = '1') then
			avalon_master_address   <= (others => '0');
			avalon_master_read      <= '0';
			avalon_master_write     <= '0';
			avalon_master_writedata <= (others => '0');
			s_rx_data_fifo_wrdata <= (others => '0');
			s_tx_data_fifo_rdreq                 <= '0';
			s_rx_data_fifo_wrreq  <= '0';
			v_cnt                   := 0;
			v_tx_ready              := '0';
			v_tx_ready              := '0';
		elsif rising_edge(clock_sink_clk) then

			avalon_master_address   <= (others => '0');
			avalon_master_read      <= '0';
			avalon_master_write     <= '0';
			avalon_master_writedata <= (others => '0');
			s_rx_data_fifo_wrdata <= (others => '0');
			s_tx_data_fifo_rdreq                 <= '0';
			s_rx_data_fifo_wrreq  <= '0';

			case (v_cnt) is

				-- get status
				when 10 =>
					avalon_master_address <= std_logic_vector(to_unsigned(8, avalon_master_address'length)); -- status reg
					avalon_master_read    <= '1';

				when 11 =>
					if (avalon_master_waitrequest = '1') then
					avalon_master_address <= std_logic_vector(to_unsigned(8, avalon_master_address'length)); -- status reg
					avalon_master_read    <= '1';
					v_cnt                 := 10;
						v_tx_ready := '0';
						v_rx_ready := '0';
					else
						v_tx_ready := avalon_master_readdata(6);
						v_rx_ready := avalon_master_readdata(7);
						if ((v_tx_ready = '1') and (s_tx_data_fifo_empty = '0')) then
							v_cnt := 20;
						elsif ((v_rx_ready = '1') and (s_rx_data_fifo_full = '0')) then
							v_cnt := 30;
						else
							v_cnt := 0;
						end if;
					end if;

				-- tx data
				when 25 =>
					avalon_master_address                <= std_logic_vector(to_unsigned(4, avalon_master_address'length)); -- tx data reg
					avalon_master_write                  <= '1';
					avalon_master_writedata(15 downto 8) <= x"00";
					avalon_master_writedata(7 downto 0)  <= s_tx_data_fifo_rddata;
					s_tx_data_fifo_rdreq                 <= '0';

				when 26 =>
										if (avalon_master_waitrequest = '1') then
					avalon_master_address                <= std_logic_vector(to_unsigned(4, avalon_master_address'length)); -- tx data reg
					avalon_master_write                  <= '1';
					avalon_master_writedata(15 downto 8) <= x"00";
					avalon_master_writedata(7 downto 0)  <= s_tx_data_fifo_rddata;
						s_tx_data_fifo_rdreq <= '0';
						v_cnt                := 25;
					else
						s_tx_data_fifo_rdreq <= '1';
						v_cnt                := 0;
					end if;

				-- rx data
				when 35 =>
					avalon_master_address <= std_logic_vector(to_unsigned(0, avalon_master_address'length)); -- rx data reg
					avalon_master_read    <= '1';
					s_rx_data_fifo_wrdata <= (others => '0');
					s_rx_data_fifo_wrreq  <= '0';

				when 36 =>
					if (avalon_master_waitrequest = '1') then
					avalon_master_address <= std_logic_vector(to_unsigned(0, avalon_master_address'length)); -- rx data reg
					avalon_master_read    <= '1';
						s_rx_data_fifo_wrdata <= (others => '0');
						s_rx_data_fifo_wrreq  <= '0';
						v_cnt                 := 35;
					else
						s_rx_data_fifo_wrdata <= avalon_master_readdata;
						s_rx_data_fifo_wrreq  <= '1';
						v_cnt                 := 0;
					end if;

				when others =>
					null;

			end case;

			v_cnt := v_cnt + 1;

		end if;
	end process p_avalon_master_controller;

end architecture rtl;                   -- of uart_module_top
