# Windows Developer Build Instructions (Work in Progress)

The primary purpose of these build instructions is to avoid having to build all of Qt including QtWebEngine.
To do this we will use the Conan Cache.

These instructions will assume use of GitBash.

## Get the Conan Cache with all the dependencies

The cache resides in c: because long file paths will cause issues.

~~~
cd c:
export CONAN_USER_HOME="c:/release"
export CONAN_USER_HOME_SHORT=${CONAN_USER_HOME}/short
git clone git@github.com:turtlebrowser/conan-cache-turtlebrowser.git $CONAN_USER_HOME
cd ${CONAN_USER_HOME}
git checkout host-Windows-target-Windows-windows-2019-master
git lfs pull
find .conan/ -name .conan_link -exec perl -pi -e 's=CONAN_USER_HOME_SHORT=$ENV{CONAN_USER_HOME_SHORT}=g' {} +
~~~

## Get TurtleBrowser and build it

Now let's get the TurtleBrowser source, this can reside anywhere, but here I will assume it's in a folder called Code in your user directory.

~~~
cd ~/Code
git clone git@github.com:turtlebrowser/turtlebrowser.git
cd turtlebrowser
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
cmake --build . --config Release -j 4
~~~

## Trouble shooting

Make sure the Conan configuration looks like this - see output from the first cmake command above.
~~~
Configuration:
[settings]
arch=x86_64
arch_build=x86_64
build_type=Release
compiler=Visual Studio
compiler.runtime=MD
compiler.version=16
os=Windows
os_build=Windows
[options]
[build_requires]
[env]
~~~
