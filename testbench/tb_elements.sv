`timescale 1ns / 1ps
`define Width 1

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: MJA Baig
// 
// Create Date: 10/13/2026 01:20:34 PM
// Design Name: eFPGA building blocks 
// Module Name: elements
// Project Name: eFPGA
// Target Devices: ASIC
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


module tb_Dlatch();
    
      logic d,en,q;
      
      DLatch dut(
          .d(d),
          .q(q),
          .enable(en)
       );
       
       
       initial
        begin
            en <= 0; d<=0; 
            #10
            en <= 1; d<=0; 
            #10
            en <= 0; d<=0; 
            #10
            en <= 0; d<=1; 
            #10
            en <= 1; d<=1; 
            #10
            en <= 0; d<=1; 
            #10
            en <= 0; d<=0; 
            #10
          $finish;
        
        end   
      
endmodule




module tb_dff;
  reg clk;
  reg WE;
  reg reset;
  reg [`Width-1:0] d;
  wire [`Width -1:0] q;

  DFF #(`Width) dut(
    .clk(clk),
    .WE(WE),
    .reset(reset),
    .d(d),
    .q(q)
  );

  // 1. Clock Generation: 10ns period (5ns HIGH, 5ns LOW)
  always #5 clk = ~clk;
  integer i;

  // 2. Stimulus Process
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_dff);

    // Monitor signal updates in stdout
    $monitor("Time=%0t | clk=%b reset=%b WE=%b d=%b -> q=%b", 
             $time, clk, reset, WE, d, q);

    clk = 0;
    WE  = 0;
    reset  = 1; //active low
    d   = 0;
    #5
    
    #10;
    reset = 0; d = 4'b0001;  WE = 1;       // Force reset active with d=1 to verify SR priority
    #10;
    reset = 1;             // Release reset

    #10;
    WE = 1; 
    //d = 4'b0010;      // Expect q = 1 on posedge clk
    for (i = 0; i < 5; i = i + 1) begin
      @(posedge clk);        // Wait for clock edge
      d = d + 1'b1;   // Apply vector
    end
    #10;
    d = 0;              // Expect q = 0 on posedge clk

    #10;
    WE = 0; d = 4'b0001;      // Changing d while WE=0; expect q to hold 0
    #10;

    WE = 1; d =  4'b0001;      // Enable write
    #10;                // q becomes 1
    reset = 0;             // Assert reset while WE is still active
    #10;                // SR should override WE, q becomes 0

    // End 
    #10;
    $finish;
  end

endmodule




module tb_mux2;
  reg I0,I1,S;
  wire O;
  
  mux_2  dut(
    .I0(I0),
    .I1(I1),
    .S(S),
    .O(O)
  );
  
  always #10 S = ~S;

  // 2. Stimulus Process
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_mux2);

    I0 =1;I1=0;S =0;   // Apply vector
 
    #50
    $finish;
  end

endmodule




module tb_adder;
  reg a,b,cin;
  wire out,cout;
  

  adder_1_bit dut(
    .a(a),
    .b(b),
    .cin(cin),
    .out(out),
    .cout(cout)
  );
  


  // 2. Stimulus Process
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_adder);

    a=0;b=0;cin=0;//0
    #10//
    a=0;b=0;cin=1;//10
    #10//
    a=0;b=1;cin=0;//20
    #10
    a=0;b=1;cin=1;//30
    #10
    a=1;b=0;cin=0;//40
    #10
    a=1;b=0;cin=1;//50
    #10
    a=1;b=1;cin=0;//60
    #10
    a=1;b=1;cin=1;///70
    #10

 
    #100
    $finish;
  end

endmodule




module tb_mux4;
  reg I0,I1,I2,I3;
  reg [1:0]S;
  wire O;
  
  mux_4  dut(
    .I0(I0),
    .I1(I1),
    .I2(I2),
    .I3(I3),
    .S(S),
    .O(O)
  );
  
  always #10 S = ~S; // others

  // 2. Stimulus Process
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_mux4);

    I0 =1;I1=0;I2 =1;I3=0;S = 0;   // Apply vector
 	#10
    I0 =1;I1=0;I2 =1;I3=0;S = 1;   // Apply vector
 	#10
    I0 =1;I1=0;I2 =1;I3=0;S = 2;   // Apply vector
 	#10
    I0 =1;I1=0;I2 =1;I3=0;S = 3;   // Apply vector
 	#10
    #10
    
    I0 =0;I1=1;I2 =0;I3=1;S = 0;   // Apply vector
 	#10
    I0 =0;I1=1;I2 =0;I3=1;S = 1;   // Apply vector
 	#10
    I0 =0;I1=1;I2 =0;I3=1;S = 2;   // Apply vector
 	#10
    I0 =0;I1=1;I2 =0;I3=1;S = 3;   // Apply vector
     	#10
    #10
    
    #150
    $finish;
  end

endmodule



module tb_demux();
    logic IN;
    logic [2:0]Select;
    logic O_0,O_1,O_2,O_3,O_4,O_5,O_6,O_7;
    
    demux_8to1 dut(
        .IN(IN),
        .Select(Select),
        .O_0(O_0),.O_1(O_1),.O_2(O_2),.O_3(O_3),.O_4(O_4),.O_5(O_5),.O_6(O_6),.O_7(O_7)
      );
    
    integer i;
    
    initial
        begin
            IN = 1; 
            for (i = 0; i < 8; i = i + 1) 
                begin
                    Select = i;  
                    #10;
                end
            #150
            $finish;
        end
endmodule




module tb_decoder;
  logic a,b,c,enable;
  logic O_0,O_1,O_2,O_3,O_4,O_5,O_6,O_7;
 
decoder_3_to_8 dut(
    .a(a),
    .b(b),
    .c(c),
    .enable(enable),
    .O_0(O_0),
    .O_1(O_1),
    .O_2(O_2),
    .O_3(O_3),
    .O_4(O_4),
    .O_5(O_5),
    .O_6(O_6),
    .O_7(O_7)
    );
                                                             

  // 2. Stimulus Process
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_decoder);
    
        enable = 1'b0;
        #10;
        
        enable = 1'b1;
        for (int i = 0; i < 8; i++) begin
            {a, b, c} = i;
            #10;
        end

        enable = 1'b0;
        {a, b, c} = 3'b000;
        #10;
        
        {a, b, c} = 3'b101;
        #10;
 
    #20
    $finish;
  end

endmodule




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
    logic clk;
    logic a,b,c,d,e,f, Data_in;
    logic cfg_write_en_0, cfg_write_en_1, cfg_write_en_2, cfg_write_en_3, cfg_write_en_4, cfg_write_en_5, cfg_write_en_6, cfg_write_en_7;
    logic Cin_lower_nibble, Cin_upper_nibble;
    logic [1:0]Carry_select_Int_0,Carry_select_Int_1;
    logic LowerNibble_negVal_sel, UpperNibble_negVal_sel;
    logic O_6, O_5;
    logic Sum_0, Sum_1, Cout_lower_nibble, Sum_2, Sum_3, Cout_upper_nibble; 
 
    LUT6 dut (.clk(clk), .d(d), .e(e), .f(f), .a(a), .b(b), .c(c), .Data_in(Data_in), 
              .cfg_write_en_0(cfg_write_en_0), .cfg_write_en_1(cfg_write_en_1), .cfg_write_en_2(cfg_write_en_2), .cfg_write_en_3(cfg_write_en_3), .cfg_write_en_4(cfg_write_en_4), .cfg_write_en_5(cfg_write_en_5), .cfg_write_en_6(cfg_write_en_6), .cfg_write_en_7(cfg_write_en_7), 
              .Cin_lower_nibble(Cin_lower_nibble), .Cin_upper_nibble(Cin_upper_nibble), .Carry_select_Int_0(Carry_select_Int_0), .Carry_select_Int_1(Carry_select_Int_1), .LowerNibble_negVal_sel(LowerNibble_negVal_sel), .UpperNibble_negVal_sel(UpperNibble_negVal_sel), 
              .O_6(O_6), .O_5(O_5), .Sum_0(Sum_0), .Sum_1(Sum_1), .Cout_lower_nibble(Cout_lower_nibble), .Sum_2(Sum_2), .Sum_3(Sum_3), .Cout_upper_nibble(Cout_upper_nibble));
              
              
    always #5 clk = ~clk;
    
    
    initial 
      begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_lut6);
        
        // initial condition
        clk = 1;
        cfg_write_en_0 = 0;  
        cfg_write_en_1 = 0;
        cfg_write_en_2 = 0;
        cfg_write_en_3 = 0;
        cfg_write_en_4 = 0;
        cfg_write_en_5 = 0;
        cfg_write_en_6 = 0;
        cfg_write_en_7 = 0;
        #10
        
        
        //config time
        cfg_write_en_0 = 1;  
        cfg_write_en_1 = 1;
        cfg_write_en_2 = 1;
        cfg_write_en_3 = 1;
          
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
        
        cfg_write_en_0 = 0;  
        cfg_write_en_1 = 0;
        cfg_write_en_2 = 0;
        cfg_write_en_3 = 0;
        #10
        cfg_write_en_4 = 1;
        cfg_write_en_5 = 1;
        cfg_write_en_6 = 1;
        cfg_write_en_7 = 1;
        
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
        cfg_write_en_4 = 0;
        cfg_write_en_5 = 0;
        cfg_write_en_6 = 0;
        cfg_write_en_7 = 0;
        

        
        //differentitaing time
        #50
        
                
        //normal ops  lut 6 and lut 5
        cfg_write_en_0 = 0;  
        cfg_write_en_1 = 0;
        cfg_write_en_2 = 0;
        cfg_write_en_3 = 0;
        cfg_write_en_4 = 0;
        cfg_write_en_5 = 0;
        cfg_write_en_6 = 0;
        cfg_write_en_7 = 0;
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
        cfg_write_en_0 = 1;  
        Data_in = 1;
        #10
        
        cfg_write_en_0 = 0;  
        cfg_write_en_1 = 1;  
        Data_in = 1;       
        #10
        
        cfg_write_en_1 = 0;  
        cfg_write_en_2 = 1;  
        Data_in = 0;
        #10
        
        cfg_write_en_2 = 0;  
        cfg_write_en_3 = 1;  
        Data_in = 1;
        #10
        cfg_write_en_3 = 0;  
        
        
        
        //differentitaing time
        #50
        
                
        //normal ops add and cin 0
        LowerNibble_negVal_sel = 0;
        Carry_select_Int_0 = 0;
        c=0; b=0; a=0;  
        
        
        //differentitaing time
        #50
        
        //normal ops add cin 1
        // sub and a distant adders
        LowerNibble_negVal_sel = 0;
        Carry_select_Int_0 = 3;
        c=0; b=0; a=0;  
        
        
        //differentitaing time
        #50
        
         // 2 adders with cin 0
         LowerNibble_negVal_sel = 0;
        Carry_select_Int_0 = 1;
        Cin_lower_nibble = 0;
        c=0; b=0; a=0;  
        
        
        //differentitaing time
        #50
        
        
         // 2 adders with cin 1
         LowerNibble_negVal_sel = 0;
        Carry_select_Int_0 = 2;
        Cin_lower_nibble = 1;
        c=0; b=0; a=0;  
        
        
           #50
        
         // 2 adders with cin 1
         LowerNibble_negVal_sel = 0;
        Carry_select_Int_0 = 2;
        Cin_lower_nibble = 1;
        c=0; b=0; a=0;  
      
      UpperNibble_negVal_sel = 0;
        Carry_select_Int_1 = 2;
        Cin_upper_nibble = 1;
        #10
        $display("Carry_select_Int_1 = %b", Carry_select_Int_1);
$display("Wire_Cout_LowerNibble = %b", dut.Wire_Cout_LowerNibble);
$display("Cin_upper_nibble = %b", dut.Cin_upper_nibble);
$display("Carry_UpperNibble_out = %b", dut.Carry_UpperNibble_out);

$display("Wire_UpperNibble_AddSub_Sel_val = %b", dut.Wire_UpperNibble_AddSub_Sel_val);
$display("Out_lut3_5 = %b", dut.Out_lut3_5);
$display("Carry_UpperNibble_out = %b", dut.Carry_UpperNibble_out);

$display("Sum_2 = %b", dut.Sum_2);


        
        
        
        //differentitaing time
        #50
        
        
        
        
        // sub
        Carry_select_Int_0 =2;
        LowerNibble_negVal_sel = 1;
        Cin_lower_nibble = 1;
        c=0; b=0; a=0;  
        
        
        
        //differentitaing time
        #50
        
        
        
        
       $finish; 
      end   
     
 endmodule
 
 
 
 
 module tb_adder_8bit;
 
 logic [7:0] a, b, Out;
 logic Cin,Cout;
 
 adder_8bit dut (.a(a), .b(b), .Cin(Cin), .Out(Out), .Cout(Cout));
 
 
 initial
    begin
     $dumpfile("dump.vcd");
     $dumpvars(0, tb_adder_8bit);
     
     
     
     a = 25; b = 15; Cin = 1;
     #10
     a = 23; b = 10; Cin = 0;
     #10
     a = 5; b = 30; Cin = 1;
     #10
     a = 8; b = 40; Cin = 1;
     #10
     a = 30; b = 34; Cin = 1;
     #10
     a = 10; b = ~5; Cin = 1; //5
     #10
     a = ~15; b = 30; Cin = 1; //15
     #10
     a = 30; b = ~34; Cin = 1; //-4
     #10
     
    
    $monitor("a= %d, b= %d, Cin=%d, Out= %d, Cout=%d", a,b,Cin,Out,Cout);
    
    $finish;
    
    end
    
 
 
 endmodule
 
 
 
 
 module tb_adder_16bit;
 
 logic [15:0] a, b, Out;
 logic Cin,Cout;
 
 adder_16bit dut (.a(a), .b(b), .Cin(Cin), .Out(Out), .Cout(Cout));
 
 
 initial
    begin
     $dumpfile("dump.vcd");
     $dumpvars(0, tb_adder_16bit);
     
     
     
     a = 125; b = 105; Cin = 1;
     #10
     a = 123; b = 100; Cin = 0;
     #10
     a = 5; b = 230; Cin = 1;
     #10
     a = 180; b = 140; Cin = 1;
     #10
     a = 130; b = 34; Cin = 1;
     #10
     a = 100; b = ~15; Cin = 1; //85
     #10
     a = ~150; b = 30; Cin = 1; //-120
     #10
     a = 300; b = ~34; Cin = 1; //256
     #10
     
    
    $monitor("a= %d, b= %d, Cin=%d, Out= %d, Cout=%d", a,b,Cin,Out,Cout);
    
    $finish;
    
    end
    
 
 
 endmodule
 
 
 
 
 module tb_and_16bit;
 
 logic [15:0] a,b,c;
 int i;
 
 AND_16bit dut(.a(a),.b(b),.c(c));
 
 initial
    begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_and_16bit);
        
        
        for(i = 0; i< 5; i++)
            begin
                a = $random;
                b = $random;
                #10;
            end
        
        $finish;
     
    end 
 endmodule
 
 
 
 
 module tb_OR_16bits;
 
    logic [15:0] a,b,c;
    integer i;
    
    OR_16bit dut(.a(a),.b(b),.c(c));
     
    initial 
        begin
            $dumpfile("dump.vcd");
            $dumpvars(0, tb_OR_16bits);
            
            for(i = 0; i< 5; i++)
                begin
                    a = $random;
                    b = $random;
                    #10;
                end
            
            $finish;   
        end
 
 endmodule
 
 
 
 
  module tb_Not_16bits;
 
    logic [15:0] a,c;
    integer i;
    
    NOT_16bit dut(.a(a),.c(c));
     
    initial 
        begin
            $dumpfile("dump.vcd");
            $dumpvars(0, tb_Not_16bits);
            
            for(i = 0; i< 5; i++)
                begin
                    a = $random;
                    #10;
                end
            
            $finish;   
        end
 
 endmodule