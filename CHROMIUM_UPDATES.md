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
* Gn args: https://www.chromium.org/developers/gn-build-configuration

## Plan for figuring out the Chromium patch set (Step 3)

- [x] Get and build Chromium latest locally on Linux (make functional build instructions)
- [ ] Build Chromium 80 (probably a bit different build instructions)
- [ ] Diff with Qts branch at 80
- [ ] Try to figure out a minimal patch set between the two (we don't need all the backported fixes)
- [ ] Apply minimal patch set to Chromium 80
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

### Trying to build Chromium clean on Linux

https://chromium.googlesource.com/chromium/src/+/master/docs/linux/build_instructions.md

~~~ bash
mkdir -p ~/Code
cd ~/Code
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH="$PATH:${HOME}/Code/depot_tools"
mkdir chromium && cd chromium
fetch --nohooks chromium
cd src
./build/install-build-deps.sh
gclient runhooks
gn gen out/Default
nano out/Default/args.gn
autoninja -C out/Default chrome
~~~

~~~ bash
$ cat out/Default/args.gn
Set build arguments here. See `gn help buildargs`.
symbol_level=1
blink_symbol_level=0
~~~
