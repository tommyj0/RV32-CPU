`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
//
// MODULE: CPU
//
////////////////////////////////////////////////////////////////////////////////



module cpu(
    input               clk,
    input               rst,
    output [15:0]       led
);

// Instruction Fetch wires
wire [31:0] PC_branch_mem_if;
wire        branch_mem_if;

wire [31:0] PC_if_id;
wire [31:0] instr_if_id;

// Instruction Fetch instanciation
instr_fetch u_instr_fetch(
    .clk(clk),
    .rst(rst),
    .branch_mem_if(branch_mem_if),
    .PC_branch_mem_if(PC_branch_mem_if),
    .instr_if_id(instr_if_id),
    .PC_if_id(PC_if_id)
);

// Decode wires
wire [31:0] rs1_id_exe;
wire [31:0] rs2_id_exe;
wire [31:0] PC_id_exe;
wire [31:0] imm_id_exe;
wire [4:0]  write_reg_wb_id;
wire [31:0] write_data_wb_id;
wire        write_reg_enable_wb_id;

wire [4:0]  write_reg_id_exe;

// Decode instanciation
decode u_decode(
    .clk(clk),
    .rst(rst),
    .instr_if_id(instr_if_id),
    .PC_if_id(PC_if_id),
    .write_reg_wb_id(write_reg_wb_id),
    .write_data_wb_id(write_data_wb_id),
    .write_reg_enable_wb_id(write_reg_enable_wb_id),
    .rs1_id_exe(rs1_id_exe),
    .rs2_id_exe(rs2_id_exe),
    .PC_id_exe(PC_id_exe),
    .imm_id_exe(imm_id_exe),
    .write_reg_id_exe(write_reg_id_exe)
);

// Execute wires
wire [31:0] alu_result_exe_mem;
wire        zero_exe_mem;
wire [31:0] PC_branch_exe_mem;
wire [31:0] rs2_exe_mem;
wire [4:0]  write_reg_exe_mem;

// Execute instanciation
execute u_execute(
    .clk(clk),
    .rst(rst),
    .PC_id_exe(PC_id_exe),
    .rs1_id_exe(rs1_id_exe),
    .rs2_id_exe(rs2_id_exe),
    .imm_id_exe(imm_id_exe),
    .alu_src_id_exe(),
    .alu_op_id_exe(),
    .write_reg_id_exe(write_reg_id_exe),
    .alu_result_exe_mem(alu_result_exe_mem),
    .zero_exe_mem(zero_exe_mem),
    .PC_branch_exe_mem(PC_branch_exe_mem),
    .rs2_exe_mem(rs2_exe_mem),
    .write_reg_exe_mem(write_reg_exe_mem)
);

// Memory Access wires
wire [31:0] r_data_mem_wb;
wire [31:0] reg_out_mem_wb;
wire        mem_to_reg_mem_wb;
wire [4:0]  write_reg_wb_mem;

// Memory Access instanciation
mem_access u_mem_access(
    // inputs
    .clk(clk),
    .mem_read_exe_mem(),
    .mem_write_exe_mem(),
    .mem_to_reg_exe_mem(),
    .alu_out_exe_mem(alu_result_exe_mem),
    .w_data_exe_mem(rs2_exe_mem),
    .write_reg_exe_mem(write_reg_exe_mem),
    // output
    .r_data_mem_wb(r_data_mem_wb),
    .reg_out_mem_wb(reg_out_mem_wb),
    .mem_to_reg_mem_wb(mem_to_reg_mem_wb),
    .write_reg_wb_mem(write_reg_wb_mem)
);

// write back instanciation
write_back u_write_back(
    // inputs
    .r_data_mem_wb(r_data_mem_wb),
    .reg_out_mem_wb(reg_out_mem_wb),
    .mem_to_reg_mem_wb(mem_to_reg_mem_wb),
    .write_reg_enable_mem_wb(write_reg_enable_mem_wb),
    .write_reg_mem_wb(write_reg_mem_wb),
    // outputs
    .write_data_wb_id(write_data_wb_id),
    .write_reg_enable_wb_id(write_reg_enable_wb_id),
    .write_reg_wb_id(write_reg_wb_id)
);


assign led = r_data_mem_wb[15:0];

endmodule