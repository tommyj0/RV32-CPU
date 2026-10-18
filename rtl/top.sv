`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// MODULE: top
//////////////////////////////////////////////////////////////////////////////////

// system specific top
`include "reg_map.vh"

// `define VGA_ADDR 32'h0001_0000
module top #
(
  parameter DISPLAY_WIDTH=800,
  parameter DISPLAY_HEIGHT=600,
  parameter DISPLAY_SCALE=2
)
(
  input logic clk,
  input logic rst,
  input logic [4:0] btns,
  output logic [15:0] led,
  output logic [11:0] colour_out,
  output logic HS,
  output logic VS
);


// I/O bus wires
logic [31:0] bus_addr;
logic [31:0] bus_rdata;
logic [31:0] bus_wdata;
logic        bus_we;

assign bus_rdata = 32'h0000_0000; // TODO

core core1 (
  .clk(clk),
  .rst(rst),
  .bus_rdata(bus_rdata),
  .bus_addr(bus_addr),
  .bus_wdata(bus_wdata),
  .bus_we(bus_we),
  .led(led)
);
    
// VGA logic
logic [11:0]         colour;
logic [10:0]         x;
logic [9:0]          y;

vga_driver  #
(
  .DISPLAY_WIDTH(DISPLAY_WIDTH),
  .DISPLAY_HEIGHT(DISPLAY_HEIGHT)
)
vga_driver1
(
    .clk(clk),
    .rst(rst),
    .colour_in(colour),
    .colour_out(colour_out),
    .x(x),
    .y(y),
    .HS(HS),
    .VS(VS),
    .frame_trig(frame_trig)
);

logic vga_we;

assign vga_we = bus_addr == `VGA_ADDR ? 1'b1 : 1'b0; // TODO choose a range

vga_memory  #
(
  .DISPLAY_WIDTH(DISPLAY_WIDTH/DISPLAY_SCALE),
  .DISPLAY_HEIGHT(DISPLAY_HEIGHT/DISPLAY_SCALE)
)
vga_memory1
(
    .clk(clk),
    .rst(rst),
    // .colour_in(12'hF0F),
    .colour_out(colour),
    .x(x),
    .y(y),
    .bus_wdata(bus_wdata),
    .vga_we(vga_we),
    .frame_trig(frame_trig)
);

endmodule