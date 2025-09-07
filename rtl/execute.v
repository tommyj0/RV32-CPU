`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// MODULE: execute


module execute(
        
        input               clk,
        input               rst,
        // inputs from decode
        input [31:0]        PC_id_exe,
        input [31:0]        rs1_id_exe,
        input [31:0]        rs2_id_exe,
        input [31:0]        imm_id_exe,
        input               alu_src_id_exe,
        input [3:0]         alu_op_id_exe,
        input [4:0]         write_reg_id_exe,
        // Sync outputs
        output reg [31:0]   alu_result_exe_mem,
        output reg          zero_exe_mem,
        output reg [31:0]   PC_branch_exe_mem,
        output reg [31:0]   rs2_exe_mem,
        output reg [4:0]    write_reg_exe_mem

);
wire [31:0] alu_in1;
wire [31:0] alu_in2;

reg     [31:0]  Next_PC_sum;
wire    [31:0]  Next_alu_result;

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
    end
    else
    begin
        PC_branch_exe_mem <= Next_PC_sum; 
        alu_result_exe_mem <= Next_alu_result;
        zero_exe_mem <= Next_zero;
        rs2_exe_mem <= rs2_id_exe;   
        write_reg_exe_mem <= write_reg_id_exe;
    end
end

// asynchronous
always@(*)
begin
    Next_PC_sum = PC_id_exe + (imm_id_exe << 1);
end

assign alu_in1 = rs1_id_exe;
assign alu_in2 = alu_src_id_exe ? imm_id_exe : rs2_id_exe;

alu u_alu(
    .in1(alu_in1),
    .in2(alu_in2),
    .alu_op(),
    .zero(Next_zero),
    .alu_result(Next_alu_result),
    .overflow()
);
endmodule