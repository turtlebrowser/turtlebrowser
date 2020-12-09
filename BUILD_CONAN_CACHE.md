# Project internal documentation, not intended for devs or users

These instructions are to update the Conan Cache

# Temporary fixes

* 'ubuntu-20.04'

~~~ bash
sudo apt install libxcb-dri3-dev
~~~

* 'ubuntu-16.04'

~~~ bash
sudo apt install libegl1-mesa-dev
~~~

# Ubuntu 20.04 : Taking in a new release

Prerequisite: SSH key has been added to your accout

## 16.04 - needs

~~~ bash
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
~~~

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
sudo apt-get -y update
sudo apt-get -y install git-lfs
sudo apt-get -y install python
sudo apt-get -y install python3-pip
pip3 install wheel setuptools
pip3 install conan --upgrade
sudo apt-get -y install cmake
sudo apt-get -y install pkgconf
~~~

## Run build

~~~ bash
cd ~/Code/conan-cache
./update_cache_ubuntu_20_04.sh /<user>/Code/turtlebrowser/
~~~
