#!/bin/bash

PACKAGES="git valac meson ninja-build libglib2.0-dev build-essential gzip pandoc graphviz plantuml uncrustify"

function isUbuntu() {
    cat /etc/os-release | grep "NAME=\"Ubuntu\""
    if [ "$?" != "0" ]; then
        echo "This environment is not Ubuntu. Not use this script."
        exit 1
    fi
}

isUbuntu
sudo apt update
sudo apt -y upgrade
sudo apt -y install ${PACKAGES}
