vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO luau-lang/luau
    REF "${VERSION}"
    SHA512 a7e0b6bf57770f026f59d66c1f424a9f292850076a07e203f7ab1296c229cb1541aee556bbc3833adc79f5a77520b4575539ffbd1422c044f59d60886feb917d
    PATCHES
        cmake-install.patch
)

string(COMPARE EQUAL "${VCPKG_CRT_LINKAGE}" "static" LUAU_STATIC_CRT)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DLUAU_BUILD_CLI=OFF
        -DLUAU_BUILD_TESTS=OFF
        -DLUAU_BUILD_WEB=OFF
        -DLUAU_STATIC_CRT=${LUAU_STATIC_CRT}
)

vcpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_cmake_config_fixup()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
