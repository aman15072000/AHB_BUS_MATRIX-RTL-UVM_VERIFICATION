 //master_driver.sv
 	class master_driver extends uvm_driver #(m_xtn);

	`uvm_component_utils(master_driver)
   	virtual mas_interface.MAS_DRV_MP m_if;

        mas_agent_config m_cfg;



//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
     	
	extern function new(string name ="master_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(m_xtn xtn);
	extern function void report_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//
 // Define Constructor new() function
	function master_driver::new(string name ="master_driver",uvm_component parent);
		super.new(name,parent);
	endfunction

//-----------------  build() phase method  -------------------//
 	function void master_driver::build_phase(uvm_phase phase);
          super.build_phase(phase);
	  if(!uvm_config_db #(mas_agent_config)::get(this,"","mas_agent_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
        endfunction


 	function void master_driver::connect_phase(uvm_phase phase);
          m_if = m_cfg.m_if;
        endfunction
  

	task master_driver::run_phase(uvm_phase phase);
             @(m_if.mdrv_cb);
                   m_if.mdrv_cb.HRESETn<=0;
                  @(m_if.mdrv_cb);
				  @(m_if.mdrv_cb);
                        m_if.mdrv_cb.HRESETn<=1;

               	forever 
                  begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
		end
	endtask

//-----------------  task send_to_dut() method  -------------------//

   // Add task send_to_dut(m_xtn handle as an input argument)
	
	task master_driver::send_to_dut(m_xtn xtn);
 
          // Add the write logic
            //@(m_if.mdrv_cb);
                m_if.mdrv_cb.REMAP<=xtn.REMAP;  
                m_if.mdrv_cb.HSELS<=xtn.HSELS;
                m_if.mdrv_cb.HADDRS<=xtn.HADDRS; 
                m_if.mdrv_cb.HTRANSS<=xtn.HTRANSS;   
                m_if.mdrv_cb.HWRITES<=xtn.HWRITES;
                m_if.mdrv_cb.HSIZES<=xtn.HSIZES;  
                m_if.mdrv_cb.HBURSTS<=xtn.HBURSTS;  
                m_if.mdrv_cb.HPROTS<=0;  //xtn.HPROTS;
                m_if.mdrv_cb.HMASTERS<=xtn.HMASTERS;  
                m_if.mdrv_cb.HMASTLOCKS<=0;    				
                     @(m_if.mdrv_cb);	
       if(xtn.HSELS)
         wait(m_if.mdrv_cb.HREADYOUTS)
    $display("HREADYOUTS %0d", m_if.mdrv_cb.HREADYOUTS);
       if(m_if.mdrv_cb.HREADYOUTS && xtn.HWRITES)
	                   m_if.mdrv_cb.HWDATAS<=xtn.HWDATAS;  
		// Print the transaction
          `uvm_info("master_driver",$sformatf("printing from driver \n %s", xtn.sprint()),UVM_LOW)      
	                    m_cfg.drv_data_count++;
endtask

  // UVM report_phase
 function void master_driver::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: master driver sent %0d packets",m_cfg.drv_data_count), UVM_LOW)
  endfunction
