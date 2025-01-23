#!/usr/bin/env bash
# Prompt the user for input via Wofi
PROMPT=$(wofi --dmenu --prompt "Ask ChatGPT:")
# Exit if no input is provided
[ -z "$PROMPT" ] && exit 0
# Get the ChatGPT response
RESPONSE=$(echo "$PROMPT" | /home/asura/.config/home-manager/wofi/chatgpt/wofi-chatgpt.py)
# Display the response via Wofi
echo -e "$RESPONSE" | wofi --dmenu --prompt "ChatGPT Response:"