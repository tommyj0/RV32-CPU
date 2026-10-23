`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2025 09:57:01 PM
// Design Name: 
// Module Name: write_back
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


module write_back(
    input logic clk_i,
    input logic       [31:0]  r_data_mem_wb_i,
    input logic       [31:0]  reg_out_mem_wb_i,
    input logic       [4:0]   write_reg_mem_wb_i,
    // input logic         ctrl_branch_mem_wb_i,
    input logic               ctrl_mem_to_reg_mem_wb_i,
    input logic               ctrl_write_reg_mem_wb_i,
    output logic      [31:0]  write_data_wb_id_o,
    output logic      [4:0]   write_reg_wb_id_o,
    output logic      [0:0]   ctrl_write_reg_wb_id_o
    // output logic [0:0]   ctrl_branch_wb_if_o
);

assign write_data_wb_id_o = ctrl_mem_to_reg_mem_wb_i ? r_data_mem_wb_i : reg_out_mem_wb_i;   
assign ctrl_write_reg_wb_id_o = ctrl_write_reg_mem_wb_i;
assign write_reg_wb_id_o = write_reg_mem_wb_i;

// always @ (posedge clk_i)
// begin
//     ctrl_branch_wb_if_q <= ctrl_branch_mem_wb_i;
// end
endmodule
