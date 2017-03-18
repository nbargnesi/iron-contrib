#!/usr/bin/env bash

source "$TOP_DIR"/env.sh || exit 1
source "$TOP_DIR"/eslint.sh || exit 1

testMissingESLintEnv() {
    # missing MODPATH
    IRON_CONTRIB_ESLINT_NPM_MODPATH="fake-environment"
    eslint_env_needs_update
    RET=$?
    # assert returned 0 (indicating an update is needed)
    assertEquals 0 $RET
}

testCreationFailed() {
    # no ".ts" file exists in MODPATH
    IRON_CONTRIB_ESLINT_NPM_MODPATH="$(mktemp -d)"
    mkdir "$IRON_CONTRIB_ESLINT_NPM_MODPATH"/node_modules
    eslint_env_needs_update
    RET=$?

    rm -fr "$IRON_CONTRIB_ESLINT_NPM_MODPATH"

    # assert returned 0 (indicating an update is needed)
    assertEquals 0 $RET
}

. "$(dirname "$BASH_SOURCE[0]")"/shunit2-2.1.6/src/shunit2
