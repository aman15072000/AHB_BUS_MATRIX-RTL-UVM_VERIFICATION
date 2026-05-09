   ///////////////////////////scoreboard.sv//////////////////////////////////////
   
/*
class scoreboard extends uvm_scoreboard;

  `uvm_component_utils(scoreboard)
  extern function new(string name = "scoreboard",uvm_component parent);
endclass

//---------------------constructor new method-----------------------------//
function scoreboard::new(string name = "scoreboard",uvm_component parent);
  super.new(name,parent);
endfunction
*/

class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  uvm_tlm_analysis_fifo #(m_xtn) fifo_mas[];
  uvm_tlm_analysis_fifo #(s_xtn) fifo_slv[];

  m_xtn  mxtn;
  s_xtn  sxtn;

  env_config e_cfg;
  int i;
  int num;
  int length;
  
  int slv_id;
 //int pass;
  extern function new(string name="scoreboard", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task check_data(m_xtn mxtn);
  extern task compare(m_xtn mxtn, s_xtn sxtn, int i);

endclass

//-------------------- new --------------------//
function scoreboard::new(string name="scoreboard", uvm_component parent);
  super.new(name, parent);
endfunction

//-------------------- build_phase --------------------//
function void scoreboard::build_phase(uvm_phase phase);

  if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
    `uvm_fatal(get_type_name(),"cannot get ENV config")

  fifo_mas = new[e_cfg.no_of_mas];
  fifo_slv = new[e_cfg.no_of_slv];

  num = e_cfg.no_of_mas;

  super.build_phase(phase);

  foreach (fifo_mas[i]) begin
    fifo_mas[i] = new($sformatf("fifo_mas[%0d]",i), this);
  end

  foreach (fifo_slv[i]) begin
    fifo_slv[i] = new($sformatf("fifo_slv[%0d]",i), this);
  end

  `uvm_info(get_type_name(),
            "PRINTING FROM SCOREBOARD BUILD PHASE",
            UVM_NONE)

endfunction

//-------------------- run_phase --------------------//
task scoreboard::run_phase(uvm_phase phase);

  `uvm_info(get_type_name(),
            "PRINTING FROM SCOREBOARD RUN PHASE",
            UVM_NONE)

  forever begin
    foreach (fifo_mas[i]) begin
      fifo_mas[i].get(mxtn);   // NS
      check_data(mxtn);

      if(!uvm_config_db #(bit[11:0])::get(this,"","burst_length",length))
        `uvm_fatal("","")

      for(int j=0; j<length; j++) begin
        if(j>0)
          fifo_mas[i].get(mxtn); // Seq
       begin
        fifo_slv[slv_id].get(sxtn); // NS,S,S,S
        compare(mxtn, sxtn, i);
	  end
      end
    end
  end

endtask

//-------------------- check --------------------//
task scoreboard::check_data(m_xtn mxtn);

  if(mxtn.REMAP == 0) begin
    if (((mxtn.HADDRS > 32'h00000000) & (mxtn.HADDRS < 32'h00001000)))
                 slv_id = 0;  // Select Output port 0

               else if (((mxtn.HADDRS > 32'h00001000) & (mxtn.HADDRS < 32'h00002000)))
                 slv_id = 1;  // Select Output port 1

               else if (((mxtn.HADDRS > 32'h00002000) & (mxtn.HADDRS < 32'h00003000)))
                 slv_id = 2;  // Select Output port 2

               else if (((mxtn.HADDRS > 32'h00003000) & (mxtn.HADDRS < 32'h00004000)))
                 slv_id = 3;  // Select Output port 3

               else if (((mxtn.HADDRS > 32'h00004000) & (mxtn.HADDRS < 32'h00005000)))
                 slv_id = 4;  // Select Output port 4

               else if (((mxtn.HADDRS > 32'h00006000) & (mxtn.HADDRS < 32'h00007000)))
                 slv_id = 5;  // Select Output port 5

               else if (((mxtn.HADDRS > 32'h00007000) & (mxtn.HADDRS < 32'h00008000)))
                 slv_id = 6;  // Select Output port 6

               else if (((mxtn.HADDRS > 32'h00008000) & (mxtn.HADDRS < 32'h00009000)))
                 slv_id = 7;  // Select Output port 7

               else if (((mxtn.HADDRS > 32'h00009000) & (mxtn.HADDRS < 32'h00010000)))
                 slv_id = 8;  // Select Output port 8

               else if (((mxtn.HADDRS > 32'h00010000) & (mxtn.HADDRS < 32'h00020000)))
                 slv_id = 9;  // Select Output port 9

               else if (((mxtn.HADDRS > 32'h00020000) & (mxtn.HADDRS < 32'h00030000)))
                 slv_id = 10;  // Select Output port 10

               else if (((mxtn.HADDRS > 32'h00030000) & (mxtn.HADDRS < 32'h00040000)))
                 slv_id = 11;  // Select Output port 11

               else if (((mxtn.HADDRS > 32'h00040000) & (mxtn.HADDRS < 32'h00050000)))
                 slv_id = 12;  // Select Output port 12

               else if (((mxtn.HADDRS > 32'h00060000) & (mxtn.HADDRS < 32'h00070000)))
                 slv_id = 13;  // Select Output port 13

               else if (((mxtn.HADDRS > 32'h00070000) & (mxtn.HADDRS < 32'h00080000)))
                 slv_id = 14;  // Select Output port 14

               //else if (((mxtn.HADDRS == 32'h0) & (mxtn.HADDRS > 32'h00080000)))
                 //addr_out_port = 4'd15;   // Select the default slave
       
         else
                 slv_id = 15;


  end

endtask

//-------------------- compare --------------------//
task scoreboard::compare(m_xtn mxtn, s_xtn sxtn, int i);

  if(mxtn.HSELS) begin
    if(slv_id != 15) begin

      if(mxtn.HWRITES) begin
        if(mxtn.HWDATAS == sxtn.HRDATAM)
          $display("Write Data compare SUCCESS for Master %0d MAS_HWDATAS=%0h SLV_HWDATAM=%0h", i, mxtn.HWDATAS, sxtn.HRDATAM);
        else begin
          $display("%0t Write Data compare UNSUCCESSFULL MAS_HWDATAS=%0h SLV_HWDATAM=%0h",
                    $time, mxtn.HWDATAS, sxtn.HRDATAM);
        end
      end
      else begin
        if(mxtn.HRDATAS == sxtn.HRDATAM)
          $display("Read Data Compare SUCCESS for Master %0d MAS_HRDATAS=%0h SLV_HRDATAM=%0h",
                    i, mxtn.HRDATAS, sxtn.HRDATAM);
        else
          $display("%0t Read Data Compare UNSUCCESSFULL MAS_HRDATAS=%0h SLV_HRDATAM=%0h",
                    $time, mxtn.HRDATAS, sxtn.HRDATAM);
      end

    end
    else begin
      $display("Default slave is selected by Master %0d", i);
    end
  end
  else begin
    $display("Master %0d is disabled", i);
  end

endtask