	///////////////////////apb_agent_config.sv////////////////////////
	class apb_agent_config extends uvm_object;

	 `uvm_object_utils(apb_agent_config)

          bit is_active; 
          virtual apb_interface p_if;
          static int apb_mon_data_count=0;
          static int apb_drv_data_count=0;
	extern function new(string name = "apb_agent_config");

endclass: apb_agent_config

    function apb_agent_config::new(string name="apb_agent_config");
          super.new(name);
    endfunction:new