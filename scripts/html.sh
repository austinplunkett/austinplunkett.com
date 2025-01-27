#!/bin/bash

set -euo pipefail

this_dir=$(readlink -qe "$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )")
wd=$(readlink -qe "${this_dir}"/../)

cd "${wd}"

while read f ; do
    echo "${f}"
    d=$(dirname "${f}")
    f="${d}"/$(basename "${f}")
    t="${d}"/index.html
    minify "${f}" > "${t}"
done < <(find "${wd}" -name index-raw.html)
