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



module ALU(ALU_mode, cfg_ALU_mode, A, B, CarryIn, cfg_Carry_sel, cfg_ALU_CarrySel, Out_1, Out_2, CarryOut, ZeroFlag);

    input logic ALU_mode, CarryIn;
    input logic [2:0] cfg_ALU_mode;
    input logic [1:0] cfg_ALU_CarrySel;
    input logic [15:0] A,B;
    output logic [15:0] Out_1,Out_2;
    output logic CarryOut, ZeroFlag;
    
    //wires
    logic [15:0] Wire_B_selected_Latch;
    logic [15:0] Wire_Out_Not, Wire_Out_OR, Wire_Out_AND, Wire_Out_Adder;
    logic ALU_Carry_select;
    logic [2:0] Wire_ALU_mode_Latch;
    logic [1:0] Wire_ALU_CarrySel_Latch;
    
    
    // latches
    DLatch#(3) out_sel_latch(.d(ALU_mode), .enable(cfg_ALU_mode), .q(Wire_ALU_mode_Latch));
    DLatch#(3) carry_sel_latch(.d(cfg_ALU_CarrySel), .enable(cfg_Carry_sel), .q(Wire_ALU_CarrySel_Latch));
    
    DLatch#(3) B_sel_latch(.d(), .enable(), .q(Wire_B_selected_Latch));
    
    
    // carry mux
    mux_4 Carry_select_Mux(.I0(1'b0),.I1(1'b1),.I2(CarryIn),.I3(CarryIn),.S(Wire_ALU_CarrySel_Latch), .O(ALU_Carry_select) );
    
    //B input select logic
    
    //ALU OPS
    NOT_16bit ALU_NOT_Gate(.c(Wire_Out_Not), .a(A));
    OR_16bit ALU_OR_Gate( .c(Wire_Out_OR), .a(A), .b(Wire_B_selected_Latch) );
    AND_16bit ALU_AND_Gate(.a(A), .b(Wire_B_selected_Latch), .c(Wire_Out_AND));
    adder_16bit ALU_ADDER_Gate(.a(A), .b(Wire_B_selected_Latch), .Cin(ALU_Carry_select), .Out(Wire_Out_Adder), .Cout(CarryOut));
    
    
    //zero flag generation
    ZeroDetector detector(.C(ZeroFlag),.A(Wire_Out_Adder));


    // out mux
    //ALU Mode =  1.and  2.or  3. not  4.adder   5. subtractor   6.lessthan   7.greater than    8.equals to                                                                                           
    Mux8_16bit out_mux(.O(Out_1), .A(Wire_Out_AND), .B(Wire_Out_OR), .C(Wire_Out_Not), .D(Wire_Out_Adder), .E(Wire_Out_Adder), .F({7{Wire_Out_Adder[7]}}), .G({7{Wire_Out_Adder[7]}}), .H(Wire_Out_Adder), .S(Wire_ALU_mode_Latch));
endmodule
