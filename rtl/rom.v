`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2025 09:57:01 PM
// Design Name: 
// Module Name: rom
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


module rom(
    input clk,
    input [31:0] addr, // byte addressed
    output reg [31:0] data

);

parameter RAMAddrWidth = 16;
parameter RAMWordWidth = 32;
parameter INIT_FILE = "rom.mem";

wire [RAMWordWidth - 3:0] addr_4b; // 4 byte addressed

reg [RAMWordWidth - 1:0] mem [2**RAMAddrWidth-1:0];

assign addr_4b = addr[RAMWordWidth - 1:2];

initial $readmemh(INIT_FILE, mem);

always@(posedge clk)
    data <= mem[addr_4b];
    
    
endmodule
