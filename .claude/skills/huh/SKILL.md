---
name: huh
description: Catch the user up on this Claude Code session in a few lines: what it is working on, the PRs it opened or touched, what testing ran, and what is planned next. Use when the user invokes `/huh`, or asks "where are we", "catch me up", "what is this session doing", or "what did you do so far".
---

# huh

The user is returning to this session cold. Give them the shortest summary that
lets them pick it back up. Build it from this session's own conversation
(including any compaction summary), not from guesses about the repo.

## Gather

1. Reread the conversation for: the goal, PRs created or pushed to, test and
   check commands that actually ran (with their result), and stated next steps.
2. For each PR found, fetch its live state, since it may have changed since it
   was last mentioned:
   `gh pr view <n> --repo <owner>/<repo> --json number,title,state,url,isDraft`
   Resolve `<owner>/<repo>` from `git remote get-url origin` or from the
   command that produced the number. Run these in parallel.
3. Do nothing else. No new investigation, no fixes, no code changes.

## Output

Exactly these four sections, in this order. Bullets only, one line each, no
preamble or closing remark.

```
**Working on**
<one sentence: the goal and where it stands>

**PRs**
- [#123](https://github.com/<owner>/<repo>/pull/123) <title>: merged | open | draft | closed
- None

**Testing**
- <what ran>: <pass | fail (why) | not run>
- None

**Next**
- <planned step>
- None
```

Rules:

- Every PR is a markdown link, never a bare `#123`. Open PRs first, then merged.
- Testing lists only what actually ran in this session, with its result. A test
  that was planned but not run goes under Next, or as `not run`.
- Name specific commands, suites, or environments (`go test ./internal/loop`,
  `make lint`, "CI green on head"), not "ran tests".
- Next holds only steps the session or user actually stated, plus any blocker
  (failing check, awaiting review, waiting on the user). Mark a blocker
  `blocked:`.
- If the session has done nothing yet, say so in one line and stop.
