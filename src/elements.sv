`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: MJA Baig
// 
// Create Date: 10/13/2026 10:41:44 AM
// Design Name: 
// Module Name: Basic Blocks
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


//D latch
module DLatch#(
	parameter WIDTH = 1
)(
   input logic [WIDTH-1:0]d,
   input logic enable,
   output logic [WIDTH-1:0]q
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
  (clk,WE,reset, d,q);
  input wire clk,WE,reset;
  input wire [WIDTH-1:0] d;
  output reg [WIDTH-1:0] q;
  
//  always@(posedge clk) 
//    begin
//      q <= (SR == 1'b1)? {WIDTH{1'b0}}  :   // if reset 
//     	   (WE == 1'b1)? d     :  q ;   //if WE take d otherwise keep q
      
//    end 
    
    always_ff@(posedge clk or negedge reset)
        begin
            q <= (reset == 0)  ? {WIDTH{1'b0}} :  
                 (clk & WE)    ? d             :
                                 q             ;   
        end
  endmodule
  
  
  
  
  //DFF_without WE
module DFF_noWE #(
	parameter WIDTH = 1
)
  (clk,reset, d,q);
  input wire clk,reset;
  input wire [WIDTH-1:0] d;
  output reg [WIDTH-1:0] q;

    always_ff@(posedge clk or negedge reset)
        begin
            q <= (reset == 0)  ? {WIDTH{1'b0}} :  
                 (clk )    ? d             :
                             q             ;   
        end
  endmodule




//2:1 mux 
module mux_2 (I0,I1,S,O);
  input wire I0,I1;
  input wire S;
  output reg O;
    
    assign O = (S == 0)? I0 : I1;

 endmodule




//4:1 mux 
module mux_4 (I0,I1,I2,I3,S,O);
  input wire I0,I1,I3,I2;
  input wire [1:0]S;
  output wire O;
  
      assign O = (S == 3)? I3 : 
                 (S == 2)? I2 : 
                 (S == 1)? I1 : 
                           I0 ;  
 endmodule




//8:1 mux 
module mux_8 (I0,I1,I2,I3,I4,I5,I6,I7,S,O);
  input wire I0,I1,I2,I3,I4,I5,I6,I7;
  input wire [2:0]S;
  output wire O;
  
      assign O = (S == 7)? I7 : 
                 (S == 6)? I6 : 
                 (S == 5)? I5 : 
                 (S == 4)? I4 :
                 (S == 3)? I3 : 
                 (S == 2)? I2 : 
                 (S == 1)? I1 : 
                           I0 ;  
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
nand (nand_out_0,NOTc,NOTb,NOTa);  //000
nand (nand_out_1,NOTc,NOTb,a); //001
nand (nand_out_2,NOTc,b,NOTa);//010
nand (nand_out_3,NOTc,b,a);//011
nand (nand_out_4,c,NOTb,NOTa);//100
nand (nand_out_5,c,NOTb,a);//101
nand (nand_out_6,c,b,NOTa);//110
nand (nand_out_7,c,b,a);//111

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




//16bit adder
module adder_16bit(a, b, Cin, Out, Cout);
    
    input logic [15:0] a,b;
    input logic Cin;
    output logic [15:0] Out;
    output logic Cout;
    
    logic Int_Cout_0, Int_Cout_1, Int_Cout_2, Int_Cout_3, Int_Cout_4, Int_Cout_5, Int_Cout_6, Int_Cout_7;
    logic Int_Cout_8, Int_Cout_9, Int_Cout_10, Int_Cout_11, Int_Cout_12, Int_Cout_13, Int_Cout_14, Int_Cout_15, Int_Cout_16;


    adder_1_bit adder0(.a(a[0]), .b(b[0]), .cin(Cin), .out(Out[0]), .cout(Int_Cout_0));
    adder_1_bit adder1(.a(a[1]), .b(b[1]), .cin(Int_Cout_0), .out(Out[1]), .cout(Int_Cout_1));
    adder_1_bit adder2(.a(a[2]), .b(b[2]), .cin(Int_Cout_1), .out(Out[2]), .cout(Int_Cout_2));
    adder_1_bit adder3(.a(a[3]), .b(b[3]), .cin(Int_Cout_2), .out(Out[3]), .cout(Int_Cout_3));
    adder_1_bit adder4(.a(a[4]), .b(b[4]), .cin(Int_Cout_3), .out(Out[4]), .cout(Int_Cout_4));
    adder_1_bit adder5(.a(a[5]), .b(b[5]), .cin(Int_Cout_4), .out(Out[5]), .cout(Int_Cout_5));
    adder_1_bit adder6(.a(a[6]), .b(b[6]), .cin(Int_Cout_5), .out(Out[6]), .cout(Int_Cout_6));
    adder_1_bit adder7(.a(a[7]), .b(b[7]), .cin(Int_Cout_6), .out(Out[7]), .cout(Int_Cout_7));
    adder_1_bit adder8(.a(a[8]), .b(b[8]), .cin(Int_Cout_7), .out(Out[8]), .cout(Int_Cout_8));
    adder_1_bit adder9(.a(a[9]), .b(b[9]), .cin(Int_Cout_8), .out(Out[9]), .cout(Int_Cout_9));
    adder_1_bit adder10(.a(a[10]), .b(b[10]), .cin(Int_Cout_9), .out(Out[10]), .cout(Int_Cout_10));
    adder_1_bit adder11(.a(a[11]), .b(b[11]), .cin(Int_Cout_10), .out(Out[11]), .cout(Int_Cout_11));
    adder_1_bit adder12(.a(a[12]), .b(b[12]), .cin(Int_Cout_11), .out(Out[12]), .cout(Int_Cout_12));
    adder_1_bit adder13(.a(a[13]), .b(b[13]), .cin(Int_Cout_12), .out(Out[13]), .cout(Int_Cout_13));
    adder_1_bit adder14(.a(a[14]), .b(b[14]), .cin(Int_Cout_13), .out(Out[14]), .cout(Int_Cout_14));
  //  adder_1_bit adder15(.a(a[15]), .b(b[15]), .cin(Int_Cout_14), .out(Out[15]), .cout(Int_Cout_15));
    adder_1_bit adder15(.a(a[15]), .b(b[15]), .cin(Int_Cout_14), .out(Out[15]), .cout(Cout));
    
     
endmodule




//8bit Add
module adder_8bit(a, b, Cin, Out, Cout);
    
    input logic [7:0] a,b;
    input logic Cin;
    output logic [7:0] Out;
    output logic Cout;
    
    logic Int_Cout_0, Int_Cout_1, Int_Cout_2, Int_Cout_3, Int_Cout_4, Int_Cout_5, Int_Cout_6, Int_Cout_7, Int_Cout_8;


    adder_1_bit adder0(.a(a[0]), .b(b[0]), .cin(Cin), .out(Out[0]), .cout(Int_Cout_0));
    adder_1_bit adder1(.a(a[1]), .b(b[1]), .cin(Int_Cout_0), .out(Out[1]), .cout(Int_Cout_1));
    adder_1_bit adder2(.a(a[2]), .b(b[2]), .cin(Int_Cout_1), .out(Out[2]), .cout(Int_Cout_2));
    adder_1_bit adder3(.a(a[3]), .b(b[3]), .cin(Int_Cout_2), .out(Out[3]), .cout(Int_Cout_3));
    adder_1_bit adder4(.a(a[4]), .b(b[4]), .cin(Int_Cout_3), .out(Out[4]), .cout(Int_Cout_4));
    adder_1_bit adder5(.a(a[5]), .b(b[5]), .cin(Int_Cout_4), .out(Out[5]), .cout(Int_Cout_5));
    adder_1_bit adder6(.a(a[6]), .b(b[6]), .cin(Int_Cout_5), .out(Out[6]), .cout(Int_Cout_6));
    adder_1_bit adder7(.a(a[7]), .b(b[7]), .cin(Int_Cout_6), .out(Out[7]), .cout(Cout));
   // adder_1_bit adder8(.a(a[8]), .b(b[8]), .cin(Int_Cout_7), .out(Out[8]), .cout(Cout));
    
     
endmodule




//16 bit bitwise And
module AND_16bit(a,b,c);
    
    input logic [15:0] a,b;
    output logic [15:0] c;
    
    and and0(c[0], a[0], b[0]);
    and and1(c[1], a[1], b[1]);
    and and2(c[2], a[2], b[2]);
    and and3(c[3], a[3], b[3]);
    and and4(c[4], a[4], b[4]);
    and and5(c[5], a[5], b[5]);
    and and6(c[6], a[6], b[6]);
    and and7(c[7], a[7], b[7]);
    and and8(c[8], a[8], b[8]);
    and and9(c[9], a[9], b[9]);
    and and10(c[10], a[10], b[10]);
    and and11(c[11], a[11], b[11]);
    and and12(c[12], a[12], b[12]);
    and and13(c[13], a[13], b[13]);
    and and14(c[14], a[14], b[14]);
    and and15(c[15], a[15], b[15]);
//    and and16(c[16], a[16], b[16]);
        
endmodule




//16 bit or
module OR_16bit(c,a,b);

    input logic [15:0] a,b;
    output logic [15:0]c;
    
    genvar i;
    
    generate
        for (i =0; i<=15; i++)
            begin : OrGates
                or OrGate(c[i],a[i],b[i]);
            end 
    endgenerate;
    
endmodule




//16 bit not
module NOT_16bit(c,a);

    input logic [15:0] a;
    output logic [15:0] c;
    
    genvar i;
    
    generate 
        for(i=0; i<=15; i++)
            begin : NotGates
                not NotGate(c[i], a[i]);    
            end
    endgenerate;
    
endmodule




//8 bit not
module NOT_8bit(c,a);

    input logic [7:0] a;
    output logic [7:0] c;
    
    genvar i;
    
    generate 
        for(i=0; i<=7; i++)
            begin : NotGates
                not NotGate(c[i], a[i]);    
            end
    endgenerate;
endmodule



//and 4 primitive
module AND4(Z, A, B, C, D);

    input logic A,B,C,D;
    output logic Z;
    
    always_comb
        Z = A & B & C & D;
        
endmodule



//nor 2 primitive
module NOR2(Z, A, B );

    input logic A,B;
    output logic Z;
    
    always_comb
        Z = ~(A | B );      
endmodule




//nor 4 primitive
module NOR4(Z, A, B, C, D);

    input logic A,B,C,D;
    output logic Z;
    
    always_comb
        Z = ~(A | B | C | D);
        
endmodule




//16 bit 8 input mux
module Mux8_16bit(O, A, B, C, D, E, F, G, H, S);
    
    input logic [15:0] A,B,C,D,E,F,G,H;
    input logic [2:0] S;
    output logic [15:0] O;
    
    //wire
    logic [15:0] upper_mux_out, lower_mux_out;
    

    genvar i;
    
    generate
        for(i = 0; i<=15; i++)
            begin: dspMux
                mux_4 upper_mux(.I0(A[i]), .I1(B[i]), .I2(C[i]), .I3(D[i]), .S(S[1:0]), .O(lower_mux_out[i]));
                mux_4 lower_mux(.I0(E[i]), .I1(F[i]), .I2(G[i]), .I3(H[i]), .S(S[1:0]), .O(upper_mux_out[i]));
                
                mux_2 outer_mux(.I0(lower_mux_out[i]), .I1(upper_mux_out[i]), .S(S[2]) , .O(O[i]));            
            end   
    endgenerate
endmodule




//3 bit 2 input mux
module mux2_3bit(A,B,S,O);
  
  input logic [2:0] A,B;
  input logic S;
  output logic [2:0] O;
   
    genvar i;
    
    generate
        for(i = 0; i<=2; i++)
            begin: bit3_mux
                 mux_2 mux2_8bit(.I0(A[i]), .I1(B[i]), .S(S), .O(O[i]));
            end
    endgenerate
 endmodule




//8 bit 2 input mux
module mux2_8bit(A,B,S,O);
  
  input logic [7:0] A,B;
  input logic S;
  output logic [7:0] O;
   
    genvar i;
    
    generate
        for(i = 0; i<=7; i++)
            begin: bit8_mux
                 mux_2 mux2_8bit(.I0(A[i]), .I1(B[i]), .S(S), .O(O[i]));
                 
            end
    endgenerate

 endmodule
 
 
 //8 bit 2 input mux
module mux2_Parameterizedbit#(parameter WIDTH = 1)
(
  input logic [WIDTH-1:0] A,B,
  input logic S,
  output logic [WIDTH-1:0] O
);
  
    genvar i;
    
    generate
        for(i = 0; i<=WIDTH-1; i++)
            begin: bitparameteized_mux
                 mux_2 mux2_8bit(.I0(A[i]), .I1(B[i]), .S(S), .O(O[i]));
            end
    endgenerate

 endmodule



 
//8 bit 2 input mux
module mux2_9bit(A,B,S,O);
  
  input logic [8:0] A,B;
  input logic S;
  output logic [8:0] O;
   
    genvar i;
    
    generate
        for(i = 0; i<=8; i++)
            begin: bit9_mux
                 mux_2 mux2_8bit(.I0(A[i]), .I1(B[i]), .S(S), .O(O[i]));
                 
            end
    endgenerate

 endmodule 
 
 
 
 
//16 bit 2 input mux
module mux2_16bit(A,B,S,O);
  
  input logic [15:0] A,B;
  input logic S;
  output logic [15:0] O;
   
    genvar i;
    
    generate
        for(i = 0; i<=15; i++)
            begin: bit16_mux
                 mux_2 mux2_8bit(.I0(A[i]), .I1(B[i]), .S(S), .O(O[i]));
            end
    endgenerate

 endmodule
 
 
 
 
 //4:1 mux 
module mux4_16bit (I0,I1,I2,I3,S,O);
  input logic [15:0] I0,I1,I3,I2;
  input wire [1:0]S;
  output logic [15:0]O;
  
  genvar i;
  
   generate
        for(i = 0; i<=15; i++)
            begin: bit16_mux4
                 mux_4 mux4_16bit(.I0(I0[i]), .I1(I1[i]), .I2(I2[i]), .I3(I3[i]), .S(S), .O(O[i]));
            end
    endgenerate

 endmodule


 
 
 
 
 // 8 bit multiplier
 module multiplier_8bit (
    input  logic [7:0] A,
    input  logic [7:0] B,
 //   input  logic SignedMode,
    output logic [15:0] Out
);

    //always_comb begin
    //    if (SignedMode)
    //        Out = $signed(A) * $signed(B);
    //    else
         assign   Out = A * B;
    //end

endmodule