`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2025 11:21:52 PM
// Design Name: 
// Module Name: reg_file
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


module reg_file(
    input logic           clk_i,
    input logic [4:0]     read_reg1_i,
    input logic [4:0]     read_reg2_i,
    input logic [4:0]     write_reg_i,
    input logic [31:0]    write_data_i,
    input logic           write_reg_enable_i,
    output logic [31:0]   read_data1_o,
    output logic [31:0]   read_data2_o
);

logic [31:0] regs_q [1:31];

assign read_data1_o = (read_reg1_i == 'h0) ? 'h0 : regs_q[read_reg1_i];
assign read_data2_o = (read_reg2_i == 'h0) ? 'h0 : regs_q[read_reg2_i];

always@(posedge clk_i)
begin
    if (write_reg_enable_i)
        regs_q[write_reg_i] <= write_data_i;
end

endmodule
