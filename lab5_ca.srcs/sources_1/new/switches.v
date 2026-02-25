
//WORKING
`timescale 1ns / 1ps

module switches(
    input clk,                 // system clock
    input rst,                 // reset signal
    input [31:0] writeData,    // data for writes (unused)
    input writeEnable,         // enable for writing
    input readEnable,          // enable for reading
    input [29:0] memAddress,   // address from bus
    output reg [31:0] readData = 0, // data sent to bus
    output reg [15:0] leds     // physical switch status
);

    // handle bus reads
    always @(posedge clk) begin
        if (readEnable) begin
            readData <= {16'b0, leds}; //Pad with 0s to fit into 32 bit
        end
    end

endmodule