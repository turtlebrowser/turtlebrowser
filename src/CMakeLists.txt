cmake_minimum_required(VERSION 3.14)

set(CMAKE_CXX_STANDARD 17)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

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
find_package(Qt5 COMPONENTS LinguistTools REQUIRED)

include_directories(${Qt5Widgets_INCLUDE_DIRS} ${QtQml_INCLUDE_DIRS})

add_definitions(${Qt5Widgets_DEFINITIONS} ${QtQml_DEFINITIONS} ${${Qt5Quick_DEFINITIONS}})

qt5_add_resources(QT_RESOURCES resources/resources.qrc)

set(tsFiles
    ${PROJECT}_de_AT.ts
    ${PROJECT}_de_DE.ts
    ${PROJECT}_ja.ts)

option(ENABLE_TS_RESCAN "Enable rescanning sources to update .ts files" OFF)

if(ENABLE_TS_RESCAN)
    # Need to generate the ts files using lupdate
    qt5_create_translation(qmFiles ${CMAKE_CURRENT_LIST_DIR} ${tsFiles})
else()
    # Need to the ts files to qm files using lrelease
    qt5_add_translation(qmFiles ${tsFiles})
endif()

if(NOT DEFINED HEADERS)
    file(GLOB HEADERS *.h)
endif()

if(NOT DEFINED SOURCES)
    file(GLOB SOURCES *.cpp)
endif()

source_group("Header Files" FILES ${HEADERS})
source_group("Source Files" FILES ${SOURCES})

add_executable(${PROJECT} MACOSX_BUNDLE WIN32 ${HEADERS} ${SOURCES} ${QT_RESOURCES} ${qmFiles})

target_link_libraries(${PROJECT}
        Qt5::Core
        Qt5::Gui
        Qt5::Qml
        Qt5::Quick
        Qt5::Svg
        Qt5::WebEngine
        Qt5::Widgets
        Qt5::Xml)

set(qmFiles ${CMAKE_SOURCE_DIR}/src/resources/qml/)

if (APPLE)
    set_target_properties(${PROJECT} PROPERTIES INSTALL_RPATH @executable_path/../Frameworks)
    set_source_files_properties(${qmFiles} PROPERTIES
                                MACOSX_PACKAGE_LOCATION "translations")
endif ()

set(CMAKE_INSTALL_DEFAULT_COMPONENT_NAME turtlebrowser)

include(GNUInstallDirs)
set(CMAKE_INSTALL_DOCDIR ${CMAKE_INSTALL_DATAROOTDIR}/doc/${PROJECT})

# Maybe install(TARGETS ${PROJECT}) is sufficient with GNUInstallDirs and CMAKE_INSTALL_DEFAULT_COMPONENT_NAME?
install(TARGETS ${PROJECT}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        BUNDLE DESTINATION .)

# Set up the qt.conf
set(qtConfPrefix ..)
set(qtConfQml2Imports .)
set(qtConfLibraryExecutables .)
configure_file(qt.conf.in qt.conf @ONLY)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/qt.conf DESTINATION ${CMAKE_INSTALL_BINDIR})

# Get the Qt bin directory
get_target_property(mocExe Qt5::moc IMPORTED_LOCATION)
get_filename_component(qtBinDir "${mocExe}" DIRECTORY)

if (APPLE)
    # Merge language files
    find_program(LCONVERT_EXECUTABLE lconvert
                 PATHS "${qtBinDir}"
                 NO_DEFAULT_PATH)
    find_program(DEPLOYQT_EXECUTABLE macdeployqt
            PATHS "${qtBinDir}"
            NO_DEFAULT_PATH)
    set(DEPLOY_OPTIONS [[${PROJECT}.app -verbose=2 -dmg -qmldir=${qmFiles}]])
#    set(DEPLOY_OPTIONS [[${PROJECT}.app -verbose=2 "-codesign=Apple Development"]])
    set(TRANSLATION_DIR MyQtApp.app/Contents/translations)
endif()

if (WIN32)
    find_program(DEPLOYQT_EXECUTABLE windeployqt
                 PATHS "${qtBinDir}"
                 NO_DEFAULT_PATH)
    set(DEPLOY_OPTIONS
        bin/${PROJECT}.exe
        --dir .
        --libdir bin
        --plugindir plugins
        --qmldir ${qmFiles})
    set(TRANSLATION_DIR translations)
endif ()

# androiddeployqt ???

if (APPLE OR WIN32)
    configure_file(deployapp.cmake.in deployapp.cmake @ONLY)
    install(SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/deployapp.cmake)
endif ()
