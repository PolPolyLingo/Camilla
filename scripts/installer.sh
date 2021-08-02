#!/bin/bash -eu
# [Description]
#  This shell script install man-pages, LICENSE, NOTICE.
ROOT_DIR=$(git rev-parse --show-toplevel)
MAN_DIR="${ROOT_DIR}/man"
MAN_PAGES_LANG="ja en"
DOC_INSTALL_DIR="/usr/share/doc/camilla"
LICENSE="${ROOT_DIR}/LICENSE"
NOTICE="${ROOT_DIR}/NOTICE"

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
        local man_pages=$(find ${MAN_DIR}/ -name "*.gz" | grep "/${lang}/")
        for man_page in ${man_pages}
        do
            echo "Install ${man_page}" 
            if [ "${lang}" = "en" ]; then
                install -m 0644 -D ${man_page} /usr/share/man/man1/.
            else
                install -m 0644 -D ${man_page} /usr/share/man/${lang}/man1/.
            fi
        done
    done
}

function installLicense() {
    echo "Install LICENSE and NOTICE at ${DOC_INSTALL_DIR}"
    install -m 0644 -D ${LICENSE} ${DOC_INSTALL_DIR}
    install -m 0644 -D ${NOTICE} ${DOC_INSTALL_DIR}
}   

isRoot
installManPages
installLicense