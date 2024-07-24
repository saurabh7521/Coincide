module pipeline_tb;
  reg clk, in;
  wire out;

  // Instantiate the pipeline module
  pipeline #(.DEPTH(4)) uut (
    .clk(clk),
    .in(in),
    .out(out)
  );

  // Generate clock signal
  always #5 clk = ~clk;

  initial begin
    // Initialize inputs
    clk = 0;
    in = 0;

    // Apply test vectors
    #10 in = 1;
    #10 in = 0;
    #10 in = 1;
    #20 in = 0;
    #50 $finish;
  end

  initial begin
    $monitor("Time: %d, in: %b, out: %b", $time, in, out);
  end
endmodule