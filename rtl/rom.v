`timescale 1ns / 1ps



module rom #
(
    parameter ROMAddrWidth = 16,
    parameter ROMWordWidth = 32,
    parameter INIT_FILE = "rom.mem"
)
(
    input clk,
    input [ROMAddrWidth - 1:0] addr, // byte addressed
    output reg [ROMWordWidth - 1:0] r_data

);


wire [ROMAddrWidth - 3:0] addr_4b; // 4 byte addressed

reg [ROMWordWidth - 1:0] mem [2**(ROMAddrWidth - $clog2(ROMWordWidth >> 3)) - 1:0];

assign addr_4b = addr[ROMAddrWidth - 1:2];

initial $readmemh(INIT_FILE, mem);

// reads are synchronous to encourage Vivado to instantiate B-RAM
always@(posedge clk)
    r_data <= mem[addr_4b]; 
    
    
endmodule
