//////////////////////////test.sv////////////////////////////////
	class test extends uvm_test;
	
	`uvm_component_utils(test)
    	
		env envh;
        env_config cfg;
		
        mas_agent_config mcfg[];
        slv_agent_config scfg[];
		
         bit has_mas_agent=1;
         bit has_slv_agent=1;
		  
        int no_of_mas = 15;
        int no_of_slv = 15;
		 
		 //int has_scoreboard = 1;
         //int has_vir_seqr = 1;

	/*extern function new(string name = "test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	function void end_of_elaboration_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase); 
	//extern function void config_router();*/
   


   	function new(string name = "test" , uvm_component parent);
		super.new(name,parent);
	endfunction


	function void build_phase(uvm_phase phase);
     		super.build();

	        cfg=env_config::type_id::create("cfg");

                mcfg=new[no_of_mas];
                scfg=new[no_of_slv];				
		
                cfg.scfg = new[no_of_slv];
                cfg.mcfg = new[no_of_mas];


	        foreach(mcfg[i]) 
                    begin
                mcfg[i]=mas_agent_config::type_id::create($sformatf("mcfg[%0d]", i));
				mcfg[i].is_active = UVM_ACTIVE;
	            if(!uvm_config_db #(virtual mas_interface)::get(this,"",$sformatf("mvif[%0d]",i),mcfg[i].m_if))
		            `uvm_fatal("get_type_name()","cannot get()interface master from uvm_config_db. Have you set() it?") 

                cfg.mcfg[i] = mcfg[i]; 
                end
          

	        foreach(scfg[i]) 
                    begin
                scfg[i]=slv_agent_config::type_id::create($sformatf("scfg[%0d]", i));
				scfg[i].is_active = UVM_ACTIVE;
	            if(!uvm_config_db #(virtual slv_interface)::get(this,"",$sformatf("svif[%0d]",i),scfg[i].s_if))
		              `uvm_fatal("get_type_name()","cannot get()interface slave from uvm_config_db. Have you set() it?") 

                cfg.scfg[i] = scfg[i];
                end

               cfg.no_of_slv = no_of_slv;
               cfg.no_of_mas = no_of_mas;
				/*cfg.has_scoreboard = has_scoreboard;
                cfg.has_vir_seqr = has_vir_seqr;*/				
                cfg.has_slv_agent = has_slv_agent;
               cfg.has_mas_agent = has_mas_agent;
 

	 	uvm_config_db #(env_config)::set(this,"*","env_config",cfg);

            
		envh=env::type_id::create("envh", this);
	endfunction
	
	/*function void end_of_elaboration_phase(uvm_phase phase);
	   uvm_top.print_topology();
	    endfunction*/
		
	task run_phase(uvm_phase phase);
	slave1_seqs m_seqs1;
	slv_write_seq s_seq11;
	
	slave2_seqs m_seqs2;
	slv_write_seq s_seq12;
	
	slave3_seqs m_seqs3;
	slv_write_seq s_seq13;
	
	slave4_seqs m_seqs4;
	slv_write_seq s_seq14;
	
	slave5_seqs m_seqs5;
	slv_write_seq s_seq15;
	
	slave6_seqs m_seqs6;
	slv_write_seq s_seq16;
	
	slave7_seqs m_seqs7;
	slv_write_seq s_seq17;
	
	slave8_seqs m_seqs8;
	slv_write_seq s_seq18;
	
	slave9_seqs m_seqs9;
	slv_write_seq s_seq19;
	
	slave10_seqs m_seqs10;
	slv_write_seq s_seq20;
	
	slave11_seqs m_seqs11;
	slv_write_seq s_seq21;
	
	slave12_seqs m_seqs12;
	slv_write_seq s_seq22;
	
	slave13_seqs m_seqs13;
	slv_write_seq s_seq23;
	
	slave14_seqs m_seqs14;
	slv_write_seq s_seq24;
	
	slave15_seqs m_seqs15;
	slv_write_seq s_seq25;
	
	slave16_seqs m_seqs16;
	slv_write_seq s_seq26;
	
	      phase.raise_objection(this);
		  m_seqs1=slave1_seqs::type_id::create("m_seqs1");
		  s_seq11=slv_write_seq::type_id::create("s_seq11");
		  
		  m_seqs2=slave2_seqs::type_id::create("m_seqs2");
		  s_seq12=slv_write_seq::type_id::create("s_seq12");
		  
		  m_seqs3=slave3_seqs::type_id::create("m_seqs3");
		  s_seq13=slv_write_seq::type_id::create("s_seq13");
		  
		  m_seqs4=slave4_seqs::type_id::create("m_seqs4");
		  s_seq14=slv_write_seq::type_id::create("s_seq14");
		  
		  m_seqs5=slave5_seqs::type_id::create("m_seqs5");
		  s_seq15=slv_write_seq::type_id::create("s_seq15");
		  
		  m_seqs6=slave6_seqs::type_id::create("m_seqs6");
		  s_seq16=slv_write_seq::type_id::create("s_seq16");
		  
		  m_seqs7=slave7_seqs::type_id::create("m_seqs7");
		  s_seq17=slv_write_seq::type_id::create("s_seq17");
		  
		  m_seqs8=slave8_seqs::type_id::create("m_seqs8");
		  s_seq18=slv_write_seq::type_id::create("s_seq18");
		  
		  m_seqs9=slave9_seqs::type_id::create("m_seqs9");
		  s_seq19=slv_write_seq::type_id::create("s_seq19");
		  
		  m_seqs10=slave10_seqs::type_id::create("m_seqs10");
		  s_seq20=slv_write_seq::type_id::create("s_seq20");
		  
		  m_seqs11=slave11_seqs::type_id::create("m_seqs11");
		  s_seq21=slv_write_seq::type_id::create("s_seq21");
		  
		  m_seqs12=slave12_seqs::type_id::create("m_seqs12");
		  s_seq22=slv_write_seq::type_id::create("s_seq22");
		  
		  m_seqs13=slave13_seqs::type_id::create("m_seqs13");
		  s_seq23=slv_write_seq::type_id::create("s_seq23");
		  
		  m_seqs14=slave14_seqs::type_id::create("m_seqs14");
		  s_seq24=slv_write_seq::type_id::create("s_seq24");
		  
		  m_seqs15=slave15_seqs::type_id::create("m_seqs15");
		  s_seq25=slv_write_seq::type_id::create("s_seq25");
		  
		  m_seqs16=slave16_seqs::type_id::create("m_seqs16");
		  s_seq26=slv_write_seq::type_id::create("s_seq26");
		  
		  fork
		    m_seqs1.start(envh.mas_top.m_agnth[0].m_seqrh);
		    m_seqs2.start(envh.mas_top.m_agnth[1].m_seqrh);
			m_seqs3.start(envh.mas_top.m_agnth[2].m_seqrh);
			m_seqs4.start(envh.mas_top.m_agnth[3].m_seqrh);
			m_seqs5.start(envh.mas_top.m_agnth[4].m_seqrh);
			m_seqs6.start(envh.mas_top.m_agnth[5].m_seqrh);
			m_seqs7.start(envh.mas_top.m_agnth[6].m_seqrh);
			m_seqs8.start(envh.mas_top.m_agnth[7].m_seqrh);
			m_seqs9.start(envh.mas_top.m_agnth[8].m_seqrh);
			m_seqs10.start(envh.mas_top.m_agnth[9].m_seqrh);
			m_seqs11.start(envh.mas_top.m_agnth[10].m_seqrh);
			m_seqs12.start(envh.mas_top.m_agnth[11].m_seqrh);
			m_seqs13.start(envh.mas_top.m_agnth[12].m_seqrh);
			m_seqs14.start(envh.mas_top.m_agnth[13].m_seqrh);
			m_seqs15.start(envh.mas_top.m_agnth[14].m_seqrh);
			begin
			#10;
			m_seqs16.start(envh.mas_top.m_agnth[0].m_seqrh);
			end
			
			begin
			#50;
			s_seq11.start(envh.slv_top.s_agnth[0].s_seqrh);
			end
			
			begin
			#50;
			s_seq12.start(envh.slv_top.s_agnth[1].s_seqrh);
			end
			
			begin
			#50;
			s_seq13.start(envh.slv_top.s_agnth[2].s_seqrh);
			end
			
			begin
			#50;
			s_seq14.start(envh.slv_top.s_agnth[3].s_seqrh);
			end
			
			begin
			#50;
			s_seq15.start(envh.slv_top.s_agnth[4].s_seqrh);
			end
			
			begin
			#50;
			s_seq16.start(envh.slv_top.s_agnth[5].s_seqrh);
			end
			
			begin
			#50;
			s_seq17.start(envh.slv_top.s_agnth[6].s_seqrh);
			end
			
			begin
			#50;
			s_seq18.start(envh.slv_top.s_agnth[7].s_seqrh);
			end
			
			begin
			#50;
			s_seq19.start(envh.slv_top.s_agnth[8].s_seqrh);
			end
			
			begin
			#50;
			s_seq20.start(envh.slv_top.s_agnth[9].s_seqrh);
			end
			
			begin
			#50;
			s_seq21.start(envh.slv_top.s_agnth[10].s_seqrh);
			end
			
			begin
			#50;
			s_seq22.start(envh.slv_top.s_agnth[11].s_seqrh);
			end
			
			begin
			#50;
			s_seq23.start(envh.slv_top.s_agnth[12].s_seqrh);
			end
			
			begin
			#50;
			s_seq24.start(envh.slv_top.s_agnth[13].s_seqrh);
			end
			
			begin
			#50;
			s_seq25.start(envh.slv_top.s_agnth[14].s_seqrh);
			end
			
			begin
			#100;
			s_seq26.start(envh.slv_top.s_agnth[0].s_seqrh);
			end
						
			join
			phase.drop_objection(this);
			endtask
			     endclass