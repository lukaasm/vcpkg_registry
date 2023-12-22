vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO websnarf/bstrlib
    REF "v${VERSION}"
    SHA512 396e0e25c9dd706fe7c6ecf6e92c8bd4a5ad843d5b1d57f62c0ee0c093d1df051354b7b72f0187d779278ca1c1515d8af8a5e534474b7353eecba8c89e212393
    HEAD_REF master
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}")

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup()

vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")