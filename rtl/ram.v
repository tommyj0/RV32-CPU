`timescale 1ns / 1ps



module ram #
(
    parameter RAMAddrWidth = 16,
    parameter RAMWordWidth = 32,
    parameter INIT_FILE = "ram.mem"
)
(
    input               clk,
    input               we,
    input       [RAMAddrWidth - 1:0]  addr, // byte addressed
    input       [RAMWordWidth - 1:0]  w_data,
    output reg  [RAMWordWidth -1 :0]  r_data

);


wire [RAMAddrWidth - 3:0] addr_4b; // 4 byte addressed

reg [RAMWordWidth - 1:0] mem [0:2**(RAMAddrWidth - $clog2(RAMWordWidth >> 3)) - 1];

assign addr_4b = addr[RAMAddrWidth - 1:2];

initial $readmemh(INIT_FILE, mem);

always@(posedge clk)
begin
    if (we)
        mem[addr_4b] <= w_data;
    else
        r_data <= mem[addr_4b];
end
endmodule