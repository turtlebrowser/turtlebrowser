# Windows

## Build Qt
* Up to date Qt: See the chromium_update repo
* Otherwise, download the regular tar and build it
```
curl -sSL https://download.qt.io/archive/qt/5.15/5.15.2/single/qt-everywhere-src-5.15.2.tar.xz | tar xJf -
```
The paths below assume it is configured and built in __C:\Code\qt5-build\\__

The scripts in chromium_update might be useful for figuring out how to build.

## CMake options
```
-DUSE_CONAN=OFF -DCMAKE_INSTALL_PREFIX="C:\Code\turtle_install" -DQTBASE_SOURCE="C:/Code/qt-everywhere-src-5.15.2/qtbase"
```

## Environment
```
CMAKE_PREFIX_PATH=C:\Code\qt5-build\qtbase\lib\cmake
```

## Global environment
Put this in the system path
```
C:\Code\qt5-build\qtbase\bin
```

## Runtime
* Add install step
* Run the binary from the install folder

# Linux

## Build Qt
* Up to date Qt: See the chromium_update repo
* Otherwise, download the regular tar and build it
```
curl -sSL https://download.qt.io/archive/qt/5.15/5.15.2/single/qt-everywhere-src-5.15.2.tar.xz | tar xJf -
```
The paths below assume it is configured and built in __/Code/qt5-build__

The scripts in chromium_update might be useful for figuring out how to build.

## CMake options
```
-DUSE_CONAN=OFF -DCMAKE_INSTALL_PREFIX="/Code/turtle_install" -DQTBASE_SOURCE="/Code/qt-everywhere-src-5.15.2/qtbase"
```

## Environment
```
CMAKE_PREFIX_PATH=/Code/qt5-build/qtbase/lib/cmake
```
