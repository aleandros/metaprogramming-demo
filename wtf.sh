#!/bin/bash

TARGET=$1

if [ -z "$TARGET" ] || ! (pgrep $TARGET &>/dev/null) ; then
    echo "Process not found"
    exit 1
fi

total_memory() {
    ps aux |                       # List everyt process using BSD syntax
	grep $TARGET |             # Filter matched processes
	grep -v grep |             # Ignore grep process
	awk '{ print $6 / 1024}' | # 6th column: RSS -> Resident Set Size in KB (non-swapped physical memory)
	paste -sd+ |               # Format column into infix sum notation
	bc                         # Sum total memory
}

most_memory() {
    ps aux --sort -%mem |
	sed -n 2p |
	awk '{print $11 " using at least " $4 "% of memory";}'
}

log_memory() {
    while true
    do
	echo "$(date),$(total_memory)" >> "$TARGET-memory.log"
	sleep 1
    done
}

notify_memory() {
    while true
    do
	notify-send "Watch out for $(most_memory)"
	sleep 3
    done
}

log_memory &
notify_memory
