set(CPACK_PACKAGE_VENDOR "TurtleSec AS")

set(CPACK_PACKAGE_INSTALL_DIRECTORY ${PROJECT_NAME})
set(CPACK_VERBATIM_VARIABLES YES)
set(CPACK_PACKAGE_EXECUTABLES TurtleBrowser "TurtleBrowser")
set(CPACK_STRIP_FILES FALSE CACHE BOOL "Remove nonessential information from executable binary")

set(CPACK_OUTPUT_CONFIG_FILE "${CMAKE_BINARY_DIR}/CPackConfig.cmake")
set(CPACK_SOURCE_OUTPUT_CONFIG_FILE "${CMAKE_BINARY_DIR}/CPackSourceConfig.cmake")

# Input to GUI installers
set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_LIST_DIR}/Description.txt")
set(CPACK_RESOURCE_FILE_WELCOME "${CMAKE_CURRENT_LIST_DIR}/Welcome.txt")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_LIST_DIR}/License.txt")
set(CPACK_RESOURCE_FILE_README "${CMAKE_CURRENT_LIST_DIR}/Readme.txt")
#set(CPACK_PACKAGE_ICON)

# Configure CPack Generators per platform
if (WIN32)
    set(PLATFOM_CPACK_GENERATORS "ZIP;WIX")
elseif (APPLE)
    set(PLATFOM_CPACK_GENERATORS "TGZ;productbuild")
elseif (CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(PLATFOM_CPACK_GENERATORS "TGZ;DEB")
else ()
    set(PLATFOM_CPACK_GENERATORS "TGZ")
endif ()

# Set the CPack Generators
set(CPACK_GENERATOR ${PLATFOM_CPACK_GENERATORS} CACHE STRING "List of CPack generators to use.")

# Creating source package
# All build generators
# cpack -G TGZ --config CPackSourceConfig.cmake
# Makefile and Ninja build generators only
# cmake --build . --target package_source

set(CPACK_SOURCE_IGNORE_FILES
    /\\.git/
    \\.swp
    \\.orig
    /CMakeLists\\.txt\\.user
    /privateDir/)

set(CPACK_COMPONENTS_GROUPING ALL_COMPONENTS_IN_ONE)
set(CPACK_COMPONENTS_ALL turtlebrowser)

unset(CPACK_INSTALL_CMAKE_PROJECTS)

list(APPEND CPACK_INSTALL_CMAKE_PROJECTS
     ${CMAKE_BINARY_DIR} ${CMAKE_PROJECT_NAME} ALL /)

## Qt Installer Framework (IFW)
#
#if(WIN32)
#    set(CPACK_IFW_PACKAGE_ICON ${CMAKE_CURRENT_LIST_DIR}/Logo.ico)
#elseif(APPLE)
#    set(CPACK_IFW_PACKAGE_ICON ${CMAKE_CURRENT_LIST_DIR}/Logo.icns)
#endif()
#set(CPACK_IFW_PACKAGE_WINDOW_ICON ${CMAKE_CURRENT_LIST_DIR}/Logo.png)
#set(CPACK_IFW_PACKAGE_LOGO        ${CMAKE_CURRENT_LIST_DIR}/Logo.png)
#
#set(CPACK_IFW_PACKAGE_MAINTENANCE_TOOL_NAME ${PROJECT_NAME}_MaintenanceTool)
#set(CPACK_IFW_PACKAGE_MAINTENANCE_TOOL_INI_FILE
#        ${CPACK_IFW_PACKAGE_MAINTENANCE_TOOL_NAME}.ini
#)

# Debian/Ubuntu packaging
set(CPACK_DEBIAN_FILE_NAME "DEB-DEFAULT" CACHE STRING "Package file name.")
# TODO: This is not going to work, we need to ship our own QtWebEngine
set(CPACK_DEBIAN_PACKAGE_DEPENDS
    "qt5-default, libqt5quick5, libqt5svg5, libqt5widgets5, libqt5webengine5" CACHE STRING
    "Dependencies of the TurtleBrowser package. Default assumes Debian 10.4 'buster'")
set(CPACK_DEBIAN_PACKAGE_HOMEPAGE "https://github.com/turtlebrowser/turtlebrowser")
set(CPACK_DEBIAN_PACKAGE_RELEASE "" CACHE STRING
    "The Debian package release - Debian revision number.")
set(CPACK_DEBIAN_PACKAGE_SECTION "web" CACHE STRING
    "Set Section control field e.g. admin, devel, doc, ...")

set(CPACK_DEBIAN_PACKAGE_MAINTAINER "patricia@turtlesec.no" CACHE STRING
    "Debian package requires a maintainer for a package.")
mark_as_advanced(
        CPACK_DEBIAN_FILE_NAME
        CPACK_DEBIAN_PACKAGE_DEPENDS
        CPACK_DEBIAN_PACKAGE_MAINTAINER
        CPACK_DEBIAN_PACKAGE_RELEASE
        CPACK_DEBIAN_PACKAGE_SECTION)

# Red Hat/CentOS/Fedora packaging
set(CPACK_RPM_FILE_NAME "RPM-DEFAULT" CACHE STRING "Package file name.")
set(CPACK_RPM_PACKAGE_GROUP "unknown" CACHE STRING "The RPM package group.")
set(CPACK_RPM_PACKAGE_LICENSE "MIT")
set(CPACK_RPM_PACKAGE_RELEASE "" CACHE STRING "The RPM package release.")
# TODO: This is not going to work, we need to ship our own QtWebEngine
set(CPACK_RPM_PACKAGE_REQUIRES
    "qt5-qtbase, qt5-qtdeclarative, qt5-qtwebengine, qt5-qtsvg" CACHE STRING
    "Dependencies of the TurtleBrowser package. Default assumes Fedora 22")
set(CPACK_RPM_PACKAGE_URL "https://github.com/turtlebrowser/turtlebrowser")

get_cmake_property(CPACK_VARIABLES VARIABLES)
list(FILTER CPACK_VARIABLES INCLUDE REGEX "CPACK_.*")
list(FILTER CPACK_VARIABLES INCLUDE REGEX ".*SOURCE.*")

set(CPACK_RPM_SOURCE_PKG_BUILD_PARAMS "" CACHE STRING
    "Additional command-line parameters provided to cmake executable.")

foreach(variable IN LISTS CPACK_VARIABLES)
    list(APPEND CPACK_RPM_SOURCE_PKG_BUILD_PARAMS "${variable}")
endforeach()

mark_as_advanced(
        CPACK_RPM_FILE_NAME
        CPACK_RPM_PACKAGE_GROUP
        CPACK_RPM_PACKAGE_RELEASE
        CPACK_RPM_PACKAGE_REQUIRES)

include(CPack)

## (IFW) Qt Installer Framework
#include(CPackIFW)

# Define components and component groups...

#cpack_add_component(turtlebrowser
#                    DISPLAY_NAME "TurtleBrowser"
#                    DESCRIPTION "Web browser based on Qt"
#                    )

## (IFW) Configure localization of strings
#cpack_ifw_configure_component(turtlebrowser
#        DISPLAY_NAME "TurtleBrowser"
#        DESCRIPTION en      "Web browser based on Qt"
#                    en_AU   "Web browser based on Qt"
#)

# (IFW) Upgrade server - GitHub ?
# cpack_configure_downloads(baseUrl
#         [ALL]
#         [ADD_REMOVE | NO_ADD_REMOVE]
#         [UPLOAD_DIRECTORY dir]
# )

# (IFW) Download other components? Widewine?
# cpack_ifw_add_repository(repoName
#        URL baseUrl
#        [DISPLAY_NAME displayName]
#        [DISABLED]
#        [USERNAME username]
#        [PASSWORD password]
# )