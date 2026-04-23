---
name: content
description: Meta-orchestrator for the full content creation workflow. Chains the 8 content-* skills in the right order for end-to-end production — Research (ideas) → Hook (variations) → Draft (body in voice) → Grade (100-pt rubric) → Repurpose (if validated) → Delivery (ship + ingest). Use when user says "run the full content workflow", "produce a post end to end", "content pipeline for this idea", or wants to go from zero to shipped without naming each sub-skill.
user-invocable: true
disable-model-invocation: false
---

# content

The full workflow, orchestrated. One invocation, end-to-end production.

## When to use

- Producing a post from scratch, full pipeline (research → ship)
- Running a weekly batch (N ideas → N posts scheduled)
- Onboarding a new owner : `content onboard` triggers `content-foundation` + first full cycle
- Quarterly health check : runs `content-refresh all`

## When NOT to use

- Known single-step need (use the specific `content-*` skill directly)
- Fast edit on an existing post (just do it inline)
- Debugging a specific skill's output (invoke the skill, not the orchestrator)

## Modes

| Mode | What it does | Sequence |
|---|---|---|
| `onboard` | New owner → full foundation + first cycle | foundation → research → hook → draft → grade → (ship if ≥70) |
| `produce` | Zero to shipped post | research → hook → draft → grade → (repurpose if validated) → delivery |
| `produce-from-idea` | Skip research, idea provided | hook → draft → grade → delivery |
| `batch` | Weekly N posts (**sequential execution** — one idea at a time through the chain; true parallelism requires sub-agents, not in scope) | research (once) → for each top N : hook → draft → grade → delivery |
| `refresh` | Maintenance | content-refresh all |
| `audit` | Grade existing posts retroactively | for each post : content-grade → log |
| `debug` | Inspect last session's failure — reads Content-Feedback-Log, identifies the failing sub-skill, surfaces `ban_violations` + `voice_score` + `user_action`, suggests re-invocation flags | read log → diagnose → suggest |

## Inputs required

- **Mode** : one of the above
- **Owner** : default Benoît
- **Count** (for batch) : default 5
- **Idea** (for produce-from-idea) : text description
- **Pillar filter** (optional) : restrict to 1 pillar
- **Tier filter** (optional) : restrict to 1 audience tier
- **Ship automatically** : `yes` (if grade ≥80) | `no` (hand back to user for approval) — default `no`

## Procedure

### Mode `onboard`

1. Run `content-foundation` in `new` mode → produces Voice Profile + ICP + Pillars
2. Run `content-research` window 30d → produces initial idea bank
3. Pick top idea (user selects or auto top-1)
4. Run `content-hook` → 30 hooks, pick top 1
5. Run `content-draft` → full body
6. Run `content-grade` → score + verdict
7. If ≥70 : flow to `content-delivery schedule`. Else : user iterates.

### Mode `produce`

1. If no active idea bank for current week : run `content-research`
2. Pick top idea
3. Run `content-hook` → top 3 hooks presented to user
4. User picks (or auto top-1)
5. Run `content-draft` → full body
6. Run `content-grade`
   - ≥90 : SHIP → `content-delivery schedule`
   - 80-89 : TWEAK, user edits, re-grade, ship
   - 70-79 : MINOR-REWRITE, user validates edits, ship
   - 60-69 : REWRITE via `content-draft` with flagged constraints (max 2 retries)
   - <60 : ABORT, flag to user, consider re-ideation
7. Post-publication (async) : `content-delivery ingest` picks it up → if ≥2x pillar median, queue `content-repurpose`

### Mode `batch`

1. Run `content-research` once → idea bank
2. For top N ideas :
   - Run `content-hook` (parallel if possible)
   - Run `content-draft`
   - Run `content-grade`
   - If ≥70 : stage in `08-Production/LinkedIn/{YYYY-WW}/`
3. Final review with user → schedule batch via `content-delivery schedule`

### Mode `refresh`

Pass-through to `content-refresh all`.

### Mode `audit`

For each provided URL / text, run `content-grade` only. Produce a rollup report highlighting retro-drift patterns.

### Mode `debug`

Inspect the last session's failure without re-running the workflow.

1. Read `04-Intelligence/Apprentissages/Content-Feedback-Log-{YYYY-MM}.md` — find the most recent session entry (or the session_id given via `--session` flag).
2. Extract diagnostic fields:
   - `skill` : which sub-skill last ran
   - `user_action` : accepted / edited / rejected / abandoned / pending
   - `ban_violations` : Ban List items flagged
   - `voice_score` : latest grade
   - `rewrite_count` : retries
   - `edit_diff_summary` : what the user changed manually
3. Cross-reference with the output artifact (path in `output_ref`) if it exists.
4. Diagnose patterns:
   - `rewrite_count` ≥ 2 + score still <70 → idea problem, not draft problem
   - `user_action: abandoned` → user blocked mid-flow, surface the blocking step
   - `ban_violations` recurring across multiple sessions → suggest Voice Profile refresh
5. Output a diagnosis block + suggested re-invocation (with specific flags).

## Orchestration rules

- **Parallelization** : `hook` + `draft` can prepare multiple candidates for same idea, user picks
- **Retry budget** : max 2 retries between `draft` ↔ `grade` before forcing human re-ideation
- **Skip logic** : never skip `grade`. Ever. Even user-written posts must grade.
- **Abort conditions** : if `grade` <50 twice consecutive on same idea → abort idea, return to research
- **Human checkpoints** : 
  - hook selection (unless `--auto`)
  - post-draft review (unless grade ≥90)
  - pre-ship confirmation (unless `--ship-auto`)
- **`--ship-auto` semantics** :
  - Fires `content-delivery queue-vault` automatically when grade ≥80
  - Writes queue artifact to `08-Production/LinkedIn/Queue/` with `status: queued`
  - Does NOT push to Taplio or LinkedIn live — human still copies at publish time
  - `--ship-auto-live` (not recommended) also attempts Taplio push if integration configured

## Outputs

One consolidated session summary in `04-Intelligence/Apprentissages/Content-Sessions/{YYYY-MM-DD-HHMM}-{mode}.md` with :
- Mode run, inputs, owner
- Step-by-step artifacts produced (paths)
- Final grade + verdict
- Delivery status
- Next recommended action

## Integration

- Consumes : all foundation assets (Voice, ICP, Pillars), feedback log, empirical references
- Invokes (in order) : `content-foundation`, `content-research`, `content-hook`, `content-draft`, `content-grade`, `content-repurpose`, `content-delivery`, `content-refresh`
- Produces for : user (artifacts) + feedback loop (logs)

## Quality gate

Every mode, end-of-run checks :
- [ ] All sub-skill outputs produced (or explicit skip reason)
- [ ] Session summary written
- [ ] Feedback log entries complete
- [ ] User has clear next action

## Reference

- All content-* skills (see `~/.claude/skills/content-*`)
- `[[LinkedIn Content System]]` — overall methodology
- `[[Feedback-Capture-System]]` — log semantics
- `[[Content-Pillars-Benoit]]` — pillar rules
- `[[Voice — the user]]` — voice guardrail
