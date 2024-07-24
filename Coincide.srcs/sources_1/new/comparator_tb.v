module comparator_tb;
  reg clk, rst;
  reg [3:0] pins, length;
  wire incr;

  // Instantiate the comparator module
  comparator uut (
    .clk(clk),
    .rst(rst),
    .pins(pins),
    .length(length),
    .incr(incr)
  );

  // Generate clock signal
  always #5 clk = ~clk;

  initial begin
    // Initialize inputs
    clk = 0;
    rst = 1;
    pins = 4'b0000;
    length = 2;

    // Reset the system
    #10 rst = 0;

    // Apply test vectors
    #10 pins = 4'b1111; // Should set incr to 1
    #10 pins = 4'b0000; // Should reset incr to 0 after length cycles
    #10 pins = 4'b1111;
    #10 $finish;
  end

  initial begin
    $monitor("Time: %d, pins: %b, incr: %b", $time, pins, incr);
  end
endmodule