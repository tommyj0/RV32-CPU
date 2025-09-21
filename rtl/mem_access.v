`timescale 1ns / 1ps

module mem_access(
    input               clk,
    input               mem_read_exe_mem,
    input               mem_write_exe_mem,
    input               mem_to_reg_exe_mem,
    input       [31:0]  alu_out_exe_mem,
    input       [31:0]  w_data_exe_mem,
    input       [4:0]   write_reg_exe_mem,
    output      [31:0]  r_data_mem_wb,
    output reg  [31:0]  reg_out_mem_wb,
    output reg          mem_to_reg_mem_wb,
    output reg  [4:0]   write_reg_wb_mem 
);

wire [31:0] ram_addr;
assign ram_addr = alu_out_exe_mem;

always@(posedge clk)
begin
//    if (rst)
//    begin
//        reg_out_mem_wb <= 'h0;
//        mem_to_reg_mem_wb <= 1'b0;
//        write_reg_wb_mem <= 'h0;
//    end
//    else
    begin
        reg_out_mem_wb <= alu_out_exe_mem;
        mem_to_reg_mem_wb <= mem_to_reg_exe_mem;
        write_reg_wb_mem <= write_reg_exe_mem;
    end
end

ram #(
    .RAMAddrWidth(16),
    .RAMWordWidth(32),
    .INIT_FILE("ram.mem")
) u_ram (
    .clk(clk),
    .we(mem_write_exe_mem),
    .addr(ram_addr),
    .w_data(w_data_exe_mem),
    .r_data(r_data_mem_wb)
);

endmodule