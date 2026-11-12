---
name: choosing-claude-models
description: Picks the Claude model and effort level for a task. Use when choosing a model for a session, subagent or API call, when setting effort, or when a model's results fall short.
---

# Choosing a Claude model

Start on **Opus 5.5 at `medium`**. Move to another model when the task matches a line below.

## By task

- **Haiku 5.5**: classification, routing, tagging, high-volume extraction, simple chat at volume.
- **Haiku or Sonnet 5.5** (subagents): searching files, reading logs, summarizing. Wrong answers are cheap to spot, and the main model keeps the judgment calls.
- **Sonnet 5.5**: well-scoped coding (bug fixes, building to a spec), chat and interactive sessions, everyday documents and slides, repeated agent tasks (investigating, reviewing, drafting).
- **Opus 5.5**: everyday engineering, debugging, features spanning several PRs, computer use, vision-heavy work, complex financial models.
- **Fable 5.2**: major refactors and migrations, architecture planning, leading many subagents, deep research, scientific or quantitative analysis, long unattended runs.

Judge by how hard the task is. How clear the spec is doesn't decide it: a migration or a performance fix can have a clean spec and still need Opus, or Fable if it's a big one.

## When results fall short

Escalate in this order:

1. Give the model a way to check its own work: a test, a build or a script.
2. Raise effort, up to `high`.
   - On Opus 5.5, skip `high`: go from `medium` straight to **Fable 5.2 at `low`**. It scores higher than Opus at `high`, costs less and runs faster.
3. Past `high`, move up one model, starting at `low` or `medium`. Sonnet at `max` scores below Opus at `xhigh` and costs more.

Exception: on Haiku, raise effort all the way to `max` before moving up. It's still cheaper than any step up to Sonnet.

## Mixing models

- Code edits and judgment calls go to the main model. Bulk reading goes to cheaper subagents (`model: haiku` or `model: sonnet` in the agent's frontmatter).
- Switch models at natural breaks such as `/compact` or a fresh session with a short plan, because the prompt cache belongs to the model that wrote it.
- When the routing rule is simple, such as one model per step type, have code pick the model.

API model IDs: `claude-haiku-5-5`, `claude-sonnet-5-5`, `claude-opus-5-5`, `claude-fable-5-2`.
