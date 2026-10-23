#!/bin/bash

FW_DIR="fw"

OUT=bin/rom
MEM_OUT=mem/rom.mem
RAM_OUT=mem/ram.mem
OBJ_OUT=$OUT.o

rm -rf bin/
mkdir bin
rm -rf mem/
mkdir mem


CC=riscv64-unknown-elf-gcc
TEST_NAME="${1:-vga_test}"
cmake -B build -S fw -DTEST_NAME="$TEST_NAME"

cmake --build build

riscv64-unknown-elf-objdump -d build/rvcpu > $OUT.dis

riscv64-unknown-elf-objcopy -O binary build/rvcpu $OUT.bin

xxd -p $OUT.bin > $OUT.hex

rm -f $MEM_OUT
cp $OUT.hex $MEM_OUT
python scripts/line_break.py $MEM_OUT 
# xxd -s $OUT.elf > example.bin

# create a dummy ram.mem file with 0s
rm -f $RAM_OUT
for i in {1..256}
do
    echo "00000000" >> $RAM_OUT
done
