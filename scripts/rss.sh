#!/bin/bash

# Kudos: https://recursewithless.net/projects/pandoc-feeds.html

set -euo pipefail

this_dir=$(readlink -qe "$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )")
wd=$(readlink -qe "${this_dir}"/../)

cd "${wd}"

pandoc \
    -M updated="$(date '+%Y-%m-%d')" \
    -M title='Austin Plunkett' \
    --metadata-file=feed.yaml \
    --template=templates/rss.xml \
    --wrap=none \
    -t html \
    < /dev/null \
    | sed -re 's/^\s+//g' \
    | grep -v '^$' \
    | tr -d $'\n' \
         > rss.xml
