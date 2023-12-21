vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO memononen/fontstash
    REF b5ddc9741061343740d85d636d782ed3e07cf7be
    SHA512 5a54045136946f625fca86d0399fa0a679a781ee869e74a66e0fbcaaba7debf94268baed98d85b5f94916c660b2f2d89f9c48b75d5731403321651cfc73b8aaa
    HEAD_REF master
)

file(COPY "${SOURCE_PATH}/src/fontstash.h" DESTINATION "${CURRENT_PACKAGES_DIR}/include")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")