#!/usr/bin/env bash
# Usage: Push built Sysmaker Docker images
# Maintainer: LouisSung <ls@sysmaker.org>
# Edit Date: [LS] 2020-0402, 0401

# Make sure this script execute from its location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
RESTORE_DIR=$(pwd)

cd "$SCRIPT_DIR" || exit 1
# <<<<<<< Script Start

# ===== def func =====
function add_latest_tag_and_push() {  #$1=TARGET_IMAGE
  NEW_IMAGE="$(docker images "sysmaker/sysmaker$1" --format '{{.Repository}}:{{.Tag}} {{.Repository}}:latest {{.Repository}}:dev' | head -1)"
  ORIGINAL_TAG=$(echo "$NEW_IMAGE" | cut -f1 -d' ')
  LATEST_TAG=$(echo "$NEW_IMAGE" | cut -f2 -d' ')
  DEV_TAG=$(echo "$NEW_IMAGE" | cut -f3 -d' ')
  docker tag "$ORIGINAL_TAG" "$LATEST_TAG"
  docker tag "$ORIGINAL_TAG" "$DEV_TAG"

  case "$ORIGINAL_TAG" in
    *feature*)  # feature branch (push `:dev` only)
      echo "push $DEV_TAG" && docker push "$DEV_TAG"
      docker rmi "$DEV_TAG"
      ;;
    *master*)  # master branch (push both `:master-*` and `latest`)
      echo "push $ORIGINAL_TAG" && docker push "$ORIGINAL_TAG"
      echo "push $LATEST_TAG" && docker push "$LATEST_TAG"
      docker rmi "$LATEST_TAG"
      ;;
  esac
}
# ===== end def func =====

if [ "$#" -eq 0 ]; then set -- 'all'; fi

case "$1" in
  env) add_latest_tag_and_push '-env'
    ;;
  all) for target in '-app' '-api' ''; do add_latest_tag_and_push "$target"; done
    ;;
esac

# >>>>>>> Script End
cd "$RESTORE_DIR" || exit 1
