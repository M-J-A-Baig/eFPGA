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




module tb_ALU;
    
    logic [2:0] ALU_mode;
    logic cfg_flag,ALU_Carry_IN, CarryOut, ZeroFlag;
    logic [1:0] cfg_ALU_CarrySel;
    logic [16:0] A,B, Out;
    
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
