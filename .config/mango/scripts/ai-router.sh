#!/usr/bin/env bash
# AI Workspace Router for MangoWM
# Automatically routes browser windows with AI titles (ChatGPT, Claude, Gemini, DeepSeek) to Tag 6 (Tile layout)

mmsg watch focusing-client 2>/dev/null | while read -r line; do
    id=$(echo "$line" | jq -r '.id // empty' 2>/dev/null)
    title=$(echo "$line" | jq -r '.title // empty' 2>/dev/null)
    tags=$(echo "$line" | jq -r '.tags[] // empty' 2>/dev/null | tr '\n' ' ')

    if [[ -n "$id" && "$id" != "null" ]]; then
        if echo "$title" | grep -iqE '(gemini|claude|chatgpt|deepseek)'; then
            if [[ "$tags" != "6 " && "$tags" != "6" ]]; then
                mmsg dispatch tag,6 client,"$id" >/dev/null 2>&1
            fi
        fi
    fi
done
