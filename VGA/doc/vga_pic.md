# vga_pic

## module diagram

![vga_pic_module](https://github.com/KaihaoYuHW/Interfaces/blob/main/VGA/doc/vga_pic_module.png)

## signals

|   name   | width(bit) |  type  |                     description                      |
| :------: | :--------: | :----: | :--------------------------------------------------: |
| vga_clk  |     1      | input  |                        25MHz                         |
|  rst_n   |     1      | input  |                        reset                         |
|  pix_x   |     10     | input  | x-axis of the frame, which is scanned at the moment. |
|  pix_y   |     10     | input  | y-axis of the frame, which is scanned at the moment. |
| pix_data |     16     | output |  the color data, which is filled in scanning pixel.  |

