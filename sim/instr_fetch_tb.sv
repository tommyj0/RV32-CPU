`timescale 1ns / 1ps

module instr_fetch_tb();
reg clk = 0;
reg rst = 1;

reg branch_mem_if = 0;
reg [31:0] PC_branch_mem_if = 'h0;
wire [31:0] instr_if_id;
wire [31:0] PC_if_id;

initial
  forever #5 clk = ~clk;

initial
    #100 rst = 0;
always@(posedge clk)
begin
    if ($random % 5 == 0) begin
        branch_mem_if <= 1;
        PC_branch_mem_if <= PC_branch_mem_if + ($random % 100);
    end
    else begin
        branch_mem_if <= 0;
    end
        
end


// Instruction Fetch instanciation
instr_fetch u_instr_fetch(
    .clk(clk),
    .rst(rst),
    .branch_mem_if(branch_mem_if),
    .PC_branch_mem_if(PC_branch_mem_if),
    .instr_if_id(instr_if_id),
    .PC_if_id(PC_if_id)
);

endmodule