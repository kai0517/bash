#!/bin/bash
# Date: 2018-11-12
# Reference: https://www.linuxjournal.com/content/remove-duplicate-path-entries

# Use awk to remove duplicate entries and to retain the original order of these entries.

export PATH=/usr/bin:/bin:/usr/local/bin:/usr/bin:/bin
echo -n $PATH | awk -v RS=: -v ORS=: '!($0 in ary) {ary[$0]; printf("%s%s", length(ary) > 1 ? ":" : "", $0)}'
echo
