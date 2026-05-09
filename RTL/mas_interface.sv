  ///////////////////////////////mas_interface.sv//////////////////////
    /********************************************************************************************

  Copyright 2024 - Maven Silicon Softech Pvt Ltd.  

  www.maven-silicon.com

  All Rights Reserved.

  This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
  It is not to be shared with or used by any third parties who have not enrolled for our paid 
  training courses or received any written authorization from Maven Silicon.

  Filename                :       mas_interface.sv   

  module Name             :       mas_interface

  Description             :       Master Interface for AHB Bus Matrix 

  Author Name             :       K Sriguru

  Support e-mail          :       For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

  Version                 :       1.0

  *********************************************************************************************/



  import cvw::*;

  interface mas_interface(input bit HCLK);


    logic       HRESETn;
    logic [3:0] REMAP;
    logic       HSELS;
    logic [31:0]HADDRS;
    logic [31:0]HWDATAS;
    logic [1:0] HTRANSS;
    logic       HWRITES;
    logic [2:0] HSIZES;
    logic [2:0] HBURSTS;
    logic [3:0] HPROTS;
    logic [3:0] HMASTERS;
    logic       HMASTLOCKS;
    logic       HREADYOUTS;
    logic [1:0] HRESPS;
    logic [31:0]HRDATAS;

    clocking mdrv_cb@(posedge HCLK);
  //    default input #1 output #1;
      input HREADYOUTS,HRESPS,HRDATAS;
      output HRESETn,REMAP,HSELS,HADDRS,HWDATAS,HTRANSS,HSIZES,HBURSTS,HPROTS,HMASTERS,HMASTLOCKS,
			HWRITES;
    endclocking

    clocking mmon_cb@(posedge HCLK);
    //  default input #1 output #1;
      input HRESETn,REMAP,HSELS,HADDRS,HWDATAS,HTRANSS,HSIZES,HBURSTS,HPROTS,HMASTERS,HMASTLOCKS,HWRITES,HREADYOUTS,HRESPS,HRDATAS;
    endclocking


    modport MAS_DRV_MP(clocking mdrv_cb);

    modport MAS_MON_MP(clocking mmon_cb);

  endinterface