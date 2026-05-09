	///////////////////////////slave_seqs.sv///////////////////////////
	class slave_base_seqs extends uvm_sequence #(s_xtn);  
	`uvm_object_utils(slave_base_seqs)
	
	
function new(string name ="slave_base_seqs");
	super.new(name);
endfunction: new
endclass:slave_base_seqs

//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------


//Extend slv_write_seq from slave_base_seqs;
class slv_write_seq extends slave_base_seqs;

	`uvm_object_utils(slv_write_seq)
      	bit [11:0]length;
	    bit [11:0]l;
         //bit [1:0]length;

//-----------------  constructor new method  -------------------//
function new(string name = "slv_write_seq");
	super.new(name);
endfunction:new
 

task body();
#45;
if(!uvm_config_db #(bit[11:0])::get(null,get_full_name(),"burst_length",length))
`uvm_fatal("CONFIG","cannot get() length from uvm_config_db. Have you set() it?")
  //length=12'd6;
  $display("ms_length:%0d",length);
  l=length;
  $display("ms_length:%0d",l);
  repeat(l)
    begin
		req=s_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {HRESPM==2'd0;
		                             HREADYOUTM==1'b1;
                                     resp==2'd2;}								 
					 );
      finish_item(req);	
end	 
endtask: body
endclass:slv_write_seq