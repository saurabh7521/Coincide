

module au_top (
    input clk,          // 100MHz clock
    input rst_n,        // reset button
    output reg [7:0] led,   // 8 user controllable LEDs
    output wire tx,     // Transmission line
    input wire rx,      //Reception line
    input pulseA,         //external pulse input for A
    input pulseB,        //external pulse input for B
    input pulseC,        //external pulse input for C
    input pulseD         //external pulse input for D
);

    // Signal declarations
    wire rst;
    wire [3:0] xout_duplicated_pulse, yout_duplicated_pulse;         // Duplicator out for pulses x and y window
    reg [3:0] xpins, ypins;     // Goes into the comparators for x and y window
    wire [14:0] xincr, yincr;    // Vector that stores the increment flags of comparators
    wire tmr_maxval;    // Timer has reached counting
    wire [31:0] timer_value; // Variable to hold timer value
    reg rx_data;      //Data received for coincidence window
    reg rx_new_data;    //rx new data flag
    reg window = 1'b0;        //Flag for concidence window, if zero, rx data goes to x, otherwise y
    reg [7:0] x_window = 8'd10; //x coincidence window, 10 clock cycles by default
    reg [7:0] y_window = 8'd20; //y coincidence window, 20 clock cycles by default

    //Below are the pin registers that are used to send the bitmasked data to COMPARATORS
    // for example, pins xcompA_pins is assigned to comparator xcompA
    reg [3:0] xcompA_pins, xcompB_pins, xcompC_pins, xcompD_pins, xcompAB_pins,
              xcompAC_pins, xcompAD_pins, xcompBC_pins, xcompBD_pins, xcompCD_pins,
              xcompABC_pins, xcompABD_pins, xcompACD_pins, xcompBCD_pins, xcompABCD_pins;

    //Same for the y coincidence
    reg [3:0] ycompA_pins, ycompB_pins, ycompC_pins, ycompD_pins, ycompAB_pins,
              ycompAC_pins, ycompAD_pins, ycompBC_pins, ycompBD_pins, ycompCD_pins,
              ycompABC_pins, ycompABD_pins, ycompACD_pins, ycompBCD_pins, ycompABCD_pins;

    //Below are the variables that store the coincidence count values and corresponding temporary variables
    //These are for x coincidence window
    reg [31:0] xcountsA, xcountsB, xcountsC, xcountsD, xcountsAB,
               xcountsAC, xcountsAD, xcountsBC, xcountsBD, xcountsCD,
               xcountsABC, xcountsABD, xcountsACD, xcountsBCD, xcountsABCD;

    // Below are y coincidence counts register
    reg [31:0] ycountsA, ycountsB, ycountsC, ycountsD, ycountsAB,
               ycountsAC, ycountsAD, ycountsBC, ycountsBD, ycountsCD,
               ycountsABC, ycountsABD, ycountsACD, ycountsBCD, ycountsABCD;

    // Temporary registers to store counts x coincidence window, used for communciation
    reg [31:0] xcounts_tempA, xcounts_tempB, xcounts_tempC, xcounts_tempD,
               xcounts_tempAB, xcounts_tempAC, xcounts_tempAD, xcounts_tempBC,
               xcounts_tempBD, xcounts_tempCD, xcounts_tempABC, xcounts_tempABD,
               xcounts_tempACD, xcounts_tempBCD, xcounts_tempABCD;

    //Below are registers that store counts for y coincidence window temporarily, used for communciation
    reg [31:0] ycounts_tempA, ycounts_tempB, ycounts_tempC, ycounts_tempD,
               ycounts_tempAB, ycounts_tempAC, ycounts_tempAD, ycounts_tempBC,
               ycounts_tempBD, ycounts_tempCD, ycounts_tempABC, ycounts_tempABD,
               ycounts_tempACD, ycounts_tempBCD, ycounts_tempABCD;

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

    // Instantiating duplicator module for x coincidence window
    duplicator xduplA (.clk(clk), .rst(rst), .pulse(pulseA), .length(x_window), .out(xout_duplicated_pulse[3])),
               xduplB (.clk(clk), .rst(rst), .pulse(pulseB), .length(x_window), .out(xout_duplicated_pulse[2])),
               xduplC (.clk(clk), .rst(rst), .pulse(pulseC), .length(x_window), .out(xout_duplicated_pulse[1])),
               xduplD (.clk(clk), .rst(rst), .pulse(pulseD), .length(x_window), .out(xout_duplicated_pulse[0]));

    // Instantiating duplicator module for y coincidence window
    duplicator yduplA (.clk(clk), .rst(rst), .pulse(pulseA), .length(y_window), .out(yout_duplicated_pulse[3])),
               yduplB (.clk(clk), .rst(rst), .pulse(pulseB), .length(y_window), .out(yout_duplicated_pulse[2])),
               yduplC (.clk(clk), .rst(rst), .pulse(pulseC), .length(y_window), .out(yout_duplicated_pulse[1])),
               yduplD (.clk(clk), .rst(rst), .pulse(pulseD), .length(y_window), .out(yout_duplicated_pulse[0]));

    // Instantiate comparator modules for x coincidence window
    comparator xcompA (.clk(clk), .rst(rst), .pins(xcompA_pins), .length(x_window), .incr(xincr[14])),
               xcompB (.clk(clk), .rst(rst), .pins(xcompB_pins), .length(x_window), .incr(xincr[13])),
               xcompC (.clk(clk), .rst(rst), .pins(xcompC_pins), .length(x_window), .incr(xincr[12])),
               xcompD (.clk(clk), .rst(rst), .pins(xcompD_pins), .length(x_window), .incr(xincr[11])),
               xcompAB (.clk(clk), .rst(rst), .pins(xcompAB_pins), .length(x_window), .incr(xincr[10])),
               xcompAC (.clk(clk), .rst(rst), .pins(xcompAC_pins), .length(x_window), .incr(xincr[9])),
               xcompAD (.clk(clk), .rst(rst), .pins(xcompAD_pins), .length(x_window), .incr(xincr[8])),
               xcompBC (.clk(clk), .rst(rst), .pins(xcompBC_pins), .length(x_window), .incr(xincr[7])),
               xcompBD (.clk(clk), .rst(rst), .pins(xcompBD_pins), .length(x_window), .incr(xincr[6])),
               xcompCD (.clk(clk), .rst(rst), .pins(xcompCD_pins), .length(x_window), .incr(xincr[5])),
               xcompABC (.clk(clk), .rst(rst), .pins(xcompABC_pins), .length(x_window), .incr(xincr[4])),
               xcompABD (.clk(clk), .rst(rst), .pins(xcompABD_pins), .length(x_window), .incr(xincr[3])),
               xcompACD (.clk(clk), .rst(rst), .pins(xcompACD_pins), .length(x_window), .incr(xincr[2])),
               xcompBCD (.clk(clk), .rst(rst), .pins(xcompBCD_pins), .length(x_window), .incr(xincr[1])),
               xcompABCD (.clk(clk), .rst(rst), .pins(xcompABCD_pins), .length(x_window), .incr(xincr[0]));

    // Instantiate comparator modules for y coincidence window
    comparator ycompA (.clk(clk), .rst(rst), .pins(ycompA_pins), .length(y_window), .incr(yincr[14])),
               ycompB (.clk(clk), .rst(rst), .pins(ycompB_pins), .length(y_window), .incr(yincr[13])),
               ycompC (.clk(clk), .rst(rst), .pins(ycompC_pins), .length(y_window), .incr(yincr[12])),
               ycompD (.clk(clk), .rst(rst), .pins(ycompD_pins), .length(y_window), .incr(yincr[11])),
               ycompAB (.clk(clk), .rst(rst), .pins(ycompAB_pins), .length(y_window), .incr(yincr[10])),
               ycompAC (.clk(clk), .rst(rst), .pins(ycompAC_pins), .length(y_window), .incr(yincr[9])),
               ycompAD (.clk(clk), .rst(rst), .pins(ycompAD_pins), .length(y_window), .incr(yincr[8])),
               ycompBC (.clk(clk), .rst(rst), .pins(ycompBC_pins), .length(y_window), .incr(yincr[7])),
               ycompBD (.clk(clk), .rst(rst), .pins(ycompBD_pins), .length(y_window), .incr(yincr[6])),
               ycompCD (.clk(clk), .rst(rst), .pins(ycompCD_pins), .length(y_window), .incr(yincr[5])),
               ycompABC (.clk(clk), .rst(rst), .pins(ycompABC_pins), .length(y_window), .incr(yincr[4])),
               ycompABD (.clk(clk), .rst(rst), .pins(ycompABD_pins), .length(y_window), .incr(yincr[3])),
               ycompACD (.clk(clk), .rst(rst), .pins(ycompACD_pins), .length(y_window), .incr(yincr[2])),
               ycompBCD (.clk(clk), .rst(rst), .pins(ycompBCD_pins), .length(y_window), .incr(yincr[1])),
               ycompABCD (.clk(clk), .rst(rst), .pins(ycompABCD_pins), .length(y_window), .incr(yincr[0]));


    // Instantiate a timer module
    timer timer_inst (
        .clk(clk),
        .rst(rst),
        .maxval(tmr_maxval),
        .value(timer_value)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin

            xcountsA <= 0;
            xcounts_tempA <= 0;
            xcountsB <= 0;
            xcounts_tempB <= 0;
            xcountsC <= 0;
            xcounts_tempC <= 0;
            xcountsD <= 0;
            xcounts_tempD <= 0;
            xcountsAB <= 0;
            xcounts_tempAB <= 0;
            xcountsAC <= 0;
            xcounts_tempAC <= 0;
            xcountsAD <= 0;
            xcounts_tempAD <= 0;
            xcountsBC <= 0;
            xcounts_tempBC <= 0;
            xcountsBD <= 0;
            xcounts_tempBD <= 0;
            xcountsCD <= 0;
            xcounts_tempCD <= 0;
            xcountsABC <= 0;
            xcounts_tempABC <= 0;
            xcountsABD <= 0;
            xcounts_tempABD <= 0;
            xcountsACD <= 0;
            xcounts_tempACD <= 0;
            xcountsBCD <= 0;
            xcounts_tempBCD <= 0;
            xcountsABCD <= 0;
            xcounts_tempABCD <= 0;

            ycountsA <= 0;
            ycounts_tempA <= 0;
            ycountsB <= 0;
            ycounts_tempB <= 0;
            ycountsC <= 0;
            ycounts_tempC <= 0;
            ycountsD <= 0;
            ycounts_tempD <= 0;
            ycountsAB <= 0;
            ycounts_tempAB <= 0;
            ycountsAC <= 0;
            ycounts_tempAC <= 0;
            ycountsAD <= 0;
            ycounts_tempAD <= 0;
            ycountsBC <= 0;
            ycounts_tempBC <= 0;
            ycountsBD <= 0;
            ycounts_tempBD <= 0;
            ycountsCD <= 0;
            ycounts_tempCD <= 0;
            ycountsABC <= 0;
            ycounts_tempABC <= 0;
            ycountsABD <= 0;
            ycounts_tempABD <= 0;
            ycountsACD <= 0;
            ycounts_tempACD <= 0;
            ycountsBCD <= 0;
            ycounts_tempBCD <= 0;
            ycountsABCD <= 0;
            ycounts_tempABCD <= 0;

            poll_flag <= 0;
            state <= 3'b000;
            new_data <= 0;
            rx_data <= 0;
            rx_new_data <= 0;
            tx_data <= 8'b00000000;
            byte_counter <= 0;  // Initialize byte counter
            timestamp <= 0;     // Initialize timestamp
            led <= 8'b00000000;
        end else begin
            if (rx_new_data) begin
                if (window)begin
                    y_window <= rx_data;
                end else begin
                    x_window <= rx_data;
                end
            end
            xpins[0] <= xout_duplicated_pulse[3];      // Saving the duplicated pulse A into pins
            xpins[1] <= xout_duplicated_pulse[2];      //Saving the duplicated pulse B into pins
            xpins[2] <= xout_duplicated_pulse[1];      //Saving the duplicated pulse C into pins
            xpins[3] <= xout_duplicated_pulse[0];      //Saving the duplicated pulse D into pins

            ypins[0] <= yout_duplicated_pulse[3];      // Saving the duplicated pulse A into pins
            ypins[1] <= yout_duplicated_pulse[2];      //Saving the duplicated pulse B into pins
            ypins[2] <= yout_duplicated_pulse[1];      //Saving the duplicated pulse C into pins
            ypins[3] <= yout_duplicated_pulse[0];      //Saving the duplicated pulse D into pins


            xcompA_pins <= (xpins | 4'b1110); // Passing bit masked pins to the x comparators
            xcompC_pins <= (xpins | 4'b1011);
            xcompD_pins <= (xpins | 4'b0111);
            xcompAB_pins <= (xpins | 4'b1100);
            xcompAC_pins <= (xpins | 4'b1010);
            xcompAD_pins <= (xpins | 4'b0110);
            xcompBC_pins <= (xpins | 4'b1001);
            xcompBD_pins <= (xpins | 4'b0101);
            xcompCD_pins <= (xpins | 4'b0011);
            xcompABC_pins <= (xpins | 4'b1000);
            xcompABD_pins <= (xpins | 4'b0100);
            xcompACD_pins <= (xpins | 4'b0010);
            xcompBCD_pins <= (xpins | 4'b0001);
            xcompABCD_pins <= (xpins | 4'b0000);

            ycompA_pins <= (ypins | 4'b1110); // Passing bit masked pins to the y comparators
            ycompC_pins <= (ypins | 4'b1011);
            ycompD_pins <= (ypins | 4'b0111);
            ycompAB_pins <= (ypins | 4'b1100);
            ycompAC_pins <= (ypins | 4'b1010);
            ycompAD_pins <= (ypins | 4'b0110);
            ycompBC_pins <= (ypins | 4'b1001);
            ycompBD_pins <= (ypins | 4'b0101);
            ycompCD_pins <= (ypins | 4'b0011);
            ycompABC_pins <= (ypins | 4'b1000);
            ycompABD_pins <= (ypins | 4'b0100);
            ycompACD_pins <= (ypins | 4'b0010);
            ycompBCD_pins <= (ypins | 4'b0001);
            ycompABCD_pins <= (ypins | 4'b0000);

            // Incrementing counter for Y COUNTERS
            if (xincr[14]) begin
                xcountsA <= xcountsA + 1; // Increment counts by 1 if xcompA detects all high bits
            end

            if (xincr[13]) begin
                xcountsB <= xcountsB + 1; // Increment counts by 1 if xcompB detects all high bits
            end

            if (xincr[12]) begin
                xcountsC <= xcountsC + 1; // Increment counts by 1 if xcompC detects all high bits
            end

            if (xincr[11]) begin
                xcountsD <= xcountsD + 1; // Increment counts by 1 if xcompD detects all high bits
            end

            if (xincr[10]) begin
                xcountsAB <= xcountsAB + 1; // Increment counts by 1 if xcompAB detects all high bits
            end

            if (xincr[9]) begin
                xcountsAC <= xcountsAC + 1; // Increment counts by 1 if xcompAC detects all high bits
            end

            if (xincr[8]) begin
                xcountsAD <= xcountsAD + 1; // Increment counts by 1 if xcompAD detects all high bits
            end

            if (xincr[7]) begin
                xcountsBC <= xcountsBC + 1; // Increment counts by 1 if xcompBC detects all high bits
            end

            if (xincr[6]) begin
                xcountsBD <= xcountsBD + 1; // Increment counts by 1 if xcompBD detects all high bits
            end

            if (xincr[5]) begin
                xcountsCD <= xcountsCD + 1; // Increment counts by 1 if xcompCD detects all high bits
            end

            if (xincr[4]) begin
                xcountsABC <= xcountsABC + 1; // Increment counts by 1 if xcompABC detects all high bits
            end

            if (xincr[3]) begin
                xcountsABD <= xcountsABD + 1; // Increment counts by 1 if xcompABD detects all high bits
            end

            if (xincr[2]) begin
                xcountsACD <= xcountsACD + 1; // Increment counts by 1 if xcompACD detects all high bits
            end

            if (xincr[1]) begin
                xcountsBCD <= xcountsBCD + 1; // Increment counts by 1 if xcompBCD detects all high bits
            end

            if (xincr[0]) begin
                xcountsABCD <= xcountsABCD + 1; // Increment counts by 1 if xcompABCD detects all high bits
            end


            // Incrementing counter for Y COUNTERS
            if (yincr[14]) begin
                ycountsA <= ycountsA + 1; // Increment counts by 1 if ycompA detects all high bits
            end

            if (yincr[13]) begin
                ycountsB <= ycountsB + 1; // Increment counts by 1 if ycompB detects all high bits
            end

            if (yincr[12]) begin
                ycountsC <= ycountsC + 1; // Increment counts by 1 if ycompC detects all high bits
            end

            if (yincr[11]) begin
                ycountsD <= ycountsD + 1; // Increment counts by 1 if ycompD detects all high bits
            end

            if (yincr[10]) begin
                ycountsAB <= ycountsAB + 1; // Increment counts by 1 if ycompAB detects all high bits
            end

            if (yincr[9]) begin
                ycountsAC <= ycountsAC + 1; // Increment counts by 1 if ycompAC detects all high bits
            end

            if (yincr[8]) begin
                ycountsAD <= ycountsAD + 1; // Increment counts by 1 if ycompAD detects all high bits
            end

            if (yincr[7]) begin
                ycountsBC <= ycountsBC + 1; // Increment counts by 1 if ycompBC detects all high bits
            end

            if (yincr[6]) begin
                ycountsBD <= ycountsBD + 1; // Increment counts by 1 if ycompBD detects all high bits
            end

            if (yincr[5]) begin
                ycountsCD <= ycountsCD + 1; // Increment counts by 1 if ycompCD detects all high bits
            end

            if (yincr[4]) begin
                ycountsABC <= ycountsABC + 1; // Increment counts by 1 if ycompABC detects all high bits
            end

            if (yincr[3]) begin
                ycountsABD <= ycountsABD + 1; // Increment counts by 1 if ycompABD detects all high bits
            end

            if (yincr[2]) begin
                ycountsACD <= ycountsACD + 1; // Increment counts by 1 if ycompACD detects all high bits
            end

            if (yincr[1]) begin
                ycountsBCD <= ycountsBCD + 1; // Increment counts by 1 if ycompBCD detects all high bits
            end

            if (yincr[0]) begin
                ycountsABCD <= ycountsABCD + 1; // Increment counts by 1 if ycompABCD detects all high bits
            end


            if (tmr_maxval) begin // If timer is complete
                //led<= tmr_maxval;
                tmr_maxval_temp <= tmr_maxval; //Save tmr_maxval flag for initiating transfer
                xcounts_tempA <= xcountsA;      //Save counts to a temp. variable for transmission
                xcounts_tempB <= xcountsB;
                xcounts_tempC <= xcountsC;
                xcounts_tempD <= xcountsD;
                xcounts_tempAB <= xcountsAB;
                xcounts_tempAC <= xcountsAC;
                xcounts_tempAD <= xcountsAD;
                xcounts_tempBC <= xcountsBC;
                xcounts_tempBD <= xcountsBD;
                xcounts_tempCD <= xcountsCD;
                xcounts_tempABC <= xcountsABC;
                xcounts_tempABD <= xcountsABD;
                xcounts_tempACD <= xcountsACD;
                xcounts_tempBCD <= xcountsBCD;
                xcounts_tempABCD <= xcountsABCD;

                ycounts_tempA <= ycountsA;      //Save counts to a temp. variable for transmission
                ycounts_tempB <= ycountsB;
                ycounts_tempC <= ycountsC;
                ycounts_tempD <= ycountsD;
                ycounts_tempAB <= ycountsAB;
                ycounts_tempAC <= ycountsAC;
                ycounts_tempAD <= ycountsAD;
                ycounts_tempBC <= ycountsBC;
                ycounts_tempBD <= ycountsBD;
                ycounts_tempCD <= ycountsCD;
                ycounts_tempABC <= ycountsABC;
                ycounts_tempABD <= ycountsABD;
                ycounts_tempACD <= ycountsACD;
                ycounts_tempBCD <= ycountsBCD;
                ycounts_tempABCD <= ycountsABCD;


                timestamp <= timer_value; // Save current timer value as timestamp
                xcountsA <= 0;            //Reset counter to 0
                xcountsB <= 0;
                xcountsC <= 0;
                xcountsD <= 0;
                xcountsAB <= 0;
                xcountsAC <= 0;
                xcountsAD <= 0;
                xcountsBC <= 0;
                xcountsBD <= 0;
                xcountsCD <= 0;
                xcountsABC <= 0;
                xcountsABD <= 0;
                xcountsACD <= 0;
                xcountsBCD <= 0;
                xcountsABCD <= 0;

                ycountsA <= 0;            //Reset counter to 0
                ycountsB <= 0;
                ycountsC <= 0;
                ycountsD <= 0;
                ycountsAB <= 0;
                ycountsAC <= 0;
                ycountsAD <= 0;
                ycountsBC <= 0;
                ycountsBD <= 0;
                ycountsCD <= 0;
                ycountsABC <= 0;
                ycountsABD <= 0;
                ycountsACD <= 0;
                ycountsBCD <= 0;
                ycountsABCD <= 0;


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
                            //Transmitting counts of x coincidence window- A
                            7'b0000000: tx_data <= xcounts_tempA[7:0];
                            7'b0000001: tx_data <= xcounts_tempA[15:8];
                            7'b0000010: tx_data <= xcounts_tempA[23:16];
                            7'b0000011: tx_data <= xcounts_tempA[31:24];
                            //Transmitting counts of B
                            7'b0000100: tx_data <= xcounts_tempB[7:0];
                            7'b0000101: tx_data <= xcounts_tempB[15:8];
                            7'b0000110: tx_data <= xcounts_tempB[23:16];
                            7'b0000111: tx_data <= xcounts_tempB[31:24];
                            //Transmitting counts of C
                            7'b0001000: tx_data <= xcounts_tempC[7:0];
                            7'b0001001: tx_data <= xcounts_tempC[15:8];
                            7'b0001010: tx_data <= xcounts_tempC[23:16];
                            7'b0001011: tx_data <= xcounts_tempC[31:24];
                            //Transmitting counts of D
                            7'b0001100: tx_data <= xcounts_tempD[7:0];
                            7'b0001101: tx_data <= xcounts_tempD[15:8];
                            7'b0001110: tx_data <= xcounts_tempD[23:16];
                            7'b0001111: tx_data <= xcounts_tempD[31:24];
                            //Transmitting counts of AB
                            7'b0010000: tx_data <= xcounts_tempAB[7:0];
                            7'b0010001: tx_data <= xcounts_tempAB[15:8];
                            7'b0010010: tx_data <= xcounts_tempAB[23:16];
                            7'b0010011: tx_data <= xcounts_tempAB[31:24];
                            //Transmitting counts of AC
                            7'b0010100: tx_data <= xcounts_tempAC[7:0];
                            7'b0010101: tx_data <= xcounts_tempAC[15:8];
                            7'b0010110: tx_data <= xcounts_tempAC[23:16];
                            7'b0010111: tx_data <= xcounts_tempAC[31:24];
                            //Transmitting counts of AD
                            7'b0011000: tx_data <= xcounts_tempAD[7:0];
                            7'b0011001: tx_data <= xcounts_tempAD[15:8];
                            7'b0011010: tx_data <= xcounts_tempAD[23:16];
                            7'b0011011: tx_data <= xcounts_tempAD[31:24];
                            //Transmitting counts of BC
                            7'b0011100: tx_data <= xcounts_tempBC[7:0];
                            7'b0011101: tx_data <= xcounts_tempBC[15:8];
                            7'b0011110: tx_data <= xcounts_tempBC[23:16];
                            7'b0011111: tx_data <= xcounts_tempBC[31:24];
                            //Transmitting counts of BD
                            7'b0100000: tx_data <= xcounts_tempBD[7:0];
                            7'b0100001: tx_data <= xcounts_tempBD[15:8];
                            7'b0100010: tx_data <= xcounts_tempBD[23:16];
                            7'b0100011: tx_data <= xcounts_tempBD[31:24];
                            //Transmitting counts of CD
                            7'b0100100: tx_data <= xcounts_tempCD[7:0];
                            7'b0100101: tx_data <= xcounts_tempCD[15:8];
                            7'b0100110: tx_data <= xcounts_tempCD[23:16];
                            7'b0100111: tx_data <= xcounts_tempCD[31:24];
                            //Transmitting counts of ABC
                            7'b0101000: tx_data <= xcounts_tempABC[7:0];
                            7'b0101001: tx_data <= xcounts_tempABC[15:8];
                            7'b0101010: tx_data <= xcounts_tempABC[23:16];
                            7'b0101011: tx_data <= xcounts_tempABC[31:24];
                            //Transmitting counts of ABD
                            7'b0101100: tx_data <= xcounts_tempABD[7:0];
                            7'b0101101: tx_data <= xcounts_tempABD[15:8];
                            7'b0101110: tx_data <= xcounts_tempABD[23:16];
                            7'b0101111: tx_data <= xcounts_tempABD[31:24];
                            //Transmitting counts of ACD
                            7'b0110000: tx_data <= xcounts_tempACD[7:0];
                            7'b0110001: tx_data <= xcounts_tempACD[15:8];
                            7'b0110010: tx_data <= xcounts_tempACD[23:16];
                            7'b0110011: tx_data <= xcounts_tempACD[31:24];
                            //Transmitting counts of BCD
                            7'b0110100: tx_data <= xcounts_tempBCD[7:0];
                            7'b0110101: tx_data <= xcounts_tempBCD[15:8];
                            7'b0110110: tx_data <= xcounts_tempBCD[23:16];
                            7'b0110111: tx_data <= xcounts_tempBCD[31:24];
                            //Transmitting counts of ABCD
                            7'b0111000: tx_data <= xcounts_tempABCD[7:0];
                            7'b0111001: tx_data <= xcounts_tempABCD[15:8];
                            7'b0111010: tx_data <= xcounts_tempABCD[23:16];
                            7'b0111011: tx_data <= xcounts_tempABCD[31:24];

                            //Transmitting counts of y coincidence window- A
                            7'b0111100: tx_data <= ycounts_tempA[7:0];
                            7'b0111101: tx_data <= ycounts_tempA[15:8];
                            7'b0111110: tx_data <= ycounts_tempA[23:16];
                            7'b0111111: tx_data <= ycounts_tempA[31:24];
                            //Transmitting counts of B
                            7'b1000000: tx_data <= ycounts_tempB[7:0];
                            7'b1000001: tx_data <= ycounts_tempB[15:8];
                            7'b1000010: tx_data <= ycounts_tempB[23:16];
                            7'b1000011: tx_data <= ycounts_tempB[31:24];
                            //Transmitting counts of C
                            7'b1000100: tx_data <= ycounts_tempC[7:0];
                            7'b1000101: tx_data <= ycounts_tempC[15:8];
                            7'b1000110: tx_data <= ycounts_tempC[23:16];
                            7'b1000111: tx_data <= ycounts_tempC[31:24];
                            //Transmitting counts of D
                            7'b1001000: tx_data <= ycounts_tempD[7:0];
                            7'b1001001: tx_data <= ycounts_tempD[15:8];
                            7'b1001010: tx_data <= ycounts_tempD[23:16];
                            7'b1001011: tx_data <= ycounts_tempD[31:24];
                            //Transmitting counts of AB
                            7'b1001100: tx_data <= ycounts_tempAB[7:0];
                            7'b1001101: tx_data <= ycounts_tempAB[15:8];
                            7'b1001110: tx_data <= ycounts_tempAB[23:16];
                            7'b1001111: tx_data <= ycounts_tempAB[31:24];
                            //Transmitting counts of AC
                            7'b1010000: tx_data <= ycounts_tempAC[7:0];
                            7'b1010001: tx_data <= ycounts_tempAC[15:8];
                            7'b1010010: tx_data <= ycounts_tempAC[23:16];
                            7'b1010011: tx_data <= ycounts_tempAC[31:24];
                            //Transmitting counts of AD
                            7'b1010100: tx_data <= ycounts_tempAD[7:0];
                            7'b1010101: tx_data <= ycounts_tempAD[15:8];
                            7'b1010110: tx_data <= ycounts_tempAD[23:16];
                            7'b1010111: tx_data <= ycounts_tempAD[31:24];
                            //Transmitting counts of BC
                            7'b1011000: tx_data <= ycounts_tempBC[7:0];
                            7'b1011001: tx_data <= ycounts_tempBC[15:8];
                            7'b1011010: tx_data <= ycounts_tempBC[23:16];
                            7'b1011011: tx_data <= ycounts_tempBC[31:24];
                            //Transmitting counts of BD
                            7'b1011100: tx_data <= ycounts_tempBD[7:0];
                            7'b1011101: tx_data <= ycounts_tempBD[15:8];
                            7'b1011110: tx_data <= ycounts_tempBD[23:16];
                            7'b1011111: tx_data <= ycounts_tempBD[31:24];
                            //Transmitting counts of CD
                            7'b1100000: tx_data <= ycounts_tempCD[7:0];
                            7'b1100001: tx_data <= ycounts_tempCD[15:8];
                            7'b1100010: tx_data <= ycounts_tempCD[23:16];
                            7'b1100011: tx_data <= ycounts_tempCD[31:24];
                            //Transmitting counts of ABC
                            7'b1100100: tx_data <= ycounts_tempABC[7:0];
                            7'b1100101: tx_data <= ycounts_tempABC[15:8];
                            7'b1100110: tx_data <= ycounts_tempABC[23:16];
                            7'b1100111: tx_data <= ycounts_tempABC[31:24];
                            //Transmitting counts of ABD
                            7'b1101000: tx_data <= ycounts_tempABD[7:0];
                            7'b1101001: tx_data <= ycounts_tempABD[15:8];
                            7'b1101010: tx_data <= ycounts_tempABD[23:16];
                            7'b1101011: tx_data <= ycounts_tempABD[31:24];
                            //Transmitting counts of ACD
                            7'b1101100: tx_data <= ycounts_tempACD[7:0];
                            7'b1101101: tx_data <= ycounts_tempACD[15:8];
                            7'b1101110: tx_data <= ycounts_tempACD[23:16];
                            7'b1101111: tx_data <= ycounts_tempACD[31:24];
                            //Transmitting counts of BCD
                            7'b1110000: tx_data <= ycounts_tempBCD[7:0];
                            7'b1110001: tx_data <= ycounts_tempBCD[15:8];
                            7'b1110010: tx_data <= ycounts_tempBCD[23:16];
                            7'b1110011: tx_data <= ycounts_tempBCD[31:24];
                            //Transmitting counts of ABCD
                            7'b1110100: tx_data <= ycounts_tempABCD[7:0];
                            7'b1110101: tx_data <= ycounts_tempABCD[15:8];
                            7'b1110110: tx_data <= ycounts_tempABCD[23:16];
                            7'b1110111: tx_data <= ycounts_tempABCD[31:24];
                            //Transmitting counts of timestamp
                            7'b1111000: tx_data <= timestamp[7:0];
                            7'b1111001: tx_data <= timestamp[15:8];
                            7'b1111010: tx_data <= timestamp[23:16];
                            7'b1111011: tx_data <= timestamp[31:24];
                            //Transmitting value of tmr_maxval_temp
                            7'b1111100: tx_data <= tmr_maxval_temp;
                        endcase
                        new_data <= 1;
                        state <= 3'b010;
                    end
                end
                3'b010: begin // Wait for transmission to complete
                    if (!busy) begin
                        byte_counter <= byte_counter + 1;
                        if (byte_counter == 7'b1111100) begin
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
                    xcounts_tempA <= 0;
                    xcounts_tempB <= 0;
                    xcounts_tempC <= 0;
                    xcounts_tempD <= 0;
                    xcounts_tempAB <= 0;
                    xcounts_tempAC <= 0;
                    xcounts_tempAD <= 0;
                    xcounts_tempBC <= 0;
                    xcounts_tempBD <= 0;
                    xcounts_tempCD <= 0;
                    xcounts_tempABC <= 0;
                    xcounts_tempABD <= 0;
                    xcounts_tempACD <= 0;
                    xcounts_tempBCD <= 0;
                    xcounts_tempABCD <= 0;

                    ycounts_tempA <= 0;
                    ycounts_tempB <= 0;
                    ycounts_tempC <= 0;
                    ycounts_tempD <= 0;
                    ycounts_tempAB <= 0;
                    ycounts_tempAC <= 0;
                    ycounts_tempAD <= 0;
                    ycounts_tempBC <= 0;
                    ycounts_tempBD <= 0;
                    ycounts_tempCD <= 0;
                    ycounts_tempABC <= 0;
                    ycounts_tempABD <= 0;
                    ycounts_tempACD <= 0;
                    ycounts_tempBCD <= 0;
                    ycounts_tempABCD <= 0;


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

    // Instantiating uart_rx module
    uart_rx #(
        .CLK_FREQ(100_000_000),  // Clock frequency
        .BAUD(9600)              // Baud rate
    ) uart_rx_inst (
        .clk(clk),               // Clock input
        .rst(rst),               // Reset input
        .rx(rx),                 // UART receive line
        .data(rx_data),          // Received data output
        .new_data(rx_new_data)   // New data flag output
    );


endmodule
