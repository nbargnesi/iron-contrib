#!/usr/bin/env bash

source "$TOP_DIR"/env.sh || exit 1
source "$TOP_DIR"/node.sh || exit 1

testInstallNodeDepsFailure() {
    OUTPUT=$(install_node_deps 2>&1)
    RET=$?
    # assert returned 1
    assertEquals 1 $RET

    # assert npm output generated
    assertTrue "function failed to produce output" '[ ! -z "$OUTPUT" ]'
}

testMissingNodeEnv() {
    # missing MODPATH
    IRON_CONTRIB_NODE_NPM_MODPATH="fake-environment"
    IRON_CONTRIB_NODE_NPM_PKGJSON="ignored"
    node_env_needs_update
    RET=$?
    # assert returned 0 (indicating an update is needed)
    assertEquals 0 $RET
}

testPackageJSONChanged() {
    # PKGJSON newer than MODPATH
    IRON_CONTRIB_NODE_NPM_MODPATH="$(mktemp -d)"
    mkdir "$IRON_CONTRIB_NODE_NPM_MODPATH"/node_modules
    touch -d "19700101" $IRON_CONTRIB_NODE_NPM_MODPATH
    IRON_CONTRIB_NODE_NPM_PKGJSON="$(mktemp)"
    node_env_needs_update
    RET=$?

    rm -fr "$IRON_CONTRIB_NODE_NPM_MODPATH"
    rm "$IRON_CONTRIB_NODE_NPM_PKGJSON"

    # assert returned 0 (indicating an update is needed)
    assertEquals 0 $RET
}

testCreationFailed() {
    # no ".ts" file exists in MODPATH
    IRON_CONTRIB_NODE_NPM_PKGJSON="$(mktemp)"
    touch -d "19700101" $IRON_CONTRIB_NODE_NPM_PKGJSON
    IRON_CONTRIB_NODE_NPM_MODPATH="$(mktemp -d)"
    mkdir "$IRON_CONTRIB_NODE_NPM_MODPATH"/node_modules
    node_env_needs_update
    RET=$?

    rm -fr "$IRON_CONTRIB_NODE_NPM_MODPATH"
    rm "$IRON_CONTRIB_NODE_NPM_PKGJSON"

    # assert returned 0 (indicating an update is needed)
    assertEquals 0 $RET
}

. "$(dirname "$BASH_SOURCE[0]")"/shunit2-2.1.6/src/shunit2
