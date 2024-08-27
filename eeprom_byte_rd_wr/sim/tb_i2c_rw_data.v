`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:21:05 08/24/2024
// Design Name:   i2c_rw_data
// Module Name:   E:/IC_design/Verilog/FPGA_S6/eeprom_byte_rd_wr/sim/tb_i2c_rw_data.v
// Project Name:  eeprom_byte_rd_wr
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: i2c_rw_data
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_i2c_rw_data;

	// Inputs
	reg sys_clk;
	reg sys_rst_n;
	reg write;
	reg read;
	reg i2c_end;
	reg [7:0] rd_data;

	// Outputs
	wire wr_en;
	wire rd_en;
	wire i2c_start;
	wire [15:0] byte_addr;
	wire [7:0] wr_data;
	wire [7:0] fifo_rd_data;

	// Instantiate the Unit Under Test (UUT)
	i2c_rw_data uut (
		.sys_clk(sys_clk), 
		.sys_rst_n(sys_rst_n), 
		.write(write), 
		.read(read), 
		.i2c_end(i2c_end), 
		.rd_data(rd_data), 
		.wr_en(wr_en), 
		.rd_en(rd_en), 
		.i2c_start(i2c_start), 
		.byte_addr(byte_addr), 
		.wr_data(wr_data), 
		.fifo_rd_data(fifo_rd_data)
	);

	integer i;

	initial begin
		// Initialize Inputs
		sys_clk = 1'b1;
		sys_rst_n <= 1'b0;
		write <= 1'b0;
		read <= 1'b0;
		i2c_end <= 1'b0;

		// Wait 100 ns for global reset to finish
		#200;
        sys_rst_n <= 1'b1;
		// Add stimulus here
		#1000;
		read <= 1'b1;
		#20;
		read <= 1'b0;

		// 读操作
		#4192000
		i2c_end <= 1'b1;
		#20
		i2c_end <= 1'b0;
		// //写操作
		// #4152000
		// i2c_end <= 1'b1;
		// #20
		// i2c_end <= 1'b0;
		for (i = 0; i <= 8; i = i + 1) begin
			#3999980
			i2c_end <= 1'b1;
			#20
			i2c_end <= 1'b0;
		end

	end

	integer j;

	initial begin
		rd_data <= 8'h0;
		#200;
		#1000;
		#20;

		// 读取数据的变化
		#4184020;
		rd_data <= 8'hA5;
		for (j = 0; j <= 8; j = j + 1) begin
			#4000000;
			rd_data <= rd_data + 1'b1;
		end

	end
    
	always #10 sys_clk = ~sys_clk;	// 周期=20ns

endmodule

