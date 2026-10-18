`timescale 1ns / 1ps

`include "alu_ops.vh"

module alu_control(
  input logic [2:0] funct3,
  input logic [0:0] funct7_5,
  input logic [1:0] ctrl_alu_op,
  output logic [3:0] alu_ctrl
);


always @ (*)
begin
  casez (ctrl_alu_op)
    `ALU_OP_MATH:
    begin
      if (funct3[1:0] == 2'b01)
        alu_ctrl = {funct7_5,funct3};
      else
        alu_ctrl = {1'b0,funct3};
    end
    `ALU_OP_BEQ: alu_ctrl = `SUB;
    `ALU_OP_MEM: alu_ctrl = `ADD;
    default:
      alu_ctrl = `ADD;
  endcase
    


end

endmodule