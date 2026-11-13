`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2026 10:36:18 AM
// Design Name: 
// Module Name: tb_clb
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


module tb_lut3;
    logic a,b,c;
  	logic clk,cfg_write_en;
	logic Data_in;
	logic Out;


LUT3 dut (.a(a), .b(b), .c(c), .clk(clk), .Data_in(Data_in), .cfg_write_en(cfg_write_en), .Out(Out));

always #5 clk = ~clk;

  initial 
      begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_lut3);
        
       
        clk = 1;
        cfg_write_en = 0;  // initial condition
        #10
       
       
       //config time
        cfg_write_en = 1;
        
        c=0; b=0; a=0;     Data_in=1;
        #10
        c=0; b=0; a=1;     Data_in=0;
        #10
        c=0; b=1; a=0;     Data_in=0;
        #10
        c=0; b=1; a=1;     Data_in=0;
        #10
        c=1; b=0; a=0;     Data_in=1;
        #10
        c=1; b=0; a=1;     Data_in=1;
        #10
        c=1; b=1; a=0;     Data_in=0;
        #10
        c=1; b=1; a=1;     Data_in=1;
        #60
        
        
        //run time 
        cfg_write_en = 0;    // normal ops
        #50
        c=0; b=0; a=1;     
        #10
        c=1; b=0; a=0;     
        #10
        c=0; b=0; a=0;    
        #10
       
        $finish;
      end  
      
      
 endmodule
 
 
 
 
 module tb_lut6;

    logic clk,cfg_flag;
    logic a,b,c,d,e,f, Data_in;
    logic write_en_0, write_en_1, write_en_2, write_en_3, write_en_4, write_en_5, write_en_6, write_en_7;
    logic Cin_bits0, Cin_bits1;
    logic [1:0] cfg_Carry_select_Int_0, cfg_Carry_select_Int_1;
    logic O_6, O_5;
    logic Sum_0, Sum_1, Cout_lower, Sum_2, Sum_3, Cout_upper; 
 
              
    LUT6 dut (.clk(clk), .cfg_flag(cfg_flag), .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .Data_in(Data_in), 
              .write_en_0(write_en_0), .write_en_1(write_en_1), .write_en_2(write_en_2), .write_en_3(write_en_3), .write_en_4(write_en_4), .write_en_5(write_en_5), .write_en_6(write_en_6), .write_en_7(write_en_7), 
              .Cin_bits0(Cin_bits0), .Cin_bits1(Cin_bits1), .cfg_Carry_select_Int_0(cfg_Carry_select_Int_0), .cfg_Carry_select_Int_1(cfg_Carry_select_Int_1), 
              .O_6(O_6), .O_5(O_5), .Sum_0(Sum_0), .Sum_1(Sum_1), .Cout_lower(Cout_lower), .Sum_2(Sum_2), .Sum_3(Sum_3), .Cout_upper(Cout_upper));
              
                
              
    always #5 clk = ~clk;
    
    
    initial 
      begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_lut6);
        
        // initial condition
        clk = 1;
        write_en_0 = 0;  
        write_en_1 = 0;
        write_en_2 = 0;
        write_en_3 = 0;
        write_en_4 = 0;
        write_en_5 = 0;
        write_en_6 = 0;
        write_en_7 = 0;
        #10
        
        //config time
        write_en_0 = 1;  
        write_en_1 = 1;
        write_en_2 = 1;
        write_en_3 = 1;
          
        c=0; b=0; a=0;     Data_in=1;
        #10
        c=0; b=0; a=1;     Data_in=0;
        #10
        c=0; b=1; a=0;     Data_in=0;
        #10
        c=0; b=1; a=1;     Data_in=0;
        #10
        c=1; b=0; a=0;     Data_in=0;
        #10
        c=1; b=0; a=1;     Data_in=1;
        #10
        c=1; b=1; a=0;     Data_in=0;
        #10
        c=1; b=1; a=1;     Data_in=1;
        #10
        
        write_en_0 = 0;  
        write_en_1 = 0;
        write_en_2 = 0;
        write_en_3 = 0;
        #10
        write_en_4 = 1;
        write_en_5 = 1;
        write_en_6 = 1;
        write_en_7 = 1;
        
        c=0; b=0; a=0;     Data_in=0;
        #10
        c=0; b=0; a=1;     Data_in=1;
        #10
        c=0; b=1; a=0;     Data_in=1;
        #10
        c=0; b=1; a=1;     Data_in=1;
        #10
        c=1; b=0; a=0;     Data_in=1;
        #10
        c=1; b=0; a=1;     Data_in=0;
        #10
        c=1; b=1; a=0;     Data_in=1;
        #10
        c=1; b=1; a=1;     Data_in=0;
        #10
        write_en_4 = 0;
        write_en_5 = 0;
        write_en_6 = 0;
        write_en_7 = 0;
        #10;
        write_en_0 = 0;  
        write_en_1 = 0;
        write_en_2 = 0;
        write_en_3 = 0;
        write_en_4 = 0;
        write_en_5 = 0;
        write_en_6 = 0;
        write_en_7 = 0;
        #10
        
        //differentitaing time
        #50
        
                
        //normal ops  lut 6 and lut 5
       
        
        //lower values
        c=0; b=0; a=1;
        d = 0; e = 0; f = 0;
        #10
        c=1; b=0; a=0;
        d = 1; e = 0; f = 0;
        #10
        c=0; b=0; a=0;
        d = 0; e = 1; f = 0;
        #40
        
        //upper values
        c=0; b=0; a=1;
        d = 0; e = 0; f = 1;
        #10
        c=1; b=0; a=0;
        d = 0; e = 1; f = 1;
        #10
        c=0; b=0; a=0;
        d = 1; e = 0; f = 1;
        #50
        
         //config time
         
        c = 0; b = 0; a = 0;  
        write_en_0 = 1;  
        Data_in = 1;
        #10
        
        write_en_0 = 0;  
        write_en_1 = 1;  
        Data_in = 1;       
        #10
        
        write_en_1 = 0;  
        write_en_2 = 1;  
        Data_in = 0;
        #10
        
        write_en_2 = 0;  
        write_en_3 = 1;  
        Data_in = 1;
        #10
        write_en_3 = 0;  
        
        //differentitaing time
        #50
                
        //normal ops add and cin 0
        cfg_flag = 1;
        //cfg_Lower_negVal_sel = 0;
        cfg_Carry_select_Int_0 = 1;
        c=0; b=0; a=0;
        #10;
        cfg_flag = 0;
          
        
        //differentitaing time
        #50
        
        //normal ops add cin 1
        // sub and a distant adders
        cfg_flag = 1;
       // cfg_Lower_negVal_sel = 0;
        Cin_bits0 = 1;
        cfg_Carry_select_Int_0 = 0;
        c=0; b=0; a=0;  
        #10;
        cfg_flag = 0;
        
        //differentitaing time
        #50
        
         // 2 adders with cin 0
         cfg_flag = 1;
        // cfg_Lower_negVal_sel = 0;
        cfg_Carry_select_Int_0 = 0;
        cfg_Carry_select_Int_1 = 0;
        Cin_bits0 = 0;
        c=0; b=0; a=0;  
        #10;
        cfg_flag = 0;
        
        
        //differentitaing time
        #50
        
         // 2 adders with cin 1
        cfg_flag = 1;
        //cfg_Lower_negVal_sel = 0;
        cfg_Carry_select_Int_0 = 0;
        cfg_Carry_select_Int_1 = 0;
        Cin_bits0 = 1;
        c=0; b=0; a=0;  
        #50
        
//         // 2 adders with cin 1
         
//       // cfg_Lower_negVal_sel = 0;
//        cfg_Carry_select_Int_0 = 2;
//        Cin_bits0 = 1;
//        c=0; b=0; a=0;  
      
//        cfg_Upper_negVal_sel = 0;
//        cfg_Carry_select_Int_1 = 2;
//        Cin_bits1 = 1;
//        #10
//        $display("Carry_select_Int_1 = %b", cfg_Carry_select_Int_1);
//        $display("Wire_Cout_LowerNibble = %b", dut.Wire_Cout_Lower);
//        $display("Cin_upper_nibble = %b", dut.Cin_upper_nibble);
//        $display("Carry_UpperNibble_out = %b", dut.Carry_UpperNibble_out);
        
//        $display("Wire_UpperNibble_AddSub_Sel_val = %b", dut.Wire_UpperNibble_AddSub_Sel_val);
//        $display("Out_lut3_5 = %b", dut.Out_lut3_5);
//        $display("Carry_UpperNibble_out = %b", dut.Carry_UpperNibble_out);
        
//        $display("Sum_2 = %b", dut.Sum_2);
        
        //differentitaing time
        #50
        
        // sub
        cfg_flag = 1;
        cfg_Carry_select_Int_0 = 3;
       // cfg_Lower_negVal_sel = 1;
        Cin_bits0 = 0;  //doesnt matter
        c=0; b=0; a=0;  
        #10;
        cfg_flag = 0;
        
        //differentitaing time
        #50
        
        
        
        
          // 2 adders with cin 0
         cfg_flag = 1;
        // cfg_Lower_negVal_sel = 0;
        cfg_Carry_select_Int_0 = 3;
        Cin_bits0 = 0;// doesnt matter
        cfg_Carry_select_Int_1 = 3;
        Cin_bits0 = 0;// doesnt matter
        c=0; b=0; a=0;  
        #10;
        cfg_flag = 0;
        
        
        
        //differentitaing time
        #50
        
        
        
       $finish; 
      end   
 endmodule
 
 

module tb_clb_1_bit;

    //lut6
    logic clk, cfg_flag;
    logic a,b,c,d,e,f, Data_in;
    logic write_en_0, write_en_1, write_en_2, write_en_3, write_en_4, write_en_5, write_en_6, write_en_7;
    logic Cin_bits0, Cin_bits1;
    logic [1:0] cfg_Carry_select_Int_0, cfg_Carry_select_Int_1;
    logic O_6, O_5;
    logic Sum_0, Sum_1, Cout_lower, Sum_2, Sum_3, Cout_upper;
    //clb 
    logic [1:0] cfg_sel_clb_out, cfg_sel_Dff_out;
    logic dff_reset;
    logic out, Mem_out;
    


    clb_1_bit  dut(.clk(clk), .cfg_flag(cfg_flag), .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .Data_in(Data_in),
    .write_en_0(write_en_0), .write_en_1(write_en_1), .write_en_2(write_en_2), .write_en_3(write_en_3), .write_en_4(write_en_4), .write_en_5(write_en_5), .write_en_6(write_en_6), .write_en_7(write_en_7),
    .Cin_bits0(Cin_bits0), .Cin_bits1(Cin_bits1), .cfg_Carry_select_Int_0(cfg_Carry_select_Int_0), .cfg_Carry_select_Int_1(cfg_Carry_select_Int_1),
    .O_6(O_6), .O_5(O_5), .Sum_0(Sum_0), .Sum_1(Sum_1), .Cout_lower(Cout_lower), .Sum_2(Sum_2), .Sum_3(Sum_3), .Cout_upper(Cout_upper),
    .cfg_sel_clb_out(cfg_sel_clb_out), .cfg_sel_Dff_out(cfg_sel_Dff_out), .dff_reset(dff_reset), .out(out), .Mem_out(Mem_out)
);
              
    
    always #5 clk = ~clk;
    
      initial 
      begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_clb_1_bit);
        
        // initial condition
        clk = 1;
        write_en_0 = 0;  
        write_en_1 = 0;
        write_en_2 = 0;
        write_en_3 = 0;
        write_en_4 = 0;
        write_en_5 = 0;
        write_en_6 = 0;
        write_en_7 = 0;
        dff_reset = 0;
        #10
        
        
        //config time
        dff_reset = 1;
        write_en_0 = 1;  
        write_en_1 = 1;
        write_en_2 = 1;
        write_en_3 = 1;
          
        c=0; b=0; a=0;     Data_in=1;
        #10
        c=0; b=0; a=1;     Data_in=0;
        #10
        c=0; b=1; a=0;     Data_in=0;
        #10
        c=0; b=1; a=1;     Data_in=0;
        #10
        c=1; b=0; a=0;     Data_in=0;
        #10
        c=1; b=0; a=1;     Data_in=1;
        #10
        c=1; b=1; a=0;     Data_in=0;
        #10
        c=1; b=1; a=1;     Data_in=1;
        #10
        
        write_en_0 = 0;  
        write_en_1 = 0;
        write_en_2 = 0;
        write_en_3 = 0;
        #10
        write_en_4 = 1;
        write_en_5 = 1;
        write_en_6 = 1;
        write_en_7 = 1;
        
        c=0; b=0; a=0;     Data_in=0;
        #10
        c=0; b=0; a=1;     Data_in=1;
        #10
        c=0; b=1; a=0;     Data_in=1;
        #10
        c=0; b=1; a=1;     Data_in=1;
        #10
        c=1; b=0; a=0;     Data_in=1;
        #10
        c=1; b=0; a=1;     Data_in=0;
        #10
        c=1; b=1; a=0;     Data_in=1;
        #10
        c=1; b=1; a=1;     Data_in=0;
        #10
        write_en_4 = 0;
        write_en_5 = 0;
        write_en_6 = 0;
        write_en_7 = 0;
        

        
        //differentitaing time
        #50
        
                
        //normal ops  lut 6 and lut 5
        write_en_0 = 0;  
        write_en_1 = 0;
        write_en_2 = 0;
        write_en_3 = 0;
        write_en_4 = 0;
        write_en_5 = 0;
        write_en_6 = 0;
        write_en_7 = 0;
        #10
        
        //lower values
        c=0; b=0; a=1;
        d = 0; e = 0; f = 0;
        #10
        c=1; b=0; a=0;
        d = 1; e = 0; f = 0;
        #10
        c=0; b=0; a=0;
        d = 0; e = 1; f = 0;
        #40
        
        
        
        //upper values
        c=0; b=0; a=1;
        d = 0; e = 0; f = 1;
        #10
        c=1; b=0; a=0;
        d = 0; e = 1; f = 1;
        #10
        c=0; b=0; a=0;
        d = 1; e = 0; f = 1;
        #50
        
        
        
         //config time
        c = 0; b = 0; a = 0;  
        write_en_0 = 1;  
        Data_in = 1;
        #10
        
        write_en_0 = 0;  
        write_en_1 = 1;  
        Data_in = 1;       
        #10
        
        write_en_1 = 0;  
        write_en_2 = 1;  
        Data_in = 0;
        #10
        
        write_en_2 = 0;  
        write_en_3 = 1;  
        Data_in = 1;
        #10
        write_en_3 = 0;  
        
         dff_reset = 1;
        
        
        
        //differentitaing time
        #50
        
                
        //1.normal ops add and cin 0
        cfg_flag = 1;
        cfg_Carry_select_Int_0 = 0;
        Cin_bits0 = 0;
        c=0; b=0; a=0;  
            $display("1.Current simulation time = %0t", $time);
              #10
        
        
        //differentitaing time
        cfg_flag = 0;
        #50
        
        //2.normal ops add cin 1
        cfg_flag = 1;
        cfg_Carry_select_Int_0 = 0;
        Cin_bits0 = 1;
        c=0; b=0; a=0;  
            $display("2.Current simulation time = %0t", $time);
              #10
        
        
        //differentitaing time
        cfg_flag = 0;
        #50
        
         // 3. 2 adders with cin 0
        cfg_flag = 1;
        cfg_Carry_select_Int_0 = 0;
        cfg_Carry_select_Int_0 = 0;
        Cin_bits0 = 0;
        Cin_bits1 = 0;
        c=0; b=0; a=0;  
            $display("3.Current simulation time = %0t", $time);
              #10
        
           //differentitaing time
        cfg_flag = 0;
        #50
        
         //4. 2 adders with cin 1
        cfg_flag = 1;
        cfg_Carry_select_Int_0 = 0;
        cfg_Carry_select_Int_1 = 1;
        Cin_bits0 = 1;
        Cin_bits1 = 1;
        c=0; b=0; a=0;  
    $display("4.Current simulation time = %0t", $time);
      #10
        
        //differentitaing time
        cfg_flag = 0;
        #50
        

        //5. sub
        cfg_flag = 1;
        cfg_Carry_select_Int_0 = 2;
        cfg_Carry_select_Int_1 = 3;
        Cin_bits0 = 0;//dont matter
        Cin_bits1 = 1;//dont matter
        c=0; b=0; a=0;  
            $display("5.Current simulation time = %0t", $time);
          #10
        
        
        //differentitaing time
        cfg_flag = 0;
        #50
        
        
        
        //config time
        //6. send zero to ouput and dff
        cfg_flag = 1;
        cfg_sel_clb_out = 0;
        cfg_sel_Dff_out =0;
        #10
            $display("6.Current simulation time = %0t", $time);
        
         //normal ops
         cfg_flag = 0;
         #50
        
        //config time
        //7. send o5 to to dff and o6 to out
        cfg_flag = 1;
        cfg_sel_clb_out = 1;
        cfg_sel_Dff_out =2;
        #10
            $display("7.Current simulation time = %0t", $time);
        
         //normal ops
         cfg_flag = 0;
         #50

      
         //config time
         //reset dff 
         dff_reset = 0;
             $display("8.Current simulation time = %0t", $time);
         #10;
           
         //normal ops
         #50
         
         dff_reset = 1;
             $display("9.Current simulation time = %0t", $time);
         
         //normal ops
         #50
         
        
        //config time
        // din to bith
        cfg_flag = 1;
        cfg_sel_clb_out = 3;
        cfg_sel_Dff_out = 3;
            $display("10.Current simulation time = %0t", $time);
        #10
        
         //normal ops
         cfg_flag = 0;
         #50
      
        
       $finish; 
      end             
endmodule