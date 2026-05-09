////////////////////////////////env_config.sv//////////////////////////////
class env_config extends uvm_object;

	`uvm_object_utils(env_config)

          bit has_mas_agent=1;
          bit has_slv_agent=1;

         int no_of_mas=15;
         int no_of_slv=15;
		 
		 int has_scoreboard=1;
         //int has_vir_seqr=1;

	slv_agent_config scfg[];
	mas_agent_config mcfg[];
	
	//bit [2:0]hburst;
	//logic [2:0]burst,size;

	extern function new(string name = "env_config");

endclass: env_config

function env_config::new(string name = "env_config");
  super.new(name);
endfunction