`timescale 1ns / 1ps



module rom #
(
    parameter ROMAddrWidth = 16,
    parameter ROMWordWidth = 32,
    parameter INIT_FILE = "rom.mem"
)
(
    input logic clk_i,
    input logic [ROMAddrWidth - 1:0] addr_i, // byte addressed
    output logic [ROMWordWidth - 1:0] r_data_o

);


logic [ROMAddrWidth - 3:0] addr_4b; // 4 byte addressed

logic [ROMWordWidth - 1:0] mem_q [0:2**(ROMAddrWidth - $clog2(ROMWordWidth >> 3)) - 1];
logic [ROMWordWidth - 1:0] r_data_q;

assign r_data_o = r_data_q;

assign addr_4b = addr_i[ROMAddrWidth - 1:2];

initial $readmemh(INIT_FILE, mem_q);

// reads are synchronous to encourage Vivado to instantiate B-RAM
always@(posedge clk_i)
    r_data_q <= mem_q[addr_4b]; 
    
    
endmodule
