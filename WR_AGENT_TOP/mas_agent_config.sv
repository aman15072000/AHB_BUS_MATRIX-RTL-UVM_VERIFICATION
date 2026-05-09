	/////////////////////mas_agent_config.sv////////////////////////
 class mas_agent_config extends uvm_object;

	 `uvm_object_utils(mas_agent_config)

          bit is_active; 
          virtual mas_interface m_if;
          static int mon_data_count=0;
          static int drv_data_count=0;
	extern function new(string name = "mas_agent_config");

endclass: mas_agent_config

    function mas_agent_config::new(string name="mas_agent_config");
          super.new(name);
    endfunction
	
	
