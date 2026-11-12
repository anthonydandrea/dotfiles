#!/usr/bin/env python3
"""Arrange the current tmux window's panes into an even grid.

Panes fill columns left to right, top to bottom, in pane-index order. The
grid is as square as the pane count allows, and when the count does not fill
it, the left columns take the extra pane:

    2 panes: side by side          3 panes: two stacked left, one right
    4 panes: 2 x 2                 5 panes: 2 + 2 + 1 across three columns

tmux's built-in `tiled` layout fills rows instead, which puts three panes as
two on top and one full-width below, so this builds its own layout string.

Usage: even_layout.py [target-window]
"""
import math
import subprocess
import sys


def tmux(*args):
    return subprocess.check_output(("tmux",) + args).decode().strip()


def split_evenly(total, parts):
    """Split `total` cells into `parts` sizes, leaving one cell per border."""
    usable = total - (parts - 1)
    base, extra = divmod(usable, parts)
    return [base + (1 if i < extra else 0) for i in range(parts)]


def column_sizes(pane_count):
    """Return how many panes each column holds, larger columns first."""
    columns = math.ceil(math.sqrt(pane_count))
    base, extra = divmod(pane_count, columns)
    return [base + (1 if i < extra else 0) for i in range(columns)]


def build_layout(pane_ids, width, height):
    """Return the tmux layout body (without its checksum) for the grid."""
    remaining = list(pane_ids)
    cells = []
    x = 0
    counts = column_sizes(len(pane_ids))
    for column_width, count in zip(split_evenly(width, len(counts)), counts):
        panes = []
        y = 0
        for pane_height in split_evenly(height, count):
            pane_id = remaining.pop(0)
            panes.append(f"{column_width}x{pane_height},{x},{y},{pane_id}")
            y += pane_height + 1
        if count == 1:
            cells.append(panes[0])
        else:
            cells.append(f"{column_width}x{height},{x},0[{','.join(panes)}]")
        x += column_width + 1
    if len(cells) == 1:
        return cells[0]
    return f"{width}x{height},0,0{{{','.join(cells)}}}"


def checksum(layout):
    """tmux's layout checksum: a 16-bit rotate-right-and-add over the body."""
    total = 0
    for char in layout:
        total = (total >> 1) + ((total & 1) << 15)
        total = (total + ord(char)) & 0xFFFF
    return f"{total:04x}"


def main():
    target = sys.argv[1] if len(sys.argv) > 1 else tmux("display-message", "-p", "#{window_id}")
    width, height = map(int, tmux("display-message", "-p", "-t", target, "#{window_width} #{window_height}").split())
    rows = tmux("list-panes", "-t", target, "-F", "#{pane_id} #{pane_floating_flag}").splitlines()
    # Floating panes sit above the grid and are not part of the tiled layout.
    pane_ids = [row.split()[0].lstrip("%") for row in rows if not row.endswith(" 1")]
    if len(pane_ids) < 2:
        return
    layout = build_layout(pane_ids, width, height)
    tmux("select-layout", "-t", target, f"{checksum(layout)},{layout}")


if __name__ == "__main__":
    main()
