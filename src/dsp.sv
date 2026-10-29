`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2026 08:51:13 AM
// Design Name: 
// Module Name: dsp
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


module ALU(ALU_mode,A,B,CarryIn,Out_1,Out_2,CarryOut,ZeroFlag);

    input logic ALU_mode, CarryIn;
    input logic [15:0] A,B;
    output logic [15:0] Out_1,Out_2;
    output logic CarryOut, ZeroFlag;
    
    
    //
    NOT_16bit(c,a);
    OR_16bit(c,a,b);
    AND_16bit(a,b,c);
    adder_16bit(a, b, Cin, Out, Cout);
    


endmodule
