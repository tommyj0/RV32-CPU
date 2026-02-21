import sys

def align_rom(file_name,align_bytes=4):
  file = open(file_name,"r")
  lines = file.readlines()
  file = open(file_name,"w")
  align_chars = align_bytes*2 # each hex char is half a byte
  master_line = ""

  for line in lines:
    master_line += line

  
  master_line = master_line.replace('\n','')
  master_line = master_line.replace('\r','')
  if len(master_line) % align_chars != 0:
    raise Exception(f"incorrect line length for {align_bytes} byte alignment\n line: {master_line}")
  for i in range(len(master_line)//align_chars):
    for j in range(4):
      start_index = 8*i + 6 - j*2
      file.write(f"{master_line[start_index:start_index+2]}")
    file.write("\n")
  file.close()
    
    
if __name__ == "__main__":
  file_name = sys.argv[1]
  align_rom(file_name)



  