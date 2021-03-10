# MacOS Developer Build Instructions (Work in Progress)

[//]: # (Prerequisite: SSH key has been added to your accout)

## Setup of machine

Install CLion https://www.jetbrains.com/clion/download/#section=mac

Clone turtlebrowser
~~~ bash
git clone git@github.com:turtlebrowser/turtlebrowser.git
~~~

Install brew: https://brew.sh

Install VSCode (good for handling patches and conflicts - not really needed)
~~~ bash
brew install visual-studio-code
~~~

Install Python 3 https://www.python.org/downloads/

Install Conan
~~~ bash
pip3 install conan  
~~~

Install Java (probably not needed if not building chromium tests) https://www.oracle.com/java/technologies/javase-jdk15-downloads.html

Install XCode (App Store)

Install Node.js https://nodejs.org/en/download/

Open the CMakeLists.txt file in the root folder of the turtlebrowser project in CLion.

## Troubleshooting

**Conan**

There seems to be a problem with Conan installed via Homebrew. 
Therefore, install it via PIP instead `pip install conan` and your version should be `1.34.0` minimum. 
If you have an older version, it can be updated running `pip install -U conan`. 

**Python**

- Conan utilise Python3, but Chromium depends on Python2.7 to build. 
  Therefore using Python3 can cause problems (i.e. Anaconda/Conda) 
  the system includes Python2.7 will allow both Conan to work and Chromium to build 

**Homebrew Clang "Interference"**

Turtlebrowser compilation is currently only tested with the Apple LLVM stack. 
If you usually are using LLVM installed via Homebrew, it can interfere with the build process. 
Below is a list of environment variable changes known to affect the build process. 
These should be removed before a build is attempted. 

- `export PATH="/usr/local/opt/llvm/bin:$PATH"`
- `export LIBRARY_PATH="/usr/local/lib:$LIBRARY_PATH"`
- `export CPLUS_INCLUDE_PATH="/usr/local/include:$CPLUS_INCLUDE_PATH"`

**Xcode**

Get the right version of Xcode or activate Xcode after a macOS update. 
To check if it setup correctly run `xcodebuild -version && xcodebuild -showsdks`.
If the output gives the version and SDK, you expect then you are set to go. 
If it is not or it is empty, run the command `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`

