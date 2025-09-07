`timescale 1ns / 1ps

module reg_file_tb();
reg clk = 0;
reg [4:0] read_reg1 = 0;
reg [4:0] read_reg2 = 0;
reg [4:0] write_reg = 0;
reg [31:0] write_data = 0;
reg write_reg_enable = 0;
wire [31:0] read_data1;
wire [31:0] read_data2;


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
  .clk(clk),
  .read_reg1(read_reg1),
  .read_reg2(read_reg2),
  .write_reg(write_reg),
  .write_data(write_data),
  .write_reg_enable(write_reg_enable),
  .read_data1(read_data1),
  .read_data2(read_data2)
);

endmodule