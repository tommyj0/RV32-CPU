ENTRY(_start)
/* STARTUP("crt0.s") */


MEMORY
{
  ROM : ORIGIN = 0, LENGTH = 64k
  RAM : ORIGIN = 0x40000000, LENGTH = 64k
}


REGION_ALIAS("REGION_TEXT", ROM);
REGION_ALIAS("REGION_RODATA", ROM);
REGION_ALIAS("REGION_DATA", RAM);
REGION_ALIAS("REGION_BSS", RAM);

SECTIONS
  {
    .text :
      {
        *crt0.s.o(.text)
        *(.text)
      } > REGION_TEXT
    .rodata :
      {
        *(.rodata)
        rodata_end = .;
      } > REGION_RODATA
    .data : AT (rodata_end)
      {
        data_start = .;
        *(.data)
      } > REGION_DATA
    data_size = SIZEOF(.data);
    data_load_start = LOADADDR(.data);
    .bss :
      {
        *(.bss)
      } > REGION_BSS
  }
