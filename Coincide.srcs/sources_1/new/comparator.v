// This module compares a 4-bit input with a bitmask and increments a counter if all bits are high.
// It includes a sleep state to prevent multiple counts for the same event, controlled by a user-specified length.
// The module uses a clock and reset input to manage state transitions and counter increments.

module comparator (
    input wire clk,        // Clock input
    input wire rst,        // Reset input
    input wire [3:0] pins, // Connects to pins.q at top level, bitmasked for specific comparisons
    input wire [3:0] length, // User-specified pulse length
    output reg incr        // 1-bit output that increments top-level counters
);

    // State Definitions
    localparam COMPARE = 1'b0; // State for comparing inputs
    localparam SLEEP = 1'b1;   // State for sleeping (preventing multiple counts)

    // State Register
    reg state;

    // Counter Register for tracking sleep duration
    reg [3:0] ctr;

    // State and Counter Transition Logic
    always @(posedge clk or posedge rst) begin
        incr <= 0; // Default output to LOW each clock cycle
        
        if (rst) begin
            state <= COMPARE; // Reset to COMPARE state
            ctr <= 0;         // Reset counter
        end else begin
            case (state)
                COMPARE: begin
                    if (&pins) begin // If all input pins are HIGH
                        incr <= 1;   // Set output HIGH to increment counter
                        state <= SLEEP; // Transition to SLEEP state
                        ctr <= 0;    // Reset the counter for sleep duration
                    end
                end

                SLEEP: begin
                    if (ctr == length - 1) begin // If sleep duration is complete
                        ctr <= 0;    // Reset counter
                        state <= COMPARE; // Return to COMPARE state
                    end else begin
                        ctr <= ctr + 1; // Increment sleep counter
                    end
                end
            endcase
        end
    end

endmodule