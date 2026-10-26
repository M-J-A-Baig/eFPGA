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
                 (clk & WE)  ? d             :
                                 q             ;   
        
        end
  
  endmodule




//2:1 mux 
module mux_2 (I0,I1,S,O);
  input wire I0,I1;
  input wire S;
  output reg O;
  
  
    assign O = (S == 0)? I0 : I1;
//    always_comb begin
//        case (S)
//            1'b1:   O = I1;
//            default: O = I0;
//        endcase
//end
  
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
    logic output_mux_a_01, output_mux_a_23,output_mux_a_45, output_mux_a_67;
    logic output_mux_b_03, output_mux_b_47;
    logic output_mux_c_07;
    
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
                
    //4. c
        mux_2 mux_select_a_0(.I0(dlatch_out[0]), .I1(dlatch_out[1]), .S(a), .O(output_mux_a_01));
        mux_2 mux_select_a_1(.I0(dlatch_out[2]), .I1(dlatch_out[3]), .S(a), .O(output_mux_a_23));
        mux_2 mux_select_a_2(.I0(dlatch_out[4]), .I1(dlatch_out[5]), .S(a), .O(output_mux_a_45));
        mux_2 mux_select_a_3(.I0(dlatch_out[6]), .I1(dlatch_out[7]), .S(a), .O(output_mux_a_67));
    
    //5. b
        mux_2 mux_select_b_0(.I0(output_mux_a_01), .I1(output_mux_a_23), .S(b), .O(output_mux_b_03));
        mux_2 mux_select_b_1(.I0(output_mux_a_45), .I1(output_mux_a_67), .S(b), .O(output_mux_b_47));
        
    //6. a
         mux_2 mux_select_c_0(.I0(output_mux_b_03), .I1(output_mux_b_47), .S(c), .O(output_mux_c_07));
         
    //7. output
        assign Out = output_mux_c_07;
  
  
  endmodule
  
  
  
 
//lut6
// same selectors for a nibble
//module LUT6(clk,d,e,f, a_lower_nibble, b_lower_nibble, c_lower_nibble, Data_in__lower_nibble, Data_in__upper_nibble, a_upper_nibble, b_upper_nibble, c_upper_nibble, cfg_write_en_0, cfg_write_en_1, cfg_write_en_2, cfg_write_en_3, cfg_write_en_4, cfg_write_en_5, cfg_write_en_6, cfg_write_en_7, Cin_lower_nibble, Cin_upper_nibble, Carry_select_Int_0,Carry_select_Int_1, LowerNibble_negVal_sel, UpperNibble_negVal_sel, O_6, O_5, Sum_0, Sum_1, Cout_lower_nibble, Sum_2, Sum_3, Cout_upper_nibble);

//    input logic clk;
//    input logic d,e,f;
//    input logic a_lower_nibble, b_lower_nibble, c_lower_nibble,Data_in__lower_nibble;
//    input logic a_upper_nibble, b_upper_nibble, c_upper_nibble, Data_in__upper_nibble;
//    input logic cfg_write_en_0, cfg_write_en_1, cfg_write_en_2, cfg_write_en_3, cfg_write_en_4, cfg_write_en_5, cfg_write_en_6, cfg_write_en_7;
//    input logic Cin_lower_nibble, Cin_upper_nibble;
//    input logic LowerNibble_negVal_sel, UpperNibble_negVal_sel;
//    input logic [1:0]Carry_select_Int_0,Carry_select_Int_1;
//    output logic O_6, O_5;
//    output logic Sum_0, Sum_1, Cout_lower_nibble, Sum_2, Sum_3, Cout_upper_nibble; 
    
//    //abc with a msb and c lsb
    
    
//    //connecting wires
//    logic Carry_LowerNibble_out, Carry_UpperNibble_out;
//    logic Wire_LowerNibble_AddSub_Sel_val, Wire_UpperNibble_AddSub_Sel_val;
//    logic Out_lut3_0 , Out_lut3_1, Out_lut3_2, Out_lut3_3, Out_lut3_4, Out_lut3_5, Out_lut3_6, Out_lut3_7;
//    logic Not_Out_lut3_0, Not_Out_lut3_4;
//    logic CarryBetweenAdder_Lut3_01_and_Lut3_23,CarryBetweenAdder_Lut3_45_and_Lut3_67;
//    logic Wire_Cout_LowerNibble,Wire_Cout_UpperNibble;
//    logic Out_mux4_01, Out_mux4_23, Out_mux4_45, Out_mux4_67;
//    logic Out_mux5_03, Out_mux5_47;
    
    
//    //0. clock buffers
    
    
//    //stage 0
//    //1. input carry lower nibble
//        mux_4 lower_carry_selector(.I0(1'b0),.I1(Cin_lower_nibble),.I2(Cin_lower_nibble),.I3(1'b1),.S(Carry_select_Int_0),.O(Carry_LowerNibble_out));
        
//    //2. lower nibble lut3s
//        LUT3  lut3_0(.a(a_lower_nibble),.b(b_lower_nibble),.c(c_lower_nibble),.clk(clk), .Data_in(Data_in__lower_nibble),.cfg_write_en(cfg_write_en_0), .Out(Out_lut3_0));
//        LUT3  lut3_1(.a(a_lower_nibble),.b(b_lower_nibble),.c(c_lower_nibble),.clk(clk), .Data_in(Data_in__lower_nibble),.cfg_write_en(cfg_write_en_1), .Out(Out_lut3_1)); 
//        LUT3  lut3_2(.a(a_lower_nibble),.b(b_lower_nibble),.c(c_lower_nibble),.clk(clk), .Data_in(Data_in__lower_nibble),.cfg_write_en(cfg_write_en_2), .Out(Out_lut3_2)); 
//        LUT3  lut3_3(.a(a_lower_nibble),.b(b_lower_nibble),.c(c_lower_nibble),.clk(clk), .Data_in(Data_in__lower_nibble),.cfg_write_en(cfg_write_en_3), .Out(Out_lut3_3)); 
              
        
//    //3. Lower nibble adders
//    // negative term in lower lut3, because addition with 2s compliment because limiting not gate 
      
//         not two_comp_lowerNible(Not_Out_lut3_0,Out_lut3_0);
//         mux_2 diff_bw_add_sub_LowerNibble(.I0(Out_lut3_0),.I1(Not_Out_lut3_0), .S(LowerNibble_negVal_sel),.O(Wire_LowerNibble_AddSub_Sel_val));
//         adder_1_bit lut3_01(.a(Wire_LowerNibble_AddSub_Sel_val),.b(Out_lut3_1),.cin(Carry_LowerNibble_out),.out(Sum_0),.cout(CarryBetweenAdder_Lut3_01_and_Lut3_23));
//         adder_1_bit lut3_23(.a(Out_lut3_2),.b(Out_lut3_3),.cin(CarryBetweenAdder_Lut3_01_and_Lut3_23),.out(Sum_1),.cout(Wire_Cout_LowerNibble));
        
//    //4. input carry upper nibble
//        mux_4 Upper_carry_selector(.I0(1'b0),.I1(Cin_upper_nibble),.I2(Wire_Cout_LowerNibble),.I3(1'b1),.S(Carry_select_Int_1),.O(Carry_UpperNibble_out));
        
//    //5. upper nibble lut3s
//        LUT3  lut3_4(.a(a_upper_nibble),.b(b_upper_nibble),.c(c_upper_nibble),.clk(clk), .Data_in(Data_in__upper_nibble),.cfg_write_en(cfg_write_en_4), .Out(Out_lut3_4));
//        LUT3  lut3_5(.a(a_upper_nibble),.b(b_upper_nibble),.c(c_upper_nibble),.clk(clk), .Data_in(Data_in__upper_nibble),.cfg_write_en(cfg_write_en_5), .Out(Out_lut3_5)); 
//        LUT3  lut3_6(.a(a_upper_nibble),.b(b_upper_nibble),.c(c_upper_nibble),.clk(clk), .Data_in(Data_in__upper_nibble),.cfg_write_en(cfg_write_en_6), .Out(Out_lut3_6)); 
//        LUT3  lut3_7(.a(a_upper_nibble),.b(b_upper_nibble),.c(c_upper_nibble),.clk(clk), .Data_in(Data_in__upper_nibble),.cfg_write_en(cfg_write_en_7), .Out(Out_lut3_7)); 
              
//    //6. Upper nibble adders
//    // negative term in lower lut3, because addition with 2s compliment because limiting not gate   
//        not two_comp_upperNible(Not_Out_lut3_4,Out_lut3_4);
//        mux_2 diff_bw_add_sub_UpperNibble(.I0(Out_lut3_4), .I1(Not_Out_lut3_4), .S(UpperNibble_negVal_sel),.O(Wire_UpperNibble_AddSub_Sel_val));
//        adder_1_bit lut3_45(.a(Wire_UpperNibble_AddSub_Sel_val),.b(Out_lut3_5),.cin(Carry_upperNibble_out),.out(Sum_3),.cout(CarryBetweenAdder_Lut3_45_and_Lut3_67));
//        adder_1_bit lut3_67(.a(Out_lut3_6),.b(Out_lut3_7),.cin(CarryBetweenAdder_Lut3_45_and_Lut3_67),.out(Sum_4),.cout(Wire_Cout_UpperNibble));
         
         
         
         
//    //stage 2
//    //7. d selectors/muxes
//        mux_2 dSelector_lut4_01(.I0(Out_lut3_0),.I1(Out_lut3_1),.S(d),.O(Out_mux4_01));
//        mux_2 dSelector_lut4_23(.I0(Out_lut3_2),.I1(Out_lut3_3),.S(d),.O(Out_mux4_23));
//        mux_2 dSelector_lut4_45(.I0(Out_lut3_4),.I1(Out_lut3_5),.S(d),.O(Out_mux4_45));
//        mux_2 dSelector_lut4_67(.I0(Out_lut3_6),.I1(Out_lut3_6),.S(d),.O(Out_mux4_67));
        
//    //8. e selector/muxes 
//         mux_2 dSelector_lut5_03(.I0(Out_mux4_01),.I1(Out_mux4_23),.S(e),.O(Out_mux5_03));
//         mux_2 dSelector_lut5_47(.I0(Out_mux4_45),.I1(Out_mux4_67),.S(e),.O(Out_mux5_47));
         
//    //9. f selector/muxes
//         mux_2 dSelector_lut6(.I0(Out_mux5_03),.I1(Out_mux5_47),.S(f),.O(O_6)); 
         
         
         
//    // assign ports
//        assign   Cout_lower_nibble = Wire_Cout_LowerNibble;
//        assign   Cout_upper_nibble = Wire_Cout_UpperNibble;
//        assign   O_5 = Out_mux5_03;
        
//endmodule  

module LUT6(clk,a,b,c,d,e,f, Data_in, cfg_write_en_0, cfg_write_en_1, cfg_write_en_2, cfg_write_en_3, cfg_write_en_4, cfg_write_en_5, cfg_write_en_6, cfg_write_en_7, Cin_lower_nibble, Cin_upper_nibble, Carry_select_Int_0,Carry_select_Int_1, LowerNibble_negVal_sel, UpperNibble_negVal_sel, O_6, O_5, Sum_0, Sum_1, Cout_lower_nibble, Sum_2, Sum_3, Cout_upper_nibble);

    input logic clk;
    input logic a,b,c,d,e,f, Data_in;
    input logic cfg_write_en_0, cfg_write_en_1, cfg_write_en_2, cfg_write_en_3, cfg_write_en_4, cfg_write_en_5, cfg_write_en_6, cfg_write_en_7;
    input logic Cin_lower_nibble, Cin_upper_nibble;
    input logic LowerNibble_negVal_sel, UpperNibble_negVal_sel;
    input logic [1:0]Carry_select_Int_0,Carry_select_Int_1;
    output logic O_6, O_5;
    output logic Sum_0, Sum_1, Cout_lower_nibble, Sum_2, Sum_3, Cout_upper_nibble; 
    
    //abc with a msb and c lsb
    
    
    //connecting wires
    logic Carry_LowerNibble_out, Carry_UpperNibble_out;
    logic Wire_LowerNibble_AddSub_Sel_val, Wire_UpperNibble_AddSub_Sel_val;
    logic Out_lut3_0 , Out_lut3_1, Out_lut3_2, Out_lut3_3, Out_lut3_4, Out_lut3_5, Out_lut3_6, Out_lut3_7;
    logic Not_Out_lut3_0, Not_Out_lut3_4;
    logic CarryBetweenAdder_Lut3_01_and_Lut3_23,CarryBetweenAdder_Lut3_45_and_Lut3_67;
    logic Wire_Cout_LowerNibble,Wire_Cout_UpperNibble;
    logic Out_mux4_01, Out_mux4_23, Out_mux4_45, Out_mux4_67;
    logic Out_mux5_03, Out_mux5_47;
    
    
    //0. clock buffers
    
    
    //stage 0
    //1. input carry lower nibble
        mux_4 lower_carry_selector(.I0(1'b0),.I1(Cin_lower_nibble),.I2(Cin_lower_nibble),.I3(1'b1),.S(Carry_select_Int_0),.O(Carry_LowerNibble_out));
        
    //2. lower nibble lut3s
        LUT3  lut3_0(.a(a),.b(b),.c(c),.clk(clk), .Data_in(Data_in),.cfg_write_en(cfg_write_en_0), .Out(Out_lut3_0));
        LUT3  lut3_1(.a(a),.b(b),.c(c),.clk(clk), .Data_in(Data_in),.cfg_write_en(cfg_write_en_1), .Out(Out_lut3_1)); 
        LUT3  lut3_2(.a(a),.b(b),.c(c),.clk(clk), .Data_in(Data_in),.cfg_write_en(cfg_write_en_2), .Out(Out_lut3_2)); 
        LUT3  lut3_3(.a(a),.b(b),.c(c),.clk(clk), .Data_in(Data_in),.cfg_write_en(cfg_write_en_3), .Out(Out_lut3_3)); 
              
        
    //3. Lower nibble adders
    // negative term in lower lut3, because addition with 2s compliment because limiting not gate 
      
         not two_comp_lowerNible(Not_Out_lut3_0,Out_lut3_0);
         mux_2 diff_bw_add_sub_LowerNibble(.I0(Out_lut3_0),.I1(Not_Out_lut3_0), .S(LowerNibble_negVal_sel),.O(Wire_LowerNibble_AddSub_Sel_val));
         adder_1_bit lut3_01(.a(Wire_LowerNibble_AddSub_Sel_val),.b(Out_lut3_1),.cin(Carry_LowerNibble_out),.out(Sum_0),.cout(CarryBetweenAdder_Lut3_01_and_Lut3_23));
         adder_1_bit lut3_23(.a(Out_lut3_2),.b(Out_lut3_3),.cin(CarryBetweenAdder_Lut3_01_and_Lut3_23),.out(Sum_1),.cout(Wire_Cout_LowerNibble));
        
        
        
    //4. input carry upper nibble
        mux_4 Upper_carry_selector(.I0(1'b0),.I1(Cin_upper_nibble),.I2(Wire_Cout_LowerNibble),.I3(1'b1),.S(Carry_select_Int_1),.O(Carry_UpperNibble_out));
        
    //5. upper nibble lut3s
        LUT3  lut3_4(.a(a),.b(b),.c(c),.clk(clk), .Data_in(Data_in),.cfg_write_en(cfg_write_en_4), .Out(Out_lut3_4));
        LUT3  lut3_5(.a(a),.b(b),.c(c),.clk(clk), .Data_in(Data_in),.cfg_write_en(cfg_write_en_5), .Out(Out_lut3_5)); 
        LUT3  lut3_6(.a(a),.b(b),.c(c),.clk(clk), .Data_in(Data_in),.cfg_write_en(cfg_write_en_6), .Out(Out_lut3_6)); 
        LUT3  lut3_7(.a(a),.b(b),.c(c),.clk(clk), .Data_in(Data_in),.cfg_write_en(cfg_write_en_7), .Out(Out_lut3_7)); 
              
    //6. Upper nibble adders
    // negative term in lower lut3, because addition with 2s compliment because limiting not gate   
        not two_comp_upperNible(Not_Out_lut3_4,Out_lut3_4);
        mux_2 diff_bw_add_sub_UpperNibble(.I0(Out_lut3_4), .I1(Not_Out_lut3_4), .S(UpperNibble_negVal_sel),.O(Wire_UpperNibble_AddSub_Sel_val));
        adder_1_bit lut3_45(.a(Wire_UpperNibble_AddSub_Sel_val),.b(Out_lut3_5),.cin(Carry_UpperNibble_out),.out(Sum_2),.cout(CarryBetweenAdder_Lut3_45_and_Lut3_67));
        adder_1_bit lut3_67(.a(Out_lut3_6),.b(Out_lut3_7),.cin(CarryBetweenAdder_Lut3_45_and_Lut3_67),.out(Sum_3),.cout(Wire_Cout_UpperNibble));
         
         
         
         
    //stage 2
    //7. d selectors/muxes
        mux_2 dSelector_lut4_01(.I0(Out_lut3_0),.I1(Out_lut3_1),.S(d),.O(Out_mux4_01));
        mux_2 dSelector_lut4_23(.I0(Out_lut3_2),.I1(Out_lut3_3),.S(d),.O(Out_mux4_23));
        mux_2 dSelector_lut4_45(.I0(Out_lut3_4),.I1(Out_lut3_5),.S(d),.O(Out_mux4_45));
        mux_2 dSelector_lut4_67(.I0(Out_lut3_6),.I1(Out_lut3_6),.S(d),.O(Out_mux4_67));
        
    //8. e selector/muxes 
         mux_2 dSelector_lut5_03(.I0(Out_mux4_01),.I1(Out_mux4_23),.S(e),.O(Out_mux5_03));
         mux_2 dSelector_lut5_47(.I0(Out_mux4_45),.I1(Out_mux4_67),.S(e),.O(Out_mux5_47));
         
    //9. f selector/muxes
         mux_2 dSelector_lut6(.I0(Out_mux5_03),.I1(Out_mux5_47),.S(f),.O(O_6)); 
         
         
         
    // assign ports
        assign   Cout_lower_nibble = Wire_Cout_LowerNibble;
        assign   Cout_upper_nibble = Wire_Cout_UpperNibble;
        assign   O_5 = Out_mux5_03;
        
endmodule  




//8bit adder
module adder_16bit(a, b, Cin, Out, Cout);
    
    input logic [15:0] a,b;
    input logic Cin;
    output logic [15:0] Out;
    output logic Cout;
    
    logic Int_Cout_0, Int_Cout_1, Int_Cout_2, Int_Cout_3, Int_Cout_4, Int_Cout_5, Int_Cout_6, Int_Cout_7;
    logic Int_Cout_8, Int_Cout_9, Int_Cout_10, Int_Cout_11, Int_Cout_12, Int_Cout_13, Int_Cout_14, Int_Cout_15;


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
    adder_1_bit adder15(.a(a[15]), .b(b[15]), .cin(Int_Cout_14), .out(Out[15]), .cout(Cout));
    
     
endmodule




//16bit Add

module adder_8bit(a, b, Cin, Out, Cout);
    
    input logic [7:0] a,b;
    input logic Cin;
    output logic [7:0] Out;
    output logic Cout;
    
    logic Int_Cout_0, Int_Cout_1, Int_Cout_2, Int_Cout_3, Int_Cout_4, Int_Cout_5, Int_Cout_6, Int_Cout_7;


    adder_1_bit adder0(.a(a[0]), .b(b[0]), .cin(Cin), .out(Out[0]), .cout(Int_Cout_0));
    adder_1_bit adder1(.a(a[1]), .b(b[1]), .cin(Int_Cout_0), .out(Out[1]), .cout(Int_Cout_1));
    adder_1_bit adder2(.a(a[2]), .b(b[2]), .cin(Int_Cout_1), .out(Out[2]), .cout(Int_Cout_2));
    adder_1_bit adder3(.a(a[3]), .b(b[3]), .cin(Int_Cout_2), .out(Out[3]), .cout(Int_Cout_3));
    adder_1_bit adder4(.a(a[4]), .b(b[4]), .cin(Int_Cout_3), .out(Out[4]), .cout(Int_Cout_4));
    adder_1_bit adder5(.a(a[5]), .b(b[5]), .cin(Int_Cout_4), .out(Out[5]), .cout(Int_Cout_5));
    adder_1_bit adder6(.a(a[6]), .b(b[6]), .cin(Int_Cout_5), .out(Out[6]), .cout(Int_Cout_6));
    adder_1_bit adder7(.a(a[7]), .b(b[7]), .cin(Int_Cout_6), .out(Out[7]), .cout(Cout));
    
     
endmodule