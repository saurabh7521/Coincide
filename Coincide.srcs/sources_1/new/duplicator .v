
// This module detects edges on an input pulse and duplicates the pulse for a user-specified duration.
// It uses an edge detector and a synchronizer to handle input pulse timing, managing state transitions 
// and pulse duplication with a simple state machine controlled by a clock and reset signal.

module duplicator (
    input wire clk,         // Clock input
    input wire rst,         // Reset input
    input wire pulse,       // Raw input pulse
    input wire [3:0] length,// User-specified pulse length
    output reg out          // Output to pins.d register
);

    // Edge Detector instance
    wire edge_out;
    edge_detector edge_inst (
        .clk(clk),
        .in(sync_out),
        .out(edge_out)
    );

    // Pipeline instance to synchronize the input pulse
    wire sync_out;
    pipeline #(1) sync_inst (
        .clk(clk),
        .in(pulse),
        .out(sync_out)
    );

    // State Definitions for the State Machine
    localparam [1:0]
        LISTEN = 2'b00, // State for listening for an edge
        PULSE  = 2'b01; // State for outputting the pulse

    // State and Counter Registers
    reg [1:0] state;     // Combined state variable
    reg [3:0] ctr;       // Single counter for pulse duration
    reg [3:0] length_reg;
    
    always @(posedge clk or posedge rst) begin
    if (rst)
        length_reg <= 0;
    else
        length_reg <= length - 1;
    end
    
    
    // State Machine and Output Logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ctr <= 0;         // Reset counter
            state <= LISTEN;  // Reset to LISTEN state
            out <= 0;         // Set output LOW
        end else begin
            case (state)
                LISTEN: begin
                    if (edge_out) begin
                        out <= 1;       // Set output HIGH
                        state <= PULSE; // Change state to PULSE
                        ctr <= 0;       // Reset counter
                    end else begin
                        out <= 0;       // If no edge detected, output remains LOW
                    end
                end

                PULSE: begin
                    if (ctr == length_reg) begin
                        out <= 0;       // Set output LOW after pulse duration
                        state <= LISTEN;// Return to LISTEN state
                    end else begin
                        out <= 1;       // Keep output HIGH during pulse duration
                        ctr <= ctr + 1; // Increment counter
                    end
                end

                default: state <= LISTEN; // Default state is LISTEN
            endcase
        end
    end
endmodule
