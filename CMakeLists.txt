cmake_minimum_required(VERSION 3.19.2)
project(Spice)

# Include all *.c files from the library
file(GLOB SPICE_COMMON_SOURCE ${PROJECT_SOURCE_DIR}/src/common/*.c)
set(INCLUDE_PATH "${PROJECT_SOURCE_DIR}/include")

if (MSVC)
  file(GLOB SPICE_PLATFORM_SOURCE ${PROJECT_SOURCE_DIR}/src/msvc/*.c)
  set(INCLUDE_PATH "${PROJECT_SOURCE_DIR}/include/msvc" ${INCLUDE_PATH})
elseif (APPLE)
  # Detection code adapted from
  # https://github.com/Kitware/CMake/blob/master/Modules/CMakeDetermineSystem.cmake
  if (DEFINED CMAKE_APPLE_SILICON_PROCESSOR)
    set(_CMAKE_APPLE_SILICON_PROCESSOR "${CMAKE_APPLE_SILICON_PROCESSOR}")
  elseif(DEFINED ENV{CMAKE_APPLE_SILICON_PROCESSOR})
    set(_CMAKE_APPLE_SILICON_PROCESSOR "$ENV{CMAKE_APPLE_SILICON_PROCESSOR}")
  else()
    set(_CMAKE_APPLE_SILICON_PROCESSOR "")
  endif()
  
  if (_CMAKE_APPLE_SILICON_PROCESSOR STREQUAL "arm64")
    file(GLOB SPICE_PLATFORM_SOURCE ${PROJECT_SOURCE_DIR}/src/mac_arm/*.c)
    set(INCLUDE_PATH "${PROJECT_SOURCE_DIR}/include/mac_arm" ${INCLUDE_PATH})
  else ()
    file(GLOB SPICE_PLATFORM_SOURCE ${PROJECT_SOURCE_DIR}/src/mac/*.c)
    set(INCLUDE_PATH "${PROJECT_SOURCE_DIR}/include/mac" ${INCLUDE_PATH})
  endif()
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

option(SPICE_BUILD_SHARED_LIBRARY "Build SPICE library as shared library" ON)

if (SPICE_BUILD_SHARED_LIBRARY)
  add_library(spice SHARED ${SPICE_COMMON_SOURCE} ${SPICE_PLATFORM_SOURCE})
else ()
  add_library(spice STATIC ${SPICE_COMMON_SOURCE} ${SPICE_PLATFORM_SOURCE})
endif ()
set_target_properties(spice PROPERTIES POSITION_INDEPENDENT_CODE 1)
set_target_properties(spice PROPERTIES C_STANDARD 90)
target_include_directories(spice PUBLIC "${INCLUDE_PATH}")

if (WIN32)
  # Our compile definitions on Windows
  # We are not manually setting the optimization level, but leave that to the Debug/Release flags
  target_compile_definitions(spice PRIVATE 
    _COMPLEX_DEFINED
    MSDOS
    OMIT_BLANK_CC
    NON_ANSI_STDIO
  )
  target_compile_options(spice PRIVATE /MP)

  set_target_properties(spice PROPERTIES WINDOWS_EXPORT_ALL_SYMBOLS TRUE)
else ()
  target_compile_definitions(spice PRIVATE NON_ANSI_STDIO)
  target_compile_options(spice PRIVATE -ansi)
endif ()

if (MSVC)
  target_compile_options(spice PRIVATE /W0)
else ()
  target_compile_options(spice PRIVATE -w)
endif ()

if (WIN32)
  target_precompile_headers(spice PRIVATE
    <math.h>
    <string.h>
    <stdlib.h>
    [["f2c.h"]]
    [["SpiceUsr.h"]]
    [["SpiceZfc.h"]]
    [["SpiceZpr.h"]]
    [["SpiceZst.h"]]
    [["SpiceZmc.h"]]
  )
endif ()
