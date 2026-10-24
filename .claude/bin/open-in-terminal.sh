#!/usr/bin/env bash
# Hand an interactive command to a terminal the human can see and type into.
# Inside tmux: a new pane (or window, with CLAUDE_TERM_TMUX_MODE=window).
# Outside tmux: a new iTerm2 window. Falls back to Terminal.app.
# Override detection with CLAUDE_TERM=tmux|iterm|terminal.
set -euo pipefail

cmd="$*"
if [ -z "$cmd" ]; then
  echo "usage: open-in-terminal.sh <command...>" >&2
  exit 2
fi

work="$PWD"
script="$(mktemp "${TMPDIR:-/tmp}/claude-run.XXXXXXXX")"
{
  printf '#!/usr/bin/env bash\n'
  printf 'cd %q || exit 1\n' "$work"
  printf 'printf "\\033[1;36m$ %%s\\033[0m\\n\\n" %q\n' "$cmd"
  printf '%s\n' "$cmd"
  printf 'status=$?\n'
  printf 'printf "\\n\\033[2m[exit %%s] press enter to close\\033[0m" "$status"\n'
  printf 'read -r _\n'
  printf 'rm -f -- "$0"\n'
} > "$script"
chmod +x "$script"

target="${CLAUDE_TERM:-auto}"
if [ "$target" = auto ]; then
  if [ -n "${TMUX:-}" ]; then target=tmux
  elif [ -d /Applications/iTerm.app ]; then target=iterm
  else target=terminal
  fi
fi

case "$target" in
  tmux)
    # Target the pane this session runs in ($TMUX_PANE), so the new pane or
    # window lands beside the requesting Claude session, not in whichever
    # window the client happens to have active.
    here="${TMUX_PANE:-}"
    if [ "${CLAUDE_TERM_TMUX_MODE:-pane}" = window ]; then
      tmux new-window -a ${here:+-t "$here"} -c "$work" "$script"
    else
      tmux split-window -h ${here:+-t "$here"} -c "$work" "$script"
    fi
    echo "Opened tmux ${CLAUDE_TERM_TMUX_MODE:-pane}: $cmd"
    ;;
  iterm)
    osascript - "$script" <<'APPLESCRIPT' >/dev/null
on run argv
  set s to item 1 of argv
  tell application "iTerm"
    if it is not running then
      run
      delay 0.4
      set w to current window
    else
      set w to (create window with default profile)
    end if
    tell current session of w to write text s
    activate
  end tell
end run
APPLESCRIPT
    echo "Opened a new iTerm2 window: $cmd"
    ;;
  *)
    open -a Terminal "$script"
    echo "Opened a new Terminal.app window: $cmd"
    ;;
esac
