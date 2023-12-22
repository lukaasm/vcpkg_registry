cmake_minimum_required (VERSION 3.9)

project(bstrlib C CXX)

set(HEADERS
    bsafe.h
    bstraux.h
    bstrlib.h
    bstrwrap.h
)

set (SRCS
    bsafe.c
    bstraux.c
    bstrlib.c
)

add_library(bstrlib ${SRCS})
add_library(bstrlib-cpp bstrwrap.cpp)

target_link_libraries(bstrlib-cpp PUBLIC bstrlib)

install(TARGETS bstrlib bstrlib-cpp EXPORT bstrlibTargets )
install(EXPORT bstrlibTargets
    NAMESPACE bstrlib::
    DESTINATION share/bstrlib
)

install( FILES ${HEADERS} DESTINATION include/bstrlib )