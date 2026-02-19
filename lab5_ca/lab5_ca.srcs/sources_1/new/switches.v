`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2026 09:54:34 AM
// Design Name: 
// Module Name: switches
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module switches(
input clk,
input rst,
input [31:0] writeData,
input writeEnable,
input readEnable,
input [29:0] memAddress,
output reg [31:0] readData = 0, // not to be read
output reg [15:0] leds
);

endmodule
