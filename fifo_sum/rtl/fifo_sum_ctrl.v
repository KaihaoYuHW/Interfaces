module fifo_sum_ctrl # (
    parameter CNT_ROW_MAX = 6'd49, // 矩阵中一行有多少个元素
    parameter CNT_COL_MAX = 6'd49   // 矩阵中一共有多少行
) (
    input wire sys_clk,
    input wire sys_rst_n,
    input wire pi_flag,
    input wire [7:0] pi_data,
    output reg po_flag,
    output reg [7:0] po_sum
);
    
    reg [5:0] cnt_row;  // 矩阵中一行的第几个元素
    reg [5:0] cnt_col;  // 矩阵中的第几行
    reg wr_en1; // 与第一个fifo的write enable连接
    wire wr_en2;    // 与第二个fifo的write enable连接
    wire [7:0] data_in1;  // 与第一个fifo的data in连接
    wire [7:0] data_out1;
    wire [7:0] data_out2;
    reg po_flag_reg;    // 用于求和运算

    // 当pi_flag = 1时，通过uart传输到fifo_sum_ctrl中的元素是矩阵的第几行，第几列。
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            cnt_row <= 6'd0;
        else if ((cnt_row == CNT_ROW_MAX) && (pi_flag == 1'b1))
            cnt_row <= 6'd0;
        else if (pi_flag == 1'b1)
            cnt_row <= cnt_row + 1'b1;
    end

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            cnt_col <= 6'd0;
        else if ((cnt_row == CNT_ROW_MAX) && (pi_flag == 1'b1) && (cnt_col == CNT_COL_MAX))
            cnt_col <= 6'd0;
        else if ((cnt_row == CNT_ROW_MAX) && (pi_flag == 1'b1))
            cnt_col <= cnt_col + 1'b1;
    end

    // 在pi_data输入的矩阵元素为第0行，或者fifo2读出的元素为第1~47行时，fifo1写入数据。
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            wr_en1 <= 1'b0;
        else if (((cnt_col == 6'd0) || (cnt_col >= 6'd2 && cnt_col <= 6'd48)) && pi_flag == 1'b1)
            wr_en1 <= 1'b1;
        else 
            wr_en1 <= 1'b0;
    end

    assign data_in1 = (cnt_col >= 6'd2) ? data_out2 : pi_data;

    // 在pi_data输入的矩阵元素为第1~48行时，fifo2写入数据。
    assign wr_en2 = (cnt_col >= 6'd1 && cnt_col <= 6'd48) ? pi_flag : 1'b0;

    // 当pi_data开始输入第2行的元素时，fifo1和2同时读出之前存储在里面的元素数据。
    assign rd_en = (cnt_col >= 6'd2) ? pi_flag : 1'b0;

    // 对rd_en打一拍，得到po_flag_reg
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            po_flag_reg <= 1'b0;
        else 
            po_flag_reg <= rd_en;
    end

    // 同一列，相邻三行的元素求和运算
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            po_sum <= 8'd0;
        else if (po_flag_reg == 1'b1)
            po_sum <= data_out1 + data_out2 + pi_data;
    end

    // 对po_flag_reg打一拍，得到po_flag
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            po_flag <= 1'b0;
        else 
            po_flag <= po_flag_reg;
    end

    fifo_data fifo_data_inst1 (
        .clk(sys_clk),
        .din(data_in1),
        .wr_en(wr_en1),
        .rd_en(rd_en),
        .dout(data_out1),
        .full(),
        .empty()
    );

    fifo_data fifo_data_inst2 (
        .clk(sys_clk),
        .din(pi_data),  // data_in2直接与pi_data相连
        .wr_en(wr_en2),
        .rd_en(rd_en),
        .dout(data_out2),
        .full(),
        .empty()
    );
endmodule