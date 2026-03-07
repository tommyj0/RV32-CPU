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

`include "opcodes.vh"

// TODO: propagate the stalled instruction, NOP on every subsequent cycle

module decode(
    input               clk,
    input               rst,
    input [31:0]        instr_if_id,
    input [31:0]        PC_if_id,
    input [4:0]         write_reg_wb_id, // from wb
    input [31:0]        write_data_wb_id, // from wb
    input               write_reg_enable_wb_id, // from wb
    output reg [31:0]   rs1_id_exe,
    output reg [31:0]   rs2_id_exe,
    output reg [31:0]   PC_id_exe,
    output reg [31:0]   imm_id_exe,
    output reg [4:0]    write_reg_id_exe,
    output reg [0:0]    ctrl_branch_id_exe,
    output reg [0:0]    ctrl_mem_read_id_exe,
    output reg [0:0]    ctrl_mem_to_reg_id_exe,
    output reg [1:0]    ctrl_alu_op_id_exe,
    output reg [0:0]    ctrl_mem_write_id_exe,
    output reg [0:0]    ctrl_alu_src_id_exe,
    output reg [0:0]    ctrl_write_reg_id_exe,
    output reg [2:0]    funct3_id_exe,
    output reg [0:0]    funct7_5_id_exe,
    output reg [0:0]    stall_out
);

localparam [31:0] STALL_INSTRUCTION =  32'h00000013;  // addi x0,x0,0


wire [31:0]     in_instruction;
wire [31:0]     out_instruction;

wire [31:0]     read_data1;
wire [31:0]     read_data2;

// Instruction Segments
wire [6:0]      opcode;
wire [4:0]      rs1;
wire [4:0]      rs2;
wire [4:0]      rd;
wire [2:0]      funct3;

wire [6:0]      out_opcode;
wire [4:0]      out_rs1;
wire [4:0]      out_rs2;
wire [4:0]      out_rd;
wire [2:0]      out_funct3;
reg Next_stall;


assign in_instruction = instr_if_id;
assign out_instruction = stall_out ? STALL_INSTRUCTION : instr_if_id; // change on synchronous stall

assign opcode   = in_instruction[6:0];
assign rs1      = in_instruction[19:15];
assign rs2      = in_instruction[24:20];
assign rd       = in_instruction[11:7];
assign funct3   = in_instruction[14:12];

assign out_opcode   = out_instruction[6:0];
assign out_rs1      = out_instruction[19:15];
assign out_rs2      = out_instruction[24:20];
assign out_rd       = out_instruction[11:7];
assign out_funct3   = out_instruction[14:12];


wire [0:0] ctrl_branch_id_exe_next;
wire [0:0] ctrl_mem_read_id_exe_next;
wire [0:0] ctrl_mem_to_reg_id_exe_next;
wire [1:0] ctrl_alu_op_id_exe_next;
wire [0:0] ctrl_mem_write_id_exe_next;
wire [0:0] ctrl_alu_src_id_exe_next;
wire [0:0] ctrl_write_reg_id_exe_next;

reg [4:0]       read_reg1;
reg [4:0]       read_reg2;

reg_file u_reg_file (
    .clk(clk),
    .read_reg1(read_reg1),
    .read_reg2(read_reg2),
    .write_reg(write_reg_wb_id),
    .write_data(write_data_wb_id),
    .write_reg_enable(write_reg_enable_wb_id),
    .read_data1(read_data1),
    .read_data2(read_data2)
);


control_unit u_control_unit(
    // inputs
    .opcode(out_opcode),
    // outputs
    .branch(ctrl_branch_id_exe_next), //  BRANCH?
    .mem_read(ctrl_mem_read_id_exe_next), // READ FROM MEM?
    .mem_to_reg(ctrl_mem_to_reg_id_exe_next), // LOAD?
    .alu_op(ctrl_alu_op_id_exe_next), // tells the ALU control what format the instr is
    .mem_write(ctrl_mem_write_id_exe_next), // STORE?
    .alu_src(ctrl_alu_src_id_exe_next), // IMM USED INSTEAD OF RS2?
    .reg_write(ctrl_write_reg_id_exe_next) // REG WRITE?
);


localparam WRITTEN_REGS_BUF_LEN = 4;

reg [4:0]       Next_written_regs[0:WRITTEN_REGS_BUF_LEN-1];
reg [4:0]       written_regs[0:WRITTEN_REGS_BUF_LEN-1];

localparam JUMPS_BUF_LEN = 6;

reg [0:0]       Next_jumps[0:JUMPS_BUF_LEN-1];
reg [0:0]       jumps[0:JUMPS_BUF_LEN-1];

// NB: written_regs buffer saves a bit by storing x0 as the written reg when no regs are written.
//     this is done as x0 can't be written to and to avoid undefined values in the buf. 
integer j;
always@(*)
begin
        Next_written_regs[0] = 'h0; // default to x0
        // shift written regs up by one, effectively aging the other registers by one cycle
        for (j = 0; j < WRITTEN_REGS_BUF_LEN-1; j = j + 1)
            Next_written_regs[j+1] = written_regs[j];
        if (stall_out == 0 && ctrl_write_reg_id_exe_next)
            Next_written_regs[0] = rd;
        // for jumps
        Next_jumps[0] = 'h0;
        for (j = 0; j < JUMPS_BUF_LEN; j = j + 1)
            Next_jumps[j+1] = jumps[j];
        Next_jumps[0] = 0;
        if (stall_out == 0 && (opcode == `JALR || opcode == `JAL || opcode == `BRANCH))
            Next_jumps[0] = 1;
          

end


reg [4:0]       in_read_reg1;
reg [4:0]       in_read_reg2;

always@(*)
begin
    case (opcode)
        `JALR,
        `MATHI,
        `LOAD:
        begin
            in_read_reg1 = rs1;
            in_read_reg2 = 'h0;
        end
        `LUI,
        `AUIPC:
        begin
            in_read_reg1 = 'h0;
            in_read_reg2 = 'h0;
        end
        default:
        begin
            in_read_reg1 = rs1;
            in_read_reg2 = rs2;
        end
    endcase
end



always@(*)
begin
    case (out_opcode)
        `JALR,
        `MATHI,
        `LOAD:
        begin
            read_reg1 = out_rs1;
            read_reg2 = 'h0;
        end
        `LUI,
        `AUIPC:
        begin
            read_reg1 = 'h0;
            read_reg2 = 'h0;
        end
        default:
        begin
            read_reg1 = out_rs1;
            read_reg2 = out_rs2;
        end
    endcase
end

// STALL LOGIC
// logic that determines if the following cycle should be stall based on history buffers
integer k;
always@(*)
begin
    Next_stall = 0;
    // check for RAW hazards
    for (k = 0; k < WRITTEN_REGS_BUF_LEN; k = k + 1)
    begin
        if ((Next_written_regs[k] == in_read_reg1 && in_read_reg1 != 0) || (Next_written_regs[k] == in_read_reg2 && in_read_reg2 != 0))
            Next_stall = 1;
    end

    // check for control hazards
    for (k = 0; k < JUMPS_BUF_LEN; k = k + 1)
    begin
        if (Next_jumps[k] == 1)
            Next_stall = 1;
    end
end

// Immediate Generation
reg  [31:0]     Next_imm;

always@(*)
begin
    case (out_opcode)
        // I
        `JALR,
        `MATHI,
        `LOAD:
            Next_imm = {{20{out_instruction[31]}},out_instruction[31:20]};
        // SB
        `BRANCH:
            Next_imm = {{19{out_instruction[31]}},out_instruction[31],out_instruction[7],out_instruction[30:25],out_instruction[11:8],1'b0};
        // S
        `STORE:
            Next_imm = {{20{out_instruction[31]}},out_instruction[31:25],out_instruction[11:7]};
        // UJ
        `JAL:
            Next_imm = {{11{out_instruction[31]}},out_instruction[31],out_instruction[19:12],out_instruction[20],out_instruction[30:21],1'b0};
        // U
        `LUI,
        `AUIPC:
            Next_imm = {out_instruction[31:12],12'h000};
        // R
        default:
            Next_imm = 'h0;
    endcase
end


integer i;
always@(posedge clk)
begin
    if (rst)
    begin
        rs1_id_exe <= 'h0;
        rs2_id_exe <= 'h0;
        PC_id_exe <= 'h0;
        imm_id_exe <= 'h0;
        write_reg_id_exe <= 'h0;
        ctrl_branch_id_exe <= 'h0;
        ctrl_mem_read_id_exe <= 'h0;
        ctrl_mem_to_reg_id_exe <= 'h0;
        ctrl_alu_op_id_exe <= 'h0;
        ctrl_mem_write_id_exe <= 'h0;
        ctrl_alu_src_id_exe <= 'h0;
        ctrl_write_reg_id_exe <= 'h0;
        funct3_id_exe <= 'h0;
        funct7_5_id_exe <= 'h0;
        stall_out <= 'h0;
        for (i = 0; i < WRITTEN_REGS_BUF_LEN; i = i + 1)
            written_regs[i] = 'h0;
        for (i = 0; i < JUMPS_BUF_LEN; i = i + 1)
            jumps[i] = 'h0;
    end
    else
    begin
        rs1_id_exe <= read_data1;
        rs2_id_exe <= read_data2;
        PC_id_exe <= PC_if_id;
        imm_id_exe <= Next_imm;
        write_reg_id_exe <= rd;
        ctrl_branch_id_exe <= ctrl_branch_id_exe_next;
        ctrl_mem_read_id_exe <= ctrl_mem_read_id_exe_next;
        ctrl_mem_to_reg_id_exe <= ctrl_mem_to_reg_id_exe_next;
        ctrl_alu_op_id_exe <= ctrl_alu_op_id_exe_next;
        ctrl_mem_write_id_exe <= ctrl_mem_write_id_exe_next;
        ctrl_alu_src_id_exe <= ctrl_alu_src_id_exe_next;
        ctrl_write_reg_id_exe <= ctrl_write_reg_id_exe_next;
        funct3_id_exe <= out_funct3;
        funct7_5_id_exe <= out_instruction[30];
        stall_out = Next_stall;
        for (i = 0; i < WRITTEN_REGS_BUF_LEN; i = i + 1)
            written_regs[i] = Next_written_regs[i];
        for (i = 0; i < JUMPS_BUF_LEN-1; i = i + 1) 
            jumps[i] = Next_jumps[i];
    end
end

endmodule