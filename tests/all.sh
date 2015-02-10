#!/usr/bin/env bash
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export TOP_DIR="$dir"/../
cd "$dir" || exit 1

_getopt=$(getopt -o U --long update-gosh -- "$@") || exit 1
update_gosh="no"
while [ $# -gt 0 ]; do
    case "$1" in
        "-U")
            ;&
        "--update-gosh")
            update_gosh="yes"
            ;;&
    esac
    shift
done

if [ ! -r "$TOP_DIR"/.gosh.sh -o "$update_gosh" == "yes" ]; then
    echo -n "Updating formwork-io/gosh... "
    # Install the latest go shell
    cd ..
    url="https://raw.githubusercontent.com/formwork-io/gosh/latest/overlay.sh"
    output=$(wget --quiet --content-disposition "$url" -O - | bash 2>&1)
    if [ $? -ne 0 ]; then
        echo "FAIL"
        echo "$output"
        exit 1
    fi
    echo "done"
    echo "--"
    cd "$dir" || exit 1
fi

export TOP_DIR="$dir"/../
for test_script in *.sh; do
    if [ "$test_script" == "all.sh" ]; then
        continue
    fi
    ./"$test_script"
done

