---
name: ticket
description: Start work on a Linear ticket or roadmap item, linked through its Linear branch name. Use when the user hands over a Linear issue (link, ID, or branch name) or a roadmap item to build, or asks for follow-up Linear tickets.
---

## 1. Find the issue

Use the `mcp__linear-server__*` tools.

- **Link or ID** (`ENG-123`): `get_issue`.
- **Branch name** (`nathan/eng-123-…`): take the ID from it, then `get_issue`.
- **Roadmap screenshot or a title**: read the title, then `list_issues` with its key words. One clear match: use it. Several: show them and ask. None: ask whether to create one.

Read the description and `list_comments`; comments often carry the decisions.

Split what you read in two:

- The **problem**: what is broken or missing, and for whom. This is the work.
- The **proposal**: any "Proposed solution", "Proposed fix", "Ideal UX" or similar section, and any fix the description prescribes. Proposals are often written by non-engineers or drafted with AI, so a proposal is a hypothesis to test against the code and data, not a spec. Find the root cause yourself, then keep, change or replace the proposal according to which solves the problem best.

Done when you have the issue ID, its `gitBranchName`, and a numbered list of the **requirements**: the problem's outcomes, stated without the proposal's mechanism.

## 2. Claim

Assign the issue to the user (`save_issue`, assignee `me`) unless someone else holds it and the user did not ask to take it over. Then check out `gitBranchName` from the freshly fetched default branch, or continue on that branch if it already exists on the remote. The branch is the issue's link; the ticket ID stays out of PR titles and commit messages.

Done when the issue is assigned and you are on its branch.

## 3. Build

Follow `full-stop`, or `full-send` when the user says "full send". For changes a user can see, run `screenshots` to the PR.

The requirements list from step 1 is part of that skill's merge gate. Before its handoff, re-read the issue and walk the list: for each requirement, name the commit and the proof (test, screenshot, output) that covers it, or flag it as open. Put the list in the final report, followed by where you departed from the proposal and why. Put the same note in the PR description, so reviewers who read the ticket see the reasoning.

## Follow-ups

Work spotted along the way that belongs outside this PR becomes a follow-up ticket: same team as the parent, assigned to the user, related to the parent issue, with a description that stands on its own (what, where in the code, why it was left). Link each one in the PR description under `## Follow-ups`.
