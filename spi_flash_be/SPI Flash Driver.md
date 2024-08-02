# SPI Flash Driver

## Experiment Goal

We write a led program into a flash in advance. FPGA will execute the program after it is powered up. Then, we download the full flash erase program into the SRAM of FPGA and execute it. The instructions are transmitted into flash unit through SPI interface to remove the led program. After FPGA is rebooted, there is no program to run. 

## SPI interfaces

SPI interface is a simple and high speed communication, but it has no specific control flow, and no response to confirm receipt of data.

The communication forms of SPI are a single main to a single sub and a single main to multi subs, including a Serial Clock (SPI), a Master output to Slave input (MOSI), a Master input to Slave output (MISO) and a Chip select (CS_N). SPI uses the CS_N signal for addressing because there is no address for slave devices. When the host wants to select a slave device, it sets CS_N of that to low. Then, the host starts to communicate with the selected slave device. 

![a single main to a single sub](E:\IC_design\Verilog\FPGA_S6\spi_flash_be\doc\a single main to a single sub.png)

![a single main to multi subs](E:\IC_design\Verilog\FPGA_S6\spi_flash_be\doc\a single main to multi subs.png)

SPI has 4 modes: SPI_0, SPI_1, SPI_2, SPI_3, where SPI_0 is the most popular.  In an idle state, SCK is low. Data of MOSI and MISO is sampled on the rising edge of SCK, and updated on the falling edge. 

![SPI mode 0](E:\IC_design\Verilog\FPGA_S6\spi_flash_be\doc\SPI_0.png)

## Principle

The bulk erase operation of flash consists of two instructions. The first one is writing enable instruction (WREN): 8’b0000_0110(06h). The other is bulk erase instruction (BE): 8’b1100_0111(C7h). As below, it is a wave diagram of entire erase operation.

![wave diagram_bulk erase operation](E:\IC_design\Verilog\FPGA_S6\spi_flash_be\doc\wave diagram_bulk erase operation.png)

We assume that $ t_{SHSL} = t_{CHSH} = t_{SHSL} = time of outputting an instruction= 640ns $ for simplification.

## Design

The architecture is made of key filter and a SPI flash driver.

![spi_flash_be architecture](E:\IC_design\Verilog\FPGA_S6\spi_flash_be\doc\spi_flash_be architecture.png)

## Implementation

We use "ISE iMPACT" to download LED program into the FPGA board, and meanwhile write it into Flash unit. Later, FPGA can automatically run the program without downloading it again after rebooting.

![download program in flash](E:\IC_design\Verilog\FPGA_S6\spi_flash_be\doc\download program into flash.png)

Next, we download the bulk erase program into SRAM. When we press KEY1 button, all data in flash unit will be erased. (i.e. There is no LED program after rebooting.)

