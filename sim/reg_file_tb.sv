`timescale 1ns / 1ps

module reg_file_tb();
logic clk = 0;
logic [4:0] read_reg1 = 0;
logic [4:0] read_reg2 = 0;
logic [4:0] write_reg = 0;
logic [31:0] write_data = 0;
logic write_reg_enable = 0;
logic [31:0] read_data1;
logic [31:0] read_data2;


initial
  forever #5 clk = ~clk;

initial
begin
  #100 write_reg_enable = 1;
  for (integer i = 0; i < 32; i = i + 1)
  begin
    read_reg1 = i;
    read_reg2 = i;
    write_reg = i;
    write_data = $random;
    #100;
  end
end

reg_file reg_file_inst(
  .clk_i(clk),
  .read_reg1_i(read_reg1),
  .read_reg2_i(read_reg2),
  .write_reg_i(write_reg),
  .write_data_i(write_data),
  .write_reg_enable_i(write_reg_enable),
  .read_data1(read_data1),
  .read_data2(read_data2)
);

endmodule