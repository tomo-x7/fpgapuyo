`timescale 1ns / 1ps


// clk_wiz_0 の置き換え。MMCM プリミティブを直接インスタンスする
// VCO = 100MHz * 6.25 / 1 = 625MHz
//   CLKOUT0: 625 / 6.25 = 100MHz
//   CLKOUT1: 625 / 125  = 5MHz
module clkgen (
    input  wire logic CLK100MRAW,
    output logic      CLK5M,
    output logic      CLK100M
);
  logic clkfbout;
  logic clkfbin;
  logic clk100m_unbuf;
  logic clk5m_unbuf;

  MMCME2_BASE #(
      .BANDWIDTH         ("OPTIMIZED"),
      .CLKIN1_PERIOD     (10.000),
      .REF_JITTER1       (0.010),
      .DIVCLK_DIVIDE     (1),
      .CLKFBOUT_MULT_F   (6.250),
      .CLKFBOUT_PHASE    (0.000),
      .CLKOUT0_DIVIDE_F  (6.250),
      .CLKOUT0_PHASE     (0.000),
      .CLKOUT0_DUTY_CYCLE(0.500),
      .CLKOUT1_DIVIDE    (125),
      .CLKOUT1_PHASE     (0.000),
      .CLKOUT1_DUTY_CYCLE(0.500),
      .STARTUP_WAIT      ("FALSE")
  ) mmcm (
      .CLKIN1   (CLK100MRAW),
      .CLKFBIN  (clkfbin),
      .CLKFBOUT (clkfbout),
      .CLKFBOUTB(),
      .CLKOUT0  (clk100m_unbuf),
      .CLKOUT0B (),
      .CLKOUT1  (clk5m_unbuf),
      .CLKOUT1B (),
      .CLKOUT2  (),
      .CLKOUT2B (),
      .CLKOUT3  (),
      .CLKOUT3B (),
      .CLKOUT4  (),
      .CLKOUT5  (),
      .CLKOUT6  (),
      .LOCKED   (),
      .PWRDWN   (1'b0),
      .RST      (1'b0)
  );

  BUFG fbbuf (
      .I(clkfbout),
      .O(clkfbin)
  );
  BUFG buf100m (
      .I(clk100m_unbuf),
      .O(CLK100M)
  );
  BUFG buf5m (
      .I(clk5m_unbuf),
      .O(CLK5M)
  );
endmodule



