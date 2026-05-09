//////////////////////////////////ahb_bus_matrix_top.v//////////////////////
  /********************************************************************************************

  Copyright 2024 - Maven Silicon Softech Pvt Ltd.  

  www.maven-silicon.com

  All Rights Reserved.

  This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
  It is not to be shared with or used by any third parties who have not enrolled for our paid 
  training courses or received any written authorization from Maven Silicon.

  Filename                :       ahb_bus_matrix_top.v   

  module Name             :       ahb_bus_matrix_top

  Description             :       Top module of AHB Bus MAtrix

  Author Name             :       K Sriguru

  Support e-mail          :       For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

  Version                 :       1.0

  *********************************************************************************************/  




  module ahb_bus_matrix_top #(parameter N=15)(
                                             input              HCLK,       // System Clock
                                             input              HRESETn,    // System Reset
                                             input  [(N*4)-1:0] REMAP,	    // REMAP input
                                             input  [N-1:0]     HSELS,      // Slave Select from AHB (1 bit for 2 ip stage)
                                             input  [(N*32)-1:0]HADDRS,     // Address bus from AHB
                                             input  [(N*32)-1:0]HWDATAS,    // Write data
                                             input  [(N*2)-1:0] HTRANSS,    // Transfer type from AHB
                                             input  [N-1:0]     HWRITES,    // Transfer direction from AHB
                                             input  [(N*3)-1:0] HSIZES,     // Transfer size from AHB
                                             input  [(N*3)-1:0] HBURSTS,    // Burst type from AHB
                                             input  [(N*4)-1:0] HPROTS,     // Protection control from AHB
                                             input  [(N*4)-1:0] HMASTERS,   // Master number from AHB
                                             input  [N-1:0]     HMASTLOCKS, // Locked Sequence  from AHB
                                             input  [(N*2)-1:0] HRESPM,     // Input to decode stage from AHB slave
                                             input  [(N*32)-1:0]HRDATAM,    // Input to decode stage from AHB slave
                                             input  [N-1:0]	HREADYOUTM, // Feedback HREADY from AHB slave to master

                                             output [N-1:0]     HREADYOUTS, // HREADYOUT input to AHB master from slave
                                             output [(N*2)-1:0] HRESPS,     // Transfer response to AHB 
                                             output [(N*32)-1:0]HRDATAS,    // read data from slave
                                             output [N-1:0]	HSELM,	    // Slave Select
                                             output [(N*32)-1:0]HADDRM,	    // Address bus
                                             output [(N*2)-1:0] HTRANSM,    // Transfer type
                                             output [N-1:0]	HWRITEM,    // Transfer direction
                                             output [(N*3)-1:0] HSIZEM,	    // Transfer size
                                             output [(N*3)-1:0] HBURSTM,    // Burst type
                                             output [(N*4)-1:0] HPROTM,	    // Protection control
                                             output [(N*4)-1:0] HMASTERM,   // Master Select
                                             output [N-1:0]	HMASTLOCKM, // iLocked Sequence
					     output [(N*32)-1:0]HWDATAM,    // Write data
					     output [N-1:0]	HREADYM	    // Master to slave
                                             );


  wire [N-1:0]       sel_ip;          // HSEL output of ip stage to op stage
  wire [(N*32)-1:0]  addr_ip;         // HADDR output of ip stage to op stage
  wire [(N*2)-1:0]   trans_ip;        // HTRANS output of ip stage to op stage
  wire [N-1:0]       write_ip;        // HWRITE output of ip stage to op stage
  wire [(N*3)-1:0]   size_ip;         // HSIZE output of ip stage to op stage
  wire [(N*3)-1:0]   burst_ip;        // HBURST output of ip stage to op stage
  wire [(N*4)-1:0]   prot_ip;         // HPROT output of ip stage to op stage
  wire [(N*4)-1:0]   master_ip;       // HMASTER output of ip stage to op stage
  wire [N-1:0]       mastlock_ip;     // HMASTLOCK output of ip stage to op stage
  wire [N-1:0]	     hreadym;

  wire [N-1:0]       active_ip;        // active_ip signal from decode stage to ip stage
  wire [N-1:0]       readyout_ip;      // HREADYOUT input from decode stage to ip stage
  wire [(N*2)-1:0]   resp_ip;          // HRESP input from decode stage to ip stage

  wire [N-1:0]       sel_out[N-1:0];   // mem to store sel_out of decode stage 
  reg  [N-1:0]       sel_op[N-1:0];    // wire for op stage from decode stage

  wire [N-1:0]       active_op[N-1:0]; // mem to store active_op of op stage
  reg  [N-1:0]	     active_dec[N-1:0];// wire for decode stage from op stage
  wire  [N-1:0]       hreadymuxm[N-1:0];       // wire for decode stage from op stage
  reg [N-1:0]       hready[N-1:0];       // wire for decode stage from op stage
  wire [N-1:0]       hreadyoutm;       // wire for output stage from decode stage

  integer a,b;

  genvar i;

  generate for(i=0;i<N;i=i+1)
    begin
      input_stage IS (.HCLK(HCLK),
	              .HRESETn(HRESETn),
		      .HSELS(HSELS[i]),                                     /////////top input
		      .HADDRS(HADDRS[((i*32)+32)-1:(i*32)]),                /////////top input
		      .HTRANSS(HTRANSS[((i*2)+2)-1:(i*2)]),                 /////////top input
		      .HWRITES(HWRITES[i]),                                 /////////top input
		      .HSIZES(HSIZES[((i*3)+3)-1:(i*3)]),                   /////////top input
		      .HBURSTS(HBURSTS[((i*3)+3)-1:(i*3)]),                 /////////top input
		      .HPROTS(HPROTS[((i*4)+4)-1:(i*4)]),                   /////////top input
		      .HMASTERS(HMASTERS[((i*4)+4)-1:(i*4)]),               /////////top input
		      .HMASTLOCKS(HMASTLOCKS[i]),                           /////////top input
		      .active_ip(active_ip[i]),                             /////////wire from decode stage
		      .readyout_ip(readyout_ip[i]),                         /////////wire from decode stage
		      .resp_ip(resp_ip[((i*2)+2)-1:(i*2)]),                 /////////wire from decode stage
		      .HREADYOUTS(HREADYOUTS[i]),                           /////////top output
		      .HRESPS(HRESPS[((i*2)+2)-1:(i*2)]),                   /////////top output
		      .sel_ip(sel_ip[i]),                                   /////////to decode stage
		      .addr_ip(addr_ip[((i*32)+32)-1:(i*32)]),              /////////to decode stage & op stage
		      .trans_ip(trans_ip[((i*2)+2)-1:(i*2)]),               /////////to decode stage & op stage
		      .write_ip(write_ip[i]),                               /////////to op stage
		      .size_ip(size_ip[((i*3)+3)-1:(i*3)]),                 /////////to op stage
		      .burst_ip(burst_ip[((i*3)+3)-1:(i*3)]),               /////////to op stage
		      .prot_ip(prot_ip[((i*4)+4)-1:(i*4)]),                 /////////to op stage
		      .master_ip(master_ip[((i*4)+4)-1:(i*4)]),             /////////to op stage
		      .mastlock_ip(mastlock_ip[i]),                         /////////to op stage
		      .HREADYM(hreadym[i])                                  /////////to decode stage
             	      );


      decode_stage#(N) DS(.HCLK(HCLK),
               	          .HRESETn(HRESETn),
  			  .remap(REMAP[((i*4)+4)-1:(i*4)]),                 /////////top input
  			  .HREADYS(hreadym[i]),                             /////////from ip stage
			  .hmaster(master_ip[((i*4)+4)-1:(i*4)]),           /////////from ip stage
			  .sel_dec(sel_ip[i]),                              /////////from ip stage
  			  .decode_addr_dec(addr_ip[((i*32)+32)-1:(i*32)]),  /////////from ip stage
  			  .trans_dec(trans_ip[((i*2)+2)-1:(i*2)]),          /////////from ip stage
  			  .hwrite(write_ip[i]),                             /////////from ip stage
  			  .active_dec(active_dec[i]),                       /////////from op stage
  			  .readyout_dec(hready[i]),                         /////////from op stage
  			  .resp_dec(HRESPM),                                /////////top input
  			  .rdata_dec(HRDATAM),                              /////////top input
  			  .sel_out(sel_out[i]),                             /////////to op stage
  			  .active_decode(active_ip[i]),                     /////////to ip stage [i]
  			  .HREADYOUTS(readyout_ip[i]),                      /////////to ip stage [i]
			  .HRESPS(resp_ip[((i*2)+2)-1:(i*2)]),              /////////to ip stage [i]
  			  .HRDATAS(HRDATAS[((i*32)+32)-1:(i*32)]),          /////////top output	
			  .HREADYIN(hreadyoutm[i])                          /////////to output stage
 		          );
			


      output_stage#(N) OS(.HCLK(HCLK),
	                  .HRESETn(HRESETn),
  			  .sel_op(sel_op[i]),                               /////////from all decode stage
  			  .addr_op(addr_ip),                                /////////from all decode stage
  			  .trans_op(trans_ip),                              /////////from all ip stage
  			  .write_op(write_ip),                              /////////from all ip stage
  			  .size_op(size_ip),                                /////////from all ip stage
  			  .burst_op(burst_ip),                              /////////from all ip stage
  			  .prot_op(prot_ip),                                /////////from all ip stage
  			  .master_op(master_ip),                            /////////from all ip stage
  			  .mastlock_op(mastlock_ip),                        /////////from all ip stage
  			  .wdata_op(HWDATAS),                               /////////from Top
  			  .HREADYOUTM(HREADYOUTM[i]),                       /////////from Top
  			  .hreadyout(hreadyoutm),                           /////////from decode stage
  			  .active_op(active_op[i]),                         /////////to decode stage
  			  .HSELM(HSELM[i]),                                 /////////top output
  			  .HADDRM(HADDRM[((i*32)+32)-1:(i*32)]),            /////////top output
  			  .HTRANSM(HTRANSM[((i*2)+2)-1:(i*2)]),             /////////top output
  			  .HWRITEM(HWRITEM[i]),                             /////////top output
  			  .HSIZEM(HSIZEM[((i*3)+3)-1:(i*3)]),               /////////top output
  			  .HBURSTM(HBURSTM[((i*3)+3)-1:(i*3)]),             /////////top output
  			  .HPROTM(HPROTM[((i*4)+4)-1:(i*4)]),               /////////top output
  			  .HMASTERM(HMASTERM[((i*4)+4)-1:(i*4)]),           /////////top output
  			  .HMASTLOCKM(HMASTLOCKM[i]),                       /////////top output
  			  .HREADYMUXM(hreadymuxm[i]),                       /////////to decode stage
  			  .HREADYMUXOUT(HREADYM[i]),                        /////////top output 
  			  .HWDATAM(HWDATAM[((i*32)+32)-1:(i*32)])           /////////top output
		          );


    end
  endgenerate

  always@(*)
    begin
      for(a=0;a<N;a=a+1)
        begin
          for(b=0;b<N;b=b+1)
	    begin
	      sel_op[a][b]=sel_out[b][a];
	      active_dec[a][b]=active_op[b][a];
	      hready[a][b]=hreadymuxm[b][a];
	    end
        end
    end




  endmodule