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
    input               mem_to_reg_mem_wb,
    input               write_reg_enable_mem_wb,
    input       [31:0]  r_data_mem_wb,
    input       [4:0]   write_reg_mem_wb,
    input       [31:0]  reg_out_mem_wb,
    output      [31:0]  write_data_wb_id,
    output              write_reg_enable_wb_id,
    output      [4:0]   write_reg_wb_id
);

assign write_data_wb_id = mem_to_reg_mem_wb ? r_data_mem_wb : reg_out_mem_wb;   
assign write_reg_enable_wb_id = write_reg_enable_mem_wb;
assign write_reg_wb_id = write_reg_mem_wb;
endmodule
