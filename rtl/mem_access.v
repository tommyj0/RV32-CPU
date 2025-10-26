`timescale 1ns / 1ps

module mem_access # (
    parameter AddrWidth = 10,
    parameter DataWidth = 32
) (
    input               clk,
    input               ctrl_branch_exe_mem,
    input               ctrl_mem_read_exe_mem,
    input               ctrl_mem_write_exe_mem,
    input               ctrl_mem_to_reg_exe_mem,
    input               ctrl_write_reg_exe_mem,
    input       [31:0]  alu_out_exe_mem,
    input       [31:0]  w_data_exe_mem,
    input       [4:0]   write_reg_exe_mem,
    output      [31:0]  r_data_mem_wb,
    output reg  [31:0]  reg_out_mem_wb,
    output reg  [4:0]   write_reg_mem_wb,
    output reg          ctrl_branch_mem_wb,
    output reg          ctrl_mem_to_reg_mem_wb,
    output reg          ctrl_write_reg_mem_wb
);

wire [31:0] ram_addr;
assign ram_addr = alu_out_exe_mem;

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

ram #(
    .RAMAddrWidth(AddrWidth),
    .RAMWordWidth(DataWidth),
    .INIT_FILE("ram.mem")
) u_ram (
    .clk(clk),
    .we(ctrl_mem_write_exe_mem),
    .addr(ram_addr[AddrWidth - 1:0]),
    .w_data(w_data_exe_mem[DataWidth - 1:0]),
    .r_data(r_data_mem_wb[DataWidth - 1:0])
);

endmodule