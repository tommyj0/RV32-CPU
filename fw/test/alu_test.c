#include <stdint.h>

#include "vga_interface.h"

#define TEST_COUNT 10
#define PASS_COLOUR 0x0F0
#define FAIL_COLOUR 0xF00

static uint32_t
run_test(uint32_t test_number)
{
  volatile uint32_t lhs = 0xA5A5A5A5;
  volatile uint32_t rhs = 0x0F0F0F0F;
  volatile int32_t signed_lhs = -1;
  volatile int32_t signed_rhs = 1;

  switch (test_number) {
    case 0:
      return lhs + rhs == 0xB4B4B4B4;
    case 1:
      return lhs - rhs == 0x96969696;
    case 2:
      return (lhs & rhs) == 0x05050505;
    case 3:
      return (lhs | rhs) == 0xAFAFAFAF;
    case 4:
      return (lhs ^ rhs) == 0xAAAAAAAA;
    case 5:
      return (lhs << 4) == 0x5A5A5A50;
    case 6:
      return (lhs >> 4) == 0x0A5A5A5A;
    case 7:
      return (signed_lhs >> 4) == -1;
    case 8:
      return signed_lhs < signed_rhs;
    case 9:
      return rhs < lhs;
    default:
      return 0;
  }
}

int
main()
{
  display_t test_display;
  vga_display_init(&test_display, 400, 300, 1);

  for (uint32_t test_number = 0; test_number < TEST_COUNT; test_number++) {
    uint32_t colour = run_test(test_number) ? PASS_COLOUR : FAIL_COLOUR;
    vga_draw_single_pixel(test_number, 0, colour);
  }

  while (1) {
  }
}
