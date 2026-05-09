/////////////////////////////master_seqs.sv////////////////////////
 class master_base_seqs extends uvm_sequence #(m_xtn);  
	`uvm_object_utils(master_base_seqs)
	
	bit [31:0]haddrs, start_addr, boundary_addr;
	bit [2:0] hsizes;
	bit       hsels;
	bit [2:0] hbursts;
	bit       hwrites;
	bit       hmastlocks;
	bit [3:0] remap;
	bit [3:0] hmasters;
	bit [3:0] hprots;
	bit [11:0] length;
	
function new(string name ="master_base_seqs");
	super.new(name);
endfunction

task body();
      haddrs=req.HADDRS;
	  hsizes=req.HSIZES;
	  hsels=req.HSELS;
      hbursts=req.HBURSTS;
	  hwrites=req.HWRITES;
	 // hmastlocks=req.hmastlocks;
	  remap=req.REMAP;
	  hmasters=req.HMASTERS;
	  hprots=req.HPROTS;
	  length=req.LENGTH;
   
   start_addr=int'((haddrs/((2**hsizes)*(length)))*((2**hsizes)*length));
   $display("start_addr:%0d",start_addr);
   
    boundary_addr=start_addr+|(2**hsizes)*length;
   $display("boundary_addr:%0d",boundary_addr);
   
// Conditional sequence generation based on hburst type
    if (hbursts == 1 || hbursts == 3 || hbursts == 5 || hbursts == 7) begin
      for (int i = 1; i < length; i++) begin
        start_item(req);
        assert(req.randomize() with {
          HTRANSS  == 2'b11;
          HWRITES == hwrites;
          HSIZES  == hsizes;
          HBURSTS == hbursts;
          REMAP   == remap;
          HSELS   == hsels;
          // HMASTERS == hmaster;
          HADDRS  == haddrs + (2**hsizes);
        });
        finish_item(req);
        haddrs = req.HADDRS;
        // req.print();
      end
    end
    else begin
      if (hbursts == 2 || hbursts == 4 || hbursts == 6) begin
        haddrs = haddrs + (2**hsizes);
        for (int i = 1; i < length; i++) begin
          if (haddrs == boundary_addr)
            haddrs = start_addr;

          start_item(req);
          assert(req.randomize() with {
            HTRANSS   == 2'b11;
            HWRITES  == hwrites;
            HSIZES   == hsizes;
            HBURSTS  == hbursts;
            REMAP    == remap;
            HSELS    == hsels;
            HMASTERS == hmasters;
            HADDRS   == haddrs;
          });
          finish_item(req);
          haddrs = req.HADDRS + 2**hsizes;
        end
      end
    end
  endtask : body

		endclass
//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------


//Extend slave1_seqs from master_base_seqs;
class slave1_seqs extends master_base_seqs;

	`uvm_object_utils(slave1_seqs)

         //bit [1:0]length;

//-----------------  constructor new method  -------------------//
function new(string name = "slave1_seqs");
	super.new(name);
endfunction
 

task body();
		req=m_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {HADDRS inside{[32'h00000000:32'h00001000]};
		                             HTRANSS==2'b10;
									 HSELS==1;
									 REMAP==0;
									 HMASTERS==4'd0;
									 //HMASTLOCKS==0;
									 });
         uvm_config_db #(bit[11:0])::set(null,"*","burst_length",req.LENGTH);
      finish_item(req);		 

 $display("current_addr:%0d",req.HADDRS);
 super.body();
endtask
endclass

//Extend slave2_seqs from master_base_seqs;
class slave2_seqs extends master_base_seqs;

	`uvm_object_utils(slave2_seqs)

         //bit [1:0]length;

//-----------------  constructor new method  -------------------//
function new(string name = "slave2_seqs");
	super.new(name);
endfunction
 

task body();
		req=m_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {HADDRS inside{[32'h00001000:32'h00002000]};
		                             HTRANSS==2'b10;
									 HSELS==1;
									 REMAP==0;
									 HMASTERS==4'd1;
									 //HMASTLOCKS==0;
									 });
         uvm_config_db #(bit[11:0])::set(null,"*","length",req.LENGTH);
      finish_item(req);		 

 $display("current_addr:%0d",req.HADDRS);
 super.body();
endtask
endclass

//Extend slave3_seqs from master_base_seqs;
class slave3_seqs extends master_base_seqs;

	`uvm_object_utils(slave3_seqs)

         //bit [1:0]length;

//-----------------  constructor new method  -------------------//
function new(string name = "slave3_seqs");
	super.new(name);
endfunction
 

task body();
		req=m_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {HADDRS inside{[32'h00002000:32'h00003000]};
		                             HTRANSS==2'b10;
									 HSELS==1;
									 REMAP==0;
									 HMASTERS==4'd2;
									 //HMASTLOCKS==0;
									 });
         uvm_config_db #(bit[11:0])::set(null,"*","length",req.LENGTH);
      finish_item(req);		 

 $display("current_addr:%0d",req.HADDRS);
 super.body();
endtask
endclass

//Extend slave4_seqs from master_base_seqs;
class slave4_seqs extends master_base_seqs;

	`uvm_object_utils(slave4_seqs)

         //bit [1:0]length;

//-----------------  constructor new method  -------------------//
function new(string name = "slave4_seqs");
	super.new(name);
endfunction
 

task body();
		req=m_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {HADDRS inside{[32'h00003000:32'h00004000]};
		                             HTRANSS==2'b10;
									 HSELS==1;
									 REMAP==0;
									 HMASTERS==4'd3;
									 //HMASTLOCKS==0;
									 });
         uvm_config_db #(bit[11:0])::set(null,"*","length",req.LENGTH);
      finish_item(req);		 

 $display("current_addr:%0d",req.HADDRS);
 super.body();
endtask
endclass

//Extend slave5_seqs from master_base_seqs;
class slave5_seqs extends master_base_seqs;

	`uvm_object_utils(slave5_seqs)

         //bit [1:0]length;

//-----------------  constructor new method  -------------------//
function new(string name = "slave5_seqs");
	super.new(name);
endfunction
 

task body();
		req=m_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {HADDRS inside{[32'h00004000:32'h00005000]};
		                             HTRANSS==2'b10;
									 HSELS==1;
									 REMAP==0;
									 HMASTERS==4'd4;
									 //HMASTLOCKS==0;
									 });
         uvm_config_db #(bit[11:0])::set(null,"*","length",req.LENGTH);
      finish_item(req);		 

 $display("current_addr:%0d",req.HADDRS);
 super.body();
endtask
endclass

//Extend slave6_seqs from master_base_seqs;
class slave6_seqs extends master_base_seqs;

	`uvm_object_utils(slave6_seqs)

         //bit [1:0]length;

//-----------------  constructor new method  -------------------//
function new(string name = "slave6_seqs");
	super.new(name);
endfunction
 

task body();
		req=m_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {HADDRS inside{[32'h00006000:32'h00007000]};
		                             HTRANSS==2'b10;
									 HSELS==1;
									 REMAP==0;
									 HMASTERS==4'd5;
									 //HMASTLOCKS==0;
									 });
         uvm_config_db #(bit[11:0])::set(null,"*","length",req.LENGTH);
      finish_item(req);		 

 $display("current_addr:%0d",req.HADDRS);
 super.body();
endtask
endclass

//Extend slave7_seqs from master_base_seqs;
class slave7_seqs extends master_base_seqs;

	`uvm_object_utils(slave7_seqs)

         //bit [1:0]length;

//-----------------  constructor new method  -------------------//
function new(string name = "slave7_seqs");
	super.new(name);
endfunction
 

task body();
		req=m_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {HADDRS inside{[32'h00007000:32'h00008000]};
		                             HTRANSS==2'b10;
									 HSELS==1;
									 REMAP==0;
									 HMASTERS==4'd6;
									 //HMASTLOCKS==0;
									 });
         uvm_config_db #(bit[11:0])::set(null,"*","length",req.LENGTH);
      finish_item(req);		 

 $display("current_addr:%0d",req.HADDRS);
 super.body();
endtask
endclass

//Extend slave8_seqs from master_base_seqs;
class slave8_seqs extends master_base_seqs;

	`uvm_object_utils(slave8_seqs)

         //bit [1:0]length;

//-----------------  constructor new method  -------------------//
function new(string name = "slave8_seqs");
	super.new(name);
endfunction
 

task body();
		req=m_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {HADDRS inside{[32'h00008000:32'h00009000]};
		                             HTRANSS==2'b10;
									 HSELS==1;
									 REMAP==0;
									 HMASTERS==4'd7;
									 //HMASTLOCKS==0;
									 });
         uvm_config_db #(bit[11:0])::set(null,"*","length",req.LENGTH);
      finish_item(req);		 

 $display("current_addr:%0d",req.HADDRS);
 super.body();
endtask
endclass

//Extend slave9_seqs from master_base_seqs;
class slave9_seqs extends master_base_seqs;

	`uvm_object_utils(slave9_seqs)

         //bit [1:0]length;

//-----------------  constructor new method  -------------------//
function new(string name = "slave9_seqs");
	super.new(name);
endfunction
 

task body();
		req=m_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {HADDRS inside{[32'h00009000:32'h00010000]};
		                             HTRANSS==2'b10;
									 HSELS==1;
									 REMAP==0;
									 HMASTERS==4'd8;
									 //HMASTLOCKS==0;
									 });
         uvm_config_db #(bit[11:0])::set(null,"*","length",req.LENGTH);
      finish_item(req);		 

 $display("current_addr:%0d",req.HADDRS);
 super.body();
endtask
endclass

//Extend slave10_seqs from master_base_seqs;
class slave10_seqs extends master_base_seqs;

	`uvm_object_utils(slave10_seqs)

         //bit [1:0]length;

//-----------------  constructor new method  -------------------//
function new(string name = "slave10_seqs");
	super.new(name);
endfunction
 

task body();
		req=m_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {HADDRS inside{[32'h00010000:32'h00020000]};
		                             HTRANSS==2'b10;
									 HSELS==1;
									 REMAP==0;
									 HMASTERS==4'd9;
									 //HMASTLOCKS==0;
									 });
         uvm_config_db #(bit[11:0])::set(null,"*","length",req.LENGTH);
      finish_item(req);		 

 $display("current_addr:%0d",req.HADDRS);
 super.body();
endtask
endclass

//Extend slave11_seqs from master_base_seqs;
class slave11_seqs extends master_base_seqs;

	`uvm_object_utils(slave11_seqs)

         //bit [1:0]length;

//-----------------  constructor new method  -------------------//
function new(string name = "slave11_seqs");
	super.new(name);
endfunction
 

task body();
		req=m_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {HADDRS inside{[32'h00020000:32'h00030000]};
		                             HTRANSS==2'b10;
									 HSELS==1;
									 REMAP==0;
									 HMASTERS==4'd10;
									 //HMASTLOCKS==0;
									 });
         uvm_config_db #(bit[11:0])::set(null,"*","length",req.LENGTH);
      finish_item(req);		 

 $display("current_addr:%0d",req.HADDRS);
 super.body();
endtask
endclass

//Extend slave12_seqs from master_base_seqs;
class slave12_seqs extends master_base_seqs;

	`uvm_object_utils(slave12_seqs)

         //bit [1:0]length;

//-----------------  constructor new method  -------------------//
function new(string name = "slave12_seqs");
	super.new(name);
endfunction
 

task body();
		req=m_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {HADDRS inside{[32'h00030000:32'h00040000]};
		                             HTRANSS==2'b10;
									 HSELS==1;
									 REMAP==0;
									 HMASTERS==4'd11;
									 //HMASTLOCKS==0;
									 });
         uvm_config_db #(bit[11:0])::set(null,"*","length",req.LENGTH);
      finish_item(req);		 

 $display("current_addr:%0d",req.HADDRS);
 super.body();
endtask
endclass

//Extend slave13_seqs from master_base_seqs;
class slave13_seqs extends master_base_seqs;

	`uvm_object_utils(slave13_seqs)

         //bit [1:0]length;

//-----------------  constructor new method  -------------------//
function new(string name = "slave13_seqs");
	super.new(name);
endfunction
 

task body();
		req=m_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {HADDRS inside{[32'h00040000:32'h00050000]};
		                             HTRANSS==2'b10;
									 HSELS==1;
									 REMAP==0;
									 HMASTERS==4'd12;
									 //HMASTLOCKS==0;
									 });
         uvm_config_db #(bit[11:0])::set(null,"*","length",req.LENGTH);
      finish_item(req);		 

 $display("current_addr:%0d",req.HADDRS);
 super.body();
endtask
endclass

//Extend slave14_seqs from master_base_seqs;
class slave14_seqs extends master_base_seqs;

	`uvm_object_utils(slave14_seqs)

         //bit [1:0]length;

//-----------------  constructor new method  -------------------//
function new(string name = "slave14_seqs");
	super.new(name);
endfunction
 

task body();
		req=m_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {HADDRS inside{[32'h00060000:32'h00070000]};
		                             HTRANSS==2'b10;
									 HSELS==1;
									 REMAP==0;
									 HMASTERS==4'd13;
									 //HMASTLOCKS==0;
									 });
         uvm_config_db #(bit[11:0])::set(null,"*","length",req.LENGTH);
      finish_item(req);		 

 $display("current_addr:%0d",req.HADDRS);
 super.body();
endtask
endclass

//Extend slave15_seqs from master_base_seqs;
class slave15_seqs extends master_base_seqs;

	`uvm_object_utils(slave15_seqs)

         //bit [1:0]length;

//-----------------  constructor new method  -------------------//
function new(string name = "slave15_seqs");
	super.new(name);
endfunction
 

task body();
		req=m_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {HADDRS inside{[32'h00070000:32'h00080000]};
		                             HTRANSS==2'b10;
									 HSELS==1;
									 REMAP==0;
									 HMASTERS==4'd14;
									 //HMASTLOCKS==0;
									 });
         uvm_config_db #(bit[11:0])::set(null,"*","length",req.LENGTH);
      finish_item(req);		 

 $display("current_addr:%0d",req.HADDRS);
 super.body();
endtask
endclass

//Extend slave16_seqs from master_base_seqs;
class slave16_seqs extends master_base_seqs;

	`uvm_object_utils(slave16_seqs)

         //bit [1:0]length;

//-----------------  constructor new method  -------------------//
function new(string name = "slave16_seqs");
	super.new(name);
endfunction
 

task body();
		req=m_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {HADDRS==32'h00000000;
		                             HTRANSS==2'b11;
									 HSELS==1;
									 REMAP==0;
									 HMASTERS==4'd14;
									 //HMASTLOCKS==0;
									 });
         uvm_config_db #(bit[11:0])::set(null,"*","length",req.LENGTH);
      finish_item(req);		 

 $display("current_addr:%0d",req.HADDRS);
 super.body();
endtask
endclass