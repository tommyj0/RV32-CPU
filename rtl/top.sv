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
  output logic [15:0] led_o,
  output logic [11:0] colour_out_o,
  output logic HS_o,
  output logic VS_o
);


// I/O bus wires
logic [31:0] bus_addr;
logic [31:0] bus_rdata;
logic [31:0] bus_wdata;
logic        bus_we;

assign bus_rdata = 32'h0000_0000; // TODO

core core1 (
  .clk_i(clk_i),
  .rst_i(rst_i),
  .bus_rdata_i(bus_rdata),
  .bus_addr_o(bus_addr),
  .bus_wdata_o(bus_wdata),
  .bus_we_o(bus_we),
  .led_o(led_o)
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
    .colour_out_o(colour_out_o),
    .x_o(x),
    .y_o(y),
    .HS_o(HS_o),
    .VS_o(VS_o),
    .frame_trig_o(frame_trig_q)
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
    .clk_i(clk_i),
    .rst_i(rst_i),
    // .colour_in_i(12'hF0F),
    .colour_out_o(colour),
    .x_i(x),
    .y_i(y),
    .bus_wdata_i(bus_wdata),
    .vga_we_i(vga_we),
    .frame_trig_i(frame_trig_q)
);

endmodule
