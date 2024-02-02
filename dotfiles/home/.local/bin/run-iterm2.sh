#!/bin/sh

procNumber=$(ps -ef | grep '/Applications/iTerm.app/Contents/MacOS/iTerm2' | wc -l)
if [ ${procNumber} -le 1 ];then
    open -a '/Applications/iTerm.app'
    exit 0
fi

osascript -e '
tell application "iTerm2"
set newWindow to (create window with default profile)
tell current session of newWindow
# write text "env "
end tell
end tell
'