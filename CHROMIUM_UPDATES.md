# Notes on performing Chromium updates

**THIS IS NOT A WORKING PROCESS. THESE ARE NOTES WHILE TRYING TO FIGURE OUT A PROCESS.**

We are using conan-qt, which means we are tied to official Qt releases. This will not work unmodified. We will need to fork conan-qt or patch it, where we add patches to Qt - specifically a patch to update to a new Chromium version. This will be much harder than it sounds.

## High level plan

These steps will have to be performed in reverse

1. Patch conan-qt to get and build patched Qt
1. Patch Qt to get and build patched Chromium
1. Patch Chromium to integrate with QtWebEngine

* Chromium Schedule: https://www.chromium.org/developers/calendar
* Chromlium Schedule: https://chromiumdash.appspot.com/schedule
* Qt Chromium repo: https://code.qt.io/cgit/qt/qtwebengine-chromium.git/
* What an Qt Chromium update looks like: https://code.qt.io/cgit/qt/qtwebengine.git/commit/?h=5.12
* Linux build instructions: https://chromium.googlesource.com/chromium/src/+/master/docs/linux/build_instructions.md
* Get and build gn: https://gn.googlesource.com/gn/
* Gn args: https://www.chromium.org/developers/gn-build-configuration
* Working with release branches: https://www.chromium.org/developers/how-tos/get-the-code/working-with-release-branches
* FreeBSD patches: https://github.com/freebsd/freebsd-ports-kde/tree/master/www/qt5-webengine/files

## Plan for figuring out the Chromium patch set (Step 3)

- [x] Get and build Chromium latest locally on Linux (make functional build instructions)
- [ ] Build Chromium 83 (probably a bit different build instructions)
- [ ] Diff with Qts branch at 83
- [ ] Try to figure out a minimal patch set between the two (we don't need all the backported fixes)
- [ ] Apply minimal patch set to Chromium 83
- [ ] Make it build on Linux
- [ ] Make it build on Windows
- [ ] Make it build on Mac
- [ ] Polish it - make sure it still builds on Linux, Mac and Windows
- [ ] Take the patch set and apply it to Chromium latest
- [ ] Make it build on Linux
- [ ] Make it build on Windows
- [ ] Make it build on Mac
- [ ] Polish it - make sure it still builds on Linux, Mac and Windows
- [ ] Try to integrate the patched Chromium with Qt 5.15.2
- [ ] Make it build on Linux
- [ ] Make it build on Windows
- [ ] Make it build on Mac
- [ ] Upload the source somewhere
- [ ] Locally patch conan-qt to fetch the modified Chromium
- [ ] Make it build on Linux
- [ ] Make it build on Windows
- [ ] Make it build on Mac

### Trying to build Chromium Latest clean on Linux

Linux build instructions: https://chromium.googlesource.com/chromium/src/+/master/docs/linux/build_instructions.md

~~~ bash
mkdir -p ~/Code
cd ~/Code
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH="$PATH:${HOME}/Code/depot_tools"
mkdir chromium_latest && cd chromium_latest
fetch --nohooks chromium
cd src
./build/install-build-deps.sh
gclient runhooks
gn gen out/Default
nano out/Default/args.gn
autoninja -C out/Default chrome
~~~

Gn args: https://www.chromium.org/developers/gn-build-configuration

~~~ bash
$ cat out/Default/args.gn
Set build arguments here. See `gn help buildargs`.
symbol_level=1
blink_symbol_level=0
~~~

### Trying to build Chromium 83 clean on Linux

Linux build instructions: https://chromium.googlesource.com/chromium/src/+/master/docs/linux/build_instructions.md
Working with release branches: https://www.chromium.org/developers/how-tos/get-the-code/working-with-release-branches

~~~ bash
mkdir -p ~/Code
cd ~/Code
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH="$PATH:${HOME}/Code/depot_tools"
mkdir chromium_83 && cd chromium_83
fetch --nohooks chromium
cd src
git fetch --tags
git checkout tags/83.0.4103.122
./build/install-build-deps.sh
./build/linux/sysroot_scripts/install-sysroot.py --arch=amd64
gclient sync --with_branch_heads --with_tags
gclient runhooks
gn gen out/Default
nano out/Default/args.gn
autoninja -C out/Default chrome
~~~

Gn args: https://www.chromium.org/developers/gn-build-configuration

~~~ bash
$ cat out/Branch83/args.gn
Set build arguments here. See `gn help buildargs`.
symbol_level=1
blink_symbol_level=0
~~~

Switch back
~~~ bash
git checkout -f master
gclient sync
~~~

### Trying to build qtwebengine-chromium 83 clean on Linux

Which branch?
~~~ bash
cd qtwebengine-chromium/
git branch -a --contains v5.15.0
* 83-based
  remotes/origin/83-based
~~~

~~~ bash
$ cat .gclient
solutions = [use_qt
    "url": "https://code.qt.io/qt/qtwebengine-chromium.git",
    "managed": False,
    "custom_deps": {},
    "custom_vars": {},
  },
]
~~~

This will not be enough - we need qt to build properly
~~~ bash
$ cat out/Default/args.gn
Set build arguments here. See `gn help buildargs`.
symbol_level=1
blink_symbol_level=0
use_qt=true
~~~

This is just thoughts - will not work - the Qt repo has no DEPS files
~~~ bash
mkdir -p ~/Code
cd ~/Code
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH="$PATH:${HOME}/Code/depot_tools"
mkdir -p ~/Code/qtwebengine-chromium-83
cd ~/Code/qtwebengine-chromium-83
nano .gclient
git clone git://code.qt.io/qt/qtwebengine-chromium.git
cd qtwebengine-chromium/
git checkout v5.15.2
./build/install-build-deps.sh
./build/linux/sysroot_scripts/install-sysroot.py --arch=amd64
gclient sync --with_branch_heads --with_tags
gclient runhooks
gn gen out/Default
nano out/Default/args.gn
autoninja -C out/Default chrome
~~~
