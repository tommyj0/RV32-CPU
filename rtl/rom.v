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
    output reg [31:0] r_data

);

parameter ROMAddrWidth = 16;
parameter ROMWordWidth = 32;
parameter INIT_FILE = "rom.mem";

wire [ROMWordWidth - 3:0] addr_4b; // 4 byte addressed

reg [ROMWordWidth - 1:0] mem [2**ROMAddrWidth-1:0];

assign addr_4b = addr[ROMWordWidth - 1:2];

initial $readmemh(INIT_FILE, mem);

always@(posedge clk)
    r_data <= mem[addr_4b];
    
    
endmodule
