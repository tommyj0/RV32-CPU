`timescale 1ns / 1ps

module instr_fetch_tb();

logic clk = 0;
logic rst = 1;

logic branch_mem_if = 0;
logic [31:0] PC_branch_mem_if = 'h0;
logic [31:0] instr_if_id;
logic [31:0] PC_if_id;

initial
  forever #5 clk = ~clk;

initial
    #100 rst = 1'b0;

always@(posedge clk)
begin
    if ($random % 5 == 0) begin
        branch_mem_if <= 'b1;
        PC_branch_mem_if <= PC_branch_mem_if + ($random % 100);
    end
    else begin
        branch_mem_if <= 'b0;
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