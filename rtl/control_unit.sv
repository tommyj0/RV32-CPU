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
    output logic          branch,
    output logic          mem_read,
    output logic          mem_to_reg,
    output logic  [1:0]   alu_op, // tells the ALU control what format the instr is
    output logic          mem_write,
    output logic          alu_src,
    output logic          reg_write
);

always@(*)
begin
    branch = 'b0;
    mem_read = 'b0;
    mem_to_reg = 'b0;
    alu_op = 'b0;
    mem_write = 'b0;
    alu_src = 'b0;
    reg_write = 'b0;
    case(opcode_i)
        `LOAD: 
        begin
            mem_read = 'b1;
            mem_to_reg = 'b1;
            alu_src = 'b1;
            reg_write = 'b1;
        end
        `MATHI:
        begin
            alu_op = 'b11;
            alu_src = 'b1;
            reg_write = 'b1;
        end
        `AUIPC:
        begin
            reg_write = 'b1;
            alu_src = 'b1;
        end
        `STORE:
        begin
            mem_write = 'b1;
            alu_src = 'b1;
        end
        `MATHR:
        begin
            reg_write = 'b1;
            alu_op = 'b10;
        end
        `LUI:
        begin
            reg_write = 'b1;
            alu_src = 'b1;
        end
        `BRANCH:
        begin
            branch = 'b1;
            alu_op = 'b01;
        end
        `JALR:
        begin
            reg_write = 'b1;
        end
        `JAL:
        begin
            reg_write = 'b1;
        end
        default:
        begin
            branch = 'b0;
            mem_read = 'b0;
            mem_to_reg = 'b0;
            alu_op = 'b0;
            mem_write = 'b0;
            alu_src = 'b0;
            reg_write = 'b0;
        end
    endcase
end
endmodule