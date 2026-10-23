`timescale 1ns / 1ps

`include "alu_ops.vh"

module alu_control(
  input logic [2:0] funct3_i,
  input logic [0:0] funct7_5_i,
  input logic [1:0] ctrl_alu_op_i,
  output logic [3:0] alu_ctrl_o
);


always @ (*)
begin
  casez (ctrl_alu_op_i)
    `ALU_OP_MATH:
    begin
      if (funct3_i[1:0] == 2'b01)
        alu_ctrl_o = {funct7_5_i,funct3_i};
      else
        alu_ctrl_o = {1'b0,funct3_i};
    end
    `ALU_OP_BEQ: alu_ctrl_o = `SUB;
    `ALU_OP_MEM: alu_ctrl_o = `ADD;
    default:
      alu_ctrl_o = `ADD;
  endcase
    


end

endmodule