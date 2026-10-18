`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
//
// MODULE: CPU
//
////////////////////////////////////////////////////////////////////////////////


module cpu(
    input logic               clk_i,
    input logic               rst_i,
    input logic  [31:0]       rom_rdata_i,
    input logic  [31:0]       ram_rdata_i,
    output logic              ram_we,
    output logic [31:0]       ram_wdata,
    output logic [31:0]       rom_addr,
    output logic [31:0]       ram_addr,
    output logic [15:0]       led
);

// Instruction Fetch wires
logic [31:0] PC_branch_mem_if_i;
assign PC_branch_mem_if_i = 0; // TODO fix
logic        ctrl_branch_mem_if_i;

logic [31:0] PC_if_id_q;
logic [31:0] instr_if_id_i;

// Instruction Fetch instanciation
instr_fetch u_instr_fetch(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .branch_mem_if_i(ctrl_branch_mem_if_i),
    .PC_branch_mem_if_i(PC_branch_mem_if_i),
    .stall_i(stall_id),
    // .instr_if_id_i(instr_if_id_i),
    .PC_if_id_q(PC_if_id_q)
);
assign instr_if_id_i = rom_rdata_i;
assign rom_addr = PC_if_id_q;

// Decode wires
logic [31:0] rs1_id_exe_q;
logic [31:0] rs2_id_exe_q;
logic [31:0] PC_id_exe_q;
logic [31:0] imm_id_exe_q;
logic [4:0]  write_reg_wb_id_i;
logic [31:0] write_data_wb_id_i;
logic [0:0]  ctrl_write_reg_wb_id; // finish at id

logic [4:0]  write_reg_id_exe_q;

logic [0:0]  stall_id; // typically the first stall_i, will go to both EXE and IF


// ctrl wires
logic [0:0]    ctrl_branch_id_exe_q; // finishes at instr_fetch
logic [0:0]    ctrl_mem_read_id_exe_q; // finishes at mem_access
logic [0:0]    ctrl_mem_to_reg_id_exe_q; // finish at wb
logic [1:0]    ctrl_alu_op_id_exe_q; // finish at exe
logic [0:0]    ctrl_mem_write_id_exe_q; // finish at mem_q
logic [0:0]    ctrl_alu_src_id_exe_q; // finish at exe
logic [0:0]    ctrl_write_reg_id_exe_q; // finish at id

// alu ctrl wires
logic [2:0]    funct3_id_exe_q;
logic [0:0]    funct7_5_id_exe_q;

// Decode instanciation
decode u_decode(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .instr_if_id_i(instr_if_id_i),
    .PC_if_id_i(PC_if_id_q),
    .write_reg_wb_id_i(write_reg_wb_id_i),
    .write_data_wb_id_i(write_data_wb_id_i),
    .write_reg_enable_wb_id_i(ctrl_write_reg_wb_id),
    .rs1_id_exe_q(rs1_id_exe_q),
    .rs2_id_exe_q(rs2_id_exe_q),
    .PC_id_exe_q(PC_id_exe_q),
    .imm_id_exe_q(imm_id_exe_q),
    .write_reg_id_exe_q(write_reg_id_exe_q),
    .ctrl_branch_id_exe_q(ctrl_branch_id_exe_q),
    .ctrl_mem_read_id_exe_q(ctrl_mem_read_id_exe_q),
    .ctrl_mem_to_reg_id_exe_q(ctrl_mem_to_reg_id_exe_q),
    .ctrl_alu_op_id_exe_q(ctrl_alu_op_id_exe_q),
    .ctrl_mem_write_id_exe_q(ctrl_mem_write_id_exe_q),
    .ctrl_alu_src_id_exe_q(ctrl_alu_src_id_exe_q),
    .ctrl_write_reg_id_exe_q(ctrl_write_reg_id_exe_q),
    .funct3_id_exe_q(funct3_id_exe_q),
    .funct7_5_id_exe_q(funct7_5_id_exe_q),
    .stall_out_q(stall_id)
);

// Execute wires
logic [31:0] alu_result_exe_mem_q;
logic        zero_exe_mem_q;
logic [31:0] PC_branch_exe_mem_q;
logic [31:0] rs2_exe_mem_q;
logic [4:0]  write_reg_exe_mem_q;

// ctrl wires
logic [0:0]    ctrl_branch_exe_mem_q; // finishes at instr_fetch
logic [0:0]    ctrl_mem_read_exe_mem_q; // finishes at mem_access
logic [0:0]    ctrl_mem_to_reg_exe_mem_q; // finish at wb
logic [0:0]    ctrl_mem_write_exe_mem_q; // finish at mem_q
logic [0:0]    ctrl_write_reg_exe_mem_q; // finish at id


// Execute instanciation
execute u_execute(
    // inputs
    .clk_i(clk_i),
    .rst_i(rst_i),
    .PC_id_exe_i(PC_id_exe_q),
    .rs1_id_exe_i(rs1_id_exe_q),
    .rs2_id_exe_i(rs2_id_exe_q),
    .imm_id_exe_i(imm_id_exe_q),
    .ctrl_alu_src_id_exe_i(ctrl_alu_src_id_exe_q),
    .ctrl_alu_op_id_exe_i(ctrl_alu_op_id_exe_q),
    .ctrl_branch_id_exe_i(ctrl_branch_id_exe_q),
    .ctrl_mem_read_id_exe_i(ctrl_mem_read_id_exe_q),
    .ctrl_mem_to_reg_id_exe_i(ctrl_mem_to_reg_id_exe_q),
    .ctrl_mem_write_id_exe_i(ctrl_mem_write_id_exe_q),
    .ctrl_write_reg_id_exe_i(ctrl_write_reg_id_exe_q),
    .write_reg_id_exe_i(write_reg_id_exe_q),
    .funct3_id_exe_i(funct3_id_exe_q),
    .funct7_5_id_exe_i(funct7_5_id_exe_q),
    // outputs
    .alu_result_exe_mem_q(alu_result_exe_mem_q),
    .zero_exe_mem_q(zero_exe_mem_q),
    .PC_branch_exe_mem_q(PC_branch_exe_mem_q), // TODO connect to mem_q
    .rs2_exe_mem_q(rs2_exe_mem_q),
    .write_reg_exe_mem_q(write_reg_exe_mem_q),
    .ctrl_branch_exe_mem_q(ctrl_branch_exe_mem_q),
    .ctrl_mem_read_exe_mem_q(ctrl_mem_read_exe_mem_q),
    .ctrl_mem_to_reg_exe_mem_q(ctrl_mem_to_reg_exe_mem_q),
    .ctrl_mem_write_exe_mem_q(ctrl_mem_write_exe_mem_q),
    .ctrl_write_reg_exe_mem_q(ctrl_write_reg_exe_mem_q)
);

// Memory Access wires
logic [31:0] r_data_mem_wb_i;
logic [31:0] reg_out_mem_wb_q;
logic [4:0]  write_reg_mem_wb_q;

// ctrl wires
// logic [0:0]    ctrl_branch_mem_if_i; // finishes at instr_fetch
logic [0:0]    ctrl_mem_to_reg_mem_wb_q; // finish at wb
logic [0:0]    ctrl_write_reg_mem_wb_q; // finish at id

// Memory Access instanciation
mem_access u_mem_access(
    // INPUTS
    .clk_i(clk_i),
    .ctrl_branch_exe_mem_i(ctrl_branch_exe_mem_q),
    .ctrl_mem_read_exe_mem_i(ctrl_mem_read_exe_mem_q),
    // .ctrl_mem_write_exe_mem_i(ctrl_mem_write_exe_mem_q),
    .ctrl_mem_to_reg_exe_mem_i(ctrl_mem_to_reg_exe_mem_q),
    .ctrl_write_reg_exe_mem_i(ctrl_write_reg_exe_mem_q),
    .alu_out_exe_mem_i(alu_result_exe_mem_q),
    // .w_data_exe_mem_i(rs2_exe_mem_q),
    .write_reg_exe_mem_i(write_reg_exe_mem_q),
    // .r_data_mem_wb(r_data_mem_wb_i),
    // OUTPUTS
    .reg_out_mem_wb_q(reg_out_mem_wb_q),
    .write_reg_mem_wb_q(write_reg_mem_wb_q),
    .ctrl_branch_mem_wb_q(ctrl_branch_mem_if_i),
    .ctrl_mem_to_reg_mem_wb_q(ctrl_mem_to_reg_mem_wb_q),
    .ctrl_write_reg_mem_wb_q(ctrl_write_reg_mem_wb_q)
);

assign r_data_mem_wb_i = ram_rdata_i;

assign ram_addr = alu_result_exe_mem_q;

assign ram_we = ctrl_mem_write_exe_mem_q;

assign ram_wdata = rs2_exe_mem_q;


// write back instanciation
write_back u_write_back(
    // inputs
    .clk_i(clk_i),
    .r_data_mem_wb_i(r_data_mem_wb_i),
    .reg_out_mem_wb_i(reg_out_mem_wb_q),
    .write_reg_mem_wb_i(write_reg_mem_wb_q),
    // .ctrl_branch_mem_wb_i(ctrl_branch_mem_wb_q),
    .ctrl_mem_to_reg_mem_wb_i(ctrl_mem_to_reg_mem_wb_q),
    .ctrl_write_reg_mem_wb_i(ctrl_write_reg_mem_wb_q),
    // outputs
    .write_data_wb_id(write_data_wb_id_i),
    .write_reg_wb_id(write_reg_wb_id_i),
    .ctrl_write_reg_wb_id(ctrl_write_reg_wb_id)
    // .ctrl_branch_wb_if_q(ctrl_branch_wb_if)
);


assign led = r_data_mem_wb_i[15:0];

endmodule