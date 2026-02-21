#include "vga_interface.h"

void 
vga_display_init(display_t * pdisplay, uint32_t width, uint32_t height, uint32_t scale)
{
  pdisplay->width = width;
  pdisplay->height = height;
  pdisplay->scale = scale;
  // TODO: HW init for display res
}

void
vga_draw_single_pixel(uint32_t x,uint32_t y, uint32_t colour12b) 
{
  uint32_t wdata = 0;
  wdata = colour12b;
  wdata <<= 10; // create space for coords
  wdata |= (y << 1);
  wdata <<= 10;
  wdata |= (x << 1);
  *(volatile uint32_t*)VGA_ADDR = wdata; 
}