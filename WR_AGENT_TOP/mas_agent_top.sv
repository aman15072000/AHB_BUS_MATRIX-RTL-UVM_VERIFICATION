	////////////////////mas_agent_top.sv////////////////////////
		class mas_agent_top extends uvm_env;

   // Factory Registration
	`uvm_component_utils(mas_agent_top)
    
   // Create the agent handle
      	 mas_agent m_agnth[];
         env_config e_cfg;
//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
	extern function new(string name = "mas_agent_top" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
  endclass

//-----------------  constructor new method  -------------------//
   // Define Constructor new() function
   	function mas_agent_top::new(string name = "mas_agent_top" , uvm_component parent);
		super.new(name,parent);
	endfunction

    
//-----------------  build() phase method  -------------------//
       	function void mas_agent_top::build_phase(uvm_phase phase);
     		super.build_phase(phase);
          if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
         `uvm_fatal("CONFIG", "cannot get() e_cfg from uvm_config_db. Have you set() it?"
)
        m_agnth = new[e_cfg.no_of_mas];
          foreach(m_agnth[i])
           begin
        
// Create the instance of mas_agent
   		m_agnth[i]=mas_agent::type_id::create($sformatf("m_agnth[%02d]",i),this);
                uvm_config_db #(mas_agent_config)::set(this,$sformatf("m_agnth[%02d]*",i),"mas_agent_config",e_cfg.mcfg[i]);
      end
	endfunction


//-----------------  run() phase method  -------------------//
       // Print the topology
	task mas_agent_top::run_phase(uvm_phase phase);
		uvm_top.print_topology;
	endtask