// MebX_Qsys_Project_dma_M1_M2.v

// This file was auto-generated from altera_msgdma_hw.tcl.  If you edit it your changes
// will probably be lost.
// 
// Generated using ACDS version 16.1 196

`timescale 1 ps / 1 ps
module MebX_Qsys_Project_dma_M1_M2 (
		output wire [30:0]  mm_read_address,              //          mm_read.address
		output wire         mm_read_read,                 //                 .read
		output wire [7:0]   mm_read_byteenable,           //                 .byteenable
		input  wire [63:0]  mm_read_readdata,             //                 .readdata
		input  wire         mm_read_waitrequest,          //                 .waitrequest
		input  wire         mm_read_readdatavalid,        //                 .readdatavalid
		output wire [7:0]   mm_read_burstcount,           //                 .burstcount
		output wire [31:0]  mm_write_address,             //         mm_write.address
		output wire         mm_write_write,               //                 .write
		output wire [7:0]   mm_write_byteenable,          //                 .byteenable
		output wire [63:0]  mm_write_writedata,           //                 .writedata
		input  wire         mm_write_waitrequest,         //                 .waitrequest
		output wire [7:0]   mm_write_burstcount,          //                 .burstcount
		input  wire         clock_clk,                    //            clock.clk
		input  wire         reset_n_reset_n,              //          reset_n.reset_n
		input  wire [31:0]  csr_writedata,                //              csr.writedata
		input  wire         csr_write,                    //                 .write
		input  wire [3:0]   csr_byteenable,               //                 .byteenable
		output wire [31:0]  csr_readdata,                 //                 .readdata
		input  wire         csr_read,                     //                 .read
		input  wire [2:0]   csr_address,                  //                 .address
		input  wire         descriptor_slave_write,       // descriptor_slave.write
		output wire         descriptor_slave_waitrequest, //                 .waitrequest
		input  wire [127:0] descriptor_slave_writedata,   //                 .writedata
		input  wire [15:0]  descriptor_slave_byteenable,  //                 .byteenable
		output wire         csr_irq_irq                   //          csr_irq.irq
	);

	wire          read_mstr_internal_data_source_valid;           // read_mstr_internal:src_valid -> write_mstr_internal:snk_valid
	wire   [63:0] read_mstr_internal_data_source_data;            // read_mstr_internal:src_data -> write_mstr_internal:snk_data
	wire          read_mstr_internal_data_source_ready;           // write_mstr_internal:snk_ready -> read_mstr_internal:src_ready
	wire          dispatcher_internal_read_command_source_valid;  // dispatcher_internal:src_read_master_valid -> read_mstr_internal:snk_command_valid
	wire  [255:0] dispatcher_internal_read_command_source_data;   // dispatcher_internal:src_read_master_data -> read_mstr_internal:snk_command_data
	wire          dispatcher_internal_read_command_source_ready;  // read_mstr_internal:snk_command_ready -> dispatcher_internal:src_read_master_ready
	wire          read_mstr_internal_response_source_valid;       // read_mstr_internal:src_response_valid -> dispatcher_internal:snk_read_master_valid
	wire  [255:0] read_mstr_internal_response_source_data;        // read_mstr_internal:src_response_data -> dispatcher_internal:snk_read_master_data
	wire          read_mstr_internal_response_source_ready;       // dispatcher_internal:snk_read_master_ready -> read_mstr_internal:src_response_ready
	wire          dispatcher_internal_write_command_source_valid; // dispatcher_internal:src_write_master_valid -> write_mstr_internal:snk_command_valid
	wire  [255:0] dispatcher_internal_write_command_source_data;  // dispatcher_internal:src_write_master_data -> write_mstr_internal:snk_command_data
	wire          dispatcher_internal_write_command_source_ready; // write_mstr_internal:snk_command_ready -> dispatcher_internal:src_write_master_ready
	wire          write_mstr_internal_response_source_valid;      // write_mstr_internal:src_response_valid -> dispatcher_internal:snk_write_master_valid
	wire  [255:0] write_mstr_internal_response_source_data;       // write_mstr_internal:src_response_data -> dispatcher_internal:snk_write_master_data
	wire          write_mstr_internal_response_source_ready;      // dispatcher_internal:snk_write_master_ready -> write_mstr_internal:src_response_ready

	dispatcher #(
		.MODE                        (0),
		.RESPONSE_PORT               (2),
		.DESCRIPTOR_INTERFACE        (0),
		.DESCRIPTOR_FIFO_DEPTH       (32),
		.ENHANCED_FEATURES           (0),
		.DESCRIPTOR_WIDTH            (128),
		.DESCRIPTOR_BYTEENABLE_WIDTH (16)
	) dispatcher_internal (
		.clk                     (clock_clk),                                                                                                                             //                clock.clk
		.reset                   (~reset_n_reset_n),                                                                                                                      //          clock_reset.reset
		.csr_writedata           (csr_writedata),                                                                                                                         //                  CSR.writedata
		.csr_write               (csr_write),                                                                                                                             //                     .write
		.csr_byteenable          (csr_byteenable),                                                                                                                        //                     .byteenable
		.csr_readdata            (csr_readdata),                                                                                                                          //                     .readdata
		.csr_read                (csr_read),                                                                                                                              //                     .read
		.csr_address             (csr_address),                                                                                                                           //                     .address
		.descriptor_write        (descriptor_slave_write),                                                                                                                //     Descriptor_Slave.write
		.descriptor_waitrequest  (descriptor_slave_waitrequest),                                                                                                          //                     .waitrequest
		.descriptor_writedata    (descriptor_slave_writedata),                                                                                                            //                     .writedata
		.descriptor_byteenable   (descriptor_slave_byteenable),                                                                                                           //                     .byteenable
		.src_write_master_data   (dispatcher_internal_write_command_source_data),                                                                                         // Write_Command_Source.data
		.src_write_master_valid  (dispatcher_internal_write_command_source_valid),                                                                                        //                     .valid
		.src_write_master_ready  (dispatcher_internal_write_command_source_ready),                                                                                        //                     .ready
		.snk_write_master_data   (write_mstr_internal_response_source_data),                                                                                              //  Write_Response_Sink.data
		.snk_write_master_valid  (write_mstr_internal_response_source_valid),                                                                                             //                     .valid
		.snk_write_master_ready  (write_mstr_internal_response_source_ready),                                                                                             //                     .ready
		.src_read_master_data    (dispatcher_internal_read_command_source_data),                                                                                          //  Read_Command_Source.data
		.src_read_master_valid   (dispatcher_internal_read_command_source_valid),                                                                                         //                     .valid
		.src_read_master_ready   (dispatcher_internal_read_command_source_ready),                                                                                         //                     .ready
		.snk_read_master_data    (read_mstr_internal_response_source_data),                                                                                               //   Read_Response_Sink.data
		.snk_read_master_valid   (read_mstr_internal_response_source_valid),                                                                                              //                     .valid
		.snk_read_master_ready   (read_mstr_internal_response_source_ready),                                                                                              //                     .ready
		.csr_irq                 (csr_irq_irq),                                                                                                                           //              csr_irq.irq
		.src_response_data       (),                                                                                                                                      //          (terminated)
		.src_response_valid      (),                                                                                                                                      //          (terminated)
		.src_response_ready      (1'b0),                                                                                                                                  //          (terminated)
		.snk_descriptor_data     (128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000), //          (terminated)
		.snk_descriptor_valid    (1'b0),                                                                                                                                  //          (terminated)
		.snk_descriptor_ready    (),                                                                                                                                      //          (terminated)
		.mm_response_waitrequest (),                                                                                                                                      //          (terminated)
		.mm_response_byteenable  (4'b0000),                                                                                                                               //          (terminated)
		.mm_response_address     (1'b0),                                                                                                                                  //          (terminated)
		.mm_response_readdata    (),                                                                                                                                      //          (terminated)
		.mm_response_read        (1'b0)                                                                                                                                   //          (terminated)
	);

	read_master #(
		.DATA_WIDTH                (64),
		.LENGTH_WIDTH              (27),
		.FIFO_DEPTH                (512),
		.STRIDE_ENABLE             (0),
		.BURST_ENABLE              (1),
		.PACKET_ENABLE             (0),
		.ERROR_ENABLE              (0),
		.ERROR_WIDTH               (8),
		.CHANNEL_ENABLE            (0),
		.CHANNEL_WIDTH             (8),
		.BYTE_ENABLE_WIDTH         (8),
		.BYTE_ENABLE_WIDTH_LOG2    (3),
		.ADDRESS_WIDTH             (31),
		.FIFO_DEPTH_LOG2           (9),
		.SYMBOL_WIDTH              (8),
		.NUMBER_OF_SYMBOLS         (8),
		.NUMBER_OF_SYMBOLS_LOG2    (3),
		.MAX_BURST_COUNT_WIDTH     (8),
		.UNALIGNED_ACCESSES_ENABLE (0),
		.ONLY_FULL_ACCESS_ENABLE   (0),
		.BURST_WRAPPING_SUPPORT    (0),
		.PROGRAMMABLE_BURST_ENABLE (0),
		.MAX_BURST_COUNT           (128),
		.FIFO_SPEED_OPTIMIZATION   (1),
		.STRIDE_WIDTH              (1)
	) read_mstr_internal (
		.clk                  (clock_clk),                                     //            Clock.clk
		.reset                (~reset_n_reset_n),                              //      Clock_reset.reset
		.master_address       (mm_read_address),                               // Data_Read_Master.address
		.master_read          (mm_read_read),                                  //                 .read
		.master_byteenable    (mm_read_byteenable),                            //                 .byteenable
		.master_readdata      (mm_read_readdata),                              //                 .readdata
		.master_waitrequest   (mm_read_waitrequest),                           //                 .waitrequest
		.master_readdatavalid (mm_read_readdatavalid),                         //                 .readdatavalid
		.master_burstcount    (mm_read_burstcount),                            //                 .burstcount
		.src_data             (read_mstr_internal_data_source_data),           //      Data_Source.data
		.src_valid            (read_mstr_internal_data_source_valid),          //                 .valid
		.src_ready            (read_mstr_internal_data_source_ready),          //                 .ready
		.snk_command_data     (dispatcher_internal_read_command_source_data),  //     Command_Sink.data
		.snk_command_valid    (dispatcher_internal_read_command_source_valid), //                 .valid
		.snk_command_ready    (dispatcher_internal_read_command_source_ready), //                 .ready
		.src_response_data    (read_mstr_internal_response_source_data),       //  Response_Source.data
		.src_response_valid   (read_mstr_internal_response_source_valid),      //                 .valid
		.src_response_ready   (read_mstr_internal_response_source_ready),      //                 .ready
		.src_sop              (),                                              //      (terminated)
		.src_eop              (),                                              //      (terminated)
		.src_empty            (),                                              //      (terminated)
		.src_error            (),                                              //      (terminated)
		.src_channel          ()                                               //      (terminated)
	);

	write_master #(
		.DATA_WIDTH                     (64),
		.LENGTH_WIDTH                   (27),
		.FIFO_DEPTH                     (512),
		.STRIDE_ENABLE                  (0),
		.BURST_ENABLE                   (1),
		.PACKET_ENABLE                  (0),
		.ERROR_ENABLE                   (0),
		.ERROR_WIDTH                    (8),
		.BYTE_ENABLE_WIDTH              (8),
		.BYTE_ENABLE_WIDTH_LOG2         (3),
		.ADDRESS_WIDTH                  (32),
		.FIFO_DEPTH_LOG2                (9),
		.SYMBOL_WIDTH                   (8),
		.NUMBER_OF_SYMBOLS              (8),
		.NUMBER_OF_SYMBOLS_LOG2         (3),
		.MAX_BURST_COUNT_WIDTH          (8),
		.UNALIGNED_ACCESSES_ENABLE      (0),
		.ONLY_FULL_ACCESS_ENABLE        (0),
		.BURST_WRAPPING_SUPPORT         (0),
		.PROGRAMMABLE_BURST_ENABLE      (0),
		.MAX_BURST_COUNT                (128),
		.FIFO_SPEED_OPTIMIZATION        (1),
		.STRIDE_WIDTH                   (1),
		.ACTUAL_BYTES_TRANSFERRED_WIDTH (32)
	) write_mstr_internal (
		.clk                (clock_clk),                                      //             Clock.clk
		.reset              (~reset_n_reset_n),                               //       Clock_reset.reset
		.master_address     (mm_write_address),                               // Data_Write_Master.address
		.master_write       (mm_write_write),                                 //                  .write
		.master_byteenable  (mm_write_byteenable),                            //                  .byteenable
		.master_writedata   (mm_write_writedata),                             //                  .writedata
		.master_waitrequest (mm_write_waitrequest),                           //                  .waitrequest
		.master_burstcount  (mm_write_burstcount),                            //                  .burstcount
		.snk_data           (read_mstr_internal_data_source_data),            //         Data_Sink.data
		.snk_valid          (read_mstr_internal_data_source_valid),           //                  .valid
		.snk_ready          (read_mstr_internal_data_source_ready),           //                  .ready
		.snk_command_data   (dispatcher_internal_write_command_source_data),  //      Command_Sink.data
		.snk_command_valid  (dispatcher_internal_write_command_source_valid), //                  .valid
		.snk_command_ready  (dispatcher_internal_write_command_source_ready), //                  .ready
		.src_response_data  (write_mstr_internal_response_source_data),       //   Response_Source.data
		.src_response_valid (write_mstr_internal_response_source_valid),      //                  .valid
		.src_response_ready (write_mstr_internal_response_source_ready),      //                  .ready
		.snk_sop            (1'b0),                                           //       (terminated)
		.snk_eop            (1'b0),                                           //       (terminated)
		.snk_empty          (3'b000),                                         //       (terminated)
		.snk_error          (8'b00000000)                                     //       (terminated)
	);

endmodule
