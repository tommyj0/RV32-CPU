`timescale 1ns / 1ps



module ram #
(
    parameter RAMAddrWidth = 16,
    parameter RAMWordWidth = 32,
    parameter INIT_FILE = "ram.mem"
)
(
    input logic               clk_i,
    input logic               we_i,
    input logic       [RAMAddrWidth - 1:0]  addr_i, // byte addressed
    input logic       [RAMWordWidth - 1:0]  w_data_i,
    output logic  [RAMWordWidth -1 :0]  r_data_o

);


logic [RAMAddrWidth - 3:0] addr_4b; // 4 byte addressed

logic [RAMWordWidth - 1:0] mem_q [0:2**(RAMAddrWidth - $clog2(RAMWordWidth >> 3)) - 1];
logic [RAMWordWidth - 1:0] r_data_q;

assign r_data_o = r_data_q;

assign addr_4b = addr_i[RAMAddrWidth - 1:2];

initial $readmemh(INIT_FILE, mem_q);

always@(posedge clk_i)
begin
    if (we_i)
        mem_q[addr_4b] <= w_data_i;
    else
        r_data_q <= mem_q[addr_4b];
end
endmodule