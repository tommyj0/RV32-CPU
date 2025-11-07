#pragma once

#include <stdint.h>

#define VGA_ADDR 0x00010000


typedef struct display_t {
  uint32_t width;
  uint32_t height;
  // resolution reduction cos the FPGA sucks (not enough BRAM)
  uint32_t scale;
} display_t;

void vga_display_init(display_t * pdisplay, uint32_t width, uint32_t height, uint32_t scale);

/*
Draws pixel in 32 bit access [colour12b[12], y[10], x[10]]
Currently setup for one resolution only, 400x300x8, max of the hw & sw is 800x600x12 in current setup
So information that is sent is enough for this 



*/
void vga_draw_single_pixel(uint32_t x,uint32_t y, uint32_t colour12b);
