#!/bin/bash -eu
# [Description]
#  This shell script install man-pages, LICENSE, NOTICE.
ROOT_DIR=$(git rev-parse --show-toplevel)
MAN_DIR="${ROOT_DIR}/man"
MAN_PAGES_LANG="ja en"
DOC_INSTALL_DIR="/usr/share/doc/camilla"
LICENSE="${ROOT_DIR}/LICENSE"
NOTICE="${ROOT_DIR}/NOTICE"
CONFIG_INSTALL_DIR="/usr/share/camilla"
LOG_CONFIG="${ROOT_DIR}/data/camilla-log4vala.conf"

function errMsg() {
    local message="$1"
    echo -n -e "\033[31m\c"
    echo "${message}" >&2
    echo -n -e "\033[m\c"
}

function isRoot() {
    if [ ${EUID:-${UID}} != 0 ]; then
        errMsg "[Usage]"
        errMsg " $ sudo $0"
        exit 1
    fi
}

function installManPages() {
    echo "Install man-pages"

    for lang in ${MAN_PAGES_LANG}
    do
        mkdir -p /usr/share/man/man1/.
        mkdir -p /usr/share/man/${lang}/man1/.

        local man_pages=$(find ${MAN_DIR}/ -name "*.gz" | grep "/${lang}/")
        for man_page in ${man_pages}
        do
            if [ "${lang}" = "en" ]; then
                echo "Install ${man_page} at /usr/share/man/man1" 
                install -m 0644 ${man_page} /usr/share/man/man1/.
            else
                echo "Install ${man_page} at /usr/share/man/${lang}/man1" 
                install -m 0644 ${man_page} /usr/share/man/${lang}/man1/.
            fi
        done
    done
}

function installLicense() {
    echo "Install LICENSE and NOTICE at ${DOC_INSTALL_DIR}"
    mkdir -p ${DOC_INSTALL_DIR}
    install -m 0644 ${LICENSE} ${DOC_INSTALL_DIR}
    install -m 0644 ${NOTICE} ${DOC_INSTALL_DIR}
}

function installConfigFile() {
    echo "Install log config file at ${CONFIG_INSTALL_DIR}"
    mkdir -p ${CONFIG_INSTALL_DIR}
    install -m 0644 ${LOG_CONFIG} ${CONFIG_INSTALL_DIR}
}

isRoot
installConfigFile
installManPages
installLicense