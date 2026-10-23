`timescale 1ns / 1ps

`include "alu_ops.vh"

module alu(
    input logic [31:0] in1_i,
    input logic [31:0] in2_i,
    input logic [3:0] alu_op_i,
    output logic zero_o,
    output logic [31:0] alu_result_o,
    output logic overflow_o
);

assign zero_o = (alu_result_o == 'h0);

always@(*)
begin
overflow_o = 1'b0;
    case(alu_op_i)
        `ADD: {overflow_o,alu_result_o} = in1_i + in2_i;
        `SUB: {overflow_o,alu_result_o} = in1_i - in2_i;
        `AND: {overflow_o,alu_result_o} = in1_i & in2_i;   
        `OR:  {overflow_o,alu_result_o} = in1_i | in2_i;
        `XOR: {overflow_o,alu_result_o} = in1_i ^ in2_i;
        `SLL: {overflow_o,alu_result_o} = in1_i << in2_i;
        `SRL: {overflow_o,alu_result_o} = in1_i >> in2_i;
        `SRA: {overflow_o,alu_result_o} = in1_i >>> in2_i;
        `SLT: alu_result_o = in1_i < in2_i ? 'b1 : 'b0;
        `SLTU: alu_result_o = in1_i < in2_i ? 'b1 : 'b0;
        // `MUL: {overflow,alu_result} = in1_i * in2_i;
        // `DIV: {overflow,alu_result} = in1_i / in2_i;
        // `REM: {overflow,alu_result} = in1_i % in2_i;
        default: alu_result_o = in1_i;
    endcase
end
endmodule
