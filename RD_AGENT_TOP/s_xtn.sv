	/////////////////////s_xtn.sv/////////////////////
	class s_xtn extends uvm_sequence_item;
`uvm_object_utils(s_xtn);


 rand bit       HREADYOUTM;
 rand bit [1:0]HRESPM;
 rand bit [31:0]HRDATAM; 
 rand bit [2:0]delay_cycles;
 
 rand enum {okay, okay_wait, error}resp;
 constraint c1{delay_cycles inside {[1:4]};}
 
 logic [3:0]HPROTM;
 logic       HSELM, HREADYM;
 logic [31:0]HADDRM;
 logic [31:0]HWDATAM;
 logic [1:0] HTRANSM;
 logic       HWRITEM;
 logic [2:0] HSIZEM;
 logic [2:0] HBURSTM;
 logic [3:0] HPORTM;
 logic [3:0] HMASTERM;
 logic       HMASTLOCKM;//


                     
function new(string name = "s_xtn");
	super.new(name);
endfunction:new

function void do_print (uvm_printer printer);
	super.do_print(printer);

   
    //              	  srting name   		        bitstream value            size            radix for printing
    printer.print_field( "HSELM", 			          this.HSELM, 	            1,		        UVM_DEC		);
				    printer.print_field( "HWRITEM", 			          this.HWRITEM, 	            1,		        UVM_DEC		);
									      printer.print_field( "HREADYOUTM", 			          this.HREADYOUTM, 	            1,		        UVM_DEC		);
										    printer.print_field( "HRESPM", 			          this.HRESPM, 	            2,		        UVM_DEC		);
											    printer.print_field( "HRDATAM", 			          this.HRDATAM, 	            32,		        UVM_DEC		);

endfunction:do_print
endclass:s_xtn