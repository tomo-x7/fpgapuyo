`timescale 1ns / 1ps

// horizontal constants
`define H_PW      96 // sync
`define H_FP      16 // front porch
`define H_DISPW  640 // active video
`define H_BP      48 // back porch
`define H_POL      0 // negative polarity
// vertical constants
`define V_PW       2 // sync
`define V_FP      10 // front porch, fixed from 33
`define V_DISPW  480 // active video
`define V_BP      33 // back porch, fixed from 10
`define V_POL      0 // negative polarity

module VGAtiming(
		 input logic PCLK_I,
		 input logic RST_I,
		 output logic BLANK_O,
		 output logic HSYNC_O,
		 output logic VSYNC_O,
		 output logic [10:0] HCNT_O,
		 output logic [10:0] VCNT_O
		 );
   logic [10:0] HCnt;  // horizontal counter
   logic [10:0] VCnt;  // vertical counter
   logic hsync, vsync; // horizontal/vertical sync
   logic blank; // data enable
   
   always_ff @(posedge PCLK_I) begin
      if (RST_I == 1) begin
	 HCnt <= `H_DISPW + `H_FP + `H_PW + `H_BP - 1; 
	 VCnt <= `V_DISPW + `V_FP + `V_PW + `V_BP - 1;
      end else begin
	 // Advance the vertical counter once per complete line.
	 if (HCnt == `H_DISPW + `H_FP + `H_PW + `H_BP - 1) begin
	    HCnt <= 0;
	    if (VCnt == `V_DISPW + `V_FP + `V_PW + `V_BP - 1) begin
	       VCnt <= 0;
	    end else begin
	       VCnt <= VCnt + 1;
	    end
	 end else begin
	    HCnt <= HCnt + 1;
	 end
      end
   end

   // Decode the current coordinates so video enable and sync stay aligned.
   assign blank = (HCnt < `H_DISPW) && (VCnt < `V_DISPW);
   assign hsync = !((HCnt >= `H_DISPW + `H_FP) &&
                    (HCnt < `H_DISPW + `H_FP + `H_PW));
   assign vsync = !((VCnt >= `V_DISPW + `V_FP) &&
                    (VCnt < `V_DISPW + `V_FP + `V_PW));

   assign HCNT_O = HCnt;
   assign VCNT_O = VCnt;
   assign HSYNC_O = `H_POL ? ~hsync:hsync;
   assign VSYNC_O = `V_POL ? ~vsync:vsync;
   assign BLANK_O = blank;
endmodule // VGAtiming



