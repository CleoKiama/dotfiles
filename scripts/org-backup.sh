#!/bin/bash

REPO_DIR="/data/org"
FAIL_COUNT_FILE="$REPO_DIR/.git/push_fail_count"

cd "$REPO_DIR" || exit 1

notify() {
    if command -v notify-send > /dev/null 2>&1; then
        notify-send -u critical "Org Backup Failed" "$1" 2>/dev/null || true
    fi
}

is_online() {
    ping -c 1 -W 2 codeberg.org > /dev/null 2>&1
}

# Commit changes
if git status --porcelain | grep -q .; then
    COMMIT_MSG="Backup: $(date '+%Y-%m-%d %H:%M:%S %Z')"
    git add -A
    git commit -m "$COMMIT_MSG" > /dev/null 2>&1 || {
        notify "FATAL: Commit failed in $REPO_DIR"
        exit 1
    }
fi

UNPUSHED=$(git log origin/main..main --oneline 2>/dev/null | wc -l)

if [ "$UNPUSHED" -eq 0 ]; then
    rm -f "$FAIL_COUNT_FILE"
    exit 0
fi

if is_online; then
    if git push origin main > /dev/null 2>&1; then
        rm -f "$FAIL_COUNT_FILE"
        exit 0
    else
        FAIL_COUNT=$(cat "$FAIL_COUNT_FILE" 2>/dev/null || echo 0)
        FAIL_COUNT=$((FAIL_COUNT + 1))
        echo "$FAIL_COUNT" > "$FAIL_COUNT_FILE"

        if [ "$FAIL_COUNT" -ge 3 ]; then
            notify "Push failed $FAIL_COUNT times (online). Check Codeberg or SSH keys."
        fi
    fi
else
    FAIL_COUNT=$(cat "$FAIL_COUNT_FILE" 2>/dev/null || echo 0)
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo "$FAIL_COUNT" > "$FAIL_COUNT_FILE"

    if [ "$FAIL_COUNT" -ge 3 ]; then
        notify "Offline for $(($FAIL_COUNT * 2)) hours. $UNPUSHED commits waiting to push."
    fi
fi
