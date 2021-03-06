#!/bin/bash

TARGET=$1

if ! (pgrep $TARGET &>/dev/null) ; then
    echo "Process not found"
    exit 1
fi

most_memory() {
    ps aux --sort -%mem |
	sed -n 2p |
	awk '{print $11; print $4}' |
	paste -sd,
}

log_memory() {
    while true
    do
	echo "$(date),$(most_memory)%" >> "most-memory.log"
	sleep 2
    done
}

log_memory &

while true
do
    echo "$(pgrep $TARGET | wc -l) processes for $TARGET running"
    sleep 1
done
