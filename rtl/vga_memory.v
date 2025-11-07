`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/26/2024 10:16:54 PM
// Design Name: 
// Module Name: memory
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


// Standard for writing to a certain pixel using example of 800x600 
// clog2(800) = 10, clog2(600) = 10, so: 
// data = {colour[11:0],y[9:0],x[9:0]} 
// block is write-only


// VGA block is setup for 800x600x12 
// due to memory constraints, 400x300x8 is used
module vga_memory #
(
  parameter DISPLAY_WIDTH=800,
  parameter DISPLAY_HEIGHT=600,
  parameter INPUT_COLOUR_BITS=8,
  parameter OUTPUT_COLOUR_BITS=12
)
(
    input clk,
    input rst,
    // VGA DRIVER ACCESS (READ-ONLY)
    input [10:0] x, 
    input [9:0] y, 
    // BUS ACCESS (WRITE-ONLY)
    input [31:0] bus_wdata, 
    input        vga_we,
    input frame_trig,   
    output [11:0] colour_out
    );

wire [$clog2(DISPLAY_WIDTH)-1:0] x_write;
wire [$clog2(DISPLAY_HEIGHT)-1:0] y_write;
wire [11:0] colour_in;

localparam integer DEPTH = DISPLAY_WIDTH*DISPLAY_HEIGHT;

wire [$clog2(DEPTH) - 1:0] write_addr;
wire [$clog2(DEPTH) - 1:0] read_addr;

reg [INPUT_COLOUR_BITS - 1:0] frame_buffer [0:DEPTH - 1];

assign x_write = bus_wdata[9:1];
assign y_write = bus_wdata[19:11];
assign colour_in = bus_wdata[31:20];
assign write_addr = y_write * DISPLAY_WIDTH + x_write;
assign read_addr = y* DISPLAY_WIDTH + x;

reg [INPUT_COLOUR_BITS - 1:0] colour_8bit; 
assign colour_out = {colour_8bit[7:5], 1'b0, colour_8bit[4:2], 1'b0, colour_8bit[1:0], 2'b0};

always@(posedge clk) begin
    if (vga_we) begin
      frame_buffer[write_addr] <= colour_in[INPUT_COLOUR_BITS - 1:0];
    end
    colour_8bit <= frame_buffer[read_addr];

end
    
endmodule
