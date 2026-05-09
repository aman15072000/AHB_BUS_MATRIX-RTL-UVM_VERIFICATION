///////////////////////slave_monitor.sv//////////////////////////
	//import cvw::*;
	
	class slave_monitor extends uvm_monitor;

	`uvm_component_utils(slave_monitor)
   	virtual slv_interface.SLV_MON_MP s_if;

        slv_agent_config s_cfg;

     uvm_analysis_port#(s_xtn) s_mon2sb;

//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
     	
	extern function new(string name ="slave_monitor",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern function void report_phase(uvm_phase phase);

endclass: slave_monitor

//-----------------  constructor new method  -------------------//
 // Define Constructor new() function
	function slave_monitor::new(string name ="slave_monitor",uvm_component parent);
		super.new(name,parent);
		s_mon2sb=new("s_mon2sb",this);		
	endfunction: new

//-----------------  build() phase method  -------------------//
 	function void slave_monitor::build_phase(uvm_phase phase);
          super.build_phase(phase);
	  if(!uvm_config_db #(slv_agent_config)::get(this,"","slv_agent_config",s_cfg))
		`uvm_fatal("CONFIG","cannot get() s_cfg from uvm_config_db. Have you set() it?") 
        endfunction:build_phase


 	function void slave_monitor::connect_phase(uvm_phase phase);
          s_if = s_cfg.s_if;
        endfunction:connect_phase
  

	task slave_monitor::run_phase(uvm_phase phase);

               	forever 
                  begin
                    collect_data();
		end
	endtask:run_phase

//-----------------  task send_to_dut() method  -------------------//

   // Add task send_to_dut(s_xtn handle as an input argument)
	
	task slave_monitor::collect_data();
	   s_xtn xtn;
          xtn=s_xtn::type_id::create("xtn");
    wait(s_if.smon_cb.HREADYOUTM)
	@(s_if.smon_cb);
	
	              xtn.HREADYOUTM=s_if.smon_cb.HREADYOUTM;
                  xtn.HRESPM=s_if.smon_cb.HRESPM;
                 xtn.HWRITEM=s_if.smon_cb.HWRITEM;
				 
                 xtn.HSELM=s_if.smon_cb.HSELM;
                 xtn.HADDRM=s_if.smon_cb.HADDRM; 
                 xtn.HTRANSM=s_if.smon_cb.HTRANSM;   
                 xtn.HSIZEM=s_if.smon_cb.HSIZEM;  
                xtn.HPROTM= s_if.smon_cb.HPROTM;  
                xtn.HMASTERM=s_if.smon_cb.HMASTERM;  
                 xtn.HMASTLOCKM=s_if.smon_cb.HMASTLOCKM; 
                xtn.HREADYM=s_if.smon_cb.HREADYM;  
				  
@(s_if.smon_cb);				  

       if(!s_if.smon_cb.HWRITEM)
	                   xtn.HRDATAM=s_if.smon_cb.HRDATAM; 
      else		
       xtn.HWDATAM=s_if.smon_cb.HWDATAM;	  
		// Print the transaction
          `uvm_info("slave_monitor",$sformatf("printing from monitor \n %s", xtn.sprint()),UVM_LOW)      
	                    s_cfg.mon_data_count++;
						
						s_mon2sb.write(xtn);
endtask:collect_data

  // UVM report_phase
  function void slave_monitor::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: slave monitor sent %0d packets",s_cfg.mon_data_count), UVM_LOW)
  endfunction:report_phase