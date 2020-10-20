# Windows Developer Build Instructions (Work in Progress)

The primary purpose of these build instructions is to avoid having to build all of Qt including QtWebEngine.
To do this we will use the Conan Cache.

These instructions will assume use of GitBash.

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
