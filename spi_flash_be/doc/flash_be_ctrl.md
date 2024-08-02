# flash_be_ctrl

## module diagram

![flash_be_ctrl_module](https://github.com/KaihaoYuHW/Interfaces/blob/main/spi_flash_be/doc/flash_be_ctrl_module.png)

## signals

|   name    | width(bit) |   type   |                         description                          |
| :-------: | :--------: | :------: | :----------------------------------------------------------: |
|  sys_clk  |     1      |  input   |                    system clock of 50MHz                     |
| sys_rst_n |     1      |  input   |                            reset                             |
|    key    |     1      |  input   |                          key signal                          |
|    sck    |     1      |  output  |                      flash serial clock                      |
|   cs_n    |     1      |  output  |                      chip select signal                      |
|   mosi    |     1      |  output  |                  Master output, Slave input                  |
|  cnt_clk  |     5      | internal | $` t_{SHSL} = t_{CHSH} = t_{SHSL} = time\ of\ outputting\ an\ instruction = 640ns `$ |
| cnt_byte  |     3      | internal |                0 to 2: WR_EN, 3: DELAY, 4 to 6: BE                 |
|   state   |     4      | internal |                    IDLE, WR_EN, DELAY, BE                    |
|  cnt_sck  |     2      | internal |  When the instruction is output, divide the clock by four.   |
|  cnt_bit  |     3      | internal |    When the instruction is output, count the output bit.     |

## waveform

The first instruction is writing enable instruction (WREN): 8’b0000_0110(06h)

![WREN instruction](https://github.com/KaihaoYuHW/Interfaces/blob/main/spi_flash_be/doc/flash_be_ctrl_waveform1.png)

The second instruction is bulk erase instruction (BE): 8’b1100_0111(C7h)

![BE instruction](https://github.com/KaihaoYuHW/Interfaces/blob/main/spi_flash_be/doc/flash_be_ctrl_waveform2.png)
