`timescale 1ns / 1ps

module mem_access # (
    parameter AddrWidth = 10,
    parameter DataWidth = 32
) (
    // INPUTS
    input logic               clk,
    input logic               ctrl_branch_exe_mem,
    input logic               ctrl_mem_read_exe_mem,
    // input logic         ctrl_mem_write_exe_mem,
    input logic               ctrl_mem_to_reg_exe_mem,
    input logic               ctrl_write_reg_exe_mem,
    input logic       [31:0]  alu_out_exe_mem,
    // input logic [31:0]  w_data_exe_mem,
    input logic       [4:0]   write_reg_exe_mem,
    // OUTPUTS
    // output logic [31:0]  r_data_mem_wb,
    output logic  [31:0]  reg_out_mem_wb,
    output logic  [4:0]   write_reg_mem_wb,
    output logic          ctrl_branch_mem_wb,
    output logic          ctrl_mem_to_reg_mem_wb,
    output logic          ctrl_write_reg_mem_wb
);

always@(posedge clk)
begin
    begin
        reg_out_mem_wb <= alu_out_exe_mem;
        write_reg_mem_wb <= write_reg_exe_mem;
        ctrl_branch_mem_wb <= ctrl_branch_exe_mem;
        ctrl_mem_to_reg_mem_wb <= ctrl_mem_to_reg_exe_mem;
        ctrl_write_reg_mem_wb <= ctrl_write_reg_exe_mem;
    end
end

endmodule