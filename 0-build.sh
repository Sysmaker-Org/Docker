#!/usr/bin/env bash
# Usage: Build Sysmaker Docker images
# Maintainer: LouisSung <ls@sysmaker.org>
# Edit Date: [LS] 2020-0402, 0401, 0330, 0329, 0308, 0304
# Edit Date: [LS] 2019-1231, 1209, 1202, 1022, 1013, 0929

# Make sure this script execute from its location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
RESTORE_DIR=$(pwd)

cd "$SCRIPT_DIR" || exit 1
# <<<<<<< Script Start

# ===== def func =====
function copy_folder_and_update_image_tag() {  # $1=TARGET_DIR $2=CI_COMMIT_BRANCH
  rsync -r --exclude-from=<(git -C "$1" ls-files --exclude-standard -oi --directory) "$1" sysmaker
  BRANCH=$(echo "${2:-$(git -C "$1" status | grep -oP 'On branch .+')}" | grep -oP '(master|develop|feature|release)')
  NUMBER=$(printf '%04d' "$(git -C "$1" rev-list --count HEAD)")
  HASH=$(git -C "$1" rev-parse --short HEAD)
  IMAGE_TAG="${BRANCH:-detached}-${NUMBER:-0000}-${HASH:-fffffff}"
  sed -i "s/IMAGE_TAG=.*/IMAGE_TAG=$IMAGE_TAG/g" .env
}
# ===== end def func =====

# use root folder as the target dir to tag (in case git submodule is used)
# provide `$CI_COMMIT_BRANCH` since detached HEAD is used during the gitlab ci process
rm -rf sysmaker/
copy_folder_and_update_image_tag '../../' "$CI_COMMIT_BRANCH"

if [ "$#" -eq 0 ]; then set -- 'all'; fi

case "$1" in
  all) docker-compose -f docker-compose.yml -f docker-compose.single.yml build  # --pull --no-cache
    ;;
  single) docker-compose -f docker-compose.single.yml build
    ;;
  ci) docker-compose -f docker-compose.gitlab-ci.yml build
    ;;
  env) docker-compose -f .docker-compose.env.yml build
    ;;
  *) set -- "${@/#/sysmaker-}"
     docker-compose build "$@"
    ;;
esac

docker image prune -f --filter label=sysmaker  # remove tmp image (<none>)
rm -rf sysmaker/

# >>>>>>> Script End
cd "$RESTORE_DIR" || exit 1
