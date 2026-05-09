/////////////////////////subscriber.sv//////////////////////////
class subscriber extends uvm_component;
	
	uvm_tlm_analysis_fifo #(s_xtn) fifo_slv_duv[];
    uvm_tlm_analysis_fifo #(m_xtn) fifo_mas_duv[];

       
	// Factory registration
	 `uvm_component_utils(subscriber)

         env_config cfg;

		m_xtn mxtn;
		s_xtn sxtn;

		//mas_xtn mxtnite_cov_data;
        //slv_xtn read_cov_data;


// LAB : mxtnite the covergroup router_fcov1 for mxtnite transactions
covergroup mas_coverage;
option.per_instance=1;
       //ADDRESS
     
       CP_RST : coverpoint mxtn.HRESETn{
					bins hresetn_0 = {0};
					//bins hresetn_1 = {1};
					}
    	     	     
       CP_REMAP : coverpoint mxtn.REMAP{
					bins remap_0 = {4'd0};
					}

       CP_HSELS : coverpoint mxtn.HSELS{
					bins hsels_1 = {4'd1};
					}

       CP_HTRANSS : coverpoint mxtn.HTRANSS{
					bins htranss_seq = {3'd3};
					bins htranss_nonseq = {3'd2};
					}

       CP_HWRITES : coverpoint mxtn.HWRITES{
					bins hwrites_high = {1'd1};
					bins hwrites_low = {1'd0};
					}

    CP_HADDRS: coverpoint mxtn.HADDRS{ 
	          bins bins_haddrs_remap0_slv0 = {['h00000001:'h00001000]};
              bins bins_haddrs_remap0_slv1 = {['h00001000:'h00002000]};
              bins bins_haddrs_remap0_slv2 = {['h00002000:'h00003000]};
              bins bins_haddrs_remap0_slv3 = {['h00003000:'h00004000]};
              bins bins_haddrs_remap0_slv4 = {['h00004000:'h00006000]};
              bins bins_haddrs_remap0_slv5 = {['h00006000:'h00007000]};
              bins bins_haddrs_remap0_slv6 = {['h00007000:'h00008000]};
              bins bins_haddrs_remap0_slv7 = {['h00008000:'h00009000]};
              bins bins_haddrs_remap0_slv8 = {['h00009000:'h00010000]};
              bins bins_haddrs_remap0_slv9 = {['h00010000:'h00020000]};
              bins bins_haddrs_remap0_slv10 = {['h00020000:'h00030000]};
              bins bins_haddrs_remap0_slv11 = {['h00030000:'h00040000]};
              bins bins_haddrs_remap0_slv12 = {['h00040000:'h00060000]};
              bins bins_haddrs_remap0_slv13 = {['h00060000:'h00070000]};
              bins bins_haddrs_remap0_slv14 = {['h00070000:'h00080000]};
              }

    CP_HBURSTS: coverpoint mxtn.HBURSTS{ 
	          bins bins_hbursts_incr = {3'd3,3'd5};
              bins bins_hbursts_wrap = {3'd2, 3'd4};
               }
			   
    CP_HSIZES: coverpoint mxtn.HSIZES{ 
	          bins bins_hsizes_min = {3'd0};
              bins bins_hsizes_mid = {3'd1};
              bins bins_hsizes_max = {3'd2};
            }

    CP_HPROTS: coverpoint mxtn.HPROTS{ 
	         bins bins_hprots_min = {4'd0};
            }
    
    CP_HMASTERS: coverpoint mxtn.HMASTERS{ 
	          bins bins_hmasters0 = {4'd0};
              bins bins_hmasters1 = {4'd1};
              bins bins_hmasters2 = {4'd2};
              bins bins_hmasters3 = {4'd3};
              bins bins_hmasters4 = {4'd4};
              bins bins_hmasters5 = {4'd5};
              bins bins_hmasters6 = {4'd6};
              bins bins_hmasters7 = {4'd7};
              bins bins_hmasters8 = {4'd8};
              bins bins_hmasters9 = {4'd9};
              bins bins_hmasters10 = {4'd10};
              bins bins_hmasters11 = {4'd11};
              bins bins_hmasters12 = {4'd12};
              bins bins_hmasters13 = {4'd13};
              bins bins_hmasters14 = {4'd14};
              }

    CP_HMASTLOCKS: coverpoint mxtn.HMASTLOCKS{ 
	          bins bins_hlocks = {1'b0};
              }
    
    CP_HRESPS:   coverpoint mxtn.HRESPS{ 
	          bins bins_hresp_error = {2'd1};
              bins bins_hresp_okay = {2'd0};
              }
    CP_HADDRS_DEF: coverpoint mxtn.HADDRS{ 
	          bins bins_haddrs_default = {32'h0};
              }

    CROSS_DEF_OKAY_ERROR: cross CP_HADDRS_DEF, CP_HRESPS;
    CROSS_HMASTER_HADDRS: cross CP_HADDRS,CP_HMASTERS;

          
    endgroup

//LAB : mxtnite the covergroup router_fcov2 for read transactions
    covergroup slv_coverage;
        option.per_instance=1;

        CP_HREADYOUTM : coverpoint sxtn.HREADYOUTM{
					bins hreadyoutm_min = {1'b1};
					}
       
        CP_HRDATAM : coverpoint sxtn.HRDATAM{
					bins hrdatam_min = {[1:4294967294]};
					}
					
		CP_HRESPM : coverpoint sxtn.HRESPM{
					bins hrespm_min = {2'b00};
					}			
       // DST_ADDR_x_DST_PAYLOAD_LENGTH : cross DST_ADDR,DST_PAYLOAD_LENGHT;
        
    endgroup


//------------------------------------------
// Methods
//------------------------------------------

// Standasxtn UVM Methods:
extern function new(string name,uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

//-----------------  constructor new method  -------------------//

    function subscriber::new(string name,uvm_component parent);
		super.new(name,parent);
			 	mas_coverage=new;
				slv_coverage=new;
	endfunction
	
	//-----------------  build phase method  -------------------//

    function void subscriber::build_phase(uvm_phase phase);
        super.build_phase(phase);

	//get configuration object env_config from database using uvm_config_db() 
	  if(!uvm_config_db #(env_config)::get(this,"","env_config",cfg))
		`uvm_fatal("get_type_name()","cannot get() cfg from uvm_config_db. Have you set() it?")
		
             fifo_mas_duv=new[cfg.no_of_mas];
			 fifo_slv_duv=new[cfg.no_of_slv]; 
			 
			 foreach(fifo_mas_duv[i])
		        fifo_mas_duv[i]=new($sformatf("fifo_mas_duv[%0d]",i),this);     
             foreach(fifo_slv_duv[i])
		        fifo_slv_duv[i]=new($sformatf("fifo_slv_duv[%0d]",i),this);
				
	   // super.build_phase(phase);               
		endfunction



//-----------------  run() phase  -------------------//

       task subscriber::run_phase(uvm_phase phase);
	     super.run_phase(phase);
	   
	   forever 
	    begin
		  foreach(fifo_mas_duv[i])
		    begin
            fifo_mas_duv[i].get(mxtn);
    	          mas_coverage.sample();
			 end
		  foreach(fifo_mas_duv[i])
		    begin
            fifo_slv_duv[i].get(sxtn);
    	          slv_coverage.sample();
			 end
			 end
       endtask