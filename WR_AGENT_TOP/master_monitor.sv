 ////////////////////////////////master_monitor.sv/////////////////////////////////
	class master_monitor extends uvm_monitor;

	`uvm_component_utils(master_monitor)
   	virtual mas_interface.MAS_MON_MP m_if;

        mas_agent_config m_cfg;
     uvm_analysis_port#(m_xtn) m_mon2sb;


//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
     	
	extern function new(string name ="master_monitor",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	//extern task send_to_dut(m_xtn xtn);
	extern function void report_phase(uvm_phase phase);
	extern task collect_data();
	
endclass

//-----------------  constructor new method  -------------------//
 // Define Constructor new() function
	function master_monitor::new(string name ="master_monitor",uvm_component parent);
		super.new(name,parent);
		m_mon2sb=new("m_mon2sb",this);
	endfunction

//-----------------  build() phase method  -------------------//
 	function void master_monitor::build_phase(uvm_phase phase);
          super.build_phase(phase);
	  if(!uvm_config_db #(mas_agent_config)::get(this,"","mas_agent_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
        endfunction


 	function void master_monitor::connect_phase(uvm_phase phase);
          m_if = m_cfg.m_if;
        endfunction
  

	task master_monitor::run_phase(uvm_phase phase);
             //repeat(4)
			 @(m_if.mmon_cb);

               	forever 
                  begin
                    collect_data();
		end
	endtask

//-----------------  task send_to_dut() method  -------------------//

   // Add task send_to_dut(m_xtn handle as an input argument)
	
	task master_monitor::collect_data();
	    m_xtn xtn;
          xtn=m_xtn::type_id::create("xtn");
          // Add the write logic
            //@(m_if.mmon_cb);
    wait((m_if.mmon_cb.HREADYOUTS) && (m_if.mmon_cb.HRESETn==1) && (m_if.mmon_cb.HTRANSS==2'b10) || (m_if.mmon_cb.HTRANSS==2'b11))
                xtn.REMAP=m_if.mmon_cb.REMAP;  
                 xtn.HSELS=m_if.mmon_cb.HSELS;
                 xtn.HADDRS=m_if.mmon_cb.HADDRS; 
                 xtn.HTRANSS=m_if.mmon_cb.HTRANSS;   
                 xtn.HWRITES=m_if.mmon_cb.HWRITES;
                 xtn.HSIZES=m_if.mmon_cb.HSIZES;  
                 xtn.HBURSTS=m_if.mmon_cb.HBURSTS;  
                xtn.HPROTS= m_if.mmon_cb.HPROTS;  
                xtn.HMASTERS=m_if.mmon_cb.HMASTERS;  
                 xtn.HMASTLOCKS=m_if.mmon_cb.HMASTLOCKS; 
                  xtn.HREADYOUTS=m_if.mmon_cb.HREADYOUTS;
                  xtn.HRESPS=m_if.mmon_cb.HRESPS;
				  
                     @(m_if.mmon_cb);	
        wait(m_if.mmon_cb.HREADYOUTS)
       if(m_if.mmon_cb.HWRITES)
	                   xtn.HWDATAS=m_if.mmon_cb.HWDATAS; 
      else		
       xtn.HRDATAS=m_if.mmon_cb.HRDATAS;	  
		// Print the transaction
          `uvm_info("master_monitor",$sformatf("printing from monitor \n %s", xtn.sprint()),UVM_LOW)      
	                  m_cfg.mon_data_count++;
					  						m_mon2sb.write(xtn);
endtask

  // UVM report_phase
  function void master_monitor::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: master monitor sent %0d packets",m_cfg.drv_data_count), UVM_LOW)
  endfunction