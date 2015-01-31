#!/usr/bin/env bash

source "$TOP_DIR"/env.sh || exit 1
source "$TOP_DIR"/node.sh || exit 1

testInstallNodeDepsFailure {
    install_node_deps 1>/dev/null 2>&1
    # assert 
    assertEquals $? 1
}

. "$(dirname "$BASH_SOURCE[0]")"/shunit2-2.1.6/src/shunit2
