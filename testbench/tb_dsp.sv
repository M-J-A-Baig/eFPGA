`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2026 08:52:06 AM
// Design Name: 
// Module Name: tb_dsp
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

module tb_ZeroDetector;
    logic [16:0] A;
    logic  C;
    
    ZeroDetector dut(.C(C), .A(A));
    
    integer i;
    
    initial     
        begin
            $dumpfile("dump.vcd");
            $dumpvars(0, tb_ZeroDetector);
                
            for(i = 0; i< 50; i++)
                    begin
                         A = $random;
                        #10;
                        A = 0;
                        #10;
                        A = $random;
                        #10;
                        
                    end
                $finish;     
        end
endmodule 




module tb_dsp;
endmodule
