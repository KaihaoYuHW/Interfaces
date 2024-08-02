module top_module (
    input wire sys_clk,
    input wire sys_rst_n,
    input wire pi_key,
    output wire sck,
    output wire cs_n,
    output wire mosi
);

    wire po_key;

    key_filter key_filter_inst (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .key_in(pi_key),
        .key_flag(po_key)
    );

    flash_be_ctrl flash_be_ctrl_inst (
        .sys_clk(sys_clk),
        .key(po_key),
        .sys_rst_n(sys_rst_n),
        .sck(sck),
        .cs_n(cs_n),
        .mosi(mosi)
    );
    
endmodule