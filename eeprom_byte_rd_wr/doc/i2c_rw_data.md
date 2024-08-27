# i2c_rw_data

## module diagram

![i2c_rw_data_module](https://github.com/KaihaoYuHW/Interfaces/blob/main/eeprom_byte_rd_wr/doc/i2c_rw_data_module.png)

## signals

|      name       | width(bit) |   type   |                         description                          |
| :-------------: | :--------: | :------: | :----------------------------------------------------------: |
|     sys_clk     |     1      |  input   |                            50Mhz                             |
|    sys_rst_n    |     1      |  input   |                            reset                             |
|      write      |     1      |  input   |                         write pulse                          |
|      read       |     1      |  input   |                          read pulse                          |
|     i2c_end     |     1      |  input   |          end signal for single byte reading/writing          |
|     rd_data     |     8      |  input   |                  read byte data from EEPROM                  |
|      wr_en      |     1      |  output  |       execute 10 writing instructions under wr_en = 1        |
|      rd_en      |     1      |  output  |       execute 10 reading instructions under rd_en = 1        |
|    i2c_start    |     1      |  output  |         start signal for single byte reading/writing         |
|    byte_addr    |     16     |  output  |                      address in EEPROM                       |
|     wr_data     |     8      |  output  |                    write data into EEPROM                    |
|  fifo_rd_data   |     8      |  output  |                     read data from FIFO                      |
|    cnt_start    |     17     | internal |         count from 0 to 199999 to generate i2c_start         |
| wr_i2c_data_num |     4      | internal |                      count from 0 to 9                       |
|  fifo_rd_valid  |     1      | internal |        generate rd_en of FIFO under fifo_rd_valid = 1        |
|    cnt_wait     |     17     | internal | count from 0 to 24999999 to generate rd_en of FIFO. Time of a number displayed on 7 segment. |
|   fifo_rd_en    |     1      | internal |                        rd_en of FIFO                         |
|   rd_data_num   |     4      | internal |                      count from 0 to 9                       |

## waveform

![i2c_rw_data_wave diagram_1](https://github.com/KaihaoYuHW/Interfaces/blob/main/eeprom_byte_rd_wr/doc/i2c_rw_data_wave%20diagram_1.bmp)

![i2c_rw_data_wave diagram_2](https://github.com/KaihaoYuHW/Interfaces/blob/main/eeprom_byte_rd_wr/doc/i2c_rw_data_wave%20diagram_2.bmp)

![i2c_rw_data_wave diagram_3](https://github.com/KaihaoYuHW/Interfaces/blob/main/eeprom_byte_rd_wr/doc/i2c_rw_data_wave%20diagram_3.bmp)
