`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2025 09:57:01 PM
// Design Name: 
// Module Name: decode
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


module decode(
    input               clk,
    input [31:0]        instr,
    input [31:0]        PC,
    input [4:0]         write_reg,
    input [31:0]        write_data,
    input               write_reg_enable,
    output reg [31:0]   rs1,
    output reg [31:0]   rs2,
    output reg [31:0]   PC_out,
    output reg [31:0]   imm,
    output reg [4:0]    write_reg_dec   
);

wire [31:0]     read_data1;
wire [31:0]     read_data2;
reg  [31:0]     Next_imm;

always@(*)
begin
    Next_imm = 'h0; // TODO
end

always@(posedge clk)
begin
    rs1 <= read_data1;
    rs2 <= read_data2;
    PC_out <= PC;
    imm <= Next_imm;
    write_reg_dec <= instr[11:7];
end

reg_file u_reg_file (
    .clk(clk),
    .read_reg1(instr[19:15]),
    .read_reg2(instr[24:20]),
    .write_reg(write_reg),
    .write_data(write_data),
    .write_reg_enable(write_reg_enable),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

endmodule