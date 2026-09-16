#!/usr/bin/env bash
# Claude Code status line. Two rows:
#   row 1  repo [wt:name]  branch ✱dirty ↑ahead ↓behind   «session»   PR #n ✓
#   row 2  Model 1M · effort   ████░░░░ 38%   $4.21  1h12m
#
# Reads the session JSON on stdin (see `claude` docs: statusline). Runs on every
# assistant message, so every branch here stays cheap: one jq pass, one git call.
# Written for bash 3.2 (macOS /bin/bash) — no mapfile, no associative arrays.

set -u

input=$(cat)

# --- One jq pass, newline-separated so an empty value stays an empty line. ---
# Successive `read`s beat @tsv here: read drops trailing empty TSV fields.
{
  read -r MODEL
  read -r CTX_SIZE
  read -r EFFORT
  read -r FAST
  read -r CTX_PCT
  read -r COST
  read -r DUR_MS
  read -r CWD
  read -r REPO
  read -r WORKTREE
  read -r SESSION
  read -r PR_NUM
  read -r PR_STATE
} <<EOF
$(printf '%s' "$input" | jq -r '
  def clean: (. // "") | tostring | gsub("[\n\t]"; " ");
  [ (.model.display_name | clean),
    (.context_window.context_window_size // 0 | tostring),
    (.effort.level | clean),
    (if .fast_mode then "1" else "" end),
    (.context_window.used_percentage // "" | tostring),
    (.cost.total_cost_usd // 0 | tostring),
    (.cost.total_duration_ms // 0 | tostring),
    (.workspace.current_dir | clean),
    (.workspace.repo.name | clean),
    ((.worktree.name // .workspace.git_worktree) | clean),
    (.session_name | clean),
    (.pr.number | clean),
    (.pr.review_state | clean)
  ] | .[]' 2>/dev/null)
EOF

# --- Colors. Skip them entirely when NO_COLOR is set or the terminal is dumb. ---
if [ -n "${NO_COLOR:-}" ] || [ "${TERM:-dumb}" = "dumb" ]; then
  R= B= D= CY= GN= YL= RD= MG= BL=
else
  R=$'\033[0m'; B=$'\033[1m'; D=$'\033[2m'
  CY=$'\033[36m'; GN=$'\033[32m'; YL=$'\033[33m'
  RD=$'\033[31m'; MG=$'\033[35m'; BL=$'\033[34m'
fi

COLS=${COLUMNS:-100}

# --- Git: one porcelain=v2 call yields branch, ahead/behind, and dirty count. ---
# --no-optional-locks keeps the status line from fighting a concurrent git for
# the index lock. If this ever feels slow in a huge tree, add -uno to drop the
# untracked scan (you lose new-file counts, you keep the rest).
BRANCH=""; AHEAD=0; BEHIND=0; DIRTY=0
if [ -n "$CWD" ] && cd "$CWD" 2>/dev/null; then
  git_out=$(git --no-optional-locks status --porcelain=v2 --branch 2>/dev/null)
  if [ -n "$git_out" ]; then
    eval "$(printf '%s\n' "$git_out" | awk '
      $1 == "#" && $2 == "branch.head" { head = $3 }
      $1 == "#" && $2 == "branch.ab"   { a = substr($3, 2); b = substr($4, 2) }
      $1 == "1" || $1 == "2" || $1 == "u" || $1 == "?" { dirty++ }
      END {
        gsub(/'\''/, "", head)
        printf "BRANCH=%s\nAHEAD=%d\nBEHIND=%d\nDIRTY=%d\n",
               "'\''" head "'\''", a + 0, b + 0, dirty + 0
      }')"
  fi
fi

# --- Row 1: where am I ---
[ -z "$REPO" ] && REPO=$(basename "${CWD:-$PWD}")
row1="${B}${CY}${REPO}${R}"

[ -n "$WORKTREE" ] && row1="${row1} ${MG}[wt:${WORKTREE}]${R}"

if [ -n "$BRANCH" ]; then
  if [ "$BRANCH" = "(detached)" ]; then
    row1="${row1}  ${YL}(detached)${R}"
  else
    row1="${row1}  ${GN}${BRANCH}${R}"
  fi
  [ "$DIRTY"  -gt 0 ] && row1="${row1} ${YL}✱${DIRTY}${R}"
  [ "$AHEAD"  -gt 0 ] && row1="${row1} ${CY}↑${AHEAD}${R}"
  [ "$BEHIND" -gt 0 ] && row1="${row1} ${CY}↓${BEHIND}${R}"
fi

# Session name only earns its space on a wide pane.
if [ -n "$SESSION" ] && [ "$COLS" -ge 90 ]; then
  row1="${row1}   ${D}«${SESSION}»${R}"
fi

if [ -n "$PR_NUM" ]; then
  case "$PR_STATE" in
    approved)          pr_mark="${GN}✓${R}" ;;
    changes_requested) pr_mark="${RD}●${R}" ;;
    pending)           pr_mark="${YL}◐${R}" ;;
    draft)             pr_mark="${D}○${R}" ;;
    *)                 pr_mark="" ;;
  esac
  row1="${row1}   ${BL}PR #${PR_NUM}${R}"
  [ -n "$pr_mark" ] && row1="${row1} ${pr_mark}"
fi

# --- Row 2: what is this session costing me ---
# Trust display_name for the model, and append 1M only when the window is
# actually extended — that distinction is invisible in the name alone.
row2="${B}${MODEL}${R}"
[ "${CTX_SIZE:-0}" -ge 1000000 ] 2>/dev/null && row2="${row2} ${D}1M${R}"
[ -n "$EFFORT" ] && row2="${row2} ${D}· ${EFFORT}${R}"
[ -n "$FAST" ]   && row2="${row2} ${YL}⚡${R}"

# used_percentage is null until the first API response and again after /compact.
if [ -n "$CTX_PCT" ] && [ "$CTX_PCT" != "null" ]; then
  pct=${CTX_PCT%%.*}
  [ -z "$pct" ] && pct=0
  if   [ "$pct" -ge 85 ]; then bar_c=$RD
  elif [ "$pct" -ge 70 ]; then bar_c=$YL
  else                         bar_c=$GN
  fi

  if   [ "$COLS" -ge 100 ]; then width=16
  elif [ "$COLS" -ge 70 ];  then width=10
  else                           width=0
  fi

  if [ "$width" -gt 0 ]; then
    filled=$(( pct * width / 100 ))
    [ "$filled" -gt "$width" ] && filled=$width
    bar=""
    i=0; while [ $i -lt $filled ];          do bar="${bar}█"; i=$((i+1)); done
    i=$filled; while [ $i -lt $width ];     do bar="${bar}░"; i=$((i+1)); done
    row2="${row2}   ${bar_c}${bar}${R} ${bar_c}${pct}%${R}"
  else
    row2="${row2}   ${bar_c}${pct}%${R}"
  fi
else
  row2="${row2}   ${D}—${R}"
fi

printf -v cost_s '%.2f' "${COST:-0}" 2>/dev/null || cost_s="0.00"
row2="${row2}   ${D}\$${cost_s}${R}"

secs=$(( ${DUR_MS:-0} / 1000 ))
if   [ "$secs" -ge 3600 ]; then dur="$((secs/3600))h$(( (secs%3600)/60 ))m"
elif [ "$secs" -ge 60 ];   then dur="$((secs/60))m"
else                            dur="${secs}s"
fi
row2="${row2}  ${D}${dur}${R}"

printf '%s\n%s\n' "$row1" "$row2"
