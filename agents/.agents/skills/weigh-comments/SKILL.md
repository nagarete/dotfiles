---
name: weigh-comments
description: Weigh teammates' PR review comments against the code and draft replies for the user to send. Use when the user asks for thoughts on someone's comment, or whether a reviewer is right.
---

A teammate's comment gets a **verdict** from the code, and the user decides what goes back to them. Nothing is posted from this skill unless the user explicitly says to post it.

## 1. Gather

Take the PR from the request, else the current branch's PR. Fetch its review threads with their resolved state:

```sh
gh api graphql -f query='query($o:String!,$r:String!,$n:Int!){repository(owner:$o,name:$r){pullRequest(number:$n){headRefOid reviewThreads(first:100){nodes{isResolved isOutdated path line comments(first:20){nodes{author{login} body createdAt url}}}} comments(first:100){nodes{author{login} body createdAt url}} reviews(first:50){nodes{author{login} state body submittedAt}}}}}' -F o=<owner> -F r=<repo> -F n=<number>
```

Keep comments from people: drop bots (CodeRabbit, Greptile, Macroscope, `[bot]` logins). When the user names someone, keep theirs; otherwise keep the unresolved ones and anything newer than the latest push.

Done when you have a list of comments, each with its author, file and line, and URL.

## 2. Verdict

For each comment, check its claim against the code at the PR head: open the file, follow the call, run the case it describes when you can. Give each one a verdict:

- **Right**: the problem is real. Say what breaks and for whom.
- **Partly right**: name the part that holds and the part that does not.
- **Wrong**: show the code or output that answers it.
- **Taste**: no correctness stake; give your lean and why.

Done when every comment has a verdict with the evidence behind it, and the claims you could not confirm say so.

## 3. Report

Per comment, in chat: the author and a one-line quote, the verdict, the evidence, and the action you propose: fix it in this PR, a follow-up (a Linear ticket under the `ticket` skill's follow-up rule), or no change. Under each, draft the reply in the user's voice, following `leaving-pr-comments`. Keep it short, conclusion first; for a _Wrong_ verdict, explain kindly, citing the code.

Then stop and wait for the user.

## 4. Act on the user's word

- **Fix**: make the change, push, and reply on the thread only if the user asks.
- **Follow-up**: file the ticket, and add it to the PR description's follow-ups.
- **Post**: post exactly the replies the user approved, as edited, with `leaving-pr-comments`.
