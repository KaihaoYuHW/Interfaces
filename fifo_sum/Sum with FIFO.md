# Sum with FIFO

## Experiment Goal

We use Matlab to generate a txt file including data of a matrix. Then, it will be transmitted from PC to FPGA through RS232. In FPGA, we design two FIFOs to do the sum operation of three rows in a matrix. The result will be sent back to PC through RS232 as well, and displayed by a serial port APP. 

## Principle

Three adjacent rows in a M*N matrix are summed to get a new matrix.

![fifo_sum principle 2](https://github.com/KaihaoYuHW/Interfaces/blob/main/fifo_sum/doc/fifo_sum%20principle%202.png)

Since the serial port can only pass single-byte at a time, it is necessary to use FIFO to store the input data to achieve multi-lines data summation.  We use two FIFOs for data caching, because this experiment is to sum 3 lines of data. 

![fifo_sum principle 1](https://github.com/KaihaoYuHW/Interfaces/blob/main/fifo_sum/doc/fifo_sum%20principle%201.png)

## Design

The architecture is made of two parts. One is uart for transmitting data. The other one is FIFO for sum operation.

![fifo_sum architecture](https://github.com/KaihaoYuHW/Interfaces/blob/main/fifo_sum/doc/fifo_sum%20architecture.png)

## Implementation

After the program is downloaded, we use a serial port APP to send data to FPGA board, and then the APP receives the result of sum operation. As the figure shown below, the sum result is correct. 

![serial port result](https://github.com/KaihaoYuHW/Interfaces/blob/main/fifo_sum/doc/serial%20port%20result.png)

