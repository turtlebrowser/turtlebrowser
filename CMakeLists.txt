cmake_minimum_required(VERSION 3.10)

project(TurtleBrowser
        VERSION "0.1.2"
        DESCRIPTION "Web browser based on QtWebEngine (Chromium/Blink)"
        LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# By default, TurtleBrowser uses Conan to ensure its dependencies
# are up-to-date on the build system. If you have some other
# mechanism for doing so (e.g. packaging TurtleBrowser for
# a distribution) then set USE_CONAN OFF.
option(USE_CONAN "Use Conan package manager" ON)
option(UPDATE_CONAN "Update Conan Cache" OFF)
option(ENABLE_TS_RESCAN "Enable rescanning sources to update .ts files" OFF)
option(CHECK_IN_LICENSES "Generate the licenses for the target platform and copy them into the source tree" OFF)
        
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

add_subdirectory(src)
add_subdirectory(packaging)
