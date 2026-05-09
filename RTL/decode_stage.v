  ////////////////////////////decode_stage.v/////////////////////////
    /********************************************************************************************

  Copyright 2024 - Maven Silicon Softech Pvt Ltd.  

  www.maven-silicon.com

  All Rights Reserved.

  This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
  It is not to be shared with or used by any third parties who have not enrolled for our paid 
  training courses or received any written authorization from Maven Silicon.

  Filename                :       decode_stage.v   

  module Name             :       decode_stage

  Description             :       Decodes the address from input stage and provides slave select signal

  Author Name             :       K Sriguru

  Support e-mail          :       For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

  Version                 :       1.0

  *********************************************************************************************/  




  module decode_stage #(parameter N=15)(
                                        // Common AHB signals
                                        input               HCLK,             // System Clock
                                        input               HRESETn,          // System Reset

                                        // Internal address remapping control
                                        input   [3:0]       remap,            // Internal remap signal

                                        // Signals from the Input stage from input stage
                                        input         	    HREADYS,          // Transfer done
					input  [3:0]        hmaster,          // Hmaster value
                                        input               sel_dec,          // HSEL input
                                        input  [31:0]       decode_addr_dec,  // HADDR decoder input
                                        input   [1:0]       trans_dec,        // Input port HTRANS signal
                                        input   	    hwrite,	      // Input port from ip stage

                                        // From output stage 0
                                        input   [N-1:0]     active_dec,       // Output stage MI0 active_dec signal
                                        input   [N-1:0]     readyout_dec,     // HREADYOUT input
                                        input   [(N*2)-1:0] resp_dec,         // HRESP input
                                        input   [(N*32)-1:0]rdata_dec,        // HRDATA input

                                        // Output port selection signals
                                        output reg  [N-1:0] sel_out,          // HSEL output to o/p stage 0

                                        // Selected Output port data and control signals
                                        output reg          active_decode,    // Combinatorial active_dec O/P
                                        output reg          HREADYOUTS,       // HREADY feedback output
                                        output reg [1:0]    HRESPS,           // Transfer response
                                        output reg [31:0]   HRDATAS,          // Slave output to master
                                        output 	            HREADYIN          // hready out for read data
                                        );


  reg     [3:0] addr_out_port;     	// Address output ports
  reg     [3:0] data_out_port;     	// Data output ports

  // Default slave signals
  reg           sel_dft_slv;       	// HSEL signal
  wire          readyout_dft_slv;  	// HREADYOUT signal
  wire    [1:0] resp_dft_slv;      	// Combinatorial HRESPS signal


  default_slave DUV(
                    // Common AHB signals
                    .HCLK        (HCLK),
                    .HRESETn     (HRESETn),

                    // AHB Control signals
                    .HSEL        (sel_dft_slv),
                    .HTRANS      (trans_dec[1]),
                    .HREADY      (HREADYS),
                    .HREADYOUT   (readyout_dft_slv),
                    .HRESP       (resp_dft_slv)
	            );


  always@(decode_addr_dec or remap)
    begin
      case (remap)  
      4'd0 : begin
               if (((decode_addr_dec > 32'h00000000) & (decode_addr_dec < 32'h00001000)))
                 addr_out_port = 4'd0;  // Select Output port 0

               else if (((decode_addr_dec > 32'h00001000) & (decode_addr_dec < 32'h00002000)))
                 addr_out_port = 4'd1;  // Select Output port 1

               else if (((decode_addr_dec > 32'h00002000) & (decode_addr_dec < 32'h00003000)))
                 addr_out_port = 4'd2;  // Select Output port 2

               else if (((decode_addr_dec > 32'h00003000) & (decode_addr_dec < 32'h00004000)))
                 addr_out_port = 4'd3;  // Select Output port 3

               else if (((decode_addr_dec > 32'h00004000) & (decode_addr_dec < 32'h00005000)))
                 addr_out_port = 4'd4;  // Select Output port 4

               else if (((decode_addr_dec > 32'h00006000) & (decode_addr_dec < 32'h00007000)))
                 addr_out_port = 4'd5;  // Select Output port 5

               else if (((decode_addr_dec > 32'h00007000) & (decode_addr_dec < 32'h00008000)))
                 addr_out_port = 4'd6;  // Select Output port 6

               else if (((decode_addr_dec > 32'h00008000) & (decode_addr_dec < 32'h00009000)))
                 addr_out_port = 4'd7;  // Select Output port 7

               else if (((decode_addr_dec > 32'h00009000) & (decode_addr_dec < 32'h00010000)))
                 addr_out_port = 4'd8;  // Select Output port 8

               else if (((decode_addr_dec > 32'h00010000) & (decode_addr_dec < 32'h00020000)))
                 addr_out_port = 4'd9;  // Select Output port 9

               else if (((decode_addr_dec > 32'h00020000) & (decode_addr_dec < 32'h00030000)))
                 addr_out_port = 4'd10;  // Select Output port 10

               else if (((decode_addr_dec > 32'h00030000) & (decode_addr_dec < 32'h00040000)))
                 addr_out_port = 4'd11;  // Select Output port 11

               else if (((decode_addr_dec > 32'h00040000) & (decode_addr_dec < 32'h00050000)))
                 addr_out_port = 4'd12;  // Select Output port 12

               else if (((decode_addr_dec > 32'h00060000) & (decode_addr_dec < 32'h00070000)))
                 addr_out_port = 4'd13;  // Select Output port 13

               else if (((decode_addr_dec > 32'h00070000) & (decode_addr_dec < 32'h00080000)))
                 addr_out_port = 4'd14;  // Select Output port 14

               //else if (((decode_addr_dec == 32'h0) & (decode_addr_dec > 32'h00080000)))
                 //addr_out_port = 4'd15;   // Select the default slave
	     
	       else
                 addr_out_port = 4'd15;
             end

      4'd1 : begin
               if (((decode_addr_dec > 32'hC0000000) & (decode_addr_dec < 32'hC0001000)))
                 addr_out_port = 4'd0;  // Select Output port 0

               else if (((decode_addr_dec > 32'hC0001000) & (decode_addr_dec < 32'hC0002000)))
                 addr_out_port = 4'd1;  // Select Output port 1

               else if (((decode_addr_dec > 32'hC0002000) & (decode_addr_dec < 32'hC0003000)))
                 addr_out_port = 4'd2;  // Select Output port 2

               else if (((decode_addr_dec > 32'hC0003000) & (decode_addr_dec < 32'hC0004000)))
                 addr_out_port = 4'd3;  // Select Output port 3

               else if (((decode_addr_dec > 32'hC0004000) & (decode_addr_dec < 32'hC0005000)))
                 addr_out_port = 4'd4;  // Select Output port 4

               else if (((decode_addr_dec > 32'hC0006000) & (decode_addr_dec < 32'hC0007000)))
                 addr_out_port = 4'd5;  // Select Output port 5

               else if (((decode_addr_dec > 32'hC0007000) & (decode_addr_dec < 32'hC0008000)))
                 addr_out_port = 4'd6;  // Select Output port 6

               else if (((decode_addr_dec > 32'hC0008000) & (decode_addr_dec < 32'hC0009000)))
                 addr_out_port = 4'd7;  // Select Output port 7

               else if (((decode_addr_dec > 32'hC0009000) & (decode_addr_dec < 32'hC0010000)))
                 addr_out_port = 4'd8;  // Select Output port 8

               else if (((decode_addr_dec > 32'hC0010000) & (decode_addr_dec < 32'hC0020000)))
                 addr_out_port = 4'd9;  // Select Output port 9

               else if (((decode_addr_dec > 32'hC0020000) & (decode_addr_dec < 32'hC0030000)))
                 addr_out_port = 4'd10;  // Select Output port 10

               else if (((decode_addr_dec > 32'hC0030000) & (decode_addr_dec < 32'hC0040000)))
                 addr_out_port = 4'd11;  // Select Output port 11

               else if (((decode_addr_dec > 32'hC0040000) & (decode_addr_dec < 32'hC0050000)))
                 addr_out_port = 4'd12;  // Select Output port 12

               else if (((decode_addr_dec > 32'hC0060000) & (decode_addr_dec < 32'hC0070000)))
                 addr_out_port = 4'd13;  // Select Output port 13

               else if (((decode_addr_dec > 32'hC0070000) & (decode_addr_dec < 32'hC0080000)))
                 addr_out_port = 4'd14;  // Select Output port 14

               //else if (((decode_addr_dec == 32'h0) & (decode_addr_dec > 32'hC0080000)))
                 //addr_out_port = 4'd15;   // Select the default slave

               else
                 addr_out_port = 4'd15;
             end

      4'd3 : begin
               if (((decode_addr_dec > 32'hC0000000) & (decode_addr_dec < 32'hC0001000)))
                 addr_out_port = 4'd0;  // Select Output port 0

               else if (((decode_addr_dec > 32'hC0001000) & (decode_addr_dec < 32'hC0002000)))
                 addr_out_port = 4'd1;  // Select Output port 1

               else if (((decode_addr_dec > 32'hC0002000) & (decode_addr_dec < 32'hC0003000)))
                 addr_out_port = 4'd2;  // Select Output port 2

               else if (((decode_addr_dec > 32'hC0003000) & (decode_addr_dec < 32'hC0004000)))
                 addr_out_port = 4'd3;  // Select Output port 3

               else if (((decode_addr_dec > 32'hC0004000) & (decode_addr_dec < 32'hC0005000)))
                 addr_out_port = 4'd4;  // Select Output port 4

               else if (((decode_addr_dec > 32'hC0006000) & (decode_addr_dec < 32'hC0007000)))
                 addr_out_port = 4'd5;  // Select Output port 5

               else if (((decode_addr_dec > 32'hC0007000) & (decode_addr_dec < 32'hC0008000)))
                 addr_out_port = 4'd6;  // Select Output port 6

               else if (((decode_addr_dec > 32'hC0008000) & (decode_addr_dec < 32'hC0009000)))
                 addr_out_port = 4'd7;  // Select Output port 7

               else if (((decode_addr_dec > 32'hC0009000) & (decode_addr_dec < 32'hC0010000)))
                 addr_out_port = 4'd8;  // Select Output port 8

               else if (((decode_addr_dec > 32'hC0010000) & (decode_addr_dec < 32'hC0020000)))
                 addr_out_port = 4'd9;  // Select Output port 9

               else if (((decode_addr_dec > 32'hC0020000) & (decode_addr_dec < 32'hC0030000)))
                 addr_out_port = 4'd10;  // Select Output port 10

               else if (((decode_addr_dec > 32'hC0030000) & (decode_addr_dec < 32'hC0040000)))
                 addr_out_port = 4'd11;  // Select Output port 11

               else if (((decode_addr_dec > 32'hC0040000) & (decode_addr_dec < 32'hC0050000)))
                 addr_out_port = 4'd12;  // Select Output port 12

               else if (((decode_addr_dec > 32'hC0060000) & (decode_addr_dec < 32'hC0070000)))
                 addr_out_port = 4'd13;  // Select Output port 13

               else if (((decode_addr_dec > 32'hC0070000) & (decode_addr_dec < 32'hC0080000)))
                 addr_out_port = 4'd14;  // Select Output port 14

               //else if (((decode_addr_dec == 32'h0) & (decode_addr_dec > 32'hC0080000)))
                 //addr_out_port = 4'd15;   // Select the default slave

               else
                 addr_out_port = 4'd15;
                 
             end

      default : addr_out_port = 4'bz;
      endcase
  end


  // Select signal decode
  always@(sel_dec or addr_out_port)
    begin
      sel_out = 'b0;
      sel_dft_slv = 1'b0;

      if (sel_dec)
        case (addr_out_port)
          4'd0  : sel_out[0]  = 1'b1;
          4'd1  : sel_out[1]  = 1'b1;
          4'd2  : sel_out[2]  = 1'b1;
          4'd3  : sel_out[3]  = 1'b1;
          4'd4  : sel_out[4]  = 1'b1;
          4'd5  : sel_out[5]  = 1'b1;
          4'd6  : sel_out[6]  = 1'b1;
          4'd7  : sel_out[7]  = 1'b1;
          4'd8  : sel_out[8]  = 1'b1;
          4'd9  : sel_out[9]  = 1'b1;
          4'd10 : sel_out[10] = 1'b1;
          4'd11 : sel_out[11] = 1'b1;
          4'd12 : sel_out[12] = 1'b1;
          4'd13 : sel_out[13] = 1'b1;
          4'd14 : sel_out[14] = 1'b1;
          4'd15 : sel_dft_slv = 1'b1;    // Select the default slave
          default : begin
                      sel_out = 'bz;
                      sel_dft_slv = 1'bz;
                    end
        endcase
    end


  // The decoder selects the appropriate active_dec signal depending on which
  // output stage is required for the transfer.
  always@(active_dec or addr_out_port)
    begin
      case (addr_out_port)
        4'd0   : active_decode = active_dec[0];
        4'd1   : active_decode = active_dec[1];
        4'd2   : active_decode = active_dec[2];
        4'd3   : active_decode = active_dec[3];
        4'd4   : active_decode = active_dec[4];
        4'd5   : active_decode = active_dec[5];
        4'd6   : active_decode = active_dec[6];
        4'd7   : active_decode = active_dec[7];
        4'd8   : active_decode = active_dec[8];
        4'd9   : active_decode = active_dec[9];
        4'd10  : active_decode = active_dec[10];
        4'd11  : active_decode = active_dec[11];
        4'd12  : active_decode = active_dec[12];
        4'd13  : active_decode = active_dec[13];
        4'd14  : active_decode = active_dec[14];
        4'd15  : active_decode = 1'b1;         // Select the default slave
        default: active_decode = 1'bz;
      endcase 
    end


  // The data_out_port needs to be updated when HREADY from the input stage is high
  always@(negedge HRESETn or posedge HCLK)
    begin : p_data_out_port_seq
      if (~HRESETn)
        begin
          data_out_port <= 4'b0;
	end
	
      else
        data_out_port <= addr_out_port;
    end 


  // HREADYOUTS output decode
  always@(readyout_dft_slv or readyout_dec or data_out_port)
    begin 
      case (data_out_port)
        4'd0    : HREADYOUTS = readyout_dec[0];
        4'd1    : HREADYOUTS = readyout_dec[1];
        4'd2    : HREADYOUTS = readyout_dec[2];
        4'd3    : HREADYOUTS = readyout_dec[3];
        4'd4    : HREADYOUTS = readyout_dec[4];
        4'd5    : HREADYOUTS = readyout_dec[5];
        4'd6    : HREADYOUTS = readyout_dec[6];
        4'd7    : HREADYOUTS = readyout_dec[7];
        4'd8    : HREADYOUTS = readyout_dec[8];
        4'd9    : HREADYOUTS = readyout_dec[9];
        4'd10   : HREADYOUTS = readyout_dec[10];
        4'd11   : HREADYOUTS = readyout_dec[11];
        4'd12   : HREADYOUTS = readyout_dec[12];
        4'd13   : HREADYOUTS = readyout_dec[13];
        4'd14   : HREADYOUTS = readyout_dec[14];
        4'd15   : HREADYOUTS = readyout_dft_slv;    // Select the default slave
        default : HREADYOUTS = 1'bz;
      endcase 
    end 


  // HRESPS output decode
  always@(resp_dft_slv or resp_dec or data_out_port)
    begin
      case (data_out_port)
        4'd0    : HRESPS = resp_dec[1:0];
        4'd1    : HRESPS = resp_dec[3:2];
        4'd2    : HRESPS = resp_dec[5:4];
        4'd3    : HRESPS = resp_dec[7:6];
        4'd4    : HRESPS = resp_dec[9:8];
        4'd5    : HRESPS = resp_dec[11:10];
        4'd6    : HRESPS = resp_dec[13:12];
        4'd7    : HRESPS = resp_dec[15:14];
        4'd8    : HRESPS = resp_dec[17:16];
        4'd9    : HRESPS = resp_dec[19:18];
        4'd10   : HRESPS = resp_dec[21:20];
        4'd11   : HRESPS = resp_dec[23:22];
        4'd12   : HRESPS = resp_dec[25:24];
        4'd13   : HRESPS = resp_dec[27:26];
        4'd14   : HRESPS = resp_dec[29:28];
        4'd15   : HRESPS = resp_dft_slv;     // Select the default slave
        default : HRESPS = 2'bz;
      endcase 
    end


  // HRDATAS output decode
  always@(*)//rdata_dec or  data_out_port or hwrite)
    begin
      if(!HRESETn)
        HRDATAS = 32'd0;
     
      else
        begin
          if(hwrite==0 && active_dec[data_out_port])
            begin
              case (data_out_port)
              4'd0    : HRDATAS = rdata_dec[31:0];
              4'd1    : HRDATAS = rdata_dec[63:32];
              4'd2    : HRDATAS = rdata_dec[95:64];
              4'd3    : HRDATAS = rdata_dec[127:96];
              4'd4    : HRDATAS = rdata_dec[159:128];
              4'd5    : HRDATAS = rdata_dec[191:160];
              4'd6    : HRDATAS = rdata_dec[223:192];
              4'd7    : HRDATAS = rdata_dec[255:224];
              4'd8    : HRDATAS = rdata_dec[287:256];
              4'd9    : HRDATAS = rdata_dec[319:288];
              4'd10   : HRDATAS = rdata_dec[351:320];
              4'd11   : HRDATAS = rdata_dec[383:352];
              4'd12   : HRDATAS = rdata_dec[415:384];
              4'd13   : HRDATAS = rdata_dec[447:416];
              4'd14   : HRDATAS = rdata_dec[479:448];
              4'd15   : HRDATAS = 32'b0;   // Select the default slave
              default : HRDATAS = 32'bz;
              endcase
          end
        end
    end

  assign HREADYIN = HREADYS;

  endmodule