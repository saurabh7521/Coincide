module uart_rx #(
    parameter CLK_FREQ = 100_000_000,  // clock frequency
    parameter BAUD = 9600         // desired baud rate
)(
    input clk,            // clock input
    input rst,            // reset active high
    input rx,             // UART rx input
    output reg [7:0] data, // received data
    output reg new_data   // new data flag (1 = new data)
);

  localparam CLK_PER_BIT = (CLK_FREQ + BAUD) / BAUD - 1; // clock cycles per bit
  localparam CTR_SIZE = $clog2(CLK_PER_BIT); // bits required to store CLK_PER_BIT - 1

  // FSM states defined using bit encoding
  localparam [1:0] 
    IDLE = 2'b00,
    WAIT_HALF = 2'b01,
    WAIT_FULL = 2'b10,
    WAIT_HIGH = 2'b11;

  reg [1:0] state;
  reg [CTR_SIZE-1:0] ctr;
  reg [2:0] bitCtr;
  reg [7:0] savedData;
  reg newData;
  reg rxd;

  // Sequential logic for state and registers
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= IDLE;
      ctr <= 0;
      bitCtr <= 0;
      savedData <= 0;
      newData <= 0;
      rxd <= 1;
    end else begin
      rxd <= rx;    // buffer rx
      newData <= 0; // default to 0

      case (state)
        IDLE: begin
          bitCtr <= 0;
          ctr <= 0;
          if (rxd == 0) // start bit detected
            state <= WAIT_HALF;
        end

        WAIT_HALF: begin
          ctr <= ctr + 1;
          if (ctr == (CLK_PER_BIT >> 1)) begin
            ctr <= 0;
            state <= WAIT_FULL;
          end
        end

        WAIT_FULL: begin
          ctr <= ctr + 1;
          if (ctr == CLK_PER_BIT - 1) begin
            savedData <= {rxd, savedData[7:1]}; // shift in new data
            bitCtr <= bitCtr + 1;
            ctr <= 0;
            if (bitCtr == 7) begin
              state <= WAIT_HIGH;
              newData <= 1;
            end
          end
        end

        WAIT_HIGH: begin
          if (rxd == 1) // wait for line to go high
            state <= IDLE;
        end

        default: begin
          state <= IDLE;
        end
      endcase
    end
  end

  // Combinational logic for outputs
  always @(*) begin
    data = savedData;
    new_data = newData;
  end
endmodule


