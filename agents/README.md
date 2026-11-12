# Agent skills

Skills live in `.agents/skills/` and reach the agents through two links:

```
~/.claude/skills/<name>  ->  ../../.agents/skills/<name>
~/.agents/skills/<name>  ->  ../../dotfiles/agents/.agents/skills/<name>
```

On a fresh machine `install.sh` (`stow */`) links `~/.agents` itself, so only
the `~/.claude/skills` links are missing. On this machine `~/.agents/skills` is
a real folder that also holds untracked skills, so each skill is linked on its
own. This loop handles both cases and only creates links that are missing:

```sh
mkdir -p ~/.claude/skills
for s in ~/dotfiles/agents/.agents/skills/*/; do
  n=$(basename "$s")
  [ -e ~/.agents/skills/"$n" ] || ln -s "../../dotfiles/agents/.agents/skills/$n" ~/.agents/skills/"$n"
  [ -e ~/.claude/skills/"$n" ] || ln -s "../../.agents/skills/$n" ~/.claude/skills/"$n"
done
```

`upstream/` is ignored by stow (see `.stowrc`), so it is only stored here, never
linked into `~`.

## narasaka/skills, adapted to Claude only

Source: <https://github.com/narasaka/skills> at commit `af84c86`
(installed 2026-11-12). Most of these skills are themselves adapted from
Theo Browne's [tstack](https://github.com/t3dotgg/tstack) (MIT).

Unchanged: `babysit-pr`, `dotenvx`, `file-pr`, `full-send`, `full-stop`,
`leaving-pr-comments`, `modernize`, `screenshots`, `takeover`, `ticket`,
`weigh-comments`. Also tracked here: `choosing-claude-models`, which the
adapted skills below rely on.

### Why we changed three of them

The upstream skills assume two subscriptions: **OpenAI (Codex)** and
**Anthropic (Claude)**, split into "Personal" and "Work" accounts. We only
have Claude right now. Without Codex:

- `sol-loop` refuses to run, because its only reviewer is GPT Sol and it is told
  never to substitute a model.
- `council` cannot seat two of its three reviewers (GPT-6.1 Sol, GPT-6 Astra)
  and fails its Personal/Work account check.
- Through them, `full-send`, `full-stop` and `ticket` stall at the review
  step (they call `sol-loop`), and `orchestrate` stalls at its per-PR `council`.

So these three are edited (each file has a header comment saying so):

| Skill | Upstream | Ours (Claude only) |
| --- | --- | --- |
| `sol-loop` | Reviewer: GPT Sol on Codex | Reviewer: Claude Fable 5.2 at `low` (`medium` for security / data-loss / concurrency rounds). Name kept so "sol loop" and `full-send` still work. |
| `council` | GPT-6.1 Sol + GPT-6 Astra + Claude Fable 5.2, matched to Personal/Work accounts | Claude Fable 5.2 (`medium`) + Opus 5.5 (`medium`) + Sonnet 5.5 (`high`), on the session's own Claude instance |
| `orchestrate` | Every implementer on Opus 5.5 at `high` | Model and effort per checkpoint from `choosing-claude-models` (default Opus 5.5 `medium`, Sonnet for small scoped work, Fable 5.2 `low` for big work; never Opus `high`) |

The `orchestrate` change is not about Codex. Upstream hardcodes Opus at `high`,
but `choosing-claude-models` says to skip that and use Fable 5.2 at `low`
instead (scores higher, costs less, runs faster), and to pick the model by how
hard each checkpoint is. One rule for model choice everywhere.

The efforts follow `choosing-claude-models` too: Opus skips `high`, and Sonnet
goes up to `high` before moving up a model.

### If we get a Codex subscription

Switch `sol-loop` and `council` back to upstream, which uses GPT reviewers.
A second provider catches mistakes a same-family reviewer tends to share.

1. Restore the originals, which are saved untouched in `upstream/narasaka-skills/`:

   ```sh
   cd ~/dotfiles/agents
   cp upstream/narasaka-skills/sol-loop/SKILL.md .agents/skills/sol-loop/SKILL.md
   cp upstream/narasaka-skills/council/SKILL.md  .agents/skills/council/SKILL.md
   ```

   Or pull the latest from <https://github.com/narasaka/skills>, which may name
   newer models.

2. Fix the account rule. Upstream matches a Claude and a Codex instance
   with the same `displayName` ("Personal" or "Work"). If our T3 provider
   instances aren't named that way, edit that paragraph in both skills to match
   our names, or drop it if we only have one account per provider.

3. Keep our `orchestrate`. It doesn't use Codex, and its model rule still applies.
   Restore `upstream/narasaka-skills/orchestrate` only if we want the fixed
   Opus `high` back.

4. Update the table above and commit.
