cmake_minimum_required(VERSION 3.0)
project(Spice)

# Include all *.c files from the library
file(GLOB SPICE_COMMON_SOURCE ${PROJECT_SOURCE_DIR}/src/common/*.c)
set(INCLUDE_PATH "${PROJECT_SOURCE_DIR}/include")

if (MSVC)
    file(GLOB SPICE_PLATFORM_SOURCE ${PROJECT_SOURCE_DIR}/src/msvc/*.c)
    set(INCLUDE_PATH "${PROJECT_SOURCE_DIR}/src/msvc" ${INCLUDE_PATH})
elseif (APPLE)
    file(GLOB SPICE_PLATFORM_SOURCE ${PROJECT_SOURCE_DIR}/src/mac/*.c)
    set(INCLUDE_PATH "${PROJECT_SOURCE_DIR}/src/mac" ${INCLUDE_PATH})
elseif (CYGWIN)
    file(GLOB SPICE_PLATFORM_SOURCE ${PROJECT_SOURCE_DIR}/src/cygwin/*.c)
    set(INCLUDE_PATH "${PROJECT_SOURCE_DIR}/src/cygwin" ${INCLUDE_PATH})
elseif (MINGW)
    # Untested
    file(GLOB SPICE_PLATFORM_SOURCE ${PROJECT_SOURCE_DIR}/src/linux/*.c)
    set(INCLUDE_PATH "${PROJECT_SOURCE_DIR}/src/linux" ${INCLUDE_PATH})
elseif (UNIX)
    file(GLOB SPICE_PLATFORM_SOURCE ${PROJECT_SOURCE_DIR}/src/linux/*.c)
    set(INCLUDE_PATH "${PROJECT_SOURCE_DIR}/src/linux" ${INCLUDE_PATH})
endif ()


add_library(Spice ${SPICE_COMMON_SOURCE} ${SPICE_PLATFORM_SOURCE})

target_include_directories(Spice PUBLIC "${INCLUDE_PATH}")

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
elseif (UNIX)
    target_compile_definitions(Spice PUBLIC "NON_ANSI_STDIO")
    target_compile_options(Spice PUBLIC -m64 -ansi -fPIC)
endif ()

if (MSVC)
    target_compile_options(Spice PUBLIC "/W0")
else ()
    target_compile_options(Spice PUBLIC "-w")
endif ()
