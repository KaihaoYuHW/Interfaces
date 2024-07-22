`timescale 1ns / 1ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:04:41 07/21/2024
// Design Name:   top_module
// Module Name:   E:/IC_design/Verilog/FPGA_S6/fifo_sum/sim/tb_top_module.v
// Project Name:  fifo_sum
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
	reg rx;
	reg [7:0] data_mem[2499:0];

	// Outputs
	wire tx;

	// Instantiate the Unit Under Test (UUT)
	top_module uut (
		.sys_clk(sys_clk), 
		.sys_rst_n(sys_rst_n), 
		.rx(rx), 
		.tx(tx)
	);

	//读取数据
	initial begin
		$readmemh("E:/IC_design/Verilog/FPGA_S6/fifo_sum/matlab/fifo_data.txt",data_mem);
	end

	//生成时钟和复位信号
	initial begin
		// Initialize Inputs
		sys_clk = 1'b1;
		sys_rst_n <= 1'b0;
		#30
		sys_rst_n <= 1'b1;
	end

	always #10 sys_clk = ~sys_clk;

	//rx赋初值,调用rx_byte
	initial begin
		rx  <=  1'b1;
    	#200
    	rx_byte();
	end

	//rx_byte
	task rx_byte();
		integer j;
		for (j = 0; j < 2500; j = j + 1) begin
			rx_bit(data_mem[j]);
		end
	endtask

	//rx_bit
	task  rx_bit(input[7:0] data);//data是data_men[j]的值。
		integer i;
		for (i = 0; i < 10; i = i + 1) begin
			case (i)
				0:  rx  <=  1'b0;     //起始位
          		1:  rx  <=  data[0];
          		2:  rx  <=  data[1];
          		3:  rx  <=  data[2];
          		4:  rx  <=  data[3];
          		5:  rx  <=  data[4];
          		6:  rx  <=  data[5];
          		7:  rx  <=  data[6];
          		8:  rx  <=  data[7];  //上面8个发送的是数据位
          		9:  rx  <=  1'b1;     //停止位
			endcase
			#1040;
		end
	endtask

	// 重新定义defparam，用于修改参数
	defparam uut.uart_rx_inst.CLK_FREQ = 500000;
	defparam uut.uart_tx_inst.CLK_FREQ = 500000;
      
endmodule

