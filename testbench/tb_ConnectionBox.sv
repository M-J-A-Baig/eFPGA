`timescale 1ns/1ps
 
// Mux-site map of ConnectionBox, two blocks side by side (no gap):
//   left  W columns : north -> south block (u_n2s)
//   right W columns : south -> north block (u_s2n)
//   '*' = a mux_2 is placed at (row, column), ' ' = the lines cross without touching
// Written to sv_map.txt, 2*W characters per row.
//
// Select bit of the mux at (row, col) in either block is select_xxx[row*W + col]
//   rows 0 .. CLB_OUTPUT_CB_IN-1   : upper muxes, row = W_input_logic index
//   rows CLB_OUTPUT_CB_IN .. end   : lower muxes, E_output_logic index = row - CLB_OUTPUT_CB_IN
 
module tb_ConnectionBox;
 
    localparam int W                  = 36;
    localparam int FC_IN              = 7;    // ceil(40*7/100)  = 3 muxes per upper row
    localparam int OVERLAPPING_FACTOR = 1;
    localparam int CLB_OUTPUT_CB_IN   = 8;
    localparam int FC_OUT             = 10;   // ceil(40*10/100) = 4 muxes per lower row
    localparam int LOWER_SHIFT        = 0;
    localparam int LOWER_SPACING      = 2;    // empty lines between lower muxes (pitch 3, as in the C code)
    localparam int CLB_IN_CB_OUT      = 4;
 
    localparam int TOTAL_ROWS  = CLB_OUTPUT_CB_IN + CLB_IN_CB_OUT;
    localparam int MUX_PER_UP  = (W*FC_IN  + 99)/100;
    localparam int MUX_PER_LOW = (W*FC_OUT + 99)/100;
    localparam int EXPECTED    = 2*(CLB_OUTPUT_CB_IN*MUX_PER_UP + CLB_IN_CB_OUT*MUX_PER_LOW);   // two blocks
 
    localparam int N2S = 0;
    localparam int S2N = 1;
 
    logic                        cfg_flag      = 1'b0;
    logic [W-1:0]                N_in          = '0;
    logic [W-1:0]                S_in          = '0;
    wire  [W-1:0]                S_out;
    wire  [W-1:0]                N_out;
    logic [CLB_OUTPUT_CB_IN-1:0] W_input_logic = '0;
    wire  [CLB_IN_CB_OUT-1:0]    E_output_logic;
    logic [TOTAL_ROWS*W-1:0]     select_N2S    = '0;
    logic [TOTAL_ROWS*W-1:0]     select_S2N    = '0;
 
    ConnectionBox #(
        .W                 (W),
        .fc_in             (FC_IN),
        .overlapping_factor(OVERLAPPING_FACTOR),
        .clb_output_cb_in  (CLB_OUTPUT_CB_IN),
        .fc_out            (FC_OUT),
        .lower_shift       (LOWER_SHIFT),
        .lower_spacing     (LOWER_SPACING),
        .clb_in_cb_out     (CLB_IN_CB_OUT)
    ) dut (
        .cfg_flag             (cfg_flag),
        .N_routing_fabric_in  (N_in),
        .S_routing_fabric_out (S_out),
        .select_N2S           (select_N2S),
        .S_routing_fabric_in  (S_in),
        .N_routing_fabric_out (N_out),
        .select_S2N           (select_S2N),
        .W_input_logic        (W_input_logic),
        .E_output_logic       (E_output_logic)
    );
 
    // One load pulse: every latch copies its select bit, then holds when cfg_flag drops.
    task automatic cfg_pulse();
        cfg_flag = 1'b1;
        #1;
        cfg_flag = 1'b0;
        #1;
    endtask
 
    // Set the select bit of ONE placed mux in one block (dir = N2S or S2N) and load it.
    // The other select bits keep their values, so the other latches reload what they already hold.
    task automatic set_sel(input int dir, input int row, input int col, input bit val);
        bit site;
        if (row < 0 || row >= TOTAL_ROWS || col < 0 || col >= W) begin
            $display("set_sel: (%0d,%0d) is out of range, ignored", row, col);
            return;
        end
        site = (dir == N2S) ? dut.u_n2s.place_mux(row, col) : dut.u_s2n.place_mux(row, col);
        if (!site) begin
            $display("set_sel: no mux at (%0d,%0d) in this block, ignored", row, col);
            return;
        end
        if (dir == N2S) select_N2S[row*W + col] = val;
        else            select_S2N[row*W + col] = val;
        cfg_pulse();
    endtask
 
    // Load 0 into every latch of both blocks.
    task automatic clear_all_sel();
        select_N2S = '0;
        select_S2N = '0;
        cfg_pulse();
    endtask
 
    int errors = 0;
    task automatic check(input string what, input logic got, input logic want);
        if (got === want) $display("PASS: %s = %b", what, got);
        else begin
            $display("FAIL: %s = %b (expected %b)", what, got, want);
            errors++;
        end
    endtask
 
    int fd;
    int count;
    bit hit;
 
    initial begin
        // ---------------- site map ----------------
        fd    = $fopen("sv_map.txt", "w");
        count = 0;
        for (int r = 0; r < TOTAL_ROWS; r++) begin
            for (int c = 0; c < W; c++) begin          // left block: north -> south
                hit = dut.u_n2s.place_mux(r, c);
                if (hit) count++;
                $fwrite(fd, "%c", hit ? "*" : " ");
            end
            for (int c = 0; c < W; c++) begin          // right block: south -> north
                hit = dut.u_s2n.place_mux(r, c);
                if (hit) count++;
                $fwrite(fd, "%c", hit ? "*" : " ");
            end
            $fwrite(fd, "\n");
        end
        $fclose(fd);
 
        $display("Mux sites found: %0d (expected %0d)", count, EXPECTED);
        if (count == EXPECTED) $display("PASS: site count matches fc_in / fc_out for both blocks");
        else                   $display("FAIL: some sites are missing (check the W warnings)");
        $display("Map written to sv_map.txt");
 
        // ---------------- functional checks ----------------
        clear_all_sel();                                   // every latch = 0
        check("idle S_out[0] follows N_in[0]", S_out[0], N_in[0]);
        check("idle N_out[0] follows S_in[0]", N_out[0], S_in[0]);
        check("idle E_output_logic[0] released", E_output_logic[0], 1'bz);
 
        // upper mux, north->south block: W_input_logic[0] -> track 0
        W_input_logic[0] = 1'b1;
        set_sel(N2S, 0, 0, 1'b1);
        check("N2S upper (0,0) on: S_out[0]", S_out[0], 1'b1);
        check("N2S upper (0,0) on: N_out[0] untouched", N_out[0], 1'b0);
 
        // same upper line into the south->north block
        set_sel(S2N, 0, 0, 1'b1);
        check("S2N upper (0,0) on: N_out[0]", N_out[0], 1'b1);
 
        // two muxes on one column (column 2 has rows 0 and 1): only row 1 is on
        W_input_logic[1] = 1'b1;
        set_sel(N2S, 1, 2, 1'b1);
        check("N2S column 2, row 1 on, row 0 off: S_out[2]", S_out[2], 1'b1);
 
        // lower mux: track 17 -> E_output_logic[0]
        N_in[17] = 1'b1;
        set_sel(N2S, CLB_OUTPUT_CB_IN, 17, 1'b1);
        check("N2S lower (8,17) on: E_output_logic[0]", E_output_logic[0], 1'b1);
 
        // track with no upper mux passes straight through
        N_in[35] = 1'b1;
        #1;
        check("column 35 has no mux: S_out[35]", S_out[35], 1'b1);
 
        $display("Checks failed: %0d", errors);
        $finish;
    end
 
endmodule
 
 