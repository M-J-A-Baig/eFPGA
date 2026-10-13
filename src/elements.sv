`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2026 10:41:44 AM
// Design Name: 
// Module Name: DLatch
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

//D latch
module DLatch(
   input logic d,
   input logic enable,
   output logic q
    );
    
    always_latch
        begin 
           if (enable) q <= d ;
        end
endmodule



//DFF
module DFF #(
	parameter WIDTH = 1
)
  (clk,WE,SR, d,q);
  input wire clk,WE,SR;
  input wire [WIDTH-1:0] d;
  output reg [WIDTH-1:0] q;
  
  always@(posedge clk) 
    begin
      q <= (SR == 1'b1)? {WIDTH{1'b0}}  :   // if reset 
     	   (WE == 1'b1)? d     :  q ;   //if WE take d otherwise keep q
      
    end 
  
  endmodule






//2:1 mux 
module mux_2 (I0,I1,S,O);
  input wire I0,I1;
  input wire S;
  output wire O;
  
    assign O = (S == 0)? I0 : I1;
  
 endmodule






//4:1 mux 
module mux_4 (I0,I1,I2,I3,S,O);
  input wire I0,I1,I3,I2;
  input wire [1:0]S;
  output wire O;
  
      assign O = (S == 0)? I0 : 
                 (S == 1)? I1 : 
                 (S == 2)? I2 : 
                           I3 ;  
 endmodule







//adder
module adder_1_bit(a,b,cin,out,cout);
  
  input wire a,b,cin;
  output wire cout,out;
  
  wire a_xor_b, a_and_b;
  wire stage_2_and_out;
  
      //stage 1 - half adder
      xor gate_xor_stage_1(a_xor_b,a,b);
      and gate_and_stage_1(a_and_b,a,b);
      
      //stage 2 - full adder
      xor gate_xor_stage_2(out,a_xor_b,cin);
      and gate_and_stage_2(stage_2_and_out,a_xor_b,cin); 
      
      //stage 3 - carry out
      or gate_or_stage3(cout,stage_2_and_out,a_and_b );
  
  
endmodule






//demux 
module demux_8to1(IN,Select,O_0,O_1,O_2,O_3,O_4,O_5,O_6,O_7 );
    input logic IN;
    input logic [2:0]Select;
    output logic O_0,O_1,O_2,O_3,O_4,O_5,O_6,O_7;
   
    
   always_comb
    begin
        O_0  = 1'b0; O_1  = 1'b0; O_2  = 1'b0; O_3  = 1'b0;O_4  = 1'b0; O_5  = 1'b0; O_6  = 1'b0; O_7 = 1'b0;
        case(Select)
            3'b000 : O_0 = IN;
            3'b001 : O_1 = IN;
            3'b010 : O_2 = IN;
            3'b011 : O_3 = IN;
            3'b100 : O_4 = IN;
            3'b101 : O_5 = IN;
            3'b110 : O_6 = IN;
            3'b111 : O_7 = IN; 
         endcase    
    end
endmodule