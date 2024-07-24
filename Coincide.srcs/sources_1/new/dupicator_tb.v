module duplicator_tb;
  reg clk, rst, pulse;
  reg [3:0] length;
  wire out;

  // Instantiate the duplicator module
  duplicator uut (
    .clk(clk),
    .rst(rst),
    .pulse(pulse),
    .length(length),
    .out(out)
  );

  // Generate clock signal
  always #5 clk = ~clk;

  initial begin
    // Initialize inputs
    clk = 0;
    rst = 1;
    pulse = 0;
    length = 2;

    // Reset the system
    #10 rst = 0;

    // Apply test vectors
    #10 pulse = 1; // Generate pulse
    #10 pulse = 0;
    #50 $finish;
  end

  initial begin
    $monitor("Time: %d, pulse: %b, out: %b", $time, pulse, out);
  end
endmodule