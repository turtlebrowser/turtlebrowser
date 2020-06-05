#set(CPACK_PACKAGE_NAME "TurtleBrowser")
#[[
If CPACK_PACKAGE_NAME is unspecified, CPack falls back to the PROJECT_NAME variable, which is
established by the project command. Given these values are intended to be the same for this
project, best not to repeat it and introduce the possibility of inconsistent values.
]]
# set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Web browser based on QtWebEngine (Chromium/Blink)")
#[[
If CPACK_PACKAGE_DESCRIPTION is unspecified, CPack falls back to the PROJECT_DESCRIPTION variable,
which is established by the project command when a DESCRIPTION argument is provided. Given these
values are intended to be the same for this project, best not to repeat it and introduce the
possibility of inconsistent values.
]]

set(CPACK_PACKAGE_VENDOR "TurtleSec AS")

#[[
In CMake version 3.12 or later, the CPack version variables are deduced based on the corresponding
CMAKE_PROJECT_VERSION_* variables. Given packaging is only considered when TurleBrowser is the
highest level CMake project, this default is appropriate.
]]
if(CMAKE_VERSION VERSION_LESS "3.12")
  set(CPACK_PACKAGE_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
  set(CPACK_PACKAGE_VERSION_MINOR ${PROJECT_VERSION_MINOR})
  set(CPACK_PACKAGE_VERSION_PATCH ${PROJECT_VERSION_PATCH})
endif()

set(CPACK_PACKAGE_INSTALL_DIRECTORY ${PROJECT_NAME})
set(CPACK_VERBATIM_VARIABLES YES)
set(CPACK_PACKAGE_EXECUTABLES TurtleBrowser "Turtle Browser" )
set(CPACK_STRIP_FILES FALSE CACHE BOOL "Remove nonessential information from executable binary")

#[[
It is unusual to setup packaging in a subdirectory this way. In order to ensure cpack may be
invoked from the root directory of the binary tree, we override the output cpack configuration file
path.
]]
set(CPACK_OUTPUT_CONFIG_FILE "${CMAKE_BINARY_DIR}/CPackConfig.cmake")
set(CPACK_SOURCE_OUTPUT_CONFIG_FILE "${CMAKE_BINARY_DIR}/CPackSourceConfig.cmake")

# Input to GUI installers
#[[
Prefer to quote absolute paths derived from CMake variables. Absolute paths have the potential to
contain whitespace. A line in a CMake file is evaluated by repeated evaluation and application. As
a result, when an application step substitutes the value of variable, if that value contained
whitespace, it will be consider multiple tokens (and hence, multiple arguments) in subsequent
evaluation passes.
]]
set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_LIST_DIR}/Description.txt")
set(CPACK_RESOURCE_FILE_WELCOME "${CMAKE_CURRENT_LIST_DIR}/Welcome.txt")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_LIST_DIR}/License.txt")
set(CPACK_RESOURCE_FILE_README "${CMAKE_CURRENT_LIST_DIR}/Readme.txt")

#[[
It is maybe a little unkind to assume an RPM-based distribution for Linux, but perhaps you have a
particular client in mind. In any case, by making these values cache variables, we provide a hook
for a user invoking CMake to overwrite these defaults. A user may also overwrite this default when
invoking CPack using the -G argument, but familiarity with CPack is (in my experience) much less
commonplace than familiarity with CMake.
]]

if (WIN32)
    set(CPACK_GENERATOR ZIP WIX CACHE STRING "List of CPack generators to use.")
elseif (APPLE)
    set(CPACK_GENERATOR TGZ productbuild CACHE STRING "List of CPack generators to use.")
elseif (CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(CPACK_GENERATOR TGZ RPM CACHE STRING "List of CPack generators to use.")
else ()
    set(CPACK_GENERATOR TGZ CACHE STRING "List of CPack generators to use.")
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
        /privateDir/)

set(CPACK_COMPONENTS_GROUPING ALL_COMPONENTS_IN_ONE)
set(CPACK_COMPONENTS_ALL turtlebrowser)

unset(CPACK_INSTALL_CMAKE_PROJECTS)

#[[
As the project is defined today, this 4-tuple was redundant; this is the default behavior.
]]
#list(APPEND CPACK_INSTALL_CMAKE_PROJECTS
#        ${CMAKE_BINARY_DIR} ${CMAKE_PROJECT_NAME} ALL /)

# Qt Installer Framework (IFW)

if(WIN32)
    set(CPACK_IFW_PACKAGE_ICON ${CMAKE_CURRENT_LIST_DIR}/Logo.ico)
elseif(APPLE)
    set(CPACK_IFW_PACKAGE_ICON ${CMAKE_CURRENT_LIST_DIR}/Logo.icns)
endif()
set(CPACK_IFW_PACKAGE_WINDOW_ICON ${CMAKE_CURRENT_LIST_DIR}/Logo.png)
set(CPACK_IFW_PACKAGE_LOGO        ${CMAKE_CURRENT_LIST_DIR}/Logo.png)

set(CPACK_IFW_PACKAGE_MAINTENANCE_TOOL_NAME ${PROJECT_NAME}_MaintenanceTool)
set(CPACK_IFW_PACKAGE_MAINTENANCE_TOOL_INI_FILE
        ${CPACK_IFW_PACKAGE_MAINTENANCE_TOOL_NAME}.ini
)

# Debian/Ubuntu packaging
#[[
Fields that can be expected to vary based on the target operating system (or that a packager may
otherwise wish to customize) are marked as cache, allowing the end user to specify their respective
value from during the command line invocation or from the CMake GUI.
]]
set(CPACK_DEBIAN_FILE_NAME "DEB-DEFAULT" CACHE STRING "Package file name.")
set(CPACK_DEBIAN_PACKAGE_DEPENDS 
         "qt5-default, libqt5quick5, libqt5svg5, libqt5widgets5, libqt5webengine5" CACHE STRING 
		 "Dependencies of the TurtleBrowser package. Default assumes Debian 10.4 'buster'")
set(CPACK_DEBIAN_PACKAGE_HOMEPAGE "https://github.com/turtlebrowser/turtlebrowser")
set(CPACK_DEBIAN_PACKAGE_RELEASE "" CACHE STRING
        "The Debian package release - Debian revision number.")
set(CPACK_DEBIAN_PACKAGE_SECTION "web" CACHE STRING
        "Set Section control field e.g. admin, devel, doc, ...")

#[[
For the moment, I have used the email associated with your consulting firm as a placeholder. I
recommend providing a default value, but in reality, this should probably be contact information for
the package maintainer rather than contact information for the developer (although those are
sometimes the same person).
]]
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "patricia@turtlesec.no" CACHE STRING
        "Debian package requires a maintainer for a package.")
mark_as_advanced(
        CPACK_DEBIAN_FILE_NAME
        CPACK_DEBIAN_PACKAGE_DEPENDS
		CPACK_DEBIAN_PACKAGE_MAINTAINER
        CPACK_DEBIAN_PACKAGE_RELEASE
        CPACK_DEBIAN_PACKAGE_SECTION)

# Red Hat/CentOS/Fedora packaging
#[[
Fields that can be expected to vary based on the target operating system (or that a packager may
otherwise wish to customize) are marked as cache, allowing the end user to specify their respective
value from during the command line invocation or from the CMake GUI.
]]
set(CPACK_RPM_FILE_NAME "RPM-DEFAULT" CACHE STRING "Package file name.")
set(CPACK_RPM_PACKAGE_GROUP "unknown" CACHE STRING "The RPM package group.")
set(CPACK_RPM_PACKAGE_LICENSE "MIT")
set(CPACK_RPM_PACKAGE_RELEASE "" CACHE STRING "The RPM package release.")
set(CPACK_RPM_PACKAGE_REQUIRES 
        "qt5-qtbase, qt5-qtdeclarative, qt5-qtwebengine, qt5-qtsvg" CACHE STRING
        "Dependencies of the TurtleBrowser package. Default assumes Fedora 22")
set(CPACK_RPM_PACKAGE_URL "https://github.com/turtlebrowser/turtlebrowser")

get_cmake_property(CPACK_VARIABLES VARIABLES)
list(FILTER CPACK_VARIABLES INCLUDE REGEX "CPACK_.*")
list(FILTER CPACK_VARIABLES INCLUDE REGEX ".*SOURCE.*")


set(CPACK_RPM_SOURCE_PKG_BUILD_PARAMS "" CACHE STRING
        "Additional command-line parameters provided to cmake executable.")

#[[
In addition to the user arguments, we record the value of any CPACK_RPM_* variables, such that when
the SRPM is used to generate an RPM, those user specifications will be honored.
]]
foreach(variable IN LISTS CPACK_VARIABLES)
  list(APPEND CPACK_RPM_SOURCE_PKG_BUILD_PARAMS "${variable}")
endforeach()

mark_as_advanced(
        CPACK_RPM_FILE_NAME
        CPACK_RPM_PACKAGE_GROUP
        CPACK_RPM_PACKAGE_RELEASE
        CPACK_RPM_PACKAGE_REQUIRES)

include(CPack)

# (IFW) Qt Installer Framework
include(CPackIFW)

#[[
The variables established by cpack_add_component are now set in the src/CMakeLists.txt file to
support subproject composition.
]]
# Define components and component groups...
#cpack_add_component(turtlebrowser
#        DISPLAY_NAME "TurtleBrowser"
#        DESCRIPTION "Web browser based on Qt")

# (IFW) Configure localization of strings
cpack_ifw_configure_component(turtlebrowser
        DISPLAY_NAME "TurtleBrowser"
        DESCRIPTION en      "Web browser based on Qt"
                    en_AU   "Web browser based on Qt"
)

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