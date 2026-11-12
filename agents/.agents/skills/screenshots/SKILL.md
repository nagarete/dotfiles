---
name: screenshots
description: Screenshot UI work and show it in chat or attach it to a PR. Use when the user asks for screenshots of the work, or to attach media to a PR.
argument-hint: "[PR numbers or URLs] [desktop|tablet|mobile ...] [all pages]"
---

Screenshot the screens a change touches and deliver them where the user asked.

Arguments: `$ARGUMENTS`

## 1. Scope

Read three things from the request and arguments:

- **Destination.** _PR_ when the request names a PR or says "attach" or "PR description"; for a PR, use the named PRs, else the thread's linked PRs (`list_thread_pull_requests`), else the current branch's PR, taking every layer of a stack. Otherwise _chat_.
- **Viewports.** Exactly the ones the user names. Otherwise desktop and mobile, plus tablet when the app has a layout of its own between them.
- **Screens.** With "all" or "every page", the whole route list of the app, read from the router or the pages directory. Otherwise the pages, states (hover, open menus, empty and error states) and flows the diff touches (`git diff <base>... --name-only`, or `gh pr diff <n> --name-only` for a PR). A PR whose diff changes nothing a user sees is _skipped_; record why ("#38 is API-only").

Done when you have a destination, a viewport list, and a written screen list. For "all", the screen list is every route, so you can check it off.

## 2. Capture

1. Launch the app at the head being shown (the `run` skill, or the repo's own launch instructions). Give pages realistic data, seeding it when they would otherwise be empty.
2. Make a fresh directory with `mktemp -d` for the images.
3. With `agent-browser`, capture each screen at each viewport:
   - desktop `1440 900`
   - tablet `820 1180`
   - mobile `390 844`

   Use `--full` for pages taller than the viewport. Capture interactive states once, at the size where they read best.
4. When the user asks for a before and after, also capture each screen on the base branch at the same viewport: a **before** for each **after**.
5. Open every image and look at it: real content loaded, the state you meant, no error toast, nothing clipped, and different from its neighbours. Two images of the same page under different names is a miss.

Done when every screen on the list has an image at every viewport, and you have looked at each one.

## 3. Deliver

- **Chat:** embed each image with Markdown image syntax and its absolute path, under a heading naming the screen and viewport. Put a before directly above its after.
- **PR:** upload with `gh` (flags: https://docs.github.com/api/article/body?pathname=/en/github-cli/github-cli/attaching-files-with-github-cli). Write the images into the PR description under a `## Screenshots` heading as a table: one row per screen and viewport, with `Before | After` columns when you have befores, labels in the table rather than on the images. When the description already has a `## Screenshots` section, replace it whole; a PR shows one current set. Under the table, note the commit the images show: `Captured at <short sha>`.

## 4. Report

List what you delivered (or each PR's link with its image count), the skipped PRs with their reasons, and, for "all", the route list with every route ticked. Stop the app and anything else you started.
