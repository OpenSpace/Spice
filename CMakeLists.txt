cmake_minimum_required(VERSION 3.4)
project(Spice)

# Include all *.c files from the library
file(GLOB SPICE_COMMON_SOURCE ${PROJECT_SOURCE_DIR}/src/common/*.c)
set(INCLUDE_PATH "${PROJECT_SOURCE_DIR}/include")

if (MSVC)
    file(GLOB SPICE_PLATFORM_SOURCE ${PROJECT_SOURCE_DIR}/src/msvc/*.c)
    set(INCLUDE_PATH "${PROJECT_SOURCE_DIR}/include/msvc" ${INCLUDE_PATH})
elseif (APPLE)
    file(GLOB SPICE_PLATFORM_SOURCE ${PROJECT_SOURCE_DIR}/src/mac/*.c)
    set(INCLUDE_PATH "${PROJECT_SOURCE_DIR}/include/mac" ${INCLUDE_PATH})
elseif (CYGWIN)
    file(GLOB SPICE_PLATFORM_SOURCE ${PROJECT_SOURCE_DIR}/src/cygwin/*.c)
    set(INCLUDE_PATH "${PROJECT_SOURCE_DIR}/include/cygwin" ${INCLUDE_PATH})
elseif (MINGW)
    # Untested
    file(GLOB SPICE_PLATFORM_SOURCE ${PROJECT_SOURCE_DIR}/src/linux/*.c)
    set(INCLUDE_PATH "${PROJECT_SOURCE_DIR}/include/linux" ${INCLUDE_PATH})
elseif (UNIX)
    file(GLOB SPICE_PLATFORM_SOURCE ${PROJECT_SOURCE_DIR}/src/linux/*.c)
    set(INCLUDE_PATH "${PROJECT_SOURCE_DIR}/include/linux" ${INCLUDE_PATH})
endif ()


add_library(SpiceObj OBJECT ${SPICE_COMMON_SOURCE} ${SPICE_PLATFORM_SOURCE})
set_property(TARGET SpiceObj PROPERTY POSITION_INDEPENDENT_CODE 1)

target_include_directories(SpiceObj PUBLIC "${INCLUDE_PATH}")

if (WIN32)
    # Our compile definitions on Windows
    # We are not manually setting the optimization level, but
    # leave that to the Debug/Release flags
    target_compile_definitions(
        SpiceObj
        PUBLIC "_COMPLEX_DEFINED;MSDOS;OMIT_BLANK_CC;NON_ANSI_STDIO"
    )

    set_target_properties(SpiceObj PROPERTIES WINDOWS_EXPORT_ALL_SYMBOLS TRUE)
elseif (APPLE)
    # The compile definitons on Mac
    target_compile_definitions(SpiceObj PUBLIC "NON_ANSI_STDIO")
    target_compile_options(SpiceObj PUBLIC "-m64;-ansi;-fPIC")
elseif (UNIX)
    target_compile_definitions(SpiceObj PUBLIC "NON_ANSI_STDIO")
    target_compile_options(SpiceObj PUBLIC "-m64;-ansi;-fPIC")
endif ()

get_property(compile_options TARGET SpiceObj PROPERTY COMPILE_OPTIONS)
string(REGEX REPLACE "(^|;)([/-])W[0-9](;|$)" ";" compile_options "${compile_options}") # remove any other waning level
if (MSVC)
    target_compile_options(SpiceObj PRIVATE "${compile_options};/W0")
else ()
    target_compile_options(SpiceObj PRIVATE "${compile_options};-w")
endif ()

add_library(Spice        SHARED $<TARGET_OBJECTS:SpiceObj>)
add_library(Spice_static STATIC $<TARGET_OBJECTS:SpiceObj>)
set_target_properties(Spice        PROPERTIES CLEAN_DIRECT_OUTPUT 1)
set_target_properties(Spice_static PROPERTIES CLEAN_DIRECT_OUTPUT 1)
