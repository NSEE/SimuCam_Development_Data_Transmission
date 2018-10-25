// (C) 2001-2016 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/16.1/ip/merlin/altera_merlin_router/altera_merlin_router.sv.terp#1 $
// $Revision: #1 $
// $Date: 2016/08/07 $
// $Author: swbranch $

// -------------------------------------------------------
// Merlin Router
//
// Asserts the appropriate one-hot encoded channel based on 
// either (a) the address or (b) the dest id. The DECODER_TYPE
// parameter controls this behaviour. 0 means address decoder,
// 1 means dest id decoder.
//
// In the case of (a), it also sets the destination id.
// -------------------------------------------------------

`timescale 1 ns / 1 ns

module MebX_Qsys_Project_mm_interconnect_0_router_default_decode
  #(
     parameter DEFAULT_CHANNEL = 22,
               DEFAULT_WR_CHANNEL = -1,
               DEFAULT_RD_CHANNEL = -1,
               DEFAULT_DESTID = 11 
   )
  (output [108 - 104 : 0] default_destination_id,
   output [23-1 : 0] default_wr_channel,
   output [23-1 : 0] default_rd_channel,
   output [23-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[108 - 104 : 0];

  generate
    if (DEFAULT_CHANNEL == -1) begin : no_default_channel_assignment
      assign default_src_channel = '0;
    end
    else begin : default_channel_assignment
      assign default_src_channel = 23'b1 << DEFAULT_CHANNEL;
    end
  endgenerate

  generate
    if (DEFAULT_RD_CHANNEL == -1) begin : no_default_rw_channel_assignment
      assign default_wr_channel = '0;
      assign default_rd_channel = '0;
    end
    else begin : default_rw_channel_assignment
      assign default_wr_channel = 23'b1 << DEFAULT_WR_CHANNEL;
      assign default_rd_channel = 23'b1 << DEFAULT_RD_CHANNEL;
    end
  endgenerate

endmodule


module MebX_Qsys_Project_mm_interconnect_0_router
(
    // -------------------
    // Clock & Reset
    // -------------------
    input clk,
    input reset,

    // -------------------
    // Command Sink (Input)
    // -------------------
    input                       sink_valid,
    input  [122-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [122-1    : 0] src_data,
    output reg [23-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 67;
    localparam PKT_ADDR_L = 36;
    localparam PKT_DEST_ID_H = 108;
    localparam PKT_DEST_ID_L = 104;
    localparam PKT_PROTECTION_H = 112;
    localparam PKT_PROTECTION_L = 110;
    localparam ST_DATA_W = 122;
    localparam ST_CHANNEL_W = 23;
    localparam DECODER_TYPE = 0;

    localparam PKT_TRANS_WRITE = 70;
    localparam PKT_TRANS_READ  = 71;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;



    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    localparam PAD0 = log2ceil(64'h80000000 - 64'h0); 
    localparam PAD1 = log2ceil(64'h80000400 - 64'h80000000); 
    localparam PAD2 = log2ceil(64'h81200000 - 64'h81100000); 
    localparam PAD3 = log2ceil(64'h81201000 - 64'h81200800); 
    localparam PAD4 = log2ceil(64'h81201800 - 64'h81201000); 
    localparam PAD5 = log2ceil(64'h81201c00 - 64'h81201800); 
    localparam PAD6 = log2ceil(64'h81202000 - 64'h81201c00); 
    localparam PAD7 = log2ceil(64'h81202400 - 64'h81202000); 
    localparam PAD8 = log2ceil(64'h81202800 - 64'h81202400); 
    localparam PAD9 = log2ceil(64'h81202c00 - 64'h81202800); 
    localparam PAD10 = log2ceil(64'h81203000 - 64'h81202c00); 
    localparam PAD11 = log2ceil(64'h81203400 - 64'h81203000); 
    localparam PAD12 = log2ceil(64'h81203800 - 64'h81203400); 
    localparam PAD13 = log2ceil(64'h81203c00 - 64'h81203800); 
    localparam PAD14 = log2ceil(64'h81204000 - 64'h81203c00); 
    localparam PAD15 = log2ceil(64'h81204040 - 64'h81204000); 
    localparam PAD16 = log2ceil(64'h81204080 - 64'h81204040); 
    localparam PAD17 = log2ceil(64'h812040a0 - 64'h81204080); 
    localparam PAD18 = log2ceil(64'h812040c0 - 64'h812040a0); 
    localparam PAD19 = log2ceil(64'h812040c8 - 64'h812040c0); 
    localparam PAD20 = log2ceil(64'h812040d0 - 64'h812040c8); 
    localparam PAD21 = log2ceil(64'h812040d8 - 64'h812040d0); 
    localparam PAD22 = log2ceil(64'h88000000 - 64'h84000000); 
    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 64'h88000000;
    localparam RANGE_ADDR_WIDTH = log2ceil(ADDR_RANGE);
    localparam OPTIMIZED_ADDR_H = (RANGE_ADDR_WIDTH > PKT_ADDR_W) ||
                                  (RANGE_ADDR_WIDTH == 0) ?
                                        PKT_ADDR_H :
                                        PKT_ADDR_L + RANGE_ADDR_WIDTH - 1;

    localparam RG = RANGE_ADDR_WIDTH-1;
    localparam REAL_ADDRESS_RANGE = OPTIMIZED_ADDR_H - PKT_ADDR_L;

      reg [PKT_ADDR_W-1 : 0] address;
      always @* begin
        address = {PKT_ADDR_W{1'b0}};
        address [REAL_ADDRESS_RANGE:0] = sink_data[OPTIMIZED_ADDR_H : PKT_ADDR_L];
      end   

    // -------------------------------------------------------
    // Pass almost everything through, untouched
    // -------------------------------------------------------
    assign sink_ready        = src_ready;
    assign src_valid         = sink_valid;
    assign src_startofpacket = sink_startofpacket;
    assign src_endofpacket   = sink_endofpacket;
    wire [PKT_DEST_ID_W-1:0] default_destid;
    wire [23-1 : 0] default_src_channel;




    // -------------------------------------------------------
    // Write and read transaction signals
    // -------------------------------------------------------
    wire write_transaction;
    assign write_transaction = sink_data[PKT_TRANS_WRITE];
    wire read_transaction;
    assign read_transaction  = sink_data[PKT_TRANS_READ];


    MebX_Qsys_Project_mm_interconnect_0_router_default_decode the_default_decode(
      .default_destination_id (default_destid),
      .default_wr_channel   (),
      .default_rd_channel   (),
      .default_src_channel  (default_src_channel)
    );

    always @* begin
        src_data    = sink_data;
        src_channel = default_src_channel;
        src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = default_destid;

        // --------------------------------------------------
        // Address Decoder
        // Sets the channel and destination ID based on the address
        // --------------------------------------------------

    // ( 0x0 .. 0x80000000 )
    if ( {address[RG:PAD0],{PAD0{1'b0}}} == 32'h0   ) begin
            src_channel = 23'b10000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 11;
    end

    // ( 0x80000000 .. 0x80000400 )
    if ( {address[RG:PAD1],{PAD1{1'b0}}} == 32'h80000000   ) begin
            src_channel = 23'b00001000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 9;
    end

    // ( 0x81100000 .. 0x81200000 )
    if ( {address[RG:PAD2],{PAD2{1'b0}}} == 32'h81100000   ) begin
            src_channel = 23'b00010000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 18;
    end

    // ( 0x81200800 .. 0x81201000 )
    if ( {address[RG:PAD3],{PAD3{1'b0}}} == 32'h81200800   ) begin
            src_channel = 23'b00100000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 12;
    end

    // ( 0x81201000 .. 0x81201800 )
    if ( {address[RG:PAD4],{PAD4{1'b0}}} == 32'h81201000   ) begin
            src_channel = 23'b00000010000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 17;
    end

    // ( 0x81201800 .. 0x81201c00 )
    if ( {address[RG:PAD5],{PAD5{1'b0}}} == 32'h81201800   ) begin
            src_channel = 23'b00000000000001000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 7;
    end

    // ( 0x81201c00 .. 0x81202000 )
    if ( {address[RG:PAD6],{PAD6{1'b0}}} == 32'h81201c00   ) begin
            src_channel = 23'b00000000000000100000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 6;
    end

    // ( 0x81202000 .. 0x81202400 )
    if ( {address[RG:PAD7],{PAD7{1'b0}}} == 32'h81202000   ) begin
            src_channel = 23'b00000000000000010000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 5;
    end

    // ( 0x81202400 .. 0x81202800 )
    if ( {address[RG:PAD8],{PAD8{1'b0}}} == 32'h81202400   ) begin
            src_channel = 23'b00000000000000001000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 4;
    end

    // ( 0x81202800 .. 0x81202c00 )
    if ( {address[RG:PAD9],{PAD9{1'b0}}} == 32'h81202800   ) begin
            src_channel = 23'b00000000000000000100000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
    end

    // ( 0x81202c00 .. 0x81203000 )
    if ( {address[RG:PAD10],{PAD10{1'b0}}} == 32'h81202c00   ) begin
            src_channel = 23'b00000000000000000010000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
    end

    // ( 0x81203000 .. 0x81203400 )
    if ( {address[RG:PAD11],{PAD11{1'b0}}} == 32'h81203000   ) begin
            src_channel = 23'b00000000000000000001000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 1;
    end

    // ( 0x81203400 .. 0x81203800 )
    if ( {address[RG:PAD12],{PAD12{1'b0}}} == 32'h81203400   ) begin
            src_channel = 23'b00000000000000000000100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
    end

    // ( 0x81203800 .. 0x81203c00 )
    if ( {address[RG:PAD13],{PAD13{1'b0}}} == 32'h81203800   ) begin
            src_channel = 23'b00000000000100000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 22;
    end

    // ( 0x81203c00 .. 0x81204000 )
    if ( {address[RG:PAD14],{PAD14{1'b0}}} == 32'h81203c00   ) begin
            src_channel = 23'b00000000000000000000010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 8;
    end

    // ( 0x81204000 .. 0x81204040 )
    if ( {address[RG:PAD15],{PAD15{1'b0}}} == 32'h81204000   ) begin
            src_channel = 23'b00000000100000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 19;
    end

    // ( 0x81204040 .. 0x81204080 )
    if ( {address[RG:PAD16],{PAD16{1'b0}}} == 32'h81204040   ) begin
            src_channel = 23'b00000000010000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 20;
    end

    // ( 0x81204080 .. 0x812040a0 )
    if ( {address[RG:PAD17],{PAD17{1'b0}}} == 32'h81204080  && write_transaction  ) begin
            src_channel = 23'b00000100000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 14;
    end

    // ( 0x812040a0 .. 0x812040c0 )
    if ( {address[RG:PAD18],{PAD18{1'b0}}} == 32'h812040a0   ) begin
            src_channel = 23'b00000001000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 13;
    end

    // ( 0x812040c0 .. 0x812040c8 )
    if ( {address[RG:PAD19],{PAD19{1'b0}}} == 32'h812040c0  && read_transaction  ) begin
            src_channel = 23'b00000000001000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 21;
    end

    // ( 0x812040c8 .. 0x812040d0 )
    if ( {address[RG:PAD20],{PAD20{1'b0}}} == 32'h812040c8   ) begin
            src_channel = 23'b00000000000010000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 10;
    end

    // ( 0x812040d0 .. 0x812040d8 )
    if ( {address[RG:PAD21],{PAD21{1'b0}}} == 32'h812040d0   ) begin
            src_channel = 23'b00000000000000000000001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 16;
    end

    // ( 0x84000000 .. 0x88000000 )
    if ( {address[RG:PAD22],{PAD22{1'b0}}} == 32'h84000000   ) begin
            src_channel = 23'b01000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 15;
    end

end


    // --------------------------------------------------
    // Ceil(log2()) function
    // --------------------------------------------------
    function integer log2ceil;
        input reg[65:0] val;
        reg [65:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

endmodule

