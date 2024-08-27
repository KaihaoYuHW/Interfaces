`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:09:34 08/24/2024
// Design Name:   top_module
// Module Name:   E:/IC_design/Verilog/FPGA_S6/eeprom_byte_rd_wr/sim/tb_top_module.v
// Project Name:  eeprom_byte_rd_wr
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top_module
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_top_module;

	// Inputs
	reg sys_clk;
	reg sys_rst_n;
	reg key_wr;
	reg key_rd;

	// Outputs
	wire [5:0] sel;
	wire [7:0] seg;
	wire scl;

	// Bidirs
	wire sda;

	// Instantiate the Unit Under Test (UUT)
	top_module uut (
		.sys_clk(sys_clk), 
		.sys_rst_n(sys_rst_n), 
		.key_wr(key_wr), 
		.key_rd(key_rd), 
		.sel(sel), 
		.seg(seg), 
		.scl(scl), 
		.sda(sda)
	);

	initial begin
		// Initialize Inputs
		sys_clk = 1'b1;
		sys_rst_n <= 1'b0;
		key_wr <= 1'b1;
		key_rd <= 1'b1;

		// Wait 100 ns for global reset to finish
		#200;
        sys_rst_n <= 1'b1;
		// Add stimulus here
		#1000;
		key_wr <= 1'b0;
		key_rd <= 1'b1;
		#400;
		key_wr <= 1'b1;
		key_rd <= 1'b1;
	end

	always #10 sys_clk = ~sys_clk;

	defparam uut.key_wr_filter_inst.CNT_max = 5;
	defparam uut.key_rd_filter_inst.CNT_max = 5;

	M24LC64 M24lc64_inst (
		.A0(1'b0),
		.A1(1'b0),
		.A2(1'b0),
		.WP(1'b0),
		.RESET(~sys_rst_n),
		.SDA(sda),
		.SCL(scl)
	);  
endmodule

