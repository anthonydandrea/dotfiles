#!/bin/sh
# Flag this Claude session's tmux window as waiting for input (set) or not (clear).
# The status bar paints flagged windows yellow; see @claude_waiting in ~/.tmux.conf.
[ -n "$TMUX_PANE" ] || exit 0
case "$1" in
  set)
    # A Stop with background agents/shells still running isn't waiting on me:
    # Claude resumes on its own when they finish.
    [ "$(jq '[.background_tasks[]? | select(.status == "running")] | length' 2>/dev/null)" = 0 ] || exit 0
    # Skip if I'm already looking at this window.
    [ "$(tmux display -p -t "$TMUX_PANE" '#{&&:#{window_active},#{session_attached}}')" = 1 ] && exit 0
    tmux set -w -t "$TMUX_PANE" @claude_waiting 1 ;;
  clear)
    tmux set -wu -t "$TMUX_PANE" @claude_waiting ;;
esac
exit 0
