`timescale 1ns / 1ps



module main (
    input  wire logic        CLK100MRAW,
    output logic      [15:0] LED,
    input  wire logic [15:0] SW,
    input  wire logic [ 4:0] BTN,
    output logic      [ 7:0] SSEG_CA,
    output logic      [ 3:0] SSEG_AN,
    output logic             SPEAKER0,
    output logic             SPEAKER1
);
  
endmodule


