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
    logic [15:0] A;
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




module tb_ALU;
    
    logic [2:0] ALU_mode;
    logic cfg_flag,ALU_Carry_IN, CarryOut, ZeroFlag;
    logic [1:0] cfg_ALU_CarrySel;
    logic [15:0] A,B, Out;
    
    ALU dut(.ALU_mode(ALU_mode), .cfg_flag(cfg_flag), .A(A), .B(B), .cfg_ALU_CarrySel(cfg_ALU_CarrySel), .ALU_Carry_IN(ALU_Carry_IN),  .Out(Out), .CarryOut(CarryOut), .ZeroFlag(ZeroFlag));

    integer i;
    
        initial     
        begin
            $dumpfile("dump.vcd");
            $dumpvars(0, tb_ALU);
            
              for(i = 0; i< 10; i++)
                    begin
                        cfg_flag = 1;
                        ALU_mode  = 0; // and
                        cfg_ALU_CarrySel = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 1:0;
                        ALU_Carry_IN = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 0:1;
                        #10;
                        cfg_flag = 0;
                        #10;
                        A = 3;
                        B = 5;
                        #10;
                        
                               cfg_flag = 1;
                        ALU_mode  = 1; // or
                        cfg_ALU_CarrySel = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 1:0;
                        ALU_Carry_IN = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 0:1;
                        #10;
                        cfg_flag = 0;
                        #10;
                        A = 9;
                        B = 5;
                        #10;
                                 cfg_flag = 1;
                        ALU_mode  = 2; // not
                        cfg_ALU_CarrySel = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 1:0;
                        ALU_Carry_IN = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 0:1;
                        #10;
                        cfg_flag = 0;
                        #10;
                        A = 9;
                        B = 5;
                        #10;
                        
                                 cfg_flag = 1;
                        ALU_mode  = 3; // add
                        cfg_ALU_CarrySel = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 1:0;
                        ALU_Carry_IN = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 0:1;
                        #10;
                        cfg_flag = 0;
                        #10;
                        A = 9;
                        B = 5;
                        #10;
                        
                                 cfg_flag = 1;
                        ALU_mode  = 4; // sub
                        cfg_ALU_CarrySel = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 1:0;
                        ALU_Carry_IN = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 0:1;
                        #10;
                        cfg_flag = 0;
                        #10;
                        A = 9;
                        B = 5;
                        #10;
                        
                                 cfg_flag = 1;
                        ALU_mode  = 4; // sub
                        cfg_ALU_CarrySel = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 1:0;
                        ALU_Carry_IN = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 0:1;
                        #10;
                        cfg_flag = 0;
                        #10;
                        A = 9;
                        B = 50;
                        #10;
                        
                                 cfg_flag = 1;
                        ALU_mode  = 7; // equals
                        cfg_ALU_CarrySel = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 1:0;
                        ALU_Carry_IN = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 0:1;
                        #10;
                        cfg_flag = 0;
                        #10;
                        A = 9;
                        B = 5;
                        #10;
                        
                        
                                 cfg_flag = 1;
                        ALU_mode  = 7; // equals
                        cfg_ALU_CarrySel = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 1:0;
                        ALU_Carry_IN = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 0:1;
                        #10;
                        cfg_flag = 0;
                        #10;
                        A = 9;
                        B = 9;
                        #10; 
                        
                        
                                 cfg_flag = 1;
                        ALU_mode  = 5; // less than
                        cfg_ALU_CarrySel = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 1:0;
                        ALU_Carry_IN = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 0:1;
                        #10;
                        cfg_flag = 0;
                        #10;
                        A = 9;
                        B = 5;
                        #10;                       

                                 cfg_flag = 1;
                        ALU_mode  = 5; // less than
                        cfg_ALU_CarrySel = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 1:0;
                        ALU_Carry_IN = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 0:1;
                        #10;
                        cfg_flag = 0;
                        #10;
                        A = 5;
                        B = 9;
                        #10; 
                        
                                                         cfg_flag = 1;
                        ALU_mode  = 5; // less than
                        cfg_ALU_CarrySel = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 1:0;
                        ALU_Carry_IN = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 0:1;
                        #10;
                        cfg_flag = 0;
                        #10;
                        A = 5;
                        B = 5;
                        #10;       
                        
                            cfg_flag = 1;
                        ALU_mode  = 6; // greater than
                        cfg_ALU_CarrySel = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 1:0;
                        ALU_Carry_IN = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 0:1;
                        #10;
                        cfg_flag = 0;
                        #10;
                        A = 9;
                        B = 5;
                        #10;                       

                                 cfg_flag = 1;
                        ALU_mode  = 6; // greater than
                        cfg_ALU_CarrySel = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 1:0;
                        ALU_Carry_IN = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 0:1;
                        #10;
                        cfg_flag = 0;
                        #10;
                        A = 5;
                        B = 9;
                        #10; 
                        
                                                         cfg_flag = 1;
                        ALU_mode  = 6; // greater than
                        cfg_ALU_CarrySel = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 1:0;
                        ALU_Carry_IN = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 0:1;
                        #10;
                        cfg_flag = 0;
                        #10;
                        A = 5;
                        B = 5;
                        #10;                 
                      


                    end   
                $finish;     
        end
    
endmodule



module tb_DSP;
  
  
   logic [7:0] A,B,C,D,E,F;
   logic [15:0] G,ALU_DSP_IN;
   logic ALU_DSP_Cin;
   logic clk, rst, cfg_flag;
   logic cfg_preadder_pipeline_A, cfg_preadder_pipeline_B, cfg_preadder_pipeline_C, cfg_preadder_pipeline_D, cfg_preadder_pipeline_E, cfg_preadder_pipeline_F, cfg_preadder_pipeline_G, cfg_preadder_pipeline_AluDspIn, cfg_preadder_pipeline_AluDspCin;
   logic cfg_upper_neg_sel, cfg_lower_neg_sel;
   logic cfg_premultiplier_pipeline_Adder_upper, cfg_premultiplier_pipeline_C, cfg_premultiplier_pipeline_Adder_lower, cfg_premultiplier_pipeline_F, cfg_premultiplier_pipeline_G, cfg_premultiplier_pipeline_AluDspIn, cfg_premultiplier_pipeline_AluDspCin;
   logic cfg_postmultiplier_pipeline_upper, cfg_postmultiplier_pipeline_lower, cfg_postmultiplier_pipeline_G, cfg_postmultiplier_pipeline_AluDspIn, cfg_postmultiplier_pipeline_AluDspCin;
   logic [1:0]cfg_ALU_operand_sel_A, cfg_ALU_operand_sel_B, cfg_ALU_CarrySel;
   logic [2:0] ALU_mode;
   logic cfg_feedback_PipeReg;
   logic [2:0] cfg_out_1,cfg_out_2;
   
   logic [15:0] ALU_DSP_Out, Out1, Out2;
   logic ZeroFlag, ALU_DSP_Cout;


    
    
    
    DSP dut (
        .clk(clk),.rst(rst),.cfg_flag(cfg_flag),
    
        .A(A),.B(B),.C(C),.D(D),.E(E),.F(F),.G(G),
    
        .ALU_DSP_IN(ALU_DSP_IN),.ALU_DSP_Cin(ALU_DSP_Cin),
        
        //stage 1
        //preadders slect
        .cfg_preadder_pipeline_A(cfg_preadder_pipeline_A),
        .cfg_preadder_pipeline_B(cfg_preadder_pipeline_B),.cfg_preadder_pipeline_C(cfg_preadder_pipeline_C),
        .cfg_preadder_pipeline_D(cfg_preadder_pipeline_D),.cfg_preadder_pipeline_E(cfg_preadder_pipeline_E),
        .cfg_preadder_pipeline_F(cfg_preadder_pipeline_F),.cfg_preadder_pipeline_G(cfg_preadder_pipeline_G),
        .cfg_preadder_pipeline_AluDspIn(cfg_preadder_pipeline_AluDspIn),
        .cfg_preadder_pipeline_AluDspCin(cfg_preadder_pipeline_AluDspCin),
    
        .cfg_upper_neg_sel(cfg_upper_neg_sel),
        .cfg_lower_neg_sel(cfg_lower_neg_sel),
    
        //stage 2
        //premultiplier pipeline
        .cfg_premultiplier_pipeline_Adder_upper(cfg_premultiplier_pipeline_Adder_upper),
        .cfg_premultiplier_pipeline_C(cfg_premultiplier_pipeline_C),
        .cfg_premultiplier_pipeline_Adder_lower(cfg_premultiplier_pipeline_Adder_lower),
        .cfg_premultiplier_pipeline_F(cfg_premultiplier_pipeline_F),
        .cfg_premultiplier_pipeline_G(cfg_premultiplier_pipeline_G),
        .cfg_premultiplier_pipeline_AluDspIn(cfg_premultiplier_pipeline_AluDspIn),
        .cfg_premultiplier_pipeline_AluDspCin(cfg_premultiplier_pipeline_AluDspCin),
    
        .cfg_postmultiplier_pipeline_upper(cfg_postmultiplier_pipeline_upper),
        .cfg_postmultiplier_pipeline_lower(cfg_postmultiplier_pipeline_lower),
        .cfg_postmultiplier_pipeline_G(cfg_postmultiplier_pipeline_G),
        .cfg_postmultiplier_pipeline_AluDspIn(cfg_postmultiplier_pipeline_AluDspIn),
        .cfg_postmultiplier_pipeline_AluDspCin(cfg_postmultiplier_pipeline_AluDspCin),
    
        .cfg_ALU_operand_sel_A(cfg_ALU_operand_sel_A),
        .cfg_ALU_operand_sel_B(cfg_ALU_operand_sel_B),
    
        .ALU_mode(ALU_mode),
        .cfg_ALU_CarrySel(cfg_ALU_CarrySel),
    
        .cfg_feedback_PipeReg(cfg_feedback_PipeReg),
        .cfg_out_1(cfg_out_1),
        .cfg_out_2(cfg_out_2),
    
        .ALU_DSP_Out(ALU_DSP_Out),
        .ALU_DSP_Cout(ALU_DSP_Cout),
        .Out1(Out1),
        .Out2(Out2),
        .ZeroFlag(ZeroFlag)
    );
    
    
    always #5 clk = ~clk;
    

    integer i;
    
    initial     
        begin
            $dumpfile("dump.vcd");
            $dumpvars(0, tb_DSP);
                
            for(i = 0; i< 5; i++)
                    begin
                    clk = 0;
                    rst = 0;
                    #10;
                    rst = 1;
                    
                    //FIST PIPELEINE BYPASSSED
                    cfg_flag = 1;
                    cfg_upper_neg_sel = 0 ;
                    cfg_lower_neg_sel = 0 ;
                    cfg_preadder_pipeline_A = 0 ;
                    cfg_preadder_pipeline_B = 0 ;
                    cfg_preadder_pipeline_C = 0 ;
                    cfg_preadder_pipeline_D = 0 ;
                    cfg_preadder_pipeline_E = 0 ;
                    cfg_preadder_pipeline_F = 0 ;
                    cfg_preadder_pipeline_G = 0 ;
                    cfg_preadder_pipeline_AluDspIn = 0 ;
                    cfg_preadder_pipeline_AluDspCin = 0 ;
                    
                    
                    //2nd bypassed
                    cfg_premultiplier_pipeline_Adder_upper  = 0 ;
                    cfg_premultiplier_pipeline_C            = 0 ;
                    cfg_premultiplier_pipeline_Adder_lower  = 0 ;
                    cfg_premultiplier_pipeline_F            = 0 ;
                    cfg_premultiplier_pipeline_G            = 0 ;
                    cfg_premultiplier_pipeline_AluDspIn     = 0 ;
                    cfg_premultiplier_pipeline_AluDspCin    = 0 ;
                    
                    
                    //3rd bnypassed
                    cfg_postmultiplier_pipeline_upper         = 0 ;
                    cfg_postmultiplier_pipeline_lower         = 0 ;
                    cfg_postmultiplier_pipeline_G             = 0 ;
                    cfg_postmultiplier_pipeline_AluDspIn      = 0 ;
                    cfg_postmultiplier_pipeline_AluDspCin     = 0 ;
                    
                    //operand selector
                    cfg_ALU_operand_sel_A = 0;
                    cfg_ALU_operand_sel_B = 0;
                    
                    
                    ALU_mode = 0;
                    
                    //BYPASS FEEEDBACK AND ZERO FLAG REG
                    cfg_feedback_PipeReg = 0;
                    
                    //OUT SELECTOR
                    cfg_out_1 = 0;
                    cfg_out_2 = 2;
                    
                           
                 
                    #10;
                    cfg_flag = 0;
                    #20;
                    A = $random;    
                    B = $random;
                    C = $random;
                    D = $random;
                    E = $random;
                    F = $random;
                    G = $random;
                    ALU_DSP_IN = $random; 
                    ALU_DSP_Cin = $random;
                    
                     //operand selector
                    #10;
                    cfg_flag = 1;
                    cfg_ALU_operand_sel_A = 1;
                    cfg_ALU_operand_sel_B = 1;
                    #10;
                    cfg_flag = 0;
                    #20;
                    
                    cfg_flag = 1;
                    cfg_ALU_operand_sel_A = 2;
                    cfg_ALU_operand_sel_B = 2;
                    ALU_mode = 2;
                    #10;
                    cfg_flag = 0;
                    #20;
                       
                    cfg_flag = 1;
                    cfg_ALU_operand_sel_A = 3;
                    cfg_ALU_operand_sel_B = 3;
                    #10;
                    cfg_flag = 0;
                    #20;
                    
                    //FIRST PIPELINE APPLIED
//                    cfg_flag = 1;
                    
//                    cfg_upper_neg_sel = 1 ;
//                    cfg_lower_neg_sel = 1 ;
//                    cfg_preadder_pipeline_A = 1 ;
//                    cfg_preadder_pipeline_B = 1 ;
//                    cfg_preadder_pipeline_C = 1 ;
//                    cfg_preadder_pipeline_D = 1 ;
//                    cfg_preadder_pipeline_E = 1 ;
//                    cfg_preadder_pipeline_F = 1 ;
//                    cfg_preadder_pipeline_G = 1 ;
//                    cfg_preadder_pipeline_AluDspIn = 1 ;
//                    cfg_preadder_pipeline_AluDspCin = 1 ;
                    
                    
                    
//                    cfg_premultiplier_pipeline_Adder_upper  = 1 ;
//                    cfg_premultiplier_pipeline_C            = 1 ;
//                    cfg_premultiplier_pipeline_Adder_lower  = 1 ;
//                    cfg_premultiplier_pipeline_F            = 1 ;
//                    cfg_premultiplier_pipeline_G            = 1 ;
//                    cfg_premultiplier_pipeline_AluDspIn     = 1 ;
//                    cfg_premultiplier_pipeline_AluDspCin    = 1 ;
                 
                    
//                    #10;
//                    cfg_flag = 0;
//                    #20;
//                    A = $random;    
//                    B = $random;
//                    C = $random;
//                    D = $random;
//                    E = $random;
//                    F = $random;
//                    G = $random;
//                    ALU_DSP_IN = $random; 
//                    ALU_DSP_Cin = $random;
//                    #20;
                    
                    
                    //now addition substraction  and preadder bypass checked.
                    
                    
            
           
                    
                    
                     
                     
                        
                    end
                $finish;     
        end


endmodule