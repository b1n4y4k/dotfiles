#!/usr/bin/env bash
# Hyprland Power Menu — gruvbox, text-only, no lock-on-escape

LOCK="  lock"
SLEEP="  sleep"
LOGOUT="  logout"
REBOOT="  reboot"
SHUTDOWN="  shutdown"

CHOICE=$(printf '%s\n' "$LOCK" "$SLEEP" "$LOGOUT" "$REBOOT" "$SHUTDOWN" \
  | wofi \
      --dmenu \
      --prompt "" \
      --width 180 \
      --height 240 \
      --style "$HOME/.config/wofi/powermenu.css" \
      --no-actions \
      --hide-search \
      --insensitive) || exit 0
# exit 0 on Esc — prevents fallthrough to any action

case "$CHOICE" in
  "$LOCK")     loginctl lock-session ;;
  "$SLEEP")    systemctl suspend ;;
  "$LOGOUT")   hyprctl dispatch exit 0 ;;
  "$REBOOT")   systemctl reboot ;;
  "$SHUTDOWN") systemctl poweroff ;;
esac
