  /////////////////////////////default_slave.v/////////////////////
    /********************************************************************************************

  Copyright 2024 - Maven Silicon Softech Pvt Ltd.  

  www.maven-silicon.com

  All Rights Reserved.

  This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
  It is not to be shared with or used by any third parties who have not enrolled for our paid 
  training courses or received any written authorization from Maven Silicon.

  Filename                :       default_slave.v   

  module Name             :       default_slave

  Description             :       Instantiated in decode stage to act as slave when address is not found in the mapped locations 

  Author Name             :       K Sriguru

  Support e-mail          :       For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

  Version                 :       1.0

  *********************************************************************************************/   




  module default_slave (
                        // Common AHB signals
                        input         HCLK,           // AHB System Clock
                        input         HRESETn,        // AHB System Reset

                        // AHB control input signals
                        input         HSEL,           // Slave Select
                        input         HTRANS,         // Transfer type
                        input         HREADY,         // Transfer done

                        // AHB control output signals
                        output reg    HREADYOUT,      // HREADY feedback
                        output reg [1:0] HRESP        // Transfer response
		        );         



  `define RSP_OKAY    2'b00         // OKAY response
  `define RSP_ERROR   2'b01         // ERROR response
  `define RSP_RETRY   2'b10         // RETRY response
  `define RSP_SPLIT   2'b11         // SPLIT response


  wire          invalid;    	   // Set during invalid transfer
  wire          iHREADYOUT;
  wire          iHRESP;

  always@(posedge HCLK or negedge HRESETn)
    begin
      if(!HRESETn)
        begin
          HREADYOUT <= 0;
	  HRESP     <= 0;
        end

      else
        begin
          HREADYOUT <= iHREADYOUT;
	  HRESP     <= iHRESP;
        end
    end

  assign invalid = (HREADY & HSEL & HTRANS);
  assign iHREADYOUT = HSEL ? 1'b1 : 1'b0;
  assign iHRESP = invalid ? `RSP_ERROR : `RSP_OKAY;


  endmodule