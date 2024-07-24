module edge_detector_tb;
    reg clk;
    reg in;
    wire out;

    // Instantiate the edge_detector module
    edge_detector #(.RISE(1), .FALL(0)) uut (
        .clk(clk),
        .in(in),
        .out(out)
    );

    // Generate clock signal
    always #5 clk = ~clk;

    initial begin
        // Initialize input signal
        clk = 0;
        in = 0;
       
        // Apply test cases
        #10 in = 1;  // Rising edge
        #10 in = 0;  // Falling edge
        #10 in = 1;  // Rising edge
        #10 in = 0;  // Falling edge

        // Add more test cases if needed
        #10 in = 1;  // Rising edge
        #10 in = 0;  // Falling edge

        // Finish the simulation after 200 time units
        #200 $finish;
    end
    
    initial begin
    $monitor("Time: %d, in: %b, out: %b", $time, in, out);
  end
endmodule