---
name: content-hook
description: Generate 20-30 hook variations for a single idea, using the 5 Hook Families + 7 tension mechanics + Perfect Hook Formula (10 elements). Each hook ≤15 words, ≥40% open with "Ce/Cet/Cette". Output is a ranked hook batch ready for `content-draft`. Use when user says "find hooks for this idea", "generate hook variations", "hook my post", or provides a raw idea that needs a strong entry line.
user-invocable: true
disable-model-invocation: false
---

# content-hook

The hook carries 80% of a post's reach. This skill generates the volume needed to find the winning one.

## When to use

- An idea has been validated (from `content-research` or user input) and needs hook variations
- An existing post underperforms and needs a hook rewrite
- Batch generation for a week of posts (run once, pick hooks, send batches to `content-draft`)

## When NOT to use

- Generating full posts (use `content-draft` after picking a hook)
- Finding ideas (use `content-research`)
- One-off quick hook tweaks (just do it inline)

## Inputs required

- **Idea** : 1-3 sentences describing the content angle
- **Pillar** : which Pillar it belongs to (from `[[Content-Pillars-{Owner}]]`)
- **Tier** : target audience tier (1/2/3 from `[[ICP-Language-by-Tier]]`)
- **Voice Profile** : reference (default active owner)
- **Format target** : LinkedIn post | thread | newsletter | blog | video | carousel
- **Proof available** : chiffres, cas client, verbatim, observation (any empirical anchor)

## Procedure

1. **Load reference frameworks**
   - `[[Hook Families — 5 familles, 7 mécaniques]]`
   - `[[Perfect Hook Formula]]`
   - `[[Hook Generator]]` (7 qualifying questions + output template)
   - `[[LinkedIn Content System]]` (empirical constraints)
   - Active Voice Profile for lexical fit

2. **Run 7 qualifying questions** (if info missing)
   1. Audience precise?
   2. Problem #1?
   3. Desired outcome (specific)?
   4. Proof available?
   5. Main objection?
   6. Platform / format?
   7. Tone?

3. **Generate 30 hooks, distributed across 5 Families**
   - **Famille 1 — Désir** : 6 hooks (Hormozi equation)
   - **Famille 2 — Stat-shock** : 6 hooks (contextualized numbers)
   - **Famille 3 — Blunt/Contrarian** : 6 hooks (counter-consensus)
   - **Famille 4 — Problème/Risque** : 6 hooks (hidden cost)
   - **Famille 5 — Structure/Framework** : 6 hooks (taxonomy, model)

   Each hook must:
   - Be 11-15 words (hard limit).
     - Draft at 16+ words : attempt 1 auto-truncate pass (remove fillers like "vraiment", "juste", "un peu"; drop qualifiers; remove optional articles). If still >15 after 1 pass, reject the hook — don't over-retry.
   - Contain ≥1 tension mechanic (Contraste / Contradiction / Inversion / Contrainte / Coût inaction / Open loop / Paradoxe)
   - Pass Voice Profile lexical check (allowed vocab only, zero Ban List items)
   - Not reveal the mechanism (only the promise)

4. **Apply the "Ce/Cet/Cette" quota**
   - At least 12 of 30 must open with "Ce/Cet/Cette" (empirical top signal, +1.47x impressions)

5. **Score each hook on 5 dimensions (0-4 each, max 20)**
   - **Specificity** : concrete, measurable, named vs vague
   - **Tension** : strength of chosen mechanic
   - **Voice fit** : lexical match to Voice Profile
   - **Tier fit** : language aligned to target tier
   - **Length efficiency** : closer to 12-13 words = better (15 = OK, 11 = OK, outside = reject)

6. **Output ranked table** (markdown)

   ```markdown
   ## Hooks for: {Idea title}

   | Rank | Hook | Famille | Mechanic | Score |
   |------|------|---------|----------|-------|
   | 1 | {hook} | {#} | {mech} | {XX}/20 |
   | 2 | ... | | | |
   ```

   Highlight top 5. Flag anti-patterns detected (if any).

7. **Optional: Perfect Hook Formula check on top 5**
   - For each top 5, count elements present from PA/PT/EE/DD/SN/UT/HP/EM/CC/RF
   - Top hook should carry ≥5 of 10 elements

## Integration

- Consumes : idea (from `content-research` or user), Voice Profile, Pillars, ICP
- Produces for : `content-draft` (picks top 1-3 hooks)
- Feedback : logs the chosen hook + final post performance (via `content-delivery` later) to refine the scoring model

## Quality gate

- [ ] 30 hooks generated (or 25 min if idea is very narrow)
- [ ] All 5 Families represented (≥4 each)
- [ ] ≥12 open with "Ce/Cet/Cette"
- [ ] All hooks ≤15 words
- [ ] Zero Ban List violations
- [ ] Top 5 each score ≥15/20

## Reference

- `[[Hook Families — 5 familles, 7 mécaniques]]`
- `[[Perfect Hook Formula]]`
- `[[Hook Generator]]`
- `[[LinkedIn Content System]]`
- `[[Ban List -- 47 interdits LinkedIn]]`
- `[[Voice — the user]]`
- `[[Analyse-LinkedIn-277-posts-2025-2026]]` — empirical data behind the "Ce/Cet/Cette" quota
