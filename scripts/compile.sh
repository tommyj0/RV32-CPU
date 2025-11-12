#!/bin/bash

FW_DIR="fw"

OUT=bin/rom
MEM_OUT=mem/rom.mem
OBJ_OUT=$OUT.o

rm -rf bin/
mkdir bin

CC=riscv64-unknown-elf-gcc
cmake -B build -S fw

cmake --build build

riscv64-unknown-elf-objdump -D build/rvcpu > $OUT.dis

riscv64-unknown-elf-objcopy -O binary build/rvcpu $OUT.bin

xxd -p $OUT.bin > $OUT.hex

rm -f $MEM_OUT
cp $OUT.hex $MEM_OUT
# xxd -s $OUT.elf > example.bin