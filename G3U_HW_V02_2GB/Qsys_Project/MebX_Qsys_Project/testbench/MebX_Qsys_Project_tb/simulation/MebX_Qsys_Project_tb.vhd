-- MebX_Qsys_Project_tb.vhd

-- Generated using ACDS version 18.1 625

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MebX_Qsys_Project_tb is
end entity MebX_Qsys_Project_tb;

architecture rtl of MebX_Qsys_Project_tb is
	component MebX_Qsys_Project is
		port (
			clk50_clk                                  : in  std_logic                     := 'X';             -- clk
			rs232_uart_rxd                             : in  std_logic                     := 'X';             -- rxd
			rs232_uart_txd                             : out std_logic;                                        -- txd
			rs232_uart_cts_n                           : in  std_logic                     := 'X';             -- cts_n
			rs232_uart_rts_n                           : out std_logic;                                        -- rts_n
			rs232_uart_irq_irq                         : out std_logic;                                        -- irq
			rst_reset_n                                : in  std_logic                     := 'X';             -- reset_n
			uart_module_uart_txd_signal                : out std_logic;                                        -- uart_txd_signal
			uart_module_uart_rxd_signal                : in  std_logic                     := 'X';             -- uart_rxd_signal
			uart_module_uart_rts_signal                : in  std_logic                     := 'X';             -- uart_rts_signal
			uart_module_uart_cts_signal                : out std_logic;                                        -- uart_cts_signal
			uart_module_top_0_avalon_slave_address     : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- address
			uart_module_top_0_avalon_slave_read        : in  std_logic                     := 'X';             -- read
			uart_module_top_0_avalon_slave_write       : in  std_logic                     := 'X';             -- write
			uart_module_top_0_avalon_slave_waitrequest : out std_logic;                                        -- waitrequest
			uart_module_top_0_avalon_slave_writedata   : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			uart_module_top_0_avalon_slave_readdata    : out std_logic_vector(31 downto 0)                     -- readdata
		);
	end component MebX_Qsys_Project;

	component altera_avalon_clock_source is
		generic (
			CLOCK_RATE : positive := 10;
			CLOCK_UNIT : positive := 1000000
		);
		port (
			clk : out std_logic   -- clk
		);
	end component altera_avalon_clock_source;

	component altera_conduit_bfm is
		port (
			sig_cts_n : out std_logic_vector(0 downto 0);                    -- cts_n
			sig_rts_n : in  std_logic_vector(0 downto 0) := (others => 'X'); -- rts_n
			sig_rxd   : out std_logic_vector(0 downto 0);                    -- rxd
			sig_txd   : in  std_logic_vector(0 downto 0) := (others => 'X')  -- txd
		);
	end component altera_conduit_bfm;

	component altera_avalon_interrupt_sink_vhdl is
		generic (
			ASSERT_HIGH_IRQ        : integer := 1;
			AV_IRQ_W               : integer := 1;
			ASYNCHRONOUS_INTERRUPT : integer := 0;
			VHDL_ID                : integer := 0
		);
		port (
			clk   : in std_logic                    := 'X';             -- clk
			reset : in std_logic                    := 'X';             -- reset
			irq   : in std_logic_vector(0 downto 0) := (others => 'X')  -- irq
		);
	end component altera_avalon_interrupt_sink_vhdl;

	component altera_avalon_reset_source is
		generic (
			ASSERT_HIGH_RESET    : integer := 1;
			INITIAL_RESET_CYCLES : integer := 0
		);
		port (
			reset : out std_logic;        -- reset_n
			clk   : in  std_logic := 'X'  -- clk
		);
	end component altera_avalon_reset_source;

	component altera_conduit_bfm_0002 is
		port (
			clk                 : in  std_logic                    := 'X';             -- clk
			sig_uart_cts_signal : in  std_logic_vector(0 downto 0) := (others => 'X'); -- uart_cts_signal
			sig_uart_rts_signal : out std_logic_vector(0 downto 0);                    -- uart_rts_signal
			sig_uart_rxd_signal : out std_logic_vector(0 downto 0);                    -- uart_rxd_signal
			sig_uart_txd_signal : in  std_logic_vector(0 downto 0) := (others => 'X'); -- uart_txd_signal
			reset               : in  std_logic                    := 'X'              -- reset
		);
	end component altera_conduit_bfm_0002;

	component altera_avalon_mm_master_bfm_vhdl is
		generic (
			AV_ADDRESS_W               : integer := 32;
			AV_SYMBOL_W                : integer := 8;
			AV_NUMSYMBOLS              : integer := 4;
			AV_BURSTCOUNT_W            : integer := 3;
			AV_READRESPONSE_W          : integer := 8;
			AV_WRITERESPONSE_W         : integer := 8;
			USE_READ                   : integer := 1;
			USE_WRITE                  : integer := 1;
			USE_ADDRESS                : integer := 1;
			USE_BYTE_ENABLE            : integer := 1;
			USE_BURSTCOUNT             : integer := 1;
			USE_READ_DATA              : integer := 1;
			USE_READ_DATA_VALID        : integer := 1;
			USE_WRITE_DATA             : integer := 1;
			USE_BEGIN_TRANSFER         : integer := 0;
			USE_BEGIN_BURST_TRANSFER   : integer := 0;
			USE_WAIT_REQUEST           : integer := 1;
			USE_TRANSACTIONID          : integer := 0;
			USE_WRITERESPONSE          : integer := 0;
			USE_READRESPONSE           : integer := 0;
			USE_CLKEN                  : integer := 0;
			AV_CONSTANT_BURST_BEHAVIOR : integer := 1;
			AV_BURST_LINEWRAP          : integer := 1;
			AV_BURST_BNDR_ONLY         : integer := 1;
			AV_MAX_PENDING_READS       : integer := 0;
			AV_MAX_PENDING_WRITES      : integer := 0;
			AV_FIX_READ_LATENCY        : integer := 1;
			AV_READ_WAIT_TIME          : integer := 1;
			AV_WRITE_WAIT_TIME         : integer := 0;
			REGISTER_WAITREQUEST       : integer := 0;
			AV_REGISTERINCOMINGSIGNALS : integer := 0;
			VHDL_ID                    : integer := 0
		);
		port (
			clk                    : in  std_logic                     := 'X';             -- clk
			reset                  : in  std_logic                     := 'X';             -- reset
			avm_address            : out std_logic_vector(7 downto 0);                     -- address
			avm_readdata           : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			avm_writedata          : out std_logic_vector(31 downto 0);                    -- writedata
			avm_waitrequest        : in  std_logic                     := 'X';             -- waitrequest
			avm_write              : out std_logic;                                        -- write
			avm_read               : out std_logic;                                        -- read
			avm_burstcount         : out std_logic_vector(0 downto 0);                     -- burstcount
			avm_begintransfer      : out std_logic;                                        -- begintransfer
			avm_beginbursttransfer : out std_logic;                                        -- beginbursttransfer
			avm_byteenable         : out std_logic_vector(3 downto 0);                     -- byteenable
			avm_readdatavalid      : in  std_logic                     := 'X';             -- readdatavalid
			avm_arbiterlock        : out std_logic;                                        -- arbiterlock
			avm_lock               : out std_logic;                                        -- lock
			avm_debugaccess        : out std_logic;                                        -- debugaccess
			avm_transactionid      : out std_logic_vector(7 downto 0);                     -- transactionid
			avm_readid             : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- readid
			avm_writeid            : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- writeid
			avm_clken              : out std_logic;                                        -- clken
			avm_response           : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- response
			avm_writeresponsevalid : in  std_logic                     := 'X';             -- writeresponsevalid
			avm_readresponse       : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- readresponse
			avm_writeresponse      : in  std_logic_vector(0 downto 0)  := (others => 'X')  -- writeresponse
		);
	end component altera_avalon_mm_master_bfm_vhdl;

	component altera_irq_mapper is
		port (
			clk           : in  std_logic                    := 'X'; -- clk
			reset         : in  std_logic                    := 'X'; -- reset
			receiver0_irq : in  std_logic                    := 'X'; -- irq
			sender_irq    : out std_logic_vector(0 downto 0)         -- irq
		);
	end component altera_irq_mapper;

	signal mebx_qsys_project_inst_uart_module_top_0_avalon_slave_bfm_m0_readdata    : std_logic_vector(31 downto 0); -- MebX_Qsys_Project_inst:uart_module_top_0_avalon_slave_readdata -> MebX_Qsys_Project_inst_uart_module_top_0_avalon_slave_bfm:avm_readdata
	signal mebx_qsys_project_inst_uart_module_top_0_avalon_slave_bfm_m0_waitrequest : std_logic;                     -- MebX_Qsys_Project_inst:uart_module_top_0_avalon_slave_waitrequest -> MebX_Qsys_Project_inst_uart_module_top_0_avalon_slave_bfm:avm_waitrequest
	signal mebx_qsys_project_inst_uart_module_top_0_avalon_slave_bfm_m0_address     : std_logic_vector(7 downto 0);  -- MebX_Qsys_Project_inst_uart_module_top_0_avalon_slave_bfm:avm_address -> MebX_Qsys_Project_inst:uart_module_top_0_avalon_slave_address
	signal mebx_qsys_project_inst_uart_module_top_0_avalon_slave_bfm_m0_read        : std_logic;                     -- MebX_Qsys_Project_inst_uart_module_top_0_avalon_slave_bfm:avm_read -> MebX_Qsys_Project_inst:uart_module_top_0_avalon_slave_read
	signal mebx_qsys_project_inst_uart_module_top_0_avalon_slave_bfm_m0_writedata   : std_logic_vector(31 downto 0); -- MebX_Qsys_Project_inst_uart_module_top_0_avalon_slave_bfm:avm_writedata -> MebX_Qsys_Project_inst:uart_module_top_0_avalon_slave_writedata
	signal mebx_qsys_project_inst_uart_module_top_0_avalon_slave_bfm_m0_write       : std_logic;                     -- MebX_Qsys_Project_inst_uart_module_top_0_avalon_slave_bfm:avm_write -> MebX_Qsys_Project_inst:uart_module_top_0_avalon_slave_write
	signal mebx_qsys_project_inst_clk50_bfm_clk_clk                                 : std_logic;                     -- MebX_Qsys_Project_inst_clk50_bfm:clk -> [MebX_Qsys_Project_inst:clk50_clk, MebX_Qsys_Project_inst_rs232_uart_irq_bfm:clk, MebX_Qsys_Project_inst_rst_bfm:clk, MebX_Qsys_Project_inst_uart_module_bfm:clk, MebX_Qsys_Project_inst_uart_module_top_0_avalon_slave_bfm:clk, irq_mapper:clk]
	signal mebx_qsys_project_inst_rs232_uart_txd                                    : std_logic;                     -- MebX_Qsys_Project_inst:rs232_uart_txd -> MebX_Qsys_Project_inst_rs232_uart_bfm:sig_txd
	signal mebx_qsys_project_inst_rs232_uart_bfm_conduit_cts_n                      : std_logic_vector(0 downto 0);  -- MebX_Qsys_Project_inst_rs232_uart_bfm:sig_cts_n -> MebX_Qsys_Project_inst:rs232_uart_cts_n
	signal mebx_qsys_project_inst_rs232_uart_rts_n                                  : std_logic;                     -- MebX_Qsys_Project_inst:rs232_uart_rts_n -> MebX_Qsys_Project_inst_rs232_uart_bfm:sig_rts_n
	signal mebx_qsys_project_inst_rs232_uart_bfm_conduit_rxd                        : std_logic_vector(0 downto 0);  -- MebX_Qsys_Project_inst_rs232_uart_bfm:sig_rxd -> MebX_Qsys_Project_inst:rs232_uart_rxd
	signal mebx_qsys_project_inst_uart_module_bfm_conduit_uart_rxd_signal           : std_logic_vector(0 downto 0);  -- MebX_Qsys_Project_inst_uart_module_bfm:sig_uart_rxd_signal -> MebX_Qsys_Project_inst:uart_module_uart_rxd_signal
	signal mebx_qsys_project_inst_uart_module_uart_txd_signal                       : std_logic;                     -- MebX_Qsys_Project_inst:uart_module_uart_txd_signal -> MebX_Qsys_Project_inst_uart_module_bfm:sig_uart_txd_signal
	signal mebx_qsys_project_inst_uart_module_uart_cts_signal                       : std_logic;                     -- MebX_Qsys_Project_inst:uart_module_uart_cts_signal -> MebX_Qsys_Project_inst_uart_module_bfm:sig_uart_cts_signal
	signal mebx_qsys_project_inst_uart_module_bfm_conduit_uart_rts_signal           : std_logic_vector(0 downto 0);  -- MebX_Qsys_Project_inst_uart_module_bfm:sig_uart_rts_signal -> MebX_Qsys_Project_inst:uart_module_uart_rts_signal
	signal mebx_qsys_project_inst_rst_bfm_reset_reset                               : std_logic;                     -- MebX_Qsys_Project_inst_rst_bfm:reset -> [MebX_Qsys_Project_inst:rst_reset_n, mebx_qsys_project_inst_rst_bfm_reset_reset:in]
	signal irq_mapper_receiver0_irq                                                 : std_logic;                     -- MebX_Qsys_Project_inst:rs232_uart_irq_irq -> irq_mapper:receiver0_irq
	signal mebx_qsys_project_inst_rs232_uart_irq_bfm_irq_irq                        : std_logic_vector(0 downto 0);  -- irq_mapper:sender_irq -> MebX_Qsys_Project_inst_rs232_uart_irq_bfm:irq
	signal mebx_qsys_project_inst_rst_bfm_reset_reset_ports_inv                     : std_logic;                     -- mebx_qsys_project_inst_rst_bfm_reset_reset:inv -> [MebX_Qsys_Project_inst_rs232_uart_irq_bfm:reset, MebX_Qsys_Project_inst_uart_module_top_0_avalon_slave_bfm:reset, irq_mapper:reset]

begin

	mebx_qsys_project_inst : component MebX_Qsys_Project
		port map (
			clk50_clk                                  => mebx_qsys_project_inst_clk50_bfm_clk_clk,                                 --                          clk50.clk
			rs232_uart_rxd                             => mebx_qsys_project_inst_rs232_uart_bfm_conduit_rxd(0),                     --                     rs232_uart.rxd
			rs232_uart_txd                             => mebx_qsys_project_inst_rs232_uart_txd,                                    --                               .txd
			rs232_uart_cts_n                           => mebx_qsys_project_inst_rs232_uart_bfm_conduit_cts_n(0),                   --                               .cts_n
			rs232_uart_rts_n                           => mebx_qsys_project_inst_rs232_uart_rts_n,                                  --                               .rts_n
			rs232_uart_irq_irq                         => irq_mapper_receiver0_irq,                                                 --                 rs232_uart_irq.irq
			rst_reset_n                                => mebx_qsys_project_inst_rst_bfm_reset_reset,                               --                            rst.reset_n
			uart_module_uart_txd_signal                => mebx_qsys_project_inst_uart_module_uart_txd_signal,                       --                    uart_module.uart_txd_signal
			uart_module_uart_rxd_signal                => mebx_qsys_project_inst_uart_module_bfm_conduit_uart_rxd_signal(0),        --                               .uart_rxd_signal
			uart_module_uart_rts_signal                => mebx_qsys_project_inst_uart_module_bfm_conduit_uart_rts_signal(0),        --                               .uart_rts_signal
			uart_module_uart_cts_signal                => mebx_qsys_project_inst_uart_module_uart_cts_signal,                       --                               .uart_cts_signal
			uart_module_top_0_avalon_slave_address     => mebx_qsys_project_inst_uart_module_top_0_avalon_slave_bfm_m0_address,     -- uart_module_top_0_avalon_slave.address
			uart_module_top_0_avalon_slave_read        => mebx_qsys_project_inst_uart_module_top_0_avalon_slave_bfm_m0_read,        --                               .read
			uart_module_top_0_avalon_slave_write       => mebx_qsys_project_inst_uart_module_top_0_avalon_slave_bfm_m0_write,       --                               .write
			uart_module_top_0_avalon_slave_waitrequest => mebx_qsys_project_inst_uart_module_top_0_avalon_slave_bfm_m0_waitrequest, --                               .waitrequest
			uart_module_top_0_avalon_slave_writedata   => mebx_qsys_project_inst_uart_module_top_0_avalon_slave_bfm_m0_writedata,   --                               .writedata
			uart_module_top_0_avalon_slave_readdata    => mebx_qsys_project_inst_uart_module_top_0_avalon_slave_bfm_m0_readdata     --                               .readdata
		);

	mebx_qsys_project_inst_clk50_bfm : component altera_avalon_clock_source
		generic map (
			CLOCK_RATE => 50000000,
			CLOCK_UNIT => 1
		)
		port map (
			clk => mebx_qsys_project_inst_clk50_bfm_clk_clk  -- clk.clk
		);

	mebx_qsys_project_inst_rs232_uart_bfm : component altera_conduit_bfm
		port map (
			sig_cts_n    => mebx_qsys_project_inst_rs232_uart_bfm_conduit_cts_n, -- conduit.cts_n
			sig_rts_n(0) => mebx_qsys_project_inst_rs232_uart_rts_n,             --        .rts_n
			sig_rxd      => mebx_qsys_project_inst_rs232_uart_bfm_conduit_rxd,   --        .rxd
			sig_txd(0)   => mebx_qsys_project_inst_rs232_uart_txd                --        .txd
		);

	mebx_qsys_project_inst_rs232_uart_irq_bfm : component altera_avalon_interrupt_sink_vhdl
		generic map (
			ASSERT_HIGH_IRQ        => 1,
			AV_IRQ_W               => 1,
			ASYNCHRONOUS_INTERRUPT => 0,
			VHDL_ID                => 0
		)
		port map (
			clk   => mebx_qsys_project_inst_clk50_bfm_clk_clk,             --       clock_reset.clk
			reset => mebx_qsys_project_inst_rst_bfm_reset_reset_ports_inv, -- clock_reset_reset.reset
			irq   => mebx_qsys_project_inst_rs232_uart_irq_bfm_irq_irq     --               irq.irq
		);

	mebx_qsys_project_inst_rst_bfm : component altera_avalon_reset_source
		generic map (
			ASSERT_HIGH_RESET    => 0,
			INITIAL_RESET_CYCLES => 50
		)
		port map (
			reset => mebx_qsys_project_inst_rst_bfm_reset_reset, -- reset.reset_n
			clk   => mebx_qsys_project_inst_clk50_bfm_clk_clk    --   clk.clk
		);

	mebx_qsys_project_inst_uart_module_bfm : component altera_conduit_bfm_0002
		port map (
			clk                    => mebx_qsys_project_inst_clk50_bfm_clk_clk,                       --     clk.clk
			sig_uart_cts_signal(0) => mebx_qsys_project_inst_uart_module_uart_cts_signal,             -- conduit.uart_cts_signal
			sig_uart_rts_signal    => mebx_qsys_project_inst_uart_module_bfm_conduit_uart_rts_signal, --        .uart_rts_signal
			sig_uart_rxd_signal    => mebx_qsys_project_inst_uart_module_bfm_conduit_uart_rxd_signal, --        .uart_rxd_signal
			sig_uart_txd_signal(0) => mebx_qsys_project_inst_uart_module_uart_txd_signal,             --        .uart_txd_signal
			reset                  => '0'                                                             -- (terminated)
		);

	mebx_qsys_project_inst_uart_module_top_0_avalon_slave_bfm : component altera_avalon_mm_master_bfm_vhdl
		generic map (
			AV_ADDRESS_W               => 8,
			AV_SYMBOL_W                => 8,
			AV_NUMSYMBOLS              => 4,
			AV_BURSTCOUNT_W            => 1,
			AV_READRESPONSE_W          => 1,
			AV_WRITERESPONSE_W         => 1,
			USE_READ                   => 1,
			USE_WRITE                  => 1,
			USE_ADDRESS                => 1,
			USE_BYTE_ENABLE            => 0,
			USE_BURSTCOUNT             => 0,
			USE_READ_DATA              => 1,
			USE_READ_DATA_VALID        => 0,
			USE_WRITE_DATA             => 1,
			USE_BEGIN_TRANSFER         => 0,
			USE_BEGIN_BURST_TRANSFER   => 0,
			USE_WAIT_REQUEST           => 1,
			USE_TRANSACTIONID          => 0,
			USE_WRITERESPONSE          => 0,
			USE_READRESPONSE           => 0,
			USE_CLKEN                  => 0,
			AV_CONSTANT_BURST_BEHAVIOR => 1,
			AV_BURST_LINEWRAP          => 0,
			AV_BURST_BNDR_ONLY         => 0,
			AV_MAX_PENDING_READS       => 0,
			AV_MAX_PENDING_WRITES      => 0,
			AV_FIX_READ_LATENCY        => 0,
			AV_READ_WAIT_TIME          => 1,
			AV_WRITE_WAIT_TIME         => 0,
			REGISTER_WAITREQUEST       => 0,
			AV_REGISTERINCOMINGSIGNALS => 0,
			VHDL_ID                    => 0
		)
		port map (
			clk                    => mebx_qsys_project_inst_clk50_bfm_clk_clk,                                 --       clk.clk
			reset                  => mebx_qsys_project_inst_rst_bfm_reset_reset_ports_inv,                     -- clk_reset.reset
			avm_address            => mebx_qsys_project_inst_uart_module_top_0_avalon_slave_bfm_m0_address,     --        m0.address
			avm_readdata           => mebx_qsys_project_inst_uart_module_top_0_avalon_slave_bfm_m0_readdata,    --          .readdata
			avm_writedata          => mebx_qsys_project_inst_uart_module_top_0_avalon_slave_bfm_m0_writedata,   --          .writedata
			avm_waitrequest        => mebx_qsys_project_inst_uart_module_top_0_avalon_slave_bfm_m0_waitrequest, --          .waitrequest
			avm_write              => mebx_qsys_project_inst_uart_module_top_0_avalon_slave_bfm_m0_write,       --          .write
			avm_read               => mebx_qsys_project_inst_uart_module_top_0_avalon_slave_bfm_m0_read,        --          .read
			avm_burstcount         => open,                                                                     -- (terminated)
			avm_begintransfer      => open,                                                                     -- (terminated)
			avm_beginbursttransfer => open,                                                                     -- (terminated)
			avm_byteenable         => open,                                                                     -- (terminated)
			avm_readdatavalid      => '0',                                                                      -- (terminated)
			avm_arbiterlock        => open,                                                                     -- (terminated)
			avm_lock               => open,                                                                     -- (terminated)
			avm_debugaccess        => open,                                                                     -- (terminated)
			avm_transactionid      => open,                                                                     -- (terminated)
			avm_readid             => "00000000",                                                               -- (terminated)
			avm_writeid            => "00000000",                                                               -- (terminated)
			avm_clken              => open,                                                                     -- (terminated)
			avm_response           => "00",                                                                     -- (terminated)
			avm_writeresponsevalid => '0',                                                                      -- (terminated)
			avm_readresponse       => "0",                                                                      -- (terminated)
			avm_writeresponse      => "0"                                                                       -- (terminated)
		);

	irq_mapper : component altera_irq_mapper
		port map (
			clk           => mebx_qsys_project_inst_clk50_bfm_clk_clk,             --       clk.clk
			reset         => mebx_qsys_project_inst_rst_bfm_reset_reset_ports_inv, -- clk_reset.reset
			receiver0_irq => irq_mapper_receiver0_irq,                             -- receiver0.irq
			sender_irq    => mebx_qsys_project_inst_rs232_uart_irq_bfm_irq_irq     --    sender.irq
		);

	mebx_qsys_project_inst_rst_bfm_reset_reset_ports_inv <= not mebx_qsys_project_inst_rst_bfm_reset_reset;

end architecture rtl; -- of MebX_Qsys_Project_tb
