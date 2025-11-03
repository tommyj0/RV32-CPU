`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// MODULE: top
//////////////////////////////////////////////////////////////////////////////////

// system specific top
module top#
(
  parameter DISPLAY_WIDTH=800,
  parameter DISPLAY_HEIGHT=600
)
(
  input clk,
  input rst,
  output [15:0] led,
  output [11:0] colour_out,
  output HS,
  output VS
);

// I/O bus wires
wire [31:0] bus_addr;
wire [31:0] bus_rdata;
wire [31:0] bus_wdata;
wire        bus_we;

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
wire [11:0]         colour;
wire [10:0]         x;
wire [9:0]          y;

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

wire vga_we;

assign vga_we = 0; // TODO choose a range

vga_memory  #
(
  .DISPLAY_WIDTH(DISPLAY_WIDTH),
  .DISPLAY_HEIGHT(DISPLAY_HEIGHT)
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