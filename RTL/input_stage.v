  ////////////////////////////input_stage.v////////////////////////
    /********************************************************************************************

  Copyright 2024 - Maven Silicon Softech Pvt Ltd.  

  www.maven-silicon.com

  All Rights Reserved.

  This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
  It is not to be shared with or used by any third parties who have not enrolled for our paid 
  training courses or received any written authorization from Maven Silicon.

  Filename                :       input_stage.v   

  module Name             :       input_stage

  Description             :       Register the master data upon the slave access and send to decode stage

  Author Name             :       K Sriguru

  Support e-mail          :       For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

  Version                 :       1.0

  *********************************************************************************************/   




  module input_stage (
                      input            HCLK,            	// System Clock
                      input            HRESETn,         	// System Reset
                      input            HSELS,           	// Slave Select from AHB
                      input      [31:0]HADDRS,          	// Address bus from AHB
                      input      [1:0] HTRANSS,         	// Transfer type from AHB
                      input            HWRITES,         	// Transfer direction from AHB
                      input      [2:0] HSIZES,          	// Transfer size from AHB
                      input      [2:0] HBURSTS,         	// Burst type from AHB
                      input      [3:0] HPROTS,          	// Protection control from AHB
                      input      [3:0] HMASTERS,        	// Master number from AHB
                      input            HMASTLOCKS,      	// Locked Sequence  from AHB
                      input            active_ip,          	// active_ip signal from decode stage
                      input            readyout_ip,        	// HREADYOUT input from decode stage
                      input      [1:0] resp_ip,            	// HRESP input from decode stage

                      output reg       HREADYOUTS,	        // HREADYOUT input
                      output reg [1:0] HRESPS,          	// Transfer response to AHB    
                      output reg       sel_ip,           	// HSEL output
                      output reg [31:0]addr_ip,                 // HADDR output
                      output reg [1:0] trans_ip,                // HTRANS output
                      output reg       write_ip,                // HWRITE output
                      output reg [2:0] size_ip,                 // HSIZE output
                      output reg [2:0] burst_ip,                // HBURST output
                      output reg [3:0] prot_ip,                 // HPROT output
                      output reg [3:0] master_ip,               // HMASTER output
                      output reg       mastlock_ip,             // HMASTLOCK output
		      output reg       HREADYM
                      );


  wire         load_reg;             	// Holding register load flag
  wire         pend_tran;            	// An active transfer cannot complete
  wire         addr_valid;           	// Indicates address phase of valid transfer
  reg 	       data_valid;
  reg   [1:0]  reg_trans;            	// Registered HTRANSS
  reg   [31:0] reg_addr;             	// Registered HADDRS
  reg          reg_write;            	// Registered HWRITES
  reg 	       reg_sel;		  	// Registered HSELS
  reg   [2:0]  reg_size;             	// Registered HSIZES
  reg   [2:0]  reg_burst;            	// Registered HBURSTS
  reg   [3:0]  reg_prot;             	// Registered HPROTS
  reg   [3:0]  reg_master;           	// Registerd HMASTERS
  reg          reg_mastlock;         	// Registered HMASTLOCKS





  always@(negedge HRESETn or posedge HCLK)
    begin
      if (~HRESETn)
        begin
          reg_trans    <= 2'b00;
          reg_addr     <= 32'b0;
          reg_write    <= 1'b0 ;
          reg_size     <= 3'b000;
          reg_burst    <= 3'b000;
          reg_prot     <= 4'b0;
          reg_master   <= 4'b0000;
          reg_mastlock <= 1'b0 ;
          reg_sel      <= 1'b0;
	  HREADYOUTS   <= 1'b0;
        end
	
      else
        begin
          if(load_reg)
            begin
              reg_trans    <= HTRANSS;
              reg_addr     <= HADDRS;
              reg_write    <= HWRITES;
              reg_size     <= HSIZES;
              reg_burst    <= HBURSTS;
              reg_prot     <= HPROTS;
              reg_master   <= HMASTERS;
              reg_mastlock <= HMASTLOCKS;
              reg_sel      <= HSELS;
            end
        end
  end


  // addr_valid indicates the address phase of an active (non-BUSY/IDLE)
  // transfer to this slave port
  assign addr_valid = (HSELS & HTRANSS[1]);

  // The holding register is loaded whenever there is a transfer on the input
  // port which is validated by active signal 
  assign load_reg = (addr_valid & active_ip);

  // data_valid register
  // addr_valid indicates the data phase of an active 
  // transfer to this slave port. A valid response (HREADY, HRESP) must be
  // generated
  always@(negedge HRESETn or posedge HCLK)
  begin
    if (~HRESETn)
      data_valid <= 1'b0;

    else
      if (readyout_ip)
        data_valid  <= addr_valid;
  end

  // pend_tran indicates that an active transfer presented to this
  // slave cannot complete immediately.  

  assign pend_tran = (load_reg & (~active_ip)) ? 1'b1 :(active_ip & readyout_ip) ? 1'b0 : pend_tran;


  always@(*)
  begin
    if(~pend_tran)
      begin
        sel_ip      = HSELS;
        trans_ip    = HTRANSS;
        addr_ip     = HADDRS;
        write_ip    = HWRITES;
        size_ip     = HSIZES;
        burst_ip    = HBURSTS;
        prot_ip     = HPROTS;
        master_ip   = HMASTERS;
        mastlock_ip = HMASTLOCKS;
        HREADYM	    = readyout_ip;
      end
	
    else
      begin
        sel_ip      = reg_sel;
        trans_ip    = reg_trans;
        addr_ip     = reg_addr;
        write_ip    = reg_write;
        size_ip     = reg_size;
        burst_ip    = reg_burst;
        prot_ip     = reg_prot;
        master_ip   = reg_master;
        mastlock_ip = reg_mastlock;
        HREADYM	    = readyout_ip;
      end
  end

  always@(data_valid or pend_tran or readyout_ip or resp_ip)
  begin
    if (~data_valid)
      begin
        HREADYOUTS = readyout_ip;
        HRESPS     = 2'b00;
      end

    else if (pend_tran)
      begin
        HREADYOUTS = 1'b0;
        HRESPS     = 2'b00;
      end
      
    else
      begin
        HREADYOUTS = readyout_ip;
        HRESPS     = resp_ip;
      end
  end

  endmodule