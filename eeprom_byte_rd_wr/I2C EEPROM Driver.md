# I2C EEPROM Driver

## Experiment Goal

We use I2C communication protocol to design an EEPROM controller which can write or read data into EEPROM. Number 1 to 10 are written into EEPROM by KEY 1. They can be read from EEPROM later by KEY 2, and meanwhile shown on 7 segment display. 

## I2C interface

The I2C communication protocol (Inter - Integrated Circuit) is a simple, bi-directional, synchronous serial bus developed by Philips that has two wires to transfer information between devices connected to the bus.

Its physical layer has the following characteristics:

1. I2C is a bus that supports multiple devices. Multiple I2C communication devices can be connected to an I2C bus.
2. An I2C bus uses only two bus lines, a bi-directional serial data line (SDA) and a serial clock line (SCL). The data line is used to transfer data and the clock line is used to synchronize data sending and receiving.
3. Each device connected to the bus has an individual address that is used by the host for access to different devices.
4. The bus is connected to the power supply through a pull-up resistor. When the I2C device is IDLE, it will output high resistance. 
5. When multiple hosts use a bus at the same time, we determine which device works on the bus by arbitration in order to prevent data conflicts. 

![I2C connection](E:\IC_design\Verilog\FPGA_S6\eeprom_byte_rd_wr\doc\I2C connection.png)

The wave diagram of I2C protocol includes four parts.

1. The label ① in the figure indicates "idle state". In this state, both SCL and SDA are high, and no I2C device works.
2. The label ② indicates "start state". In this state, SCL keeps high, and SDA is from high to low. The falling edge is actually a start signal. When all I2C devices detect the signal, they will end "start state" and wait for the input of instruction.
3. ③ is "read/write state". In this state, the host writes instructions or data to the slave. Only one bit is written at a time. Data will be changed on SDA line when SCL is low. Data will be stayed on SDA line when SCL is high. If the slave receives data successfully, SDA will be low to send a response signal (1 bit) back. After that, we can end or start to transfer the next instruction or data. 
4. ④ is "stop state". After we finish reading or writing data, SCL becomes high. When SDA generates a rising edge which indicates a stop signal, I2C bus goes back to "idle state". 

![I2C diagram](E:\IC_design\Verilog\FPGA_S6\eeprom_byte_rd_wr\doc\I2C wave diagram.png)

## Principle

- single byte writing operation

![single byte writing operation](E:\IC_design\Verilog\FPGA_S6\eeprom_byte_rd_wr\doc\single byte write operation.png)

- single byte reading operation

![single byte reading operation](E:\IC_design\Verilog\FPGA_S6\eeprom_byte_rd_wr\doc\single byte read operation.png)

## Design

The architecture is made of data generator module and a I2C driver.

![eeprom_byte_rd_wr](E:\IC_design\Verilog\FPGA_S6\eeprom_byte_rd_wr\doc\eeprom_byte_rd_wr_architecture.png)

## Implementation

We press KEY_1 to write number 1 to 10 into EEPROM first. Next, we press KEY_2 to read data stored in EEPROM and show them on 7 segment display. 