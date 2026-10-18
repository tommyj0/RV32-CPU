`timescale 1ns / 1ps

module mem_access # (
    parameter AddrWidth = 10,
    parameter DataWidth = 32
) (
    // INPUTS
    input logic               clk_i,
    input logic               ctrl_branch_exe_mem_i,
    input logic               ctrl_mem_read_exe_mem_i,
    // input logic         ctrl_mem_write_exe_mem_i,
    input logic               ctrl_mem_to_reg_exe_mem_i,
    input logic               ctrl_write_reg_exe_mem_i,
    input logic       [31:0]  alu_out_exe_mem_i,
    // input logic [31:0]  w_data_exe_mem_i,
    input logic       [4:0]   write_reg_exe_mem_i,
    // OUTPUTS
    // output logic [31:0]  r_data_mem_wb,
    output logic  [31:0]  reg_out_mem_wb_q,
    output logic  [4:0]   write_reg_mem_wb_q,
    output logic          ctrl_branch_mem_wb_q,
    output logic          ctrl_mem_to_reg_mem_wb_q,
    output logic          ctrl_write_reg_mem_wb_q
);

always@(posedge clk_i)
begin
    begin
        reg_out_mem_wb_q <= alu_out_exe_mem_i;
        write_reg_mem_wb_q <= write_reg_exe_mem_i;
        ctrl_branch_mem_wb_q <= ctrl_branch_exe_mem_i;
        ctrl_mem_to_reg_mem_wb_q <= ctrl_mem_to_reg_exe_mem_i;
        ctrl_write_reg_mem_wb_q <= ctrl_write_reg_exe_mem_i;
    end
end

endmodule