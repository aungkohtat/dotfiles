#!/usr/bin/env sh

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

POPUP_OFF="sketchybar --set github.bell popup.drawing=off"

update() {
  COUNT=$(gh api notifications --paginate 2>/dev/null | jq -r 'length' 2>/dev/null)
  if [ -z "$COUNT" ] || [ "$COUNT" = "0" ]; then
    sketchybar --set github.bell icon=$BELL \
                                 icon.color=$WHITE \
                                 label.drawing=off
  else
    sketchybar --set github.bell icon=$BELL_DOT \
                                 icon.color=$RED \
                                 label="$COUNT" \
                                 label.drawing=on
  fi
}

popup() {
  sketchybar --set github.bell popup.drawing=$1

  ITEMS=$(gh api notifications --paginate 2>/dev/null | jq -r '.[0:5] | .[] | .subject.title' 2>/dev/null)
  if [ -z "$ITEMS" ]; then
    return
  fi

  INDEX=0
  while IFS= read -r title; do
    sketchybar --clone "github.item.$INDEX" github.template \
               --set "github.item.$INDEX" label="$title" \
                                          drawing=on \
                                          position=popup.github.bell
    INDEX=$((INDEX + 1))
  done <<< "$ITEMS"
}

case "$SENDER" in
  "mouse.entered") popup on ;;
  "mouse.exited"|"mouse.exited.global") popup off ;;
  *) update ;;
esac
