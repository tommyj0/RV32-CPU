`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// MODULE: core
//////////////////////////////////////////////////////////////////////////////////
`include "reg_map.vh"

module core #
(
    parameter ROMAddrWidth = 10,
    parameter ROMDataWidth = 32,
    parameter RAMAddrWidth = 10,
    parameter RAMDataWidth = 32
)
(
  input logic clk,
  input logic rst,
  input logic  [31:0] bus_rdata,
  output logic [31:0] bus_addr,
  output logic [31:0] bus_wdata,
  output logic        bus_we,
  output logic [15:0] led
);
logic [31:0]    rom_rdata;
logic [31:0]    ram_rdata;
logic [0:0]     ram_we;
logic [31:0]    ram_wdata;
logic [31:0]    rom_addr;
logic [31:0]    ram_addr;

logic [31:0]    ram_rdata_cpu;

logic bus_access;
logic ram_access;

assign bus_access = ((ram_addr & `QUAD_MASK) == `IO_BASE_ADDR) ? 1'b1 : 1'b0;  // 4th quadrant of addressing space for bus
assign bus_we = ram_we & bus_access;
assign bus_wdata = ram_wdata;

assign ram_access = ((ram_addr & `QUAD_MASK) == `RAM_BASE_ADDR) ? 1'b1 : 1'b0;

assign bus_addr = ram_addr;



assign ram_rdata_cpu = ram_access ? ram_rdata : bus_rdata; // TODO: this ram_access should be delayed by a cycle

cpu cpu1 (
    .clk(clk),
    .rst(rst),
    .rom_rdata(rom_rdata),
    .ram_rdata(ram_rdata_cpu),
    .ram_we(ram_we),
    .ram_wdata(ram_wdata),
    .rom_addr(rom_addr),
    .ram_addr(ram_addr),
    .led(led)
);

rom #(
    .ROMAddrWidth(ROMAddrWidth),
    .ROMWordWidth(ROMDataWidth),
    .INIT_FILE("rom.mem")
) rom1 (
    .clk(clk),
    .addr(rom_addr[ROMAddrWidth - 1:0]),
    .r_data(rom_rdata) // output logic is clocked so OK to input logic comb logic
);


ram #(
    .RAMAddrWidth(RAMAddrWidth),
    .RAMWordWidth(RAMDataWidth),
    .INIT_FILE("ram.mem")
) ram1 (
    .clk(clk),
    .we(ram_we & ram_access),
    .addr(ram_addr[RAMAddrWidth - 1:0]),
    .w_data(ram_wdata[RAMDataWidth - 1:0]),
    .r_data(ram_rdata[RAMDataWidth - 1:0])
);

endmodule