#pragma once

#include <stdint.h>

void io_write_u32(uint32_t addr, uint32_t data);
void io_write_i32(uint32_t addr, int32_t data);

uint32_t io_read_u32(uint32_t addr);
int32_t io_read_i32(uint32_t addr);