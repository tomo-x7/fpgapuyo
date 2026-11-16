`timescale 1ns / 1ps

module vga (
    input  logic         CLK25M,
    input  logic         Reset,
    input  logic [233:0] stage,
    output logic [  3:0] VGA_RED,
    output logic [  3:0] VGA_GREEN,
    output logic [  3:0] VGA_BLUE,
    output logic         VGA_HS,
    output logic         VGA_VS
);
  logic video_enable;
  logic [10:0] hcount, vcount;
  logic [7:0] red, green, blue;

  VGAtiming vga_timing (
      .PCLK_I(CLK25M),
      .RST_I(Reset),
      .BLANK_O(video_enable),
      .HSYNC_O(VGA_HS),
      .VSYNC_O(VGA_VS),
      .HCNT_O(hcount),
      .VCNT_O(vcount)
  );

  draw draw_stage (
      .stage(stage),
      .x({5'b0, hcount}),
      .y({5'b0, vcount}),
      .red(red),
      .green(green),
      .blue(blue)
  );

  // Drive black outside the active video area.
  assign VGA_RED   = video_enable ? red[7:4]   : 4'h0;
  assign VGA_GREEN = video_enable ? green[7:4] : 4'h0;
  assign VGA_BLUE  = video_enable ? blue[7:4]  : 4'h0;
endmodule
