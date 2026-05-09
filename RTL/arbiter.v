		/////////////////////arbiter.v/////////////////////////
		  /********************************************************************************************

  Copyright 2024 - Maven Silicon Softech Pvt Ltd.  

  www.maven-silicon.com

  All Rights Reserved.

  This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
  It is not to be shared with or used by any third parties who have not enrolled for our paid 
  training courses or received any written authorization from Maven Silicon.

  Filename                :       arbiter.v   

  module Name             :       arbiter

  Description             :       When master is accessing shared slave upon priority master is given access

  Author Name             :       K Sriguru

  Support e-mail          :       For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

  Version                 :       1.0

  *********************************************************************************************/




  module arbiter #(parameter N=15)(
                                  // Common AHB signals
                                  input        HCLK,            // AHB system clock
                                  input        HRESETn,         // AHB system reset

                                  input  [N-1:0]req_port,       // Port 0 request signal

                                  input        HREADYM,         // Transfer done
                                  input  [1:0] HTRANSM,         // Transfer type
                                  input        HMASTLOCKM,      // Locked transfer

                                  output reg [3:0]addr_in_port, // Port address input
                                  output reg      no_port       // No port selected signal
                                  );


  reg  [3:0]addr_in_port_next; // D-input of addr_in_port
  reg  no_port_next;           // D-input of no_port


  always@(req_port or HMASTLOCKM)
    begin
      // Default values are used for addr_in_port_next and no_port_next
      no_port_next     = 1'b0;
      addr_in_port_next = 1'bz;

      if (HMASTLOCKM)
        addr_in_port_next = 4'bz;

      else if (req_port[0] )
        addr_in_port_next = 4'd0;
      
      else if (req_port[1] )
        addr_in_port_next = 4'd1;

      else if (req_port[2] )
        addr_in_port_next = 4'd2;              
      
      else if (req_port[3] )
        addr_in_port_next = 4'd3;

      else if (req_port[4] )
        addr_in_port_next = 4'd4;
      
      else if (req_port[5] )
        addr_in_port_next = 4'd5;

      else if (req_port[6] )
        addr_in_port_next = 4'd6;
      
      else if (req_port[7] )
        addr_in_port_next = 4'd7;

      else if (req_port[8] )
        addr_in_port_next = 4'd8;
      
      else if (req_port[9] )
        addr_in_port_next = 4'd9;

      else if (req_port[10] )
        addr_in_port_next = 4'd10;
      
      else if (req_port[11] )
        addr_in_port_next = 4'd11;

      else if (req_port[12] )
        addr_in_port_next = 4'd12;
      
      else if (req_port[13])
        addr_in_port_next = 4'd13;

      else if (req_port[14])
        addr_in_port_next = 4'd14;

      else
        no_port_next = 1'b1;
    end


  always@(negedge HRESETn or posedge HCLK)
    begin
      if(~HRESETn)
        begin
          no_port<=1'b1;
          addr_in_port<=4'bz;
        end

      else
        begin
          no_port <= no_port_next;
          addr_in_port <= addr_in_port_next;
        end
    end

  endmodule