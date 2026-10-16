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




//lut3
module LUT3(a,b,c,clk, Data_in,cfg_write_en, Out);

	input logic a,b,c;
  	input logic clk,cfg_write_en;
	input logic Data_in;
    //input logic [3-1 : 0] Select_in;// config time address handelde by abc
	output logic Out;
  
    // interemediate wires
    // A MSB and C LSB
    logic clock_gated_enable;
    logic [7:0] decoder_to_mem, dlatch_out;
    
    logic output_mux_c_01, output_mux_c_23,output_mux_c_45, output_mux_c_67;
    logic output_mux_b_03, output_mux_b_47;
    logic output_mux_a_07;
    
    //1. clock gateing the enable for decoder
    // so it acts as a clocked input for dram
    // we do not need a dff, just a and gate would do
        and clocking_gate(clock_gated_enable, cfg_write_en, clk );
    
    //2. decoder
        decoder_3_to_8 lut3_decoder(.a(a),.b(b),.c(c),.enable(clock_gated_enable),.O_0(decoder_to_mem[0]), .O_1(decoder_to_mem[1]), .O_2(decoder_to_mem[2]), .O_3(decoder_to_mem[3]), .O_4(decoder_to_mem[4]), .O_5(decoder_to_mem[5]), .O_6(decoder_to_mem[6]), .O_7(decoder_to_mem[7]));

    //3. mem_locations
        for (genvar i = 0; i <= 7; i++) begin : gen_Lut3_mem_locations
               DLatch lut3_module( .d(Data_in), .enable(decoder_to_mem[i]),.q(dlatch_out[i]) );
            end
                 
    //4. a
        mux_2 mux_select_c_0(.I0(dlatch_out[0]), .I1(dlatch_out[1]), .S(c), .O(output_mux_c_01));
        mux_2 mux_select_c_1(.I0(dlatch_out[2]), .I1(dlatch_out[3]), .S(c), .O(output_mux_c_23));
        mux_2 mux_select_c_2(.I0(dlatch_out[4]), .I1(dlatch_out[5]), .S(c), .O(output_mux_c_45));
        mux_2 mux_select_c_3(.I0(dlatch_out[6]), .I1(dlatch_out[7]), .S(c), .O(output_mux_c_67));
    
    //5. b
        mux_2 mux_select_b_0(.I0(output_mux_c_01), .I1(output_mux_c_23), .S(b), .O(output_mux_b_03));
        mux_2 mux_select_b_1(.I0(output_mux_c_45), .I1(output_mux_c_67), .S(b), .O(output_mux_b_47));
        
    //6. c
         mux_2 mux_select_a_0(.I0(output_mux_b_03), .I1(output_mux_b_47), .S(a), .O(output_mux_a_07));
         
    //7. output
        assign Out = output_mux_a_07;
  
  
  endmodule
  
  
  
  
  