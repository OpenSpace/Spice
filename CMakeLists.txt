cmake_minimum_required(VERSION 3.0)
project(Spice)

file(GLOB SPICE_SOURCE ${PROJECT_SOURCE_DIR}/src/*.c)
file(GLOB SPICE_HEADER ${PROJECT_SOURCE_DIR}/include/*.h)

# list(REMOVE_ITEM SPICE_SOURCE "${PROJECT_SOURCE_DIR}/src/zzsecprt.c")

foreach (file ${SPICE_SOURCE})
    # set_source_files_properties(${file} PROPERTIES COMPILE_FLAGS "/O2")
    set_source_files_properties(${file} PROPERTIES COMPILE_DEFINITIONS "_COMPLEX_DEFINED;MSDOS;OMIT_BLANK_CC;NON_ANSI_STDIO")
endforeach ()

set_source_files_properties("${PROJECT_SOURCE_DIR}/src/zzsecprt.c" PROPERTIES COMPILE_DEFINITIONS "_COMPLEX_DEFINED;MSDOS;OMIT_BLANK_CC")

add_library(Spice ${SPICE_SOURCE})
target_include_directories(Spice PUBLIC "${PROJECT_SOURCE_DIR}/include")
