module flash_be_ctrl (
    input wire sys_clk,
    input wire key,
    input wire sys_rst_n,
    output reg sck,
    output reg cs_n,
    output reg mosi
);

    localparam IDLE = 4'b0001,      // 初始状态
                WR_EN = 4'b0010,    // 写状态
                DELAY = 4'b0100,    // 等待状态
                BE = 4'b1000;       // 全擦除状态
    localparam WR_EN_INST = 8'b0000_0110,   // 写使能指令
                BE_INST = 8'b1100_0111;     // 全擦除指令

    reg [4:0] cnt_clk;
    reg [3:0] state;
    reg [2:0] cnt_byte;
    reg [3:0] next_state;
    reg [1:0] cnt_sck;
    reg [2:0] cnt_bit;

    // 当state == IDLE时，cnt_clk = 0；当state != IDLE时，cnt_clk = 0~31。
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            cnt_clk <= 5'd0;
        else if ((state == IDLE) || (cnt_clk == 5'd31))
            cnt_clk <= 5'd0;
        else if (state != IDLE)
            cnt_clk <= cnt_clk + 1'b1;
    end
    
    // 当cnt_clk计数到31时，cnt_byte + 1
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            cnt_byte <= 3'd0;
        else if ((state == IDLE) || ((cnt_clk == 5'd31) && (cnt_byte == 3'd6)))
            cnt_byte <= 3'd0;
        else if (cnt_clk == 5'd31)
            cnt_byte <= cnt_byte + 1'b1;
    end

    // 状态转移
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            state <= IDLE;
        else 
            state <= next_state;
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (key == 1'b1)
                    next_state = WR_EN;
                else
                    next_state = IDLE;
            end
            WR_EN: begin
                if ((cnt_byte == 3'd2) && (cnt_clk == 5'd31))
                    next_state = DELAY;
                else
                    next_state = WR_EN;
            end
            DELAY: begin
                if ((cnt_byte == 3'd3) && (cnt_clk == 5'd31))
                    next_state = BE;
                else
                    next_state = DELAY;
            end
            BE: begin
                if ((cnt_byte == 3'd6) && (cnt_clk == 5'd31))
                    next_state = IDLE;
                else
                    next_state = BE;
            end
            default: next_state = IDLE;
        endcase
    end

    // flash片选信号
    always @(*) begin
        if (!sys_rst_n)
            cs_n = 1'b1;
        else
            case (state)
                IDLE, DELAY: cs_n = 1'b1;
                WR_EN, BE: cs_n = 1'b0;
                default: cs_n = 1'b1;
            endcase
    end

    // 当cnt_byte = 1和5时，cnt_sck从0~3计数
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            cnt_sck <= 2'd0;
        else if (cnt_sck == 2'd3)
            cnt_sck <= 2'd0;
        else if ((cnt_byte == 3'd1) || (cnt_byte == 3'd5))
            cnt_sck <= cnt_sck + 1'b1;
    end

    // flash串行时钟，12.5Mhz
    always @(*) begin
        if (!sys_rst_n)
            sck = 1'b0;
        else if ((cnt_byte == 3'd1) || (cnt_byte == 3'd5)) begin
            case (cnt_sck)
                0, 1: sck = 1'b0;
                2, 3: sck = 1'b1;
                default: sck = 1'b0;
            endcase
        end
        else
            sck = 1'b0;
    end

    // 当cnt_byte = 1和5时，cnt_bit从0~7计数
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            cnt_bit <= 3'd0;
        else if (cnt_bit == 3'd7 && cnt_sck == 2'd3)
            cnt_bit <= 3'd0;
        else if (((cnt_byte == 3'd1) || (cnt_byte == 3'd5)) && cnt_sck == 2'd3)
            cnt_bit <= cnt_bit + 1'b1;
    end

    // flash 主输入，从输出信号
    always @(*) begin
        if (!sys_rst_n)
            mosi = 1'b0;
        else if (cnt_byte == 3'd1)
            mosi = WR_EN_INST[7 - cnt_bit];
        else if (cnt_byte == 3'd5)
            mosi = BE_INST[7 - cnt_bit];
        else 
            mosi = 1'b0;
    end
endmodule