# FreeBSD Developer Build Instructions (Work in Progress)

**NOTE: It does not build - these instructions will only get you to the start of the Qt build**

[//]: # (Prerequisite: SSH key has been added to your accout)

## Setup of machine

~~~ bash
bash
mkdir ~/Code
cd ~/Code
pkg install -y git
git clone https://github.com/turtlebrowser/turtlebrowser.git
pkg install -y cmake python2 python3 py37-pip py37-sqlite3 sudo gmake perl5 pkgconf libunwind bash
~~~


# Build locally

~~~ bash
pip install conan
alias python=python2

export CONAN_MAKE_PROGRAM="gmake"
cd ~/Code/turtlebrowser
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++
cmake --build . --config Release
~~~

# Notes

Might be needed

~~~
if(CMAKE_SYSTEM_NAME STREQUAL FreeBSD)
  # required for libunwind
  include_directories("/usr/local/include/")
endif()
~~~

[//]: # (git clone https://github.com/turtlebrowser/conan-cache.git)
[//]: # (git config --global user.name "Your Name")
[//]: # (git config --global user.email "your_email_address@example.com")
[//]: # (mkdir /Code)
[//]: # (cd /Code)
[//]: # (export CONAN_USER_HOME="/Code/release")
[//]: # (export CONAN_USER_HOME_SHORT=${CONAN_USER_HOME}/short)
[//]: # (pkg install -y git-lfs)
[//]: # (git lfs install)
[//]: # (git clone https://github.com/turtlebrowser/conan-cache-turtlebrowser.git $CONAN_USER_HOME)
