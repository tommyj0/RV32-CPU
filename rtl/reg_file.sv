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
    input logic           clk,
    input logic [4:0]     read_reg1,
    input logic [4:0]     read_reg2,
    input logic [4:0]     write_reg,
    input logic [31:0]    write_data,
    input logic           write_reg_enable,
    output logic [31:0]   read_data1,
    output logic [31:0]   read_data2
);

logic [31:0] regs [1:31];

assign read_data1 = (read_reg1 == 'h0) ? 'h0 : regs[read_reg1];
assign read_data2 = (read_reg2 == 'h0) ? 'h0 : regs[read_reg2];

always@(posedge clk)
begin
    if (write_reg_enable)
        regs[write_reg] <= write_data;
end

endmodule
