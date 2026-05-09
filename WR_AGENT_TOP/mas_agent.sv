  /////////////////////////mas_agent.sv//////////////////////////////
  	class mas_agent extends uvm_agent;

   // Factory Registration
	`uvm_component_utils(mas_agent)

   // Declare handle for configuration object
        mas_agent_config m_cfg;
       
   // Declare handles of master_monitor,master_sequencer and master_driver
   // with Handle names as monh, m_seqrh, drvh respectively
	master_monitor monh;
	master_sequencer m_seqrh;
	master_driver drvh;

//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
  extern function new(string name = "mas_agent", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : mas_agent
//-----------------  constructor new method  -------------------//

       function mas_agent::new(string name = "mas_agent", 
                               uvm_component parent = null);
         super.new(name, parent);
       endfunction
     
  
//-----------------  build() phase method  -------------------//
         // Call parent build phase
         // Create master_monitor instance
         // If is_active=UVM_ACTIVE, create master_driver and master_sequencer instances
	function void mas_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);

                // get the config object using uvm_config_db 
	  if(!uvm_config_db #(mas_agent_config)::get(this,"","mas_agent_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
	        monh=master_monitor::type_id::create("monh",this);	
		if(m_cfg.is_active==UVM_ACTIVE)
		begin
		drvh=master_driver::type_id::create("drvh",this);
		m_seqrh=master_sequencer::type_id::create("m_seqrh",this);
		end
	endfunction

      
//-----------------  connect() phase method  -------------------//
	//If is_active=UVM_ACTIVE, 
        //connect driver(TLM seq_item_port) and sequencer(TLM seq_item_export)
      
	function void mas_agent::connect_phase(uvm_phase phase);
		if(m_cfg.is_active==UVM_ACTIVE)
		begin
		drvh.seq_item_port.connect(m_seqrh.seq_item_export);
  		end
	endfunction