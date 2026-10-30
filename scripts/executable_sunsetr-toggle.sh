#!/usr/bin/env bash
# Toggle between day neutral preset and default warm preset

if [ "$(sunsetr preset active 2>/dev/null)" = "day" ]; then
    sunsetr preset default
else
    sunsetr preset day
fi
