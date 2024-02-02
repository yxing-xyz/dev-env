#!/bin/sh

dsktpIdx="$1" # arguments are accessible through $1, $2,...
totalNum=`/opt/homebrew/bin/yabai -m query --displays --display | /opt/homebrew/bin/jq '.spaces | length'`
displayID=$(/opt/homebrew/bin/yabai -m query --displays --display | /opt/homebrew/bin/jq '.id')
if (( $(echo "${displayID} == 1" | bc -l) )); then
    max=$(($dsktpIdx-$totalNum))
    for ((i=1;i<=$max;i++))
    do
        /opt/homebrew/bin/yabai -m space --create
    done
fi

/opt/homebrew/bin/yabai -m space --focus $dsktpIdx