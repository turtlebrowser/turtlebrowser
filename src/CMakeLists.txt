cmake_minimum_required(VERSION 3.10)

set(CMAKE_CXX_STANDARD 17)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)

# Download automatically, you can also just copy the conan.cmake file
if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
    message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
    file(DOWNLOAD "https://github.com/conan-io/cmake-conan/raw/v0.15/conan.cmake"
            "${CMAKE_BINARY_DIR}/conan.cmake")
endif()

include(${CMAKE_BINARY_DIR}/conan.cmake)
conan_add_remote(NAME bincrafters INDEX 1 URL https://api.bintray.com/conan/bincrafters/public-conan)
conan_cmake_run(CONANFILE ../conanfile.py BASIC_SETUP CMAKE_TARGETS BUILD missing)

# For running locally in CLion
if (NOT DEFINED ENV{CMAKE_PREFIX_PATH})
    file(COPY ${CMAKE_BINARY_DIR}/src/qt.conf DESTINATION ${CMAKE_BINARY_DIR}/src/bin/)
endif()

find_package(Qt5 COMPONENTS Core Gui Qml Quick Svg WebEngine Widgets Xml REQUIRED)
find_package(Qt5Test REQUIRED)

include_directories(${Qt5Widgets_INCLUDE_DIRS} ${QtQml_INCLUDE_DIRS})

add_definitions(${Qt5Widgets_DEFINITIONS} ${QtQml_DEFINITIONS} ${${Qt5Quick_DEFINITIONS}})

qt5_add_resources(QT_RESOURCES resources/resources.qrc)

if(NOT DEFINED HEADERS)
    file(GLOB HEADERS *.h)
endif()

if(NOT DEFINED SOURCES)
    file(GLOB SOURCES *.cpp)
endif()

source_group("Header Files" FILES ${HEADERS})
source_group("Source Files" FILES ${SOURCES})

if(APPLE)
    add_executable(${PROJECT} MACOSX_BUNDLE ${HEADERS} ${SOURCES} ${QT_RESOURCES})
else()
    add_executable(${PROJECT} ${HEADERS} ${SOURCES} ${QT_RESOURCES})
endif()

target_link_libraries(${PROJECT}
        Qt5::Core
        Qt5::Gui
        Qt5::Qml
        Qt5::Quick
        Qt5::Svg
        Qt5::WebEngine
        Qt5::Widgets
        Qt5::Xml)

if (CMAKE_SYSTEM_NAME STREQUAL "Linux")
    # Linux : Installs TurtleBrowser to CMAKE_INSTALL_PREFIX/bin
    install(TARGETS ${PROJECT} RUNTIME DESTINATION bin COMPONENT Runtime)
else ()
    # Windows : Installs TurtleBrowser.exe to CMAKE_INSTALL_PREFIX/bin
    # Mac     : Installs TurtleBrowser.app to CMAKE_INSTALL_PREFIX/
    INSTALL(TARGETS ${PROJECT}
            BUNDLE DESTINATION . COMPONENT Runtime
            RUNTIME DESTINATION bin COMPONENT Runtime)
endif ()
