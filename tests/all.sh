#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

# Install the latest go shell
cd ..
URL="https://raw.githubusercontent.com/formwork-io/gosh/latest/overlay.sh"
wget --quiet --content-disposition "$URL" -O - | bash

cd "$DIR" || exit 1
export CONTRIB_DIR="$DIR"/../
for test_script in *.sh; do
    if [ "$test_script" == "all.sh" ]; then
        continue
    fi
    ./"$test_script"
done

