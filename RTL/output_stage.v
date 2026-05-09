 ///////////////////////////////output_stage.v//////////////////////
    /********************************************************************************************

  Copyright 2024 - Maven Silicon Softech Pvt Ltd.  

  www.maven-silicon.com

  All Rights Reserved.

  This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
  It is not to be shared with or used by any third parties who have not enrolled for our paid 
  training courses or received any written authorization from Maven Silicon.

  Filename                :       output_stage.v   

  module Name             :       output_stage

  Description             :       Depending upon the arbiter address the master data are given to slave as output

  Author Name             :       K Sriguru

  Support e-mail          :       For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

  Version                 :       1.0

  *********************************************************************************************/   



  module output_stage #(parameter N=15)(
                                      // Common AHB signals
                                      input             HCLK,           // AHB system clock
                                      input             HRESETn,        // AHB system reset

                                      // Bus-switch input 0
                                      input      [N-1:0]     sel_op,     // Port  HSEL signal
                                      input      [(N*32)-1:0]addr_op,    // Port  HADDR signal
                                      input      [(N*2)-1:0] trans_op,   // Port  HTRANS signal
                                      input      [N-1:0]     write_op,   // Port  HWRITE signal
                                      input      [(N*3)-1:0] size_op,    // Port  HSIZE signal
                                      input      [(N*3)-1:0] burst_op,   // Port  HBURST signal
                                      input      [(N*4)-1:0] prot_op,    // Port  HPROT signal
                                      input      [(N*4)-1:0] master_op,  // Port  HMASTER signal
                                      input      [N-1:0]     mastlock_op,// Port  HMASTLOCK signal
                                      input      [(N*32)-1:0]wdata_op,   // Port  HWDATA signal
                                      input                  HREADYOUTM, // HREADY feedback from top
                                      input      [N-1:0]     hreadyout,  // hready from master to slave

                                      output reg [N-1:0]     active_op,  // Port  Active signal

                                      // Slave Address/Control Signals
                                      output reg        HSELM,      	 // Slave select line
                                      output reg [31:0] HADDRM,     	 // Address
                                      output reg [1:0]  HTRANSM,    	 // Transfer type
                                      output reg        HWRITEM,    	 // Transfer direction
                                      output reg [2:0]  HSIZEM,     	 // Transfer size
                                      output reg [2:0]  HBURSTM,    	 // Burst type
                                      output reg [3:0]  HPROTM,     	 // Protection control
                                      output reg [3:0]  HMASTERM,   	 // Master ID
                                      output reg        HMASTLOCKM, 	 // Locked transfer
                                      output reg [N-1:0]HREADYMUXM, 	 // Transfer done
                                      output reg [31:0] HWDATAM,     	 // Write data
                                      output reg        HREADYMUXOUT     // Ready out for slave
                                      );


  wire  [3:0]  addr_in_port;  	// Address input port
  reg   [3:0]  data_in_port;  	// Data input port
  wire         no_port;       	// No port selected signal
  reg          slave_sel;       // Slave select signal
  reg 	       i_hreadymuxm;
  reg   [N-1:0]sel_out;


  // Arbiter instance for resolving requests to this output stage
  arbiter #(N) DUV(
                   .HCLK(HCLK),
                   .HRESETn(HRESETn),
                   .req_port(sel_op),

                   .HREADYM(i_hreadymuxm),
                   .HTRANSM(HTRANSM),
                   .HMASTLOCKM(HMASTLOCKM),

                   .addr_in_port(addr_in_port),
                   .no_port(no_port)
                   );


  // Active signal combinatorial decode
  always@(addr_in_port or no_port)
    begin 
      // Default value(s)
      active_op = 'b0;

      // Decode selection when enabled
      if (~no_port)
        begin
          case (addr_in_port)
            4'd0  : active_op[0] = 1'b1;
            4'd1  : active_op[1] = 1'b1;
            4'd2  : active_op[2] = 1'b1;
            4'd3  : active_op[3] = 1'b1;
            4'd4  : active_op[4] = 1'b1;
            4'd5  : active_op[5] = 1'b1;
            4'd6  : active_op[6] = 1'b1;
            4'd7  : active_op[7] = 1'b1;
            4'd8  : active_op[8] = 1'b1;
            4'd9  : active_op[9] = 1'b1;
            4'd10 : active_op[10] = 1'b1;
            4'd11 : active_op[11] = 1'b1;
            4'd12 : active_op[12] = 1'b1;
            4'd13 : active_op[13] = 1'b1;
            4'd14 : active_op[14] = 1'b1;
            default : begin
                        active_op = 'bz;
                      end
          endcase 
       end
    end


  //  Address/control output decode
  always@(sel_op or addr_op or trans_op or write_op or
             size_op or burst_op or prot_op or
             master_op or mastlock_op or addr_in_port or no_port)
    begin
      // Default values
      HSELM       = 1'b0;
      HADDRM      = 32'b0;
      HTRANSM     = 2'b00;
      HWRITEM     = 1'b0;
      HSIZEM      = 3'b000;
      HBURSTM     = 3'b000;
      HPROTM      = 4'b0;
      HMASTERM    = 4'b0000;
      HMASTLOCKM  = 1'b0;
      HREADYMUXOUT= 1'b0;

      // Decode selection when enabled
      if (~no_port)
        case (addr_in_port)
        // Bus-switch input 0
          4'd0 :
            begin
              HSELM       = sel_op[0];
              HADDRM      = addr_op[31:0];
              HTRANSM     = trans_op[1:0];
              HWRITEM     = write_op[0];
              HSIZEM      = size_op[2:0];
              HBURSTM     = burst_op[2:0];
              HPROTM      = prot_op[3:0];
              HMASTERM    = master_op[3:0];
              HMASTLOCKM  = mastlock_op[0];
	      HREADYMUXOUT= hreadyout[0];
            end

          // Bus-switch input 1
          4'd1 :
            begin
              HSELM       = sel_op[1];
              HADDRM      = addr_op[63:32];
              HTRANSM     = trans_op[3:2];
              HWRITEM     = write_op[1];
              HSIZEM      = size_op[5:3];
              HBURSTM     = burst_op[5:3];
              HPROTM      = prot_op[7:4];
              HMASTERM    = master_op[7:4];
              HMASTLOCKM  = mastlock_op[1];
	      HREADYMUXOUT= hreadyout[1];
            end

	  // Bus-switch input 2
          4'd2 :
            begin
              HSELM       = sel_op[2];
              HADDRM      = addr_op[95:64];
              HTRANSM     = trans_op[5:4];
              HWRITEM     = write_op[2];
              HSIZEM      = size_op[8:6];
              HBURSTM     = burst_op[8:6];
              HPROTM      = prot_op[11:8];
              HMASTERM    = master_op[11:8];
              HMASTLOCKM  = mastlock_op[2];
	      HREADYMUXOUT= hreadyout[2];
            end

          // Bus-switch input 3
          4'd3 :
            begin
              HSELM       = sel_op[3];
              HADDRM      = addr_op[127:96];
              HTRANSM     = trans_op[7:6];
              HWRITEM     = write_op[3];
              HSIZEM      = size_op[11:9];
              HBURSTM     = burst_op[11:9];
              HPROTM      = prot_op[15:12];
              HMASTERM    = master_op[15:12];
              HMASTLOCKM  = mastlock_op[3];
	      HREADYMUXOUT= hreadyout[3];
            end

	  // Bus-switch input 4
          4'd4 :
            begin
              HSELM       = sel_op[4];
              HADDRM      = addr_op[159:128];
              HTRANSM     = trans_op[9:8];
              HWRITEM     = write_op[4];
              HSIZEM      = size_op[14:12];
              HBURSTM     = burst_op[14:12];
              HPROTM      = prot_op[19:16];
              HMASTERM    = master_op[19:16];
              HMASTLOCKM  = mastlock_op[4];
	      HREADYMUXOUT= hreadyout[4];
            end

          // Bus-switch input 5
          4'd5 :
            begin
              HSELM       = sel_op[5];
              HADDRM      = addr_op[191:160];
              HTRANSM     = trans_op[11:10];
              HWRITEM     = write_op[5];
              HSIZEM      = size_op[17:15];
              HBURSTM     = burst_op[17:15];
              HPROTM      = prot_op[23:20];
              HMASTERM    = master_op[23:20];
              HMASTLOCKM  = mastlock_op[5];
	      HREADYMUXOUT= hreadyout[5];
            end

	  // Bus-switch input 6
          4'd6 :
            begin
              HSELM       = sel_op[6];
              HADDRM      = addr_op[223:192];
              HTRANSM     = trans_op[13:12];
              HWRITEM     = write_op[6];
              HSIZEM      = size_op[20:18];
              HBURSTM     = burst_op[20:18];
              HPROTM      = prot_op[27:24];
              HMASTERM    = master_op[27:24];
              HMASTLOCKM  = mastlock_op[6];
	      HREADYMUXOUT= hreadyout[6];
            end

          // Bus-switch input 7
          4'd7 :
            begin
              HSELM       = sel_op[7];
              HADDRM      = addr_op[255:224];
              HTRANSM     = trans_op[15:14];
              HWRITEM     = write_op[7];
              HSIZEM      = size_op[23:21];
              HBURSTM     = burst_op[23:21];
              HPROTM      = prot_op[31:28];
              HMASTERM    = master_op[31:28];
              HMASTLOCKM  = mastlock_op[7];
	      HREADYMUXOUT= hreadyout[7];
            end

	  // Bus-switch input 8
          4'd8 :
            begin
              HSELM       = sel_op[8];
              HADDRM      = addr_op[287:256];
              HTRANSM     = trans_op[17:16];
              HWRITEM     = write_op[8];
              HSIZEM      = size_op[26:24];
              HBURSTM     = burst_op[26:24];
              HPROTM      = prot_op[35:32];
              HMASTERM    = master_op[35:32];
              HMASTLOCKM  = mastlock_op[8];
	      HREADYMUXOUT= hreadyout[8];
            end

          // Bus-switch input 9
          4'd9 :
            begin
              HSELM       = sel_op[9];
              HADDRM      = addr_op[319:288];
              HTRANSM     = trans_op[19:18];
              HWRITEM     = write_op[9];
              HSIZEM      = size_op[29:27];
              HBURSTM     = burst_op[29:27];
              HPROTM      = prot_op[39:36];
              HMASTERM    = master_op[39:36];
              HMASTLOCKM  = mastlock_op[9];
	      HREADYMUXOUT= hreadyout[9];
            end

	  // Bus-switch input 10
          4'd10 :
            begin
              HSELM       = sel_op[10];
              HADDRM      = addr_op[351:320];
              HTRANSM     = trans_op[21:20];
              HWRITEM     = write_op[10];
              HSIZEM      = size_op[32:30];
              HBURSTM     = burst_op[32:30];
              HPROTM      = prot_op[43:40];
              HMASTERM    = master_op[43:40];
              HMASTLOCKM  = mastlock_op[10];
	      HREADYMUXOUT= hreadyout[10];
            end

          // Bus-switch input 11
          4'd11 :
            begin
              HSELM       = sel_op[11];
              HADDRM      = addr_op[383:352];
              HTRANSM     = trans_op[23:22];
              HWRITEM     = write_op[11];
              HSIZEM      = size_op[35:33];
              HBURSTM     = burst_op[35:33];
              HPROTM      = prot_op[47:44];
              HMASTERM    = master_op[47:44];
              HMASTLOCKM  = mastlock_op[11];
	      HREADYMUXOUT= hreadyout[11];
            end

	  // Bus-switch input 12
          4'd12 :
            begin
              HSELM       = sel_op[12];
              HADDRM      = addr_op[415:384];
              HTRANSM     = trans_op[25:24];
              HWRITEM     = write_op[12];
              HSIZEM      = size_op[38:36];
              HBURSTM     = burst_op[38:36];
              HPROTM      = prot_op[51:48];
              HMASTERM    = master_op[51:48];
              HMASTLOCKM  = mastlock_op[12];
	      HREADYMUXOUT= hreadyout[12];
            end

          // Bus-switch input 13
          4'd13 :
            begin
              HSELM       = sel_op[13];
              HADDRM      = addr_op[447:416];
              HTRANSM     = trans_op[27:26];
              HWRITEM     = write_op[13];
              HSIZEM      = size_op[41:39];
              HBURSTM     = burst_op[41:39];
              HPROTM      = prot_op[55:52];
              HMASTERM    = master_op[55:52];
              HMASTLOCKM  = mastlock_op[13];
	      HREADYMUXOUT= hreadyout[13];
            end

	  // Bus-switch input 14
          4'd14 :
            begin
              HSELM       = sel_op[14];
              HADDRM      = addr_op[479:448];
              HTRANSM     = trans_op[29:28];
              HWRITEM     = write_op[14];
              HSIZEM      = size_op[44:42];
              HBURSTM     = burst_op[44:42];
              HPROTM      = prot_op[59:56];
              HMASTERM    = master_op[59:56];
              HMASTLOCKM  = mastlock_op[14];
	      HREADYMUXOUT= hreadyout[14];
            end

          default :
            begin
              HSELM       = 1'bz;
              HADDRM      = 32'bz;
              HTRANSM     = 2'bz;
              HWRITEM     = 1'bz;
              HSIZEM      = 3'bz;
              HBURSTM     = 3'bz;
              HPROTM      = 4'bz;
              HMASTERM    = 4'bz;
              HMASTLOCKM  = 1'bz;
	      HREADYMUXOUT= 1'bz;
            end
        endcase 
  end


  // Dataport register
  always@(negedge HRESETn or posedge HCLK)
    begin 
      if(~HRESETn)
        data_in_port <= 4'b0;

      else
        if(i_hreadymuxm)
          data_in_port <= addr_in_port;
    end


  // HWDATAM output decode
  always@(wdata_op or data_in_port or sel_op)
    begin
      // Default value
      HWDATAM = 32'b0;

    if(sel_op[data_in_port])
      // Decode selection
      if(write_op[data_in_port])
        case (data_in_port)
          4'd0    : HWDATAM = wdata_op[31:0];
          4'd1    : HWDATAM = wdata_op[63:32];
          4'd2    : HWDATAM = wdata_op[95:64];
          4'd3    : HWDATAM = wdata_op[127:96];
          4'd4    : HWDATAM = wdata_op[159:128];
          4'd5    : HWDATAM = wdata_op[191:160];
          4'd6    : HWDATAM = wdata_op[223:192];
          4'd7    : HWDATAM = wdata_op[255:224];
          4'd8    : HWDATAM = wdata_op[287:256];
          4'd9    : HWDATAM = wdata_op[319:288];
          4'd10   : HWDATAM = wdata_op[351:320];
          4'd11   : HWDATAM = wdata_op[383:352];
          4'd12   : HWDATAM = wdata_op[415:384];
          4'd13   : HWDATAM = wdata_op[447:416];
          4'd14   : HWDATAM = wdata_op[479:448];
          default : HWDATAM = 32'b0;
      	endcase 
    end


  // The HREADY signal on the shared slave is generated directly from
  //  the shared slave HREADYOUTS if the slave is selected, otherwise
  //  it mirrors the HREADY signal of the appropriate input port
  /*always@(negedge HRESETn or posedge HCLK)
    begin
      if (~HRESETn)
        slave_sel <= 1'b0;

      else
        begin
          //if(i_hreadymuxm)
            slave_sel  <= HSELM;
	  
	  // Drive output with internal version of the signal
	  HREADYMUXM[addr_in_port] = i_hreadymuxm;
	end
    end*/

  always@(*)//negedge HRESETn or posedge HCLK)
    begin

          //if(i_hreadymuxm)
            slave_sel  <= HSELM;

          i_hreadymuxm <= (slave_sel) ? HREADYOUTM : 1'b1;
          // Drive output with internal version of the signal
          HREADYMUXM[addr_in_port] <= i_hreadymuxm;
    end


  // HREADYMUXM output selection
  //assign i_hreadymuxm = (slave_sel) ? HREADYOUTM : 1'b1;

  // Drive output with internal version of the signal
  //assign HREADYMUXM[addr_in_port] = i_hreadymuxm;


  endmodule