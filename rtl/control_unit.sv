`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2025 09:57:01 PM
// Design Name: 
// Module Name: control_unit
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
`include "opcodes.vh"

module control_unit(
    // instruction opcode_i from fetch
    input logic       [6:0]   opcode_i,
    // asynch outputs
    output logic          branch_o,
    output logic          mem_read_o,
    output logic          mem_to_reg_o,
    output logic  [1:0]   alu_op_o, // tells the ALU control what format the instr is
    output logic          mem_write_o,
    output logic          alu_src_o,
    output logic          reg_write_o
);

always@(*)
begin
    branch_o = 'b0;
    mem_read_o = 'b0;
    mem_to_reg_o = 'b0;
    alu_op_o = 'b0;
    mem_write_o = 'b0;
    alu_src_o = 'b0;
    reg_write_o = 'b0;
    case(opcode_i)
        `LOAD: 
        begin
            mem_read_o = 'b1;
            mem_to_reg_o = 'b1;
            alu_src_o = 'b1;
            reg_write_o = 'b1;
        end
        `MATHI:
        begin
            alu_op_o = 'b11;
            alu_src_o = 'b1;
            reg_write_o = 'b1;
        end
        `AUIPC:
        begin
            reg_write_o = 'b1;
            alu_src_o = 'b1;
        end
        `STORE:
        begin
            mem_write_o = 'b1;
            alu_src_o = 'b1;
        end
        `MATHR:
        begin
            reg_write_o = 'b1;
            alu_op_o = 'b10;
        end
        `LUI:
        begin
            reg_write_o = 'b1;
            alu_src_o = 'b1;
        end
        `BRANCH:
        begin
            branch_o = 'b1;
            alu_op_o = 'b01;
        end
        `JALR:
        begin
            reg_write_o = 'b1;
        end
        `JAL:
        begin
            reg_write_o = 'b1;
        end
        default:
        begin
            branch_o = 'b0;
            mem_read_o = 'b0;
            mem_to_reg_o = 'b0;
            alu_op_o = 'b0;
            mem_write_o = 'b0;
            alu_src_o = 'b0;
            reg_write_o = 'b0;
        end
    endcase
end
endmodule