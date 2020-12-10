# Notes on performing Chromium updates

**THIS IS NOT A WORKING PROCESS. THESE ARE NOTES WHILE TRYING TO LOOK AT A PROCESS.**

We are using conan-qt, which means we are tied to official Qt releases. This will not work unmodified. We will need to fork conan-qt or patch it, where we add patches to Qt - specifically a patch to update to a new Chromium version. This will be much harder than it sounds.

* Schedule: https://www.chromium.org/developers/calendar
* Schedule: https://chromiumdash.appspot.com/schedule
* Qt Chromium repo: https://code.qt.io/cgit/qt/qtwebengine-chromium.git/
* What an update looks like: https://code.qt.io/cgit/qt/qtwebengine.git/commit/?h=5.12
* Linux build instructions: https://chromium.googlesource.com/chromium/src/+/master/docs/linux/build_instructions.md

## Details
* Latest gn binary (zip) : https://chrome-infra-packages.appspot.com/dl/gn/gn/linux-amd64/+/latest
* gn binary placed at ~/Code/qtwebengine-chromium/chromium/buildtools/linux64/gn

This does not work, but it's a beginning
~~~ bash
mkdir -p ~/Code
cd ~/Code
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH="$PATH:${HOME}/Code/depot_tools"
git clone git://code.qt.io/qt/qtwebengine-chromium.git
cd qtwebengine-chromium/
git checkout 87-based
cd ninja/
sudo apt install re2c
./configure.py --bootstrap
cd ../chromium/
./build/install-build-deps.sh
gclient config http://code.qt.io/qt/qtwebengine-chromium.git
gclient runhooks
gn args out
nano out/args.gn
gn gen out/Default
~~~