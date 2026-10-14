`timescale 1ns / 1ps
`define Width 4

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2026 01:20:34 PM
// Design Name: 
// Module Name: tb_elements
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
  reg SR;
  reg [`Width-1:0] d;
  wire [`Width -1:0] q;

  DFF #(`Width) dut(
    .clk(clk),
    .WE(WE),
    .SR(SR),
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
    $monitor("Time=%0t | clk=%b SR=%b WE=%b d=%b -> q=%b", 
             $time, clk, SR, WE, d, q);

    clk = 0;
    WE  = 0;
    SR  = 0;
    d   = 0;

    #10;
    SR = 1; d = 4'b0001;      // Force reset active with d=1 to verify SR priority
    #10;
    SR = 0;             // Release reset

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
    SR = 1;             // Assert reset while WE is still active
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



 
    #120
    $finish;
  end

endmodule