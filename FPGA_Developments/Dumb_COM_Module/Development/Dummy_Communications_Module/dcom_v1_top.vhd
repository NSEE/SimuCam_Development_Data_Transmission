-- dcom_v1_top.vhd

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

entity dcom_v1_top is
	port (
		reset_sink_reset                     : in  std_logic                     := '0';             --               reset_sink.reset
		data_in                              : in  std_logic                     := '0';             --          spw_conduit_end.data_in_signal
		data_out                             : out std_logic;                                        --                         .data_out_signal
		strobe_in                            : in  std_logic                     := '0';             --                         .strobe_in_signal
		strobe_out                           : out std_logic;                                        --                         .strobe_out_signal
		sync_channel                         : in  std_logic                     := '0';             --         sync_conduit_end.sync_channel_signal
		clock_sink_100_clk                   : in  std_logic                     := '0';             --           clock_sink_100.clk
		clock_sink_200_clk                   : in  std_logic                     := '0';             --           clock_sink_200.clk
		avalon_slave_data_buffer_address     : in  std_logic_vector(9 downto 0)  := (others => '0'); -- avalon_slave_data_buffer.address
		avalon_slave_data_buffer_write       : in  std_logic                     := '0';             --                         .write
		avalon_slave_data_buffer_writedata   : in  std_logic_vector(63 downto 0) := (others => '0'); --                         .writedata
		avalon_slave_data_buffer_waitrequest : out std_logic;                                        --                         .waitrequest
		avalon_slave_dcom_address            : in  std_logic_vector(7 downto 0)  := (others => '0'); --        avalon_slave_dcom.address
		avalon_slave_dcom_write              : in  std_logic                     := '0';             --                         .write
		avalon_slave_dcom_read               : in  std_logic                     := '0';             --                         .read
		avalon_slave_dcom_readdata           : out std_logic_vector(31 downto 0);                    --                         .readdata
		avalon_slave_dcom_writedata          : in  std_logic_vector(31 downto 0) := (others => '0'); --                         .writedata
		avalon_slave_dcom_waitrequest        : out std_logic;                                        --                         .waitrequest
		tx_interrupt_sender_irq              : out std_logic                                         --      tx_interrupt_sender.irq
	);
end entity dcom_v1_top;

architecture rtl of dcom_v1_top is
begin

	-- TODO: Auto-generated HDL template

	data_out <= '0';

	strobe_out <= '0';

	avalon_slave_data_buffer_waitrequest <= '0';

	avalon_slave_dcom_readdata <= "00000000000000000000000000000000";

	avalon_slave_dcom_waitrequest <= '0';

	tx_interrupt_sender_irq <= '0';

end architecture rtl; -- of dcom_v1_top
