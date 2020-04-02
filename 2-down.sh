#!/usr/bin/env bash
# Usage: Sysmaker container shut down (all)
# Maintainer: LouisSung <ls@sysmaker.org>
# Edit Date: [LS] 2020-0330

# Make sure this script execute from its location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
RESTORE_DIR=$(pwd)

cd "$SCRIPT_DIR" || exit 1
# <<<<<<< Script Start

docker-compose -f docker-compose.yml -f docker-compose.single.yml down

# >>>>>>> Script End
cd "$RESTORE_DIR" || exit 1
