#!/usr/bin/env bash

set -e
set -x
shopt -s dotglob

readonly name="lcm"
readonly ownership="LCM Upstream <lcm-upstream@lcm.local>"
readonly subtree="$name/$name-src"
readonly repo="https://github.com/lcm-proj/lcm.git"
readonly tag="v1.3.0"

extract_source () {
    git_archive
}

. "${BASH_SOURCE%/*}/../update-common.sh"
