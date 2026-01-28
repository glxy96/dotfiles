#!/bin/bash
# クロスプラットフォーム対応の通知音再生スクリプト

# macOS
if command -v afplay &> /dev/null; then
    afplay /System/Library/Sounds/Pop.aiff
# Linux (pulseaudio)
elif command -v paplay &> /dev/null; then
    paplay /usr/share/sounds/freedesktop/stereo/bell.oga 2>/dev/null || true
# Linux (ALSA)
elif command -v aplay &> /dev/null; then
    aplay /usr/share/sounds/alsa/Front_Center.wav 2>/dev/null || true
# WSL (Windowsのビープ音)
elif grep -qi microsoft /proc/version 2>/dev/null; then
    powershell.exe -c '[console]::beep(800,200)' 2>/dev/null || true
fi

exit 0
