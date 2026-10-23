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
  input logic clk_i,
  input logic rst_i,
  input logic  [31:0] bus_rdata_i,
  output logic [31:0] bus_addr_o,
  output logic [31:0] bus_wdata_o,
  output logic        bus_we_o,
  output logic [15:0] led_o
);
logic [31:0]    rom_rdata_q;
logic [31:0]    ram_rdata_q;
logic [0:0]     ram_we;
logic [31:0]    ram_wdata;
logic [31:0]    rom_addr;
logic [31:0]    ram_addr;

logic [31:0]    ram_rdata_cpu;

logic bus_access;
logic ram_access;

assign bus_access = ((ram_addr & `QUAD_MASK) == `IO_BASE_ADDR) ? 1'b1 : 1'b0;  // 4th quadrant of addressing space for bus
assign bus_we_o = ram_we & bus_access;
assign bus_wdata_o = ram_wdata;

assign ram_access = ((ram_addr & `QUAD_MASK) == `RAM_BASE_ADDR) ? 1'b1 : 1'b0;

assign bus_addr_o = ram_addr;



assign ram_rdata_cpu = ram_access ? ram_rdata_q : bus_rdata_i; // TODO: this ram_access should be delayed by a cycle

cpu cpu1 (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .rom_rdata_i(rom_rdata_q),
    .ram_rdata_i(ram_rdata_cpu),
    .ram_we_o(ram_we),
    .ram_wdata_o(ram_wdata),
    .rom_addr_o(rom_addr),
    .ram_addr_o(ram_addr),
    .led_o(led_o)
);

rom #(
    .ROMAddrWidth(ROMAddrWidth),
    .ROMWordWidth(ROMDataWidth),
    .INIT_FILE("rom.mem")
) rom1 (
    .clk_i(clk_i),
    .addr_i(rom_addr[ROMAddrWidth - 1:0]),
    .r_data_o(rom_rdata_q)
);


ram #(
    .RAMAddrWidth(RAMAddrWidth),
    .RAMWordWidth(RAMDataWidth),
    .INIT_FILE("ram.mem")
) ram1 (
    .clk_i(clk_i),
    .we_i(ram_we & ram_access),
    .addr_i(ram_addr[RAMAddrWidth - 1:0]),
    .w_data_i(ram_wdata[RAMDataWidth - 1:0]),
    .r_data_o(ram_rdata_q[RAMDataWidth - 1:0])
);

endmodule