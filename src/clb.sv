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
        mux_4 lower_carry_selector(.I0(Cin_bits0),.I1(1'b0),.I2(1'b1),.I3(1'b1),.S(wire_Carry_Lower_Latch),.O(wire_Carry_Lower_Sel));
        mux_4 upper_carry_selector(.I0(Wire_Cout_Lower),.I1(Cin_bits1),.I2(1'b1),.I3(1'b1),.S(wire_Carry_Lower_Latch),.O(wire_Carry_Upper_out));
            
            
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
