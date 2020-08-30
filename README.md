# TurtleBrowser

![CI-Release](https://github.com/turtlebrowser/turtlebrowser/workflows/CI-Release/badge.svg)
![CI-Debug](https://github.com/turtlebrowser/turtlebrowser/workflows/CI-Debug/badge.svg)

# Introduction

TurtleBrowser is intended to become a full featured browser on at least Linux, MacOS, Windows, iOS and Android.

Once the basics are in place the goal is to create a browser that allows "installation" of Progressive Web Apps
as "native" sandboxed apps on desktop machines.

The foundation is: privacy, security, user is the customer, open source, data minimization

## Tricky bits

- WebView updating: The browser needs to follow the upstream webview releases, on platforms where
  this likely will be the platform webview this is not an issue (iOS and Android), but on desktop
  the QtWebEngine is probably too far behind Chromium/Blink to be considered secure. An update process
  needs to be in place that is "lightweight" enough to be preformed every month more or less.

- Sandboxing: It is unclear how well the Chromium sandbox works on the different platforms.

- Diverse browser space: Chromium/Blink is dominating the browser space and that makes a web
  designed by an ad company. Google needs the web, but their incentives might not always align
  with the end user. More competition would probably be healthier than what we have today. It would
  be good to try to support another WebView implementation (Servo or WebKit?)

## Qt WebView

The goal is to use Qt WebView as the abstraction for the webview, on iOS and Android it will wrap the
platform webview, on Linux, MacOS and Windows it will be powered by QtWebEngine, at least initially.
[Issue 11: Make a Proof of Concept Servo implementation of QtWebView](https://github.com/turtlebrowser/turtlebrowser/issues/11)
is looking to investigate making an alternative implementation of Qt WebView using Servo.

```
Qt WebView provides a way to display web content in a QML application without necessarily including a full web browser stack by using native APIs where it makes sense.

This is useful on mobile platforms such as Android, iOS, and UWP (Universal Windows Platform); especially on iOS, where policy dictates that all web content is displayed using the operating system's web view.

On Windows, Linux, and macOS, Qt WebView depends on the Qt WebEngine module to render content.
```

[Qt docs on Qt WebView](https://doc.qt.io/qt-5/qtwebview-index.html)

# Licences

Tracked in [issue 16](https://github.com/turtlebrowser/turtlebrowser/issues/16)

Using Qt and Chromium comes with a wide range of licences that all have to be taken into account. Not exactly sure what that means for TurtleBrowser yet.

[Qt WebEngine Licensing](https://doc.qt.io/qt-5/qtwebengine-licensing.html)

Icons: [Material icons](https://material.io/resources/icons/?style=outline) licence: [Apache license version 2.0](https://www.apache.org/licenses/LICENSE-2.0.html)

# Development

## Development notes

### See Qt Dependencies to build Qt locally, either through Conan or stand alone

https://wiki.qt.io/Building_Qt_5_from_Git

### Using the prebuilt conan cache to avoid building Qt

Clone the appropriate branch of [conan-cache-turtlebrowser](https://github.com/turtlebrowser/conan-cache-turtlebrowser) according to the instructions [here](https://github.com/turtlebrowser/conan-cache#how-to-use-locally).

#### Windows Conan Cache build settings
```
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
```

#### Linux Conan Cache build settings
```
Configuration:
[settings]
arch=x86_64
arch_build=x86_64
build_type=Release
compiler=gcc
compiler.libcxx=libstdc++11
compiler.version=7
os=Linux
os_build=Linux
[options]
[build_requires]
[env]
```

#### Build new Windows Conan Cache
Use the [script](https://github.com/turtlebrowser/conan-cache/blob/master/update_cache_windows.sh) in [conan-cache](https://github.com/turtlebrowser/conan-cache)
```
./update_cache_windows.sh <path to TurtleBrowser checkout>
```

#### Build new Linux Conan Cache
Use the [script](https://github.com/turtlebrowser/conan-cache/blob/master/update_cache_linux.sh) in [conan-cache](https://github.com/turtlebrowser/conan-cache)
```
./update_cache_linux.sh <path to TurtleBrowser checkout>
```

## Using conan install

- Conan needs Python 3
- Chromium needs Python greater than equal to 2.7.5 and less than 3
- Chromium generates very long filenames/paths - put .conan at the root of the filesystem
  [https://docs.conan.io/en/latest/mastering/custom_cache.html]
- git config --system core.longpaths true (probably not needed)

## GitBash Windows

```
$ pip3 install conan --upgrade
$ python --version
Python 2.7.17
```

## Linux

```
$ sudo pip3 install conan --upgrade
$ python --version
Python 2.7.17
```

```
$ export CONAN_USER_HOME=/Code/
$ conan remote add bincrafters https://api.bintray.com/conan/bincrafters/public-conan
$ conan install . -s build_type=Debug -s compiler=gcc -s compiler.version=7 -s compiler.libcxx=libstdc++11 -g=cmake --build=missing
```

### Might be needed

See [Qt dependencies](https://wiki.qt.io/Building_Qt_5_from_Git) for help in what you need to build Qt

```
sudo apt-get install libxcb-xinput0 xorg-dev libxcb-render-util0-dev libxcb-xkb-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev 
```

## Test conan-qt branch

If you need to test conan-qt changes locally.

```
conan export /path/to/conan-qt qt/5.15.0@user/channel
```

## Style

* Options for [palette](https://doc.qt.io/qt-5/qml-palette.html#qtquickcontrols2-palette), [syntax](https://doc.qt.io/qt-5/qtquickcontrols2-configuration.html#palette-configuration)
* Options for [font](https://doc.qt.io/qt-5/qtquickcontrols2-configuration.html#font-configuration)
* QT_QUICK_CONTROLS_IMAGINE_PATH=imagine-assets
* Command line: ./app -style material
* Environment: QT_QUICK_CONTROLS_STYLE=universal ./app
* [Icon Themes](https://doc.qt.io/qt-5/qtquickcontrols2-icons.html#icon-themes)
