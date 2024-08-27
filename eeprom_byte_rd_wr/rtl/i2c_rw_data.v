module i2c_rw_data #(
    parameter DATA_NUM = 4'd10,                 // 写入10个字节数据，读出10个字节数据
    parameter CNT_START_MAX = 18'd200_000,      // t(一个读/写操作) + t(相邻两个读/写操作的间隔)
    parameter CNT_WAIT_MAX = 25'd25_000_000     // 每个字节数据在数码管上显示的时间
) (
    input wire sys_clk,
    input wire sys_rst_n,
    input wire write,
    input wire read,
    input wire i2c_end,
    input wire [7:0] rd_data,
    output reg wr_en,
    output reg rd_en,
    output reg i2c_start,
    output reg [15:0] byte_addr,
    output reg [7:0] wr_data,
    output wire [7:0] fifo_rd_data
);

    reg [17:0] cnt_start;
    reg [3:0] wr_i2c_data_num;
    reg [3:0] rd_i2c_data_num;
    reg fifo_rd_valid;
    reg [24:0] cnt_wait;
    reg fifo_rd_en;
    reg [3:0] rd_data_num;
    wire [7:0] data_num;

    // wr_en：接收到write的一个脉冲后，拉高wr_en，并持续10个i2c_start
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            wr_en <= 1'b0;
        else if (i2c_end == 1'b1 && wr_i2c_data_num == DATA_NUM - 1'b1)
            wr_en <= 1'b0;
        else if (write == 1'b1)
            wr_en <= 1'b1;
    end

    // cnt_start：在wr_en=1和rd_en=1下，计数0~199_999
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            cnt_start <= 18'd0;
        else if (wr_en == 1'b0 && rd_en == 1'b0)
            cnt_start <= 18'd0;
        else if ((wr_en == 1'b1 || rd_en == 1'b1) && cnt_start == CNT_START_MAX - 1'b1)
            cnt_start <= 18'd0;
        else if (wr_en == 1'b1 || rd_en == 1'b1)
            cnt_start <= cnt_start + 1'b1;
    end

    // i2c_start: 单字节数据读/写开始信号
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            i2c_start <= 1'b0;
        else if ((wr_en == 1'b1 || rd_en == 1'b1) && cnt_start == CNT_START_MAX - 1'b1)
            i2c_start <= 1'b1;
        else
            i2c_start <= 1'b0;
    end

    // wr_i2c_data_num: 在wr_en=1下，对i2c_end进行计数0~9
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            wr_i2c_data_num <= 4'd0;
        else if (wr_en == 1'b0)
            wr_i2c_data_num <= 4'd0;
        else if (wr_en == 1'b1 && wr_i2c_data_num == DATA_NUM - 1'b1 && i2c_end == 1'b1)
            wr_i2c_data_num <= 4'd0;
        else if (wr_en == 1'b1 && i2c_end == 1'b1)
            wr_i2c_data_num <= wr_i2c_data_num + 1'b1;
    end

    // byte_addr: 在wr_en=1下，以i2c_end为条件，对EERPROM的地址+1
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            byte_addr <= 16'h00_5A;
        else if (wr_en == 1'b0 && rd_en == 1'b0)
            byte_addr <= 16'h00_5A;
        else if ((wr_en == 1'b1 || rd_en == 1'b1) && (wr_i2c_data_num == DATA_NUM - 1'b1 || rd_i2c_data_num == DATA_NUM - 1'b1) && i2c_end == 1'b1)
            byte_addr <= 16'h00_5A;
        else if ((wr_en == 1'b1 || rd_en == 1'b1) && i2c_end == 1'b1)
            byte_addr <= byte_addr + 1'b1;
    end

    // wr_data: 在wr_en=1下，以i2c_end为条件，写入的数据每次+1
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            wr_data <= 8'h01;
        else if (wr_en == 1'b0)
            wr_data <= 8'h01;
        else if (wr_en == 1'b1 && wr_i2c_data_num == DATA_NUM - 1'b1 && i2c_end == 1'b1)
            wr_data <= 8'h01;
        else if (wr_en == 1'b1 && i2c_end == 1'b1)
            wr_data <= wr_data + 1'b1;
    end

    // rd_en：接收到read的一个脉冲后，拉高rd_en，并持续10个i2c_start
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            rd_en <= 1'b0;
        else if (i2c_end == 1'b1 && rd_i2c_data_num == DATA_NUM - 1'b1)
            rd_en <= 1'b0;
        else if (read == 1'b1)
            rd_en <= 1'b1;
    end

    // rd_i2c_data_num: 在rd_en=1下，对i2c_end进行计数0~9
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            rd_i2c_data_num <= 4'd0;
        else if (rd_en == 1'b0)
            rd_i2c_data_num <= 4'd0;
        else if (rd_en == 1'b1 && rd_i2c_data_num == DATA_NUM - 1'b1 && i2c_end == 1'b1)
            rd_i2c_data_num <= 4'd0;
        else if (rd_en == 1'b1 && i2c_end == 1'b1)
            rd_i2c_data_num <= rd_i2c_data_num + 1'b1;
    end 

    // fifo_rd_valid: 当接收到第10个读操作的i2c_end后，拉高fifo_rd_valid，并持续10个fifo_rd_en
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            fifo_rd_valid <= 1'b0;
        else if (fifo_rd_en == 1'b1 && rd_data_num == DATA_NUM - 1'b1)
            fifo_rd_valid <= 1'b0;
        else if (data_num == DATA_NUM)
            fifo_rd_valid <= 1'b1;
    end

    // cnt_wait：在fifo_rd_valid=1下，计数0~24_999_999
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            cnt_wait <= 25'd0;
        else if (fifo_rd_valid == 1'b0)
            cnt_wait <= 25'd0;
        else if (fifo_rd_valid == 1'b1 && cnt_wait == CNT_WAIT_MAX - 1'b1)
            cnt_wait <= 25'd0;
        else if (fifo_rd_valid == 1'b1)
            cnt_wait <= cnt_wait + 1'b1;
    end

    // fifo_rd_en: fifo的rd_en信号
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            fifo_rd_en <= 1'b0;
        else if (fifo_rd_valid == 1'b1 && cnt_wait == CNT_WAIT_MAX - 1'b1)
            fifo_rd_en <= 1'b1;
        else 
            fifo_rd_en <= 1'b0;
    end

    // rd_data_num: 在fifo_rd_valid=1下，对fifo_rd_en的进行计数0~9
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            rd_data_num <= 4'd0;
        else if (fifo_rd_valid == 1'b0)
            rd_data_num <= 4'd0;
        else if (fifo_rd_valid == 1'b1 && fifo_rd_en == 1'b1 && rd_data_num == DATA_NUM - 1'b1)
            rd_data_num <= 4'd0;
        else if (fifo_rd_valid == 1'b1 && fifo_rd_en == 1'b1)
            rd_data_num <= rd_data_num + 1'b1;
    end

    fifo_read fifo_read_inst (
        .clk(sys_clk),
        .din(rd_data),
        .wr_en(i2c_end && rd_en),
        .rd_en(fifo_rd_en),
        .dout(fifo_rd_data),
        .full(),
        .empty(),
        .data_count(data_num)
    );

endmodule