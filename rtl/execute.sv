`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// MODULE: execute


module execute(
        
        // INPUTS
        input logic               clk,
        input logic               rst,
        // inputs from decode
        input logic [31:0]        PC_id_exe,
        input logic [31:0]        rs1_id_exe,
        input logic [31:0]        rs2_id_exe,
        input logic [31:0]        imm_id_exe,
        input logic               ctrl_alu_src_id_exe,
        input logic [1:0]         ctrl_alu_op_id_exe,
        input logic [0:0]         ctrl_branch_id_exe, // finishes at instr_fetch
        input logic [0:0]         ctrl_mem_read_id_exe, // finishes at mem_access
        input logic [0:0]         ctrl_mem_to_reg_id_exe, // finish at wb
        input logic [0:0]         ctrl_mem_write_id_exe, // finish at mem
        input logic [0:0]         ctrl_write_reg_id_exe, // finish at id
        input logic [4:0]         write_reg_id_exe,
        input logic [2:0]         funct3_id_exe,
        input logic [0:0]         funct7_5_id_exe,
        // OUTPUTS
        output logic [31:0]   alu_result_exe_mem,
        output logic          zero_exe_mem,
        output logic [31:0]   PC_branch_exe_mem,
        output logic [31:0]   rs2_exe_mem,
        output logic [4:0]    write_reg_exe_mem,
        output logic [0:0]    ctrl_branch_exe_mem, // finishes at instr_fetch
        output logic [0:0]    ctrl_mem_read_exe_mem, // finishes at mem_access
        output logic [0:0]    ctrl_mem_to_reg_exe_mem, // finish at wb
        output logic [0:0]    ctrl_mem_write_exe_mem, // finish at mem
        output logic [0:0]    ctrl_write_reg_exe_mem // finish at id

);
logic [31:0] alu_in1;
logic [31:0] alu_in2;

logic     [31:0]  Next_PC_sum;
logic    [31:0]  Next_alu_result;

// synchronous
always@(posedge clk)
begin
    if (rst)
    begin
        PC_branch_exe_mem <= 32'h0;
        alu_result_exe_mem <= 32'h0;
        zero_exe_mem <= 1'b0;
        rs2_exe_mem <= 32'h0;
        write_reg_exe_mem <= 5'h0;
        ctrl_branch_exe_mem <= 'h0;
        ctrl_mem_read_exe_mem <= 'h0;
        ctrl_mem_to_reg_exe_mem <= 'h0;
        ctrl_mem_write_exe_mem <= 'h0;
        ctrl_write_reg_exe_mem <= 'h0;
    end
    else
    begin
        PC_branch_exe_mem <= Next_PC_sum; 
        alu_result_exe_mem <= Next_alu_result;
        zero_exe_mem <= Next_zero;
        rs2_exe_mem <= rs2_id_exe;   
        write_reg_exe_mem <= write_reg_id_exe;
        ctrl_branch_exe_mem <= ctrl_branch_id_exe;
        ctrl_mem_read_exe_mem <= ctrl_mem_read_id_exe;
        ctrl_mem_to_reg_exe_mem <= ctrl_mem_to_reg_id_exe;
        ctrl_mem_write_exe_mem <= ctrl_mem_write_id_exe;
        ctrl_write_reg_exe_mem <= ctrl_write_reg_id_exe;
    end
end

// asynchronous
always@(*)
begin
    Next_PC_sum = PC_id_exe + (imm_id_exe << 1);
end

assign alu_in1 = rs1_id_exe;
assign alu_in2 = ctrl_alu_src_id_exe ? imm_id_exe : rs2_id_exe;


logic [3:0] alu_ctrl;
alu_control u_alu_control (
   .funct3(funct3_id_exe),
   .funct7_5(funct7_5_id_exe),
   .ctrl_alu_op(ctrl_alu_op_id_exe),
   .alu_ctrl(alu_ctrl)
);

alu u_alu(
    .in1(alu_in1),
    .in2(alu_in2),
    .alu_op(alu_ctrl),
    .zero(Next_zero),
    .alu_result(Next_alu_result),
    .overflow()
);
endmodule