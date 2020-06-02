cmake_minimum_required(VERSION 3.10)
project(TurtleBrowser VERSION "0.1.2")
set(PROJECT "TurtleBrowser")
add_subdirectory(src)

if (CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    add_subdirectory(packaging)
endif ()
