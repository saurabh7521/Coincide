/*
   Parameters:
     STAGES = 4
*/
module reset_conditioner (
    input clk,        // Clock input
    input in,         // Asynchronous reset input
    output reg out    // Synchronous reset output
);

    // Local parameter for the number of stages in the shift register
    localparam STAGES = 3'h4;

    // Register to hold the shift register stages
    reg [3:0] M_stage_d, M_stage_q = 4'hf;  // Initialize with all 1's (reset condition)

    // Combinational logic
    always @* begin
        M_stage_d = M_stage_q;  // Default assignment to prevent latches
        
        // Shift register logic
        // Shift the stages to the right, introducing a 0 at the MSB
        M_stage_d = {M_stage_q[0+2-:3], 1'h0};
        
        // Output the MSB of the shift register
        out = M_stage_q[3+0-:1];
    end

    // Sequential logic
    always @(posedge clk) begin
        if (in == 1'b1) begin
            // If the asynchronous reset input is high, reset all stages to 1
            M_stage_q <= 4'hf;
        end else begin
            // Otherwise, update the stages with the shifted value
            M_stage_q <= M_stage_d;
        end
    end

endmodule