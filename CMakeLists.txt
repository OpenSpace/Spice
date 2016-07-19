cmake_minimum_required(VERSION 3.0)
project(Spice)

# Include all *.c files from the library
file(GLOB SPICE_SOURCE ${PROJECT_SOURCE_DIR}/src/*.c)

add_library(Spice ${SPICE_SOURCE})

if (WIN32)
    # Our compile definitions on Windows
    # We are not manually setting the optimization level, but
    # leave that to the Debug/Release flags
    target_compile_definitions(
        Spice
        PUBLIC "_COMPLEX_DEFINED;MSDOS;OMIT_BLANK_CC;NON_ANSI_STDIO"
    )
elseif (APPLE)
    # The compile definitons on Mac
    target_compile_definitions(Spice PUBLIC "NON_ANSI_STDIO")
    target_compile_options(Spice PUBLIC -m64 -ansi -fPIC)
endif ()
 
if (MSVC)
    target_compile_options(Spice PUBLIC "/W0")
else ()
    target_compile_options(Spice PUBLIC "-w")
endif ()

 
target_include_directories(Spice PUBLIC "${PROJECT_SOURCE_DIR}/include")