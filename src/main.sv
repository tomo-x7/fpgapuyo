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
  logic Locked;

  clkgen clkgen (
      .CLK100MRAW,
      .CLK5M  (),
      .CLK100M(),
      .CLK25M,
      .LOCKED (Locked)
  );
  vga vga (
      .CLK25M,
      .Reset(!Locked),
      .stage(SW[15:0]),
      .VGA_RED,
      .VGA_GREEN,
      .VGA_BLUE,
      .VGA_HS,
      .VGA_VS
  );
endmodule


