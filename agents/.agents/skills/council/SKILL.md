---
name: council
description: Trigger this if the user says 'council'.
---

<!-- Claude-only variant of narasaka/skills `council` (upstream af84c86).
     The upstream uses two Codex reviewers; we have no Codex subscription.
     Original: ~/dotfiles/agents/upstream/narasaka-skills/council. See ~/dotfiles/agents/README.md. -->

# Council

Before an audit, address outstanding PR comments, fix known issues, and run
relevant checks. Give council the updated implementation; do not defer known
fixes until reviews return. If the user wants to discard the implementation
and explore new ideas, skip fixes to code being replaced.

Bring in two delegates to help with the user's request, usually for review
or feedback. The user has only an Anthropic (Claude) subscription. Two Claude
models share more blind spots than models from two providers, so the council
gets its spread from giving each delegate a different lens rather than from
more seats. If the user's instructions name council members, use those.
Otherwise the council is exactly these two:

- **Claude Fable 5.2** (`claude-fable-5-2`), effort `low`. Lens:
  correctness. Bugs, broken callers, and edge cases in the intended use.
- **Claude Sonnet 5.5** (`claude-sonnet-5-5`), effort `high`. Lens: intent
  and scope. Does the change do what was asked, is anything unneeded, would a
  reader follow it.

For security, permissions, auth, data loss, or state/concurrency changes,
raise Fable to `high`. Never raise Sonnet past `high`: on Artificial Analysis
(2026-11), Sonnet `xhigh` and `max` cost more than Fable `low` and score below
it. Skip Fable `medium`: it adds little over `low` for more cost. Opus is left
out because it usually wrote the code under review.

Put the lens in each delegate's brief, but let either report any real bug.

Never use non-Anthropic models, and never reach a Claude model through
another provider (OpenCode, Bedrock, Cursor, and so on), even when it lists
the same model.

In T3 Code, confirm these IDs with `orchestrator_capabilities`, then
`delegate_task` to start one delegate per model in parallel, on the same
Claude provider instance as yours (`inheritedProviderInstanceId`). Elsewhere,
use the harness's subagent tools (in Claude Code, the `Agent` tool with
`model` and `effort` set). If a member is unavailable, report it instead of
substituting.

Give each delegate the request and relevant context. For review or feedback,
keep their work read-only. Collect their responses and summarize the useful
findings, disagreements, and recommended next steps.

For a code review, ask each delegate for a score out of 10.
Count each full review pass as one round.
A fresh review after fixes starts a new round.

Report the results in your final reply only:

```markdown
## Council review

Rounds: 2

| Delegate | Round 1 | Round 2 |
| --- | --- | --- |
| Claude Fable 5.2 | 8/10 | 10/10 |
| Claude Sonnet 5.5 | 7/10 | 9/10 |
```

If a delegate gives no score, write `no score`. Do not invent one.
Never put council results, model names, or review scores in a PR
description, PR comment, or commit message.

If you agree with their recommendations, make the changes and request a fresh
review after. Continue this process until all delegates are satisfied with the
outcome.

Do not let repeated reviews result in scope creep. It is your job to fight to
keep scope limited.
