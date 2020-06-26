#!/bin/bash

[ $# -lt 2 ] && {
  echo "Usage: $0 [-linux|-windows] <full path to APPLICATION checkout>"
  exit 1
}

export PLATFORM_NAME=""
export CONAN_CACHE_BRANCH=""
export CONAN_USER_HOME=""

if [ "$1" == "-linux" ]; then
    PLATFORM_NAME=linux
    CONAN_CACHE_BRANCH=host-Linux-target-Linux-master
    CONAN_USER_HOME="/Code/release"
elif [ "$1" == "-windows" ]; then
    PLATFORM_NAME=windows
    CONAN_CACHE_BRANCH=host-Windows-target-Windows-master
    CONAN_USER_HOME="c:/release"
else
  echo "Usage: $0 [-linux|-windows] <full path to APPLICATION checkout>"
  exit 1
fi

APPLICATION_DIR="$2"

confirm() {
  read -r -p "${1:-Are you sure? [y/N]} " response
  case "$response" in
  [yY][eE][sS] | [yY])
    true
    ;;
  *)
    false
    ;;
  esac
}

header() {
  echo -e "\e[35m$1\e[0m"
}

echo "APPLICATION dir: " ${APPLICATION_DIR}

[ ! -d ${APPLICATION_DIR} ] && {
  echo "${APPLICATION_DIR} DOES NOT EXIST"
  exit 1
}

[ ! -d ${CONAN_USER_HOME} ] && {
  echo "${CONAN_USER_HOME} DOES NOT EXIST"
  exit 1
}

export CONAN_USER_HOME_SHORT=${CONAN_USER_HOME}/short

[ ! -d ${CONAN_USER_HOME_SHORT} ] && {
  echo "${CONAN_USER_HOME_SHORT} DOES NOT EXIST"
  exit 1
}

export INSTALL_SUB_DIR=install_release
export APPLICATION_INSTALL_DIR=${APPLICATION_DIR}/${INSTALL_SUB_DIR}
export RELATIVE_LICENSE_PATH=src/resources/licenses/${PLATFORM_NAME}/
export QRC_FILENAME=${PLATFORM_NAME}_licenses.qrc
export RELATIVE_QRC_PATH=src/resources/licenses/${PLATFORM_NAME}/${QRC_FILENAME}

fix_licenses() {
  cd ${APPLICATION_DIR}
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name "*.cpp" -exec rm {} +
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name "*.h" -exec rm {} +
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name "*.cc" -exec rm {} +
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name "*.py" -exec rm {} +
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name "*.pyc" -exec rm {} +
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name "*.pl" -exec rm {} +
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name "*.pl.vanilla" -exec rm {} +
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name "*.js" -exec rm {} +
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name "*,js" -exec rm {} +
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name "*.json" -exec rm {} +
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name "*.pro" -exec rm {} +
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name "*.qrc" -exec rm {} +
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name "*.png" -exec rm {} +
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name "*.qdoc" -exec rm {} +
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name "*.yml" -exec rm {} +
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name "*.patch" -exec rm {} +
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name "*.ini" -exec rm {} +
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name "CHANGELOG.md" -exec rm {} +
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name "README.md" -exec rm {} +
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name ".npmignore" -exec rm {} +
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name ".eslintignore" -exec rm {} +
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name "license-checker" -exec rm {} +
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name "nopt" -exec rm {} +
  find ${RELATIVE_LICENSE_PATH}/licenses -type f -name "OWNERS" -exec rm {} +
}

header "Prepare Cache for update"

confirm "Clean cache? [y/N]" && cd ${CONAN_USER_HOME} && git clean -df && git checkout . && git checkout ${CONAN_CACHE_BRANCH}

confirm "Update cache? [y/N]" && cd ${CONAN_USER_HOME} && git pull && git lfs pull

confirm "Prepare short paths [y/N]" && cd ${CONAN_USER_HOME} && find .conan/ -name .conan_link -exec perl -pi -e 's=CONAN_USER_HOME_SHORT=$ENV{CONAN_USER_HOME_SHORT}=g' {} +

header "Prepare Application for update"

confirm "Clean APPLICATION? [y/N]" && cd ${APPLICATION_DIR} && git stash && git clean -df && git checkout .

confirm "Update APPLICATION? [y/N]" && cd ${APPLICATION_DIR} && git pull

confirm "Remove old build directory? [y/N]" && cd ${APPLICATION_DIR} && rm -rf build

confirm "Create build directory? [y/N]" && cd ${APPLICATION_DIR} && mkdir build

confirm "Remove old install directory? [y/N]" && cd ${APPLICATION_DIR} && rm -rf ${INSTALL_SUB_DIR}

header "Clean Licenses"

confirm "Clean APPLICATION licenses? [y/N]" && cd ${APPLICATION_DIR} && rm -rf ${RELATIVE_LICENSE_PATH}

header "Produce licenses"

confirm "Start build? [y/N]" && cd ${APPLICATION_DIR} && cd build && cmake -DCHECK_IN_LICENSES=ON -DCMAKE_INSTALL_PREFIX=${APPLICATION_INSTALL_DIR} -DCMAKE_BUILD_TYPE=Release ..

confirm "Install build? [y/N]" && cd ${APPLICATION_DIR} && cd build && cmake --build . --config Release --target install

confirm "Fix licenses? [y/N]" && fix_licenses

confirm "Truncate qrc file? [y/N]" && cd ${APPLICATION_DIR} && : >${RELATIVE_QRC_PATH}

confirm "Write start qrc file? [y/N]" && cd ${APPLICATION_DIR}/${RELATIVE_LICENSE_PATH} && echo '<RCC><qresource prefix="/">' >>${QRC_FILENAME}

confirm "Write licenses? [y/N]" && cd ${APPLICATION_DIR}/${RELATIVE_LICENSE_PATH} && find licenses -type f -exec echo "<file>{}</file>" \; >>${QRC_FILENAME}

confirm "Write end qrc file? [y/N]" && cd ${APPLICATION_DIR}/${RELATIVE_LICENSE_PATH} && echo '</qresource></RCC>' >>${QRC_FILENAME}

confirm "Commit qrc file? [y/N]" && cd ${APPLICATION_DIR} && git add ${RELATIVE_QRC_PATH} && git commit -m "Updated qrc file"

confirm "Commit license files [y/N]" && cd ${RELATIVE_LICENSE_PATH} && git add -A . && git commit -m "Updated license files"

header "Test cache locally"

confirm "TEST: Clean APPLICATION? [y/N]" && cd ${APPLICATION_DIR} && git stash && git clean -df && git checkout .

confirm "TEST: Remove old build directory? [y/N]" && cd ${APPLICATION_DIR} && rm -rf build

confirm "TEST: Create build directory? [y/N]" && cd ${APPLICATION_DIR} && mkdir build

confirm "TEST: Start REGULAR build? [y/N]" && cd ${APPLICATION_DIR} && cd build && cmake -DUPDATE_CONAN=OFF -DCMAKE_BUILD_TYPE=Release ..
