///////////////////////////////env.sv/////////////////////////////////
	class env extends uvm_env;

     	`uvm_component_utils(env)

	    mas_agent mas_agt[];
        slv_agent slv_agt[];

        slv_agent_config scfg[];
		mas_agent_config mcfg[];
		
		//vir_sequencer vir_seqr;
		
		mas_agent_top mas_top;
		slv_agent_top slv_top;

		scoreboard sb;
		
		subscriber subs;

        env_config cfg;

extern function new(string name = "env", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass: env

	function env::new(string name = "env", uvm_component parent);
		super.new(name,parent);
	endfunction

    function void env::build_phase(uvm_phase phase);
       super.build_phase(phase);
 
	  if(!uvm_config_db #(env_config)::get(this,"","env_config",cfg))
		`uvm_fatal("get_type_name()","cannot get() cfg from uvm_config_db. Have you set() it?")

               mcfg=new[cfg.no_of_mas];
                scfg=new[cfg.no_of_slv];				
		
                slv_agt = new[cfg.no_of_slv];
                mas_agt = new[cfg.no_of_mas];
				
				mas_top=mas_agent_top::type_id::create("mas_top", this);
		        slv_top=slv_agent_top::type_id::create("slv_top", this);

              /* if(cfg.has_vir_seqr)
                   begin
	                vir_seqr=vir_seqr::type_id::create("vir_seqr",this);
                   end
*/
               if(cfg.has_scoreboard)
                  begin
                sb=scoreboard::type_id::create("sb",this);	                       			   
                subs=subscriber::type_id::create("subs",this);
               end
		endfunction

 
   		function void env::connect_phase(uvm_phase phase);
                     /* if(cfg.has_vir_seqr) 
                        begin
                           foreach(vir_seqr.mas_seqr[i])
										    begin
                                              vir_seqr.mas_seqr[i] =mas_top.mas_agt[i].mas_seqr;
                                           end
								
                           foreach(vir_seqr.slv_seqr[i])
										    begin
                                              vir_seqr.slv_seqr[i] =slv_top.slv_agt[i].slv_seqr;
                                           end

                        end
       */

   		              if(cfg.has_scoreboard) 
                                        begin
										  foreach(mcfg[i])
										    begin
                                              mas_top.m_agnth[i].monh.m_mon2sb.connect(sb.fifo_mas[i].analysis_export); 
 			     							  end										
										  foreach(scfg[i])
										    begin
                                              slv_top.s_agnth[i].monh.s_mon2sb.connect(sb.fifo_slv[i].analysis_export);
			                        		end
					
   		             
                                      					
										  foreach(mcfg[i])
										    begin
                                              mas_top.m_agnth[i].monh.m_mon2sb.connect(subs.fifo_mas_duv[i].analysis_export);
                                             end										

										  foreach(scfg[i])
										    begin
                                              slv_top.s_agnth[i].monh.s_mon2sb.connect(subs.fifo_slv_duv[i].analysis_export);
					                        end	
                                         end											
										
			endfunction