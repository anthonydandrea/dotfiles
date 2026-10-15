#!/usr/bin/env python3
"""Remove git worktrees that are idle and safe to delete.

A worktree is removed only when every check passes:
  - it is not the main checkout and not locked (Claude locks a worktree while a session is open)
  - no running process has its working directory inside it
  - `git status` is clean (no modified or untracked files)
  - every commit on HEAD is on a remote, or its branch has a merged PR on GitHub
  - it has a claude-last-active stamp, so only worktrees a hooked Claude session used
    are ever removed (--include-unstamped lifts this for a one-off cleanup)
  - its last activity is older than --days, where last activity is the newest of:
      the claude-last-active stamp (stamp-worktree-activity.sh hook),
      the last HEAD reflog entry (checkout, commit, reset),
      the newest message in its Claude transcripts.
File mtimes are deliberately ignored: a disk copy or restore resets them.

Dry run by default. --apply removes worktrees (`git worktree remove`, never --force)
and prunes entries whose directory is already gone. Branches are never deleted.
"""
import argparse
import glob
import json
import os
import subprocess
import sys
import time
from datetime import datetime

GIT_TIMEOUT_S = 60
GH_TIMEOUT_S = 30
DAY_S = 86400
TRANSCRIPT_TAIL_LINES = 50
PROJECTS_DIR = os.path.expanduser("~/.claude/projects")


def git(*args: str, cwd: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(["git", "-C", cwd, *args], capture_output=True, text=True, timeout=GIT_TIMEOUT_S)


def parse_worktrees(repo: str) -> list[dict[str, str]]:
    out = git("worktree", "list", "--porcelain", cwd=repo)
    out.check_returncode()
    entries = []
    for block in out.stdout.strip().split("\n\n"):
        entry: dict[str, str] = {}
        for line in block.splitlines():
            key, _, value = line.partition(" ")
            entry[key] = value
        entries.append(entry)
    return entries


def process_cwds() -> list[str]:
    cwds = []
    for link in glob.glob("/proc/[0-9]*/cwd"):
        try:
            cwds.append(os.readlink(link))
        except OSError:
            pass
    if cwds:
        return cwds
    # macOS has no /proc; lsof prints one "n<path>" line per process cwd.
    out = subprocess.run(["lsof", "-d", "cwd", "-Fn"], capture_output=True, text=True, timeout=GIT_TIMEOUT_S)
    return [line[1:] for line in out.stdout.splitlines() if line.startswith("n")]


def stamp_time(gitdir: str) -> float:
    try:
        return float(open(os.path.join(gitdir, "claude-last-active")).read().strip())
    except (OSError, ValueError):
        return 0.0


def reflog_time(gitdir: str) -> float:
    try:
        last = open(os.path.join(gitdir, "logs", "HEAD"), errors="replace").read().strip().splitlines()[-1]
    except (OSError, IndexError):
        return 0.0
    # "<old> <new> Name <email> <unix-ts> <tz>\t<message>"
    return float(last.split("\t", 1)[0].split()[-2])


def transcript_time(worktree: str) -> float:
    project = os.path.join(PROJECTS_DIR, worktree.replace("/", "-").replace(".", "-"))
    newest = 0.0
    for path in glob.glob(os.path.join(project, "*.jsonl")):
        for raw in open(path, errors="replace").read().splitlines()[-TRANSCRIPT_TAIL_LINES:]:
            try:
                ts = json.loads(raw).get("timestamp")
            except (ValueError, AttributeError):
                continue
            if isinstance(ts, str):
                newest = max(newest, datetime.fromisoformat(ts.replace("Z", "+00:00")).timestamp())
    return newest


def has_merged_pr(worktree: str, branch: str) -> bool:
    try:
        out = subprocess.run(
            ["gh", "pr", "list", "--head", branch, "--state", "merged", "--json", "number", "--limit", "1"],
            cwd=worktree, capture_output=True, text=True, timeout=GH_TIMEOUT_S,
        )
    except (OSError, subprocess.TimeoutExpired):
        return False
    return out.returncode == 0 and out.stdout.strip() not in ("", "[]")


def skip_reason(entry: dict[str, str], cwds: list[str], cutoff: float, include_unstamped: bool) -> str | None:
    """Return why this worktree must be kept, or None when it is safe to remove."""
    wt = entry["worktree"]
    if "locked" in entry:
        return "locked"
    if any(c == wt or c.startswith(wt + "/") for c in cwds):
        return "process running inside"
    status = git("status", "--porcelain", cwd=wt)
    if status.returncode != 0:
        return f"git status failed: {status.stderr.strip()}"
    if status.stdout.strip():
        return f"{len(status.stdout.splitlines())} uncommitted changes"
    unpushed = git("rev-list", "--count", "HEAD", "--not", "--remotes", cwd=wt).stdout.strip()
    branch = entry.get("branch", "").removeprefix("refs/heads/")
    if unpushed not in ("", "0") and not (branch and has_merged_pr(wt, branch)):
        return f"{unpushed} commits not on any remote"
    gitdir = git("rev-parse", "--absolute-git-dir", cwd=wt).stdout.strip()
    stamp = stamp_time(gitdir)
    if not stamp and not include_unstamped:
        return "no activity stamp"
    last = max(stamp, reflog_time(gitdir), transcript_time(wt))
    if last >= cutoff:
        return f"active {(time.time() - last) / DAY_S:.1f}d ago"
    return None


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--repo", default="/mnt/hark/hark/mvp", help="main checkout of the repository")
    parser.add_argument("--days", type=float, default=5, help="idle days before a worktree is removed")
    parser.add_argument("--apply", action="store_true", help="remove worktrees (default is a dry run)")
    parser.add_argument(
        "--include-unstamped", action="store_true",
        help="also consider worktrees with no activity stamp (one-off cleanup of pre-hook worktrees)",
    )
    args = parser.parse_args()

    cutoff = time.time() - args.days * DAY_S
    entries = parse_worktrees(args.repo)
    cwds = process_cwds()
    mode = "APPLY" if args.apply else "DRY RUN"
    print(f"{datetime.now():%Y-%m-%d %H:%M} {mode}: {len(entries) - 1} worktrees, idle cutoff {args.days:g} days")

    removed = kept = missing = 0
    for entry in entries[1:]:
        wt = entry["worktree"]
        if "bare" in entry:
            continue
        if not os.path.isdir(wt):
            missing += 1
            print(f"  prune   {wt} (directory gone)")
            continue
        reason = skip_reason(entry, cwds, cutoff, args.include_unstamped)
        if reason:
            kept += 1
            print(f"  keep    {wt} ({reason})")
            continue
        if args.apply:
            result = git("worktree", "remove", wt, cwd=args.repo)
            if result.returncode != 0:
                kept += 1
                print(f"  FAILED  {wt}: {result.stderr.strip()}")
                continue
        removed += 1
        print(f"  remove  {wt}")

    if args.apply and missing:
        git("worktree", "prune", cwd=args.repo).check_returncode()
    verb = "removed" if args.apply else "would remove"
    print(f"{verb} {removed}, kept {kept}, dead entries {'pruned' if args.apply else 'to prune'} {missing}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
