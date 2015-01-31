#!/usr/bin/env bash

source "$CONTRIB_DIR"/node.sh || exit 1

install_node_deps

. "$(dirname "$BASH_SOURCE[0]")"/shunit2-2.1.6/src/shunit2
