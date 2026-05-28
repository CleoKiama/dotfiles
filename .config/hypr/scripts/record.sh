#!/usr/bin/env bash

getdate() {
    date '+%Y-%m-%d_%H.%M.%S'
}

getaudiooutput() {
    pactl list sources | grep 'Name' | grep 'monitor' | cut -d ' ' -f2
}

getactivemonitor() {
    hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name'
}

VIDEO_DIR="$(xdg-user-dir VIDEOS)"
mkdir -p "$VIDEO_DIR"
cd "$VIDEO_DIR" || exit 1

if pgrep wf-recorder > /dev/null; then
    notify-send "Recording Stopped" "Stopped" -a 'record-script.sh' &
    pkill wf-recorder &
else
    FILENAME="recording_$(getdate).mp4"
    notify-send "Starting recording" "$FILENAME" -a 'record-script.sh'

    case "$1" in
        --sound)
            wf-recorder \
                --pixel-format yuv420p \
                -f "$VIDEO_DIR/$FILENAME" \
                --geometry "$(slurp)" \
                --audio="$(getaudiooutput)" \
                & disown
            ;;
        --fullscreen-sound)
            wf-recorder \
                -o "$(getactivemonitor)" \
                --pixel-format yuv420p \
                -f "$VIDEO_DIR/$FILENAME" \
                --audio="$(getaudiooutput)" \
                & disown
            ;;
        --fullscreen)
            wf-recorder \
                -o "$(getactivemonitor)" \
                --pixel-format yuv420p \
                -f "$VIDEO_DIR/$FILENAME" \
                & disown
            ;;
        *)
            wf-recorder \
                --pixel-format yuv420p \
                -f "$VIDEO_DIR/$FILENAME" \
                --geometry "$(slurp)" \
                & disown
            ;;
    esac
fi

