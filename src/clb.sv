`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: MJA Baig
//// 
//// Create Date: 10/19/2026 02:24:23 PM
//// Design Name: 
//// Module Name: clb
//// Project Name: eFPGA
//// Target Devices: ASIC
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////
//`include "elements.sv"
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
                
    //4. a
        mux_2 mux_select_a_0(.I0(dlatch_out[0]), .I1(dlatch_out[1]), .S(a), .O(output_mux_a_01));
        mux_2 mux_select_a_1(.I0(dlatch_out[2]), .I1(dlatch_out[3]), .S(a), .O(output_mux_a_23));
        mux_2 mux_select_a_2(.I0(dlatch_out[4]), .I1(dlatch_out[5]), .S(a), .O(output_mux_a_45));
        mux_2 mux_select_a_3(.I0(dlatch_out[6]), .I1(dlatch_out[7]), .S(a), .O(output_mux_a_67));
    
    //5. b
        mux_2 mux_select_b_0(.I0(output_mux_a_01), .I1(output_mux_a_23), .S(b), .O(output_mux_b_03));
        mux_2 mux_select_b_1(.I0(output_mux_a_45), .I1(output_mux_a_67), .S(b), .O(output_mux_b_47));
        
    //6. c
         mux_2 mux_select_c_0(.I0(output_mux_b_03), .I1(output_mux_b_47), .S(c), .O(output_mux_c_07));
         
    //7. output
        assign Out = output_mux_c_07;
        
  endmodule
  
  
  
 
//lut6
// same selectors for a nibble
module LUT6(clk,cfg_flag,a,b,c,d,e,f, Data_in, write_en_0, write_en_1, write_en_2,  write_en_3,  write_en_4,  write_en_5, write_en_6, write_en_7, Cin_bits0, Cin_bits1, cfg_Carry_select_Int_0, cfg_Carry_select_Int_1, O_6, O_5, Sum_0, Sum_1, Cout_lower, Sum_2, Sum_3, Cout_upper);

    input logic clk,cfg_flag;
    input logic a,b,c,d,e,f, Data_in;
    input logic write_en_0, write_en_1, write_en_2, write_en_3, write_en_4, write_en_5, write_en_6, write_en_7;
    input logic Cin_bits0, Cin_bits1;
    input logic [1:0] cfg_Carry_select_Int_0, cfg_Carry_select_Int_1;
    output logic O_6, O_5;
    output logic Sum_0, Sum_1, Cout_lower, Sum_2, Sum_3, Cout_upper; 
    
    //abc with a msb and c lsb
    
    
    //connecting wires
    logic [1:0] wire_Carry_Lower_Latch, wire_Carry_Upper_Latch;
    logic wire_Carry_Lower_Sel, wire_Carry_Upper_Sel;
    logic Wire_Lower_AddSub_Sel_val, Wire_Upper_AddSub_Sel_val;


    logic Wire_Out_lut3_0 , Wire_Out_lut3_1, Wire_Out_lut3_2, Wire_Out_lut3_3, Wire_Out_lut3_4, Wire_Out_lut3_5, Wire_Out_lut3_6, Wire_Out_lut3_7;
    logic Wire_Not_Out_lut3_0, Wire_Not_Out_lut3_4;
    logic Wire_CarryBetweenAdder_Lut3_01_and_Lut3_23,Wire_CarryBetweenAdder_Lut3_45_and_Lut3_67;
    logic Wire_Cout_Lower,Wire_Cout_Upper;
    
    
    logic Wire_Out_mux4_01, Wire_Out_mux4_23, Wire_Out_mux4_45, Wire_Out_mux4_67;
    logic Wire_Out_mux5_03, Wire_Out_mux5_47;
    
    
    //0. clock buffers
    
    
    //stage 0
    //0. mux latches
        DLatch#(.WIDTH(2)) In_latch_Cin0_sel( .d(cfg_Carry_select_Int_0), .enable(cfg_flag),.q(wire_Carry_Lower_Latch) );
        DLatch#(.WIDTH(2)) In_latch_Cin1_sel( .d(cfg_Carry_select_Int_1), .enable(cfg_flag),.q(wire_Carry_Upper_Latch) );
           
    //1. lower nibble lut3s
        LUT3  lut3_0(.a(a),.b(b),.c(c),.clk(clk), .Data_in(Data_in),.cfg_write_en(write_en_0), .Out(Wire_Out_lut3_0));
        LUT3  lut3_1(.a(a),.b(b),.c(c),.clk(clk), .Data_in(Data_in),.cfg_write_en(write_en_1), .Out(Wire_Out_lut3_1)); 
        LUT3  lut3_2(.a(a),.b(b),.c(c),.clk(clk), .Data_in(Data_in),.cfg_write_en(write_en_2), .Out(Wire_Out_lut3_2)); 
        LUT3  lut3_3(.a(a),.b(b),.c(c),.clk(clk), .Data_in(Data_in),.cfg_write_en(write_en_3), .Out(Wire_Out_lut3_3)); 
        LUT3  lut3_4(.a(a),.b(b),.c(c),.clk(clk), .Data_in(Data_in),.cfg_write_en(write_en_4), .Out(Wire_Out_lut3_4));
        LUT3  lut3_5(.a(a),.b(b),.c(c),.clk(clk), .Data_in(Data_in),.cfg_write_en(write_en_5), .Out(Wire_Out_lut3_5)); 
        LUT3  lut3_6(.a(a),.b(b),.c(c),.clk(clk), .Data_in(Data_in),.cfg_write_en(write_en_6), .Out(Wire_Out_lut3_6)); 
        LUT3  lut3_7(.a(a),.b(b),.c(c),.clk(clk), .Data_in(Data_in),.cfg_write_en(write_en_7), .Out(Wire_Out_lut3_7)); 
        
        
    //stage 1
    //1. input carry lower nibble
        mux_4 lower_carry_selector(.I0(1'b0),.I1(Cin_bits0),.I2(1'b1),.I3(1'b1),.S(wire_Carry_Lower_Latch),.O(wire_Carry_Lower_Sel));
        mux_4 upper_carry_selector(.I0(Wire_Cout_Lower),.I1(Cin_bits1),.I2(1'b1),.I3(1'b1),.S(wire_Carry_Upper_Latch),.O(wire_Carry_Upper_out));
            
            
    //3. adders
    // negative term in lower lut3, because addition with 2s compliment because limiting not gate 
      
         not two_comp_lower(Wire_Not_Out_lut3_0,Wire_Out_lut3_0);
         mux_2 diff_bw_add_sub_Lower(.I0(Wire_Out_lut3_0),.I1(Wire_Not_Out_lut3_0), .S(wire_Carry_Lower_Latch[1]),.O(Wire_Lower_AddSub_Sel_val));  
         adder_1_bit lut3_01(.a(Wire_Out_lut3_1),.b(Wire_Lower_AddSub_Sel_val),.cin(wire_Carry_Lower_Sel),.out(Sum_0),.cout(Wire_CarryBetweenAdder_Lut3_01_and_Lut3_23));
         adder_1_bit lut3_23(.a(Wire_Out_lut3_2),.b(Wire_Out_lut3_3),.cin(Wire_CarryBetweenAdder_Lut3_01_and_Lut3_23),.out(Sum_1),.cout(Wire_Cout_Lower));
         
         not two_comp_upper(Wire_Not_Out_lut3_4,Wire_Out_lut3_4);
         mux_2 diff_bw_add_sub_Upper(.I0(Wire_Out_lut3_4),.I1(Wire_Not_Out_lut3_4), .S(wire_Carry_Upper_Latch[1]),.O(Wire_Upper_AddSub_Sel_val));  
         adder_1_bit lut3_45(.a(Wire_Out_lut3_5),.b(Wire_Upper_AddSub_Sel_val),.cin(wire_Carry_Upper_out),.out(Sum_2),.cout(Wire_CarryBetweenAdder_Lut3_45_and_Lut3_67));
         adder_1_bit lut3_67(.a(Wire_Out_lut3_6),.b(Wire_Out_lut3_7),.cin(Wire_CarryBetweenAdder_Lut3_45_and_Lut3_67),.out(Sum_3),.cout(Wire_Cout_Upper));
        
        
         
    //stage 2
    //7. d selectors/muxes
        mux_2 dSelector_lut4_01(.I0(Wire_Out_lut3_0),.I1(Wire_Out_lut3_1),.S(d),.O(Wire_Out_mux4_01));
        mux_2 dSelector_lut4_23(.I0(Wire_Out_lut3_2),.I1(Wire_Out_lut3_3),.S(d),.O(Wire_Out_mux4_23));
        mux_2 dSelector_lut4_45(.I0(Wire_Out_lut3_4),.I1(Wire_Out_lut3_5),.S(d),.O(Wire_Out_mux4_45));
        mux_2 dSelector_lut4_67(.I0(Wire_Out_lut3_6),.I1(Wire_Out_lut3_6),.S(d),.O(Wire_Out_mux4_67));
        
    //8. e selector/muxes 
         mux_2 dSelector_lut5_03(.I0(Wire_Out_mux4_01),.I1(Wire_Out_mux4_23),.S(e),.O(Wire_Out_mux5_03));
         mux_2 dSelector_lut5_47(.I0(Wire_Out_mux4_45),.I1(Wire_Out_mux4_67),.S(e),.O(Wire_Out_mux5_47));
         
    //9. f selector/muxes
         mux_2 dSelector_lut6(.I0(Wire_Out_mux5_03),.I1(Wire_Out_mux5_47),.S(f),.O(O_6)); 
         
         
         
    // assign ports
        assign   Cout_lower = Wire_Cout_Lower;
        assign   Cout_upper = Wire_Cout_Upper;
        assign   O_5 = Wire_Out_mux5_03;
        
endmodule  




//1 bit clb
module clb_1_bit (clk, cfg_flag, a, b, c, d, e, f, Data_in, write_en_0, write_en_1, write_en_2, write_en_3, write_en_4, write_en_5, write_en_6, write_en_7, Cin_bits0, Cin_bits1, cfg_Carry_select_Int_0, cfg_Carry_select_Int_1, O_6, O_5, Sum_0, Sum_1, Cout_lower, Sum_2, Sum_3, Cout_upper, cfg_sel_clb_out, cfg_sel_Dff_out, dff_reset, out, Mem_out);


    //lut6
    input logic clk, cfg_flag;
    input logic a,b,c,d,e,f, Data_in;
    input logic write_en_0, write_en_1, write_en_2, write_en_3, write_en_4, write_en_5, write_en_6, write_en_7;
    input logic Cin_bits0, Cin_bits1;
    input logic [1:0] cfg_Carry_select_Int_0, cfg_Carry_select_Int_1;
    output logic O_6, O_5;
    output logic Sum_0, Sum_1, Cout_lower, Sum_2, Sum_3, Cout_upper;
    //clb 
    input logic [1:0] cfg_sel_clb_out, cfg_sel_Dff_out;
    input logic  dff_reset;
    output logic out, Mem_out;
    
    
    
    //wires
    logic [1:0]Wire_Out_SelMux, Wire_dff_SelMux;
    logic Wire_mux_to_dff;
    
    logic Wire_dff_out, Wire_direct_out;

    
//  
    //stage 0
    LUT6 Clb_1bit_lut6( .clk(clk), .cfg_flag(cfg_flag), .d(d), .e(e), .f(f), .a(a), .b(b), .c(c), .Data_in(Data_in), 
                        .write_en_0(write_en_0), .write_en_1(write_en_1), .write_en_2(write_en_2), .write_en_3(write_en_3), .write_en_4(write_en_4), .write_en_5(write_en_5), .write_en_6(write_en_6), .write_en_7(write_en_7), 
                        .Cin_bits0(Cin_bits0), .Cin_bits1(Cin_bits1), .cfg_Carry_select_Int_0(cfg_Carry_select_Int_0), .cfg_Carry_select_Int_1(cfg_Carry_select_Int_1), 
                        .O_6(O_6), .O_5(O_5), .Sum_0(Sum_0), .Sum_1(Sum_1), .Cout_lower(Cout_lower), .Sum_2(Sum_2), .Sum_3(Sum_3), .Cout_upper(Cout_upper));
    
    //stage1
    DLatch #(.WIDTH(2)) Out_selMux_latch( .d(cfg_sel_clb_out), .enable(cfg_flag),.q(Wire_Out_SelMux) );
    DLatch #(.WIDTH(2)) Dff_selMux_latch( .d(cfg_sel_Dff_out), .enable(cfg_flag),.q(Wire_dff_SelMux) );
    
    //stage 2
    mux_4 out_sel_mux (.I0(1'b0), .I1(O_6), .I2(O_5), .I3(Data_in), .S(Wire_Out_SelMux), .O(Wire_direct_out));
    mux_4 dff_ip_mux (.I0(1'b0), .I1(O_6), .I2(O_5), .I3(Data_in), .S(Wire_dff_SelMux), .O(Wire_mux_to_dff));

    //stage 3
    DFF_noWE clb_dff(.clk(clk), .reset(dff_reset), .d(Wire_mux_to_dff), .q(Wire_dff_out));
    
    
    assign out = Wire_direct_out;
    assign Mem_out = Wire_dff_out;
    
endmodule




// complete clb
module clb (clk, cfg_flag, cfg_Cin_8_to_16, cfg_Cin_16_to_24, cfg_Cin_24_to_32, Cin_8_to_16, Cin_16_to_24, Cin_24_to_32, reset,
    bit0_a, bit0_b, bit0_c, bit0_d, bit0_e, bit0_f, bit0_Data_in, bit0_write_en_0, bit0_write_en_1, bit0_write_en_2, bit0_write_en_3, bit0_write_en_4, bit0_write_en_5, bit0_write_en_6, bit0_write_en_7, bit0_Cin_bits0, bit0_Cin_bits1, bit0_cfg_Carry_select_Int_0, bit0_cfg_Carry_select_Int_1, bit0_O_6, bit0_O_5, bit0_Sum_0, bit0_Sum_1, bit0_Cout_lower, bit0_Sum_2, bit0_Sum_3, bit0_Cout_upper, bit0_cfg_sel_clb_out, bit0_cfg_sel_Dff_out, bit0_out, bit0_Mem_out,
    bit1_a, bit1_b, bit1_c, bit1_d, bit1_e, bit1_f, bit1_Data_in, bit1_write_en_0, bit1_write_en_1, bit1_write_en_2, bit1_write_en_3, bit1_write_en_4, bit1_write_en_5, bit1_write_en_6, bit1_write_en_7,                 bit1_Cin_bits1, bit1_cfg_Carry_select_Int_0, bit1_cfg_Carry_select_Int_1, bit1_O_6, bit1_O_5, bit1_Sum_0, bit1_Sum_1, bit1_Cout_lower, bit1_Sum_2, bit1_Sum_3, bit1_Cout_upper, bit1_cfg_sel_clb_out, bit1_cfg_sel_Dff_out, bit1_out, bit1_Mem_out,
    bit2_a, bit2_b, bit2_c, bit2_d, bit2_e, bit2_f, bit2_Data_in, bit2_write_en_0, bit2_write_en_1, bit2_write_en_2, bit2_write_en_3, bit2_write_en_4, bit2_write_en_5, bit2_write_en_6, bit2_write_en_7,                 bit2_Cin_bits1, bit2_cfg_Carry_select_Int_0, bit2_cfg_Carry_select_Int_1, bit2_O_6, bit2_O_5, bit2_Sum_0, bit2_Sum_1, bit2_Cout_lower, bit2_Sum_2, bit2_Sum_3, bit2_Cout_upper, bit2_cfg_sel_clb_out, bit2_cfg_sel_Dff_out, bit2_out, bit2_Mem_out,
    bit3_a, bit3_b, bit3_c, bit3_d, bit3_e, bit3_f, bit3_Data_in, bit3_write_en_0, bit3_write_en_1, bit3_write_en_2, bit3_write_en_3, bit3_write_en_4, bit3_write_en_5, bit3_write_en_6, bit3_write_en_7,                 bit3_Cin_bits1, bit3_cfg_Carry_select_Int_0, bit3_cfg_Carry_select_Int_1, bit3_O_6, bit3_O_5, bit3_Sum_0, bit3_Sum_1, bit3_Cout_lower, bit3_Sum_2, bit3_Sum_3, bit3_Cout_upper, bit3_cfg_sel_clb_out, bit3_cfg_sel_Dff_out, bit3_out, bit3_Mem_out,
    bit4_a, bit4_b, bit4_c, bit4_d, bit4_e, bit4_f, bit4_Data_in, bit4_write_en_0, bit4_write_en_1, bit4_write_en_2, bit4_write_en_3, bit4_write_en_4, bit4_write_en_5, bit4_write_en_6, bit4_write_en_7,                 bit4_Cin_bits1, bit4_cfg_Carry_select_Int_0, bit4_cfg_Carry_select_Int_1, bit4_O_6, bit4_O_5, bit4_Sum_0, bit4_Sum_1, bit4_Cout_lower, bit4_Sum_2, bit4_Sum_3, bit4_Cout_upper, bit4_cfg_sel_clb_out, bit4_cfg_sel_Dff_out, bit4_out, bit4_Mem_out,
    bit5_a, bit5_b, bit5_c, bit5_d, bit5_e, bit5_f, bit5_Data_in, bit5_write_en_0, bit5_write_en_1, bit5_write_en_2, bit5_write_en_3, bit5_write_en_4, bit5_write_en_5, bit5_write_en_6, bit5_write_en_7,                 bit5_Cin_bits1, bit5_cfg_Carry_select_Int_0, bit5_cfg_Carry_select_Int_1, bit5_O_6, bit5_O_5, bit5_Sum_0, bit5_Sum_1, bit5_Cout_lower, bit5_Sum_2, bit5_Sum_3, bit5_Cout_upper, bit5_cfg_sel_clb_out, bit5_cfg_sel_Dff_out, bit5_out, bit5_Mem_out,
    bit6_a, bit6_b, bit6_c, bit6_d, bit6_e, bit6_f, bit6_Data_in, bit6_write_en_0, bit6_write_en_1, bit6_write_en_2, bit6_write_en_3, bit6_write_en_4, bit6_write_en_5, bit6_write_en_6, bit6_write_en_7,                 bit6_Cin_bits1, bit6_cfg_Carry_select_Int_0, bit6_cfg_Carry_select_Int_1, bit6_O_6, bit6_O_5, bit6_Sum_0, bit6_Sum_1, bit6_Cout_lower, bit6_Sum_2, bit6_Sum_3, bit6_Cout_upper, bit6_cfg_sel_clb_out, bit6_cfg_sel_Dff_out, bit6_out, bit6_Mem_out,
    bit7_a, bit7_b, bit7_c, bit7_d, bit7_e, bit7_f, bit7_Data_in, bit7_write_en_0, bit7_write_en_1, bit7_write_en_2, bit7_write_en_3, bit7_write_en_4, bit7_write_en_5, bit7_write_en_6, bit7_write_en_7,                 bit7_Cin_bits1, bit7_cfg_Carry_select_Int_0, bit7_cfg_Carry_select_Int_1, bit7_O_6, bit7_O_5, bit7_Sum_0, bit7_Sum_1, bit7_Cout_lower, bit7_Sum_2, bit7_Sum_3, bit7_Cout_upper, bit7_cfg_sel_clb_out, bit7_cfg_sel_Dff_out, bit7_out, bit7_Mem_out
);


    
    input logic clk, cfg_flag, reset, Cin_8_to_16, Cin_16_to_24, Cin_24_to_32;
    input logic [1:0]cfg_Cin_8_to_16, cfg_Cin_16_to_24, cfg_Cin_24_to_32;

    // bit 0
    // lut6
    input logic bit0_a, bit0_b, bit0_c, bit0_d, bit0_e, bit0_f, bit0_Data_in;
    input logic bit0_write_en_0, bit0_write_en_1, bit0_write_en_2, bit0_write_en_3, bit0_write_en_4, bit0_write_en_5, bit0_write_en_6, bit0_write_en_7;
    input logic bit0_Cin_bits0, bit0_Cin_bits1;
    input logic [1:0] bit0_cfg_Carry_select_Int_0, bit0_cfg_Carry_select_Int_1;
    output logic bit0_O_6, bit0_O_5;
    output logic bit0_Sum_0, bit0_Sum_1, bit0_Cout_lower, bit0_Sum_2, bit0_Sum_3, bit0_Cout_upper;
    // clb
    input logic [1:0] bit0_cfg_sel_clb_out, bit0_cfg_sel_Dff_out;
    output logic bit0_out, bit0_Mem_out;

    // bit 1
    // lut6
    input logic bit1_a, bit1_b, bit1_c, bit1_d, bit1_e, bit1_f, bit1_Data_in;
    input logic bit1_write_en_0, bit1_write_en_1, bit1_write_en_2, bit1_write_en_3, bit1_write_en_4, bit1_write_en_5, bit1_write_en_6, bit1_write_en_7;
    input logic  bit1_Cin_bits1;
    input logic [1:0] bit1_cfg_Carry_select_Int_0, bit1_cfg_Carry_select_Int_1;
    output logic bit1_O_6, bit1_O_5;
    output logic bit1_Sum_0, bit1_Sum_1, bit1_Cout_lower, bit1_Sum_2, bit1_Sum_3, bit1_Cout_upper;
    // clb
    input logic [1:0] bit1_cfg_sel_clb_out, bit1_cfg_sel_Dff_out;
    output logic bit1_out, bit1_Mem_out;

    // bit 2
    // lut6
    input logic bit2_a, bit2_b, bit2_c, bit2_d, bit2_e, bit2_f, bit2_Data_in;
    input logic bit2_write_en_0, bit2_write_en_1, bit2_write_en_2, bit2_write_en_3, bit2_write_en_4, bit2_write_en_5, bit2_write_en_6, bit2_write_en_7;
    input logic  bit2_Cin_bits1;
    input logic [1:0] bit2_cfg_Carry_select_Int_0, bit2_cfg_Carry_select_Int_1;
    output logic bit2_O_6, bit2_O_5;
    output logic bit2_Sum_0, bit2_Sum_1, bit2_Cout_lower, bit2_Sum_2, bit2_Sum_3, bit2_Cout_upper;
    // clb
    input logic [1:0] bit2_cfg_sel_clb_out, bit2_cfg_sel_Dff_out;
    output logic bit2_out, bit2_Mem_out;

    // bit 3
    // lut6
    input logic bit3_a, bit3_b, bit3_c, bit3_d, bit3_e, bit3_f, bit3_Data_in;
    input logic bit3_write_en_0, bit3_write_en_1, bit3_write_en_2, bit3_write_en_3, bit3_write_en_4, bit3_write_en_5, bit3_write_en_6, bit3_write_en_7;
    input logic  bit3_Cin_bits1;
    input logic [1:0] bit3_cfg_Carry_select_Int_0, bit3_cfg_Carry_select_Int_1;
    output logic bit3_O_6, bit3_O_5;
    output logic bit3_Sum_0, bit3_Sum_1, bit3_Cout_lower, bit3_Sum_2, bit3_Sum_3, bit3_Cout_upper;
    // clb
    input logic [1:0] bit3_cfg_sel_clb_out, bit3_cfg_sel_Dff_out;
    output logic bit3_out, bit3_Mem_out;

    // bit 4
    // lut6
    input logic bit4_a, bit4_b, bit4_c, bit4_d, bit4_e, bit4_f, bit4_Data_in;
    input logic bit4_write_en_0, bit4_write_en_1, bit4_write_en_2, bit4_write_en_3, bit4_write_en_4, bit4_write_en_5, bit4_write_en_6, bit4_write_en_7;
    input logic  bit4_Cin_bits1;
    input logic [1:0] bit4_cfg_Carry_select_Int_0, bit4_cfg_Carry_select_Int_1;
    output logic bit4_O_6, bit4_O_5;
    output logic bit4_Sum_0, bit4_Sum_1, bit4_Cout_lower, bit4_Sum_2, bit4_Sum_3, bit4_Cout_upper;
    // clb
    input logic [1:0] bit4_cfg_sel_clb_out, bit4_cfg_sel_Dff_out;
    output logic bit4_out, bit4_Mem_out;

    // bit 5
    // lut6
    input logic bit5_a, bit5_b, bit5_c, bit5_d, bit5_e, bit5_f, bit5_Data_in;
    input logic bit5_write_en_0, bit5_write_en_1, bit5_write_en_2, bit5_write_en_3, bit5_write_en_4, bit5_write_en_5, bit5_write_en_6, bit5_write_en_7;
    input logic  bit5_Cin_bits1;
    input logic [1:0] bit5_cfg_Carry_select_Int_0, bit5_cfg_Carry_select_Int_1;
    output logic bit5_O_6, bit5_O_5;
    output logic bit5_Sum_0, bit5_Sum_1, bit5_Cout_lower, bit5_Sum_2, bit5_Sum_3, bit5_Cout_upper;
    // clb
    input logic [1:0] bit5_cfg_sel_clb_out, bit5_cfg_sel_Dff_out;
    output logic bit5_out, bit5_Mem_out;

    // bit 6
    // lut6
    input logic bit6_a, bit6_b, bit6_c, bit6_d, bit6_e, bit6_f, bit6_Data_in;
    input logic bit6_write_en_0, bit6_write_en_1, bit6_write_en_2, bit6_write_en_3, bit6_write_en_4, bit6_write_en_5, bit6_write_en_6, bit6_write_en_7;
    input logic  bit6_Cin_bits1;
    input logic [1:0] bit6_cfg_Carry_select_Int_0, bit6_cfg_Carry_select_Int_1;
    output logic bit6_O_6, bit6_O_5;
    output logic bit6_Sum_0, bit6_Sum_1, bit6_Cout_lower, bit6_Sum_2, bit6_Sum_3, bit6_Cout_upper;
    // clb
    input logic [1:0] bit6_cfg_sel_clb_out, bit6_cfg_sel_Dff_out;
    output logic bit6_out, bit6_Mem_out;

    // bit 7
    // lut6
    input logic bit7_a, bit7_b, bit7_c, bit7_d, bit7_e, bit7_f, bit7_Data_in;
    input logic bit7_write_en_0, bit7_write_en_1, bit7_write_en_2, bit7_write_en_3, bit7_write_en_4, bit7_write_en_5, bit7_write_en_6, bit7_write_en_7;
    input logic  bit7_Cin_bits1;
    input logic [1:0] bit7_cfg_Carry_select_Int_0, bit7_cfg_Carry_select_Int_1;
    output logic bit7_O_6, bit7_O_5;
    output logic bit7_Sum_0, bit7_Sum_1, bit7_Cout_lower, bit7_Sum_2, bit7_Sum_3, bit7_Cout_upper;
    // clb
    input logic [1:0] bit7_cfg_sel_clb_out, bit7_cfg_sel_Dff_out;
    output logic bit7_out, bit7_Mem_out;
    
    
    
    
    
    //wires
    logic wire_Carry_bit0_out, wire_Carry_bit1_out, wire_Carry_bit2_out, wire_Carry_bit3_out, wire_Carry_bit4_out, wire_Carry_bit5_out, wire_Carry_bit6_out, wire_Carry_bit7_out;
    logic [1:0] Wire_8to16_Cin_sel_latch, Wire_16to24_Cin_sel_latch, Wire_24to32_Cin_sel_latch;
    logic Wire_8to16_Cin_selected, Wire_16to24_Cin_selected, Wire_24to32_Cin_selected;
     

    
    
    //Mux Latches
    DLatch #(.WIDTH(2)) Cin8to16_selMux_latch ( .d(cfg_Cin_8_to_16),  .enable(cfg_flag), .q(Wire_8to16_Cin_sel_latch) );
    DLatch #(.WIDTH(2)) Cin16to24_selMux_latch( .d(cfg_Cin_16_to_24), .enable(cfg_flag), .q(Wire_16to24_Cin_sel_latch) );
    DLatch #(.WIDTH(2)) Cin24to32_selMux_latch( .d(cfg_Cin_24_to_32), .enable(cfg_flag), .q(Wire_24to32_Cin_sel_latch) );
    
    //Cin Muxes    
    mux_4 Cin_sel_8to16(.I0(wire_Carry_bit1_out),.I1(Cin_8_to_16),.I2(1'b1),.I3(1'b1),.S(Wire_8to16_Cin_sel_latch),.O(Wire_8to16_Cin_selected));
    mux_4 Cin_sel_16to24(.I0(wire_Carry_bit3_out),.I1(Cin_16_to_24),.I2(1'b1),.I3(1'b1),.S(Wire_16to24_Cin_sel_latch),.O(Wire_16to24_Cin_selected));
    mux_4 Cin_sel_24to32(.I0(wire_Carry_bit5_out),.I1(Cin_24_to_32),.I2(1'b1),.I3(1'b1),.S(Wire_24to32_Cin_sel_latch),.O(Wire_24to32_Cin_selected));
    
    
    
    
    clb_1_bit Bit_0(.clk(clk), .cfg_flag(cfg_flag), .a(bit0_a), .b(bit0_b), .c(bit0_c), .d(bit0_d), .e(bit0_e), .f(bit0_f), .Data_in(bit0_Data_in), 
                    .write_en_0(bit0_write_en_0), .write_en_1(bit0_write_en_1), .write_en_2(bit0_write_en_2), .write_en_3(bit0_write_en_3), .write_en_4(bit0_write_en_4), .write_en_5(bit0_write_en_5), .write_en_6(bit0_write_en_6), .write_en_7(bit0_write_en_7), 
                    .Cin_bits0(bit0_Cin_bits0), .Cin_bits1(bit0_Cin_bits1), .cfg_Carry_select_Int_0(bit0_cfg_Carry_select_Int_0), .cfg_Carry_select_Int_1(bit0_cfg_Carry_select_Int_1), 
                    .O_6(bit0_O_6), .O_5(bit0_O_5), .Sum_0(bit0_Sum_0), .Sum_1(bit0_Sum_1), .Cout_lower(bit0_Cout_lower), .Sum_2(bit0_Sum_2), .Sum_3(bit0_Sum_3), .Cout_upper(wire_Carry_bit0_out), 
                    .cfg_sel_clb_out(bit0_cfg_sel_clb_out), .cfg_sel_Dff_out(bit0_cfg_sel_Dff_out), .dff_reset(reset), .out(bit0_out), .Mem_out(bit0_Mem_out));
    
  
    clb_1_bit Bit_1(.clk(clk), .cfg_flag(cfg_flag), .a(bit1_a), .b(bit1_b), .c(bit1_c), .d(bit1_d), .e(bit1_e), .f(bit1_f), .Data_in(bit1_Data_in), 
                    .write_en_0(bit1_write_en_0), .write_en_1(bit1_write_en_1), .write_en_2(bit1_write_en_2), .write_en_3(bit1_write_en_3), .write_en_4(bit1_write_en_4), .write_en_5(bit1_write_en_5), .write_en_6(bit1_write_en_6), .write_en_7(bit1_write_en_7), 
                    .Cin_bits0(wire_Carry_bit0_out), .Cin_bits1(bit1_Cin_bits1), .cfg_Carry_select_Int_0(bit1_cfg_Carry_select_Int_0), .cfg_Carry_select_Int_1(bit1_cfg_Carry_select_Int_1), 
                    .O_6(bit1_O_6), .O_5(bit1_O_5), .Sum_0(bit1_Sum_0), .Sum_1(bit1_Sum_1), .Cout_lower(bit1_Cout_lower), .Sum_2(bit1_Sum_2), .Sum_3(bit1_Sum_3), .Cout_upper(wire_Carry_bit1_out), 
                    .cfg_sel_clb_out(bit1_cfg_sel_clb_out), .cfg_sel_Dff_out(bit1_cfg_sel_Dff_out), .dff_reset(reset), .out(bit1_out), .Mem_out(bit1_Mem_out));
                    
                    
                    
                   //mux  Cin_bits0
                    

    clb_1_bit Bit_2(.clk(clk), .cfg_flag(cfg_flag), .a(bit2_a), .b(bit2_b), .c(bit2_c), .d(bit2_d), .e(bit2_e), .f(bit2_f), .Data_in(bit2_Data_in), 
                    .write_en_0(bit2_write_en_0), .write_en_1(bit2_write_en_1), .write_en_2(bit2_write_en_2), .write_en_3(bit2_write_en_3), .write_en_4(bit2_write_en_4), .write_en_5(bit2_write_en_5), .write_en_6(bit2_write_en_6), .write_en_7(bit2_write_en_7), 
                    .Cin_bits0(Wire_8to16_Cin_selected), .Cin_bits1(bit2_Cin_bits1), .cfg_Carry_select_Int_0(bit2_cfg_Carry_select_Int_0), .cfg_Carry_select_Int_1(bit2_cfg_Carry_select_Int_1), 
                    .O_6(bit2_O_6), .O_5(bit2_O_5), .Sum_0(bit2_Sum_0), .Sum_1(bit2_Sum_1), .Cout_lower(bit2_Cout_lower), .Sum_2(bit2_Sum_2), .Sum_3(bit2_Sum_3), .Cout_upper(wire_Carry_bit2_out), 
                    .cfg_sel_clb_out(bit2_cfg_sel_clb_out), .cfg_sel_Dff_out(bit2_cfg_sel_Dff_out), .dff_reset(reset), .out(bit2_out), .Mem_out(bit2_Mem_out));

    clb_1_bit Bit_3(.clk(clk), .cfg_flag(cfg_flag), .a(bit3_a), .b(bit3_b), .c(bit3_c), .d(bit3_d), .e(bit3_e), .f(bit3_f), .Data_in(bit3_Data_in), 
                    .write_en_0(bit3_write_en_0), .write_en_1(bit3_write_en_1), .write_en_2(bit3_write_en_2), .write_en_3(bit3_write_en_3), .write_en_4(bit3_write_en_4), .write_en_5(bit3_write_en_5), .write_en_6(bit3_write_en_6), .write_en_7(bit3_write_en_7), 
                    .Cin_bits0(wire_Carry_bit2_out), .Cin_bits1(bit3_Cin_bits1), .cfg_Carry_select_Int_0(bit3_cfg_Carry_select_Int_0), .cfg_Carry_select_Int_1(bit3_cfg_Carry_select_Int_1), 
                    .O_6(bit3_O_6), .O_5(bit3_O_5), .Sum_0(bit3_Sum_0), .Sum_1(bit3_Sum_1), .Cout_lower(bit3_Cout_lower), .Sum_2(bit3_Sum_2), .Sum_3(bit3_Sum_3), .Cout_upper(wire_Carry_bit3_out), 
                    .cfg_sel_clb_out(bit3_cfg_sel_clb_out), .cfg_sel_Dff_out(bit3_cfg_sel_Dff_out), .dff_reset(reset), .out(bit3_out), .Mem_out(bit3_Mem_out));
                    
                    
                    //mux 
                    
                    

    clb_1_bit Bit_4(.clk(clk), .cfg_flag(cfg_flag), .a(bit4_a), .b(bit4_b), .c(bit4_c), .d(bit4_d), .e(bit4_e), .f(bit4_f), .Data_in(bit4_Data_in), 
                    .write_en_0(bit4_write_en_0), .write_en_1(bit4_write_en_1), .write_en_2(bit4_write_en_2), .write_en_3(bit4_write_en_3), .write_en_4(bit4_write_en_4), .write_en_5(bit4_write_en_5), .write_en_6(bit4_write_en_6), .write_en_7(bit4_write_en_7), 
                    .Cin_bits0(Wire_16to24_Cin_selected), .Cin_bits1(bit4_Cin_bits1), .cfg_Carry_select_Int_0(bit4_cfg_Carry_select_Int_0), .cfg_Carry_select_Int_1(bit4_cfg_Carry_select_Int_1), 
                    .O_6(bit4_O_6), .O_5(bit4_O_5), .Sum_0(bit4_Sum_0), .Sum_1(bit4_Sum_1), .Cout_lower(bit4_Cout_lower), .Sum_2(bit4_Sum_2), .Sum_3(bit4_Sum_3), .Cout_upper(wire_Carry_bit4_out), 
                    .cfg_sel_clb_out(bit4_cfg_sel_clb_out), .cfg_sel_Dff_out(bit4_cfg_sel_Dff_out), .dff_reset(reset), .out(bit4_out), .Mem_out(bit4_Mem_out));

    clb_1_bit Bit_5(.clk(clk), .cfg_flag(cfg_flag), .a(bit5_a), .b(bit5_b), .c(bit5_c), .d(bit5_d), .e(bit5_e), .f(bit5_f), .Data_in(bit5_Data_in), 
                    .write_en_0(bit5_write_en_0), .write_en_1(bit5_write_en_1), .write_en_2(bit5_write_en_2), .write_en_3(bit5_write_en_3), .write_en_4(bit5_write_en_4), .write_en_5(bit5_write_en_5), .write_en_6(bit5_write_en_6), .write_en_7(bit5_write_en_7), 
                    .Cin_bits0(wire_Carry_bit4_out), .Cin_bits1(bit5_Cin_bits1), .cfg_Carry_select_Int_0(bit5_cfg_Carry_select_Int_0), .cfg_Carry_select_Int_1(bit5_cfg_Carry_select_Int_1), 
                    .O_6(bit5_O_6), .O_5(bit5_O_5), .Sum_0(bit5_Sum_0), .Sum_1(bit5_Sum_1), .Cout_lower(bit5_Cout_lower), .Sum_2(bit5_Sum_2), .Sum_3(bit5_Sum_3), .Cout_upper(wire_Carry_bit5_out), 
                    .cfg_sel_clb_out(bit5_cfg_sel_clb_out), .cfg_sel_Dff_out(bit5_cfg_sel_Dff_out), .dff_reset(reset), .out(bit5_out), .Mem_out(bit5_Mem_out));
                    
                    
                    //mux
                    
                    

    clb_1_bit Bit_6(.clk(clk), .cfg_flag(cfg_flag), .a(bit6_a), .b(bit6_b), .c(bit6_c), .d(bit6_d), .e(bit6_e), .f(bit6_f), .Data_in(bit6_Data_in), 
                    .write_en_0(bit6_write_en_0), .write_en_1(bit6_write_en_1), .write_en_2(bit6_write_en_2), .write_en_3(bit6_write_en_3), .write_en_4(bit6_write_en_4), .write_en_5(bit6_write_en_5), .write_en_6(bit6_write_en_6), .write_en_7(bit6_write_en_7), 
                    .Cin_bits0(Wire_24to32_Cin_selected), .Cin_bits1(bit6_Cin_bits1), .cfg_Carry_select_Int_0(bit6_cfg_Carry_select_Int_0), .cfg_Carry_select_Int_1(bit6_cfg_Carry_select_Int_1), 
                    .O_6(bit6_O_6), .O_5(bit6_O_5), .Sum_0(bit6_Sum_0), .Sum_1(bit6_Sum_1), .Cout_lower(bit6_Cout_lower), .Sum_2(bit6_Sum_2), .Sum_3(bit6_Sum_3), .Cout_upper(wire_Carry_bit6_out), 
                    .cfg_sel_clb_out(bit6_cfg_sel_clb_out), .cfg_sel_Dff_out(bit6_cfg_sel_Dff_out), .dff_reset(reset), .out(bit6_out), .Mem_out(bit6_Mem_out));

    clb_1_bit Bit_7(.clk(clk), .cfg_flag(cfg_flag), .a(bit7_a), .b(bit7_b), .c(bit7_c), .d(bit7_d), .e(bit7_e), .f(bit7_f), .Data_in(bit7_Data_in), 
                    .write_en_0(bit7_write_en_0), .write_en_1(bit7_write_en_1), .write_en_2(bit7_write_en_2), .write_en_3(bit7_write_en_3), .write_en_4(bit7_write_en_4), .write_en_5(bit7_write_en_5), .write_en_6(bit7_write_en_6), .write_en_7(bit7_write_en_7), 
                    .Cin_bits0(wire_Carry_bit6_out), .Cin_bits1(bit7_Cin_bits1), .cfg_Carry_select_Int_0(bit7_cfg_Carry_select_Int_0), .cfg_Carry_select_Int_1(bit7_cfg_Carry_select_Int_1), 
                    .O_6(bit7_O_6), .O_5(bit7_O_5), .Sum_0(bit7_Sum_0), .Sum_1(bit7_Sum_1), .Cout_lower(bit7_Cout_lower), .Sum_2(bit7_Sum_2), .Sum_3(bit7_Sum_3), .Cout_upper(wire_Carry_bit7_out), 
                    .cfg_sel_clb_out(bit7_cfg_sel_clb_out), .cfg_sel_Dff_out(bit7_cfg_sel_Dff_out), .dff_reset(reset), .out(bit7_out), .Mem_out(bit7_Mem_out));
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
    
        
    assign bit0_Cout_upper = wire_Carry_bit0_out;
    assign bit1_Cout_upper = wire_Carry_bit1_out;
    assign bit2_Cout_upper = wire_Carry_bit2_out;
    assign bit3_Cout_upper = wire_Carry_bit3_out;
    assign bit4_Cout_upper = wire_Carry_bit4_out;
    assign bit5_Cout_upper = wire_Carry_bit5_out;
    assign bit6_Cout_upper = wire_Carry_bit6_out;
    assign bit7_Cout_upper = wire_Carry_bit7_out;
    
    
    
    endmodule