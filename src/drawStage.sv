
// stageは左上から0,1,2...5で一行で、列を下方向に積み上げ


function automatic logic [23:0] get_color(input logic [2:0] current);
  unique case (current)
    3'd0: get_color = 24'h000000;  // black
    3'd1: get_color = 24'hff0000;  // red
    3'd2: get_color = 24'h00ff00;  // green
    3'd3: get_color = 24'hffff00;  // yellow
    3'd4: get_color = 24'h0000ff;  // blue
    default: get_color = 24'h000000;
  endcase
endfunction

module draw (
    input  logic [233:0] stage,
    input  logic [ 15:0] x,
    input  logic [ 15:0] y,
    output logic [  7:0] red,
    output logic [  7:0] green,
    output logic [  7:0] blue
);
  // 0~11
  logic [7:0] cy;
  // -5~10 => 0~5
  logic signed [7:0] cx;
  always_comb begin
    cy = 8'(y / 40);
    cx = 8'($signed(x) / 16'sd40 - 16'sd5);
    if (cy > 11 || cx < 0 || cx > 5) begin
      red   = 8'h00;
      green = 8'h00;
      blue  = 8'h00;
    end else begin
      {red, green, blue} = get_color(stage[(cy*6+cx)*3+:3]);
    end
  end
endmodule
