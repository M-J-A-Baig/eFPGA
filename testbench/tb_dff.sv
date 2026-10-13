
`timescale 1ns/1ns
`define Width 4

module testbench;
  reg clk;
  reg WE;
  reg SR;
  reg [`Width-1:0] d;
  wire [`Width -1:0] q;

  DFF #(`Width) dut(
    .clk(clk),
    .WE(WE),
    .SR(SR),
    .d(d),
    .q(q)
  );

  // 1. Clock Generation: 10ns period (5ns HIGH, 5ns LOW)
  always #5 clk = ~clk;
  integer i;

  // 2. Stimulus Process
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, testbench);

    // Monitor signal updates in stdout
    $monitor("Time=%0t | clk=%b SR=%b WE=%b d=%b -> q=%b", 
             $time, clk, SR, WE, d, q);

    clk = 0;
    WE  = 0;
    SR  = 0;
    d   = 0;

    #10;
    SR = 1; d = 4'b0001;      // Force reset active with d=1 to verify SR priority
    #10;
    SR = 0;             // Release reset

    #10;
    WE = 1; 
    //d = 4'b0010;      // Expect q = 1 on posedge clk
    for (i = 0; i < 5; i = i + 1) begin
      @(posedge clk);        // Wait for clock edge
      d = d + 1'b1;   // Apply vector
    end
    #10;
    d = 0;              // Expect q = 0 on posedge clk

    #10;
    WE = 0; d = 4'b0001;      // Changing d while WE=0; expect q to hold 0
    #10;

    WE = 1; d =  4'b0001;      // Enable write
    #10;                // q becomes 1
    SR = 1;             // Assert reset while WE is still active
    #10;                // SR should override WE, q becomes 0

    // End 
    #10;
    $finish;
  end

endmodule
