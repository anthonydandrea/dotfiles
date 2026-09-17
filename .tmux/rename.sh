#!/bin/zsh -fi
# Rename the current tmux window or session in a popup.
#
# tmux's command-prompt paints over the left of the status line and leaves the
# rest of it untouched, so the old window list sits immediately to the right of
# the cursor and every keystroke eats one more character of it. A popup is its
# own overlay, so the name being edited is the only text on the line.
#
# Called from .tmux.conf through run-shell, which is what expands the #{...}
# target: display-popup does not expand formats in the command it runs.
# Runs under `zsh -f` so a popup does not pay for .zshrc, and under `-i` so
# vared has zle and the prompt supports normal line editing.

scope=$1  # window or session
target=$2 # a window id for a window, a session name for a session

case $scope in
  window)  format='#W'; cmd=rename-window ;;
  session) format='#S'; cmd=rename-session ;;
  *) print -u2 "usage: rename.sh window|session <target>"; exit 2 ;;
esac

name=$(tmux display -p -t "$target" "$format")
vared -p "rename $scope: " name
[[ -n $name ]] && tmux "$cmd" -t "$target" -- "$name"
