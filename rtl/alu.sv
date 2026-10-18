`timescale 1ns / 1ps

`include "alu_ops.vh"

module alu(
    input logic [31:0] in1_i,
    input logic [31:0] in2_i,
    input logic [3:0] alu_op_i,
    output logic zero,
    output logic [31:0] alu_result,
    output logic overflow
);

assign zero = (alu_result == 'h0);

always@(*)
begin
overflow = 1'b0;
    case(alu_op_i)
        `ADD: {overflow,alu_result} = in1_i + in2_i;
        `SUB: {overflow,alu_result} = in1_i - in2_i;
        `AND: {overflow,alu_result} = in1_i & in2_i;   
        `OR:  {overflow,alu_result} = in1_i | in2_i;
        `XOR: {overflow,alu_result} = in1_i ^ in2_i;
        `SLL: {overflow,alu_result} = in1_i << in2_i;
        `SRL: {overflow,alu_result} = in1_i >> in2_i;
        `SRA: {overflow,alu_result} = in1_i >>> in2_i;
        `SLT: alu_result = in1_i < in2_i ? 'b1 : 'b0;
        `SLTU: alu_result = in1_i < in2_i ? 'b1 : 'b0;
        // `MUL: {overflow,alu_result} = in1_i * in2_i;
        // `DIV: {overflow,alu_result} = in1_i / in2_i;
        // `REM: {overflow,alu_result} = in1_i % in2_i;
        default: alu_result = in1_i;
    endcase
end
endmodule
