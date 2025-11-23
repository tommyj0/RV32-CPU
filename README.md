# RV32-CPU

## Overview

Simple RV32 core targetted for the Xilinx Basys3 FPGA. The aim is to have a lightweight core that complies with RV32G. Following that it should be able to use custom peripherals such as a mouse driver and VGA driver.

### Progress

Firmware compiles successfully into rom format which is readable. 

RTL is still in progress. Most modules work individually.

## Requirements

- Vivado: I used 2024.2, most recent builds should work

- riscv C compiler: follow instructions on repo to setup and install req

- Some form of linux to use the riscv toolchain, if on windows use WSL or MSYS

- Python 3.8+ if you want to regen the reg_maps 

## Run

### Compile 

```sh
./scripts/compile.sh
```

### FPGA

Include all sources in Vivado (including memory)



## Notes

Pipeline registers are typically at the end of stages. Might tweak this to put them in cpu, would be more elegant having the stage modules as combinational only. 

VGA Timings are taken from this website: [VGA Signal Timings](http://www.tinyvga.com/vga-timing)

Compiled with GNU89


