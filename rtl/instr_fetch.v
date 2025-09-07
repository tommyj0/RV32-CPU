`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// MODULE: instr_fetch

module instr_fetch(
    input               clk,
    input               rst,
    input               branch_mem_if,
    input       [31:0]  PC_branch_mem_if,
    output      [31:0]  instr_if_id,
    output      [31:0]  PC_if_id
);

wire    [31:0]  Next_PC;
reg     [31:0]  PC_reg;

assign PC_if_id = PC_reg;
assign Next_PC = (branch_mem_if) ? PC_branch_mem_if : PC_reg + 4;

always@(posedge clk)
begin
    if (rst)
        PC_reg <= 32'h0;
    else
        PC_reg <= Next_PC;
end

rom #(
    .ROMAddrWidth(16),
    .ROMWordWidth(32),
    .INIT_FILE("rom.mem")
) rom_inst (
    .clk(clk),
    .addr(PC_reg),
    .r_data(instr_if_id)
);


endmodule