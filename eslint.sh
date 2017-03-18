# iron-contrib: eslint.sh
# https://github.com/formwork-io/iron-contrib
#
# Copyright (c) 2015 Nick Bargnesi
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#

# This contrib uses the following env vars:
#
# IRON_CONTRIB_ESLINT_VERSION
#   Specific version of eslint to use (optional).
#
# IRON_CONTRIB_ESLINT_NPM_MODPATH
#   Path to eslint-specific node_modules directory, e.g., $DIR.
#

# Installs eslint into the node_modules of the current directory.
# E.g.,
#    install_eslint
function install_eslint {
    require-cmd "npm" || return 1
    echo -en "Running npm install... "
    # redirect stdout/stderr to mimic silent behavior
    # (npm currently lacks this functionality as of 2014-10-20)
    NODE_OUTPUT=$(mktemp) || return 1
    local version=IRON_CONTRIB_ESLINT_VERSION
    if [ ! -z "${!version}" ]; then
        npm install eslint@"${!version}" >"$NODE_OUTPUT" 2>&1
        EC=$?
    else
        npm install eslint >"$NODE_OUTPUT" 2>&1
        EC=$?
    fi
    if [ $EC -ne 0 ]; then
        echo "failed"
        cat "$NODE_OUTPUT" || return 1
        rm "$NODE_OUTPUT" || return 1
        return 1
    fi
    rm "$NODE_OUTPUT" || return 1
    echo "okay"
    return 0
}

# Determines whether the eslint node_modules need updating.
# E.g.,
#    if $(eslint_env_needs_update); then
#        # update it
#    fi
function eslint_env_needs_update {
    # returning 0 indicates an update is needed
    assert-env IRON_CONTRIB_ESLINT_NPM_MODPATH || return 0

    # E.g., $DIR -> $DIR/node_modules
    local nm_dir="$IRON_CONTRIB_ESLINT_NPM_MODPATH"/node_modules

    # directory doesn't exist?
    if [ ! -d "$nm_dir" ]; then return 0; fi
    # previous npm install failed?
    if [ ! -f "$nm_dir"/.ts ]; then return 0; fi
    return 1
}

# Marks the eslint environment IRON_CONTRIB_ESLINT_NPM_MODPATH as complete.
# Call this function once a node envrionment has been configured and all of the
# necessary dependencies have been installed.
function complete_eslint_env {
    assert-env IRON_CONTRIB_ESLINT_NPM_MODPATH || return 1
    # E.g., $DIR -> $DIR/node_modules
    local nm_dir="$IRON_CONTRIB_ESLINT_NPM_MODPATH"/node_modules
    date > "$nm_dir"/.ts || return 1
    return 0
}

# Creates an eslint environment using npm.
# This function needs IRON_CONTRIB_ESLINT_NPM_MODPATH set.
function create_eslint_env {
    assert-env IRON_CONTRIB_ESLINT_NPM_MODPATH || exit 1
    if eslint_env_needs_update; then
        echo "ESLint environment out-of-date - it will be created."
        echo "($IRON_CONTRIB_ESLINT_NPM_MODPATH)"
        # E.g., $DIR -> $DIR/node_modules
        local nm_dir="$IRON_CONTRIB_ESLINT_NPM_MODPATH"/node_modules
        rm -fr "$nm_dir"
        install_eslint || exit 1
        complete_eslint_env || exit 1
        echo
    fi

    local binpath="$IRON_CONTRIB_ESLINT_NPM_MODPATH/node_modules/.bin"
    _g_add_path "$binpath"
}

