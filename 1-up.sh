#!/usr/bin/env bash
# Usage: Sysmaker container boot up (`normal`(app + api + nginx) or `single`)
# Maintainer: LouisSung <ls@sysmaker.org>
# Edit Date: [LS] 2020-04.02, 0329

# Make sure this script execute from its location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
RESTORE_DIR=$(pwd)

cd "$SCRIPT_DIR" || exit 1
# <<<<<<< Script Start

if [ "$#" -eq 0 ]; then  set -- 'all'; fi

case "$1" in
  all) docker-compose up
    ;;
  single) docker-compose -f docker-compose.single.yml up
    ;;
esac

# >>>>>>> Script End
cd "$RESTORE_DIR" || exit 1
