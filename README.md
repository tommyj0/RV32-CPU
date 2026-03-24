# RV32-CPU

## Overview

> This project is still a WIP. Gradually adding functionality...

Simple RV32 core targetted for the Xilinx Basys3 FPGA. The aim is to have a lightweight core that complies with rv32i. Following that it should be able to use custom peripherals such as a mouse driver and VGA driver. The firmware is written in C99.

## Requirements

- Vivado: 2024.2 is used here, most recent builds should work

- riscv C compiler: riscv64-unknown-elf-gcc

- Some form of linux to use the riscv toolchain, if on windows use WSL or MSYS. Vivado works on either (Windows or Linux) but the firmware toolchain requires Linux to cross-compile for the core.

- Python 3.8+ 

- A lot of patience

## Quick Start

### Compile 

- Create memory files by compiling the firmware:

```sh
./scripts/compile.sh
```

### FPGA

- Include all sources in Vivado (including memory files)

- Generate bistream as usual



## Notes

Pipeline registers are typically at the end of stages. Might tweak this to put them in cpu, would be more elegant having the stage modules as combinational only. 

VGA Timings are taken from this website: [VGA Signal Timings](http://www.tinyvga.com/vga-timing)
