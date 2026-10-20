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

module clb_1_bit (clk,a,b,c,d,e,f, Data_in, cfg_write_en_0, cfg_write_en_1, cfg_write_en_2, cfg_write_en_3, cfg_write_en_4, cfg_write_en_5, cfg_write_en_6, cfg_write_en_7, Cin_lower_nibble, Cin_upper_nibble, Carry_select_Int_0,Carry_select_Int_1, LowerNibble_negVal_sel, UpperNibble_negVal_sel, O_6, O_5, Sum_0, Sum_1, Cout_lower_nibble, Sum_2, Sum_3, Cout_upper_nibble, sel_clb_out, cfg_sel_clb_out, sel_Dff_out, cfg_sel_Dff_out, dff_Write_enable, dff_reset, out, Mem_out);


    //lut6
    input logic clk;
    input logic a,b,c,d,e,f, Data_in;
    input logic cfg_write_en_0, cfg_write_en_1, cfg_write_en_2, cfg_write_en_3, cfg_write_en_4, cfg_write_en_5, cfg_write_en_6, cfg_write_en_7;
    input logic Cin_lower_nibble, Cin_upper_nibble;
    input logic LowerNibble_negVal_sel, UpperNibble_negVal_sel;
    input logic [1:0]Carry_select_Int_0,Carry_select_Int_1;
    output logic O_6, O_5;
    output logic Sum_0, Sum_1, Cout_lower_nibble, Sum_2, Sum_3, Cout_upper_nibble;
    //clb 
    input logic [1:0]sel_clb_out, sel_Dff_out;
    input logic cfg_sel_clb_out, cfg_sel_Dff_out;
    input logic dff_Write_enable, dff_reset;
    output logic out, Mem_out;
    
    
    
    //wires
    logic [1:0]Wire_Out_SelMux, Wire_dff_SelMux;
    logic Wire_mux_to_dff;
    
    logic Wire_dff_out, Wire_direct_out;

    
//  
    //stage 0
    LUT6 Clb_1bit_lut6( .clk(clk), .d(d), .e(e), .f(f), .a(a), .b(b), .c(c), .Data_in(Data_in), 
                        .cfg_write_en_0(cfg_write_en_0), .cfg_write_en_1(cfg_write_en_1), .cfg_write_en_2(cfg_write_en_2), .cfg_write_en_3(cfg_write_en_3), .cfg_write_en_4(cfg_write_en_4), .cfg_write_en_5(cfg_write_en_5), .cfg_write_en_6(cfg_write_en_6), .cfg_write_en_7(cfg_write_en_7), 
                        .Cin_lower_nibble(Cin_lower_nibble), .Cin_upper_nibble(Cin_upper_nibble), .Carry_select_Int_0(Carry_select_Int_0), .Carry_select_Int_1(Carry_select_Int_1), 
                        .LowerNibble_negVal_sel(LowerNibble_negVal_sel), .UpperNibble_negVal_sel(UpperNibble_negVal_sel), 
                        .O_6(O_6), .O_5(O_5), .Sum_0(Sum_0), .Sum_1(Sum_1), .Cout_lower_nibble(Cout_lower_nibble), .Sum_2(Sum_2), .Sum_3(Sum_3), .Cout_upper_nibble(Cout_upper_nibble));
    
    //stage1
    DLatch #(.WIDTH(2)) Out_selMux_latch( .d(sel_clb_out), .enable(cfg_sel_clb_out),.q(Wire_Out_SelMux) );
    DLatch #(.WIDTH(2)) Dff_selMux_latch( .d(sel_Dff_out), .enable(cfg_sel_Dff_out),.q(Wire_dff_SelMux) );
    
    //stage 2
    mux_4 out_sel_mux (.I0(1'b0), .I1(O_6), .I2(O_5), .I3(Data_in), .S(Wire_Out_SelMux), .O(Wire_direct_out));
    mux_4 dff_ip_mux (.I0(1'b0), .I1(O_6), .I2(O_5), .I3(Data_in), .S(Wire_dff_SelMux), .O(Wire_mux_to_dff));

    //stage 3
    DFF clb_dff(.clk(clk),.WE(dff_Write_enable),.reset(dff_reset), .d(Wire_mux_to_dff), .q(Wire_dff_out));
    
    
    assign out = Wire_direct_out;
    assign Mem_out = Wire_dff_out;
    
endmodule
