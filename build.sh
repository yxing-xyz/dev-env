#!/bin/sh

su x -c "
expect -c '
    spawn yay --sudoloop --save
	expect \"*sudo*\"
	send "x\\n"
	expect eof'
expect -c '
	spawn yay -Syu --needed --noconfirm --overwrite \"*\"
	expect \"*sudo*\"
	send "x\\n"
	expect eof'
"
rm -rf /home/x/* || true
rm -rf /home/x/.* || true
rm -rf /tmp/* || true
