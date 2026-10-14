#!/usr/bin/env bash
# Fork a Claude Code session into a new tmux pane beside the current one.
# usage: tfork.sh [session-id]   (defaults to $CLAUDE_CODE_SESSION_ID)
# The fork resumes the conversation under a new session id, in the same
# directory, with the parent's permission flags. TFORK_SPLIT=v splits vertically.
set -euo pipefail

id="${1:-}"
[[ "$id" =~ ^[0-9a-f-]{36}$ ]] || id="${CLAUDE_CODE_SESSION_ID:-}"
if [ -z "$id" ]; then
  echo "tfork: no session id (pass one, or run inside Claude Code)" >&2
  exit 2
fi
if [ -z "${TMUX:-}" ]; then
  echo "tfork: not inside tmux" >&2
  exit 2
fi

# Carry over how the parent was started: skipped permissions or a set mode.
flags=()
if [ -n "${CLAUDE_PID:-}" ]; then
  read -r -a parent < <(ps -o args= -p "$CLAUDE_PID" 2>/dev/null || true)
  for i in "${!parent[@]}"; do
    case "${parent[$i]}" in
      --dangerously-skip-permissions) flags+=("${parent[$i]}") ;;
      --permission-mode | --model) flags+=("${parent[$i]}" "${parent[$((i + 1))]:-}") ;;
    esac
  done
fi

cmd="claude --resume $id --fork-session"
for f in "${flags[@]+"${flags[@]}"}"; do cmd+=" $(printf '%q' "$f")"; done

split=-h
[ "${TFORK_SPLIT:-h}" = v ] && split=-v
pane=$(tmux split-window "$split" ${TMUX_PANE:+-t "$TMUX_PANE"} -c "$PWD" -P -F '#{pane_id}' "$cmd; exec \$SHELL")
echo "Forked session $id into tmux pane $pane"
