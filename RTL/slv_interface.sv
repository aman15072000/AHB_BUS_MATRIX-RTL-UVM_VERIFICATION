////////////////////////////////////slv_interface.sv/////////////////////
  /********************************************************************************************

  Copyright 2024 - Maven Silicon Softech Pvt Ltd.  

  www.maven-silicon.com

  All Rights Reserved.

  This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
  It is not to be shared with or used by any third parties who have not enrolled for our paid 
  training courses or received any written authorization from Maven Silicon.

  Filename                :       slv_interface.sv   

  module Name             :       slv_interface

  Description             :       Slave Interface for AHB Bus Matrix 

  Author Name             :       K Sriguru

  Support e-mail          :       For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

  Version                 :       1.0

  *********************************************************************************************/

 // import cvw::*;

  interface slv_interface(input bit HCLK);

    logic [1:0] HRESPM;
    logic [31:0]HRDATAM;
    logic       HREADYOUTM;

    logic       HSELM;
    logic [31:0]HADDRM;
    logic [1:0] HTRANSM;
    logic       HWRITEM;
    logic [2:0] HSIZEM;
    logic [2:0] HBURSTM;
    logic [3:0] HPROTM;
    logic [3:0] HMASTERM;
    logic       HMASTLOCKM;
    logic [31:0]HWDATAM;
    logic       HREADYM;
    logic [1:0] resp;

    clocking sdrv_cb@(posedge HCLK);
  //    default input #1 output #1;
      output HRESPM,HRDATAM,HREADYOUTM,resp;
      input  HWRITEM,HSELM,HADDRM,HTRANSM,HSIZEM,HBURSTM,HPROTM,HMASTERM,HMASTLOCKM,HWDATAM,HREADYM;
    endclocking

    clocking smon_cb@(posedge HCLK);
    //  default input #1 output #1;
      input HRESPM,HRDATAM,HREADYOUTM,HWRITEM,HSELM,HADDRM,HTRANSM,HSIZEM,HBURSTM,HPROTM,HMASTERM,HMASTLOCKM,HWDATAM,HREADYM,resp;
    endclocking


    modport SLV_DRV_MP(clocking sdrv_cb);

    modport SLV_MON_MP(clocking smon_cb);

  endinterface:slv_interface