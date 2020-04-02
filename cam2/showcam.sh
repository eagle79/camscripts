#!/bin/bash

STREAM_URL="rtsp://[user]:[pwd]@[ip]:554/cam/realmonitor?channel=1&subtype=0"

VLC_PID=$(pidof /usr/bin/vlc)

if [ -z "$VLC_PID" ]; then
	vlc --fullscreen --loop --qt-minimal-view --no-qt-error-dialogs $STREAM_URL &
fi

