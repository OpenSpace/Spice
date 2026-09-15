# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or distribute this
# software, either in source code form or as a compiled binary, for any purpose,
# commercial or non-commercial, and by any means.
#
# For more information, please refer to <https://unlicense.org>

# Install and export rules that make Spice consumable through
# `find_package(spice CONFIG REQUIRED)` and `target_link_libraries(... spice::spice)`

include(CMakePackageConfigHelpers)

set(SPICE_INSTALL_CMAKEDIR "${CMAKE_INSTALL_DATADIR}/spice")

install(
  TARGETS spice
  EXPORT SpiceTargets
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

# Only the headers for the platform that was actually built get installed. The per-platform
# subdirectories (msvc, mac, mac_arm, cygwin, linux) each define files with the same name
# (SpiceZpl.h, fio.h) as their siblings, so flattening all of them into one include
# directory would be ambiguous; INCLUDE_PATH already resolved to the correct subset above.
foreach (dir IN LISTS INCLUDE_PATH)
  install(
    DIRECTORY "${dir}/"
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    FILES_MATCHING PATTERN "*.h"
  )
endforeach ()

install(
  EXPORT SpiceTargets
  FILE SpiceTargets.cmake
  NAMESPACE spice::
  DESTINATION ${SPICE_INSTALL_CMAKEDIR}
)

configure_package_config_file(
  ${PROJECT_SOURCE_DIR}/support/cmake/spiceConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/spiceConfig.cmake
  INSTALL_DESTINATION ${SPICE_INSTALL_CMAKEDIR}
)

write_basic_package_version_file(
  ${CMAKE_CURRENT_BINARY_DIR}/spiceConfigVersion.cmake
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY SameMinorVersion
)

install(
  FILES
    ${CMAKE_CURRENT_BINARY_DIR}/spiceConfig.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/spiceConfigVersion.cmake
  DESTINATION ${SPICE_INSTALL_CMAKEDIR}
)
