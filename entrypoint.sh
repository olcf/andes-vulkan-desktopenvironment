#!/bin/bash

export DISPLAY=:1
set -ex

# Clean up stale X lock files and sockets
rm -f /tmp/.X1-lock
rm -rf /tmp/.X11-unix/X1

# Ensure directory exists and has correct permissions
mkdir -p /tmp/.X11-unix
#chmod 1777 /tmp/.X11-unix

# Start virtual framebuffer
Xvfb $DISPLAY -screen 0 1280x800x24 &

sleep 5
# Start xfce session
startxfce4 &

# Wait for xfce to start
sleep 5

# Start VNC server in foreground to keep container alive
exec x11vnc -display $DISPLAY -nopw -forever -rfbport 5901

