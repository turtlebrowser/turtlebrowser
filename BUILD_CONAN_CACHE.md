# Project internal documentation, not intended for devs or users

These instructions are to update the Conan Cache

# Ubuntu 20.04 : Taking in a new release

Prerequisite: SSH key has been added to your accout

## Setup of machine

~~~ bash
mkdir ~/Code
cd ~/Code
git clone git@github.com:turtlebrowser/turtlebrowser.git
git clone git@github.com:turtlebrowser/conan-cache.git
git config --global user.name "Your Name"
git config --global user.email "your_email_address@example.com"
mkdir /Code
cd /Code
export CONAN_USER_HOME="/Code/release"
export CONAN_USER_HOME_SHORT=${CONAN_USER_HOME}/short
git clone git@github.com:turtlebrowser/conan-cache-turtlebrowser.git $CONAN_USER_HOME
sudo apt update
sudo apt-get install git-lfs
sudo apt install python
pip3 install wheel setuptools
pip3 install conan --upgrade
sudo apt install cmake
sudo apt install pkgconf
~~~

## Run build

~~~ bash
cd ~/Code/conan-cache
./update_cache_ubuntu_20_04.sh /<user>/Code/turtlebrowser/
~~~
