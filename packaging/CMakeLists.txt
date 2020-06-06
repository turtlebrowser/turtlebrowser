set(CPACK_PACKAGE_VENDOR "TurtleSec AS")

set(CPACK_PACKAGE_INSTALL_DIRECTORY ${PROJECT_NAME})
set(CPACK_VERBATIM_VARIABLES YES)
set(CPACK_PACKAGE_EXECUTABLES TurtleBrowser "TurtleBrowser" )
set(CPACK_STRIP_FILES FALSE CACHE BOOL "Remove nonessential information from executable binary")

set(CPACK_OUTPUT_CONFIG_FILE "${CMAKE_BINARY_DIR}/CPackConfig.cmake")
set(CPACK_SOURCE_OUTPUT_CONFIG_FILE "${CMAKE_BINARY_DIR}/CPackSourceConfig.cmake")

# Input to GUI installers
set(CPACK_PACKAGE_DESCRIPTION_FILE ${CMAKE_CURRENT_LIST_DIR}/Description.txt)
set(CPACK_RESOURCE_FILE_WELCOME ${CMAKE_CURRENT_LIST_DIR}/Welcome.txt)
set(CPACK_RESOURCE_FILE_LICENSE ${CMAKE_CURRENT_LIST_DIR}/License.txt)
set(CPACK_RESOURCE_FILE_README ${CMAKE_CURRENT_LIST_DIR}/Readme.txt)
#set(CPACK_PACKAGE_ICON)

if (WIN32)
    set(CPACK_GENERATOR ZIP WIX)
elseif (APPLE)
    set(CPACK_GENERATOR TGZ productbuild)
elseif (CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(CPACK_GENERATOR TGZ DEB)
else ()
    set(CPACK_GENERATOR TGZ)
endif ()

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
        /privateDir/
)

set(CPACK_COMPONENTS_GROUPING ALL_COMPONENTS_IN_ONE)
set(CPACK_COMPONENTS_ALL turtlebrowser)

unset(CPACK_INSTALL_CMAKE_PROJECTS)

list(APPEND CPACK_INSTALL_CMAKE_PROJECTS
        ${CMAKE_BINARY_DIR} ${CMAKE_PROJECT_NAME} ALL /
)

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

set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Patricia Aas")
set(CPACK_DEBIAN_TURTLEBROWSER_PACKAGE_NAME turtlebrowser)
set(CPACK_DEBIAN_TURTLEBROWSER_FILE_NAME DEB-DEFAULT)
set(CPACK_DEBIAN_TURTLEBROWSER_PACKAGE_SHLIBDEPS TRUE)
#set(CPACK_DEBIAN_TURTLEBROWSER_PACKAGE_DEPENDS)
set(CPACK_DEBIAN_TURTLEBROWSER_PACKAGE_GENERATE_SHLIBS TRUE)

include(CPack)

## (IFW) Qt Installer Framework
#include(CPackIFW)

# Define components and component groups...

cpack_add_component(turtlebrowser
        DISPLAY_NAME "TurtleBrowser"
        DESCRIPTION "Web browser based on Qt"
)

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