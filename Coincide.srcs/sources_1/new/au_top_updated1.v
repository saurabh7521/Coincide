module au_top (
    input clk,          // 100MHz clock
    input rst_n,        // reset button
    output reg [7:0] led,   // 8 user controllable LEDs
    output wire tx,     // Transmission line
    input pulseA,         // external pulse input for A
    input pulseB,        //external pulse input for B
    input pulseC        //external pulse input for C
);

    // Signal declarations
    wire rst;
    wire [3:0] out_duplicated_pulse;           // Duplicator out for pulses
    reg [3:0] pins;     // Goes into the comparator
    wire [5:0] incr;    // Vector that stores the increment values of comparators
    wire tmr_maxval;    // Timer has reached counting
    wire [31:0] timer_value; // Variable to hold timer value
    //Below are the pin registers taht are used to send the bitmasked data to comparators
    reg [3:0] compA_pins; // Pins that go into comparator A
    reg [3:0] compB_pins;   // Pins that go into comparator B
    reg [3:0] compC_pins;   // Pins that go into comparator C
    reg [3:0] compAB_pins;   // Pins that go into comparator AB
    reg [3:0] compBC_pins;   // Pins that go into comparator BC
    reg [3:0] compAC_pins;   // Pins that go into comparator AC
    //Below are the counts that store the coincidence count values and corresponding temporary variables
    //used in communication
    reg [31:0] countsA;  // Register to store the count of the A pulses
    reg [31:0] countsB;  // Register to store the count of the B pulses
    reg [31:0] countsC;  // Register to store the count of the C pulses
    reg [31:0] countsAB; // Register to store the count of the AB pulses
    reg [31:0] countsBC; // Register to store the count of the BC pulses
    reg [31:0] countsAC; // Register to store the count of the AC pulses
    reg [31:0] counts_tempA;
    reg [31:0] counts_tempB;
    reg [31:0] counts_tempC;
    reg [31:0] counts_tempAB;
    reg [31:0] counts_tempBC;
    reg [31:0] counts_tempAC;
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
        .pulse(pulseA),
        .length(4'd10),
        .out(out_duplicated_pulse[3])
    );

    duplicator duplB (
        .clk(clk),
        .rst(rst),
        .pulse(pulseB),
        .length(4'd10),
        .out(out_duplicated_pulse[2])
    );

    duplicator duplC (
        .clk(clk),
        .rst(rst),
        .pulse(pulseC),
        .length(4'd10),
        .out(out_duplicated_pulse[1])
    );

    // Instantiate a comparator module
    comparator compA (
        .clk(clk),
        .rst(rst),
        .pins(compA_pins),
        .length(4'd10),
        .incr(incr[5])
    );

    comparator compB (
        .clk(clk),
        .rst(rst),
        .pins(compB_pins),
        .length(4'd10),
        .incr(incr[4])
    );

    comparator compC (
        .clk(clk),
        .rst(rst),
        .pins(compC_pins),
        .length(4'd10),
        .incr(incr[3])
    );

    comparator compAB (
        .clk(clk),
        .rst(rst),
        .pins(compAB_pins),
        .length(4'd10),
        .incr(incr[2])
    );

    comparator compBC (
        .clk(clk),
        .rst(rst),
        .pins(compBC_pins),
        .length(4'd10),
        .incr(incr[1])
    );

    comparator compAC (
        .clk(clk),
        .rst(rst),
        .pins(compAC_pins),
        .length(4'd10),
        .incr(incr[0])
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
            countsA <= 0;
            counts_tempA <= 0;
            countsB <= 0;
            counts_tempB <= 0;
            countsC <= 0;
            counts_tempC <= 0;
            countsAB <= 0;
            counts_tempAB <= 0;
            countsBC <= 0;
            counts_tempBC <= 0;
            countsAC <= 0;
            counts_tempAC <= 0;
            poll_flag <= 0;
            state <= 3'b000;
            new_data <= 0;
            tx_data <= 8'b00000000;
            byte_counter <= 0;  // Initialize byte counter
            timestamp <= 0;     // Initialize timestamp
            led <= 8'b00000000;
        end else begin
            pins[0] <= out_duplicated_pulse[3];      // Saving the duplicated pulse A into pins
            pins[1] <= out_duplicated_pulse[2];      //Saving the duplicated pulse B into pins
            pins[2] <= out_duplicated_pulse[1];      //Saving the duplicated pulse C into pins
            compA_pins <= (pins | 4'b1110); // Passing bit masked
            compB_pins <= (pins | 4'b1101);
            compC_pins <= (pins | 4'b1011);
            compAB_pins <= (pins | 4'b1100);
            compBC_pins <= (pins | 4'b1001);
            compAC_pins <= (pins | 4'b1010);

            if (incr[5]) begin
                countsA <= countsA + 1; // Increment counts by 1 if compA detects all high bits
            end

            if (incr[4]) begin
                countsB <= countsB + 1; // Increment counts by 1 if compB detects all high bits
            end

            if (incr[3]) begin
                countsC <= countsC + 1; // Increment counts by 1 if compC detects all high bits
            end

            if (incr[2]) begin
                countsAB <= countsAB + 1; // Increment counts by 1 if compAB detects all high bits
            end

            if (incr[1]) begin
                countsBC <= countsBC + 1; // Increment counts by 1 if compBC detects all high bits
            end

            if (incr[0]) begin
                countsAC <= countsAC + 1; // Increment counts by 1 if compAC detects all high bits
            end

            if (tmr_maxval) begin // If timer is complete
                //led<= tmr_maxval;
                tmr_maxval_temp <= tmr_maxval; //Save tmr_maxval flag for initiating transfer
                counts_tempA <= countsA;      //Save counts to a temp. variable for transmission
                counts_tempB <= countsB;
                counts_tempC <= countsC;
                counts_tempAB <= countsAB;
                counts_tempBC <= countsBC;
                counts_tempAC <= countsAC;
                timestamp <= timer_value; // Save current timer value as timestamp
                countsA <= 0;            //Reset counter to 0
                countsB <= 0;
                countsC <= 0;
                countsAB <= 0;
                countsBC <= 0;
                countsAC <= 0;
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
                            //Transmitting counts of A
                            5'b00000: tx_data <= counts_tempA[7:0];
                            5'b00001: tx_data <= counts_tempA[15:8];
                            5'b00010: tx_data <= counts_tempA[23:16];
                            5'b00011: tx_data <= counts_tempA[31:24];
                            //Transmitting counts of B
                            5'b00100: tx_data <= counts_tempB[7:0];
                            5'b00101: tx_data <= counts_tempB[15:8];
                            5'b00110: tx_data <= counts_tempB[23:16];
                            5'b00111: tx_data <= counts_tempB[31:24];
                            //Transmitting counts of C
                            5'b01000: tx_data <= counts_tempC[7:0];
                            5'b01001: tx_data <= counts_tempC[15:8];
                            5'b01010: tx_data <= counts_tempC[23:16];
                            5'b01011: tx_data <= counts_tempC[31:24];
                            //Transmitting counts of AB
                            5'b01100: tx_data <= counts_tempAB[7:0];
                            5'b01101: tx_data <= counts_tempAB[15:8];
                            5'b01110: tx_data <= counts_tempAB[23:16];
                            5'b01111: tx_data <= counts_tempAB[31:24];
                            //Transmitting counts of BC
                            5'b10000: tx_data <= counts_tempBC[7:0];
                            5'b10001: tx_data <= counts_tempBC[15:8];
                            5'b10010: tx_data <= counts_tempBC[23:16];
                            5'b10011: tx_data <= counts_tempBC[31:24];
                            //Transmitting counts of AC
                            5'b10100: tx_data <= counts_tempAC[7:0];
                            5'b10101: tx_data <= counts_tempAC[15:8];
                            5'b10110: tx_data <= counts_tempAC[23:16];
                            5'b10111: tx_data <= counts_tempAC[31:24];
                            //Transmitting counts of timestamp
                            5'b11000: tx_data <= timestamp[7:0];
                            5'b11001: tx_data <= timestamp[15:8];
                            5'b11010: tx_data <= timestamp[23:16];
                            5'b11011: tx_data <= timestamp[31:24];
                            //Transmitting value of tmr_maxval_temp
                            5'b11100: tx_data <= tmr_maxval_temp;
                        endcase
                        new_data <= 1;
                        state <= 3'b010;
                    end
                end
                3'b010: begin // Wait for transmission to complete
                    if (!busy) begin
                        byte_counter <= byte_counter + 1;
                        if (byte_counter == 5'b11100) begin
                            byte_counter <= 0;
                            state <= 3'b011;  // Move to clean up state
                        end else begin
                            state <= 3'b001;  // Continue sending current counter bytes
                        end
                    end
                end
                3'b011: begin
                    //Clearing all the variables used in the transmission
                    poll_flag <= 0;
                    counts_tempA <= 0;
                    counts_tempB <= 0;
                    counts_tempC <= 0;
                    counts_tempAB <= 0;
                    counts_tempBC <= 0;
                    counts_tempAC <= 0;
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