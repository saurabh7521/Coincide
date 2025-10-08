// This module implements a configurable depth pipeline for an input signal.
// It uses an array of D flip-flops to shift the input through multiple stages,
// producing a delayed output.

module pipeline #(
    parameter DEPTH = 1 // Depth of the pipeline
) (
    input wire clk,  // Clock input
    input wire in,   // Input signal
    output wire out  // Output signal
);

    // Ensure DEPTH is at least 1
    generate
        if (DEPTH <= 0) begin
            $error("DEPTH must be greater than 0"); // Error if DEPTH is not valid
        end
    endgenerate

    // Array of D flip-flops for the pipeline stages
    reg [DEPTH-1:0] pipe;

    integer i;

    // Sequential logic to shift the input through the pipeline stages
    always @(posedge clk) begin
        pipe[0] <= in; // Input goes into the first stage
        for (i = 1; i < DEPTH; i = i + 1) begin
            pipe[i] <= pipe[i-1]; // Shift the values through the pipeline
        end
    end

    // Output the last stage of the pipeline
    assign out = pipe[DEPTH-1];

endmodule
