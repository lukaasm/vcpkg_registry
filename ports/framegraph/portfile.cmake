vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO skaarj1989/FrameGraph
    REF 29d0ed5a3f8c03a193df1f03b947a082ae5f64ca
    SHA512 5da5cc729c42b4977c1d6df354e41117d32fc17fdeabb6a482e7ab53c8716bd4c47e8cd05d9d2a6caad5f0555330c600e3d9af96b850cc49a7e0afc926a5a853
    HEAD_REF master
    PATCHES
        export-targets.patch
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DFG_BUILD_TEST=OFF
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
