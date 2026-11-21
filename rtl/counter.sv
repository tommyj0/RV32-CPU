`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// counter
//////////////////////////////////////////////////////////////////////////////////


module counter(
    clk,
    en_i,
    rst,
    count_o,
    trig_o
    );
    
    
parameter WIDTH = 4;
parameter MAX = 9;

input logic clk;
input logic en_i;
input logic rst;

output logic [WIDTH - 1:0] count_o;
output logic trig_o;

logic [WIDTH - 1:0] count_q;
logic trig_q;

assign count_o = count_q;
assign trig_o = trig_q;

always@(posedge clk) begin
    if (rst)
        count_q <= 'b0;
    else if (en_i) begin
        if (count_q < MAX)
            count_q <= count_q + 1;
        else
            count_q <= 'b0;     
    end
end

always@(posedge clk) begin

    if (rst)
        trig_q <= 1'b0;
    else if (en_i && count_q == MAX)
        trig_q <= 1'b1;
    else
        trig_q <= 1'b0;
        
end

endmodule
