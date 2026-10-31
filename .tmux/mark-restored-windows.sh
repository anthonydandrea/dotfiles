#!/bin/sh
# Re-mark hand-named windows after tmux-resurrect restores them.
#
# resurrect brings back every window's name but no user option, so the
# @manual_name mark that rename.sh sets is gone after a restore, and the shell
# hooks in .zshrc rename the window on its next command (a dev box resumes
# Claude Code in each pane, so every such window came back as "claude").
#
# This runs as resurrect's pre-restore-pane-processes hook: the names are
# already restored and no pane has run a command yet. A window whose name is
# neither what the hooks would have chosen (the active pane's directory) nor
# its shell's name was named by hand, so it gets the mark back.
tab="$(printf '\t')"
tmux list-windows -a -F "#{window_id}${tab}#{window_name}${tab}#{b:pane_current_path}${tab}#{pane_current_command}" |
	while IFS="$tab" read -r id name dir command; do
		[ "$name" = "$dir" ] && continue
		[ "$name" = "$command" ] && continue
		tmux set -w -t "$id" @manual_name 1
	done
