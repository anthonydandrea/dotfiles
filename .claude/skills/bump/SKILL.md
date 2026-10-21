---
name: bump
description: Bump the user's open PRs in Slack. Lists the open PRs the user authored that this session made or discussed and that have a Slack post, confirms the exact messages, then replies "bump" in each confirmed thread. Use when the user invokes `/bump` or asks to bump their PRs in Slack.
---

# bump

Reply "bump" in the Slack thread of each open PR the user confirms. Nothing
else gets posted, and nothing goes out before the user confirms.

## 1. Find the candidates

Start from the PRs this session created, pushed to, or discussed, newest first.
Read them from the conversation, including any compaction summary. When the
session named none, fall back to the user's 10 most recently updated open PRs:

```bash
gh pr list --author @me --state open --limit 10 --json number,title,url,updatedAt
```

For each PR, check its live state:

```bash
gh pr view <n> --repo <owner>/<repo> --json number,title,url,state,isDraft,author,body
```

Keep a PR only when all four hold:
- It is open.
- The author is the user (compare against `gh api user -q .login`).
- No human has approved it. Read
  `gh api repos/<owner>/<repo>/pulls/<n>/reviews`, never `reviewDecision`. Take
  each reviewer's latest review, ignoring bots and the author. Any `APPROVED`
  drops the PR, because a review is what a bump asks for.
- It has a Slack post.

List each dropped PR in the confirmation with its reason (approved by whom, or
no Slack post), so the user sees why it is missing.

Drafts count as open. Resolve `<owner>/<repo>` from `git remote get-url origin`,
or from the command that produced the number.

## 2. Find each PR's Slack post

1. Look in the PR body for `<!-- agent-prs-post: <link> -->`, which `hark-ship`
   writes. Use that link as given.
2. Otherwise, search Slack for the PR URL with `slack_search_public_and_private`.
   Keep only messages the user posted or that tag them. If there are several,
   take the earliest top-level post, since that is the one reviewers watch.
3. If there is still no post, drop the PR and list it under "No Slack post" in
   the confirmation.

Turn a permalink into a thread target as follows:
- The channel is the `archives/<C…>` segment.
- The thread timestamp is the `p<digits>` segment with a dot inserted before
  the last six digits: `p1792539694079339` becomes `1792539694.079339`.
- If the link has a `thread_ts=` query parameter, the post is itself a reply.
  Use that value as the thread timestamp instead.

Read the post with `slack_read_thread` to confirm it exists and to see its last
reply. Skip a thread whose most recent reply is already the user's "bump" from
the last 24 hours, and say so.

## 3. Confirm

Show one table, then ask:

| # | PR | Channel | Posted | Message (first ~80 chars) | Last reply |
|---|---|---|---|---|---|

- Each PR goes out as a markdown link, never a bare `#123`.
- Show the permalink under the table.

Ask with `AskUserQuestion` using `multiSelect: true`, one option per PR, and
label each option with the PR number and a short title. An option takes at most
4 PRs. Past 4, ask in several questions of up to 4 each, in the same call. If
the user selects nothing, stop.

## 4. Reply

For each confirmed PR, call `slack_send_message` with the post's channel, its
thread timestamp as `thread_ts`, and the text `bump`. Send exactly that text:
no mention, no PR link, and no broadcast to the channel.

Then report one line per PR: the PR link and the reply's permalink, or the
error if it failed. Do not retry a failed send without asking.
