//`timescale 1ns / 1ps
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

//module clb_1_bit (sel_clb_out, Sel_Dff_out, dff_Write_enable, dff_reset, out, Mem_out);


//    input logic sel_clb_out, Sel_Dff_out;
//    input logic dff_Write_enable, dff_reset;
//    output logic out, Mem_out;
    
//    logic Wire_lut6_o6_to_mux,Wire_lut6_o5_to_mux;
//    logic Wire_mux_to_dff;
    
//    logic Wire_dff_out;
    
    
    
    
//    //stage 2
//    mux_4 out_sel_mux (.I0(), .I1(), .I2(), .I3(), .S(sel_clb_out), .O());
//    mux_4 dff_ip_mux (.I0(), .I1(), .I2(), .I3(), .S(Sel_Dff_out), .O(Wire_mux_to_dff));

//    //stage 3
//    DFF clb_dff(.clk(clk),.WE(dff_Write_enable),.SR(dff_reset), .d(Wire_mux_to_dff), .q(Wire_dff_out));
    
    
//    assign out = 
//    assign Mem_out = Wire_dff_out;
    
//endmodule
