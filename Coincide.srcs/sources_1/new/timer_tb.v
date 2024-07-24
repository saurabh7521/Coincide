module timer_tb;
  reg clk, rst;
  wire maxval;
  wire [7:0] value;

  // Instantiate the timer module with parameters
  timer #(.SIZE(8), .DIV(0), .TOP(255), .UP(1)) uut (
    .clk(clk),
    .rst(rst),
    .maxval(maxval),
    .value(value)
  );

  // Generate clock signal
  always #5 clk = ~clk;

  initial begin
    // Initialize inputs
    clk = 0;
    rst = 1;

    // Reset the system
    #10 rst = 0;

    // Wait for the timer to reach the maximum value
    #10000 $finish; // Increase the simulation time
  end

  initial begin
    $monitor("Time: %d, value: %d, maxval: %b", $time, value, maxval);
  end
endmodule