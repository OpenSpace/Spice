# This port lives inside the Spice repository and builds the enclosing checkout. When
# publishing Spice to a registry, replace this with vcpkg_from_github(REPO OpenSpace/Spice
# REF <tag> SHA512 <hash>) so that the port is reproducible and content-addressed.
get_filename_component(SOURCE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../../.." ABSOLUTE)

vcpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
  OPTIONS
    -DSPICE_BUILD_SHARED_LIBRARY=OFF
    -DSPICE_ENABLE_INSTALL=ON
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH share/spice)
vcpkg_copy_pdbs()

file(REMOVE_RECURSE
  "${CURRENT_PACKAGES_DIR}/debug/include"
  "${CURRENT_PACKAGES_DIR}/debug/share"
)

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

# Spice ships no LICENSE file; disclaimer.txt carries the disclaimer verbatim from the top
# of every source file in the toolkit.
vcpkg_install_copyright(FILE_LIST "${CMAKE_CURRENT_LIST_DIR}/disclaimer.txt")
