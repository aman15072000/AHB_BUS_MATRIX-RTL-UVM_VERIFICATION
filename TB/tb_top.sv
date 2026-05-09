////////////////////////////tb_top.sv///////////////////////////
  /********************************************************************************************

  Copyright 2024 - Maven Silicon Softech Pvt Ltd.  

  www.maven-silicon.com

  All Rights Reserved.

  This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
  It is not to be shared with or used by any third parties who have not enrolled for our paid 
  training courses or received any written authorization from Maven Silicon.

  Filename                :       tb_top.sv   

  module Name             :       tb_top

  Description             :       Test bench top to connect tb environment and design

  Author Name             :       K Sriguru

  Support e-mail          :       For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

  Version                 :       1.0

  *********************************************************************************************/


  
module tb_top;

  bit clock=1;

  always #5 clock=~clock;

  //`include "uvm_macros.svh"
  import ahb_pkg::*;
  import uvm_pkg::*;
  import cvw::*;




  mas_interface m_if0(clock);
  mas_interface m_if1(clock);
  mas_interface m_if2(clock);
  mas_interface m_if3(clock);
  mas_interface m_if4(clock);
  mas_interface m_if5(clock);
  mas_interface m_if6(clock);
  mas_interface m_if7(clock);
  mas_interface m_if8(clock);
  mas_interface m_if9(clock);
  mas_interface m_if10(clock);
  mas_interface m_if11(clock);
  mas_interface m_if12(clock);
  mas_interface m_if13(clock);
  mas_interface m_if14(clock);
  
  slv_interface s_if0(clock);
  slv_interface s_if1(clock);
  slv_interface s_if2(clock);
  slv_interface s_if3(clock);
  slv_interface s_if4(clock);
  slv_interface s_if5(clock);
  slv_interface s_if6(clock);
  slv_interface s_if7(clock);
  slv_interface s_if8(clock);
  slv_interface s_if9(clock);
  slv_interface s_if10(clock);
  slv_interface s_if11(clock);
  slv_interface s_if12(clock);
  slv_interface s_if13(clock);
  slv_interface s_if14(clock);
  

  ahb_bus_matrix_top #(P.n) DUV(.HCLK(clock),.HRESETn(m_if0.HRESETn),
                                .REMAP({m_if14.REMAP[3:0],m_if13.REMAP[3:0],m_if12.REMAP[3:0],m_if11.REMAP[3:0],
                                        m_if10.REMAP[3:0],m_if9.REMAP[3:0],m_if8.REMAP[3:0],m_if7.REMAP[3:0],
                                        m_if6.REMAP[3:0],m_if5.REMAP[3:0],m_if4.REMAP[3:0],m_if3.REMAP[3:0],
                                        m_if2.REMAP[3:0],m_if1.REMAP[3:0],m_if0.REMAP[3:0]}),

                                .HSELS({m_if14.HSELS,m_if13.HSELS,m_if12.HSELS,m_if11.HSELS,m_if10.HSELS,
                                        m_if9.HSELS,m_if8.HSELS,m_if7.HSELS,m_if6.HSELS,m_if5.HSELS,
                                        m_if4.HSELS,m_if3.HSELS,m_if2.HSELS,m_if1.HSELS,m_if0.HSELS}),

                                .HADDRS({m_if14.HADDRS[31:0],m_if13.HADDRS[31:0],m_if12.HADDRS[31:0],m_if11.HADDRS[31:0],
                                         m_if10.HADDRS[31:0],m_if9.HADDRS[31:0],m_if8.HADDRS[31:0],m_if7.HADDRS[31:0],
                                         m_if6.HADDRS[31:0],m_if5.HADDRS[31:0],m_if4.HADDRS[31:0],m_if3.HADDRS[31:0],
                                         m_if2.HADDRS[31:0],m_if1.HADDRS[31:0],m_if0.HADDRS[31:0]}),

			        .HWDATAS({m_if14.HWDATAS[31:0],m_if13.HWDATAS[31:0],m_if12.HWDATAS[31:0],m_if11.HWDATAS[31:0],
                                          m_if10.HWDATAS[31:0],m_if9.HWDATAS[31:0],m_if8.HWDATAS[31:0],m_if7.HWDATAS[31:0],
                                          m_if6.HWDATAS[31:0],m_if5.HWDATAS[31:0],m_if4.HWDATAS[31:0],m_if3.HWDATAS[31:0],
                                          m_if2.HWDATAS[31:0],m_if1.HWDATAS[31:0],m_if0.HWDATAS[31:0]}),

                                .HTRANSS({m_if14.HTRANSS[1:0],m_if13.HTRANSS[1:0],m_if12.HTRANSS[1:0],m_if11.HTRANSS[1:0],m_if10.HTRANSS[1:0],
                                          m_if9.HTRANSS[1:0],m_if8.HTRANSS[1:0],m_if7.HTRANSS[1:0],m_if6.HTRANSS[1:0],
                                          m_if5.HTRANSS[1:0],m_if4.HTRANSS[1:0],m_if3.HTRANSS[1:0],m_if2.HTRANSS[1:0],
                                          m_if1.HTRANSS[1:0],m_if0.HTRANSS[1:0]}),

                                .HWRITES({m_if14.HWRITES,m_if13.HWRITES,m_if12.HWRITES,m_if11.HWRITES,m_if10.HWRITES,
                                          m_if9.HWRITES,m_if8.HWRITES,m_if7.HWRITES,m_if6.HWRITES,m_if5.HWRITES,
                                          m_if4.HWRITES,m_if3.HWRITES,m_if2.HWRITES,m_if1.HWRITES,m_if0.HWRITES}),

                                .HSIZES({m_if14.HSIZES[2:0],m_if13.HSIZES[2:0],m_if12.HSIZES[2:0],m_if11.HSIZES[2:0],
                                         m_if10.HSIZES[2:0],m_if9.HSIZES[2:0],m_if8.HSIZES[2:0],m_if7.HSIZES[2:0],
                                         m_if6.HSIZES[2:0],m_if5.HSIZES[2:0],m_if4.HSIZES[2:0],m_if3.HSIZES[2:0],
                                         m_if2.HSIZES[2:0],m_if1.HSIZES[2:0],m_if0.HSIZES[2:0]}),

			        .HBURSTS({m_if14.HBURSTS[2:0],m_if13.HBURSTS[2:0],m_if12.HBURSTS[2:0],m_if11.HBURSTS[2:0],
                                          m_if10.HBURSTS[2:0],m_if9.HBURSTS[2:0],m_if8.HBURSTS[2:0],m_if7.HBURSTS[2:0],
                                          m_if6.HBURSTS[2:0],m_if5.HBURSTS[2:0],m_if4.HBURSTS[2:0],m_if3.HBURSTS[2:0],
                                          m_if2.HBURSTS[2:0],m_if1.HBURSTS[2:0],m_if0.HBURSTS[2:0]}),

                                .HPROTS({m_if14.HPROTS[3:0],m_if13.HPROTS[3:0],m_if12.HPROTS[3:0],m_if11.HPROTS[3:0],
                                         m_if10.HPROTS[3:0],m_if9.HPROTS[3:0],m_if8.HPROTS[3:0],m_if7.HPROTS[3:0],
                                         m_if6.HPROTS[3:0],m_if5.HPROTS[3:0],m_if4.HPROTS[3:0],m_if3.HPROTS[3:0],
                                         m_if2.HPROTS[3:0],m_if1.HPROTS[3:0],m_if0.HPROTS[3:0]}),

                                .HMASTERS({m_if14.HMASTERS[3:0],m_if13.HMASTERS[3:0],m_if12.HMASTERS[3:0],m_if11.HMASTERS[3:0],
                                           m_if10.HMASTERS[3:0],m_if9.HMASTERS[3:0],m_if8.HMASTERS[3:0],m_if7.HMASTERS[3:0],
                                           m_if6.HMASTERS[3:0],m_if5.HMASTERS[3:0],m_if4.HMASTERS[3:0],m_if3.HMASTERS[3:0],
                                           m_if2.HMASTERS[3:0],m_if1.HMASTERS[3:0],m_if0.HMASTERS[3:0]}),

                                .HMASTLOCKS({m_if14.HMASTLOCKS,m_if13.HMASTLOCKS,m_if12.HMASTLOCKS,m_if11.HMASTLOCKS,m_if10.HMASTLOCKS,
                                             m_if9.HMASTLOCKS,m_if8.HMASTLOCKS,m_if7.HMASTLOCKS,m_if6.HMASTLOCKS,m_if5.HMASTLOCKS,
                                             m_if4.HMASTLOCKS,m_if3.HMASTLOCKS,m_if2.HMASTLOCKS,m_if1.HMASTLOCKS,
                                             m_if0.HMASTLOCKS}),

                                .HRESPM({s_if14.HRESPM[1:0],s_if13.HRESPM[1:0],s_if12.HRESPM[1:0],s_if11.HRESPM[1:0],s_if10.HRESPM[1:0],
                                         s_if9.HRESPM[1:0],s_if8.HRESPM[1:0],s_if7.HRESPM[1:0],s_if6.HRESPM[1:0],
                                         s_if5.HRESPM[1:0],s_if4.HRESPM[1:0],s_if3.HRESPM[1:0],s_if2.HRESPM[1:0],
                                         s_if1.HRESPM[1:0],s_if0.HRESPM[1:0]}),

                                .HRDATAM({s_if14.HRDATAM[31:0],s_if13.HRDATAM[31:0],s_if12.HRDATAM[31:0],s_if11.HRDATAM[31:0],
                                          s_if10.HRDATAM[31:0],s_if9.HRDATAM[31:0],s_if8.HRDATAM[31:0],s_if7.HRDATAM[31:0],
                                          s_if6.HRDATAM[31:0],s_if5.HRDATAM[31:0],s_if4.HRDATAM[31:0],s_if3.HRDATAM[31:0],
                                          s_if2.HRDATAM[31:0],s_if1.HRDATAM[31:0],s_if0.HRDATAM[31:0]}),

                                .HREADYOUTM({s_if14.HREADYOUTM,s_if13.HREADYOUTM,s_if12.HREADYOUTM,s_if11.HREADYOUTM,s_if10.HREADYOUTM,
                                             s_if9.HREADYOUTM,s_if6.HREADYOUTM,s_if7.HREADYOUTM,s_if6.HREADYOUTM,s_if5.HREADYOUTM,
                                             s_if4.HREADYOUTM,s_if3.HREADYOUTM,s_if2.HREADYOUTM,s_if1.HREADYOUTM,
                                             s_if0.HREADYOUTM}),

			        .HREADYOUTS({m_if14.HREADYOUTS,m_if13.HREADYOUTS,m_if12.HREADYOUTS,m_if11.HREADYOUTS,m_if10.HREADYOUTS,
                                             m_if9.HREADYOUTS,m_if8.HREADYOUTS,m_if7.HREADYOUTS,m_if6.HREADYOUTS,m_if5.HREADYOUTS,
                                             m_if4.HREADYOUTS,m_if3.HREADYOUTS,m_if2.HREADYOUTS,m_if1.HREADYOUTS,
                                             m_if0.HREADYOUTS}),

                                .HRESPS({m_if14.HRESPS[1:0],m_if13.HRESPS[1:0],m_if12.HRESPS[1:0],m_if11.HRESPS[1:0],m_if10.HRESPS[1:0],
                                         m_if9.HRESPS[1:0],m_if8.HRESPS[1:0],m_if7.HRESPS[1:0],m_if6.HRESPS[1:0],
                                         m_if5.HRESPS[1:0],m_if4.HRESPS[1:0],m_if3.HRESPS[1:0],m_if2.HRESPS[1:0],
                                         m_if1.HRESPS[1:0],m_if0.HRESPS[1:0]}),

                                .HRDATAS({m_if14.HRDATAS[31:0],m_if13.HRDATAS[31:0],m_if12.HRDATAS[31:0],m_if11.HRDATAS[31:0],
                                          m_if10.HRDATAS[31:0],m_if9.HRDATAS[31:0],m_if8.HRDATAS[31:0],m_if7.HRDATAS[31:0],
                                          m_if6.HRDATAS[31:0],m_if5.HRDATAS[31:0],m_if4.HRDATAS[31:0],m_if3.HRDATAS[31:0],
                                          m_if2.HRDATAS[31:0],m_if1.HRDATAS[31:0],m_if0.HRDATAS[31:0]}),

                                .HSELM({s_if14.HSELM,s_if13.HSELM,s_if12.HSELM,s_if11.HSELM,s_if10.HSELM,
                                        s_if9.HSELM,s_if8.HSELM,s_if7.HSELM,s_if6.HSELM,s_if5.HSELM,
                                        s_if4.HSELM,s_if3.HSELM,s_if2.HSELM,s_if1.HSELM,s_if0.HSELM}),

			        .HADDRM({s_if14.HADDRM[31:0],s_if13.HADDRM[31:0],s_if12.HADDRM[31:0],s_if11.HADDRM[31:0],
                                         s_if10.HADDRM[31:0],s_if9.HADDRM[31:0],s_if8.HADDRM[31:0],s_if7.HADDRM[31:0],
                                         s_if6.HADDRM[31:0],s_if5.HADDRM[31:0],s_if4.HADDRM[31:0],s_if3.HADDRM[31:0],
                                         s_if2.HADDRM[31:0],s_if1.HADDRM[31:0],s_if0.HADDRM[31:0]}),

                                .HTRANSM({s_if14.HTRANSM[1:0],s_if13.HTRANSM[1:0],s_if12.HTRANSM[1:0],s_if11.HTRANSM[1:0],s_if10.HTRANSM[1:0],
                                          s_if9.HTRANSM[1:0],s_if8.HTRANSM[1:0],s_if7.HTRANSM[1:0],s_if6.HTRANSM[1:0],
                                          s_if5.HTRANSM[1:0],s_if4.HTRANSM[1:0],s_if3.HTRANSM[1:0],s_if2.HTRANSM[1:0],
                                          s_if1.HTRANSM[1:0],s_if0.HTRANSM[1:0]}),

                                .HWRITEM({s_if14.HWRITEM,s_if13.HWRITEM,s_if12.HWRITEM,s_if11.HWRITEM,s_if10.HWRITEM,
                                          s_if9.HWRITEM,s_if8.HWRITEM,s_if7.HWRITEM,s_if6.HWRITEM,s_if5.HWRITEM,
                                          s_if4.HWRITEM,s_if3.HWRITEM,s_if2.HWRITEM,s_if1.HWRITEM,s_if0.HWRITEM}),

                                .HSIZEM({s_if14.HSIZEM[2:0],s_if13.HSIZEM[2:0],s_if12.HSIZEM[2:0],s_if11.HSIZEM[2:0],
                                         s_if10.HSIZEM[2:0],s_if9.HSIZEM[2:0],s_if8.HSIZEM[2:0],s_if7.HSIZEM[2:0],
                                         s_if6.HSIZEM[2:0],s_if5.HSIZEM[2:0],s_if4.HSIZEM[2:0],s_if3.HSIZEM[2:0],
                                         s_if2.HSIZEM[2:0],s_if1.HSIZEM[2:0],s_if0.HSIZEM[2:0]}),

                                .HBURSTM({s_if14.HBURSTM[2:0],s_if13.HBURSTM[2:0],s_if12.HBURSTM[2:0],s_if11.HBURSTM[2:0],
                                          s_if10.HBURSTM[2:0],s_if9.HBURSTM[2:0],s_if8.HBURSTM[2:0],s_if7.HBURSTM[2:0],
                                          s_if6.HBURSTM[2:0],s_if5.HBURSTM[2:0],s_if4.HBURSTM[2:0],s_if3.HBURSTM[2:0],
                                          s_if2.HBURSTM[2:0],s_if1.HBURSTM[2:0],s_if0.HBURSTM[2:0]}),

			        .HPROTM({s_if14.HPROTM[3:0],s_if13.HPROTM[3:0],s_if12.HPROTM[3:0],s_if11.HPROTM[3:0],
                                         s_if10.HPROTM[3:0],s_if9.HPROTM[3:0],s_if8.HPROTM[3:0],s_if7.HPROTM[3:0],
                                         s_if6.HPROTM[3:0],s_if5.HPROTM[3:0],s_if4.HPROTM[3:0],s_if3.HPROTM[3:0],
                                         s_if2.HPROTM[3:0],s_if1.HPROTM[3:0],s_if0.HPROTM[3:0]}),

                                .HMASTERM({s_if14.HMASTERM[3:0],s_if13.HMASTERM[3:0],s_if12.HMASTERM[3:0],s_if11.HMASTERM[3:0],
                                           s_if10.HMASTERM[3:0],s_if9.HMASTERM[3:0],s_if8.HMASTERM[3:0],s_if7.HMASTERM[3:0],
                                           s_if6.HMASTERM[3:0],s_if5.HMASTERM[3:0],s_if4.HMASTERM[3:0],s_if3.HMASTERM[3:0],
                                           s_if2.HMASTERM[3:0],s_if1.HMASTERM[3:0],s_if0.HMASTERM[3:0]}),

                                .HMASTLOCKM({s_if14.HMASTLOCKM,s_if13.HMASTLOCKM,s_if12.HMASTLOCKM,s_if11.HMASTLOCKM,s_if10.HMASTLOCKM,
                                             s_if9.HMASTLOCKM,s_if8.HMASTLOCKM,s_if7.HMASTLOCKM,s_if6.HMASTLOCKM,s_if5.HMASTLOCKM,
                                             s_if4.HMASTLOCKM,s_if3.HMASTLOCKM,s_if2.HMASTLOCKM,s_if1.HMASTLOCKM,
                                             s_if0.HMASTLOCKM}),

                                .HWDATAM({s_if14.HWDATAM[31:0],s_if13.HWDATAM[31:0],s_if12.HWDATAM[31:0],s_if11.HWDATAM[31:0],
                                          s_if10.HWDATAM[31:0],s_if9.HWDATAM[31:0],s_if8.HWDATAM[31:0],s_if7.HWDATAM[31:0],
                                          s_if6.HWDATAM[31:0],s_if5.HWDATAM[31:0],s_if4.HWDATAM[31:0],s_if3.HWDATAM[31:0],
                                          s_if2.HWDATAM[31:0],s_if1.HWDATAM[31:0],s_if0.HWDATAM[31:0]}),

                                .HREADYM({s_if14.HREADYM,s_if13.HREADYM,s_if12.HREADYM,s_if11.HREADYM,s_if10.HREADYM,
                                          s_if9.HREADYM,s_if8.HREADYM,s_if7.HREADYM,s_if6.HREADYM,s_if5.HREADYM,
                                          s_if4.HREADYM,s_if3.HREADYM,s_if2.HREADYM,s_if1.HREADYM,s_if0.HREADYM}));


  initial
    begin
      uvm_config_db#(virtual slv_interface)::set(null,"*","svif[0]",s_if0);
      uvm_config_db#(virtual slv_interface)::set(null,"*","svif[1]",s_if1);
      uvm_config_db#(virtual slv_interface)::set(null,"*","svif[2]",s_if2);
      uvm_config_db#(virtual slv_interface)::set(null,"*","svif[3]",s_if3);
      uvm_config_db#(virtual slv_interface)::set(null,"*","svif[4]",s_if4);
      uvm_config_db#(virtual slv_interface)::set(null,"*","svif[5]",s_if5);
      uvm_config_db#(virtual slv_interface)::set(null,"*","svif[6]",s_if6);
      uvm_config_db#(virtual slv_interface)::set(null,"*","svif[7]",s_if7);
      uvm_config_db#(virtual slv_interface)::set(null,"*","svif[8]",s_if8);
      uvm_config_db#(virtual slv_interface)::set(null,"*","svif[9]",s_if9);
      uvm_config_db#(virtual slv_interface)::set(null,"*","svif[10]",s_if10);
      uvm_config_db#(virtual slv_interface)::set(null,"*","svif[11]",s_if11);
      uvm_config_db#(virtual slv_interface)::set(null,"*","svif[12]",s_if12);
      uvm_config_db#(virtual slv_interface)::set(null,"*","svif[13]",s_if13);
      uvm_config_db#(virtual slv_interface)::set(null,"*","svif[14]",s_if14);
      
      uvm_config_db#(virtual mas_interface)::set(null,"*","mvif[0]",m_if0);
      uvm_config_db#(virtual mas_interface)::set(null,"*","mvif[1]",m_if1);
      uvm_config_db#(virtual mas_interface)::set(null,"*","mvif[2]",m_if2);
      uvm_config_db#(virtual mas_interface)::set(null,"*","mvif[3]",m_if3);
      uvm_config_db#(virtual mas_interface)::set(null,"*","mvif[4]",m_if4);
      uvm_config_db#(virtual mas_interface)::set(null,"*","mvif[5]",m_if5);
      uvm_config_db#(virtual mas_interface)::set(null,"*","mvif[6]",m_if6);
      uvm_config_db#(virtual mas_interface)::set(null,"*","mvif[7]",m_if7);
      uvm_config_db#(virtual mas_interface)::set(null,"*","mvif[8]",m_if8);
      uvm_config_db#(virtual mas_interface)::set(null,"*","mvif[9]",m_if9);
      uvm_config_db#(virtual mas_interface)::set(null,"*","mvif[10]",m_if10);
      uvm_config_db#(virtual mas_interface)::set(null,"*","mvif[11]",m_if11);
      uvm_config_db#(virtual mas_interface)::set(null,"*","mvif[12]",m_if12);
      uvm_config_db#(virtual mas_interface)::set(null,"*","mvif[13]",m_if13);
      uvm_config_db#(virtual mas_interface)::set(null,"*","mvif[14]",m_if14);
      
      run_test("test");
    end
  endmodule:tb_top