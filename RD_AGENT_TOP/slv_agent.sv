/////////////////////slv_agent.sv////////////////////////
class slv_agent extends uvm_agent;

   // Factory Registration
	`uvm_component_utils(slv_agent)

   // Declare handle for configuration object
        slv_agent_config s_cfg;
       
   // Declare handles of slave_monitor,slave_sequencer and slave_driver
   // with Handle names as monh, s_seqrh, drvh respectively
	slave_monitor monh;
	slave_sequencer s_seqrh;
	slave_driver drvh;

//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
  extern function new(string name = "slv_agent", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : slv_agent
//-----------------  constructor new method  -------------------//

       function slv_agent::new(string name = "slv_agent", uvm_component parent = null);
         super.new(name, parent);
       endfunction : new
     
  
//-----------------  build() phase method  -------------------//
         // Call parent build phase
         // Create slave_monitor instance
         // If is_active=UVM_ACTIVE, create slave_driver and slave_sequencer instances
	function void slv_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);

                // get the config object using uvm_config_db 
	  if(!uvm_config_db #(slv_agent_config)::get(this,"","slv_agent_config",s_cfg))
		`uvm_fatal("CONFIG","cannot get() s_cfg from uvm_config_db. Have you set() it?") 
	        monh=slave_monitor::type_id::create("monh",this);	
		if(s_cfg.is_active==UVM_ACTIVE)
		begin
		drvh=slave_driver::type_id::create("drvh",this);
		s_seqrh=slave_sequencer::type_id::create("s_seqrh",this);
		end
	endfunction : build_phase

      
//-----------------  connect() phase method  -------------------//
	//If is_active=UVM_ACTIVE, 
        //connect driver(TLM seq_item_port) and sequencer(TLM seq_item_export)
      
	function void slv_agent::connect_phase(uvm_phase phase);
		if(s_cfg.is_active==UVM_ACTIVE)
		begin
		drvh.seq_item_port.connect(s_seqrh.seq_item_export);
  		end
	endfunction : connect_phase