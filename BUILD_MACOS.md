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

**Python**

- Conan utilise Python3 but Chromium depends on Python2.7 to build. 
  Therefore using Python3 can cause problems (i.e. Anaconda/Conda) 
  the system include Python2.7 will allow both Conan to work and Chromium to build 
