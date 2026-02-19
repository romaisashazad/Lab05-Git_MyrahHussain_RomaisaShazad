module leds(
    input clk, rst,               // clock and reset
    input [15:0] btns,            // button inputs
    input [31:0] writeData,       // data to write
    input writeEnable,            // write ctrl
    input readEnable,             // read ctrl
    input [29:0] memAddress,      // address bus
    input [15:0] switches,        // switch inputs
    output reg [31:0] readData,   // data sent back to bus
    output [15:0] leds            // physical led output
);
    
    // send count or switch data to leds
    assign leds = readData[15:0]; // drive lights with lower bits

    // bus read logic
    always @(posedge clk) begin
        if (readEnable)
            readData <= {16'b0, switches}; // put switch values on bus
    end
endmodule