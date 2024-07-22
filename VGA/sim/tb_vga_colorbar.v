`timescale 1ns / 1ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:12:32 11/18/2022
// Design Name:   vga_colorbar
// Module Name:   E:/IC_design/Verilog/FPGA_S6/vga_colorbar/sim/tb_vga_colorbar.v
// Project Name:  vga_colorbar
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vga_colorbar
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_vga_colorbar;

	// Inputs
	reg sys_clk;
	reg sys_rst_n;

	// Outputs
	wire hsync;
	wire vsync;
	wire [15:0] rgb;

	// Instantiate the Unit Under Test (UUT)
	vga_colorbar uut (
		.sys_clk(sys_clk), 
		.sys_rst_n(sys_rst_n), 
		.hsync(hsync), 
		.vsync(vsync), 
		.rgb(rgb)
	);

	initial begin
		// Initialize Inputs
		sys_clk = 1'b1;
		sys_rst_n <= 1'b0;
		#200
		sys_rst_n <= 1'b1;
	end

	always #10 sys_clk = ~sys_clk;
	 
endmodule

