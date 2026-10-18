`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// MODULE: instr_fetch
//////////////////////////////////////////////////////////////////////////////////

module instr_fetch
(
    // INPUTS
    input logic               clk,
    input logic               rst,
    input logic               branch_mem_if,
    input logic       [31:0]  PC_branch_mem_if,
    input logic               stall,
    // OUTPUTS
    // output logic [31:0]  instr_if_id,
    output logic      [31:0]  PC_if_id
);

logic    [31:0]  Next_PC;
logic     [31:0]  PC_reg;

assign PC_if_id = PC_reg;
// assign Next_PC = (branch_mem_if) ? PC_branch_mem_if : (stall) ? PC_reg : PC_reg + 4;
assign Next_PC = (stall) ? PC_reg : (branch_mem_if) ? PC_branch_mem_if : PC_reg + 4;

always@(posedge clk)
begin
    if (rst)
        PC_reg <= 32'h0;
    else
        PC_reg <= Next_PC;
end

endmodule