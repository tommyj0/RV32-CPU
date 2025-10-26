# RV32-CPU

## Description

Simple (in development) RV32 core targetted for the Xilinx Basys3 FPGA

## Requirements

- Vivado

- riscv C compiler

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

Pipeline registers are typically at the end of stages. Might tweak this to put them in top, would be more elegant, but requires more code.
