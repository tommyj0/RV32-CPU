module top_tb();

logic clk;
logic rst;
logic [4:0] btns;
logic [15:0] led;
logic [11:0] colour_out;
logic HS;
logic VS;


top top_inst (
    .clk(clk),
    .rst(rst),
    .btns(btns),
    .led(led),
    .colour_out(colour_out),
    .HS(HS),
    .VS(VS)
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