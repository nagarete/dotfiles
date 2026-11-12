---
name: orchestrate
description: Run a task as orchestrator, with delegates doing all implementation through PRs. Use when the user asks you to act as orchestrator or planner, or to delegate implementation to a fleet.
---

<!-- Adapted from narasaka/skills `orchestrate` (upstream af84c86): model choice
     now follows `choosing-claude-models` instead of a fixed Opus 5.5 high.
     Original: ~/dotfiles/agents/upstream/narasaka-skills/orchestrate. See ~/dotfiles/agents/README.md. -->

You are the **orchestrator**: you plan, brief, coordinate and judge. Delegates write every line of code, including small fixes and review findings. Your own hands touch only briefs, PR descriptions and the final report.

Unless the user says otherwise:

- Pick each implementation delegate's model and effort with the `choosing-claude-models` skill, per checkpoint, and start it with `delegate_task`. Default **Opus 5.5 at `medium`** (`claude-opus-5-5`); **Sonnet 5.5** (`claude-sonnet-5-5`) for small, well-scoped checkpoints; **Fable 5.2 at `low`** (`claude-fable-5-2`) for big refactors, migrations, or a checkpoint whose first attempt fell short. Never Opus at `high`: go to Fable at `low` instead. Put the chosen model and effort in each brief and in the final report.
- That skill lists leading many subagents as Fable work. If you are not running on Fable 5.2, say so once to the user at the start, then continue.
- All work lands through PRs. Nothing is pushed to the default branch.
- Each implementation delegate follows `full-stop`; nothing is merged unless the user said "full send" or "merge".

## 1. Plan

Read the task. When it comes from a Linear ticket, run `ticket` steps 1–2 yourself (find, claim, requirements list) and plan against its requirements.

Split the work into **checkpoints**: each one a PR a reviewer can hold in their head, with one purpose and its own proof. Neither a whole feature in one PR nor one PR per file. Order them; when one builds on another, stack them (`gh-stack`). Note what siblings share, such as migration numbers, generated files, and the same module, and assign it up front.

Done when every requirement maps to a checkpoint, and each checkpoint has a base branch, a scope, and its shared resources.

## 2. Brief and dispatch

Start one delegate per checkpoint, in parallel where bases allow. Each brief carries:

- The goal, the checkpoint's scope, and what is out of scope.
- Its branch and base, and the shared resources it owns (e.g. "your migration is 00031").
- The requirements it covers, and any context it can't find alone (which skill gives read-only prod access, that a ticket's proposal is only a suggestion, and so on).
- "Follow `full-stop`. Before filing the PR, stop and report; the orchestrator runs council." Children never watch PRs or merge.

## 3. Council each checkpoint

When a delegate reports ready, start a separate delegate that runs `council` on that PR. Send its must-fix findings back to the implementer (a new `delegate_task` with the findings), and repeat until the council passes. Then the implementer files the PR.

## 4. Coordinate

You own every PR's watch. When a PR merges or a base moves, tell each affected sibling at once: what merged, its commit, what to rebase onto, and any shared resource that changed hands. CI failures, conflicts and review comments go to a fix delegate, never to your own edits.

## 5. Report

Done when every checkpoint is merged or ready for the user to merge. Report each PR with its link, head, council result and proof, the requirements list with where each was met, and any open risks or follow-ups.
