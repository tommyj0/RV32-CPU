# RV32-CPU

## Description

Simple RV32 core targetted for the Xilinx Basys3 FPGA. The aim is to have a lightweight core that complies with RV32G. Following that it should be able to use custom peripherals such as a mouse driver and VGA driver.

## Requirements

- Vivado: I used 2024.2, most recent builds should work

- riscv C compiler: follow instructions on repo to setup and install req

- Some form of linux to use the riscv toolchain, if on windows use WSL or MSYS

- Python 3.8+ if you want to regen the reg_maps 

## Usage

### Compile 

```sh
./scripts/compile.sh
```


## Progress

### Hardware 

| module | design | testbench | verified |
|---|---:|---|:---|
| cpu (top) | X | - | - | 
| instr_fetch | X | X | X |
| decode | - |  - | - |
| regfile | X |  X | X |
| alu | X | X  | X |
| alu_control | X |  - | - |
| control_unit | X |  - | - |
| mem_access | X |  - | - |
| ram | X |  - | - |
| rom | X |  - | - |

Done:

- Most of the RTL for CPU pipeline stages

- Working VGA Driver for 800x600x12 (scaled down to 400x300x8 in the frame buffer)

TODO:

- Immediate Generation

- ALU control

- VGA Driver Connection

### Firmware

Done:

- Quick test build to manually copy and paste instructions into mem

TODO:

- Cmake setup

- Automatically move binary into the mem file



## Notes

Pipeline registers are typically at the end of stages. Might tweak this to put them in cpu, would be more elegant having the stage modules as combinational only. 

VGA Timings are taken from this website: [VGA Signal Timings](http://www.tinyvga.com/vga-timing)

Compiled with GNU89


