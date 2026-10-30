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
//16 bit zero detector
module ZeroDetector(C,A);

    input logic [16:0] A;
    output logic  C;
    
    //wires
    logic out_nor_1, out_nor_2, out_nor_3, out_nor_4;
    
    NOR4 NorGate_1(.Z(out_nor_1), .A(A[0]), .B(A[1]), .C(A[2]), .D(A[3]));
    NOR4 NorGate_2(.Z(out_nor_2), .A(A[4]), .B(A[5]), .C(A[6]), .D(A[7]));
    NOR4 NorGate_3(.Z(out_nor_3), .A(A[8]), .B(A[9]), .C(A[10]), .D(A[11]));
    NOR4 NorGate_4(.Z(out_nor_4), .A(A[12]), .B(A[13]), .C(A[14]), .D(A[15]));
    
    AND4 AndGate(.Z(C), .A(out_nor_1), .B(out_nor_2), .C(out_nor_3), .D(out_nor_4));
        
endmodule



//module ALU(ALU_mode, A, B, CarryIn, cfg_ALU_CarrySel, Out_1, Out_2, CarryOut, ZeroFlag);

////    input logic ALU_mode, CarryIn;
////    input logic [1:0] cfg_ALU_CarrySel;
////    input logic [15:0] A,B;
////    output logic [15:0] Out_1,Out_2;
////    output logic CarryOut, ZeroFlag;
    
////    //wires
////    logic [15:0] B_selected;
////    logic [15:0] Out_Not, Out_OR, Out_AND, Out_Adder;
////    logic ALU_Carry_select;
    
    
    
////    // carry mux
////    mux_4 Carry_select_Mux(.I0(1'b0),.I1(1'b1),.I2(CarryIn),.I3(CarryIn),.S(cfg_ALU_CarrySel), .O(ALU_Carry_select) );
    
////    //B input select logic
    
////    //ALU OPS
////    NOT_16bit ALU_NOT_Gate(.c(Out_Not), .a(A));
////    OR_16bit ALU_OR_Gate( .c(Out_OR), .a(A), .b(B_selected) );
////    AND_16bit ALU_AND_Gate(.a(A), .b(B_selected), .c(Out_AND));
////    adder_16bit ALU_ADDER_Gate(.a(A), .b(B_selected), .Cin(ALU_Carry_select), .Out(Out_Adder), .Cout(CarryOut));
    
    
    
////    //zero flag generation
    

////    // out mux
////    //1 -> Out_Not
////    //2 -> Out_OR
//endmodule
