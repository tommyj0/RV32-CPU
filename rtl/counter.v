`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// counter
//////////////////////////////////////////////////////////////////////////////////


module counter(
    clk,
    en,
    rst,
    count,
    trig
    );
    
    
parameter WIDTH = 4;
parameter MAX = 9;

input clk;
input en;
input rst;

output reg [WIDTH - 1:0] count;
output reg trig;

always@(posedge clk) begin
    if (rst)
        count <= 'b0;
    else if (en) begin
        if (count < MAX)
            count <= count + 1;
        else
            count <= 'b0;     
    end
end

always@(posedge clk) begin

    if (rst)
        trig <= 1'b0;
    else if (en && count == MAX)
        trig <= 1'b1;
    else
        trig <= 1'b0;
        
end

endmodule
