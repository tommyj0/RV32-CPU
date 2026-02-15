module top_tb();

reg clk;
reg rst;
reg [4:0] btns;
wire [15:0] led;
wire [11:0] colour_out;
wire HS;
wire VS;


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

    // Add further stimulus here as needed

    // Finish simulation after some time
    #1000;
    $finish;
end

endmodule