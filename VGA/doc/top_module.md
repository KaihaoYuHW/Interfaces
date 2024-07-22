# top_module

## module diagram

![top_module](https://github.com/KaihaoYuHW/Verilog_VGA/blob/main/doc/top_module.png)

## module description

|   name   |                           function                           |
| :------: | :----------------------------------------------------------: |
| clk_gen  | use Phase Locked Loop (PLL) to sys_clk (50Mhz) -> vga_clk (25Mhz) |
| vga_ctrl | According to vga_clk, we know the pixel which is scanned at that moment. This module outputs its coordinates, color, HSync, VSync. |
| vga_pic  | According to data about the pixel which is scanned at that moment from vga_ctrl module, determine whether this pixel should be filled with color or not? and which color should be filled? |

