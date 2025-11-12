
cmake_minimum_required(VERSION 3.15)

project(rvcpu LANGUAGES C)

set(CMAKE_C_COMPILER "riscv64-unknown-elf-gcc")
set(CMAKE_ASM_COMPILER "riscv64-unknown-elf-gcc")

# --------------------------------------------------------------------
# Configuration
# --------------------------------------------------------------------
set(CMAKE_C_STANDARD 99)

# Build type: Debug / Release
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif()

# --------------------------------------------------------------------
# Directories
# --------------------------------------------------------------------
# Source and include directories
set(SRC_DIR ${CMAKE_SOURCE_DIR}/src)
set(INCLUDE_DIR ${CMAKE_SOURCE_DIR}/inc)

# Collect all .c or .cpp files automatically
file(GLOB_RECURSE SOURCES ${SRC_DIR}/*.c ${CMAKE_SOURCE_DIR}/utils/*.s)

include_directories(${INCLUDE_DIR})

# --------------------------------------------------------------------
# Linker Flags
# --------------------------------------------------------------------
# Add custom linker flags if needed

## set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--as-needed")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -T ${CMAKE_SOURCE_DIR}/utils/boot.ld")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -nostdlib")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -march=rv32i -mabi=ilp32")
  

# --------------------------------------------------------------------
# External Libraries
# --------------------------------------------------------------------
# link_directories(/usr/X11R6/lib)

# Example manual linking:
## set(LIBS Xext X11 nsl m)

# --------------------------------------------------------------------
# Targets
# --------------------------------------------------------------------
add_executable(${PROJECT_NAME} ${SOURCES})

# Link libraries (add or remove as needed)
## target_link_libraries(${PROJECT_NAME}
    ## PRIVATE
        ## ${LIBS}
## )

# Optional: set compile options per target
target_compile_options(${PROJECT_NAME}
    PRIVATE
      -march=rv32i -mabi=ilp32  
      -g -Wall -Werror -O0
      #-DNORMALUNIX -DLINUX # -DUSEASM 
)

# Optional: specify include directories per target
target_include_directories(${PROJECT_NAME}
    PRIVATE
        ${INCLUDE_DIR}
)

# --------------------------------------------------------------------
# Installation (optional)
# --------------------------------------------------------------------
# install(TARGETS ${PROJECT_NAME} DESTINATION bin)
# install(DIRECTORY ${INCLUDE_DIR}/ DESTINATION include)