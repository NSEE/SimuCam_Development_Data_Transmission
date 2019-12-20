-- (C) 2001-2018 Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions and other 
-- software and tools, and its AMPP partner logic functions, and any output 
-- files from any of the foregoing (including device programming or simulation 
-- files), and any associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License Subscription 
-- Agreement, Intel FPGA IP License Agreement, or other applicable 
-- license agreement, including, without limitation, that your use is for the 
-- sole purpose of programming logic devices manufactured by Intel and sold by 
-- Intel or its authorized distributors.  Please refer to the applicable 
-- agreement for further details.


-- $Id: //acds/main/ip/sopc/components/verification/altera_tristate_conduit_bfm/altera_tristate_conduit_bfm.sv.terp#7 $
-- $Revision: #7 $
-- $Date: 2010/08/05 $
-- $Author: klong $
-------------------------------------------------------------------------------
-- =head1 NAME
-- altera_conduit_bfm
-- =head1 SYNOPSIS
-- Bus Functional Model (BFM) for a Standard Conduit BFM
-------------------------------------------------------------------------------
-- =head1 DESCRIPTION
-- This is a Bus Functional Model (BFM) for a Standard Conduit Master.
-- This BFM sampled the input/bidirection port value or driving user's value to 
-- output ports when user call the API.  
-- This BFM's HDL is been generated through terp file in Qsys/SOPC Builder.
-- Generation parameters:
-- output_name:                  altera_conduit_bfm_0002
-- role:width:direction:         uart_cts_signal:1:input,uart_rts_signal:1:output,uart_rxd_signal:1:output,uart_txd_signal:1:input
-- clocked                       1
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.altera_conduit_bfm_0002_vhdl_pkg.all;

entity altera_conduit_bfm_0002 is
   port (
      clk                   : in    std_logic;
      reset                 : in    std_logic;
      sig_uart_cts_signal   : in    std_logic_vector(0 downto 0);
      sig_uart_rts_signal   : out   std_logic_vector(0 downto 0);
      sig_uart_rxd_signal   : out   std_logic_vector(0 downto 0);
      sig_uart_txd_signal   : in    std_logic_vector(0 downto 0)
   );
end altera_conduit_bfm_0002;

architecture altera_conduit_bfm_0002_arch of altera_conduit_bfm_0002 is 

   begin

      process (clk) begin
      if (clk'event and clk = '1') then
         sig_uart_cts_signal_in <= sig_uart_cts_signal;
         sig_uart_rts_signal   <= out_trans.sig_uart_rts_signal_out after 1 ps;
         sig_uart_rxd_signal   <= out_trans.sig_uart_rxd_signal_out after 1 ps;
         sig_uart_txd_signal_in <= sig_uart_txd_signal;
         reset_in              <= reset;
      end if;
      end process;

end altera_conduit_bfm_0002_arch;

