# cmake_minimum_required(VERSION 3.10)
#[[
You have already established the minimum version before the declaring your project. This
information need not be repeated in every file.
]]

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

#if(NOT DEFINED HEADERS)
#    file(GLOB HEADERS *.h)
#endif()
#
#if(NOT DEFINED SOURCES)
#    file(GLOB SOURCES *.cpp)
#endif()
#[[
Unless you expect the HEADERS and SOURCES variables to be specified by the user invoking CMake
(which would be very unusual), the HEADERS variable will never be defined at this point. The
file(GLOB ...) command populates a directory variable rather than a cache variable, and as such,
the variable will not persist between CMake invocations and the condition of this if statement
should always be false.

The question of the conditional aside, the collection of source files using a globbing expression
is generally not recommended. From the CMake documentation:

    We do not recommend using GLOB to collect a list of source files from your source tree. If no
    CMakeLists.txt file changes when a source is added or removed then the generated build system
    cannot know when to ask CMake to regenerate.

In other words, the globbing expression is only evaluated when is CMake generating a build system,
not when the resulting build system is executed. When using of globbing in this manner, developers
unfamiliar with CMake will often be surprised when a developer the build system does not recognize
new source files that have been added to a project.

That said, in CMake version 3.11, an argument called CONFIGURE_DEPENDS was added to file(GLOB ...)
that will reevaluate the glob expression at build time and update the build system definition
accordingly. This will accomplish what you are after albeit at the cost of requiring a more recent
CMake version and (a surprising amount of) extra build time.
]]

file(GLOB HEADERS *.h)
file(GLOB SOURCES *.cpp)

source_group("Header Files" FILES ${HEADERS})
source_group("Source Files" FILES ${SOURCES})

#if(APPLE)
#    add_executable(${PROJECT_NAME} MACOSX_BUNDLE ${HEADERS} ${SOURCES} ${QT_RESOURCES})
#else()
#    add_executable(${PROJECT_NAME} ${HEADERS} ${SOURCES} ${QT_RESOURCES})
#endif()
#[[
There is some repetition here that can be avoided. The MACOSX_BUNDLE argument to add_executable
merely sets the MACOSX_BUNDLE target property of the resulting target to TRUE. We can avoid
repeating the structure of our sources by either

1. setting the MACOSX_BUNDLE target property ourselves after the target is created using
   set_target_properties or
2. associating the sources for the executable after the target is created using target_sources.

Here I have opted for the former.
]]

add_executable(${PROJECT_NAME} ${HEADERS} ${SOURCES} ${QT_RESOURCES})

if(APPLE)
  set_target_properties(${PROJECT_NAME} PROPERTIES MACOSX_BUNDLE TRUE)
endif()

#[[
While it is legal to call to target_link_libraries without a linkage specified, this is largely for
backwards compatability with older versions of CMake. In new CMake code, prefer to specify a
linkage.
]]
target_link_libraries(${PROJECT_NAME} PRIVATE
        Qt5::Core
        Qt5::Gui
        Qt5::Qml
        Qt5::Quick
        Qt5::Svg
        Qt5::WebEngine
        Qt5::Widgets
        Qt5::Xml)

#[[
Software packagers appreciate a build system that allows them to customize the installation
structure without requiring modification of the build system specification. GNUInstallDirs is a
module distributed with CMake that establishes a number of cache variables (defaulted sensibly
based on the operating system) that packagers can use to do just that.
]]
include (GNUInstallDirs)

if (CMAKE_SYSTEM_NAME STREQUAL "Linux")
    # Linux : Installs TurtleBrowser to CMAKE_INSTALL_BINDIR
    install(TARGETS ${PROJECT_NAME}
            RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}" COMPONENT ${PROJECT_NAME}_Runtime)

    #[[
    Given the packaging subdirectory is shrouded to detect whether TurtleBrowser is the highest
    level CMake project, I suspect you are intending to support subproject composition. If this
    is the case, it is kind to make component names specific to your project. This provides a
    hook consumers of a packaged installation to select a subset of the total installation that
    they are interested in consuming.
    ]]
else ()
    # Windows : Installs TurtleBrowser.exe to CMAKE_INSTALL_PREFIX/bin
    # Mac     : Installs TurtleBrowser.app to CMAKE_INSTALL_PREFIX/
    INSTALL(TARGETS ${PROJECT_NAME}
            BUNDLE DESTINATION . COMPONENT ${PROJECT_NAME}_Runtime
            RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}" COMPONENT ${PROJECT_NAME}_Runtime)
endif ()

#[[
At the moment, this project is not building or installing any dynamic libraries. This may change in
the future. In that case, handling the RPATH for users installing to locations aside from the system
root (e.g. '/opt/TurtleBrowser' or to their home directory) should be considered.

Uncomment the following section to accomodate RPath handling.
]]
#[===[
file(RELATIVE_PATH bin2lib "${CMAKE_INSTALL_FULL_BINDIR}" "${CMAKE_INSTALL_FULL_LIBDIR}")

set_property(TARGET ${PROJECT_NAME} APPEND PROPERTY INSTALL_RPATH
        $<$<PLATFORM_ID:Linux>:$ORIGIN/${bin2lib}>
        $<$<PLATFORM_ID:Darwin>:@loader_path>
        $<$<PLATFORM_ID:Darwin>:@loader_path/../Library/Frameworks>
        $<$<PLATFORM_ID:Darwin>:@loader_path/../Library/OpenSource>)

#[[
When users link to dynamic libraries installed to in non-traditional locations (usually located
using find_package), they are often encounter a runtime linker error after installation. By
default, CMake strips build-time linker paths from the binary as part of the installation process.
While this is probably to appropriate default, there are occassions when the opposite behavior is
desirable (e.g. installing on the machine used to build the artifact).

We publish a CMake variable to the cache to make this behavior a bit more discoverable by
end-users.
]]
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH FALSE CACHE BOOL "\
Append to the runtime search path (rpath) of installed binaries any directories outside the \
project that are in the linker search path or contain linked library files.")
#]]
]===]

#[[
Here we set a number of variables to influence how the installer groups and labels components.
These variables are written to the cache for three reasons:

1. The TurtleBrowser CMake seems to support subproject composition. Using cache variables allows
   this information to propagate to the enclosing project.
2. It allows the client (whether a parent project or the developer invoking the build system) to
   modify these names to conventions to their liking or appropriate for their use case.
3. The packaging logic is not in a nested directory scope, but rather a sibling scope. Using cache
   variables allows this information to propagate to the enclosing project.
]]
set(CPACK_COMPONENT_TURTLEBROWSER_RUNTIME_GROUP "TurtleBrowser" CACHE INTERNAL "")
set(CPACK_COMPONENT_TURTLEBROWSER_RUNTIME_DISPLAY_NAME "Runtime Components" CACHE INTERNAL "")
set(CPACK_COMPONENT_TURTLEBROWSER_RUNTIME_DESCRIPTION
        "Executable and dynamic libraries" CACHE INTERNAL "")

mark_as_advanced(
        CPACK_COMPONENT_TURTLEBROWSER_RUNTIME_GROUP
        CPACK_COMPONENT_TURTLEBROWSER_RUNTIME_DISPLAY_NAME
        CPACK_COMPONENT_TURTLEBROWSER_RUNTIME_DESCRIPTION)