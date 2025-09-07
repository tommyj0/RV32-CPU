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
    input               rst,
    input [31:0]        instr_if_id,
    input [31:0]        PC_if_id,
    input [4:0]         write_reg_wb_id,
    input [31:0]        write_data_wb_id,
    input               write_reg_enable_wb_id,
    output reg [31:0]   rs1_id_exe,
    output reg [31:0]   rs2_id_exe,
    output reg [31:0]   PC_id_exe,
    output reg [31:0]   imm_id_exe,
    output reg [4:0]    write_reg_id_exe
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
    if (rst)
    begin
        rs1_id_exe <= 'h0;
        rs2_id_exe <= 'h0;
        PC_id_exe <= 'h0;
        imm_id_exe <= 'h0;
        write_reg_id_exe <= 'h0;
    end
    else
    begin
        rs1_id_exe <= read_data1;
        rs2_id_exe <= read_data2;
        PC_id_exe <= PC_if_id;
        imm_id_exe <= Next_imm;
        write_reg_id_exe <= instr_if_id[11:7];
    end
end

reg_file u_reg_file (
    .clk(clk),
    .read_reg1(instr_if_id[19:15]),
    .read_reg2(instr_if_id[24:20]),
    .write_reg(write_reg_wb_id),
    .write_data(write_data_wb_id),
    .write_reg_enable(write_reg_enable_wb_id),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

endmodule