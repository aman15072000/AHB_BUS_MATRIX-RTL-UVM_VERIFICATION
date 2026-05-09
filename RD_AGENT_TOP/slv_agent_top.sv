/////////////////////////slv_agent_top.sv//////////////////////////
class slv_agent_top extends uvm_env;

   // Factory Registration
	`uvm_component_utils(slv_agent_top)
    
   // Create the agent handle
      	 slv_agent s_agnth[];
         env_config e_cfg;
//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
	extern function new(string name = "slv_agent_top" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
  endclass:slv_agent_top

//-----------------  constructor new method  -------------------//
   // Define Constructor new() function
   	function slv_agent_top::new(string name = "slv_agent_top" , uvm_component parent);
		super.new(name,parent);
	endfunction:new

    
//-----------------  build() phase method  -------------------//
       	function void slv_agent_top::build_phase(uvm_phase phase);
     		super.build_phase(phase);
          if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
         `uvm_fatal("CONFIG", "cannot get() e_cfg from uvm_config_db. Have you set() it?"
)
        s_agnth = new[e_cfg.no_of_slv];
          foreach(s_agnth[i])
           begin
        
// Create the instance of slv_agent
   		s_agnth[i]=slv_agent::type_id::create($sformatf("s_agnth[%02d]",i),this);
                uvm_config_db #(slv_agent_config)::set(this,$sformatf("s_agnth[%02d]*",i),"slv_agent_config",e_cfg.scfg[i]);
      end
	endfunction:build_phase


//-----------------  run() phase method  -------------------//
       // Print the topology
	task slv_agent_top::run_phase(uvm_phase phase);
		uvm_top.print_topology;
	endtask:run_phase