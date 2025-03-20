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
        // instruction opcode from fetch
        input       [6:0]   instr,
        // asynch outputs
        output reg          branch,
        output reg          mem_read,
        output reg          mem_to_reg,
        output reg  [1:0]   alu_op, // tells the ALU control what format the instr is
        output reg          mem_write,
        output reg          alu_src,
        output reg          reg_write
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
        case(instr)
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
        endcase
    end
endmodule