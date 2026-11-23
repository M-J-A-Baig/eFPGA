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










module tb_clb;
        
        logic clk, cfg_flag, Cin_8_to_16, Cin_16_to_24, Cin_24_to_32, reset = 0;;
        logic [1:0] cfg_Cin_8_to_16, cfg_Cin_16_to_24, cfg_Cin_24_to_32;
        
        // bit 0
        // lut6
        logic bit0_a, bit0_b, bit0_c, bit0_d, bit0_e, bit0_f, bit0_Data_in;
        logic bit0_write_en_0, bit0_write_en_1, bit0_write_en_2, bit0_write_en_3, bit0_write_en_4, bit0_write_en_5, bit0_write_en_6, bit0_write_en_7;
        logic bit0_Cin_bits0, bit0_Cin_bits1;
        logic [1:0] bit0_cfg_Carry_select_Int_0, bit0_cfg_Carry_select_Int_1;
        logic bit0_O_6, bit0_O_5;
        logic bit0_Sum_0, bit0_Sum_1, bit0_Cout_lower, bit0_Sum_2, bit0_Sum_3, bit0_Cout_upper;
        // clb
        logic [1:0] bit0_cfg_sel_clb_out, bit0_cfg_sel_Dff_out;
        logic bit0_out, bit0_Mem_out;
        
        // bit 1
        // lut6
        logic bit1_a, bit1_b, bit1_c, bit1_d, bit1_e, bit1_f, bit1_Data_in;
        logic bit1_write_en_0, bit1_write_en_1, bit1_write_en_2, bit1_write_en_3, bit1_write_en_4, bit1_write_en_5, bit1_write_en_6, bit1_write_en_7;
        logic bit1_Cin_bits1;
        logic [1:0] bit1_cfg_Carry_select_Int_0, bit1_cfg_Carry_select_Int_1;
        logic bit1_O_6, bit1_O_5;
        logic bit1_Sum_0, bit1_Sum_1, bit1_Cout_lower, bit1_Sum_2, bit1_Sum_3, bit1_Cout_upper;
        // clb
        logic [1:0] bit1_cfg_sel_clb_out, bit1_cfg_sel_Dff_out;
        logic bit1_out, bit1_Mem_out;
        
        // bit 2
        // lut6
        logic bit2_a, bit2_b, bit2_c, bit2_d, bit2_e, bit2_f, bit2_Data_in;
        logic bit2_write_en_0, bit2_write_en_1, bit2_write_en_2, bit2_write_en_3, bit2_write_en_4, bit2_write_en_5, bit2_write_en_6, bit2_write_en_7;
        logic bit2_Cin_bits1;
        logic [1:0] bit2_cfg_Carry_select_Int_0, bit2_cfg_Carry_select_Int_1;
        logic bit2_O_6, bit2_O_5;
        logic bit2_Sum_0, bit2_Sum_1, bit2_Cout_lower, bit2_Sum_2, bit2_Sum_3, bit2_Cout_upper;
        // clb
        logic [1:0] bit2_cfg_sel_clb_out, bit2_cfg_sel_Dff_out;
        logic bit2_out, bit2_Mem_out;
        
        // bit 3
        // lut6
        logic bit3_a, bit3_b, bit3_c, bit3_d, bit3_e, bit3_f, bit3_Data_in;
        logic bit3_write_en_0, bit3_write_en_1, bit3_write_en_2, bit3_write_en_3, bit3_write_en_4, bit3_write_en_5, bit3_write_en_6, bit3_write_en_7;
        logic bit3_Cin_bits1;
        logic [1:0] bit3_cfg_Carry_select_Int_0, bit3_cfg_Carry_select_Int_1;
        logic bit3_O_6, bit3_O_5;
        logic bit3_Sum_0, bit3_Sum_1, bit3_Cout_lower, bit3_Sum_2, bit3_Sum_3, bit3_Cout_upper;
        // clb
        logic [1:0] bit3_cfg_sel_clb_out, bit3_cfg_sel_Dff_out;
        logic bit3_out, bit3_Mem_out;
        
        // bit 4
        // lut6
        logic bit4_a, bit4_b, bit4_c, bit4_d, bit4_e, bit4_f, bit4_Data_in;
        logic bit4_write_en_0, bit4_write_en_1, bit4_write_en_2, bit4_write_en_3, bit4_write_en_4, bit4_write_en_5, bit4_write_en_6, bit4_write_en_7;
        logic bit4_Cin_bits1;
        logic [1:0] bit4_cfg_Carry_select_Int_0, bit4_cfg_Carry_select_Int_1;
        logic bit4_O_6, bit4_O_5;
        logic bit4_Sum_0, bit4_Sum_1, bit4_Cout_lower, bit4_Sum_2, bit4_Sum_3, bit4_Cout_upper;
        // clb
        logic [1:0] bit4_cfg_sel_clb_out, bit4_cfg_sel_Dff_out;
        logic bit4_out, bit4_Mem_out;
        
        // bit 5
        // lut6
        logic bit5_a, bit5_b, bit5_c, bit5_d, bit5_e, bit5_f, bit5_Data_in;
        logic bit5_write_en_0, bit5_write_en_1, bit5_write_en_2, bit5_write_en_3, bit5_write_en_4, bit5_write_en_5, bit5_write_en_6, bit5_write_en_7;
        logic bit5_Cin_bits1;
        logic [1:0] bit5_cfg_Carry_select_Int_0, bit5_cfg_Carry_select_Int_1;
        logic bit5_O_6, bit5_O_5;
        logic bit5_Sum_0, bit5_Sum_1, bit5_Cout_lower, bit5_Sum_2, bit5_Sum_3, bit5_Cout_upper;
        // clb
        logic [1:0] bit5_cfg_sel_clb_out, bit5_cfg_sel_Dff_out;
        logic bit5_out, bit5_Mem_out;
        
        // bit 6
        // lut6
        logic bit6_a, bit6_b, bit6_c, bit6_d, bit6_e, bit6_f, bit6_Data_in;
        logic bit6_write_en_0, bit6_write_en_1, bit6_write_en_2, bit6_write_en_3, bit6_write_en_4, bit6_write_en_5, bit6_write_en_6, bit6_write_en_7;
        logic bit6_Cin_bits1;
        logic [1:0] bit6_cfg_Carry_select_Int_0, bit6_cfg_Carry_select_Int_1;
        logic bit6_O_6, bit6_O_5;
        logic bit6_Sum_0, bit6_Sum_1, bit6_Cout_lower, bit6_Sum_2, bit6_Sum_3, bit6_Cout_upper;
        // clb
        logic [1:0] bit6_cfg_sel_clb_out, bit6_cfg_sel_Dff_out;
        logic bit6_out, bit6_Mem_out;
        
        // bit 7
        // lut6
        logic bit7_a, bit7_b, bit7_c, bit7_d, bit7_e, bit7_f, bit7_Data_in;
        logic bit7_write_en_0, bit7_write_en_1, bit7_write_en_2, bit7_write_en_3, bit7_write_en_4, bit7_write_en_5, bit7_write_en_6, bit7_write_en_7;
        logic bit7_Cin_bits1;
        logic [1:0] bit7_cfg_Carry_select_Int_0, bit7_cfg_Carry_select_Int_1;
        logic bit7_O_6, bit7_O_5;
        logic bit7_Sum_0, bit7_Sum_1, bit7_Cout_lower, bit7_Sum_2, bit7_Sum_3, bit7_Cout_upper;
        // clb
        logic [1:0] bit7_cfg_sel_clb_out, bit7_cfg_sel_Dff_out;
        logic bit7_out, bit7_Mem_out;
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    clb  dut(
    .clk(clk), .cfg_flag(cfg_flag), .cfg_Cin_8_to_16(cfg_Cin_8_to_16), .cfg_Cin_16_to_24(cfg_Cin_16_to_24), .cfg_Cin_24_to_32(cfg_Cin_24_to_32), .Cin_8_to_16(Cin_8_to_16), .Cin_16_to_24(Cin_16_to_24), .Cin_24_to_32(Cin_24_to_32), .reset(reset),
    .bit0_a(bit0_a), .bit0_b(bit0_b), .bit0_c(bit0_c), .bit0_d(bit0_d), .bit0_e(bit0_e), .bit0_f(bit0_f), .bit0_Data_in(bit0_Data_in), .bit0_write_en_0(bit0_write_en_0), .bit0_write_en_1(bit0_write_en_1), .bit0_write_en_2(bit0_write_en_2), .bit0_write_en_3(bit0_write_en_3), .bit0_write_en_4(bit0_write_en_4), .bit0_write_en_5(bit0_write_en_5), .bit0_write_en_6(bit0_write_en_6), .bit0_write_en_7(bit0_write_en_7), .bit0_Cin_bits0(bit0_Cin_bits0), .bit0_Cin_bits1(bit0_Cin_bits1), .bit0_cfg_Carry_select_Int_0(bit0_cfg_Carry_select_Int_0), .bit0_cfg_Carry_select_Int_1(bit0_cfg_Carry_select_Int_1), .bit0_O_6(bit0_O_6), .bit0_O_5(bit0_O_5), .bit0_Sum_0(bit0_Sum_0), .bit0_Sum_1(bit0_Sum_1), .bit0_Cout_lower(bit0_Cout_lower), .bit0_Sum_2(bit0_Sum_2), .bit0_Sum_3(bit0_Sum_3), .bit0_Cout_upper(bit0_Cout_upper), .bit0_cfg_sel_clb_out(bit0_cfg_sel_clb_out), .bit0_cfg_sel_Dff_out(bit0_cfg_sel_Dff_out), .bit0_out(bit0_out), .bit0_Mem_out(bit0_Mem_out),
    .bit1_a(bit1_a), .bit1_b(bit1_b), .bit1_c(bit1_c), .bit1_d(bit1_d), .bit1_e(bit1_e), .bit1_f(bit1_f), .bit1_Data_in(bit1_Data_in), .bit1_write_en_0(bit1_write_en_0), .bit1_write_en_1(bit1_write_en_1), .bit1_write_en_2(bit1_write_en_2), .bit1_write_en_3(bit1_write_en_3), .bit1_write_en_4(bit1_write_en_4), .bit1_write_en_5(bit1_write_en_5), .bit1_write_en_6(bit1_write_en_6), .bit1_write_en_7(bit1_write_en_7),                                  .bit1_Cin_bits1(bit1_Cin_bits1), .bit1_cfg_Carry_select_Int_0(bit1_cfg_Carry_select_Int_0), .bit1_cfg_Carry_select_Int_1(bit1_cfg_Carry_select_Int_1), .bit1_O_6(bit1_O_6), .bit1_O_5(bit1_O_5), .bit1_Sum_0(bit1_Sum_0), .bit1_Sum_1(bit1_Sum_1), .bit1_Cout_lower(bit1_Cout_lower), .bit1_Sum_2(bit1_Sum_2), .bit1_Sum_3(bit1_Sum_3), .bit1_Cout_upper(bit1_Cout_upper), .bit1_cfg_sel_clb_out(bit1_cfg_sel_clb_out), .bit1_cfg_sel_Dff_out(bit1_cfg_sel_Dff_out), .bit1_out(bit1_out), .bit1_Mem_out(bit1_Mem_out),
    .bit2_a(bit2_a), .bit2_b(bit2_b), .bit2_c(bit2_c), .bit2_d(bit2_d), .bit2_e(bit2_e), .bit2_f(bit2_f), .bit2_Data_in(bit2_Data_in), .bit2_write_en_0(bit2_write_en_0), .bit2_write_en_1(bit2_write_en_1), .bit2_write_en_2(bit2_write_en_2), .bit2_write_en_3(bit2_write_en_3), .bit2_write_en_4(bit2_write_en_4), .bit2_write_en_5(bit2_write_en_5), .bit2_write_en_6(bit2_write_en_6), .bit2_write_en_7(bit2_write_en_7),                                  .bit2_Cin_bits1(bit2_Cin_bits1), .bit2_cfg_Carry_select_Int_0(bit2_cfg_Carry_select_Int_0), .bit2_cfg_Carry_select_Int_1(bit2_cfg_Carry_select_Int_1), .bit2_O_6(bit2_O_6), .bit2_O_5(bit2_O_5), .bit2_Sum_0(bit2_Sum_0), .bit2_Sum_1(bit2_Sum_1), .bit2_Cout_lower(bit2_Cout_lower), .bit2_Sum_2(bit2_Sum_2), .bit2_Sum_3(bit2_Sum_3), .bit2_Cout_upper(bit2_Cout_upper), .bit2_cfg_sel_clb_out(bit2_cfg_sel_clb_out), .bit2_cfg_sel_Dff_out(bit2_cfg_sel_Dff_out), .bit2_out(bit2_out), .bit2_Mem_out(bit2_Mem_out),
    .bit3_a(bit3_a), .bit3_b(bit3_b), .bit3_c(bit3_c), .bit3_d(bit3_d), .bit3_e(bit3_e), .bit3_f(bit3_f), .bit3_Data_in(bit3_Data_in), .bit3_write_en_0(bit3_write_en_0), .bit3_write_en_1(bit3_write_en_1), .bit3_write_en_2(bit3_write_en_2), .bit3_write_en_3(bit3_write_en_3), .bit3_write_en_4(bit3_write_en_4), .bit3_write_en_5(bit3_write_en_5), .bit3_write_en_6(bit3_write_en_6), .bit3_write_en_7(bit3_write_en_7),                                  .bit3_Cin_bits1(bit3_Cin_bits1), .bit3_cfg_Carry_select_Int_0(bit3_cfg_Carry_select_Int_0), .bit3_cfg_Carry_select_Int_1(bit3_cfg_Carry_select_Int_1), .bit3_O_6(bit3_O_6), .bit3_O_5(bit3_O_5), .bit3_Sum_0(bit3_Sum_0), .bit3_Sum_1(bit3_Sum_1), .bit3_Cout_lower(bit3_Cout_lower), .bit3_Sum_2(bit3_Sum_2), .bit3_Sum_3(bit3_Sum_3), .bit3_Cout_upper(bit3_Cout_upper), .bit3_cfg_sel_clb_out(bit3_cfg_sel_clb_out), .bit3_cfg_sel_Dff_out(bit3_cfg_sel_Dff_out), .bit3_out(bit3_out), .bit3_Mem_out(bit3_Mem_out),
    .bit4_a(bit4_a), .bit4_b(bit4_b), .bit4_c(bit4_c), .bit4_d(bit4_d), .bit4_e(bit4_e), .bit4_f(bit4_f), .bit4_Data_in(bit4_Data_in), .bit4_write_en_0(bit4_write_en_0), .bit4_write_en_1(bit4_write_en_1), .bit4_write_en_2(bit4_write_en_2), .bit4_write_en_3(bit4_write_en_3), .bit4_write_en_4(bit4_write_en_4), .bit4_write_en_5(bit4_write_en_5), .bit4_write_en_6(bit4_write_en_6), .bit4_write_en_7(bit4_write_en_7),                                  .bit4_Cin_bits1(bit4_Cin_bits1), .bit4_cfg_Carry_select_Int_0(bit4_cfg_Carry_select_Int_0), .bit4_cfg_Carry_select_Int_1(bit4_cfg_Carry_select_Int_1), .bit4_O_6(bit4_O_6), .bit4_O_5(bit4_O_5), .bit4_Sum_0(bit4_Sum_0), .bit4_Sum_1(bit4_Sum_1), .bit4_Cout_lower(bit4_Cout_lower), .bit4_Sum_2(bit4_Sum_2), .bit4_Sum_3(bit4_Sum_3), .bit4_Cout_upper(bit4_Cout_upper), .bit4_cfg_sel_clb_out(bit4_cfg_sel_clb_out), .bit4_cfg_sel_Dff_out(bit4_cfg_sel_Dff_out), .bit4_out(bit4_out), .bit4_Mem_out(bit4_Mem_out),
    .bit5_a(bit5_a), .bit5_b(bit5_b), .bit5_c(bit5_c), .bit5_d(bit5_d), .bit5_e(bit5_e), .bit5_f(bit5_f), .bit5_Data_in(bit5_Data_in), .bit5_write_en_0(bit5_write_en_0), .bit5_write_en_1(bit5_write_en_1), .bit5_write_en_2(bit5_write_en_2), .bit5_write_en_3(bit5_write_en_3), .bit5_write_en_4(bit5_write_en_4), .bit5_write_en_5(bit5_write_en_5), .bit5_write_en_6(bit5_write_en_6), .bit5_write_en_7(bit5_write_en_7),                                  .bit5_Cin_bits1(bit5_Cin_bits1), .bit5_cfg_Carry_select_Int_0(bit5_cfg_Carry_select_Int_0), .bit5_cfg_Carry_select_Int_1(bit5_cfg_Carry_select_Int_1), .bit5_O_6(bit5_O_6), .bit5_O_5(bit5_O_5), .bit5_Sum_0(bit5_Sum_0), .bit5_Sum_1(bit5_Sum_1), .bit5_Cout_lower(bit5_Cout_lower), .bit5_Sum_2(bit5_Sum_2), .bit5_Sum_3(bit5_Sum_3), .bit5_Cout_upper(bit5_Cout_upper), .bit5_cfg_sel_clb_out(bit5_cfg_sel_clb_out), .bit5_cfg_sel_Dff_out(bit5_cfg_sel_Dff_out), .bit5_out(bit5_out), .bit5_Mem_out(bit5_Mem_out),
    .bit6_a(bit6_a), .bit6_b(bit6_b), .bit6_c(bit6_c), .bit6_d(bit6_d), .bit6_e(bit6_e), .bit6_f(bit6_f), .bit6_Data_in(bit6_Data_in), .bit6_write_en_0(bit6_write_en_0), .bit6_write_en_1(bit6_write_en_1), .bit6_write_en_2(bit6_write_en_2), .bit6_write_en_3(bit6_write_en_3), .bit6_write_en_4(bit6_write_en_4), .bit6_write_en_5(bit6_write_en_5), .bit6_write_en_6(bit6_write_en_6), .bit6_write_en_7(bit6_write_en_7),                                  .bit6_Cin_bits1(bit6_Cin_bits1), .bit6_cfg_Carry_select_Int_0(bit6_cfg_Carry_select_Int_0), .bit6_cfg_Carry_select_Int_1(bit6_cfg_Carry_select_Int_1), .bit6_O_6(bit6_O_6), .bit6_O_5(bit6_O_5), .bit6_Sum_0(bit6_Sum_0), .bit6_Sum_1(bit6_Sum_1), .bit6_Cout_lower(bit6_Cout_lower), .bit6_Sum_2(bit6_Sum_2), .bit6_Sum_3(bit6_Sum_3), .bit6_Cout_upper(bit6_Cout_upper), .bit6_cfg_sel_clb_out(bit6_cfg_sel_clb_out), .bit6_cfg_sel_Dff_out(bit6_cfg_sel_Dff_out), .bit6_out(bit6_out), .bit6_Mem_out(bit6_Mem_out),
    .bit7_a(bit7_a), .bit7_b(bit7_b), .bit7_c(bit7_c), .bit7_d(bit7_d), .bit7_e(bit7_e), .bit7_f(bit7_f), .bit7_Data_in(bit7_Data_in), .bit7_write_en_0(bit7_write_en_0), .bit7_write_en_1(bit7_write_en_1), .bit7_write_en_2(bit7_write_en_2), .bit7_write_en_3(bit7_write_en_3), .bit7_write_en_4(bit7_write_en_4), .bit7_write_en_5(bit7_write_en_5), .bit7_write_en_6(bit7_write_en_6), .bit7_write_en_7(bit7_write_en_7),                                  .bit7_Cin_bits1(bit7_Cin_bits1), .bit7_cfg_Carry_select_Int_0(bit7_cfg_Carry_select_Int_0), .bit7_cfg_Carry_select_Int_1(bit7_cfg_Carry_select_Int_1), .bit7_O_6(bit7_O_6), .bit7_O_5(bit7_O_5), .bit7_Sum_0(bit7_Sum_0), .bit7_Sum_1(bit7_Sum_1), .bit7_Cout_lower(bit7_Cout_lower), .bit7_Sum_2(bit7_Sum_2), .bit7_Sum_3(bit7_Sum_3), .bit7_Cout_upper(bit7_Cout_upper), .bit7_cfg_sel_clb_out(bit7_cfg_sel_clb_out), .bit7_cfg_sel_Dff_out(bit7_cfg_sel_Dff_out), .bit7_out(bit7_out), .bit7_Mem_out(bit7_Mem_out)
);
        
        
        
        
        
        
        
        
        
        
        
            
    always #5 clk = ~clk;
    
       
        
        
        initial
        begin
            $dumpfile("dump.vcd");
            $dumpvars(0, tb_clb);
        
            // Initial conditions
            clk = 1;
        
            reset = 0;
        
            {bit7_write_en_0, bit6_write_en_0, bit5_write_en_0, bit4_write_en_0,
             bit3_write_en_0, bit2_write_en_0, bit1_write_en_0, bit0_write_en_0} = 0;
        
            {bit7_write_en_1, bit6_write_en_1, bit5_write_en_1, bit4_write_en_1,
             bit3_write_en_1, bit2_write_en_1, bit1_write_en_1, bit0_write_en_1} = 0;
        
            {bit7_write_en_2, bit6_write_en_2, bit5_write_en_2, bit4_write_en_2,
             bit3_write_en_2, bit2_write_en_2, bit1_write_en_2, bit0_write_en_2} = 0;
        
            {bit7_write_en_3, bit6_write_en_3, bit5_write_en_3, bit4_write_en_3,
             bit3_write_en_3, bit2_write_en_3, bit1_write_en_3, bit0_write_en_3} = 0;
        
            {bit7_write_en_4, bit6_write_en_4, bit5_write_en_4, bit4_write_en_4,
             bit3_write_en_4, bit2_write_en_4, bit1_write_en_4, bit0_write_en_4} = 0;
        
            {bit7_write_en_5, bit6_write_en_5, bit5_write_en_5, bit4_write_en_5,
             bit3_write_en_5, bit2_write_en_5, bit1_write_en_5, bit0_write_en_5} = 0;
        
            {bit7_write_en_6, bit6_write_en_6, bit5_write_en_6, bit4_write_en_6,
             bit3_write_en_6, bit2_write_en_6, bit1_write_en_6, bit0_write_en_6} = 0;
        
            {bit7_write_en_7, bit6_write_en_7, bit5_write_en_7, bit4_write_en_7,
             bit3_write_en_7, bit2_write_en_7, bit1_write_en_7, bit0_write_en_7} = 0;
        
            #10;
        
            // Configuration time  reset high
              reset = 1;
        
//            // Enable LUT configuration addresses 0-3
//            {bit7_write_en_0, bit6_write_en_0, bit5_write_en_0, bit4_write_en_0,
//             bit3_write_en_0, bit2_write_en_0, bit1_write_en_0, bit0_write_en_0} = 8'hFF;
        
//            {bit7_write_en_1, bit6_write_en_1, bit5_write_en_1, bit4_write_en_1,
//             bit3_write_en_1, bit2_write_en_1, bit1_write_en_1, bit0_write_en_1} = 8'hFF;
        
//            {bit7_write_en_2, bit6_write_en_2, bit5_write_en_2, bit4_write_en_2,
//             bit3_write_en_2, bit2_write_en_2, bit1_write_en_2, bit0_write_en_2} = 8'hFF;
        
//            {bit7_write_en_3, bit6_write_en_3, bit5_write_en_3, bit4_write_en_3,
//             bit3_write_en_3, bit2_write_en_3, bit1_write_en_3, bit0_write_en_3} = 8'hFF;
        
//            // Configuration data for LUT 0-3
        
//            {bit7_c, bit6_c, bit5_c, bit4_c, bit3_c, bit2_c, bit1_c, bit0_c} = 0;
//            {bit7_b, bit6_b, bit5_b, bit4_b, bit3_b, bit2_b, bit1_b, bit0_b} = 0;
//            {bit7_a, bit6_a, bit5_a, bit4_a, bit3_a, bit2_a, bit1_a, bit0_a} = 0;
        
//            {bit7_Data_in, bit6_Data_in, bit5_Data_in, bit4_Data_in,
//             bit3_Data_in, bit2_Data_in, bit1_Data_in, bit0_Data_in} = 8'hFF;
        
//            #10;
        
//            {bit7_c, bit6_c, bit5_c, bit4_c, bit3_c, bit2_c, bit1_c, bit0_c} = 0;
//            {bit7_b, bit6_b, bit5_b, bit4_b, bit3_b, bit2_b, bit1_b, bit0_b} = 0;
//            {bit7_a, bit6_a, bit5_a, bit4_a, bit3_a, bit2_a, bit1_a, bit0_a} = 8'hFF;
        
//            {bit7_Data_in, bit6_Data_in, bit5_Data_in, bit4_Data_in,
//             bit3_Data_in, bit2_Data_in, bit1_Data_in, bit0_Data_in} = 0;
        
//            #10;
        
//            {bit7_c, bit6_c, bit5_c, bit4_c, bit3_c, bit2_c, bit1_c, bit0_c} = 0;
//            {bit7_b, bit6_b, bit5_b, bit4_b, bit3_b, bit2_b, bit1_b, bit0_b} = 8'hFF;
//            {bit7_a, bit6_a, bit5_a, bit4_a, bit3_a, bit2_a, bit1_a, bit0_a} = 0;
        
//            #10;
        
//            {bit7_c, bit6_c, bit5_c, bit4_c, bit3_c, bit2_c, bit1_c, bit0_c} = 0;
//            {bit7_b, bit6_b, bit5_b, bit4_b, bit3_b, bit2_b, bit1_b, bit0_b} = 8'hFF;
//            {bit7_a, bit6_a, bit5_a, bit4_a, bit3_a, bit2_a, bit1_a, bit0_a} = 8'hFF;
        
//            #10;
        
//            {bit7_c, bit6_c, bit5_c, bit4_c, bit3_c, bit2_c, bit1_c, bit0_c} = 8'hFF;
//            {bit7_b, bit6_b, bit5_b, bit4_b, bit3_b, bit2_b, bit1_b, bit0_b} = 0;
//            {bit7_a, bit6_a, bit5_a, bit4_a, bit3_a, bit2_a, bit1_a, bit0_a} = 0;
        
//            #10;
        
//            {bit7_c, bit6_c, bit5_c, bit4_c, bit3_c, bit2_c, bit1_c, bit0_c} = 8'hFF;
//            {bit7_b, bit6_b, bit5_b, bit4_b, bit3_b, bit2_b, bit1_b, bit0_b} = 0;
//            {bit7_a, bit6_a, bit5_a, bit4_a, bit3_a, bit2_a, bit1_a, bit0_a} = 8'hFF;
        
//            {bit7_Data_in, bit6_Data_in, bit5_Data_in, bit4_Data_in,
//             bit3_Data_in, bit2_Data_in, bit1_Data_in, bit0_Data_in} = 8'hFF;
        
//            #10;
        
//            {bit7_c, bit6_c, bit5_c, bit4_c, bit3_c, bit2_c, bit1_c, bit0_c} = 8'hFF;
//            {bit7_b, bit6_b, bit5_b, bit4_b, bit3_b, bit2_b, bit1_b, bit0_b} = 8'hFF;
//            {bit7_a, bit6_a, bit5_a, bit4_a, bit3_a, bit2_a, bit1_a, bit0_a} = 0;
        
//            #10;
        
//            {bit7_c, bit6_c, bit5_c, bit4_c, bit3_c, bit2_c, bit1_c, bit0_c} = 8'hFF;
//            {bit7_b, bit6_b, bit5_b, bit4_b, bit3_b, bit2_b, bit1_b, bit0_b} = 8'hFF;
//            {bit7_a, bit6_a, bit5_a, bit4_b, bit3_a, bit2_a, bit1_a, bit0_a} = 8'hFF;
        
//            #10;
        
//            // Disable LUT configuration addresses 0-3
//            {bit7_write_en_0, bit6_write_en_0, bit5_write_en_0, bit4_write_en_0,
//             bit3_write_en_0, bit2_write_en_0, bit1_write_en_0, bit0_write_en_0} = 0;
        
//            {bit7_write_en_1, bit6_write_en_1, bit5_write_en_1, bit4_write_en_1,
//             bit3_write_en_1, bit2_write_en_1, bit1_write_en_1, bit0_write_en_1} = 0;
        
//            {bit7_write_en_2, bit6_write_en_2, bit5_write_en_2, bit4_write_en_2,
//             bit3_write_en_2, bit2_write_en_2, bit1_write_en_2, bit0_write_en_2} = 0;
        
//            {bit7_write_en_3, bit6_write_en_3, bit5_write_en_3, bit4_write_en_3,
//             bit3_write_en_3, bit2_write_en_3, bit1_write_en_3, bit0_write_en_3} = 0;
        
//            #10;
        
//            // Enable LUT configuration addresses 4-7
        
//            {bit7_write_en_4, bit6_write_en_4, bit5_write_en_4, bit4_write_en_4,
//             bit3_write_en_4, bit2_write_en_4, bit1_write_en_4, bit0_write_en_4} = 8'hFF;
        
//            {bit7_write_en_5, bit6_write_en_5, bit5_write_en_5, bit4_write_en_5,
//             bit3_write_en_5, bit2_write_en_5, bit1_write_en_5, bit0_write_en_5} = 8'hFF;
        
//            {bit7_write_en_6, bit6_write_en_6, bit5_write_en_6, bit4_write_en_6,
//             bit3_write_en_6, bit2_write_en_6, bit1_write_en_6, bit0_write_en_6} = 8'hFF;
        
//            {bit7_write_en_7, bit6_write_en_7, bit5_write_en_7, bit4_write_en_7,
//             bit3_write_en_7, bit2_write_en_7, bit1_write_en_7, bit0_write_en_7} = 8'hFF;
        
//            // Configuration data for LUT 4-7
        
//            {bit7_c, bit6_c, bit5_c, bit4_c, bit3_c, bit2_c, bit1_c, bit0_c} = 0;
//            {bit7_b, bit6_b, bit5_b, bit4_b, bit3_b, bit2_b, bit1_b, bit0_b} = 0;
//            {bit7_a, bit6_a, bit5_a, bit4_a, bit3_a, bit2_a, bit1_a, bit0_a} = 0;
        
//            {bit7_Data_in, bit6_Data_in, bit5_Data_in, bit4_Data_in,
//             bit3_Data_in, bit2_Data_in, bit1_Data_in, bit0_Data_in} = 0;
        
//            #10;
        
//            {bit7_c, bit6_c, bit5_c, bit4_c, bit3_c, bit2_c, bit1_c, bit0_c} = 0;
//            {bit7_b, bit6_b, bit5_b, bit4_b, bit3_b, bit2_b, bit1_b, bit0_b} = 0;
//            {bit7_a, bit6_a, bit5_a, bit4_a, bit3_a, bit2_a, bit1_a, bit0_a} = 8'hFF;
        
//            {bit7_Data_in, bit6_Data_in, bit5_Data_in, bit4_Data_in,
//             bit3_Data_in, bit2_Data_in, bit1_Data_in, bit0_Data_in} = 8'hFF;
        
//            #10;
        
//            // Disable LUT configuration addresses 4-7
        
//            {bit7_write_en_4, bit6_write_en_4, bit5_write_en_4, bit4_write_en_4,
//             bit3_write_en_4, bit2_write_en_4, bit1_write_en_4, bit0_write_en_4} = 0;
        
//            {bit7_write_en_5, bit6_write_en_5, bit5_write_en_5, bit4_write_en_5,
//             bit3_write_en_5, bit2_write_en_5, bit1_write_en_5, bit0_write_en_5} = 0;
        
//            {bit7_write_en_6, bit6_write_en_6, bit5_write_en_6, bit4_write_en_6,
//             bit3_write_en_6, bit2_write_en_6, bit1_write_en_6, bit0_write_en_6} = 0;
        
//            {bit7_write_en_7, bit6_write_en_7, bit5_write_en_7, bit4_write_en_7,
//             bit3_write_en_7, bit2_write_en_7, bit1_write_en_7, bit0_write_en_7} = 0;
        
//            // Differentiating time
//            #50;
        
           
            #10;
            // Configuration time  reset high
            reset = 0;
            #10;
            // Configuration time  reset high
            reset = 1;
            #50;
            
           cfg_flag = 1; 

           {bit7_Data_in, bit6_Data_in, bit5_Data_in, bit4_Data_in, bit3_Data_in, bit2_Data_in, bit1_Data_in, bit0_Data_in} = 8'hFF;
           
           {bit7_write_en_0, bit6_write_en_0, bit5_write_en_0, bit4_write_en_0,  bit3_write_en_0, bit2_write_en_0, bit1_write_en_0, bit0_write_en_0} = 8'hFF;
           {bit7_write_en_1, bit6_write_en_1, bit5_write_en_1, bit4_write_en_1, bit3_write_en_1, bit2_write_en_1, bit1_write_en_1, bit0_write_en_1} = 8'hFF;
           {bit7_write_en_2, bit6_write_en_2, bit5_write_en_2, bit4_write_en_2, bit3_write_en_2, bit2_write_en_2, bit1_write_en_2, bit0_write_en_2} = 8'hFF;
           {bit7_write_en_3, bit6_write_en_3, bit5_write_en_3, bit4_write_en_3, bit3_write_en_3, bit2_write_en_3, bit1_write_en_3, bit0_write_en_3} = 8'hFF;
           {bit7_write_en_4, bit6_write_en_4, bit5_write_en_4, bit4_write_en_4,bit3_write_en_4, bit2_write_en_4, bit1_write_en_4, bit0_write_en_4} = 8'hFF;
           {bit7_write_en_5, bit6_write_en_5, bit5_write_en_5, bit4_write_en_5, bit3_write_en_5, bit2_write_en_5, bit1_write_en_5, bit0_write_en_5} = 8'hFF;
           {bit7_write_en_6, bit6_write_en_6, bit5_write_en_6, bit4_write_en_6, bit3_write_en_6, bit2_write_en_6, bit1_write_en_6, bit0_write_en_6} = 8'hFF;
           {bit7_write_en_7, bit6_write_en_7, bit5_write_en_7, bit4_write_en_7, bit3_write_en_7, bit2_write_en_7, bit1_write_en_7, bit0_write_en_7} = 8'hFF;
           
           {bit7_f, bit6_f, bit5_f, bit4_f, bit3_f, bit2_f, bit1_f, bit0_f} = 0;
           {bit7_e, bit6_e, bit5_e, bit4_e, bit3_e, bit2_e, bit1_e, bit0_e} = 0;
           {bit7_d, bit6_d, bit5_d, bit4_d, bit3_d, bit2_d, bit1_d, bit0_d} = 0;
           {bit7_c, bit6_c, bit5_c, bit4_c, bit3_c, bit2_c, bit1_c, bit0_c} = 0;
           {bit7_b, bit6_b, bit5_b, bit4_b, bit3_b, bit2_b, bit1_b, bit0_b} = 0;
           {bit7_a, bit6_a, bit5_a, bit4_a, bit3_a, bit2_a, bit1_a, bit0_a} = 0;
           
           
           
           
           bit0_Cin_bits0 = 1;
           bit0_cfg_Carry_select_Int_0 = 1'b1;
           bit0_cfg_Carry_select_Int_1 = 1'b0;
            
           bit1_cfg_Carry_select_Int_0 = 1'b1;
           bit1_cfg_Carry_select_Int_1 = 1'b0;
           
//           cfg_Cin_8_to_16 = 0;
           cfg_Cin_8_to_16 = 1;
           Cin_8_to_16 = 0;
            
           bit2_cfg_Carry_select_Int_0 = 1'b1;
           bit2_cfg_Carry_select_Int_1 = 1'b0;
            
           bit3_cfg_Carry_select_Int_0 = 1'b1;
           bit3_cfg_Carry_select_Int_1 = 1'b0;
           
//           cfg_Cin_16_to_24 = 0;
           cfg_Cin_16_to_24 = 1;
           Cin_16_to_24 = 0;
           
            
           bit4_cfg_Carry_select_Int_0 = 1'b1;
           bit4_cfg_Carry_select_Int_1 = 1'b0;
            
           bit5_cfg_Carry_select_Int_0 = 1'b1;
           bit5_cfg_Carry_select_Int_1 = 1'b0;
           
//           cfg_Cin_24_to_32 = 0;
           cfg_Cin_24_to_32 = 0;
           Cin_24_to_32 = 0;
           
           
            
           bit6_cfg_Carry_select_Int_0 = 1'b1;
           bit6_cfg_Carry_select_Int_1 = 1'b0;
            
           bit7_cfg_Carry_select_Int_0 = 1'b1;
           bit7_cfg_Carry_select_Int_1 = 1'b0;
           
           #10;
           bit0_Cin_bits0 = 0;
           
           
           #50;
           {bit7_f, bit6_f, bit5_f, bit4_f, bit3_f, bit2_f, bit1_f, bit0_f} = 0;
           {bit7_e, bit6_e, bit5_e, bit4_e, bit3_e, bit2_e, bit1_e, bit0_e} = 0;
           {bit7_d, bit6_d, bit5_d, bit4_d, bit3_d, bit2_d, bit1_d, bit0_d} = 0;
           {bit7_c, bit6_c, bit5_c, bit4_c, bit3_c, bit2_c, bit1_c, bit0_c} = 0;
           {bit7_b, bit6_b, bit5_b, bit4_b, bit3_b, bit2_b, bit1_b, bit0_b} = 0;
           {bit7_a, bit6_a, bit5_a, bit4_a, bit3_a, bit2_a, bit1_a, bit0_a} = 0;       
                      
                       

            
            
            
            
        
        end
        
endmodule

