`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////////
// ConnectionBox
//   Two blocks of vertical tracks side by side, crossed by the SAME horizontal lines:
//     left  block : u_n2s, data enters from the north, leaves to the south (select_N2S)
//     right block : u_s2n, data enters from the south, leaves to the north (select_S2N)
//   W_input_logic  (upper horizontal lines) can be attached to a track in either block.
//   E_output_logic (lower horizontal lines) can listen to a track in either block.
//   Marked  // CHANGED  : differences from ConnectionBox_v3.sv (the one-way core is identical).
////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////
// One-way fabric
////////////////////////////////////////////////////////////////////////////////////
module ConnectionBox_oneway #(
    parameter int W                  = 36,  // vertical lines
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
    input  logic                        cfg_flag,
    input  wire  [W-1:0]                track_in,         // vertical lines entering the box
    output wire  [W-1:0]                track_out,        // vertical lines leaving the box
    input  logic [clb_output_cb_in-1:0] W_input_logic,    // upper horizontal lines
    output wire  [clb_in_cb_out-1:0]    E_output_logic,   // lower horizontal lines
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

    // nearest upper row above row i that has a mux on column j, or -1 if none
    function automatic int prev_upper_row(input int i, input int j);
        for (int r = i - 1; r >= 0; r--) begin
            if (place_mux(r, j)) return r;
        end
        return -1;
    endfunction

    // last upper row with a mux on column j, or -1 if the column has no upper mux
    function automatic int last_upper_row(input int j);
        return prev_upper_row(clb_output_cb_in, j);
    endfunction

    // tap[i*W + j] = output of the upper mux at (i, j)
    wire [clb_output_cb_in*W-1:0] tap;

    genvar i, j;

    // Track ends.
    // No upper mux on column j -> the track simply passes through (one assign).
    // Otherwise the track leaves from the last mux on that column.
    generate
        for (j = 0; j < W; j++) begin : CB_track_ends
            localparam int LAST = last_upper_row(j);
            if (LAST < 0) begin : g_no_mux
                assign track_out[j] = track_in[j];
            end else begin : g_from_mux
                assign track_out[j] = tap[LAST*W + j];
            end
        end
    endgenerate

    generate
        for (i = 0; i < total_rows; i++) begin : CB_rows
            for (j = 0; j < W; j++) begin : CB_cols

                localparam bit PLACE_MUX = place_mux(i, j);

                if (PLACE_MUX) begin : g_mux
                    if (i < clb_output_cb_in) begin : g_writeOnRoute

                        // muxes on one column are chained mux to mux.
                        // The first one takes the incoming track, the others take the mux above them.
                        localparam int PREV     = prev_upper_row(i, j);
                        localparam int PREV_BIT = (PREV < 0) ? 0 : PREV*W + j;   // keeps the index in range

                        logic In_ConnectionBox_sel_latch;
                        DLatch In_ConnectionBox_sel( .d(select[i*W + j]), .enable(cfg_flag), .q(In_ConnectionBox_sel_latch) );

                        // upper horizontal line i -> vertical line j
                        mux_2 u_mux (
                            .I0((PREV < 0) ? track_in[j] : tap[PREV_BIT]),
                            .I1(W_input_logic[i]),
                            .S(In_ConnectionBox_sel_latch),
                            .O(tap[i*W + j])
                        );
                    end else begin : g_readFromRoute
                        localparam int row = i - clb_output_cb_in;

                        logic out_ConnectionBox_sel_latch;
                        DLatch out_ConnectionBox_sel( .d(select[i*W + j]), .enable(cfg_flag), .q(out_ConnectionBox_sel_latch) );

                        // vertical line j -> lower horizontal line
                        mux_2 u_mux (
                            .I0(1'bz),
                            .I1(track_in[j]),
                            .S(out_ConnectionBox_sel_latch),
                            .O(E_output_logic[row])
                        );
                    end
                end
                // PLACE_MUX == 0: nothing placed here
            end
        end
    endgenerate

endmodule


////////////////////////////////////////////////////////////////////////////////////
// Top level: two blocks of tracks (opposite directions) crossed by the same horizontal lines
////////////////////////////////////////////////////////////////////////////////////
module ConnectionBox #(
    parameter int W                  = 40,
    parameter int fc_in              = 7,
    parameter int overlapping_factor = 1,
    parameter int clb_output_cb_in   = 8,
    parameter int fc_out             = 10,
    parameter int lower_shift        = 0,
    parameter int lower_spacing      = 2,
    parameter int clb_in_cb_out      = 4,

    localparam int total_rows = clb_output_cb_in + clb_in_cb_out
)(
    input  logic                        cfg_flag,

    // left block: north -> south
    input  wire  [W-1:0]                N_routing_fabric_in,
    output wire  [W-1:0]                S_routing_fabric_out,
    input  logic [total_rows*W-1:0]     select_N2S,

    // right block: south -> north
    input  wire  [W-1:0]                S_routing_fabric_in,
    output wire  [W-1:0]                N_routing_fabric_out,
    input  logic [total_rows*W-1:0]     select_S2N,

    // CHANGED: the horizontal lines cross both blocks, so both blocks share them
    input  logic [clb_output_cb_in-1:0] W_input_logic,
    output wire  [clb_in_cb_out-1:0]    E_output_logic
);

    ConnectionBox_oneway #(
        .W(W), .fc_in(fc_in), .overlapping_factor(overlapping_factor),
        .clb_output_cb_in(clb_output_cb_in), .fc_out(fc_out),
        .lower_shift(lower_shift), .lower_spacing(lower_spacing),
        .clb_in_cb_out(clb_in_cb_out)
    ) u_n2s (
        .cfg_flag      (cfg_flag),
        .track_in      (N_routing_fabric_in),
        .track_out     (S_routing_fabric_out),
        .W_input_logic (W_input_logic),       // CHANGED: shared
        .E_output_logic(E_output_logic),      // CHANGED: shared
        .select        (select_N2S)
    );

    ConnectionBox_oneway #(
        .W(W), .fc_in(fc_in), .overlapping_factor(overlapping_factor),
        .clb_output_cb_in(clb_output_cb_in), .fc_out(fc_out),
        .lower_shift(lower_shift), .lower_spacing(lower_spacing),
        .clb_in_cb_out(clb_in_cb_out)
    ) u_s2n (
        .cfg_flag      (cfg_flag),
        .track_in      (S_routing_fabric_in),
        .track_out     (N_routing_fabric_out),
        .W_input_logic (W_input_logic),       // CHANGED: shared
        .E_output_logic(E_output_logic),      // CHANGED: shared
        .select        (select_S2N)
    );

endmodule