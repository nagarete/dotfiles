---
description: Commit, push, and create a PR for current changes
---
Commit, push, and create a PR for the current changes. If I don't ask don't do anything.

First, check the current git status to see what changes are staged and unstaged:
!`git status`

Then check what files have been modified:
!`git diff --name-only`

Now, commit all the changes with an appropriate commit message based on the changes. Stage all changes first, then commit:
1. Stage all changes: `git add .`
2. Create a commit with a descriptive message that summarizes the changes

After committing, push the changes to the remote:
!`git push -u origin $(git branch --show-current)`

Finally, create a pull request using the gh CLI:
!`gh pr create --title "$(git log -1 --pretty=%s)" --body "$(git log -1 --pretty=%b)"`

If the PR creation fails or needs more details, provide a summary of the changes and ask the user if they'd like to customize the PR title or description.
