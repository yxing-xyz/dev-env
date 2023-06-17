#!/bin/sh

wait_cmd() {
    while [ true ]; do
        pgrep $1 > /dev/null 2>&1
        if (( $? != 0 )); then
            break
        fi
        sleep 5
    done
}
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
wait_cmd yay
rm -rf /home/x/* || true
rm -rf /home/x/.* || true
rm -rf /tmp/* || true
