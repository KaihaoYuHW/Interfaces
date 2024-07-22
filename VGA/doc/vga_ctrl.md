# vga_ctrl

## module diagram

![vga_ctrl_module](https://github.com/KaihaoYuHW/Interfaces/blob/main/VGA/doc/vga_ctrl_module.png)

## signals

|     name     | width(bit) |   type   |                         description                          |
| :----------: | :--------: | :------: | :----------------------------------------------------------: |
|   vga_clk    |     1      |  input   |                            26Mhz                             |
|    rst_n     |     1      |  input   |                            reset                             |
|   pix_data   |     16     |  inpupt  |                        RGB565 format                         |
|    pix_x     |     10     |  output  | x-axis of the frame, which is scanned at the moment. Count from 0 to 640 |
|    pix_y     |     10     |  output  | y-axis of the frame, which is scanned at the moment. Count from 0 to 480 |
|    hsync     |     1      |  output  |                         HSync signal                         |
|    vsync     |     1      |  output  |                         VSync signal                         |
|     rgb      |     16     |  output  |                        RGB565 format                         |
|    cnt_h     |     10     | internal |           800 pixels pro row. Count from 0 to  799           |
|    cnt_v     |     10     | internal |           524 lines pro frame. Count from 0 to 524           |
|  rgb_valid   |     1      | internal | When the scanning pixel is in "Addressable" Video phase, rgb_valid = 1. Otherwise, rgb_valid = 0. |
| pix_data_req |     1      | internal | Only when pix_data_req = 1, pixel_x/y starts to count 0~640 or 0~480 |

## waveform

- define a vga cycle of vga_clk = 40ns
- define pix_data = 16'hffff

![vga_ctrl_waveform1](https://github.com/KaihaoYuHW/Interfaces/blob/main/VGA/doc/vga_ctrl_waveform1.png)

![vga_ctrl_waveform2](https://github.com/KaihaoYuHW/Interfaces/blob/main/VGA/doc/vga_ctrl_waveform2.png)

![vga_ctrl_waveform3](https://github.com/KaihaoYuHW/Interfaces/blob/main/VGA/doc/vga_ctrl_waveform3.png)

![vga_ctrl_waveform4](https://github.com/KaihaoYuHW/Interfaces/blob/main/VGA/doc/vga_ctrl_waveform4.png)

![vga_ctrl_waveform5](https://github.com/KaihaoYuHW/Interfaces/blob/main/VGA/doc/vga_ctrl_waveform5.png)

