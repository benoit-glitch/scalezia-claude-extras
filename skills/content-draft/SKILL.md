---
name: content-draft
description: Write a full post draft in the owner's voice, from a chosen hook and idea. Uses the active Voice Profile as guardrail (including its Emoji Policy section — per-owner rule overrides the empirical corpus average), enforces Ban List, follows empirical structure (body 1000-1500 char, line ≤80 char, avg 40-60 char, ≥2 CAPS, CTA explicit). Consumes `constraints_for_rewrite` YAML block if invoked as retry from `content-grade`. Output goes straight to `content-grade`. Use when user says "draft this post", "write the body", "give me a full draft from this hook".
user-invocable: true
disable-model-invocation: false
---

# content-draft

Takes a hook + idea → produces a full post body in the owner's voice. AI writes the scaffold, the human sharpens — the Voice Profile is the guardrail.

## When to use

- Hook has been picked (from `content-hook` or user)
- Rewriting a post that failed grading (from `content-grade` with feedback)
- Repurposing into a new LinkedIn post (not into another format — use `content-repurpose` for that)

## When NOT to use

- Generating hooks (use `content-hook`)
- Grading an existing draft (use `content-grade`)
- Creating non-LinkedIn formats (use `content-repurpose`)

## Inputs required

- **Hook** : chosen hook (11-15 words)
- **Idea** : the full idea with angle PSP
- **Pillar** : from `[[Content-Pillars-{Owner}]]`
- **Tier** : target audience tier (1/2/3)
- **Format** : LI-VIDEO | LI-DOC | LI-IMAGE | LI-TEXT
- **Proof** : chiffres, cas client, verbatim — at least one required
- **Voice Profile** : reference (default active owner)

## Procedure

1. **Load guardrails**
   - Active Voice Profile (connecteurs, tics, cadence, signature)
   - `[[Ban List -- 47 interdits LinkedIn]]` — as negative constraint
   - `[[LinkedIn Content System]]` — empirical structure rules
   - Active Pillars + ICP Tier mapping

2. **Apply the empirical blueprint** (from `[[Analyse-LinkedIn-277-posts-2025-2026]]`)
   - **Hook line** : as provided (no rewrite without explicit permission)
   - **Body length** : 1000-1500 characters (NOT words). Sweet spot validated empirically.
   - **Line length** : every line ≤80 characters. Zero exception (strongest negative signal if violated).
   - **Average line length** : 40-60 characters.
   - **Paragraphs** : 1-3 lines max.
   - **Structure** : Hook → short tension line → 2-4 body paragraphs → CTA close → signature
   - **CAPS** : ≥2 CAPS-emphasized words in the body (not the hook)
   - **Numbered lists** : if the idea has ≥3 enumerable elements, use a numbered list
   - **Emojis** : strictly enforce the active Voice Profile's `## Emoji Policy` section. Do NOT apply the empirical "≥3 emojis = +1,42x" corpus signal — per-owner Voice overrides it. For Benoît specifically: zero decorative symbol in body and hook, signature de clôture unchanged. Reference: `[[Voice — the user]]` > Emoji Policy.

3. **Apply the Système CEO workflow**
   - **Collect** (internal, divergent): gather all angles, sub-ideas, verbatims related to the idea — no filtering
   - **Expand** : develop each kept fragment into its natural length — don't prune yet
   - **Organize** : compress + structure + match to 1000-1500 char target, remove off-topic (stash in a `bachlog` note if valuable)

4. **Apply Voice Profile in each line**
   - Inject ≥1 connecteur favori per paragraph (except hook line)
   - Max 1 tic per post, never on line 1
   - Cadence : respect the alternation pattern specified in the Voice Profile
   - Numbers : always precise (not "environ"), match the owner's precision style

5. **CTA**
   - Must be present (absence = strongest negative signal, z=-2.99, 0.65x reach)
   - Match ICP Tier:
     - Tier 1 : "Dis-moi en commentaire si tu veux le template"
     - Tier 2 : "Je partage le détail en newsletter — lien en bio"
     - Tier 3 : "Écris-moi pour en parler" or no explicit CTA (content is the qualification)
   - Pattern "commente/dis-moi" has strongest positive signal (z=+2.92, 1.79x)

6. **Signature de clôture**
   - Match Voice Profile signature (e.g. `– {Prénom}`)
   - No emoji on the final line unless Voice Profile explicitly permits

7. **Self-check before handoff**
   - Run mental pass against Ban List — remove any violation
   - Count characters per line (tools may help)
   - Verify CTA presence
   - Verify hook untouched

8. **Output format**

   ```markdown
   ## Draft — {idea title}

   **Hook** : {hook}
   **Pillar** : {#}
   **Tier** : {1/2/3}
   **Format** : {LI-VIDEO|DOC|IMAGE|TEXT}

   ---

   {HOOK}

   {body line by line}

   {CTA}

   {signature}

   ---

   **Stats**
   - Character count : {N}
   - Line count : {N}
   - Longest line : {N} char
   - Avg line length : {N} char
   - Ban List violations flagged : {list or "none"}
   - Voice connecteurs used : {list}
   ```

## Integration

- Consumes : hook (from `content-hook`), Voice Profile, Pillars, ICP, Ban List
- Produces for : `content-grade` (mandatory next step before publishing)
- Feedback : log draft + user edits diff to `Content-Feedback-Log-{YYYY-MM}.md`

## Handling retry from `content-grade`

If this skill is invoked with a `constraints_for_rewrite` YAML block (output from a previous `content-grade` run with verdict REWRITE/MINOR-REWRITE — see `~/.claude/skills/_shared/content-system-conventions.md` section 3), it MUST:

1. Parse the block.
2. If `keep_hook: true` → hook line frozen, don't touch it.
3. Target `target_length_chars` ±50 chars.
4. Apply each `fix_criteria.specific_fix` — edit ONLY what's flagged; leave other criteria untouched.
5. For each `remove_violations` entry : locate `exact_quote`, replace with `suggested_replacement` (or delete if replacement says delete).
6. For each `preserve` entry : verify the element is still present after edits; if accidentally removed, restore.
7. Increment `rewrite_count` in the log call : `content-log.sh --rewrite-count {N+1}`.

**Retry budget** : if `rewrite_count` reaches 2 and the new draft still grades <70 → halt, flag to user, recommend re-ideation (the idea is likely the problem, not the draft).

## Quality gate (before handoff to `content-grade`)

- [ ] Hook unchanged
- [ ] Body 1000-1500 characters
- [ ] Every line ≤80 characters
- [ ] Avg line 40-60 characters
- [ ] CTA present
- [ ] ≥2 CAPS words in body
- [ ] Zero Ban List violations (or flagged explicitly for user)
- [ ] Voice connecteurs ≥2 in body
- [ ] Signature matches Voice Profile

## Reference

- `[[Voice — the user]]` — guardrail
- `[[Ban List -- 47 interdits LinkedIn]]` — negative constraint
- `[[LinkedIn Content System]]` — empirical structure
- `[[Système CEO — création de contenu à haute fréquence]]` — workflow
- `[[Methode Publications LinkedIn]]` — 10 writing rules
- `[[Analyse-LinkedIn-277-posts-2025-2026]]` — structural data
- `[[Content-Pillars-Benoit]]` — pillar mapping
- `[[ICP-Language-by-Tier]]` — tier language
