#!/bin/sh
# Flag this Claude session's tmux window in the status bar.
#   busy  Claude is working: the window name turns blue with a spinner.
#   set   Claude stopped and needs me: the window turns yellow until visited.
#   off   The session ended: no flag at all.
# The bar reads @claude_busy and @claude_waiting; see ~/.tmux.conf. The spinner
# frames come from ~/.claude/bin/tmux-spinner.sh, started here when needed.
[ -n "$TMUX_PANE" ] || exit 0
case "$1" in
  busy|clear)
    tmux set -wu -t "$TMUX_PANE" @claude_waiting \; set -w -t "$TMUX_PANE" @claude_busy 1
    # Detached so the hook returns at once; the driver exits on its own when
    # no window is busy, and a second start is a no-op while one runs.
    if command -v setsid >/dev/null 2>&1; then
      setsid nohup ~/.claude/bin/tmux-spinner.sh >/dev/null 2>&1 </dev/null &
    else
      nohup ~/.claude/bin/tmux-spinner.sh >/dev/null 2>&1 </dev/null &
    fi ;;
  set)
    # A Stop with background agents/shells still running isn't waiting on me:
    # Claude resumes on its own when they finish, so the window stays busy.
    [ "$(jq '[.background_tasks[]? | select(.status == "running")] | length' 2>/dev/null)" = 0 ] || exit 0
    tmux set -wu -t "$TMUX_PANE" @claude_busy
    # Skip the yellow if I'm already looking at this window.
    [ "$(tmux display -p -t "$TMUX_PANE" '#{&&:#{window_active},#{session_attached}}')" = 1 ] && exit 0
    tmux set -w -t "$TMUX_PANE" @claude_waiting 1 ;;
  off)
    tmux set -wu -t "$TMUX_PANE" @claude_busy \; set -wu -t "$TMUX_PANE" @claude_waiting ;;
esac
exit 0
