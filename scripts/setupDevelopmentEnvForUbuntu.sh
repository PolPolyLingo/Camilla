#!/bin/bash

PACKAGES="git valac valac-bin libvala-0.48-dev libvalacodegen-0.48-0 valac-0.48-vapi \
          meson ninja-build libglib2.0-dev build-essential gzip pandoc uncrustify \
          gir1.2-gee-0.8 libgee-0.8-2 libgee-0.8-dev gettext"

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
