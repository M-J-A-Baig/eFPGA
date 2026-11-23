//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 11/17/2026 10:30:35 AM
//// Design Name: 
//// Module Name: ConnectionBox
//// Project Name: 
//// Target Devices: 
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


//module ConnectionBox#(

//    parameter W                     = 40,                  // Fixed output width
//    parameter fc_in                 = 3,
//    parameter overlapping_factor    = 1,
//    parameter clb_output_cb_in      = 8,
//    parameter fc_out                = 4, 
//    parameter lower_shift           = 0,         // Horizontal shift of lower pattern
//    parameter lower_spacing         = 4,       // Distance between lower-pattern stars
//    parameter clb_in_cb_out         = 4,


//    localparam W_selected_ceil_in = ((W*fc_in+99)/100),
//    localparam W_selected_ceil_out = ((W*fc_out +99)/100),
//    logic start_col_lower = (clb_output_cb_in - 1) * (W_selected_ceil_in - overlapping_factor) + W_selected_ceil_in + lower_shift,
//    logic total_rows = clb_output_cb_in + clb_in_cb_out,
//    localparam place_mux = 0
    
////    parameter SEL_W = (W_selected_ceil < 1)? 1 : $clog2(W_selected_ceil)

   
//)(
////   input  logic [SEL_W-1:0] select,
   
//    inout  logic [(W - 1) :0] routing_fabric,// ceilling to ensure bit width
//    input  logic [clb_output_cb_in - 1 : 0] W_input_logic,
//    output logic [total_rows*W - 1 : 0] E_output_logic
//);

//    genvar i, j, k;
//    int row, pos;


//    generate
//        for (i = 0; i < total_rows; i++)   // in and out  horizontal
//            begin : CB_rows
           
//              for (j = 0; j < W  ; j++) 
//                    begin : cb_in_to_W_muxes
//                        place_mux = 1'b0;
                       
//                       if ((i < clb_output_cb_in) && (j >= i*(W_selected_ceil_in - overlapping_factor)) && (j < i * (W_selected_ceil_in - overlapping_factor) + W_selected_ceil_in))
//                             place_mux = 1'b1;
                   
                             
//                       if (i >= clb_output_cb_in)
//                            begin
//                                row = i - clb_output_cb_in;
                                
//                                for (k = 0; k < W_selected_ceil_out  ; k++) 
//                                    begin : cb_out_to_W_muxes
//                                        pos = start_col_lower + row + k * lower_spacing;
                                        
//                                         if (j == pos) place_mux = 1'b1;
//                                    end
//                            end 
//                            if (place_mux == 1)
//                                begin
//                                    mux_2  inputMuxes(.A(W_input_logic[i]),.B(routing_fabric[j]),.S(select[j]),.O(routing_fabric[j]));
//                                end
//                        end               
//            end
//    endgenerate
                
// endmodule
 
 
 
 
 

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
////     generate
////        for (i = 0; i < total_rows; i++)   // in and out  horizontal
////            begin : CB_INPUT_rows
////              for (j = i; j < W_selected_ceil  ; j++) 
////                    begin : CB_routing_inout_coloumns
//////                        assign routing_fabric[j] = (select)? W_input_logic[i] : routing_fabric[j];
////                          mux_2  inputMuxes(.A(W_input_logic[i]),.B(routing_fabric[j]),.S(select[j]),.O(routing_fabric[j]));                
////                    end
////            end
        
        
                
////        for (k = CB_output_width; k > 0; k--)   ///fc can be changed to output fc later on
////            begin : CB_outPUT_rows
////              for (j = W; j > W_selected_ceil   ; j = j - W_selected_ceil)   
////                    begin : CB_routing_inout_coloumns
////                        assign E_output_logic[k] = (select)? routing_fabric[j] : E_output_logic[k];
////                    end
////            end
////    endgenerate
 
 
 
 
 
 
 
//// //                        assign routing_fabric[j] = (select)? W_input_logic[i] : routing_fabric[j];
//////                          mux_2  inputMuxes(.A(W_input_logic[i]),.B(routing_fabric[j]),.S(select[j]),.O(routing_fabric[j]));  
 
 
 
 
 
 
 module ConnectionBox #(
    parameter int W                  = 40,  // vertical inout lines
    parameter int fc_in              = 7,   // % of W lines each upper line touches (7  -> 3 muxes at W=40)
    parameter int overlapping_factor = 1,   // columns shared by consecutive upper rows
    parameter int clb_output_cb_in   = 8,   // upper (input) horizontal lines
    parameter int fc_out             = 10,  // % of W lines each lower line touches (10 -> 4 muxes at W=40)
    parameter int lower_shift        = 0,   // empty columns between last upper mux and first lower mux
    parameter int lower_spacing      = 2,   // empty W lines between two muxes on one lower line
    parameter int clb_in_cb_out      = 4,   // lower (output) horizontal lines

    localparam int W_selected_ceil_in  = (W*fc_in  + 99)/100,
    localparam int W_selected_ceil_out = (W*fc_out + 99)/100,
    localparam int total_rows          = clb_output_cb_in + clb_in_cb_out,
    localparam int upper_stride        = W_selected_ceil_in - overlapping_factor,
    localparam int lower_pitch         = lower_spacing + 1,   // empty lines + the mux column itself
    localparam int start_col_lower     = (clb_output_cb_in - 1)*upper_stride
                                         + W_selected_ceil_in + lower_shift,
    localparam int last_col_upper      = (clb_output_cb_in - 1)*upper_stride + W_selected_ceil_in - 1,
    localparam int last_col_lower      = start_col_lower + (clb_in_cb_out - 1)
                                         + (W_selected_ceil_out - 1)*lower_pitch
)(
    input logic                         cfg_flag,
    inout  logic  [W-1:0]               routing_fabric,   // vertical lines
    input  logic [clb_output_cb_in-1:0] W_input_logic,    // upper horizontal lines
    output logic  [clb_in_cb_out-1:0]   E_output_logic,   // lower horizontal lines
    input  logic [total_rows*W-1:0]     select
);

    // elaboration-time sanity checks
    if (overlapping_factor >= W_selected_ceil_in) begin : chk_overlap
        $error("overlapping_factor (%0d) must be < muxes per upper row (%0d)",
               overlapping_factor, W_selected_ceil_in);
    end
    if (last_col_upper >= W) begin : chk_upper
        $warning("upper rows reach column %0d but W = %0d; muxes past W are dropped",
                 last_col_upper, W);
    end
    if (last_col_lower >= W) begin : chk_lower
        $warning("lower rows reach column %0d but W = %0d; muxes past W are dropped",
                 last_col_lower, W);
    end

    // 1 if a mux belongs at (row i, column j)
    function automatic bit place_mux(input int i, input int j);
        int row, pos;
        if (i < clb_output_cb_in) begin
            return (j >= i*upper_stride) && (j < i*upper_stride + W_selected_ceil_in);
        end else begin
            row = i - clb_output_cb_in;
            for (int k = 0; k < W_selected_ceil_out; k++) begin
                pos = start_col_lower + row + k*lower_pitch;
                if (j == pos) return 1'b1;
            end
            return 1'b0;
        end
    endfunction

    genvar i, j;
    generate
        for (i = 0; i < total_rows; i++) begin : CB_rows
            for (j = 0; j < W; j++) begin : CB_cols

                localparam bit PLACE_MUX = place_mux(i, j);

                if (PLACE_MUX) begin : g_mux
                    if (i < clb_output_cb_in) begin : g_drive
                    
                        logic In_ConnectionBox_sel_latch;
                        DLatch In_ConnectionBox_sel( .d(select[i*W + j]), .enable(cfg_flag),.q( In_ConnectionBox_sel_latch ) );

                    
                        // upper horizontal line i -> vertical line j
                        mux_2 u_mux (
                            .I0(routing_fabric[j]),
                            .I1(W_input_logic[i]),
                            .S(In_ConnectionBox_sel_latch),
                            .O(routing_fabric[j])
                        );
                    end else begin : g_sense
                        localparam int row = i - clb_output_cb_in;
                        // vertical line j -> lower horizontal line
                        
                        logic out_ConnectionBox_sel_latch;
                        DLatch out_ConnectionBox_sel( .d(select[i*W + j]), .enable(cfg_flag),.q( out_ConnectionBox_sel_latch ) );


                        mux_2 u_mux (
                            .I0(E_output_logic[row]),
                            .I1(routing_fabric[j]),
                            .S(out_ConnectionBox_sel_latch),
                            .O(E_output_logic[row])
                        );
                    end
                end
                // PLACE_MUX == 0: lines cross without touching
            end
        end
    endgenerate

endmodule
 
 
 
 
 
 
 
 
 
 