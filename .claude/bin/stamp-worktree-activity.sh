#!/usr/bin/env bash
# Claude Code hook: record "last active" for the git worktree a session works in.
# Writes a unix timestamp into <git-dir>/claude-last-active. The value lives in
# the file's contents, not its mtime, so a disk copy or restore cannot reset it.
# prune-worktrees.py reads it. Never fails the hook.

cwd=$(jq -r '.cwd // empty' 2>/dev/null)
[ -n "$cwd" ] || cwd=$PWD
gitdir=$(git -C "$cwd" rev-parse --absolute-git-dir 2>/dev/null) || exit 0
date +%s > "$gitdir/claude-last-active" 2>/dev/null
exit 0
