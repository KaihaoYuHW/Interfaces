module top_module (
    input wire sys_clk,
    input wire sys_rst_n,
    input wire rx,
    output wire tx
);

    wire pi_flag;
    wire [7:0] pi_data;
    wire po_flag;
    wire [7:0] po_sum;

    uart_rx uart_rx_inst (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .rx(rx),
        .po_data(pi_data),
        .po_flag(pi_flag)
    );

    uart_tx uart_tx_inst (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .pi_data(po_sum),
        .pi_flag(po_flag),
        .tx(tx)
    );

    fifo_sum_ctrl fifo_sum_ctrl_inst (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .pi_flag(pi_flag),
        .pi_data(pi_data),
        .po_flag(po_flag),
        .po_sum(po_sum)
    );
endmodule