  ///////////////////////////////cvw.sv/////////////////////////
    /********************************************************************************************

  Copyright 2024 - Maven Silicon Softech Pvt Ltd.  

  www.maven-silicon.com

  All Rights Reserved.

  This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
  It is not to be shared with or used by any third parties who have not enrolled for our paid 
  training courses or received any written authorization from Maven Silicon.

  Filename                :       cvw.sv   

  module Name             :       cvw

  Description             :       Package file for number of masters and slaves

  Author Name             :       K Sriguru

  Support e-mail          :       For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

  Version                 :       1.0

  *********************************************************************************************/



  package cvw;

  typedef struct packed {

    int n;  
  
  } cvw_t;


  localparam n=15;

  localparam cvw_t P = '{ 
    n : n  
  
  };

  endpackage