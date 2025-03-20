`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2025 09:57:01 PM
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "alu_ops.vh"

module alu(
    input [31:0] in1,
    input [31:0] in2,
    input [3:0] alu_op,
    output zero,
    output reg [31:0] alu_result,
    output reg overflow
);

assign zero = (alu_result == 'h0);

always@(*)
begin
    case(alu_op)
        `ADD: {overflow,alu_result} = in1 + in2;
        `SUB: {overflow,alu_result} = in1 - in2;
        `AND: {overflow,alu_result} = in1 & in2;   
        `OR:  {overflow,alu_result} = in1 | in2;
        `XOR: {overflow,alu_result} = in1 ^ in2;
        `SLL: {overflow,alu_result} = in1 << in2;
        `SRL: {overflow,alu_result} = in1 >> in2;
        `SRA: {overflow,alu_result} = in1 >>> in2;
        `MUL: {overflow,alu_result} = in1 * in2;
        `DIV: {overflow,alu_result} = in1 / in2;
        `REM: {overflow,alu_result} = in1 % in2;
        default: alu_result = in1;
    endcase
end
endmodule
