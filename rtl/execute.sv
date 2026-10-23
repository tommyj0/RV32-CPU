`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// MODULE: execute


module execute(
        
        // INPUTS
        input logic               clk_i,
        input logic               rst_i,
        // inputs from decode
        input logic [31:0]        PC_id_exe_i,
        input logic [31:0]        rs1_id_exe_i,
        input logic [31:0]        rs2_id_exe_i,
        input logic [31:0]        imm_id_exe_i,
        input logic               ctrl_alu_src_id_exe_i,
        input logic [1:0]         ctrl_alu_op_id_exe_i,
        input logic [0:0]         ctrl_branch_id_exe_i, // finishes at instr_fetch
        input logic [0:0]         ctrl_mem_read_id_exe_i, // finishes at mem_access
        input logic [0:0]         ctrl_mem_to_reg_id_exe_i, // finish at wb
        input logic [0:0]         ctrl_mem_write_id_exe_i, // finish at mem_q
        input logic [0:0]         ctrl_write_reg_id_exe_i, // finish at id
        input logic [4:0]         write_reg_id_exe_i,
        input logic [2:0]         funct3_id_exe_i,
        input logic [0:0]         funct7_5_id_exe_i,
        // OUTPUTS
        output logic [31:0]   alu_result_exe_mem_o,
        output logic          zero_exe_mem_o,
        output logic [31:0]   PC_branch_exe_mem_o,
        output logic [31:0]   rs2_exe_mem_o,
        output logic [4:0]    write_reg_exe_mem_o,
        output logic [0:0]    ctrl_branch_exe_mem_o, // finishes at instr_fetch
        output logic [0:0]    ctrl_mem_read_exe_mem_o, // finishes at mem_access
        output logic [0:0]    ctrl_mem_to_reg_exe_mem_o, // finish at wb
        output logic [0:0]    ctrl_mem_write_exe_mem_o, // finish at mem_q
        output logic [0:0]    ctrl_write_reg_exe_mem_o // finish at id

);
logic [31:0] alu_result_exe_mem_q;
logic zero_exe_mem_q;
logic [31:0] PC_branch_exe_mem_q;
logic [31:0] rs2_exe_mem_q;
logic [4:0] write_reg_exe_mem_q;
logic ctrl_branch_exe_mem_q;
logic ctrl_mem_read_exe_mem_q;
logic ctrl_mem_to_reg_exe_mem_q;
logic ctrl_mem_write_exe_mem_q;
logic ctrl_write_reg_exe_mem_q;

logic [31:0] alu_in1;
logic [31:0] alu_in2;

logic     [31:0]  Next_PC_sum;
logic    [31:0]  Next_alu_result;
logic            Next_zero;

// synchronous
always@(posedge clk_i)
begin
    if (rst_i)
    begin
        PC_branch_exe_mem_q <= 32'h0;
        alu_result_exe_mem_q <= 32'h0;
        zero_exe_mem_q <= 1'b0;
        rs2_exe_mem_q <= 32'h0;
        write_reg_exe_mem_q <= 5'h0;
        ctrl_branch_exe_mem_q <= 'h0;
        ctrl_mem_read_exe_mem_q <= 'h0;
        ctrl_mem_to_reg_exe_mem_q <= 'h0;
        ctrl_mem_write_exe_mem_q <= 'h0;
        ctrl_write_reg_exe_mem_q <= 'h0;
    end
    else
    begin
        PC_branch_exe_mem_q <= Next_PC_sum; 
        alu_result_exe_mem_q <= Next_alu_result;
        zero_exe_mem_q <= Next_zero;
        rs2_exe_mem_q <= rs2_id_exe_i;   
        write_reg_exe_mem_q <= write_reg_id_exe_i;
        ctrl_branch_exe_mem_q <= ctrl_branch_id_exe_i;
        ctrl_mem_read_exe_mem_q <= ctrl_mem_read_id_exe_i;
        ctrl_mem_to_reg_exe_mem_q <= ctrl_mem_to_reg_id_exe_i;
        ctrl_mem_write_exe_mem_q <= ctrl_mem_write_id_exe_i;
        ctrl_write_reg_exe_mem_q <= ctrl_write_reg_id_exe_i;
    end
end

// asynchronous
always@(*)
begin
    Next_PC_sum = PC_id_exe_i + (imm_id_exe_i << 1);
end

logic [3:0] alu_ctrl;
alu_control u_alu_control (
   .funct3_i(funct3_id_exe_i),
   .funct7_5_i(funct7_5_id_exe_i),
   .ctrl_alu_op_i(ctrl_alu_op_id_exe_i),
   .alu_ctrl_o(alu_ctrl)
);

alu u_alu(
    .in1_i(alu_in1),
    .in2_i(alu_in2),
    .alu_op_i(alu_ctrl),
    .zero_o(Next_zero),
    .alu_result_o(Next_alu_result),
    .overflow()
);

assign alu_in1 = rs1_id_exe_i;
assign alu_in2 = ctrl_alu_src_id_exe_i ? imm_id_exe_i : rs2_id_exe_i;

assign alu_result_exe_mem_o = alu_result_exe_mem_q;
assign zero_exe_mem_o = zero_exe_mem_q;
assign PC_branch_exe_mem_o = PC_branch_exe_mem_q;
assign rs2_exe_mem_o = rs2_exe_mem_q;
assign write_reg_exe_mem_o = write_reg_exe_mem_q;
assign ctrl_branch_exe_mem_o = ctrl_branch_exe_mem_q;
assign ctrl_mem_read_exe_mem_o = ctrl_mem_read_exe_mem_q;
assign ctrl_mem_to_reg_exe_mem_o = ctrl_mem_to_reg_exe_mem_q;
assign ctrl_mem_write_exe_mem_o = ctrl_mem_write_exe_mem_q;
assign ctrl_write_reg_exe_mem_o = ctrl_write_reg_exe_mem_q;
endmodule
