# fifo_sum_ctrl

## module diagram

![fifo_sum_ctrl_module](https://github.com/KaihaoYuHW/Interfaces/blob/main/fifo_sum/doc/fifo_sum_ctrl_module.png)

## signals

|   name    | width(bit) |   type   |              description               |
| :-------: | :--------: | :------: | :------------------------------------: |
|  sys_clk  |     1      |  input   |         system clock of 50Mhz          |
| sys_rst_n |     1      |  input   |                 reset                  |
|  pi_flag  |     1      |  input   |          input data is ready           |
|  pi_data  |     8      |  input   |               input data               |
|  po_flag  |     1      |  output  |         output result is ready         |
|  po_sum   |     8      |  output  |             output result              |
|  cnt_row  |     6      | internal |  row number of the element in matrix   |
|  cnt_col  |     6      | internal | column number of the element in matrix |
|  wr_en1   |     1      | internal |         write enable of fifo1          |
|  wr_en2   |     1      | internal |         write enable of fifo2          |
| data_in1  |     8      | internal |            data in of fifo1            |
| data_out1 |     8      | internal |           data out of fifo1            |
| data_out2 |     8      | internal |           data out of fifo2            |
|  po_flag  |     1      | internal |         help for sum operation         |

## waveform

We write the first row of a matrix into the fifo1, and the second row into the fifo2. When data of the third row is input into the module, we begin to do sum operation. 

![fifo_sum_ctrl_waveform1](https://github.com/KaihaoYuHW/Interfaces/blob/main/fifo_sum/doc/fifo_sum_ctrl_waveform1.png)

The sum result is correct. i.e. 1+1+1=3, 2+2+2=6, 3+3+3=9, 4+4+4=12, 5+5+5=15 ...

![fifo_sum_ctrl_waveform2](https://github.com/KaihaoYuHW/Interfaces/blob/main/fifo_sum/doc/fifo_sum_ctrl_waveform2.png)
