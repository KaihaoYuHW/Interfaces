module top_module (
    input wire sys_clk,
    input wire sys_rst_n,
    input wire key_wr,
    input wire key_rd,
    output wire [5:0] sel,
    output wire [7:0] seg,
    output wire scl,
    inout wire sda
);
    
    wire key_wr_flag;
    wire key_rd_flag;
    wire i2c_end;
    wire [7:0] rd_data;
    wire wr_en;
    wire rd_en;
    wire i2c_start;
    wire [15:0] byte_addr;
    wire [7:0] wr_data;
    wire [7:0] fifo_rd_data;

    key_filter key_wr_filter_inst (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .key_in(key_wr),
        .key_flag(key_wr_flag)
    );

    key_filter key_rd_filter_inst (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .key_in(key_rd),
        .key_flag(key_rd_flag)
    );

    i2c_rw_data i2c_rw_data_inst (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .write(key_wr_flag),
        .read(key_rd_flag),
        .i2c_end(i2c_end),
        .rd_data(rd_data),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .i2c_start(i2c_start),
        .byte_addr(byte_addr),
        .wr_data(wr_data),
        .fifo_rd_data(fifo_rd_data)
    );

    i2c_ctrl #(
        .DEVICE_ADDR(7'b1010_011),
        .SYS_CLK_FREQ(26'd50_000_000),
        .SCL_FREQ(18'd250_000)
    ) i2c_ctrl_inst (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .i2c_start(i2c_start),
        .addr_num(1'b1),
        .byte_addr(byte_addr),
        .wr_data(wr_data),
        .i2c_end(i2c_end),
        .rd_data(rd_data),
        .i2c_scl(scl),
        .i2c_sda(sda)
    );

    seg_dynamic seg_dynamic_inst (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .point(6'b0),
        .seg_en(1'b1),
        .data({12'b0,fifo_rd_data}),
        .sign(1'b0),
        .sel(sel),
        .seg(seg)
    );
endmodule