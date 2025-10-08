module uart_tx #(
    parameter CLK_FREQ = 300_000_000,  // clock frequency
    parameter BAUD = 14400         // desired baud rate
)(
    input clk,            // clock input
    input rst,            // reset active high
    output reg tx,        // TX output
    input block,          // block transmissions
    output reg busy,      // module is busy when 1
    input [7:0] data,     // data to send
    input new_data        // flag for new data
);

  localparam CLK_PER_BIT = (CLK_FREQ + BAUD) / BAUD - 1; // clock cycles per bit
  localparam CTR_SIZE = $clog2(CLK_PER_BIT); // bits required to store CLK_PER_BIT - 1

  // FSM states defined using bit encoding
  localparam [1:0]
    IDLE = 2'b00,
    START_BIT = 2'b01,
    DATA = 2'b10,
    STOP_BIT = 2'b11;

  reg [1:0] state;
  reg [CTR_SIZE-1:0] ctr;
  reg [2:0] bitCtr;
  reg [7:0] savedData;
  reg blockFlag;    //input buffer
  reg txReg; // output buffer

  // Sequential logic for state and registers
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= IDLE;
      ctr <= 0;
      bitCtr <= 0;
      savedData <= 0;
      txReg <= 1;
      tx <= 1;
      busy <= 0;
      blockFlag <= 0;
    end else begin
    // Update the tx output at the beginning  of each clock cycle
      tx <= txReg;
      busy = 1;
      blockFlag <= block; // buffer block input
     
      case (state)
        IDLE: begin
          txReg <= 1; // idle high (UART standard)
          if (!blockFlag) begin
            busy <= 0; // not busy
            bitCtr <= 0;
            ctr <= 0;
            if (new_data) begin
              savedData <= data; // save the data
              busy <= 1;
              state <= START_BIT; // switch states
            end
          end
        end

        START_BIT: begin
          ctr <= ctr + 1;
          txReg <= 0; // start bit is low
          if (ctr == CLK_PER_BIT - 1) begin
            ctr <= 0;
            state <= DATA; // switch states
          end
        end

        DATA: begin
          txReg <= savedData[bitCtr]; // output the data bit
          ctr <= ctr + 1;
          if (ctr == CLK_PER_BIT - 1) begin
            ctr <= 0;
            bitCtr <= bitCtr + 1;
            if (bitCtr == 7) begin
              state <= STOP_BIT; // switch states
            end
          end
        end

        STOP_BIT: begin
          txReg <= 1; // stop bit is high
          ctr <= ctr + 1;
          if (ctr == CLK_PER_BIT - 1) begin
            state <= IDLE; // switch states
            busy <= 0;
          end
        end

        default: state <= IDLE; // reset to idle if state is invalid
      endcase

     
    end
  end
endmodule
