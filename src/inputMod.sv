`timescale 1ns / 1ps


module inputMod (
    input  logic        CLK5M,
    input  logic [15:0] SW,
    input  logic [ 4:0] BTN,
    output logic        reqStart,
    output logic        reqReset,
    output logic        reqPause,
    output logic        reqResume
);
  debounce1Clk d1 (
      .CLK5M,
      .in (BTN[4]),
      .out(reqStart)
  );
  debounce1Clk d2 (
      .CLK5M,
      .in (BTN[3]),
      .out(reqReset)
  );
  debounce1Clk d3 (
      .CLK5M,
      .in (BTN[0]),
      .out(reqPause)
  );
  debounce1Clk d4 (
      .CLK5M,
      .in (BTN[1]),
      .out(reqResume)
  );

  always_ff @(posedge CLK5M) begin

  end
endmodule

module debounce1Clk (
    input  logic CLK5M,
    input  logic in,
    output logic out
);
  logic debounced;
  debounce debounce (
      .CLK5M,
      .in,
      .out(debounced)
  );
  logic tmp;
  always_ff @(posedge CLK5M) begin
    if (tmp == 0 && debounced == 1) begin
      out <= 1;
      tmp <= 1;

    end else begin
      out <= 0;
    end
    if (tmp == 1 && debounced == 0) begin
      tmp <= 0;
    end
  end
endmodule

module debounce (
    input  logic CLK5M,
    input  logic in,
    output logic out
);
  logic [7:0] tmp;
  always_ff @(posedge CLK5M) begin
    if (tmp == 8'h00) begin

      out <= 0;
    end else if (tmp == 8'hff) begin
      out <= 1;
    end
    tmp <= {tmp[6:0], in};
  end
endmodule


