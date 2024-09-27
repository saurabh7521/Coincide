module au_top (
    input clk,          // 100MHz clock
    input rst_n,        // reset button
    output reg [7:0] led,   // 8 user controllable LEDs
    output wire tx,     // Transmission line
    input pulseA,         // external pulse input for A
    input pulseB        //external pulse input for B
);

    // Signal declarations
    wire rst;
    wire outA;           // Duplicator out for pulse A, comparator in
    wire outB;          //Duplicator out for pulse B
    reg [3:0] pins;     // Goes into the comparator
    wire incrA;         // Comes from comparator A increment the counting into the counts register
    wire incrB;          // Comes from comparator B increment the counting into the counts register
    wire incrAB;        //// Comes from comparator AB increment the counting into the counts register
    wire tmr_maxval;    // Timer has reached counting
    wire [31:0] timer_value; // Variable to hold timer value
    reg dupl_pulseA, dupl_pulseB;     // Pulse going into duplicator
    reg [3:0] compA_pins; // Pins that go into comparator A
    reg [3:0] compB_pins;   // Pins that go into comparator B
    reg [3:0] compAB_pins;   // Pins that go into comparator AB
    reg [31:0] countsA;  // Register to store the count of the A pulses
    reg [31:0] countsB;  // Register to store the count of the B pulses
    reg [31:0] countsAB;
    reg [31:0] counts_tempA;
    reg [31:0] counts_tempB;
    reg [31:0] counts_tempAB;
    reg [31:0] timestamp; // Timestamp when poll_flag is set
    reg [7:0] tx_data;  // Variable to send counter value
    reg poll_flag;      // Flag for counts_temp is ready to be transmitted
    reg new_data;       // Data ready for transmission
    wire busy;          // Transmission line busy transmitting
    reg [4:0] byte_counter; // Byte transmission counter
    reg [2:0] state;    // FSM state
    reg tmr_maxval_temp;

    // Reset signal is active high
    reset_conditioner reset_cond (
        .clk(clk),           // clock input
        .in(~rst_n),         // active-low reset input, inverted
        .out(rst)            // conditioned reset output
    );

    // Instantiating duplicator module
    duplicator duplA (
        .clk(clk),
        .rst(rst),
        .pulse(dupl_pulseA),
        .length(4'd10),
        .out(outA)
    );

    duplicator duplB (
        .clk(clk),
        .rst(rst),
        .pulse(dupl_pulseB),
        .length(4'd10),
        .out(outB)
    );
    // Instantiate a comparator module
    comparator compA (
        .clk(clk),
        .rst(rst),
        .pins(compA_pins),
        .length(4'd10),
        .incr(incrA)
    );

    comparator compB (
        .clk(clk),
        .rst(rst),
        .pins(compB_pins),
        .length(4'd10),
        .incr(incrB)
    );

    comparator compAB (
        .clk(clk),
        .rst(rst),
        .pins(compAB_pins),
        .length(4'd10),
        .incr(incrAB)
    );

    // Instantiate a timer module
    timer timer_inst (
        .clk(clk),
        .rst(rst),
        .maxval(tmr_maxval),
        .value(timer_value)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dupl_pulseA <= 0;
            dupl_pulseB <= 0;
            pins <= 0;
            compA_pins <= 0;
            compB_pins <= 0;
            compAB_pins <= 0;
            countsA <= 0;
            counts_tempA <= 0;
            countsB <= 0;
            counts_tempB <= 0;
            countsAB <= 0;
            counts_tempAB <= 0;
            poll_flag <= 0;
            state <= 3'b000;
            new_data <= 0;
            tx_data <= 8'b00000000;
            byte_counter <= 0;  // Initialize byte counter
            timestamp <= 0;     // Initialize timestamp
            led <= 8'b00000000;
        end else begin
            dupl_pulseA <= pulseA; // Putting the pulse A in the duplicator
            dupl_pulseB <= pulseB; //Putting pulse B into the duplicator
            pins[0] <= outA;      // Saving the duplicated pulse A into pins
            pins[1] <= outB;      //Saving the duplicated pulse B into pins
            compA_pins <= (pins | 4'b1110); // Passing bit masked
            compB_pins <= (pins | 4'b1101);
            compAB_pins <= (pins | 4'b1100);

            if (incrA) begin
                countsA <= countsA + 1; // Increment counts by 1 if incrA bit is high
            end

            if (incrB) begin
                countsB <= countsB + 1; // Increment counts by 1 if incrB bit is high
            end

            if (incrAB) begin
                countsAB <= countsAB + 1; // Increment counts by 1 if incrB bit is high
            end

            if (tmr_maxval) begin // If timer is complete
                //led<= tmr_maxval;
                tmr_maxval_temp <= tmr_maxval; //Save tmr_maxval flag for initiating transfer
                counts_tempA <= countsA;      //Save counts to a temp. variable for transmission
                counts_tempB <= countsB;
                counts_tempAB <= countsAB;
                timestamp <= timer_value; // Save current timer value as timestamp
                countsA <= 0;            //Reset counter to 0
                countsB <= 0;
                countsAB <= 0;
                poll_flag <= 1;  // Data ready flag to execute the transmission code below
                led <= ~led;    //Comlement led to check for duration of a second
            end

            new_data <= 0;  // Default state
            case (state)
                3'b000: begin // Idle state
                    if (poll_flag) begin
                        state <= 3'b001;  // Move to prepare transmission
                    end
                end
                3'b001: begin   // Prepare counter transmission
                    if (!busy) begin
                        case (byte_counter)
                            5'b00000: tx_data <= counts_tempA[7:0];
                            5'b00001: tx_data <= counts_tempA[15:8];
                            5'b00010: tx_data <= counts_tempA[23:16];
                            5'b00011: tx_data <= counts_tempA[31:24];
                            5'b00100: tx_data <= counts_tempB[7:0];
                            5'b00101: tx_data <= counts_tempB[15:8];
                            5'b00110: tx_data <= counts_tempB[23:16];
                            5'b00111: tx_data <= counts_tempB[31:24];
                            5'b01000: tx_data <= counts_tempAB[7:0];
                            5'b01001: tx_data <= counts_tempAB[15:8];
                            5'b01010: tx_data <= counts_tempAB[23:16];
                            5'b01011: tx_data <= counts_tempAB[31:24];
                            5'b01100: tx_data <= timestamp[7:0];
                            5'b01101: tx_data <= timestamp[15:8];
                            5'b01110: tx_data <= timestamp[23:16];
                            5'b01111: tx_data <= timestamp[31:24];
                            5'b10000: tx_data <= tmr_maxval_temp;
                        endcase
                        new_data <= 1;
                        state <= 3'b010;
                    end
                end
                3'b010: begin // Wait for transmission to complete
                    if (!busy) begin
                        byte_counter <= byte_counter + 1;
                        if (byte_counter == 5'b10000) begin
                            byte_counter <= 0;
                            state <= 3'b011;  // Move to clean up state
                        end else begin
                            state <= 3'b001;  // Continue sending current counter bytes
                        end
                    end
                end
                3'b011: begin
                    poll_flag <= 0;
                    counts_tempA <= 0;
                    counts_tempB <= 0;
                    counts_tempAB <= 0;
                    timestamp <= 0;
                    tmr_maxval_temp <= 0;
                    state <= 3'b000;
                end
                default: state <= 3'b000;
            endcase
        end
    end

    // Instantiating uart_tx module
    uart_tx #(
        .CLK_FREQ(100_000_000),
        .BAUD(9600)
    ) uart_tx_inst (
        .clk(clk),
        .rst(rst),
        .tx(tx),
        .block(1'b0),
        .busy(busy),
        .data(tx_data),
        .new_data(new_data)
    );

endmodule