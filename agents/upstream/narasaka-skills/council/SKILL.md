---
name: council
description: Trigger this if the user says 'council'.
---

# Council

Before an audit, address outstanding PR comments, fix known issues, and run
relevant checks. Give council the updated implementation; do not defer known
fixes until reviews return. If the user wants to discard the implementation
and explore new ideas, skip fixes to code being replaced.

Bring in three delegates to help with the user's request, usually for review
or feedback, at high reasoning effort. The user has two subscriptions, OpenAI
(Codex) and Anthropic (Claude), so the council spans those two providers. If
the user's instructions name council members, use those. Otherwise the
council is exactly these three:

- **GPT-6.1 Sol** (`gpt-6.1-sol`), on the Codex provider.
- **GPT-6 Astra** (`gpt-6-astra`), on the Codex provider.
- **Claude Fable 5.2** (`claude-fable-5-2`), on a Claude provider.

Never use Google or Gemini models. Never reach a model through another
provider (OpenCode, Bedrock, Grok, Cursor, and so on), even when it lists
the same model.

In T3 Code, confirm these IDs with `orchestrator_capabilities`, then
`delegate_task` to start one delegate per model in parallel. Elsewhere, use
the harness's subagent tools. If a member is unavailable, report it instead
of substituting.

Match accounts. The user has Personal and Work accounts, and instance IDs
differ between machines, so never pick an instance by its ID alone. In
`orchestrator_capabilities`, find the instance named by
`inheritedProviderInstanceId` and read its `displayName` ("Personal" or
"Work"). Run every delegate on the Claude and Codex instances with that same
`displayName`. Never cross accounts. If the parent's account is unclear, or a
matching instance is missing or disabled, report it and ask. Do not fall back
to the other account.

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
| GPT-6.1 Sol | 8/10 | 10/10 |
| GPT-6 Astra | 7/10 | 9/10 |
| Claude Fable 5.2 | 7/10 | 9/10 |
```

If a delegate gives no score, write `no score`. Do not invent one.
Never put council results, model names, or review scores in a PR
description, PR comment, or commit message.

If you agree with their recommendations, make the changes and request a fresh
review after. Continue this process until all delegates are satisfied with the
outcome.

Do not let repeated reviews result in scope creep. It is your job to fight to
keep scope limited.
