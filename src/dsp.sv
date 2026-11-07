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

    input logic [15:0] A;
    output logic  C;
    
    //wires
    logic out_nor_1, out_nor_2, out_nor_3, out_nor_4;
    
    //stage 1
    NOR4 NorGate_1(.Z(out_nor_1), .A(A[0]), .B(A[1]), .C(A[2]), .D(A[3]));
    NOR4 NorGate_2(.Z(out_nor_2), .A(A[4]), .B(A[5]), .C(A[6]), .D(A[7]));
    NOR4 NorGate_3(.Z(out_nor_3), .A(A[8]), .B(A[9]), .C(A[10]), .D(A[11]));
    NOR4 NorGate_4(.Z(out_nor_4), .A(A[12]), .B(A[13]), .C(A[14]), .D(A[15]));
    
    //stage 2
//    NOR2 NorGate_15_16(.Z(out_nor_4), .A(~Intermediated_value), .B(A[16]));
    
    //stage 3
    AND4 AndGate(.Z(C), .A(out_nor_1), .B(out_nor_2), .C(out_nor_3), .D(out_nor_4));
        
endmodule




//alu
module ALU(ALU_mode, cfg_flag, A, B, cfg_ALU_CarrySel, ALU_Carry_IN, Out, CarryOut, ZeroFlag);

    input logic [2:0] ALU_mode;
    input logic cfg_flag;
    input logic ALU_Carry_IN;
    input logic [1:0] cfg_ALU_CarrySel;
    input logic [15:0] A,B;
    output logic [15:0] Out;
    output logic CarryOut, ZeroFlag;
    
    //wires
    logic [15:0] notB, Wire_B_selected;
    logic [15:0] Wire_Out_Not, Wire_Out_OR, Wire_Out_AND, Wire_Out_Adder;
    logic ALU_Carry_select;
    logic [2:0] Wire_BSelected_ALUmode_Latch; //Wire_ALU_Out1_Latched, Wire_ALU_Out2_Latched, Wire_B_selected_Latch;
    logic [1:0] Wire_ALU_CarrySel_Latch;
    logic wire_aLessThanb, wire_NotZero, wire_aGreaterThanb;
    
    
    // Selection/Mux latches
    DLatch#(3) ALU_mode_latch(.d(ALU_mode), .enable(cfg_flag), .q(Wire_BSelected_ALUmode_Latch));
    DLatch#(2) carry_sel_latch(.d(cfg_ALU_CarrySel), .enable(cfg_flag), .q(Wire_ALU_CarrySel_Latch));
//    DLatch#(1) out_sel1_latch(.d(cfg_Out1_sel), .enable(cfg_flag), .q(Wire_ALU_Out1_Latched));
    
    //formatting B
    NOT_16bit B_NOT_Gate(.c(notB), .a(B));
    
        
    // input muxes
   Mux8_16bit B_comp_select(.O(Wire_B_selected), .A(B), .B(B), .C(B), .D(B), .E(notB), .F(notB), .G(notB), .H(notB), .S(Wire_BSelected_ALUmode_Latch)); // input for alu ops
   mux_4 Carry_select_Mux(.I0(1'b0),.I1(1'b1),.I2(CarryIn),.I3(CarryIn),.S(Wire_ALU_CarrySel_Latch), .O(ALU_Carry_select) );
    
    //B input select logic
    
    //ALU OPS
    NOT_16bit ALU_NOT_Gate(.c(Wire_Out_Not), .a(A));
    OR_16bit ALU_OR_Gate( .c(Wire_Out_OR), .a(A), .b(Wire_B_selected) );
    AND_16bit ALU_AND_Gate(.a(A), .b(Wire_B_selected), .c(Wire_Out_AND));
    adder_16bit ALU_ADDER_Gate(.a(A), .b(Wire_B_selected), .Cin(ALU_Carry_select), .Out(Wire_Out_Adder), .Cout(CarryOut));
        
    //zero flag generation
    ZeroDetector detector(.C(ZeroFlag),.A(Wire_Out_Adder));
    
    //for a<b
    not (wire_aLessThanb, CarryOut);
    not (wire_NotZero, ZeroFlag );
    and (wire_aGreaterThanb, CarryOut, wire_NotZero);
    

    // out mux
    //      ALU Mode =              0.and               1.or            2. not              3.adder             4. subtractor           5.lessthan              6.greater than              7.equals to                                                                                           
    Mux8_16bit out_mux(.O(Out), .A(Wire_Out_AND), .B(Wire_Out_OR), .C(Wire_Out_Not), .D(Wire_Out_Adder), .E(Wire_Out_Adder), .F({16{wire_aLessThanb}}), .G({16{wire_aGreaterThanb}}), .H(Wire_Out_Adder), .S(Wire_BSelected_ALUmode_Latch));
    
endmodule





//dsp
module DSP(clk, rst, cfg_flag, A, B, C, D, E, F, G, ALU_DSP_IN, ALU_DSP_Cin, 
           cfg_preadder_pipeline_A, cfg_preadder_pipeline_B, cfg_preadder_pipeline_C, cfg_preadder_pipeline_D, cfg_preadder_pipeline_E, cfg_preadder_pipeline_F, cfg_preadder_pipeline_G, cfg_preadder_pipeline_AluDspIn, cfg_preadder_pipeline_AluDspCin,
           cfg_upper_neg_sel, cfg_lower_neg_sel, 
           cfg_premultiplier_pipeline_Adder_upper, cfg_premultiplier_pipeline_C, cfg_premultiplier_pipeline_Adder_lower, cfg_premultiplier_pipeline_F, cfg_premultiplier_pipeline_G, cfg_premultiplier_pipeline_AluDspIn, cfg_premultiplier_pipeline_AluDspCin,
           cfg_postmultiplier_pipeline_upper, cfg_postmultiplier_pipeline_lower, cfg_postmultiplier_pipeline_G, cfg_postmultiplier_pipeline_AluDspIn, cfg_postmultiplier_pipeline_AluDspCin,
           cfg_ALU_operand_sel_A, cfg_ALU_operand_sel_B,
           ALU_mode, cfg_ALU_CarrySel,
           cfg_feedback_PipeReg, cfg_out_1, cfg_out_2,
           ALU_DSP_Out, ALU_DSP_Cout, Out1, Out2, ZeroFlag );


    input logic [7:0] A,B,C,D,E,F;
    input logic [15:0] G,ALU_DSP_IN, ALU_DSP_Cin;
    input logic clk, rst, cfg_flag;
    input logic cfg_preadder_pipeline_A, cfg_preadder_pipeline_B, cfg_preadder_pipeline_C, cfg_preadder_pipeline_D, cfg_preadder_pipeline_E, cfg_preadder_pipeline_F, cfg_preadder_pipeline_G, cfg_preadder_pipeline_AluDspIn, cfg_preadder_pipeline_AluDspCin;
    input logic cfg_upper_neg_sel, cfg_lower_neg_sel;
    input logic cfg_premultiplier_pipeline_Adder_upper, cfg_premultiplier_pipeline_C, cfg_premultiplier_pipeline_Adder_lower, cfg_premultiplier_pipeline_F, cfg_premultiplier_pipeline_G, cfg_premultiplier_pipeline_AluDspIn, cfg_premultiplier_pipeline_AluDspCin;
    input logic cfg_postmultiplier_pipeline_upper, cfg_postmultiplier_pipeline_lower, cfg_postmultiplier_pipeline_G, cfg_postmultiplier_pipeline_AluDspIn, cfg_postmultiplier_pipeline_AluDspCin;
    input logic [1:0]cfg_ALU_operand_sel_A, cfg_ALU_operand_sel_B, cfg_ALU_CarrySel;
    input logic [2:0] ALU_mode;
    input logic cfg_feedback_PipeReg;
    input logic [2:0] cfg_out_1,cfg_out_2;
    
    
    output logic [15:0] ALU_DSP_Out, ALU_DSP_Cout, Out1, Out2;
    output logic ZeroFlag;


    //wires
    logic [7:0] Out_A_InPipeReg, Out_B_InPipeReg, Out_C_InPipeReg, Out_D_InPipeReg, Out_E_InPipeReg, Out_F_InPipeReg;
    logic [15:0] Out_G_InPipeReg, Out_AluDspIn_InPipeReg, Out_AluDspCin_InPipeReg;
    logic wire_PipeSelecetor_latch_A, wire_PipeSelecetor_latch_B, wire_PipeSelecetor_latch_C, wire_PipeSelecetor_latch_D, wire_PipeSelecetor_latch_E, wire_PipeSelecetor_latch_F, wire_PipeSelecetor_latch_G, wire_PipeSelecetor_latch_ALU_DSP_IN, wire_PipeSelecetor_latch_ALU_DSP_Cin;
    logic [7:0] wire_PipeSelecetor_A, wire_PipeSelecetor_B, wire_PipeSelecetor_C, wire_PipeSelecetor_D, wire_PipeSelecetor_E, wire_PipeSelecetor_F;
    logic [15:0] wire_PipeSelecetor_G, wire_PipeSelecetor_ALU_DSP_IN, wire_PipeSelecetor_ALU_DSP_Cin;
    logic  [7:0] wire_subs_not_upper, wire_subs_not_lower;
    logic wire_SubSelecetor_latch_Upper, wire_SubSelecetor_latch_Lower;
    logic [7:0] wire_subs_Selected_upper,wire_subs_Selected_lower;
    logic wire_SubCarrySelected_upper, wire_SubCarrySelected_lower;
    logic [7:0] wire_Preadder_Out_Upper, wire_Preadder_Out_Lower;
    logic wire_Preadder_Cout_Upper, wire_Preadder_Cout_Lower;
    logic [15:0] wire_adder_output_upper, wire_adder_output_lower;
    logic Wire_premultiplier_pipeline_Latch_Adder_upper, Wire_premultiplier_pipeline_Latch_C, Wire_premultiplier_pipeline_Latch_Adder_lower, Wire_premultiplier_pipeline_Latch_F, Wire_premultiplier_pipeline_Latch_G, Wire_premultiplier_pipeline_Latch_ALU_DSP_IN, Wire_premultiplier_pipeline_Latch_ALU_DSP_Cin;
    logic Wire_PreMulti_PipeReg_Out_AdderUpper, Wire_PreMulti_PipeReg_Out_Adderlower, Wire_PreMulti_PipeReg_Out_C, Wire_PreMulti_PipeReg_Out_F, Wire_PreMulti_PipeReg_Out_G, Wire_PreMulti_PipeReg_Out_ALU_DSP_IN, Wire_PreMulti_PipeReg_Out_ALU_DSP_Cin ;
    logic [7:0] wire_PreMulPipeSelecetor_Adder_upper, wire_PreMulPipeSelecetor_C, wire_PreMulPipeSelecetor_Adder_lower, wire_PreMulPipeSelecetor_F, wire_PreMulPipeSelecetor_G, wire_PreMulPipeSelecetor_ALU_DSP_IN , wire_PreMulPipeSelecetor_ALU_DSP_Cin; 
    logic [15:0] Wire_multiplier_Out_upper, Wire_multiplier_Out_lower; 
    logic wire_postmultiplierSelector_latch_upper, wire_postmultiplierSelector_latch_lower, wire_postmultiplierSelector_latch_G, wire_postmultiplierSelector_latch_AluDspIn, wire_postmultiplierSelector_latch_AluDspCin;
    logic [15:0] wire_PostMulti_PipeReg_Out_Upper, wire_PostMulti_PipeReg_Out_lower, wire_PostMulti_PipeReg_Out_G, wire_PostMulti_PipeReg_Out_AluDspIn, wire_PostMulti_PipeReg_Out_AluDspCin;
    logic [15:0] wire_postMulti_PipeSelector_upper, wire_PostMulti_PipeSelector_lower, wire_PostMulti_PipeSelector_G, wire_PostMulti_PipeSelector_ALU_DSP_IN, wire_PostMulti_PipeSelector_ALU_DSP_Cin;
    logic [1:0]cfg_ALU_operand_sel_latch_A, cfg_ALU_operand_sel_latch_B;
    logic [15:0] wire_alu_operand_A, wire_alu_operand_B;
    logic [15:0] Wire_ALU_out, Wire_ALU_Cout;
    logic Wire_ALU_ZeroFlag;
    logic wire_feedback_Latch;
    logic [15:0] wire_feedback_reg, wire_FeedbackMux_out;
    logic wire_ZeroFlag_reg, wire_ZeroFlagMux_out;
    logic [2:0] wire_out1_Latch, wire_out2_Latch;
    
    
      
    
    //Stage 1
    //input pipeline
    //pipeline registers 
    DFF#(.WIDTH(8)) input_PipeReg_A(.clk(clk), .WE(cfg_flag), .reset(rst), .d(A), .q(Out_A_InPipeReg));
    DFF#(.WIDTH(8)) input_PipeReg_B(.clk(clk), .WE(cfg_flag), .reset(rst), .d(B), .q(Out_B_InPipeReg));
    DFF#(.WIDTH(8)) input_PipeReg_C(.clk(clk), .WE(cfg_flag), .reset(rst), .d(C), .q(Out_C_InPipeReg));
    DFF#(.WIDTH(8)) input_PipeReg_D(.clk(clk), .WE(cfg_flag), .reset(rst), .d(D), .q(Out_D_InPipeReg));
    DFF#(.WIDTH(8)) input_PipeReg_E(.clk(clk), .WE(cfg_flag), .reset(rst), .d(E), .q(Out_E_InPipeReg));
    DFF#(.WIDTH(8)) input_PipeReg_F(.clk(clk), .WE(cfg_flag), .reset(rst), .d(F), .q(Out_F_InPipeReg));
    DFF#(.WIDTH(16)) input_PipeReg_G(.clk(clk), .WE(cfg_flag), .reset(rst), .d(G), .q(Out_G_InPipeReg));
    DFF#(.WIDTH(16)) input_PipeReg_ALU_DSP_IN(.clk(clk), .WE(cfg_flag), .reset(rst), .d(ALU_DSP_IN), .q(Out_AluDspIn_InPipeReg));
    DFF#(.WIDTH(16)) input_PipeReg_ALU_DSP_Cin(.clk(clk), .WE(cfg_flag), .reset(rst), .d(ALU_DSP_Cin), .q(Out_AluDspCin_InPipeReg));
    
    //first pipeline select latch
    DLatch #(.WIDTH(1)) In_PipeSelecetor_latch_A( .d(cfg_preadder_pipeline_A), .enable(cfg_flag),.q(wire_PipeSelecetor_latch_A) );
    DLatch  In_PipeSelecetor_latch_B( .d(cfg_preadder_pipeline_B), .enable(cfg_flag),.q(wire_PipeSelecetor_latch_B) );
    DLatch In_PipeSelecetor_latch_C( .d(cfg_preadder_pipeline_C), .enable(cfg_flag),.q(wire_PipeSelecetor_latch_C) );
    DLatch In_PipeSelecetor_latch_D( .d(cfg_preadder_pipeline_D), .enable(cfg_flag),.q(wire_PipeSelecetor_latch_D) );
    DLatch In_PipeSelecetor_latch_E( .d(cfg_preadder_pipeline_E), .enable(cfg_flag),.q(wire_PipeSelecetor_latch_E) );
    DLatch In_PipeSelecetor_latch_F( .d(cfg_preadder_pipeline_F), .enable(cfg_flag),.q(wire_PipeSelecetor_latch_F) );
    DLatch In_PipeSelecetor_latch_G( .d(cfg_preadder_pipeline_G), .enable(cfg_flag),.q(wire_PipeSelecetor_latch_G) );
    DLatch In_PipeSelecetor_latch_ALU_DSP_IN( .d(cfg_preadder_pipeline_AluDspIn), .enable(cfg_flag),.q(wire_PipeSelecetor_latch_ALU_DSP_IN) );
    DLatch In_PipeSelecetor_latch_ALU_DSP_Cin( .d(cfg_preadder_pipeline_AluDspCin), .enable(cfg_flag),.q(wire_PipeSelecetor_latch_ALU_DSP_Cin) );
    
    //input pipeline mux select
    mux2_8bit In_PipeSelecetor_A(.A(A),.B(Out_A_InPipeReg),.S(wire_PipeSelecetor_latch_A),.O(wire_PipeSelecetor_A));
    mux2_8bit In_PipeSelecetor_B(.A(B),.B(Out_B_InPipeReg),.S(wire_PipeSelecetor_latch_B),.O(wire_PipeSelecetor_B));
    mux2_8bit In_PipeSelecetor_C(.A(C),.B(Out_C_InPipeReg),.S(wire_PipeSelecetor_latch_C),.O(wire_PipeSelecetor_C));
    mux2_8bit In_PipeSelecetor_D(.A(D),.B(Out_D_InPipeReg),.S(wire_PipeSelecetor_latch_D),.O(wire_PipeSelecetor_D));
    mux2_8bit In_PipeSelecetor_E(.A(E),.B(Out_E_InPipeReg),.S(wire_PipeSelecetor_latch_E),.O(wire_PipeSelecetor_E));
    mux2_8bit In_PipeSelecetor_F(.A(F),.B(Out_F_InPipeReg),.S(wire_PipeSelecetor_latch_F),.O(wire_PipeSelecetor_F));
    mux2_16bit In_PipeSelecetor_G(.A(G),.B(Out_G_InPipeReg),.S(wire_PipeSelecetor_latch_G),.O(wire_PipeSelecetor_G));
    mux2_16bit In_PipeSelecetor_ALU_DSP_IN(.A(ALU_DSP_IN),.B(Out_AluDspIn_InPipeReg),.S(wire_PipeSelecetor_latch_ALU_DSP_IN),.O(wire_PipeSelecetor_ALU_DSP_IN));    
    mux2_16bit In_PipeSelecetor_ALU_DSP_Cin(.A(ALU_DSP_Cin),.B(Out_AluDspCin_InPipeReg),.S(wire_PipeSelecetor_latch_ALU_DSP_Cin),.O(wire_PipeSelecetor_ALU_DSP_Cin));    



    //substraction
    //NOT FOR SUBS
    NOT_8bit UpperAdder_subtraction(.c(wire_subs_not_upper), .a(wire_PipeSelecetor_B));//b
    NOT_8bit LowerAdder_subtraction(.c(wire_subs_not_lower), .a(wire_PipeSelecetor_E));//e
        
    //sub value selection and carry selection
     DLatch  In_SubSelecetor_latch_Upper( .d(cfg_upper_neg_sel), .enable(cfg_flag),.q(wire_SubSelecetor_latch_Upper) );
     DLatch  In_SubSelecetor_latch_Lower( .d(cfg_lower_neg_sel), .enable(cfg_flag),.q(wire_SubSelecetor_latch_Lower) );
     
     // neg pos val select mux
     mux2_8bit In_SubSelectorMux_upper(.A(wire_PipeSelecetor_B),.B(wire_subs_not_upper),.S(wire_SubSelecetor_latch_Upper),.O(wire_subs_Selected_upper)); // 1 = negative
     mux2_8bit In_SubSelectorMux_lower(.A(wire_PipeSelecetor_E),.B(wire_subs_not_lower),.S(wire_SubSelecetor_latch_Lower),.O(wire_subs_Selected_lower)); 
     
    // carry selection for sub
    mux_2 CarrySelect_Subs_mux_upper(.I0(1'b0), .I1(1'b1), .S(wire_SubSelecetor_latch_Upper), .O(wire_SubCarrySelected_upper));     
    mux_2 CarrySelect_Subs_mux_lower(.I0(1'b0), .I1(1'b1), .S(wire_SubSelecetor_latch_Lower), .O(wire_SubCarrySelected_lower)); 
    
    
    //Addition
    adder_8bit Preadder_upper(.a(wire_PipeSelecetor_A), .b(wire_subs_Selected_upper), .Cin(wire_SubCarrySelected_upper), .Out(wire_Preadder_Out_Upper), .Cout(wire_Preadder_Cout_Upper));
    adder_8bit Preadder_lower(.a(wire_PipeSelecetor_D), .b(wire_subs_Selected_lower), .Cin(wire_SubCarrySelected_lower), .Out(wire_Preadder_Out_Lower), .Cout(wire_Preadder_Cout_Lower));
    
      


   
   //Stage 2
   
   //premultiplier pipeline selection
   //latch
   DLatch  In_PreMultiplier_Pipeline_Latch_A( .d(cfg_premultiplier_pipeline_Adder_upper), .enable(cfg_flag),.q(Wire_premultiplier_pipeline_Latch_Adder_upper));
   DLatch  In_PreMultiplier_Pipeline_Latch_C( .d(cfg_premultiplier_pipeline_C), .enable(cfg_flag),.q(Wire_premultiplier_pipeline_Latch_C));
   DLatch  In_PreMultiplier_Pipeline_Latch_D( .d(cfg_premultiplier_pipeline_Adder_lower), .enable(cfg_flag),.q(Wire_premultiplier_pipeline_Latch_Adder_lower));
   DLatch  In_PreMultiplier_Pipeline_Latch_F( .d(cfg_premultiplier_pipeline_F), .enable(cfg_flag),.q(Wire_premultiplier_pipeline_Latch_F));
   DLatch  In_PreMultiplier_Pipeline_Latch_G( .d(cfg_premultiplier_pipeline_G), .enable(cfg_flag),.q(Wire_premultiplier_pipeline_Latch_G));
   DLatch  In_PreMultiplier_Pipeline_Latch_ALU_DSP_IN( .d(cfg_premultiplier_pipeline_AluDspIn), .enable(cfg_flag),.q(Wire_premultiplier_pipeline_Latch_ALU_DSP_IN));
   DLatch  In_PreMultiplier_Pipeline_Latch_ALU_DSP_Cin( .d(cfg_premultiplier_pipeline_AluDspCin), .enable(cfg_flag),.q(Wire_premultiplier_pipeline_Latch_ALU_DSP_Cin));
   
   // pipeline registers
    DFF#(.WIDTH(8)) PreMulti_PipeReg_Adder_upper(.clk(clk), .WE(cfg_flag), .reset(rst),  .d(wire_Preadder_Out_Upper),       .q(Wire_PreMulti_PipeReg_Out_AdderUpper));
    DFF#(.WIDTH(8)) PreMulti_PipeReg_C          (.clk(clk), .WE(cfg_flag), .reset(rst),  .d(wire_PipeSelecetor_C),          .q(Wire_PreMulti_PipeReg_Out_C));
    DFF#(.WIDTH(8)) PreMulti_PipeReg_Adder_lower(.clk(clk), .WE(cfg_flag), .reset(rst),  .d(wire_Preadder_Out_lower),       .q(Wire_PreMulti_PipeReg_Out_Adderlower));
    DFF#(.WIDTH(8)) PreMulti_PipeReg_F          (.clk(clk), .WE(cfg_flag), .reset(rst),  .d(wire_PipeSelecetor_F),          .q(Wire_PreMulti_PipeReg_Out_F));
    DFF#(.WIDTH(16)) PreMulti_PipeReg_G         (.clk(clk), .WE(cfg_flag), .reset(rst),  .d(wire_PipeSelecetor_G),          .q(Wire_PreMulti_PipeReg_Out_G));
    DFF#(.WIDTH(16)) PreMulti_PipeReg_ALU_DSP_IN(.clk(clk), .WE(cfg_flag), .reset(rst),  .d(wire_PipeSelecetor_ALU_DSP_IN), .q(Wire_PreMulti_PipeReg_Out_ALU_DSP_IN));
    DFF#(.WIDTH(16)) PreMulti_PipeReg_ALU_DSP_Cin(.clk(clk), .WE(cfg_flag), .reset(rst), .d(wire_PipeSelecetor_ALU_DSP_Cin),.q(Wire_PreMulti_PipeReg_Out_ALU_DSP_Cin));
    
    //muxes
    mux2_8bit PreMulti_PipeSelector_Adder_upper  (.A(wire_Preadder_Out_Upper),.B(Wire_PreMulti_PipeReg_Out_AdderUpper),.S(Wire_premultiplier_pipeline_Latch_Adder_upper),.O(wire_PreMulPipeSelecetor_Adder_upper));
    mux2_8bit PreMulti_PipeSelector_C            (.A(wire_PipeSelecetor_C),.B(Wire_PreMulti_PipeReg_Out_C),.S(Wire_premultiplier_pipeline_Latch_C),.O(wire_PreMulPipeSelecetor_C));
    mux2_8bit PreMulti_PipeSelector_Adder_lower  (.A(wire_Preadder_Out_lower),.B(Wire_PreMulti_PipeReg_Out_Adderlower),.S(Wire_premultiplier_pipeline_Latch_Adder_lower),.O(wire_PreMulPipeSelecetor_Adder_lower));
    mux2_8bit PreMulti_PipeSelector_F            (.A(wire_PipeSelecetor_F),.B(Wire_PreMulti_PipeReg_Out_F),.S(Wire_premultiplier_pipeline_Latch_F),.O(wire_PreMulPipeSelecetor_F));
    mux2_16bit PreMulti_PipeSelector_G            (.A(wire_PipeSelecetor_G),.B(Wire_PreMulti_PipeReg_Out_G),.S(Wire_premultiplier_pipeline_Latch_G),.O(wire_PreMulPipeSelecetor_G));
    mux2_16bit PreMulti_PipeSelector_ALU_DSP_IN   (.A(wire_PipeSelecetor_ALU_DSP_IN),.B(Wire_PreMulti_PipeReg_Out_ALU_DSP_IN),.S(Wire_premultiplier_pipeline_Latch_ALU_DSP_IN),.O(wire_PreMulPipeSelecetor_ALU_DSP_IN));
    mux2_16bit PreMulti_PipeSelector_ALU_DSP_Cin  (.A(wire_PipeSelecetor_ALU_DSP_Cin),.B(Wire_PreMulti_PipeReg_Out_ALU_DSP_Cin),.S(Wire_premultiplier_pipeline_Latch_ALU_DSP_Cin),.O(wire_PreMulPipeSelecetor_ALU_DSP_Cin));
    


    //multiplier
    multiplier_8bit multiplier_upper(.A(wire_PreMulPipeSelecetor_Adder_upper), .B(wire_PreMulPipeSelecetor_C), .Out(Wire_multiplier_Out_upper));
    multiplier_8bit multiplier_lower(.A(wire_PreMulPipeSelecetor_Adder_lower), .B(wire_PreMulPipeSelecetor_F), .Out(Wire_multiplier_Out_lower));
    
    
    
    //post multiplier pipeline and bypass   
    //latches
    DLatch  In_PostMultiplier_Pipeline_upper( .d(cfg_postmultiplier_pipeline_upper), .enable(cfg_flag),.q(wire_postmultiplierSelector_latch_upper));
    DLatch  In_PostMultiplier_Pipeline_lower( .d(cfg_postmultiplier_pipeline_lower), .enable(cfg_flag),.q(wire_postmultiplierSelector_latch_lower));
    DLatch  In_PostMultiplier_Pipeline_G( .d(cfg_postmultiplier_pipeline_G), .enable(cfg_flag),.q(wire_postmultiplierSelector_latch_G));
    DLatch  In_PostMultiplier_Pipeline_AluDspIn( .d(cfg_postmultiplier_pipeline_AluDspIn), .enable(cfg_flag),.q(wire_postmultiplierSelector_latch_AluDspIn));
    DLatch  In_PostMultiplier_Pipeline_AluDspCin( .d(cfg_postmultiplier_pipeline_AluDspCin), .enable(cfg_flag),.q(wire_postmultiplierSelector_latch_AluDspCin));
    
    //pipeline reg
    DFF#(.WIDTH(16)) PostMulti_PipeReg_Upper        (.clk(clk), .WE(cfg_flag), .reset(rst), .d(Wire_multiplier_Out_upper), .q(wire_PostMulti_PipeReg_Out_Upper));
    DFF#(.WIDTH(16)) PostMulti_PipeReg_lower        (.clk(clk), .WE(cfg_flag), .reset(rst), .d(Wire_multiplier_Out_lower), .q(wire_PostMulti_PipeReg_Out_lower));
    DFF#(.WIDTH(16)) PostMulti_PipeReg_G            (.clk(clk), .WE(cfg_flag), .reset(rst), .d(wire_PreMulPipeSelecetor_G), .q(wire_PostMulti_PipeReg_Out_G));
    DFF#(.WIDTH(16)) PostMulti_PipeReg_ALU_DSP_IN   (.clk(clk), .WE(cfg_flag), .reset(rst), .d(wire_PreMulPipeSelecetor_ALU_DSP_IN), .q(wire_PostMulti_PipeReg_Out_AluDspIn));
    DFF#(.WIDTH(16)) PostMulti_PipeReg_ALU_DSP_Cin  (.clk(clk), .WE(cfg_flag), .reset(rst), .d(wire_PreMulPipeSelecetor_ALU_DSP_Cin), .q(wire_PostMulti_PipeReg_Out_AluDspCin));
    
    //Muxes
    mux2_16bit postMulti_PipeSelector_upper        (.A(Wire_multiplier_Out_upper),.B(wire_PostMulti_PipeReg_Out_Upper),.S(wire_postmultiplierSelector_latch_upper),.O(wire_postMulti_PipeSelector_upper));
    mux2_16bit PostMulti_PipeSelector_lower        (.A(Wire_multiplier_Out_lower),.B(wire_PostMulti_PipeReg_Out_lower),.S(wire_postmultiplierSelector_latch_lower),.O(wire_PostMulti_PipeSelector_lower));
    mux2_16bit PostMulti_PipeSelector_G            (.A(wire_PreMulPipeSelecetor_G),.B(wire_PostMulti_PipeReg_Out_G),.S(wire_postmultiplierSelector_latch_G),.O(wire_PostMulti_PipeSelector_G));
    mux2_16bit PostMulti_PipeSelector_ALU_DSP_IN   (.A(wire_PreMulPipeSelecetor_ALU_DSP_IN),.B(wire_PostMulti_PipeReg_Out_AluDspIn),.S(wire_postmultiplierSelector_latch_AluDspIn),.O(wire_PostMulti_PipeSelector_ALU_DSP_IN));
    mux2_16bit PostMulti_PipeSelector_ALU_DSP_Cin  (.A(wire_PreMulPipeSelecetor_ALU_DSP_Cin),.B(wire_PostMulti_PipeReg_Out_AluDspCin),.S(wire_postmultiplierSelector_latch_AluDspCin),.O(wire_PostMulti_PipeSelector_ALU_DSP_Cin));
    
    
    //adder output selection
    mux2_16bit adder_outputSelector_upper (.A({7'b0, wire_Preadder_Cout_Upper, wire_Preadder_Out_Upper}), .B({{8{wire_Preadder_Out_Upper[7]}}, wire_Preadder_Out_Upper}), .S(wire_SubSelecetor_latch_Upper),  .O(wire_adder_output_upper));
    mux2_16bit adder_outputSelector_lower (.A({7'b0, wire_Preadder_Cout_Lower, wire_Preadder_Out_Lower}), .B({{8{wire_Preadder_Out_Lower[7]}}, wire_Preadder_Out_Lower}), .S(wire_SubSelecetor_latch_Lower),  .O(wire_adder_output_Lower));

    
    //stage 3
    //ALU input selection
    //latches
    DLatch  In_ALU_Selector_Latch_upper( .d(cfg_ALU_operand_sel_A), .enable(cfg_flag), .q(cfg_ALU_operand_sel_latch_A));
    DLatch  In_ALU_Selector_Latch_lower( .d(cfg_ALU_operand_sel_B), .enable(cfg_flag), .q(cfg_ALU_operand_sel_latch_B));
    
    //muxes
    mux4_16bit ALU_Selector_upper (.I0(wire_postMulti_PipeSelector_upper), .I1(wire_PostMulti_PipeSelector_G), .I2(wire_PostMulti_PipeSelector_ALU_DSP_IN), .I3(wire_FeedbackMux_out), .S(cfg_ALU_operand_sel_latch_A), .O(wire_alu_operand_A));
    mux4_16bit ALU_Selector_LOWer (.I0(wire_PostMulti_PipeSelector_lower), .I1(wire_PostMulti_PipeSelector_G), .I2(wire_PostMulti_PipeSelector_ALU_DSP_IN), .I3(wire_FeedbackMux_out), .S(cfg_ALU_operand_sel_latch_B), .O(wire_alu_operand_B));
    
        
    //ALU instantiation
    ALU DSP_ALU (.ALU_mode(ALU_mode), .cfg_flag(cfg_flag), .A(wire_alu_operand_A), .B(wire_alu_operand_B), .cfg_ALU_CarrySel(cfg_ALU_CarrySel), .ALU_Carry_IN(wire_PostMulti_PipeSelector_ALU_DSP_Cin), .Out(Wire_ALU_out), .CarryOut(Wire_ALU_Cout), .ZeroFlag(Wire_ALU_ZeroFlag));
    
    
    
    
    //stage 4
    //output generation
     DLatch  out_Feedback_latch( .d(cfg_feedback_PipeReg), .enable(cfg_flag),.q(wire_feedback_Latch));
     DFF#(.WIDTH(16)) feedback_PipeReg  (.clk(clk), .WE(cfg_flag), .reset(rst), .d(Wire_ALU_out), .q(wire_feedback_reg));
     mux2_16bit AluFeedback_Selector_mux (.A(Wire_ALU_out),.B(wire_feedback_reg),.S(wire_feedback_Latch),.O(wire_FeedbackMux_out));
    
     DFF ZeroFlag_PipeReg  (.clk(clk), .WE(cfg_flag), .reset(rst), .d(Wire_ALU_ZeroFlag), .q(wire_ZeroFlag_reg));
     mux2_16bit ZeroFlag_Selector_mux (.A(Wire_ALU_ZeroFlag),.B(wire_ZeroFlag_reg),.S(wire_feedback_Latch),.O(wire_ZeroFlagMux_out));
    
    
    
     DLatch  out1_latch( .d(cfg_out_1), .enable(cfg_flag),.q(wire_out1_Latch));
     DLatch  out2_latch( .d(cfg_out_2), .enable(cfg_flag),.q(wire_out2_Latch));

     Mux8_16bit out1_mux(.O(Out1), .A(wire_adder_output_upper), .B(wire_postMulti_PipeSelector_upper), .C(wire_FeedbackMux_out), .D(wire_adder_output_lower), .E(wire_postMulti_PipeSelector_lower), .F(1'b0), .G(1'b0), .H(1'b0), .S(wire_out1_Latch));
     Mux8_16bit out2_mux(.O(Out2), .A(wire_adder_output_upper), .B(wire_postMulti_PipeSelector_upper), .C(wire_FeedbackMux_out), .D(wire_adder_output_lower), .E(wire_postMulti_PipeSelector_lower), .F(1'b0), .G(1'b0), .H(1'b0), .S(wire_out2_Latch));
    
    
    
    
    assign ALU_DSP_Out = Wire_ALU_out;
    assign ALU_DSP_Cout = Wire_ALU_Cout;
 


endmodule