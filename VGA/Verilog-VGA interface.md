# Verilog-VGA interface

VGA uses RGB (red, green and blue) mode, which refers to a system representing the colors used on a digital display screen. Red, green and blue can be combined in various proportions to obtain any color in the visible spectrum.

## project structure
- "doc": the information for each module (see .md)

- "rtl": the implementation of all modules (see .v)

- "sim": all testbenches of each module

## VGA connector

![VGA-connector-port](https://github.com/KaihaoYuHW/Interfaces/blob/main/VGA/doc/VGA-connector-port.png)

Here Pin_1 RED, Pin_2 GREEN, Pin_3 BLUE are the channels for transmitting three colors. These three pins transmit analog signals. Pin_13 is horizontal sync. Pin_14 is vertical sync. 

## Principle

![VGA scanning principle](https://github.com/KaihaoYuHW/Interfaces/blob/main/VGA/doc/VGA%20scanning%20principle.png)

1. With the synchronisation of Hsync and Vsync, we scan to the first pixel in the upper left corner. 
2. From the first pixel in the first row, we scan each pixel one by one.
3. After scanning to the last pixel in the first row, it means that the scanning of one row is completed, and we do blanking. After that, we begin to scan the first pixel in second row.
4. After we repeat these operations until scanning to the last pixel in the last row, it means that the scanning of a whole frame is completed, and we do blanking. After that, we start to scan the first pixel in the first row of the second frame. 

Each pixel is individually assigned a value during the scanning process so that each pixel can display the corresponding color. When a frame is completely scanned, we start to scan the next frame and the cycle repeats. When the scanning speed is fast enough, we can see a complete image instead of a single pixel. 

## VGA industry standard timing

![VGA industry standard timing](https://github.com/KaihaoYuHW/Interfaces/blob/main/VGA/doc/VGA%20industry%20standard%20timing.png)

In HSync, the period from the rising edge to the next rising edge called a line cycle. The unit in HSync is pixel clock (divided by system clock). One pixel is scanned in every pixel clock cycle. In a complete line cycle of HSync, a row of a frame is completely scanned. The video image is only valid in the "Addressable" Video phase, and invalid in other phases. 

In VSync, the period from the rising edge to the next rising edge called a field cycle. The unit in VSync is a line cycle in HSync. In a complete field cycle of VSync, a frame is completely scanned. The video image is only valid in the "Addressable" Video phase, and invalid in other phases. 

For VGA Signal 640 x 480 @ 60 Hz Industry standard timing

- General timing

  | Screen refresh rate |    60 Hz     |
  | :-----------------: | :----------: |
  |  Vertical refresh   | 31.46875 kHz |
  |     Pixel freq.     |  25.175 MHz  |

- Horizontal timing (line)

  | Scanline part | Pixels |    Time [µs]     |
  | :-----------: | :----: | :--------------: |
  | Visible area  |  640   | 25.422045680238  |
  |  Front porch  |   16   | 0.63555114200596 |
  |  Sync pulse   |   96   | 3.8133068520357  |
  |  Back porch   |   48   | 1.9066534260179  |
  |  Whole line   |  800   | 31.777557100298  |

- Vertical timing (frame)

  |  Frame part  | Lines |     Time [ms]     |
  | :----------: | :---: | :---------------: |
  | Visible area |  480  |  15.253227408143  |
  | Front porch  |  10   | 0.31777557100298  |
  |  Sync pulse  |   2   | 0.063555114200596 |
  |  Back porch  |  33   |  1.0486593843098  |
  | Whole frame  |  525  |  16.683217477656  |
