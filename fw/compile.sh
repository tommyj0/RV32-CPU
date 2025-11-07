#!/bin/bash

OUT=rom

rm -rf $OUT.dis
rm -rf $OUT.elf

INC="-I ."
FLAGS="-march=rv32i -mabi=ilp32  -nostdlib -nostartfiles"

riscv64-unknown-elf-gcc *.c -o $OUT.elf $FLAGS $INC

riscv64-unknown-elf-objdump -D $OUT.elf > $OUT.dis
# xxd -s $OUT.elf > example.bin