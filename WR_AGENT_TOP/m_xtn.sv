//////////////////////	//m_xtn.sv////////////////////////////
	class m_xtn extends uvm_sequence_item;
`uvm_object_utils(m_xtn)

rand bit       HRESETn;
rand bit [3:0] REMAP;
rand bit       HSELS;
rand bit [31:0]HADDRS;
rand bit [31:0]HWDATAS;
rand bit [1:0] HTRANSS;
rand bit       HWRITES;
rand bit [2:0] HSIZES;
rand bit [2:0] HBURSTS;
rand bit [3:0] HPROTS;
rand bit [3:0] HMASTERS;
rand bit       HMASTLOCKS;//
rand bit [11:0] LENGTH;

 bit       HREADYOUTS;
 bit [1:0] HRESPS;
 bit [31:0] HRDATAS; 
 
 
 constraint for_reset{HRESETn dist {0:=10, 1:=90};}
 
 constraint for_hlength{HBURSTS==3'd0 -> LENGTH==1;
                        HBURSTS==3'd2 -> LENGTH==4;
						HBURSTS==3'd3 -> LENGTH==4;
						HBURSTS==3'd4 -> LENGTH==8;
						HBURSTS==3'd5 -> LENGTH==8;
						HBURSTS==3'd6 -> LENGTH==16;
						HBURSTS==3'd7 -> LENGTH==16;}
				
constraint for_hburst{HBURSTS !=1;}
constraint for_hsize{HSIZES < 3;}
constraint for_haddr{HSIZES==1 -> HADDRS%2==0; HSIZES==2 -> HADDRS%4==0;}
constraint for_hmaster{HMASTLOCKS==0;}
//constraint for_hreadyouts{HREADYOUTS !=1;}
                     
function new(string name = "m_xtn");
	super.new(name);
endfunction:new

function void do_print (uvm_printer printer);
	super.do_print(printer);

   
    //              	  srting name   		        bitstream value            size            radix for printing
    printer.print_field( "REMAP", 			          this.REMAP, 	    	    4,		        UVM_DEC		);
    printer.print_field( "HSELS", 			          this.HSELS, 	            1,		        UVM_BIN		);
	    printer.print_field( "HADDRS", 			          this.HADDRS, 	            32,		        UVM_DEC		);
		    printer.print_field( "HWDATAS", 			          this.HWDATAS, 	            32,		        UVM_DEC		);
			    printer.print_field( "HTRANSS", 			          this.HTRANSS, 	            2,		        UVM_BIN		);
				    printer.print_field( "HWRITES", 			          this.HWRITES, 	            1,		        UVM_BIN		);
					    printer.print_field( "HSIZES", 			          this.HSIZES, 	            3,		        UVM_DEC		);
						    printer.print_field( "HBURSTS", 			          this.HBURSTS, 	            3,		        UVM_DEC		);
							    printer.print_field( "HPROTS", 			          this.HPROTS, 	            4,		        UVM_DEC		);
								    printer.print_field( "HMASTERS", 			          this.HMASTERS, 	            4,		        UVM_DEC		);
									    printer.print_field( "HMASTLOCKS", 			          this.HMASTLOCKS, 	            1,		        UVM_BIN		);
									      printer.print_field( "HREADYOUTS", 			          this.HREADYOUTS, 	            1,		        UVM_BIN		);
										    printer.print_field( "HRESPS", 			          this.HRESPS, 	            2,		        UVM_DEC		);
											    printer.print_field( "HRDATAS", 			          this.HRDATAS, 	            32,		        UVM_DEC		);
												    printer.print_field( "LENGTH", 			          this.LENGTH, 	            12,		        UVM_DEC		);

endfunction:do_print
endclass