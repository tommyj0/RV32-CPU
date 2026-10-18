`timescale 1ns / 1ps

`include "alu_ops.vh"

module alu(
    input logic [31:0] in1,
    input logic [31:0] in2,
    input logic [3:0] alu_op,
    output logic zero,
    output logic [31:0] alu_result,
    output logic overflow
);

assign zero = (alu_result == 'h0);

always@(*)
begin
overflow = 1'b0;
    case(alu_op)
        `ADD: {overflow,alu_result} = in1 + in2;
        `SUB: {overflow,alu_result} = in1 - in2;
        `AND: {overflow,alu_result} = in1 & in2;   
        `OR:  {overflow,alu_result} = in1 | in2;
        `XOR: {overflow,alu_result} = in1 ^ in2;
        `SLL: {overflow,alu_result} = in1 << in2;
        `SRL: {overflow,alu_result} = in1 >> in2;
        `SRA: {overflow,alu_result} = in1 >>> in2;
        `SLT: alu_result = in1 < in2 ? 'b1 : 'b0;
        `SLTU: alu_result = in1 < in2 ? 'b1 : 'b0;
        // `MUL: {overflow,alu_result} = in1 * in2;
        // `DIV: {overflow,alu_result} = in1 / in2;
        // `REM: {overflow,alu_result} = in1 % in2;
        default: alu_result = in1;
    endcase
end
endmodule
