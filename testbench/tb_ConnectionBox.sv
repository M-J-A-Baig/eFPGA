`timescale 1ns/1ps

// Prints the mux-site map of ConnectionBox in the same format as the C program.
//   '*' = a mux_2 is placed at (row, column)
//   ' ' = the lines cross without touching
// Output goes to sv_map.txt, W characters per row, so it can be diffed
// against the C program's output.
//
// Select bit of the mux at (row, col) is select[row*W + col]
//   rows 0 .. CLB_OUTPUT_CB_IN-1   : upper muxes, row = W_input_logic index
//   rows CLB_OUTPUT_CB_IN .. end   : lower muxes, E_output_logic index = row - CLB_OUTPUT_CB_IN

module tb_connection_box_map;

    // Same values as the C program. fc_in / fc_out are percentages here.
    localparam int W                  = 40;
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
    localparam int EXPECTED    = CLB_OUTPUT_CB_IN*MUX_PER_UP + CLB_IN_CB_OUT*MUX_PER_LOW;

    wire  [W-1:0]                routing_fabric;
    logic [CLB_OUTPUT_CB_IN-1:0] W_input_logic = '0;
    wire  [CLB_IN_CB_OUT-1:0]    E_output_logic;
    logic [TOTAL_ROWS*W-1:0]     select        = '0;

    // >>>>>>>>>>>>>>>> ADDED (1/4): cfg_flag and a testbench driver for the tracks <<<<<<<<<<<<<<<<
    logic         cfg_flag   = 1'b0;     // 1 = latches follow select, 0 = latches hold
    logic [W-1:0] fabric_drv = 'z;       // lets the testbench drive tracks (z = not driving)
    assign routing_fabric = fabric_drv;
    // >>>>>>>>>>>>>>>> END ADDED (1/4) <<<<<<<<<<<<<<<<

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
        // >>>>>>>>>>>>>>>> ADDED (2/4): cfg_flag connection <<<<<<<<<<<<<<<<
        .cfg_flag       (cfg_flag),
        // >>>>>>>>>>>>>>>> END ADDED (2/4) <<<<<<<<<<<<<<<<
        .routing_fabric (routing_fabric),
        .W_input_logic  (W_input_logic),
        .E_output_logic (E_output_logic),
        .select         (select)
    );

    // >>>>>>>>>>>>>>>> ADDED (3/4): tasks to program muxes one at a time <<<<<<<<<<<<<<<<

    // One load pulse: every latch copies its select bit, then holds when cfg_flag drops.
    task automatic cfg_pulse();
        cfg_flag = 1'b1;
        #1;
        cfg_flag = 1'b0;
        #1;
    endtask

    // Set the select bit of ONE placed mux and load it.
    // The other select bits keep their current values, so the other latches reload
    // the same value they already hold and are not disturbed.
    task automatic set_sel(input int row, input int col, input bit val);
        if (row < 0 || row >= TOTAL_ROWS || col < 0 || col >= W)
            $display("set_sel: (%0d,%0d) is out of range, ignored", row, col);
        else if (!dut.place_mux(row, col))
            $display("set_sel: no mux at (%0d,%0d), ignored", row, col);
        else begin
            select[row*W + col] = val;    // same index the DUT uses: select[i*W + j]
            cfg_pulse();
        end
    endtask

    // Load 0 into every latch.
    task automatic clear_all_sel();
        select = '0;
        cfg_pulse();
    endtask

    // >>>>>>>>>>>>>>>> END ADDED (3/4) <<<<<<<<<<<<<<<<

    int fd;
    int count;
    bit hit;

    initial begin
        fd    = $fopen("sv_map.txt", "w");
        count = 0;

        for (int r = 0; r < TOTAL_ROWS; r++) begin
            for (int c = 0; c < W; c++) begin
                // the same function that decides where generate places a mux_2
                hit = dut.place_mux(r, c);
                if (hit) count++;
                $fwrite(fd, "%c", hit ? "*" : " ");
            end
            $fwrite(fd, "\n");
        end
        $fclose(fd);

        $display("Mux sites found: %0d (expected %0d)", count, EXPECTED);
        if (count == EXPECTED) $display("PASS: site count matches fc_in / fc_out");
        else                   $display("FAIL: some sites are missing (check the W warnings)");
        $display("Map written to sv_map.txt");

        // >>>>>>>>>>>>>>>> ADDED (4/4): example, program muxes one at a time <<<<<<<<<<<<<<<<
        clear_all_sel();                              // load 0 into every latch
        $display("after clear : fabric[0]=%b  fabric[17]=%b  E[0]=%b",
                 routing_fabric[0], routing_fabric[17], E_output_logic[0]);

        // upper mux (row 0, col 0): W_input_logic[0] -> routing_fabric[0]
        W_input_logic[0] = 1'b1;
        set_sel(0, 0, 1'b1);
        $display("upper (0,0) on : fabric[0]=%b  (expect 1)", routing_fabric[0]);

        // lower mux (row 8, col 17): routing_fabric[17] -> E_output_logic[0]
        fabric_drv[17] = 1'b1;
        set_sel(8, 17, 1'b1);
        $display("lower (8,17) on: E[0]=%b  (expect 1)", E_output_logic[0]);
        // >>>>>>>>>>>>>>>> END ADDED (4/4) <<<<<<<<<<<<<<<<

        $finish;
    end

endmodule