#!/bin/bash

set -euo pipefail

this_dir=$(readlink -qe "$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )")
wd=$(readlink -qe "${this_dir}"/../)

cd "${wd}"

old_branch=$(git branch --show-current)

git checkout publish # >/dev/null 2>/dev/null

while read f ; do
    git restore --source main "${f}"
done < <(git ls-tree --full-tree -r --name-only main | ag '\.(css|html|ico|js|png|xml)$' | ag -v '\.raw.html$')

git add .

{
    git commit -m "Latest site $(date)"
} || {
    echo "Nothing to do!"
    git checkout "${old_branch}"
    exit 0
}

{
    git push
} || {
    echo "Nothing to do!"
    git checkout "${old_branch}"
    exit 0
}

git checkout "${old_branch}"
