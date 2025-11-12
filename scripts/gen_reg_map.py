

# could do as dictionary, array of tuples is easier to access
reg_maps = [
  ("QUAD_MASK",0xC000_0000), 
  ("ROM_BASE_ADDR",0x0000_0000), 
  ("RAM_BASE_ADDR",0x4000_0000), 
  ("EXT_BASE_ADDR",0x8000_0000), # idk what external could be used for 
  ("IO_BASE_ADDR",0xC000_0000), # for periphe
  ("VGA_ADDR",0xC000_0000), 
]

def write_c_map(file_path):
  fp = open(file_path + "/reg_map.h","w")
  fp.write("#pragma once\n\n")
  for reg in reg_maps:
    fp.write(f"#define\t{reg[0]}\t\t({hex(reg[1])})\n")
    
def write_verilog_map(file_path):
  fp = open(file_path + "/reg_map.vh","w")
  for reg in reg_maps:
    fp.write(f"`define\t{reg[0]}\t\t32'h{hex(reg[1])[2:]}\n")



if __name__ == "__main__":
  fw_inc_path = "fw/inc"
  rtl_path = "rtl"
  write_c_map(fw_inc_path)
  write_verilog_map(rtl_path)
