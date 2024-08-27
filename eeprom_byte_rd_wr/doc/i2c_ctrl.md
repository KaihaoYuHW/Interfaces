# i2c_ctrl

## module diagram

![i2c_ctrl_module](E:\IC_design\Verilog\FPGA_S6\eeprom_byte_rd_wr\doc\i2c_ctrl_module.png)

## signals

|    name     | width(bits) |   type   |                         description                          |
| :---------: | :---------: | :------: | :----------------------------------------------------------: |
|   sys_clk   |      1      |  input   |                            50Mhz                             |
|  sys_rst_n  |      1      |  input   |                            reset                             |
|    wr_en    |      1      |  input   |                     write enable signal                      |
|    rd_en    |      1      |  input   |                      read enable signal                      |
|  i2c_start  |      1      |  input   |         start signal for single byte reading/writing         |
|  addr_num   |      1      |  input   | "0" indicates single byte address. "1" indicates 2 bytes address. |
|  byte_addr  |     16      |  input   |                      address in EEPROM                       |
|   wr_data   |      8      |  input   |                    write data into EEPROM                    |
|   i2c_end   |      1      |  output  |          end signal for single byte reading/writing          |
|   rd_data   |      8      |  output  |                  read byte data from EEPROM                  |
|   i2c_scl   |      1      |  output  |             i2c serial clock signal SCL: 250khz              |
|   i2c_sda   |      1      |  inout   |                  i2c serial data signal SDA                  |
|    state    |      4      | internal |                       total 16 states                        |
|   cnt_clk   |      8      | internal |                     count from 0 to 199                      |
|   cnt_bit   |      3      | internal |                      count from 0 to 7                       |
| i2c_sda_reg |      1      | internal |                       input of i2c_sda                       |
|   sda_en    |      1      | internal |                   enable signal of i2c_sda                   |
| rd_data_reg |      8      | internal |    In RD_DATA state, store data of i2c_sda in rd_data_reg    |
|     ack     |      1      | internal |             sample data of i2c_sda in ACK state              |

## waveform

![i2c_ctrl_wave diagram_1](E:\IC_design\Verilog\FPGA_S6\eeprom_byte_rd_wr\doc\i2c_ctrl_wave diagram_1.bmp)

![i2c_ctrl_wave diagram_2](E:\IC_design\Verilog\FPGA_S6\eeprom_byte_rd_wr\doc\i2c_ctrl_wave diagram_2.bmp)

![i2c_ctrl_wave diagram_3](E:\IC_design\Verilog\FPGA_S6\eeprom_byte_rd_wr\doc\i2c_ctrl_wave diagram_3.bmp)

![i2c_ctrl_wave diagram_4](E:\IC_design\Verilog\FPGA_S6\eeprom_byte_rd_wr\doc\i2c_ctrl_wave diagram_4.bmp)

![i2c_ctrl_wave diagram_5](E:\IC_design\Verilog\FPGA_S6\eeprom_byte_rd_wr\doc\i2c_ctrl_wave diagram_5.bmp)

![i2c_ctrl_wave diagram_6](E:\IC_design\Verilog\FPGA_S6\eeprom_byte_rd_wr\doc\i2c_ctrl_wave diagram_6.bmp)

![i2c_ctrl_wave diagram_7](E:\IC_design\Verilog\FPGA_S6\eeprom_byte_rd_wr\doc\i2c_ctrl_wave diagram_7.bmp)

![i2c_ctrl_wave diagram_8](E:\IC_design\Verilog\FPGA_S6\eeprom_byte_rd_wr\doc\i2c_ctrl_wave diagram_8.bmp)

