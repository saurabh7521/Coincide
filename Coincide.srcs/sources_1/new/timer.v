// A custom timer with 1-bit output that is HIGH for one cycle when the timer reaches its maximum value.
// It is used to reset counters in the top-level module. The timer can be configured for up or down counting,
// with adjustable width, divisor, and maximum value.

module timer #(
    parameter SIZE = 32, // Width of the counter
    parameter DIV = 0,  // Number of bits to use as divisor
    //parameter TOP = 300_000_000,// Max value, 0 means no maximum
    parameter UP = 1    // Direction to count, 1 for up and 0 for down
)(
    input wire clk,     // Clock input
    input wire rst,     // Reset input
    output reg maxval,  // 1-bit output that goes HIGH at max value
    output reg [SIZE-1:0] value // Counter value output
);

    // Internal counter register, width is SIZE + DIV
    reg [SIZE+DIV-1:0] ctr;
    reg done;
   
    // Define the maximum value based on parameters
    localparam [SIZE+DIV-1:0] MAX_VALUE = 30_000_000; // Value when maxed out


    // Counter logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ctr <= 0;         // Reset internal counter
            value <= 0;       // Reset output value
            maxval <= 0;      // Reset maxval output
            done   <= 0;
        end else begin
            done <= (ctr == MAX_VALUE - 1);  // <-- pre-trigger
            maxval <= 0; // Default maxval to LOW            
            if (UP) begin // Up counter
                //done <= (ctr == MAX_VALUE);
                if (done) begin // Check if max value reached
                    ctr <= 0;    // Reset counter
                    maxval <= 1; // Set maxval HIGH
                end else begin
                    ctr <= ctr + 1; // Increment counter
                    
                end
            end    
            value <= ctr; // Set the output value
        end
    end

endmodule
