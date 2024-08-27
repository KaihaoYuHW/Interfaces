module i2c_ctrl #(
    parameter DEVICE_ADDR = 7'b1010_000,
    parameter SYS_CLK_FREQ = 26'd50_000_000,
    parameter SCL_FREQ = 18'd250_000
) (
    input wire sys_clk,
    input wire sys_rst_n,
    input wire wr_en,
    input wire rd_en,
    input wire i2c_start,
    input wire addr_num,
    input wire [15:0] byte_addr,
    input wire [7:0] wr_data,
    output reg i2c_end,
    output reg [7:0] rd_data,
    output reg i2c_scl,
    inout wire i2c_sda
);

    parameter CNT_CLK_MAX = SYS_CLK_FREQ / SCL_FREQ,    // 200
                CNT_CLK_MAX_14 = CNT_CLK_MAX / 4,                   // 50
                CNT_CLK_MAX_24 = CNT_CLK_MAX / 2,                   // 100
                CNT_CLK_MAX_34 = (CNT_CLK_MAX / 4) * 3;             // 150

    localparam IDLE = 4'd0,
                START_1 = 4'd1,
                SEND_D_ADDR = 4'd2,
                ACK_1 = 4'd3,
                SEND_B_ADDR_H = 4'd4,
                ACK_2 = 4'd5,
                SEND_B_ADDR_L = 4'd6,
                ACK_3 = 4'd7,
                WR_DATA = 4'd8,
                ACK_4 = 4'd9,
                START_2 = 4'd10,
                SEND_RD_ADDR = 4'd11,
                ACK_5 = 4'd12,
                RD_DATA = 4'd13,
                N_ACK = 4'd14,
                STOP = 4'd15;

    reg [3:0] state;
    reg [3:0] next_state;
    reg [7:0] cnt_clk;
    reg [2:0] cnt_bit;
    reg i2c_sda_reg;
    wire sda_en;
    reg [7:0] rd_data_reg;
    reg ack;

    // 状态机的状态转换
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            state <= IDLE;
        else 
            state <= next_state;
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (i2c_start == 1'b1)
                    next_state = START_1;
                else
                    next_state = IDLE;
            end 
            START_1: begin
                if (cnt_clk == CNT_CLK_MAX - 1'b1)
                    next_state = SEND_D_ADDR;
                else 
                    next_state = START_1;
            end
            SEND_D_ADDR: begin
                if (cnt_clk == CNT_CLK_MAX - 1'b1 && cnt_bit == 3'd7)
                    next_state = ACK_1;
                else 
                    next_state = SEND_D_ADDR;
            end
            ACK_1: begin
                if (cnt_clk == CNT_CLK_MAX - 1'b1 && ack == 1'b0) begin
                    if (addr_num == 1'b1)
                        next_state = SEND_B_ADDR_H;
                    else 
                        next_state = SEND_B_ADDR_L;
                end
                else
                    next_state = ACK_1;
            end
            SEND_B_ADDR_H: begin
                if (cnt_clk == CNT_CLK_MAX - 1'b1 && cnt_bit == 3'd7)
                    next_state = ACK_2;
                else 
                    next_state = SEND_B_ADDR_H;
            end
            ACK_2: begin
                if (cnt_clk == CNT_CLK_MAX - 1'b1 && ack == 1'b0)
                    next_state = SEND_B_ADDR_L;
                else 
                    next_state = ACK_2;
            end
            SEND_B_ADDR_L: begin
                if (cnt_clk == CNT_CLK_MAX - 1'b1 && cnt_bit == 3'd7)
                    next_state = ACK_3;
                else 
                    next_state = SEND_B_ADDR_L;
            end
            ACK_3: begin
                if (cnt_clk == CNT_CLK_MAX - 1'b1 && ack == 1'b0) begin
                    if (wr_en == 1'b1)
                        next_state = WR_DATA;
                    else if (rd_en == 1'b1)
                        next_state = START_2;
                    else
                        next_state = ACK_3;
                end
                else 
                    next_state = ACK_3;    
            end
            WR_DATA: begin
                if (cnt_clk == CNT_CLK_MAX - 1'b1 && cnt_bit == 3'd7)
                    next_state = ACK_4;
                else
                    next_state = WR_DATA;
            end
            ACK_4: begin
                if (cnt_clk == CNT_CLK_MAX - 1'b1 && ack == 1'b0)
                    next_state = STOP;
                else 
                    next_state = ACK_4;
            end
            STOP: begin
                if (cnt_clk == CNT_CLK_MAX - 1'b1 && cnt_bit == 3'd3)
                    next_state = IDLE;
                else 
                    next_state = STOP;
            end
            START_2: begin
                if (cnt_clk == CNT_CLK_MAX - 1'b1)
                    next_state = SEND_RD_ADDR;
                else
                    next_state = START_2;
            end
            SEND_RD_ADDR: begin
                if (cnt_clk == CNT_CLK_MAX - 1'b1 && cnt_bit == 3'd7)
                    next_state = ACK_5;
                else 
                    next_state = SEND_RD_ADDR;
            end
            ACK_5: begin
                if (cnt_clk == CNT_CLK_MAX - 1'b1 && ack == 1'b0)
                    next_state = RD_DATA;
                else 
                    next_state = ACK_5;
            end
            RD_DATA: begin
                if (cnt_clk == CNT_CLK_MAX - 1'b1 && cnt_bit == 3'd7)
                    next_state = N_ACK;
                else 
                    next_state = RD_DATA;
            end
            N_ACK: begin
                if (cnt_clk == CNT_CLK_MAX - 1'b1)
                    next_state = STOP;
                else
                    next_state = N_ACK;
            end
            default: next_state = IDLE;
        endcase
    end

    // cnt_clk计数0~199（即一个i2c_scl周期）
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            cnt_clk <= 8'd0;
        else if (cnt_clk == CNT_CLK_MAX - 1'b1 || state == IDLE)
            cnt_clk <= 8'd0;
        else
            cnt_clk <= cnt_clk + 1'b1;
    end

    // cnt_bit计数0~7（即i2c_sda一次最多传输多少bit数据）
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            cnt_bit <= 3'd0;
        else if (cnt_bit == 3'd7 && cnt_clk == CNT_CLK_MAX - 1'b1)
            cnt_bit <= 3'd0;
        else if (state == STOP && cnt_bit == 3'd3 && cnt_clk == CNT_CLK_MAX - 1'b1)
            cnt_bit <= 3'd0;
        else if (state == IDLE || state == START_1 || state == START_2 || state == ACK_1 || state == ACK_2 || state == ACK_3 || state == ACK_4 || state == ACK_5 || state == N_ACK)
            cnt_bit <= 3'd0;
        else if ((state == SEND_D_ADDR || state == SEND_B_ADDR_H || state == SEND_B_ADDR_L || state == WR_DATA || state == SEND_RD_ADDR || state == RD_DATA || state == STOP) && cnt_clk == CNT_CLK_MAX - 1'b1)
            cnt_bit <= cnt_bit + 1'b1;
    end
    
    // STOP状态结束时，i2c_end发送一个脉冲
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            i2c_end <= 1'b0;
        else if (state == STOP && cnt_bit == 3'd3 && cnt_clk == CNT_CLK_MAX - 2'd2)
            i2c_end <= 1'b1;
        else
            i2c_end <= 1'b0;
    end

    // i2c_scl使用combinational circuit来定义
    always @(*) begin
        if (!sys_rst_n)
            i2c_scl = 1'b1;
        else 
            case (state)
                IDLE: i2c_scl = 1'b1;
                START_1: begin
                    if (cnt_clk <= CNT_CLK_MAX_34 - 1'b1)
                        i2c_scl = 1'b1;
                    else
                        i2c_scl = 1'b0;
                end
                SEND_D_ADDR, ACK_1, SEND_B_ADDR_H, ACK_2, SEND_B_ADDR_L, ACK_3, WR_DATA, ACK_4, START_2, SEND_RD_ADDR, ACK_5, RD_DATA, N_ACK: begin
                    if (cnt_clk >= CNT_CLK_MAX_14 && cnt_clk <= CNT_CLK_MAX_34 - 1'b1)
                        i2c_scl = 1'b1;
                    else 
                        i2c_scl = 1'b0;
                end
                STOP: begin
                    if (cnt_clk <= CNT_CLK_MAX_14 - 1'b1 && cnt_bit == 3'd0)
                        i2c_scl = 1'b0;
                    else
                        i2c_scl = 1'b1;
                end
                default: i2c_scl = 1'b1;
            endcase
    end

    // i2c_sda
    assign i2c_sda = sda_en ? i2c_sda_reg : 1'bz;

    assign sda_en = (state == ACK_1 || state == ACK_2 || state == ACK_3 || state == ACK_4 || state == ACK_5 || state == RD_DATA) ? 1'b0 : 1'b1;

    always @(*) begin
        if (!sys_rst_n)
            i2c_sda_reg = 1'b1;
        else 
            case (state)
                IDLE: i2c_sda_reg = 1'b1;
                START_1: begin
                    if (cnt_clk <= CNT_CLK_MAX_14 - 1'b1)
                        i2c_sda_reg = 1'b1;
                    else
                        i2c_sda_reg = 1'b0;
                end
                SEND_D_ADDR: begin
                    if (cnt_bit <= 3'd6)
                        i2c_sda_reg = DEVICE_ADDR[6 - cnt_bit];
                    else
                        i2c_sda_reg = 1'b0;
                end
                ACK_1, ACK_2, ACK_3, ACK_4, ACK_5, RD_DATA: i2c_sda_reg = 1'b1;
                SEND_B_ADDR_H: i2c_sda_reg = byte_addr[15 - cnt_bit];
                SEND_B_ADDR_L: i2c_sda_reg = byte_addr[7 - cnt_bit];
                WR_DATA: i2c_sda_reg = wr_data[7 - cnt_bit];
                START_2: begin
                    if (cnt_clk <= CNT_CLK_MAX_24 - 1'b1)
                        i2c_sda_reg = 1'b1;
                    else
                        i2c_sda_reg = 1'b0;
                end
                STOP: begin
                    if (cnt_clk <= CNT_CLK_MAX_34 - 1'b1 && cnt_bit == 3'd0)
                        i2c_sda_reg = 1'b0;
                    else
                        i2c_sda_reg = 1'b1;
                end
                SEND_RD_ADDR: begin
                    if (cnt_bit <= 3'd6)
                        i2c_sda_reg = DEVICE_ADDR[6 - cnt_bit];
                    else
                        i2c_sda_reg = 1'b1;
                end
                N_ACK: i2c_sda_reg = 1'b1;
                default: i2c_sda_reg = 1'b1;
            endcase
    end

    // ack：从机应答信号，ack只用于存储ACK状态下i2c_sda的值，其他状态下ack赋值为1
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            ack <= 1'b1;
        else if (state != ACK_1 && state != ACK_2 && state != ACK_3 && state != ACK_4 && state != ACK_5)
            ack <= 1'b1;
        else if ((state == ACK_1 || state == ACK_2 || state == ACK_3 || state == ACK_4 || state == ACK_5) && (cnt_clk <= CNT_CLK_MAX_14 - 1'b1))
            ack <= i2c_sda;
    end

    // rd_data_reg在RD_DATA阶段，用来暂时存储i2c_sda传过来的一个个bit数据
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            rd_data_reg <= 8'd0;
        else if (state == RD_DATA && cnt_clk == CNT_CLK_MAX_24 - 1'b1)
            rd_data_reg[7 - cnt_bit] <= i2c_sda;
        else if (state == IDLE)
            rd_data_reg <= 8'd0;
    end

    // rd_data
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            rd_data <= 8'd0;
        else if (state == RD_DATA && cnt_clk == CNT_CLK_MAX - 1'b1 && cnt_bit == 3'd7)
            rd_data <= rd_data_reg;
    end
endmodule