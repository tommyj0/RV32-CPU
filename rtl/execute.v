`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2025 09:57:01 PM
// Design Name: 
// Module Name: execute
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


module execute(
        
        input               clk,
        // inputs from decode
        input [31:0]        PC,
        input [31:0]        rs1,
        input [31:0]        rs2,
        input [31:0]        imm,
        input               alu_src,
        input [3:0]         alu_op,
        // Synch outputs
        output reg [31:0]   alu_result,
        output reg          zero,
        output reg [31:0]   PC_sum,
        output reg [31:0]   rs2_w
);
wire [31:0] alu_in1;
wire [31:0] alu_in2;

reg [31:0]  Next_PC_sum;
wire [31:0]  Next_alu_result;

// synchronous
always@(posedge clk)
begin
    PC_sum <= Next_PC_sum; 
    alu_result <= Next_alu_result;
    zero <= Next_zero;
    rs2_w <= rs2;   
end

// asynchronous
always@(*)
begin
    Next_PC_sum = PC + (imm << 1);
end

assign alu_in1 = rs1;
assign alu_in2 = alu_src ? imm : rs2;

alu u_alu(
    .in1(alu_in1),
    .in2(alu_in2),
    .alu_op(),
    .zero(Next_zero),
    .alu_result(Next_alu_result)
);
endmodule