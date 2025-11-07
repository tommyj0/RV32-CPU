# RV32-CPU

## Description

Simple RV32 core targetted for the Xilinx Basys3 FPGA. The aim is to have a lightweight core that complies with RV32G. Following that it should be able to use custom peripherals such as a mouse driver and VGA driver.

## Requirements

- Vivado: I used 2024.2, most recent builds should work

- riscv C compiler: follow instructions on repo to setup and install req

- Some form of linux to use the riscv toolchain: if on windows you can use WSL or MSYS

## Progress

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


## Notes

Pipeline registers are typically at the end of stages. Might tweak this to put them in cpu, would be more elegant having the stage modules as combinational only. 

VGA Timings are taken from this website: [VGA Signal Timings](http://www.tinyvga.com/vga-timing)


