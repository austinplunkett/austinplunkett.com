#!/bin/bash

# Kudos: https://recursewithless.net/projects/pandoc-feeds.html

pandoc \
    -M updated="$(date '+%a, %d %b %Y')" \
    -M title=' ' \
    --metadata-file=blog.yaml \
    --template=templates/rss.xml \
    -t html \
    -o rss.xml \
    < /dev/null
