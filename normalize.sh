#!/bin/bash
# Date: 2018-10-31
# Author: Wen-Kai, Chang
# Reference: https://www.linuxjournal.com/content/normalizing-filenames-and-data-using-bash-string-variable-manipulations

input="$*"
echo "Before encode: $input"

for ((count=0; count!=${#input}; ++count))
do
    char=${input:$count:1};
    if [[ "$char" =~ [\-_.\/!@#=\&\?a-zA-Z0-9] ]]; then
        output="$output$char"
    else
        hexchar="$(echo "$char" | tr -d '\n' | xxd -ps | head -1 \
            | awk '{for(i=0; i<length(); i+=2) printf("%%%s", toupper(substr($0,i,2)))}')"
        output="$output$hexchar"
    fi
done
echo "After encoded: $output"
