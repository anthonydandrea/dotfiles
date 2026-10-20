#!/bin/sh
# Animate the spinner next to every tmux window where Claude Code is working.
#
# Started by tmux-waiting.sh when a window is flagged @claude_busy. One copy
# runs per tmux server: it cycles the global @claude_spin glyph a few times a
# second and redraws each client's status line, then exits once no window is
# busy any more. tmux re-runs #() output at most once per status-interval
# (whole seconds), which is why the frames come from outside tmux.
FRAMES='⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏'
FRAME_SECONDS=0.12

socket=${TMUX%%,*}
[ -n "$socket" ] || exit 0
lock="${socket}.claude-spinner"

# mkdir is atomic, so two hooks firing together start one driver. A lock
# left by a killed driver names a dead pid and is taken over.
take_lock() {
  if mkdir "$lock" 2>/dev/null; then
    echo $$ > "$lock/pid"
    return 0
  fi
  if kill -0 "$(cat "$lock/pid" 2>/dev/null)" 2>/dev/null; then
    return 1
  fi
  rm -f "$lock/pid" && rmdir "$lock" 2>/dev/null && mkdir "$lock" 2>/dev/null || return 1
  echo $$ > "$lock/pid"
}
take_lock || exit 0
trap 'rm -f "$lock/pid"; rmdir "$lock" 2>/dev/null; tmux set -gu @claude_spin 2>/dev/null' EXIT INT TERM

any_busy() {
  tmux list-windows -a -F '#{@claude_busy}' 2>/dev/null | grep -q 1
}

while any_busy; do
  for glyph in $FRAMES; do
    # One tmux invocation per frame: set the glyph, then redraw every
    # attached client's status line. Built as argv, since tmux only splits
    # commands on a bare ";" argument.
    set -- set -g @claude_spin "$glyph"
    for client in $(tmux list-clients -F '#{client_name}' 2>/dev/null); do
      set -- "$@" \; refresh-client -S -t "$client"
    done
    tmux "$@" 2>/dev/null || exit 0
    sleep "$FRAME_SECONDS"
  done
done
