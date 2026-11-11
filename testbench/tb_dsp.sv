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
            
              for(i = 0; i< 1; i++)
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
                      
                      
                      
                                              
                                                         cfg_flag = 1;
                        ALU_mode  = 3; // greater than
                        cfg_ALU_CarrySel = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 1:0;
                        ALU_Carry_IN = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 0:1;
                        #10;
                        cfg_flag = 0;
                        #10;
                        A = 16'b0000010111001101;
                        B = 16'b0011110110110000;
                        #10;       
                        
                                                                  cfg_flag = 1;
                        ALU_mode  = 4; // greater than
                        cfg_ALU_CarrySel = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 1:0;
                        ALU_Carry_IN = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 0:1;
                        #10;
                        cfg_flag = 0;
                        #10;
                        A = 16'b0000010111001101;
                        B = 16'b0011110110110000;
                        #10;  
                        
                        
                                                                  cfg_flag = 1;
                        ALU_mode  = 7; // greater than
                        cfg_ALU_CarrySel = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 1:0;
                        ALU_Carry_IN = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 0:1;
                        #10;
                        cfg_flag = 0;
                        #10;
                        A = 16'b0000010111001101;
                        B = 16'b0011110110110000;
                        #10;  
                        
                              
                                                                  cfg_flag = 1;
                        ALU_mode  = 7; // greater than
                        cfg_ALU_CarrySel = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 1:0;
                        ALU_Carry_IN = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 0:1;
                        #10;
                        cfg_flag = 0;
                        #10;
                        A = 16'b1000010001100101;
                        B = 16'b1000010001100101;
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
    logic cfg_upper_pipeline_Preadder,  cfg_lower_pipeline_Preadder, cfg_preadder_pipeline_G, cfg_alumode_pipeline_Preadder, cfg_preadder_pipeline_AluDspIn, cfg_preadder_pipeline_AluDspCin;
    logic cfg_upper_neg_sel, cfg_lower_neg_sel;
    logic cfg_premultiplier_pipeline_upper, cfg_premultiplier_pipeline_lower, cfg_premultiplier_pipeline_alumode, cfg_premultiplier_pipeline_G, cfg_premultiplier_pipeline_AluDspIn, cfg_premultiplier_pipeline_AluDspCin;
    logic cfg_postmultiplier_pipeline_upper, cfg_postmultiplier_pipeline_lower, cfg_postmultiplier_pipeline_alumode, cfg_postmultiplier_pipeline_G, cfg_postmultiplier_pipeline_AluDspIn, cfg_postmultiplier_pipeline_AluDspCin;
    logic [1:0]cfg_ALU_operand_sel_A, cfg_ALU_operand_sel_B, cfg_ALU_CarrySel;
    logic [2:0] ALU_mode;
    logic [2:0] cfg_out_1,cfg_out_2;
        
    logic [15:0] ALU_DSP_Out,  Out1, Out2;
    logic ALU_DSP_Cout,ZeroFlag;


    
    
    
    DSP dut (
        .clk(clk),.rst(rst),.cfg_flag(cfg_flag),
    
        .A(A),.B(B),.C(C),.D(D),.E(E),.F(F),.G(G),
    
        .ALU_DSP_IN(ALU_DSP_IN),.ALU_DSP_Cin(ALU_DSP_Cin),
       
        .cfg_upper_pipeline_Preadder(cfg_upper_pipeline_Preadder),
        .cfg_lower_pipeline_Preadder(cfg_lower_pipeline_Preadder),
        .cfg_preadder_pipeline_G(cfg_preadder_pipeline_G),
        .cfg_alumode_pipeline_Preadder(cfg_alumode_pipeline_Preadder),
        .cfg_preadder_pipeline_AluDspIn(cfg_preadder_pipeline_AluDspIn),
        .cfg_preadder_pipeline_AluDspCin(cfg_preadder_pipeline_AluDspCin),
    
        .cfg_upper_neg_sel(cfg_upper_neg_sel),
        .cfg_lower_neg_sel(cfg_lower_neg_sel),
    
        .cfg_premultiplier_pipeline_upper(cfg_premultiplier_pipeline_upper),
        .cfg_premultiplier_pipeline_lower(cfg_premultiplier_pipeline_lower),
        .cfg_premultiplier_pipeline_alumode(cfg_premultiplier_pipeline_alumode),
        .cfg_premultiplier_pipeline_G(cfg_premultiplier_pipeline_G),
        .cfg_premultiplier_pipeline_AluDspIn(cfg_premultiplier_pipeline_AluDspIn),
        .cfg_premultiplier_pipeline_AluDspCin(cfg_premultiplier_pipeline_AluDspCin),
    
        .cfg_postmultiplier_pipeline_upper(cfg_postmultiplier_pipeline_upper),
        .cfg_postmultiplier_pipeline_lower(cfg_postmultiplier_pipeline_lower),
        .cfg_postmultiplier_pipeline_alumode(cfg_postmultiplier_pipeline_alumode),
        .cfg_postmultiplier_pipeline_G(cfg_postmultiplier_pipeline_G),
        .cfg_postmultiplier_pipeline_AluDspIn(cfg_postmultiplier_pipeline_AluDspIn),
        .cfg_postmultiplier_pipeline_AluDspCin(cfg_postmultiplier_pipeline_AluDspCin),
    
        .cfg_ALU_operand_sel_A(cfg_ALU_operand_sel_A),
        .cfg_ALU_operand_sel_B(cfg_ALU_operand_sel_B),
    
        .ALU_mode(ALU_mode),
        .cfg_ALU_CarrySel(cfg_ALU_CarrySel),
    
        .cfg_out_1(cfg_out_1),
        .cfg_out_2(cfg_out_2),
    
        .ALU_DSP_Out(ALU_DSP_Out),
        .ALU_DSP_Cout(ALU_DSP_Cout),
        .Out1(Out1),
        .Out2(Out2),
        .ZeroFlag(ZeroFlag) 
    );
    
    
    always #5 clk = ~clk;
    

    integer i,j;
    
    initial     
        begin
            $dumpfile("dump.vcd");
            $dumpvars(0, tb_DSP);
   
            clk = 0;
            rst = 0;
            
                
            for(i = 0; i< 1; i++)
                    begin
                    
                     $display("Iteration %0d started at %0t", i, $time);
                    #10;
                    rst = 1;
                    
                    //FIST PIPELEINE BYPASSSED
                    cfg_flag                        = 1;
                    
                    cfg_upper_neg_sel               = 0 ;
                    cfg_lower_neg_sel               = 0 ;
                    cfg_upper_pipeline_Preadder     = 0 ;
                    cfg_lower_pipeline_Preadder     = 0 ;
                    cfg_preadder_pipeline_G         = 0 ;
                    cfg_preadder_pipeline_AluDspIn  = 0 ;
                    cfg_preadder_pipeline_AluDspCin = 0 ;
                    cfg_alumode_pipeline_Preadder   = 0; 
                    
                    
                    //2nd bypassed
                    cfg_premultiplier_pipeline_upper        = 0 ;
                    cfg_premultiplier_pipeline_lower        = 0 ;
                    cfg_premultiplier_pipeline_G            = 0 ;
                    cfg_premultiplier_pipeline_AluDspIn     = 0 ;
                    cfg_premultiplier_pipeline_AluDspCin    = 0 ;
                    cfg_premultiplier_pipeline_alumode      = 0 ;
                    
                    
                    //3rd bnypassed
                    cfg_postmultiplier_pipeline_upper         = 0 ;
                    cfg_postmultiplier_pipeline_lower         = 0 ;
                    cfg_postmultiplier_pipeline_G             = 0 ;
                    cfg_postmultiplier_pipeline_AluDspIn      = 0 ;
                    cfg_postmultiplier_pipeline_AluDspCin     = 0 ;
                    cfg_postmultiplier_pipeline_alumode       = 0 ;
                    
                    //operand selector
                    cfg_ALU_operand_sel_A = 0;
                    cfg_ALU_operand_sel_B = 0;
                    
                    
                    ALU_mode = 0;
                    cfg_ALU_CarrySel = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 1:0;

                    
                           
                    //OUT SELECTOR
                    cfg_out_1 = 2;
                    cfg_out_2 = 2;
                    
                     $display("Calling finish at %0t", $time);      
                 
                    #10;
                    cfg_flag = 0;
                    $display("Calling finish at %0t", $time);
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
                    $display("Calling finish at %0t", $time);
                     //operand selector
                    #10;
                    
                    
                                 
                for(j = 0; j< 8; j++)
                    begin
                        cfg_flag = 1;
                        ALU_mode = j;
                        cfg_ALU_CarrySel = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 1:0;
                        #10;
                        cfg_flag = 0;
                        #10;
                        end
                        
                    
                    
                    
                    
                    
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
                    cfg_ALU_CarrySel = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 1:0;
                    #10;
                    cfg_flag = 0;
                    #20;
                    $display("Calling finish at %0t", $time);
                    
                    
                    
                    
                    cfg_flag = 1;
                    cfg_ALU_operand_sel_A = 3;
                    cfg_ALU_operand_sel_B = 3;
                    #10;
                    
                    
                    
                    
                    $display("Calling finish at %0t", $time);
                    
                    #200;
                    rst = 0;
                    cfg_flag = 1;
                 
                    
                    
                    
                    A = $random;    
                    B = $random;
                    C = $random;
                    D = $random;
                    E = $random;
                    F = $random;
                    G = $random;
                    ALU_DSP_IN = $random; 
                    ALU_DSP_Cin = $random;
                    $display("not bypass applied Calling finish at %0t", $time);
                    
                    

                
         
                   //FIST PIPELEINE not BYPASSSED
                    cfg_upper_neg_sel               = 1 ;
                    cfg_lower_neg_sel               = 1 ;
                    cfg_upper_pipeline_Preadder     = 1 ;
                    cfg_lower_pipeline_Preadder     = 1 ;
                    cfg_preadder_pipeline_G         = 1 ;
                    cfg_preadder_pipeline_AluDspIn  = 1 ;
                    cfg_preadder_pipeline_AluDspCin = 1 ;
                    cfg_alumode_pipeline_Preadder   = 1; 
                    
                    
                    //2nd  not bypassed 
                    cfg_premultiplier_pipeline_upper        = 1 ;
                    cfg_premultiplier_pipeline_lower        = 1 ;
                    cfg_premultiplier_pipeline_G            = 1 ;
                    cfg_premultiplier_pipeline_AluDspIn     = 1 ;
                    cfg_premultiplier_pipeline_AluDspCin    = 1 ;
                    cfg_premultiplier_pipeline_alumode      = 1 ;
                    
                    
                    //3rd  not bnypassed
                    cfg_postmultiplier_pipeline_upper         = 1 ;
                    cfg_postmultiplier_pipeline_lower         = 1 ;
                    cfg_postmultiplier_pipeline_G             = 1 ;
                    cfg_postmultiplier_pipeline_AluDspIn      = 1 ;
                    cfg_postmultiplier_pipeline_AluDspCin     = 1 ;
                    cfg_postmultiplier_pipeline_alumode       = 1 ;
                    
                    //operand selector
                    cfg_ALU_operand_sel_A = 0;
                    cfg_ALU_operand_sel_B = 0;
                    cfg_flag = 1;
               
                    
                    
                    
                    ALU_mode = 4;
                    cfg_ALU_CarrySel = (ALU_mode == 4 ||ALU_mode == 5 ||ALU_mode == 6 ||ALU_mode == 7) ? 1:0;
                   
                    //OUT SELECTOR
                    cfg_out_1 = 3;
                    cfg_out_2 = 3;
                    #10;
                    
                    
                    cfg_flag = 0;
                    rst = 1;
                    #100;
                    
                    
                    //now addition substraction  and preadder bypass checked.
                    
                         //OUT SELECTOR
                    cfg_flag = 1;
                    cfg_out_1 = 0;
                    cfg_out_2 = 0;
                    #10;
                    cfg_flag = 0;
                    #10;
                    
                    cfg_flag = 1;
                    cfg_out_1 = 1;
                    cfg_out_2 = 1;
                    #10;
                    cfg_flag = 0;
                    #10;
                    
                    cfg_flag = 1;
                    cfg_out_1 = 2;
                    cfg_out_2 = 2;
                    #10;
                    cfg_flag = 0;
                    #10;
                    
                    cfg_flag = 1;
                    cfg_out_1 = 3;
                    cfg_out_2 = 3;
                    #10;
                    cfg_flag = 0;
                    #10;
                    
                    cfg_flag = 1;
                    cfg_out_1 = 4;
                    cfg_out_2 = 4;
                    #10;
                    cfg_flag = 0;
                    #10;
                    
                    cfg_flag = 1;
                    cfg_out_1 = 5;
                    cfg_out_2 = 5;
                    #10;
                    cfg_flag = 0;
                    #10;
                    
                    cfg_flag = 1;
                    cfg_out_1 = 6;
                    cfg_out_2 = 6;
                    #10;
                    cfg_flag = 0;
                    #10;
                    
                    cfg_flag = 1;
                    cfg_out_1 = 7;
                    cfg_out_2 = 7;
                    #10;
                    cfg_flag = 0;
                    #10;
            
           
                    
                    
                     
                     
                        
                    end
                    $display("Calling finish at %0t", $time);
                $finish;     
        end


endmodule