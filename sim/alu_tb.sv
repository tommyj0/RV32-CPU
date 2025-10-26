`timescale 1ns / 1ps

`include "alu_ops.vh"

module alu_tb();

localparam int MAX32B = 32'hFFFFFFFF;
reg [31:0]  in1 = 'b0;
reg [31:0]  in2 = 'b0;
reg [3:0]   in_select = 'b0;

wire        zero;
wire [31:0] alu_result;
wire        overflow;



task automatic run_op_tests();
  input [3:0] alu_op;
  integer i;
  begin
    #10;
    in_select = alu_op;
    // overflow test
    in1 = MAX32B;
    in2 = MAX32B;
    #10;
    for (i = 0; i < 100; i = i + 1)
    begin
      in1 = $random;
      in2 = $random;
      #10;
    end
  end
endtask

initial begin
  run_op_tests(`ADD);
  run_op_tests(`SUB);
  run_op_tests(`AND);
  run_op_tests(`OR );
  run_op_tests(`XOR);
  run_op_tests(`SLL);
  run_op_tests(`SRL);
  run_op_tests(`SRA);


  // run_op_tests(`MUL);
  // run_op_tests(`DIV);
  // run_op_tests(`REM);
  $finish;
end

alu alu_inst(
    .in1(in1),
    .in2(in2),
    .alu_op(in_select),
    .zero(zero),
    .alu_result(alu_result),
    .overflow(overflow)
);

endmodule