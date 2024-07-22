module vga_colorbar (
    input wire sys_clk,
    input wire sys_rst_n,
    output wire hsync,
    output wire vsync,
    output wire [15:0] rgb
);

    wire rst_n;
    wire locked;
    wire vga_clk;
    wire [15:0] pix_data;
    wire [9:0] pix_x;
    wire [9:0] pix_y;

    assign rst_n = (locked & sys_rst_n);

    clk_gen clk_gen_inst (
        .CLK_IN1 (sys_clk),
        .RESET (~sys_rst_n),
        .CLK_OUT1 (vga_clk),
        .LOCKED (locked)
    );
    
    vga_ctrl vga_ctrl_inst (
        .vga_clk (vga_clk),
        .rst_n (rst_n),
        .pix_data (pix_data),
        .pix_x (pix_x),
        .pix_y (pix_y),
        .hsync (hsync),
        .vsync (vsync),
        .rgb (rgb)
    );

    vga_pic vga_pic_inst (
        .vga_clk (vga_clk),
        .rst_n (rst_n),
        .pix_x (pix_x),
        .pix_y (pix_y),
        .pix_data (pix_data)
    );
endmodule