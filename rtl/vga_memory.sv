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
// data = {colour[11:0],y_i[9:0],x_i[9:0]} 
// block is write-only


// VGA block is setup for 800x600x12 
// due to memory constraints, 400x300x8 is used
module vga_memory #
(
  parameter DISPLAY_WIDTH=400,
  parameter DISPLAY_HEIGHT=300,
  parameter INPUT_COLOUR_BITS=8,
  parameter OUTPUT_COLOUR_BITS=12
)
(
    input logic clk_i,
    input logic rst_i,
    // VGA DRIVER ACCESS (READ-ONLY)
    input logic [10:0] x_i, 
    input logic [9:0] y_i, 
    // BUS ACCESS (WRITE-ONLY)
    input logic [31:0] bus_wdata_i, 
    input logic        vga_we_i,
    input logic frame_trig_i,   
    output logic [11:0] colour_out_o
    );

logic [$clog2(DISPLAY_WIDTH)-1:0] x_write;
logic [$clog2(DISPLAY_HEIGHT)-1:0] y_write;
logic [11:0] colour_in;

localparam integer DEPTH = DISPLAY_WIDTH*DISPLAY_HEIGHT;

logic [$clog2(DEPTH) - 1:0] write_addr;
logic [$clog2(DEPTH) - 1:0] read_addr;

logic [INPUT_COLOUR_BITS - 1:0] frame_buffer_q [0:DEPTH - 1];

assign x_write = bus_wdata_i[9:1];
assign y_write = bus_wdata_i[19:11];
assign colour_in = bus_wdata_i[31:20];
assign write_addr = y_write * DISPLAY_WIDTH + x_write;
assign read_addr = (y_i >> 1)* DISPLAY_WIDTH + (x_i >> 1);

logic [INPUT_COLOUR_BITS - 1:0] colour_8bit_q; 
assign colour_out_o = {colour_8bit_q[7:5], 1'b0, colour_8bit_q[4:2], 1'b0, colour_8bit_q[1:0], 2'b0};

always@(posedge clk_i) begin
    if (vga_we_i) begin
      frame_buffer_q[write_addr] <= colour_in[INPUT_COLOUR_BITS - 1:0];
    end
    colour_8bit_q <= frame_buffer_q[read_addr];
//    colour_8bit_q <= 8'hF0;

end
    
endmodule
