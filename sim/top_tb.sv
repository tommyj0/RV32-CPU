module top_tb();

logic clk;
logic rst;
logic [4:0] btns;
logic [15:0] led;
logic [11:0] colour_out;
logic HS;
logic VS;


top top_inst (
    .clk_i(clk),
    .rst_i(rst),
    .btns_i(btns),
    .led_o(led),
    .colour_out_o(colour_out),
    .HS_o(HS),
    .VS_o(VS)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    // Initialize inputs
    rst = 1;
    btns = 5'b00000;
    #20;
    rst = 0;


    // Finish simulation after some time
    #1000000;
    // $finish;
end

endmodule