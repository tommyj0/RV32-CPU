`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// MODULE: top
//////////////////////////////////////////////////////////////////////////////////
module vga_driver #
(
    parameter DISPLAY_WIDTH=800,
    parameter DISPLAY_HEIGHT=600,
    parameter Horz_Visible = DISPLAY_WIDTH,
    parameter Vert_Visible = DISPLAY_HEIGHT

)
(
    input clk,
    input rst,
    input  [11:0] colour_in,
    output reg [11:0] colour_out,
    output reg [10:0] x,
    output reg [9:0] y,
    output reg HS,
    output reg VS,
    output frame_trig
);


//parameter Horz_Visible = 'd640;
//parameter Horz_FrontPorchEnd = Horz_Visible + 'd16;     
//parameter Horz_SyncPulseEnd = Horz_FrontPorchEnd + 'd96;     
//parameter Horz_BackPorchEnd = Horz_SyncPulseEnd + 'd48;     

//parameter Vert_Visible = 'd480;
//parameter Vert_FrontPorchEnd = Vert_Visible + 'd10;     
//parameter Vert_SyncPulseEnd = Vert_FrontPorchEnd + 'd2;     
//parameter Vert_BackPorchEnd = Vert_SyncPulseEnd + 'd29;     


parameter Horz_FrontPorchEnd = Horz_Visible + 'd56; 
parameter Horz_SyncPulseEnd = Horz_FrontPorchEnd + 'd120;     
parameter Horz_BackPorchEnd = Horz_SyncPulseEnd + 'd64;     


parameter Vert_FrontPorchEnd = Vert_Visible + 'd37;     
parameter Vert_SyncPulseEnd = Vert_FrontPorchEnd + 'd6;     
parameter Vert_BackPorchEnd = Vert_SyncPulseEnd + 'd23;     


//parameter Horz_Visible = 'd1280;
//parameter Horz_FrontPorchEnd = Horz_Visible + 'd80;     
//parameter Horz_SyncPulseEnd = Horz_FrontPorchEnd + 'd136;     
//parameter Horz_BackPorchEnd = Horz_SyncPulseEnd + 'd21;     


//parameter Vert_Visible = 'd960;
//parameter Vert_FrontPorchEnd = Vert_Visible + 'd1;     
//parameter Vert_SyncPulseEnd = Vert_FrontPorchEnd + 'd3;     
//parameter Vert_BackPorchEnd = Vert_SyncPulseEnd + 'd30;    

wire [10:0] HorzCount; 
wire [9:0] VertCount; 

// set clock speed
counter # (.WIDTH(1), .MAX(1)) counter_25 (
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .trig(Trig_vga)

);
counter # (.WIDTH(11), .MAX(Horz_BackPorchEnd - 1)) counter_horz (
    .clk(clk),
    .rst(rst),
    .en(Trig_vga),
    .trig(Trig_Horz),
    .count(HorzCount)
);
counter # (.WIDTH(10), .MAX(Vert_BackPorchEnd - 1)) counter_vert (
    .clk(clk),
    .rst(rst),
    .en(Trig_Horz),
    .trig(frame_trig),
    .count(VertCount)
);
    
always@(*) begin
    if (HorzCount >= Horz_FrontPorchEnd && HorzCount < Horz_SyncPulseEnd)
        HS = 1'b0;
    else
    
        HS = 1'b1;
    if (VertCount >= Vert_FrontPorchEnd && VertCount < Vert_SyncPulseEnd)
        VS = 1'b0;
    else
        VS = 1'b1;
end

always@(*) begin
    if (HorzCount < Horz_Visible && VertCount < Vert_Visible) begin
        colour_out = colour_in; 
        x = HorzCount;
        y = VertCount;
    end
    else begin
        colour_out = 'b0;
        x = 'b0;
        y = 'b0;
    end
end

    

endmodule
