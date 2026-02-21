#include "io.h"

void io_write_u32(uint32_t addr, uint32_t data) {
  *(volatile uint32_t*)addr = data;
}

void io_write_i32(uint32_t addr, int32_t data) {
  *(volatile int32_t*)addr = data;
}

uint32_t io_read_u32(uint32_t addr) {
  return *(volatile uint32_t*)addr;
}

int32_t io_read_i32(uint32_t addr) {
  return *(volatile int32_t*)addr;
}