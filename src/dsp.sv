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
//17 bit zero detector
module ZeroDetector(C,A);

    input logic [16:0] A;
    output logic  C;
    
    //wires
    logic out_nor_1, out_nor_2, out_nor_3, out_nor_4, Intermediated_value;
    
    //stage 1
    NOR4 NorGate_1(.Z(out_nor_1), .A(A[0]), .B(A[1]), .C(A[2]), .D(A[3]));
    NOR4 NorGate_2(.Z(out_nor_2), .A(A[4]), .B(A[5]), .C(A[6]), .D(A[7]));
    NOR4 NorGate_3(.Z(out_nor_3), .A(A[8]), .B(A[9]), .C(A[10]), .D(A[11]));
    NOR4 NorGate_4(.Z(Intermediated_value), .A(A[12]), .B(A[13]), .C(A[14]), .D(A[15]));
    
    //stage 2
    NOR2 NorGate_15_16(.Z(out_nor_4), .A(~Intermediated_value), .B(A[16]));
    
    //stage 3
    AND4 AndGate(.Z(C), .A(out_nor_1), .B(out_nor_2), .C(out_nor_3), .D(out_nor_4));
        
endmodule



module ALU(ALU_mode, cfg_flag, A, B, cfg_ALU_CarrySel, ALU_Carry_IN, Out, CarryOut, ZeroFlag);

    input logic [2:0] ALU_mode;
    input logic cfg_flag;
    input logic ALU_Carry_IN;
    input logic [1:0] cfg_ALU_CarrySel;
    input logic [16:0] A,B;
    output logic [16:0] Out;
    output logic CarryOut, ZeroFlag;
    
    //wires
    logic [16:0] notB, Wire_B_selected;
    logic [16:0] Wire_Out_Not, Wire_Out_OR, Wire_Out_AND, Wire_Out_Adder;
    logic ALU_Carry_select;
    logic [2:0] Wire_BSelected_ALUmode_Latch; //Wire_ALU_Out1_Latched, Wire_ALU_Out2_Latched, Wire_B_selected_Latch;
    logic [1:0] Wire_ALU_CarrySel_Latch;
    
    
    // Selection/Mux latches
    DLatch#(3) ALU_mode_latch(.d(ALU_mode), .enable(cfg_flag), .q(Wire_BSelected_ALUmode_Latch));
    DLatch#(2) carry_sel_latch(.d(cfg_ALU_CarrySel), .enable(cfg_flag), .q(Wire_ALU_CarrySel_Latch));
//    DLatch#(1) out_sel1_latch(.d(cfg_Out1_sel), .enable(cfg_flag), .q(Wire_ALU_Out1_Latched));
    
    //formatting B
    NOT_17bit B_NOT_Gate(.c(notB), .a(B));
    
        
    // input muxes
   Mux8_17bit B_comp_select(.O(Wire_B_selected), .A(B), .B(B), .C(B), .D(B), .E(notB), .F(notB), .G(notB), .H(notB), .S(Wire_BSelected_ALUmode_Latch)); // input for alu ops
   mux_4 Carry_select_Mux(.I0(1'b0),.I1(1'b1),.I2(CarryIn),.I3(CarryIn),.S(Wire_ALU_CarrySel_Latch), .O(ALU_Carry_select) );
    
    //B input select logic
    
    //ALU OPS
    NOT_17bit ALU_NOT_Gate(.c(Wire_Out_Not), .a(A));
    OR_17bit ALU_OR_Gate( .c(Wire_Out_OR), .a(A), .b(Wire_B_selected) );
    AND_17bit ALU_AND_Gate(.a(A), .b(Wire_B_selected), .c(Wire_Out_AND));
    adder_17bit ALU_ADDER_Gate(.a(A), .b(Wire_B_selected), .Cin(ALU_Carry_select), .Out(Wire_Out_Adder), .Cout(CarryOut));
        
    //zero flag generation
    ZeroDetector detector(.C(ZeroFlag),.A(Wire_Out_Adder));

    // out mux
    //      ALU Mode =              1.and               2.or            3. not              4.adder             5. subtractor           6.lessthan              7.greater than              8.equals to                                                                                           
    Mux8_17bit out_mux(.O(Out), .A(Wire_Out_AND), .B(Wire_Out_OR), .C(Wire_Out_Not), .D(Wire_Out_Adder), .E(Wire_Out_Adder), .F({17{Wire_Out_Adder[7]}}), .G({17{Wire_Out_Adder[7]}}), .H(Wire_Out_Adder), .S(Wire_BSelected_ALUmode_Latch));
    
endmodule
