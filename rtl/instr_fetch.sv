`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// MODULE: instr_fetch
//////////////////////////////////////////////////////////////////////////////////

module instr_fetch
(
    // INPUTS
    input logic               clk_i,
    input logic               rst_i,
    input logic               branch_mem_if_i,
    input logic       [31:0]  PC_branch_mem_if_i,
    input logic               stall_i,
    // OUTPUTS
    // output logic [31:0]  instr_if_id,
    output logic      [31:0]  PC_if_id_q
);

logic    [31:0]  Next_PC;
logic     [31:0]  PC_q;

assign PC_if_id_q = PC_q;
// assign Next_PC = (branch_mem_if_i) ? PC_branch_mem_if_i : (stall_i) ? PC_q : PC_q + 4;
assign Next_PC = (stall_i) ? PC_q : (branch_mem_if_i) ? PC_branch_mem_if_i : PC_q + 4;

always@(posedge clk_i)
begin
    if (rst_i)
        PC_q <= 32'h0;
    else
        PC_q <= Next_PC;
end

endmodule