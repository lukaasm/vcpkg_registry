set(SDL_GH_REPOSITORY libsdl-org/SDL)
set(SDL_GH_REPOSITORY_REF 8b48b70c6ed05ce58d896f73b857f2c82bf3e04f)
set(SDL_GH_REPOSITORY_HEAD main)
set(SDL_GH_REPOSITORY_SHA f1b0ec0ca0005fe3f2640edb39010ad4748462f42108accb8f3329fcc2a80a9dd1bb7a75d367dcc6da3dab9b3cc98a55c29de56d3fb781cc2e7bf6b0e34f64c1)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ${SDL_GH_REPOSITORY}
    REF ${SDL_GH_REPOSITORY_REF}
    SHA512 ${SDL_GH_REPOSITORY_SHA}
    HEAD_REF ${SDL_GH_REPOSITORY_HEAD}
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" SDL_STATIC)
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" SDL_SHARED)
string(COMPARE EQUAL "${VCPKG_CRT_LINKAGE}" "static" FORCE_STATIC_VCRT)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        alsa     SDL_ALSA
        ibus     SDL_IBUS
        vulkan   SDL_VULKAN
        wayland  SDL_WAYLAND
        x11      SDL_X11
)

if ("x11" IN_LIST FEATURES)
    message(WARNING "You will need to install Xorg dependencies to use feature x11:\nsudo apt install libx11-dev libxft-dev libxext-dev\n")
endif()
if ("wayland" IN_LIST FEATURES)
    message(WARNING "You will need to install Wayland dependencies to use feature wayland:\nsudo apt install libwayland-dev libxkbcommon-dev libegl1-mesa-dev\n")
endif()
if ("ibus" IN_LIST FEATURES)
    message(WARNING "You will need to install ibus dependencies to use feature ibus:\nsudo apt install libibus-1.0-dev\n")
endif()

if(VCPKG_TARGET_IS_UWP)
    set(configure_opts WINDOWS_USE_MSBUILD)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    ${configure_opts}
    OPTIONS ${FEATURE_OPTIONS}
        -DSDL_STATIC=${SDL_STATIC}
        -DSDL_SHARED=${SDL_SHARED}
        -DSDL_STATIC_VCRT=${FORCE_STATIC_VCRT}
        -DSDL_LIBC=ON
        -DSDL_TESTS=OFF
        -DSDL_INSTALL_CMAKEDIR="cmake"
        -DCMAKE_DISABLE_FIND_PACKAGE_Git=ON
        -DPKG_CONFIG_USE_CMAKE_PREFIX_PATH=ON
    MAYBE_UNUSED_VARIABLES
        SDL_STATIC_VCRT
        PKG_CONFIG_USE_CMAKE_PREFIX_PATH
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH cmake)

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
    "${CURRENT_PACKAGES_DIR}/bin/sdl3-config"
    "${CURRENT_PACKAGES_DIR}/debug/bin/sdl3-config"
    "${CURRENT_PACKAGES_DIR}/SDL3.framework"
    "${CURRENT_PACKAGES_DIR}/debug/SDL3.framework"
    "${CURRENT_PACKAGES_DIR}/share/licenses"
    "${CURRENT_PACKAGES_DIR}/share/aclocal"
)

file(GLOB BINS "${CURRENT_PACKAGES_DIR}/debug/bin/*" "${CURRENT_PACKAGES_DIR}/bin/*")
if(NOT BINS)
    file(REMOVE_RECURSE
        "${CURRENT_PACKAGES_DIR}/bin"
        "${CURRENT_PACKAGES_DIR}/debug/bin"
    )
endif()

vcpkg_copy_pdbs()

set(DYLIB_COMPATIBILITY_VERSION_REGEX "set\\(DYLIB_COMPATIBILITY_VERSION (.+)\\)")
set(DYLIB_CURRENT_VERSION_REGEX "set\\(DYLIB_CURRENT_VERSION (.+)\\)")
file(STRINGS "${SOURCE_PATH}/CMakeLists.txt" DYLIB_COMPATIBILITY_VERSION REGEX ${DYLIB_COMPATIBILITY_VERSION_REGEX})
file(STRINGS "${SOURCE_PATH}/CMakeLists.txt" DYLIB_CURRENT_VERSION REGEX ${DYLIB_CURRENT_VERSION_REGEX})
string(REGEX REPLACE ${DYLIB_COMPATIBILITY_VERSION_REGEX} "\\1" DYLIB_COMPATIBILITY_VERSION "${DYLIB_COMPATIBILITY_VERSION}")
string(REGEX REPLACE ${DYLIB_CURRENT_VERSION_REGEX} "\\1" DYLIB_CURRENT_VERSION "${DYLIB_CURRENT_VERSION}")

if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/sdl3.pc" "-lSDL3 " "-lSDL3d ")
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/sdl3.pc" "-lSDL3-static " "-lSDL3-staticd ")
endif()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic" AND VCPKG_TARGET_IS_WINDOWS AND NOT VCPKG_TARGET_IS_MINGW)
    if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
        vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/sdl3.pc" "-lSDL3-static " " ")
    endif()
    if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
        vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/sdl3.pc" "-lSDL3-staticd " " ")
    endif()
endif()

if(VCPKG_TARGET_IS_UWP)
    if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
        vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/sdl3.pc" "$<$<CONFIG:Debug>:d>.lib" "")
        vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/sdl3.pc" "-l-nodefaultlib:" "-nodefaultlib:")
    endif()
    if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
        vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/sdl3.pc" "$<$<CONFIG:Debug>:d>.lib" "d")
        vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/sdl3.pc" "-l-nodefaultlib:" "-nodefaultlib:")
    endif()
endif()

vcpkg_fixup_pkgconfig()

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")