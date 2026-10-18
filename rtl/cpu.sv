`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
//
// MODULE: CPU
//
////////////////////////////////////////////////////////////////////////////////


module cpu(
    input logic               clk,
    input logic               rst,
    input logic  [31:0]       rom_rdata,
    input logic  [31:0]       ram_rdata,
    output logic              ram_we,
    output logic [31:0]       ram_wdata,
    output logic [31:0]       rom_addr,
    output logic [31:0]       ram_addr,
    output logic [15:0]       led
);

// Instruction Fetch wires
logic [31:0] PC_branch_mem_if;
assign PC_branch_mem_if = 0; // TODO fix
logic        ctrl_branch_mem_if;

logic [31:0] PC_if_id;
logic [31:0] instr_if_id;

// Instruction Fetch instanciation
instr_fetch u_instr_fetch(
    .clk(clk),
    .rst(rst),
    .branch_mem_if(ctrl_branch_mem_if),
    .PC_branch_mem_if(PC_branch_mem_if),
    .stall(stall_id),
    // .instr_if_id(instr_if_id),
    .PC_if_id(PC_if_id)
);
assign instr_if_id = rom_rdata;
assign rom_addr = PC_if_id;

// Decode wires
logic [31:0] rs1_id_exe;
logic [31:0] rs2_id_exe;
logic [31:0] PC_id_exe;
logic [31:0] imm_id_exe;
logic [4:0]  write_reg_wb_id;
logic [31:0] write_data_wb_id;
logic [0:0]  ctrl_write_reg_wb_id; // finish at id

logic [4:0]  write_reg_id_exe;

logic [0:0]  stall_id; // typically the first stall, will go to both EXE and IF


// ctrl wires
logic [0:0]    ctrl_branch_id_exe; // finishes at instr_fetch
logic [0:0]    ctrl_mem_read_id_exe; // finishes at mem_access
logic [0:0]    ctrl_mem_to_reg_id_exe; // finish at wb
logic [1:0]    ctrl_alu_op_id_exe; // finish at exe
logic [0:0]    ctrl_mem_write_id_exe; // finish at mem
logic [0:0]    ctrl_alu_src_id_exe; // finish at exe
logic [0:0]    ctrl_write_reg_id_exe; // finish at id

// alu ctrl wires
logic [2:0]    funct3_id_exe;
logic [0:0]    funct7_5_id_exe;

// Decode instanciation
decode u_decode(
    .clk(clk),
    .rst(rst),
    .instr_if_id(instr_if_id),
    .PC_if_id(PC_if_id),
    .write_reg_wb_id(write_reg_wb_id),
    .write_data_wb_id(write_data_wb_id),
    .write_reg_enable_wb_id(ctrl_write_reg_wb_id),
    .rs1_id_exe(rs1_id_exe),
    .rs2_id_exe(rs2_id_exe),
    .PC_id_exe(PC_id_exe),
    .imm_id_exe(imm_id_exe),
    .write_reg_id_exe(write_reg_id_exe),
    .ctrl_branch_id_exe(ctrl_branch_id_exe),
    .ctrl_mem_read_id_exe(ctrl_mem_read_id_exe),
    .ctrl_mem_to_reg_id_exe(ctrl_mem_to_reg_id_exe),
    .ctrl_alu_op_id_exe(ctrl_alu_op_id_exe),
    .ctrl_mem_write_id_exe(ctrl_mem_write_id_exe),
    .ctrl_alu_src_id_exe(ctrl_alu_src_id_exe),
    .ctrl_write_reg_id_exe(ctrl_write_reg_id_exe),
    .funct3_id_exe(funct3_id_exe),
    .funct7_5_id_exe(funct7_5_id_exe),
    .stall_out(stall_id)
);

// Execute wires
logic [31:0] alu_result_exe_mem;
logic        zero_exe_mem;
logic [31:0] PC_branch_exe_mem;
logic [31:0] rs2_exe_mem;
logic [4:0]  write_reg_exe_mem;

// ctrl wires
logic [0:0]    ctrl_branch_exe_mem; // finishes at instr_fetch
logic [0:0]    ctrl_mem_read_exe_mem; // finishes at mem_access
logic [0:0]    ctrl_mem_to_reg_exe_mem; // finish at wb
logic [0:0]    ctrl_mem_write_exe_mem; // finish at mem
logic [0:0]    ctrl_write_reg_exe_mem; // finish at id


// Execute instanciation
execute u_execute(
    // inputs
    .clk(clk),
    .rst(rst),
    .PC_id_exe(PC_id_exe),
    .rs1_id_exe(rs1_id_exe),
    .rs2_id_exe(rs2_id_exe),
    .imm_id_exe(imm_id_exe),
    .ctrl_alu_src_id_exe(ctrl_alu_src_id_exe),
    .ctrl_alu_op_id_exe(ctrl_alu_op_id_exe),
    .ctrl_branch_id_exe(ctrl_branch_id_exe),
    .ctrl_mem_read_id_exe(ctrl_mem_read_id_exe),
    .ctrl_mem_to_reg_id_exe(ctrl_mem_to_reg_id_exe),
    .ctrl_mem_write_id_exe(ctrl_mem_write_id_exe),
    .ctrl_write_reg_id_exe(ctrl_write_reg_id_exe),
    .write_reg_id_exe(write_reg_id_exe),
    .funct3_id_exe(funct3_id_exe),
    .funct7_5_id_exe(funct7_5_id_exe),
    // outputs
    .alu_result_exe_mem(alu_result_exe_mem),
    .zero_exe_mem(zero_exe_mem),
    .PC_branch_exe_mem(PC_branch_exe_mem), // TODO connect to mem
    .rs2_exe_mem(rs2_exe_mem),
    .write_reg_exe_mem(write_reg_exe_mem),
    .ctrl_branch_exe_mem(ctrl_branch_exe_mem),
    .ctrl_mem_read_exe_mem(ctrl_mem_read_exe_mem),
    .ctrl_mem_to_reg_exe_mem(ctrl_mem_to_reg_exe_mem),
    .ctrl_mem_write_exe_mem(ctrl_mem_write_exe_mem),
    .ctrl_write_reg_exe_mem(ctrl_write_reg_exe_mem)
);

// Memory Access wires
logic [31:0] r_data_mem_wb;
logic [31:0] reg_out_mem_wb;
logic [4:0]  write_reg_mem_wb;

// ctrl wires
// logic [0:0]    ctrl_branch_mem_if; // finishes at instr_fetch
logic [0:0]    ctrl_mem_to_reg_mem_wb; // finish at wb
logic [0:0]    ctrl_write_reg_mem_wb; // finish at id

// Memory Access instanciation
mem_access u_mem_access(
    // INPUTS
    .clk(clk),
    .ctrl_branch_exe_mem(ctrl_branch_exe_mem),
    .ctrl_mem_read_exe_mem(ctrl_mem_read_exe_mem),
    // .ctrl_mem_write_exe_mem(ctrl_mem_write_exe_mem),
    .ctrl_mem_to_reg_exe_mem(ctrl_mem_to_reg_exe_mem),
    .ctrl_write_reg_exe_mem(ctrl_write_reg_exe_mem),
    .alu_out_exe_mem(alu_result_exe_mem),
    // .w_data_exe_mem(rs2_exe_mem),
    .write_reg_exe_mem(write_reg_exe_mem),
    // .r_data_mem_wb(r_data_mem_wb),
    // OUTPUTS
    .reg_out_mem_wb(reg_out_mem_wb),
    .write_reg_mem_wb(write_reg_mem_wb),
    .ctrl_branch_mem_wb(ctrl_branch_mem_if),
    .ctrl_mem_to_reg_mem_wb(ctrl_mem_to_reg_mem_wb),
    .ctrl_write_reg_mem_wb(ctrl_write_reg_mem_wb)
);

assign r_data_mem_wb = ram_rdata;

assign ram_addr = alu_result_exe_mem;

assign ram_we = ctrl_mem_write_exe_mem;

assign ram_wdata = rs2_exe_mem;


// write back instanciation
write_back u_write_back(
    // inputs
    .clk(clk),
    .r_data_mem_wb(r_data_mem_wb),
    .reg_out_mem_wb(reg_out_mem_wb),
    .write_reg_mem_wb(write_reg_mem_wb),
    // .ctrl_branch_mem_wb(ctrl_branch_mem_wb),
    .ctrl_mem_to_reg_mem_wb(ctrl_mem_to_reg_mem_wb),
    .ctrl_write_reg_mem_wb(ctrl_write_reg_mem_wb),
    // outputs
    .write_data_wb_id(write_data_wb_id),
    .write_reg_wb_id(write_reg_wb_id),
    .ctrl_write_reg_wb_id(ctrl_write_reg_wb_id)
    // .ctrl_branch_wb_if(ctrl_branch_wb_if)
);


assign led = r_data_mem_wb[15:0];

endmodule