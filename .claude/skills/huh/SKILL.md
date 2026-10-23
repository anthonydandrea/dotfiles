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
   `gh pr view <n> --repo <owner>/<repo> --json number,title,state,url,isDraft,body`
   Resolve `<owner>/<repo>` from `git remote get-url origin` or from the
   command that produced the number. Run these as separate parallel calls.
3. For each open PR, read its reviews, never the `reviewDecision` field, which
   GitHub leaves null unless branch protection requires a review:
   `gh api repos/<owner>/<repo>/pulls/<n>/reviews`
   Take each reviewer's latest review, ignoring bots and the PR author. The PR
   is approved when any of those is `APPROVED`. Run these in the same parallel
   batch as the `gh pr view` calls.
4. Find each PR's Slack post: the `<!-- agent-prs-post: <link> -->` comment in
   its body, else a post link this conversation recorded. Do not search Slack.
5. Do nothing else. No new investigation, no fixes, no code changes.

## Output

Exactly these six sections, in this order. Bullets only, one line each, no
preamble or closing remark.

```
**Closed PRs**
- [#123](https://github.com/<owner>/<repo>/pull/123) ([#agent-prs](<post link>)) <title>: merged | closed
- None

**Approved PRs**
- [#124](https://github.com/<owner>/<repo>/pull/124) ([#agent-prs](<post link>)) <title>: approved by <reviewer>, <reviewer>
- None

**Open PRs**
- [#125](https://github.com/<owner>/<repo>/pull/125) (none) <title>: open | draft
- None

**Working on**
<one sentence: the goal and where it stands>

**Testing**
- <what ran>: <pass | fail (why) | not run>
- None

**Next**
- <planned step>
- None
```

Rules:

- Every PR is a markdown link, never a bare `#123`.
- A PR line is one line: the link, the Slack post, the title, the state. The
  post shows as `(#<channel>)` linked to the post, or `(none)` when there is
  no post. A PR merged into
  another PR's branch rather than the default branch goes under Closed PRs
  with `merged into #<n>`.
- Approved PRs are open PRs with at least one human approval, as step 3
  defines it; they appear only there, not under Open PRs. Name each approver
  by GitHub login. Open PRs are the rest: unreviewed, changes requested, or
  draft.
- Testing lists only what actually ran in this session, with its result. A test
  that was planned but not run goes under Next, or as `not run`.
- Name specific commands, suites, or environments (`go test ./internal/loop`,
  `make lint`, "CI green on head"), not "ran tests".
- Next holds only steps the session or user actually stated, plus any blocker
  (failing check, awaiting review, waiting on the user). Mark a blocker
  `blocked:`.
- If the session has done nothing yet, say so in one line and stop.
