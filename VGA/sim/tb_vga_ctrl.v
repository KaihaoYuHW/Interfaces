`timescale 1ns / 1ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:53:05 11/18/2022
// Design Name:   vga_ctrl
// Module Name:   E:/IC_design/Verilog/FPGA_S6/vga_colorbar/sim/tb_vga_colorbar.v
// Project Name:  vga_colorbar
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vga_ctrl
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_vga_ctrl;

	// Inputs
	reg vga_clk;
	reg rst_n;
	reg [15:0] pix_data;

	// Outputs
	wire hsync;
	wire vsync;
	wire [9:0] pix_x;
	wire [9:0] pix_y;
	wire [15:0] rgb;

	// Instantiate the Unit Under Test (UUT)
	vga_ctrl uut (
		.vga_clk(vga_clk), 
		.rst_n(rst_n), 
		.pix_data(pix_data), 
		.hsync(hsync), 
		.vsync(vsync), 
		.pix_x(pix_x), 
		.pix_y(pix_y), 
		.rgb(rgb)
	);

	initial begin
		// Initialize Inputs
		vga_clk = 1'b1;
		rst_n <= 1'b0;
		#200
		rst_n <= 1'b1;
	end

	always #20 vga_clk = ~vga_clk;

	always @(posedge vga_clk or negedge rst_n) begin
		if (rst_n == 1'b0)
			pix_data <= 16'h0000;
		else 
			pix_data <= 16'hffff;
	end 
      
endmodule

