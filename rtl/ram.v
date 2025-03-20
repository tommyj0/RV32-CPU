`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2025 09:57:01 PM
// Design Name: 
// Module Name: ram
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


module ram(
    input               clk,
    input               we,
    input       [31:0]  addr, // byte addressed
    input       [31:0]  w_data,
    output reg  [31:0]  r_data

);

parameter RAMAddrWidth = 16;
parameter RAMWordWidth = 32;
parameter INIT_FILE = "ram.mem";

wire [RAMWordWidth - 3:0] addr_4b; // 4 byte addressed

reg [RAMWordWidth - 1:0] mem [2**RAMAddrWidth-1:0];

assign addr_4b = addr[RAMWordWidth - 1:2];

initial $readmemh(INIT_FILE, mem);

always@(posedge clk)
    if (we)
        mem[addr_4b] <= w_data;
    else
        r_data <= mem[addr_4b];
endmodule