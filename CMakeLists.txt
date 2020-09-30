cmake_minimum_required(VERSION 3.10)

project(TurtleBrowser
        VERSION "0.1.2"
        DESCRIPTION "Web browser based on QtWebEngine (Chromium/Blink)"
        LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

option(UPDATE_CONAN "Update Conan Cache" OFF)
option(ENABLE_TS_RESCAN "Enable rescanning sources to update .ts files" OFF)
option(CHECK_IN_LICENSES "Generate the licenses for the target platform and copy them into the source tree" OFF)
        
add_subdirectory(src)
add_subdirectory(packaging)
