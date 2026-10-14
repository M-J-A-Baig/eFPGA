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




//decoder
module decoder_3_to_8(a,b,c,enable,O_0,O_1,O_2,O_3,O_4,O_5,O_6,O_7);

input logic a,b,c; 
input logic enable;
output logic O_0,O_1,O_2,O_3,O_4,O_5,O_6,O_7;


//wires
logic NOTa, NOTb, NOTc;
logic nand_out_0 , nand_out_1, nand_out_2, nand_out_3, nand_out_4, nand_out_5, nand_out_6, nand_out7;

        
    
//stage 1
not (NOTa, a);
not (NOTb, b);
not (NOTc, c);
not (NOTenable, enable);



//stage 2
nand (nand_out_0,NOTa,NOTb,NOTc);  //000
nand (nand_out_1,NOTa,NOTb,c); //001
nand (nand_out_2,NOTa,b,NOTc);//010
nand (nand_out_3,NOTa,b,c);//011
nand (nand_out_4,a,NOTb,NOTc);//100
nand (nand_out_5,a,NOTb,c);//101
nand (nand_out_6,a,b,NOTc);//110
nand (nand_out_7,a,b,c);//111

//stage 3
nor (O_0, nand_out_0, NOTenable);
nor (O_1, nand_out_1, NOTenable);
nor (O_2, nand_out_2, NOTenable);
nor (O_3, nand_out_3, NOTenable);
nor (O_4, nand_out_4, NOTenable);
nor (O_5, nand_out_5, NOTenable);
nor (O_6, nand_out_6, NOTenable);
nor (O_7, nand_out_7, NOTenable);


endmodule


















////lut3
//module LUT(a,b,c,clk, Data_in,cfg_write_en, Select_in, Out);

//	input logic a,b,c;
//  	input logic clk,cfg_write_en;
//	input logic Data_in;
//    input logic [3-1 : 0] Select_in;// config time address
//	output logic Out;
  
//    // interemediate wires
//    logic dff_to_demux;
//    logic demux_to_mem_0, demux_to_mem_1, demux_to_mem_2, demux_to_mem_3, demux_to_mem_4, demux_to_mem_5, demux_to_mem_6, demux_to_mem_7;
//    logic dlatch_out_0, dlatch_out_1, dlatch_out_2, dlatch_out_3, dlatch_out_4, dlatch_out_5, dlatch_out_6, dlatch_out_7;
    
    
//    //1. dff
//  //      lut3_dff DFF(.clk(clk),.WE(cfg_write_en),.SR(1'b0), .d(Data_in),.q(dff_to_demux));
    
//    //2. demux
//        lut3_demux demux_8to1(.IN(Data_in),.Select(Select_in),.O_0(demux_to_mem_0),.O_1(demux_to_mem_1),.O_2(demux_to_mem_2),.O_3(demux_to_mem_3),.O_4(demux_to_mem_4),.O_5(demux_to_mem_5),.O_6(demux_to_mem_6),.O_7(demux_to_mem_7)); 
        
//    //3. mem_locations
//        for (genvar i = 0; i <= 7; i++) begin : gen_Lut3_mem_locations
//            lut3_module DLatch( .d(demux_to_mem_i), .enable(),.q(dlatch_out_i) );
        
//        for 
    
//    //4. a
    
//    //5. b
    
//    //6. c
  
  
  
//  endmodule