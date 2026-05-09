  ///////////////////////////slave_driver.sv/////////////////////////////
  	class slave_driver extends uvm_driver #(s_xtn);

	`uvm_component_utils(slave_driver)
   	virtual slv_interface.SLV_DRV_MP s_if;

        slv_agent_config s_cfg;



//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
     	
	extern function new(string name ="slave_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(s_xtn xtn);
	extern function void report_phase(uvm_phase phase);
endclass:slave_driver

//-----------------  constructor new method  -------------------//
 // Define Constructor new() function
	function slave_driver::new(string name ="slave_driver",uvm_component parent);
		super.new(name,parent);
	endfunction:new

//-----------------  build() phase method  -------------------//
 	function void slave_driver::build_phase(uvm_phase phase);
          super.build_phase(phase);
	  if(!uvm_config_db #(slv_agent_config)::get(this,"","slv_agent_config",s_cfg))
		`uvm_fatal("CONFIG","cannot get() s_cfg from uvm_config_db. Have you set() it?") 
        endfunction:build_phase


 	function void slave_driver::connect_phase(uvm_phase phase);
          s_if = s_cfg.s_if;
        endfunction:connect_phase
  

	task slave_driver::run_phase(uvm_phase phase);
               	forever 
                  begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
		end
	endtask:run_phase

task slave_driver::send_to_dut(s_xtn xtn);
  //@(s_if.sdrv_cb);

  s_if.sdrv_cb.resp <= xtn.resp;

  case (xtn.resp)

    2'd0: begin  // OKAY
      s_if.sdrv_cb.HREADYOUTM <= 1'b1;
      s_if.sdrv_cb.HRESPM    <= xtn.HRESPM;

      if (!s_if.sdrv_cb.HWRITEM)
        s_if.sdrv_cb.HRDATAM <= xtn.HRDATAM;

      @(s_if.sdrv_cb);
    end

    2'd1: begin  // WAIT RESPONSE
     if(s_if.sdrv_cb.HWRITEM)
	  begin		
	  s_if.sdrv_cb.HREADYOUTM <= 1'b0;
      repeat (xtn.delay_cycles)
        @(s_if.sdrv_cb);

      s_if.sdrv_cb.HREADYOUTM <= 1'b1;
      s_if.sdrv_cb.HRESPM    <= 2'b0;

      @(s_if.sdrv_cb);    
      @(s_if.sdrv_cb);
      s_if.sdrv_cb.HREADYOUTM <= 1'b0;
     end
	else if(s_if.sdrv_cb.HWRITEM == 0) 
	 begin
			s_if.sdrv_cb.HREADYOUTM <= 1'b0;
			repeat(xtn.delay_cycles)
			@(s_if.sdrv_cb);
			s_if.sdrv_cb.HREADYOUTM <= 1'b1;
			s_if.sdrv_cb.HRESPM <= 2'b0;
			if(s_if.sdrv_cb.HREADYM)
     			begin
				s_if.sdrv_cb.HRDATAM <= xtn.HRDATAM;
			   end
			@(s_if.sdrv_cb);
			@(s_if.sdrv_cb);
			s_if.sdrv_cb.HREADYOUTM <= 1'b0;
		end
	end
 

    2'd2: begin  // ERROR RESPONSE
     begin
            // Write Path
    if (s_if.sdrv_cb.HWRITEM) 
	 begin 
	  @(s_if.sdrv_cb);
      if (s_if.sdrv_cb.HTRANSM == 2'b10)
    	  begin
        s_if.sdrv_cb.HREADYOUTM <= 1'b0;
        s_if.sdrv_cb.HRESPM    <= 2'b01;  //ERROR RESPONSE
        @(s_if.sdrv_cb);
        s_if.sdrv_cb.HREADYOUTM <= 1'b1;
		@(s_if.sdrv_cb);
        @(s_if.sdrv_cb);
            s_if.sdrv_cb.HREADYOUTM <= 1'b0;
      end
	  else 
	           begin
                    s_if.sdrv_cb.HREADYOUTM <= 1'b1;
                    s_if.sdrv_cb.HRESPM     <= 2'b0;
                    @(s_if.sdrv_cb);
                    s_if.sdrv_cb.HRDATAM    <= 32'd0;
                    @(s_if.sdrv_cb);
                end

    end
        else if (s_if.sdrv_cb.HWRITEM == 0) 
		    begin
                @(s_if.sdrv_cb);
                // Check if Transfer type is NONSEQ (2'b10)
                if (s_if.sdrv_cb.HTRANSM == 2'b10) 
				begin
                    s_if.sdrv_cb.HREADYOUTM <= 1'b0;
                    s_if.sdrv_cb.HRESPM     <= 2'b01; // ERROR Response
                    @(s_if.sdrv_cb);
                    s_if.sdrv_cb.HREADYOUTM <= 1'b1;
                    @(s_if.sdrv_cb);
                    s_if.sdrv_cb.HREADYOUTM <= 1'b0;
                end
                else 
				begin
                    // Standard OKAY response for other transfer types
                    s_if.sdrv_cb.HREADYOUTM <= 1'b1;
                    s_if.sdrv_cb.HRESPM     <= 2'b0; // OKAY Response
                    @(s_if.sdrv_cb);
                end
            end
        end
    end   
  endcase

  `uvm_info("SLV_DRV",
    $sformatf("printing from driver\n%s", xtn.sprint()),
    UVM_LOW)

  s_cfg.drv_data_count++;
endtask:send_to_dut

// UVM report_phase
  function void slave_driver::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: slave driver sent %0d packets",s_cfg.drv_data_count), UVM_LOW)
  endfunction:report_phase