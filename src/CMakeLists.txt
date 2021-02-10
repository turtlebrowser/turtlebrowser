# SPDX-FileCopyrightText: (c) 2018 TurtleSec AS
# SPDX-License-Identifier: MIT

if (APPLE)
    set(TARGET_OS_NAME "macos")
    set(LICENSE_QRC resources/licenses/linux/linux_licenses.qrc)
elseif (MSVC)
    set(TARGET_OS_NAME "windows")
    set(LICENSE_QRC resources/licenses/windows/windows_licenses.qrc)
elseif (CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(TARGET_OS_NAME "linux")
    set(LICENSE_QRC resources/licenses/linux/linux_licenses.qrc)
endif ()

if (CHECK_IN_LICENSES)
    set(LICENSE_QRC "")
endif ()

if (USE_CONAN)
    # Download automatically, you can also just copy the conan.cmake file
    if (NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
        message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
        file(DOWNLOAD "https://github.com/conan-io/cmake-conan/raw/v0.15/conan.cmake"
            "${CMAKE_BINARY_DIR}/conan.cmake")
    endif ()

    include(${CMAKE_BINARY_DIR}/conan.cmake)
    conan_add_remote(NAME bincrafters INDEX 1 URL https://api.bintray.com/conan/bincrafters/public-conan)

    if (UPDATE_CONAN)
        conan_cmake_run(CONANFILE ../conanfile.py BASIC_SETUP CMAKE_TARGETS UPDATE BUILD outdated)
    else ()
        conan_cmake_run(CONANFILE ../conanfile.py BASIC_SETUP CMAKE_TARGETS BUILD missing)
    endif ()

    # For running locally in CLion
    if (NOT DEFINED ENV{CMAKE_PREFIX_PATH})
        file(COPY ${CMAKE_BINARY_DIR}/src/qt.conf DESTINATION ${CMAKE_BINARY_DIR}/src/bin/)
    endif ()
else ()
    message(STATUS "Conan package manager is switched off.")
endif ()

find_package(Qt5 COMPONENTS Core Gui Qml Quick Svg WebEngine Widgets Xml REQUIRED)
find_package(Qt5Test REQUIRED)
find_package(Qt5 COMPONENTS LinguistTools REQUIRED)

include_directories(${Qt5Widgets_INCLUDE_DIRS} ${QtQml_INCLUDE_DIRS})

add_definitions(${Qt5Widgets_DEFINITIONS} ${QtQml_DEFINITIONS} ${${Qt5Quick_DEFINITIONS}})

qt5_add_resources(QT_RESOURCES resources/resources.qrc ${LICENSE_QRC})

set(tsFiles
    ${PROJECT_NAME}_de_AT.ts
    ${PROJECT_NAME}_de_DE.ts
    ${PROJECT_NAME}_ja.ts)

if (ENABLE_TS_RESCAN)
    # Need to generate the ts files using lupdate
    qt5_create_translation(qmFiles ${CMAKE_CURRENT_LIST_DIR} ${tsFiles})
else ()
    # Need to the ts files to qm files using lrelease
    qt5_add_translation(qmFiles ${tsFiles})
endif ()

file(GLOB_RECURSE HEADERS *.h)
file(GLOB_RECURSE SOURCES *.cpp)

source_group("Header Files" FILES ${HEADERS})
source_group("Source Files" FILES ${SOURCES})

add_executable(${PROJECT_NAME} MACOSX_BUNDLE WIN32 ${HEADERS} ${SOURCES} ${QT_RESOURCES} ${qmFiles})

target_link_libraries(${PROJECT_NAME}
                      Qt5::Core
                      Qt5::Gui
                      Qt5::Qml
                      Qt5::Quick
                      Qt5::Svg
                      Qt5::WebEngine
                      Qt5::Widgets
                      Qt5::Xml)

set(qmlFiles ${CMAKE_SOURCE_DIR}/src/resources/qml/)

if (APPLE)
    set_target_properties(${PROJECT_NAME} PROPERTIES INSTALL_RPATH @executable_path/../Frameworks)
    set_source_files_properties(${qmFiles} PROPERTIES
                                MACOSX_PACKAGE_LOCATION "translations")
endif ()

set(CMAKE_INSTALL_DEFAULT_COMPONENT_NAME turtlebrowser)

# Use the default install directories
include(GNUInstallDirs)
set(CMAKE_INSTALL_DOCDIR ${CMAKE_INSTALL_DATAROOTDIR}/doc/${PROJECT_NAME})

# Maybe install(TARGETS ${PROJECT_NAME}) is sufficient with GNUInstallDirs and CMAKE_INSTALL_DEFAULT_COMPONENT_NAME?
install(TARGETS ${PROJECT_NAME}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        BUNDLE DESTINATION .)

# Get the Qt bin directory
get_target_property(mocExe Qt5::moc IMPORTED_LOCATION)
get_filename_component(qtBinDir "${mocExe}" DIRECTORY)
get_filename_component(qtBaseDir "${qtBinDir}" DIRECTORY)

# Need to figure out how to do this on Mac
if (MSVC OR CMAKE_SYSTEM_NAME STREQUAL "Linux")
    # Configure the qt.conf
    set(qtConfPrefix ${qtBaseDir})
    set(qtConfEffectiveSourcePaths ${QTBASE_SOURCE})
    if (MSVC)
        set(qtConfTargetSpec win32-clang-msvc)
        set(qtConfHostSpec win32-clang-msvc)
    elseif (CMAKE_SYSTEM_NAME STREQUAL "Linux")
        set(qtConfTargetSpec linux-clang-libc++)
        set(qtConfHostSpec linux-clang-libc++)
    endif ()
    configure_file(qt.conf.in qt.conf @ONLY)

    # Install the qt.conf
    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/qt.conf DESTINATION ${CMAKE_INSTALL_BINDIR})

    # Configure the licenses install location
    if (MSVC)
        set(ROOT_INSTALL_DIR ${CMAKE_INSTALL_BINDIR}/..)
    elseif (CMAKE_SYSTEM_NAME STREQUAL "Linux")
        set(ROOT_INSTALL_DIR ${CMAKE_INSTALL_BINDIR})
    endif ()
endif ()

if (CHECK_IN_LICENSES)
    # Install the licenses
    install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/licenses DESTINATION ${CMAKE_SOURCE_DIR}/src/resources/licenses/${TARGET_OS_NAME}/)
endif ()

# Make a runnable bundle for linux
if (CMAKE_SYSTEM_NAME STREQUAL "Linux")
    install(DIRECTORY
            ${CMAKE_CURRENT_BINARY_DIR}/lib
            ${CMAKE_CURRENT_BINARY_DIR}/plugins
            ${CMAKE_CURRENT_BINARY_DIR}/qml
            ${CMAKE_CURRENT_BINARY_DIR}/resources
            ${CMAKE_CURRENT_BINARY_DIR}/translations
            DESTINATION ${CMAKE_INSTALL_BINDIR})
    install(FILES
            ${CMAKE_CURRENT_BINARY_DIR}/libexec/QtWebEngineProcess
            DESTINATION ${CMAKE_INSTALL_BINDIR}/libexec
            PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ GROUP_EXECUTE GROUP_READ WORLD_READ WORLD_EXECUTE)
endif ()

if (APPLE)
    # Merge language files
    find_program(LCONVERT_EXECUTABLE lconvert
                 PATHS "${qtBinDir}"
                 NO_DEFAULT_PATH)
    find_program(DEPLOYQT_EXECUTABLE macdeployqt
                 PATHS "${qtBinDir}"
                 NO_DEFAULT_PATH)
    # macdeployqt TurtleBrowser.app -dmg -qmldir=${{ github.workspace }}/src/resources/qml/
    set(DEPLOY_OPTIONS
        ${PROJECT_NAME}.app
        -verbose=2
        -dmg
        -qmldir=${qmlFiles}) # "-codesign=Apple Development"
    set(TRANSLATION_DIR TurtleBrowser.app/Contents/translations)
endif ()

if (MSVC)
    find_program(DEPLOYQT_EXECUTABLE windeployqt
                 PATHS "${qtBinDir}"
                 NO_DEFAULT_PATH)
    set(DEPLOY_OPTIONS
        bin/${PROJECT_NAME}.exe
        --dir .
        --libdir bin
        --plugindir plugins
        --qmldir ${qmlFiles})
    set(TRANSLATION_DIR translations)
endif ()

# androiddeployqt ???

if (APPLE OR MSVC)
    configure_file(deployapp.cmake.in deployapp.cmake @ONLY)
    install(SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/deployapp.cmake)
endif ()
