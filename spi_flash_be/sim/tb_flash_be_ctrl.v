`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:35:38 08/01/2024
// Design Name:   flash_be_ctrl
// Module Name:   E:/IC_design/Verilog/FPGA_S6/spi_flash_be/sim/tb_flash_be_ctrl.v
// Project Name:  spi_flash_be
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: flash_be_ctrl
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_flash_be_ctrl;

	// Inputs
	reg sys_clk;
	reg key;
	reg sys_rst_n;

	// Outputs
	wire sck;
	wire cs_n;
	wire mosi;

	// Instantiate the Unit Under Test (UUT)
	flash_be_ctrl uut (
		.sys_clk(sys_clk), 
		.key(key), 
		.sys_rst_n(sys_rst_n), 
		.sck(sck), 
		.cs_n(cs_n), 
		.mosi(mosi)
	);

	initial begin
		// Initialize Inputs
		sys_clk = 0;
        
		forever begin
			#(20/2.0) sys_clk = ~sys_clk;
		end
	end

	initial begin
		// Initialize Inputs
		key = 0;
		sys_rst_n = 1'b0;

		#100
		sys_rst_n = 1'b1;

		#1000
		key = 1'b1;

		#20
		key = 1'b0;
	end
      
endmodule

