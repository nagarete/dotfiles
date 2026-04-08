---
description: Check diff against main and remove AI-generated code slop
---

<objective>
Check the diff against main and remove all AI generated slop introduced in this branch.

This ensures code quality remains high and free of unnecessary AI artifacts that don't match the team's coding standards.
</objective>

<context>
Base branch: main
Diff summary: ! `git diff main --name-only`
Detailed diff: ! `git diff main`
</context>

<process>
1. Review the diff against main to identify changes introduced in this branch
2. Look for and remove:
   - Extra comments that a human wouldn't add or that are inconsistent with the rest of the file
   - Comments explaining obvious code that is self-documenting (remove them; keep only comments explaining complex logic or hacks)
   - Extra defensive checks or try/catch blocks that are abnormal for that area of the codebase (especially if called by trusted/validated codepaths)
   - Casts to `any` to get around type issues
   - Any other style that is inconsistent with the file
3. For code heavily using comments, consider refactoring:
   - Use better variable names
   - Break into smaller functions
   - Improve structure to make intent clear
4. Edit files to remove the identified slop and apply refactoring where appropriate
5. Verify changes maintain functionality
</process>

<success_criteria>
- All AI-generated slop identified and removed
- Code style is consistent with the rest of each file
- No unnecessary comments, defensive checks, or type casts remain
- 1-3 sentence summary provided of what was changed
</success_criteria>
