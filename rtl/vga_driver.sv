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
    input logic clk_i,
    input logic rst_i,
    input logic  [11:0] colour_in_i,
    output logic [11:0] colour_out_o,
    output logic [10:0] x_o,
    output logic [9:0] y_o,
    output logic HS_o,
    output logic VS_o,
    output logic frame_trig_o
);
logic [11:0] colour_out_q;
logic HS_q;
logic VS_q;

assign colour_out_o = colour_out_q;
assign HS_o = HS_q;
assign VS_o = VS_q;


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

logic [10:0] HorzCount_q; 
logic [9:0] VertCount_q; 
logic Trig_vga;
logic Trig_Horz;

// set clock speed
counter # (.WIDTH(1), .MAX(1)) counter_25 (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .en_i(1'b1),
    .trig_o(Trig_vga)

);
counter # (.WIDTH(11), .MAX(Horz_BackPorchEnd - 1)) counter_horz (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .en_i(Trig_vga),
    .trig_o(Trig_Horz),
    .count_o(HorzCount_q)
);
counter # (.WIDTH(10), .MAX(Vert_BackPorchEnd - 1)) counter_vert (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .en_i(Trig_Horz),
    .trig_o(frame_trig_o),
    .count_o(VertCount_q)
);

// clock HS_q and VS_q so they're synched with colour_out_q (takes colour a cycle to go thru frame_buffer_q BRAM)

logic HS_dly_q;
logic VS_dly_q;
always@(posedge clk_i) begin
    HS_q <= HS_dly_q;
    VS_q <= VS_dly_q;
    if (HorzCount_q >= Horz_FrontPorchEnd && HorzCount_q < Horz_SyncPulseEnd)
        HS_dly_q <= 1'b0;
    else
        HS_dly_q <= 1'b1;
    if (VertCount_q >= Vert_FrontPorchEnd && VertCount_q < Vert_SyncPulseEnd)
        VS_dly_q <= 1'b0;
    else
        VS_dly_q <= 1'b1;
end


logic draw_window_dly;
logic draw_window_dly_q;
always@(*) begin
    if (HorzCount_q < Horz_Visible && VertCount_q < Vert_Visible) begin
        draw_window_dly = 1'b1;
        x_o = HorzCount_q;
        y_o = VertCount_q;
    end
    else begin
        draw_window_dly = 1'b0;
        x_o = 'b0;
        y_o = 'b0;
    end
    // if (draw_window_dly_q) // wait for correct colour
    //   colour_out_q = colour_in_i;
    // else
    //   colour_out_q = 'h0;
end

always@(posedge clk_i) begin
  // wait for colour_in_i to be available
  draw_window_dly_q <= draw_window_dly;
  if (draw_window_dly_q)
    colour_out_q <= colour_in_i;
  else
    colour_out_q <= 'b0;
end

endmodule
