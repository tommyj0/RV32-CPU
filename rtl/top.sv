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
  input logic clk_i,
  input logic rst_i,
  input logic [4:0] btns_i,
  output logic [15:0] led,
  output logic [11:0] colour_out,
  output logic HS,
  output logic VS
);


// I/O bus wires
logic [31:0] bus_addr;
logic [31:0] bus_rdata_i;
logic [31:0] bus_wdata;
logic        bus_we;

assign bus_rdata_i = 32'h0000_0000; // TODO

core core1 (
  .clk_i(clk_i),
  .rst_i(rst_i),
  .bus_rdata_i(bus_rdata_i),
  .bus_addr(bus_addr),
  .bus_wdata(bus_wdata),
  .bus_we(bus_we),
  .led(led)
);
    
// VGA logic
logic [11:0]         colour;
logic [10:0]         x;
logic [9:0]          y;
logic                frame_trig_q;

vga_driver  #
(
  .DISPLAY_WIDTH(DISPLAY_WIDTH),
  .DISPLAY_HEIGHT(DISPLAY_HEIGHT)
)
vga_driver1
(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .colour_in_i(colour),
    .colour_out_q(colour_out),
    .x(x),
    .y(y),
    .HS_q(HS),
    .VS_q(VS),
    .frame_trig_q(frame_trig_q)
);

logic vga_we_i;

assign vga_we_i = bus_addr == `VGA_ADDR ? 1'b1 : 1'b0; // TODO choose a range

vga_memory  #
(
  .DISPLAY_WIDTH(DISPLAY_WIDTH/DISPLAY_SCALE),
  .DISPLAY_HEIGHT(DISPLAY_HEIGHT/DISPLAY_SCALE)
)
vga_memory1
(
    .clk_i(clk_i),
    .rst_i(rst_i),
    // .colour_in_i(12'hF0F),
    .colour_out(colour),
    .x_i(x),
    .y_i(y),
    .bus_wdata_i(bus_wdata),
    .vga_we_i(vga_we_i),
    .frame_trig_i(frame_trig_q)
);

endmodule