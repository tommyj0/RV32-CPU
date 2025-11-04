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


module vga_memory #
(
  parameter DISPLAY_WIDTH=800,
  parameter DISPLAY_HEIGHT=600
)
(
    input clk,
    input rst,
    input [10:0] x,
    input [9:0] y, 
    input [31:0] bus_wdata, 
    input        vga_we,
    input frame_trig,   
    output reg [11:0] colour_out
    );

wire [$clog2(DISPLAY_WIDTH)-1:0] x_write;
wire [$clog2(DISPLAY_HEIGHT)-1:0] y_write;
wire [11:0] colour_in;

localparam integer DEPTH = DISPLAY_WIDTH*DISPLAY_HEIGHT;

wire [$clog2(DEPTH) - 1:0] write_addr;
wire [$clog2(DEPTH) - 1:0] read_addr;

assign write_addr = y_write * DISPLAY_WIDTH + x_write;
assign read_addr = y* DISPLAY_WIDTH + x;
wire [11:0] palette[0:3];
assign palette[0] = 12'hFFF;
assign palette[1] = 12'hFF0;
assign palette[2] = 12'hF0F;
assign palette[3] = 12'h0FF;


reg [1:0] frame_buffer [0:DEPTH - 1];

assign x_write = bus_wdata[9:0];
assign y_write = bus_wdata[19:10];
assign colour_in = bus_wdata[31:20];
assign write_addr = y_write * DISPLAY_WIDTH + x_write;

//always@(*) begin
//    if ((x < 100) && (y < 100 || y > `DISPLAY_HEIGHT - 100))
//        colour_out = ~colour_in;
//    else if ((x > `DISPLAY_WIDTH - 100 )&& (y < 100 || y > 600 - 100) )
//        colour_out = ~colour_in;
//    else 
//        colour_out = colour_in;
//end


always@(posedge clk) begin
    // if (rst) begin // don't strictly need a reset here, might have to do it in software
    //   frame_buffer[y][x] <= 'b0;
    // end else
    if (vga_we) begin
      frame_buffer[write_addr] <= colour_in[1:0];
    end
    colour_out <= palette[frame_buffer[read_addr]];

end
    
endmodule
