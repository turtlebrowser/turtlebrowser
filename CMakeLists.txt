cmake_minimum_required(VERSION 3.10)
#[[
Are you supporting development on a Linux distribution that only provides CMake 3.10 through its
package manager? I generally recommend setting the minimum to version 3.13 or later, if you can
swing it.
]]


project(TurtleBrowser
  VERSION "0.1.2"
  DESCRIPTION "Web browser based on QtWebEngine (Chromium/Blink)"
  LANGUAGES CXX)
#[[
Adding a DESCRIPTION argument to the project command establishes a few directory-scope and cache
variables that serve as a default brief description for several things, including CPack.

Specifying a language argument

1. influences the environment introspection done by CMake during initial confiuration
2. explicitly documents the projects languages for developers interested in and considering
   contributing to your project

By default, CMake assumes the project languages are C and C++, and will search the environment for
a corresponding toolchain during the initial configuration of a binary tree. You can save
developers some time by telling CMake to only worry about C++.
]]

# set(PROJECT "TurtleBrowser")
#[[
The project command in cmake already establishes a variable called PROJECT_NAME. Using idiomatic
variables will help contributors more readily recognize what the configuration is doing.
Personally, I tend to think this using this sort of indirection does not buy much and makes the
configuration file more difficult to read.  That said, tastes vary, and the practice is not all
that uncommon.
]]

add_subdirectory(src)

if (CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    add_subdirectory(packaging)
endif ()
