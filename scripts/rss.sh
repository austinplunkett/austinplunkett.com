#!/bin/bash

# Kudos: https://recursewithless.net/projects/pandoc-feeds.html
# Decisions about file names kudos: https://blog.jim-nielsen.com/2021/feed-urls/
# Definitive RSS location:  /feed.xml
# Definitive Atom location: /feed.atom

set -euo pipefail

this_dir=$(readlink -qe "$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )")
wd=$(readlink -qe "${this_dir}"/../)

cd "${wd}"

f="feed.xml"

# Remember, date must be in RFC822 format.

pandoc \
    -M updated="$(date '+%a, %d %b %Y %H:%M:%S %Z')" \
    -M title='Austin Plunkett' \
    --metadata-file=feed.yaml \
    --template=templates/rss.xml \
    --wrap=none \
    -t html \
    < /dev/null \
    > "${f}"

# Minify pandoc's output:
#     | sed -re 's/^\s+//g' \
#     | grep -v '^$' \
#     | tr -d $'\n' \


# Remember to write over file $f last.
for t in "feed.atom" "${f}" ; do
    tmpfile=$(mktemp)
    unset FILENAME 2>/dev/null || :
    FILENAME="${t}" envsubst < <(cat "${f}") > "${tmpfile}"
    cp -f "${tmpfile}" "${t}"
    rm -f "${tmpfile}"
done

# Hmm skip Atom for now! (:
rm -r feed.atom 2>/dev/null || :
