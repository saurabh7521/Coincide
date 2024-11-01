module au_top (
    input clk,          // 100MHz clock
    input rst_n,        // reset button
    output reg [7:0] led,   // 8 user controllable LEDs
    output wire tx,     // Transmission line
    input pulseA,         //external pulse input for A
    input pulseB,        //external pulse input for B
    input pulseC,        //external pulse input for C
    input pulseD         //external pulse input for D
);

    // Signal declarations
    wire rst;
    wire [3:0] out_duplicated_pulse;           // Duplicator out for pulses
    reg [3:0] pins;     // Goes into the comparator
    wire [14:0] incr;    // Vector that stores the increment values of comparators
    wire tmr_maxval;    // Timer has reached counting
    wire [31:0] timer_value; // Variable to hold timer value
    //Below are the pin registers taht are used to send the bitmasked data to comparators
    reg [3:0] compA_pins; // Pins that go into comparator A
    reg [3:0] compB_pins;   // Pins that go into comparator B
    reg [3:0] compC_pins;   // Pins that go into comparator C
    reg [3:0] compD_pins;   // Pins that go into comparator D
    reg [3:0] compAB_pins;   // Pins that go into comparator AB
    reg [3:0] compAC_pins;   // Pins that go into comparator AC
    reg [3:0] compAD_pins;   // Pins that go into comparator AD
    reg [3:0] compBC_pins;   // Pins that go into comparator BC
    reg [3:0] compBD_pins;   // Pins that go into comparator BD
    reg [3:0] compCD_pins;   // Pins that go into comparator CD
    reg [3:0] compABC_pins;   // Pins that go into comparator ABC
    reg [3:0] compABD_pins;   // Pins that go into comparator ABD
    reg [3:0] compACD_pins;   // Pins that go into comparator ACD
    reg [3:0] compBCD_pins;   // Pins that go into comparator BCD
    reg [3:0] compABCD_pins;   // Pins that go into comparator ABCD

    //Below are the counts that store the coincidence count values and corresponding temporary variables
    //used in communication
    reg [31:0] countsA;  // Register to store the count of the A pulses
    reg [31:0] countsB;  // Register to store the count of the B pulses
    reg [31:0] countsC;  // Register to store the count of the C pulses
    reg [31:0] countsD;  // Register to store the count of the D pulses
    reg [31:0] countsAB; // Register to store the count of the AB pulses
    reg [31:0] countsAC; // Register to store the count of the AC pulses
    reg [31:0] countsAD; // Register to store the count of the AD pulses
    reg [31:0] countsBC; // Register to store the count of the BC pulses
    reg [31:0] countsBD; // Register to store the count of the BD pulses
    reg [31:0] countsCD; // Register to store the count of the CD pulses
    reg [31:0] countsABC; // Register to store the count of the ABC pulses
    reg [31:0] countsABD; // Register to store the count of the ABD pulses
    reg [31:0] countsACD; // Register to store the count of the ACD pulses
    reg [31:0] countsBCD; // Register to store the count of the BCD pulses
    reg [31:0] countsABCD; // Register to store the count of the ABCD pulses

    reg [31:0] counts_tempA;
    reg [31:0] counts_tempB;
    reg [31:0] counts_tempC;
    reg [31:0] counts_tempD;
    reg [31:0] counts_tempAB;
    reg [31:0] counts_tempAC;
    reg [31:0] counts_tempAD;
    reg [31:0] counts_tempBC;
    reg [31:0] counts_tempBD;
    reg [31:0] counts_tempCD;
    reg [31:0] counts_tempABC;
    reg [31:0] counts_tempABD;
    reg [31:0] counts_tempACD;
    reg [31:0] counts_tempBCD;
    reg [31:0] counts_tempABCD;

    reg [31:0] timestamp; // Timestamp when poll_flag is set
    reg [7:0] tx_data;  // Variable to send counter value
    reg poll_flag;      // Flag for counts_temp is ready to be transmitted
    reg new_data;       // Data ready for transmission
    wire busy;          // Transmission line busy transmitting
    reg [6:0] byte_counter; // Byte transmission counter
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

    duplicator duplD (
        .clk(clk),
        .rst(rst),
        .pulse(pulseD),
        .length(4'd10),
        .out(out_duplicated_pulse[0])
    );

    // Instantiate a comparator module
    comparator compA (
        .clk(clk),
        .rst(rst),
        .pins(compA_pins),
        .length(4'd10),
        .incr(incr[14])
    );

    comparator compB (
        .clk(clk),
        .rst(rst),
        .pins(compB_pins),
        .length(4'd10),
        .incr(incr[13])
    );

    comparator compC (
        .clk(clk),
        .rst(rst),
        .pins(compC_pins),
        .length(4'd10),
        .incr(incr[12])
    );

    comparator compD (
        .clk(clk),
        .rst(rst),
        .pins(compD_pins),
        .length(4'd10),
        .incr(incr[11])
    );

    comparator compAB (
        .clk(clk),
        .rst(rst),
        .pins(compAB_pins),
        .length(4'd10),
        .incr(incr[10])
    );

    comparator compAC (
        .clk(clk),
        .rst(rst),
        .pins(compAC_pins),
        .length(4'd10),
        .incr(incr[9])
    );

    comparator compAD (
        .clk(clk),
        .rst(rst),
        .pins(compAD_pins),
        .length(4'd10),
        .incr(incr[8])
    );

    comparator compBC (
        .clk(clk),
        .rst(rst),
        .pins(compBC_pins),
        .length(4'd10),
        .incr(incr[7])
    );

    comparator compBD (
        .clk(clk),
        .rst(rst),
        .pins(compBD_pins),
        .length(4'd10),
        .incr(incr[6])
    );

    comparator compCD (
        .clk(clk),
        .rst(rst),
        .pins(compCD_pins),
        .length(4'd10),
        .incr(incr[5])
    );

    comparator compABC (
        .clk(clk),
        .rst(rst),
        .pins(compABC_pins),
        .length(4'd10),
        .incr(incr[4])
    );

    comparator compABD (
        .clk(clk),
        .rst(rst),
        .pins(compABD_pins),
        .length(4'd10),
        .incr(incr[3])
    );

    comparator compACD (
        .clk(clk),
        .rst(rst),
        .pins(compACD_pins),
        .length(4'd10),
        .incr(incr[2])
    );

    comparator compBCD (
        .clk(clk),
        .rst(rst),
        .pins(compBCD_pins),
        .length(4'd10),
        .incr(incr[1])
    );

    comparator compABCD (
        .clk(clk),
        .rst(rst),
        .pins(compABCD_pins),
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
            countsD <= 0;
            counts_tempD <= 0;
            countsAB <= 0;
            counts_tempAB <= 0;
            countsAC <= 0;
            counts_tempAC <= 0;
            countsAD <= 0;
            counts_tempAD <= 0;
            countsBC <= 0;
            counts_tempBC <= 0;
            countsBD <= 0;
            counts_tempBD <= 0;
            countsCD <= 0;
            counts_tempCD <= 0;
            countsABC <= 0;
            counts_tempABC <= 0;
            countsABD <= 0;
            counts_tempABD <= 0;
            countsACD <= 0;
            counts_tempACD <= 0;
            countsBCD <= 0;
            counts_tempBCD <= 0;
            countsABCD <= 0;
            counts_tempABCD <= 0;

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
            pins[3] <= out_duplicated_pulse[0];      //Saving the duplicated pulse D into pins

            compA_pins <= (pins | 4'b1110); // Passing bit masked pins to the comparator
            compB_pins <= (pins | 4'b1101);
            compC_pins <= (pins | 4'b1011);
            compD_pins <= (pins | 4'b0111);
            compAB_pins <= (pins | 4'b1100);
            compAC_pins <= (pins | 4'b1010);
            compAD_pins <= (pins | 4'b0110);
            compBC_pins <= (pins | 4'b1001);
            compBD_pins <= (pins | 4'b0101);
            compCD_pins <= (pins | 4'b0011);
            compABC_pins <= (pins | 4'b1000);
            compABD_pins <= (pins | 4'b0100);
            compACD_pins <= (pins | 4'b0010);
            compBCD_pins <= (pins | 4'b0001);
            compABCD_pins <= (pins | 4'b0000);


            if (incr[14]) begin
                countsA <= countsA + 1; // Increment counts by 1 if compA detects all high bits
            end

            if (incr[13]) begin
                countsB <= countsB + 1; // Increment counts by 1 if compB detects all high bits
            end

            if (incr[12]) begin
                countsC <= countsC + 1; // Increment counts by 1 if compC detects all high bits
            end

            if (incr[11]) begin
                countsD <= countsD + 1; // Increment counts by 1 if compD detects all high bits
            end

            if (incr[10]) begin
                countsAB <= countsAB + 1; // Increment counts by 1 if compAB detects all high bits
            end

            if (incr[9]) begin
                countsAC <= countsAC + 1; // Increment counts by 1 if compAC detects all high bits
            end

            if (incr[8]) begin
                countsAD <= countsAD + 1; // Increment counts by 1 if compAD detects all high bits
            end

            if (incr[7]) begin
                countsBC <= countsBC + 1; // Increment counts by 1 if compBC detects all high bits
            end

            if (incr[6]) begin
                countsBD <= countsBD + 1; // Increment counts by 1 if compBD detects all high bits
            end

            if (incr[5]) begin
                countsCD <= countsCD + 1; // Increment counts by 1 if compCD detects all high bits
            end

            if (incr[4]) begin
                countsABC <= countsABC + 1; // Increment counts by 1 if compABC detects all high bits
            end

            if (incr[3]) begin
                countsABD <= countsABD + 1; // Increment counts by 1 if compABD detects all high bits
            end

            if (incr[2]) begin
                countsACD <= countsACD + 1; // Increment counts by 1 if compACD detects all high bits
            end

            if (incr[1]) begin
                countsBCD <= countsBCD + 1; // Increment counts by 1 if compBCD detects all high bits
            end

            if (incr[0]) begin
                countsABCD <= countsABCD + 1; // Increment counts by 1 if compABCD detects all high bits
            end


            if (tmr_maxval) begin // If timer is complete
                //led<= tmr_maxval;
                tmr_maxval_temp <= tmr_maxval; //Save tmr_maxval flag for initiating transfer
                counts_tempA <= countsA;      //Save counts to a temp. variable for transmission
                counts_tempB <= countsB;
                counts_tempC <= countsC;
                counts_tempD <= countsD;
                counts_tempAB <= countsAB;
                counts_tempAC <= countsAC;
                counts_tempAD <= countsAD;
                counts_tempBC <= countsBC;
                counts_tempBD <= countsBD;
                counts_tempCD <= countsCD;
                counts_tempABC <= countsABC;
                counts_tempABD <= countsABD;
                counts_tempACD <= countsACD;
                counts_tempBCD <= countsBCD;
                counts_tempABCD <= countsABCD;

                timestamp <= timer_value; // Save current timer value as timestamp
                countsA <= 0;            //Reset counter to 0
                countsB <= 0;
                countsC <= 0;
                countsAB <= 0;
                countsAC <= 0;
                countsAD <= 0;
                countsBC <= 0;
                countsBD <= 0;
                countsCD <= 0;
                countsABC <= 0;
                countsABD <= 0;
                countsACD <= 0;
                countsBCD <= 0;
                countsABCD <= 0;

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
                            7'b0000000: tx_data <= counts_tempA[7:0];
                            7'b0000001: tx_data <= counts_tempA[15:8];
                            7'b0000010: tx_data <= counts_tempA[23:16];
                            7'b0000011: tx_data <= counts_tempA[31:24];
                            //Transmitting counts of B
                            7'b0000100: tx_data <= counts_tempB[7:0];
                            7'b0000101: tx_data <= counts_tempB[15:8];
                            7'b0000110: tx_data <= counts_tempB[23:16];
                            7'b0000111: tx_data <= counts_tempB[31:24];
                            //Transmitting counts of C
                            7'b0001000: tx_data <= counts_tempC[7:0];
                            7'b0001001: tx_data <= counts_tempC[15:8];
                            7'b0001010: tx_data <= counts_tempC[23:16];
                            7'b0001011: tx_data <= counts_tempC[31:24];
                            //Transmitting counts of D
                            7'b0001100: tx_data <= counts_tempD[7:0];
                            7'b0001101: tx_data <= counts_tempD[15:8];
                            7'b0001110: tx_data <= counts_tempD[23:16];
                            7'b0001111: tx_data <= counts_tempD[31:24];
                            //Transmitting counts of AB
                            7'b0010000: tx_data <= counts_tempAB[7:0];
                            7'b0010001: tx_data <= counts_tempAB[15:8];
                            7'b0010010: tx_data <= counts_tempAB[23:16];
                            7'b0010011: tx_data <= counts_tempAB[31:24];
                            //Transmitting counts of AC
                            7'b0010100: tx_data <= counts_tempAC[7:0];
                            7'b0010101: tx_data <= counts_tempAC[15:8];
                            7'b0010110: tx_data <= counts_tempAC[23:16];
                            7'b0010111: tx_data <= counts_tempAC[31:24];
                            //Transmitting counts of AD
                            7'b0011000: tx_data <= counts_tempAD[7:0];
                            7'b0011001: tx_data <= counts_tempAD[15:8];
                            7'b0011010: tx_data <= counts_tempAD[23:16];
                            7'b0011011: tx_data <= counts_tempAD[31:24];
                            //Transmitting counts of BC
                            7'b0011100: tx_data <= counts_tempBC[7:0];
                            7'b0011101: tx_data <= counts_tempBC[15:8];
                            7'b0011110: tx_data <= counts_tempBC[23:16];
                            7'b0011111: tx_data <= counts_tempBC[31:24];
                            //Transmitting counts of BD
                            7'b0100000: tx_data <= counts_tempBD[7:0];
                            7'b0100001: tx_data <= counts_tempBD[15:8];
                            7'b0100010: tx_data <= counts_tempBD[23:16];
                            7'b0100011: tx_data <= counts_tempBD[31:24];
                            //Transmitting counts of CD
                            7'b0100100: tx_data <= counts_tempCD[7:0];
                            7'b0100101: tx_data <= counts_tempCD[15:8];
                            7'b0100110: tx_data <= counts_tempCD[23:16];
                            7'b0100111: tx_data <= counts_tempCD[31:24];
                            //Transmitting counts of ABC
                            7'b0101000: tx_data <= counts_tempABC[7:0];
                            7'b0101001: tx_data <= counts_tempABC[15:8];
                            7'b0101010: tx_data <= counts_tempABC[23:16];
                            7'b0101011: tx_data <= counts_tempABC[31:24];
                            //Transmitting counts of ABD
                            7'b0101100: tx_data <= counts_tempABD[7:0];
                            7'b0101101: tx_data <= counts_tempABD[15:8];
                            7'b0101110: tx_data <= counts_tempABD[23:16];
                            7'b0101111: tx_data <= counts_tempABD[31:24];
                            //Transmitting counts of ACD
                            7'b0110000: tx_data <= counts_tempACD[7:0];
                            7'b0110001: tx_data <= counts_tempACD[15:8];
                            7'b0110010: tx_data <= counts_tempACD[23:16];
                            7'b0110011: tx_data <= counts_tempACD[31:24];
                            //Transmitting counts of BCD
                            7'b0110100: tx_data <= counts_tempBCD[7:0];
                            7'b0110101: tx_data <= counts_tempBCD[15:8];
                            7'b0110110: tx_data <= counts_tempBCD[23:16];
                            7'b0110111: tx_data <= counts_tempBCD[31:24];
                            //Transmitting counts of ABCD
                            7'b0111000: tx_data <= counts_tempABCD[7:0];
                            7'b0111001: tx_data <= counts_tempABCD[15:8];
                            7'b0111010: tx_data <= counts_tempABCD[23:16];
                            7'b0111011: tx_data <= counts_tempABCD[31:24];
                            //Transmitting counts of timestamp
                            7'b0111100: tx_data <= timestamp[7:0];
                            7'b0111101: tx_data <= timestamp[15:8];
                            7'b0111110: tx_data <= timestamp[23:16];
                            7'b0111111: tx_data <= timestamp[31:24];
                            //Transmitting value of tmr_maxval_temp
                            7'b1000000: tx_data <= tmr_maxval_temp;
                        endcase
                        new_data <= 1;
                        state <= 3'b010;
                    end
                end
                3'b010: begin // Wait for transmission to complete
                    if (!busy) begin
                        byte_counter <= byte_counter + 1;
                        if (byte_counter == 7'b1000000) begin
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
                    counts_tempD <= 0;
                    counts_tempAB <= 0;
                    counts_tempAC <= 0;
                    counts_tempAD <= 0;
                    counts_tempBC <= 0;
                    counts_tempBD <= 0;
                    counts_tempCD <= 0;
                    counts_tempABC <= 0;
                    counts_tempABD <= 0;
                    counts_tempACD <= 0;
                    counts_tempBCD <= 0;
                    counts_tempABCD <= 0;
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