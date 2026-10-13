`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2026 10:42:31 AM
// Design Name: 
// Module Name: tb_Dlatch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_Dlatch();
    
      logic d,en,q;
      
      DLatch dut(
          .d(d),
          .q(q),
          .enable(en)
       );
       
       
       initial
        begin
            en <= 0; d<=0; 
            #10
            en <= 1; d<=0; 
            #10
            en <= 0; d<=0; 
            #10
            en <= 0; d<=1; 
            #10
            en <= 1; d<=1; 
            #10
            en <= 0; d<=1; 
            #10
            en <= 0; d<=0; 
            #10
          $finish;
        
        end   
      
endmodule
