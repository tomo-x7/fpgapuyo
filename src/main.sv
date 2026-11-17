`timescale 1ns / 1ps



module main (
    input  wire logic        CLK100MRAW,
    output logic      [15:0] LED,
    input  wire logic [15:0] SW,
    input  wire logic [ 4:0] BTN,
    output logic      [ 7:0] SSEG_CA,
    output logic      [ 3:0] SSEG_AN,
    output logic             SPEAKER0,
    output logic             SPEAKER1,
    output logic      [ 3:0] VGA_RED,
    output logic      [ 3:0] VGA_GREEN,
    output logic      [ 3:0] VGA_BLUE,
    output logic             VGA_HS,
    output logic             VGA_VS
);
  logic CLK25M;
  logic CLK5M;
  logic enable1s;
  logic [31:0] counter1s = 0;
  logic enableCellClock;
  logic [31:0] counterCellClock = 0;
  always_ff @(posedge CLK5M) begin
    if (counter1s == 32'd5000000) begin
      counter1s <= 32'd0;
      enable1s  <= 1'b1;
    end else begin
      counter1s <= counter1s + 32'd1;
      enable1s  <= 1'b0;
    end
    if (counterCellClock == 32'd500000) begin
      counterCellClock <= 32'd0;
      enableCellClock  <= 1'b1;
    end else begin
      counterCellClock <= counterCellClock + 32'd1;
      enableCellClock  <= 1'b0;
    end
  end
  logic Locked;
  logic [233:0] frozenStage = 0;
  logic [233:0] stage;

  // 0: 落下
  // 1: 新規
  // 2: ゲームオーバー
  logic [3:0] state = 0;
  //   0~5
  logic [7:0] x = 0;
  //   0~11
  logic [7:0] y = 0;

  // logic color [1:0] = colors[colorsIndex*2+:2];
  logic [511:0] colors;
  logic [7:0] colorsIndex;

  always_ff @(posedge CLK5M) begin
    if (enableCellClock) begin
      if (state == 4'd0) begin
        if (y == 8'd11 || frozenStage[(x+(y+8'd1)*6)*3+:3] != 3'b0) begin
          state <= 4'd1;
          frozenStage[(x+y*6)*3+:3] <= 3'd1;
        end else begin
          y <= y + 8'd1;
        end
      end else if (state == 4'd1) begin
        x <= 8'd2;
        y <= 8'd0;
        state <= 4'd0;
      end
    end
    if (state == 4'd0 && BTNL && x > 8'd0 && frozenStage[(x-1+y*6)*3+:3] == 3'b0) begin
      x <= x - 8'd1;
    end
    if (state == 4'd0 && BTNR && x < 8'd5 && frozenStage[(x+1+y*6)*3+:3] == 3'b0) begin
      x <= x + 8'd1;
    end

  end

  always_comb begin
    stage = frozenStage;
    if (state == 4'd0) begin
      stage[(x+(y)*6)*3+:3] = 3'd1;
    end
  end

  logic BTNL;
  logic BTNR;
  inputMod inputMod (
      .CLK5M,
      .SW,
      .BTN,
      .BTNL,
      .BTNR
  );

  clkgen clkgen (
      .CLK100MRAW,
      .CLK5M,
      .CLK100M(),
      .CLK25M,
      .LOCKED (Locked)
  );
  vga vga (
      .CLK25M,
      .Reset(!Locked),
      .stage,
      .VGA_RED,
      .VGA_GREEN,
      .VGA_BLUE,
      .VGA_HS,
      .VGA_VS
  );
endmodule


