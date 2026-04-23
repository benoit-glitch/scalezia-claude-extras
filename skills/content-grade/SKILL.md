---
name: content-grade
description: Grade a draft post on the 6-criterion 100-point Scoring Grid (Format 40, Opening 15, Subject 10, Word density 15, Promise clarity 10, Safety 10). Returns the score, a per-criterion breakdown, flagged issues, and a rewrite verdict (<70 = rewrite required, 70-79 = minor edits, 80-89 = publishable with tweaks, 90-100 = ship as-is). Use when user says "grade this post", "score my draft", "is this ready to ship", or when `content-draft` finishes and auto-chains.
user-invocable: true
disable-model-invocation: false
---

# content-grade

Hard gate between draft and publication. No post publishes below 70/100. No exception.

## When to use

- After `content-draft` produces a draft
- Before publishing any LinkedIn post (even user-written)
- Auditing last month's published posts retroactively (drift detection)

## When NOT to use

- Drafting (use `content-draft`)
- Grading non-LinkedIn formats (needs format-specific rubric, TBD)

## Inputs required

- **Draft** : full post text (hook + body + CTA + signature)
- **Voice Profile reference** : default active owner
- **Target format** : LI-VIDEO | LI-DOC | LI-IMAGE | LI-TEXT (affects some criteria weights)

## Procedure

Apply `[[Scoring Grid -- 100 points]]` exactly. Score per criterion below.

### Criterion 1 — Format (40 pts)

- Paragraphs 1-3 lines : **10 pts**
  - Full : all paragraphs ≤3 lines
  - Partial : 1 paragraph >3 lines (-3 pts)
  - Fail : 2+ paragraphs >3 lines (0 pts)

- Line breaks systematic : **8 pts**
  - Each paragraph separated by blank line
  - Fail if wall of text

- Varied rhythm : **8 pts**
  - Alternation short/short/long/short or equivalent from Voice Profile
  - Fail if all lines same length

- Total length 200-1300 mots (OR 1000-1500 char for LI-TEXT) : **7 pts**
  - Hard check against empirical sweet spot

- Readable structure (lists, sub-titles, numbering) : **7 pts**
  - Applicable if ≥3 enumerable elements

### Criterion 2 — Demonstrative opening (15 pts)

- Factual / counter-intuitive hook : **8 pts**
  - Not generic, not "Je/My"
- No opening with "Je" : **4 pts**
- First sentence ≤15 words : **3 pts**

### Criterion 3 — Intriguing subject (10 pts)

- Identifiable clear topic : **5 pts**
- Original / specific angle : **5 pts**
  - Not recycled best-practice

### Criterion 4 — Word density (15 pts)

- Average 11-15 words/sentence : **8 pts**
- No empty words (vraiment, juste, un peu, etc.) : **4 pts**
- Zero sentence >20 words : **3 pts**

### Criterion 5 — Promise clarity (10 pts)

- Promise identifiable in first 3 lines : **5 pts**
- Promise delivered by the end : **5 pts**
  - The body must fulfill what the hook implied

### Criterion 6 — Safety / Ban List (10 pts)

- Zero item : **10 pts**
- 1 item : 8 pts
- 2 items : 6 pts
- 3+ items : **0 pts (mandatory rewrite)**

Run the Ban List check systematically:
- Syntax (7 items)
- Lexicon (12 items)
- Rhetoric (11 items)
- Structure (17 items)

## Output format

```markdown
## Grade : {SCORE}/100 — Verdict : {SHIP|TWEAK|MINOR-REWRITE|REWRITE|ABORT}

### Breakdown
- Format : {X}/40
  - Paragraphs 1-3 lines : {X}/10
  - Line breaks : {X}/8
  - Varied rhythm : {X}/8
  - Length : {X}/7
  - Readable structure : {X}/7
- Demonstrative opening : {X}/15
- Intriguing subject : {X}/10
- Word density : {X}/15
- Promise clarity : {X}/10
- Safety : {X}/10

### Flags
- **Critical** (force rewrite) : {list or "none"}
- **Warnings** (allow ship with edit) : {list or "none"}

### Ban List violations
{per-violation: item name + exact quote}

### Suggested edits (if score 70-89)
- {specific line-level fix}
- ...

### Rewrite guidance (if <70)
- Primary issue : {diagnosis}
- Suggested direction : {1-2 sentences}
- Re-run through `content-draft` with the `constraints_for_rewrite` YAML block below
```

### constraints_for_rewrite (OUTPUT CONTRACT)

When verdict = **REWRITE** (60-69) or **MINOR-REWRITE** (70-79), APPEND the following YAML block to the output. `content-draft` consumes it verbatim on retry.

```yaml
constraints_for_rewrite:
  keep_hook: true
  target_length_chars: 1250
  fix_criteria:
    - name: "Format"
      current: 28
      target: 36
      specific_fix: "Shorten 2 paragraphs that exceed 3 lines."
    - name: "Opening"
      current: 8
      target: 13
      specific_fix: "First sentence must drop from 18 to <=15 words."
  remove_violations:
    - item: "Stacked pain questions"
      exact_quote: "Tu as testé 10 outils? Tu as vu le résultat?"
      suggested_replacement: "Keep only the first question."
  preserve:
    - "closing signature unchanged"
    - "specific number 715"
    - "connecteur 'Or' at paragraph 2 opening"
```

**Omit this block entirely** if verdict = SHIP (>=90), TWEAK (80-89), or ABORT (<60). Full contract spec → `~/.claude/skills/_shared/content-system-conventions.md` section 3.

### Clarification — word density (Criterion 4)

"Average 11-15 words/sentence" refers to sentences (unit ending in .!?), not lines. Several short sentences can fit on one line; a line ≤80 char (empirical rule) may contain 1-2 sentences. The two constraints are compatible, not redundant.

## Verdict thresholds

- **90-100** : SHIP — publish as-is
- **80-89** : TWEAK — minor inline edits, no re-run
- **70-79** : MINOR-REWRITE — user-approved inline fixes
- **60-69** : REWRITE — back to `content-draft` with flagged constraints
- **<60** : ABORT — re-examine the idea itself, may not survive a rewrite

## Integration

- Consumes : draft (from `content-draft` or user), `[[Scoring Grid -- 100 points]]`, `[[Ban List -- 47 interdits LinkedIn]]`, Voice Profile
- Produces for : `content-delivery` (if SHIP/TWEAK), back to `content-draft` (if REWRITE)
- Feedback : logs score + violations + user decision to `Content-Feedback-Log-{YYYY-MM}.md` — key data source for `content-refresh` pattern recognition

## Quality gate

- [ ] Every criterion scored explicitly (no handwaving)
- [ ] Ban List checked item-by-item
- [ ] Verdict clear and matched to threshold
- [ ] If REWRITE/ABORT : specific diagnosis provided (not just "not good enough")

## Reference

- `[[Scoring Grid -- 100 points]]`
- `[[Ban List -- 47 interdits LinkedIn]]`
- `[[LinkedIn Content System]]`
- `[[Voice — the user]]`
- `[[Analyse-LinkedIn-277-posts-2025-2026]]` — empirical anchors
- `[[Feedback-Capture-System]]`
