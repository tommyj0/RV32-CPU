#include "vga_interface.h"

int 
main()
{
  display_t game_display;
  vga_display_init(&game_display,400,300,1);
  for (int i = 0; i < 200; i++) {
    for (int j = 0;j  < 150; j++) {
      vga_draw_single_pixel(i,j,0xF0F);
    }
  }
}