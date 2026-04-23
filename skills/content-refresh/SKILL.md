---
name: content-refresh
description: Orchestrates the Feedback Capture System's 3 upper loops — Pattern Analysis (every 5 sessions), Voice Drift Audit (monthly), Pillar Audit (quarterly). Consumes the Content-Feedback-Log, surfaces drift patterns, proposes targeted mutations to Voice Profile/Pillars/skills. Use when user says "check content drift", "monthly voice audit", "run pattern analysis", "quarterly pillar review", or auto-triggers via cron.
user-invocable: true
disable-model-invocation: false
---

# content-refresh

System maintenance skill. Without this loop, the whole content system drifts silently.

## When to use

- `patterns` mode : every 5 sessions logged in the monthly feedback file (or manual trigger)
- `voice` mode : 1st of each month (or manual trigger / when drift suspected)
- `pillars` mode : end of each quarter
- `all` mode : quarterly comprehensive refresh (runs all 3 in sequence)

## When NOT to use

- Drafting / grading / producing content (use respective skills)
- Changing the Voice Profile fundamentally (use `content-foundation` with `refresh-voice` mode)

## Inputs required

- **Mode** : `patterns` | `voice` | `pillars` | `all`
- **Owner** : default Benoît
- **Window** : auto-inferred from mode (patterns = last 5 sessions, voice = last month, pillars = last quarter)

## Procedure

Loads `[[Feedback-Capture-System]]` as the authoritative spec.

### Mode `patterns` — Boucle 2

1. **Load last 5 feedback entries** from `04-Intelligence/Apprentissages/Content-Feedback-Log-{YYYY-MM}.md`

2. **Answer the 5 diagnostic questions**
   - Which edit types appear ≥3 times in 5 sessions?
   - Which Voice scores fell below 70 ≥2 times?
   - Which Hook Family dominated? (balance check)
   - Which pillar was over/under-activated vs cible?
   - Which format had the most abandonments?

3. **Produce** `04-Intelligence/Apprentissages/Par-Theme/Pattern-Analysis-{YYYY-MM-DD}.md`
   - Top 3 rewrite patterns + cause hypothesis
   - Proposed actions : skill mutations, Ban List additions, Voice Profile refreshes
   - Critical flags (voice drift, pillar drift)

4. **Check escalation thresholds**
   - 2+ patterns → same cause : auto-trigger `voice` mode
   - Median Voice score <75 over 5 sessions : auto-trigger `voice` mode

### Mode `voice` — Boucle 3

1. **Collect corpus**
   - All posts published last month (Taplio export OR manual LinkedIn CSV OR `08-Production/LinkedIn/{YYYY-MM}/`)
   - Modjo transcripts for the same window via `modjo-export`
     - **Sampling rule** : 5 most recent owner calls + 5 random across the window (total 10 calls, or all if fewer available)
     - Filter : keep segments where owner speaks ≥10 seconds continuously (exclude short back-and-forth that carries little stylistic signal)
   - All Boucle 1 entries for the month from `Content-Feedback-Log-{YYYY-MM}.md` (schema in `~/.claude/skills/_shared/content-system-conventions.md` section 1)

2. **Analyze 6 dimensions vs `[[Voice — {Owner}]]`**
   - Connecteurs favoris % (drift threshold: <60%)
   - Cadence (median sentence length, drift threshold: >18 words)
   - Precise numbers % (drift threshold: <40%)
   - Ban List violations average (drift threshold: >0.5/post)
   - "Ce/Cet/Cette" hook pattern % (drift threshold: <35%)
   - Tics signature usage (drift threshold: outside 1/20-1/1 bounds)

3. **Modjo verbatim comparison**
   - Extract 5 owner verbatims from Modjo calls
   - Compare structure/connecteurs/tics to posts
   - If Modjo verbatims more "owner" than posts → drift confirmed, cause = AI guardrail insufficient

4. **Produce** `04-Intelligence/Apprentissages/Par-Theme/Voice-Drift-Audit-{YYYY-MM}.md`
   - Global drift score (0-100, 100 = zero drift)
   - Dimensions drifting
   - Cause hypothesis
   - Proposed actions (Voice Profile update / skill mutation / 25Q partial refresh)

5. **Check Level 2 escalation** (per CLAUDE.md)
   - Drift score <70 two consecutive months → suggest autoresearch run on `content-draft`

### Mode `pillars` — Boucle 4

1. **Load published posts from last quarter** (all pillars, tagged in Feedback Log)

2. **Apply `[[Content-Pillars-{Owner}]]` "Audit trimestriel" section**
   - Real share per pillar vs target
   - Median reach per pillar
   - Deep engagement (comments >15 words + DMs) per pillar
   - LinkedIn → call conversion per pillar (Modjo or UTM)
   - Continued relevance of each pillar

3. **Produce** `04-Intelligence/Apprentissages/Par-Theme/Pillar-Audit-{YYYY-QN}.md`
   - Per-pillar table (share, reach, engagement, conversion, verdict)
   - Pillar additions / removals proposed (justified)
   - Share reallocation for next quarter

4. **Propose update** to `[[Content-Pillars-{Owner}]]` with diff — require user approval before writing

### Mode `all` — Full quarterly refresh

Run `patterns` → `voice` → `pillars` in sequence.
Produce a consolidated `Quarterly-Refresh-{YYYY-QN}.md` that summarizes all 3 outputs + prioritized action list.

## Outputs (paths)

- `04-Intelligence/Apprentissages/Par-Theme/Pattern-Analysis-{YYYY-MM-DD}.md`
- `04-Intelligence/Apprentissages/Par-Theme/Voice-Drift-Audit-{YYYY-MM}.md`
- `04-Intelligence/Apprentissages/Par-Theme/Pillar-Audit-{YYYY-QN}.md`
- `04-Intelligence/Apprentissages/Par-Theme/Quarterly-Refresh-{YYYY-QN}.md` (mode `all` only)

## Integration

- Consumes : `Content-Feedback-Log-{YYYY-MM}.md`, all content-* skill outputs, Modjo transcripts, Taplio export
- Produces for : manual action (user reviews + approves mutations), skill file edits, Voice Profile updates, Pillars updates
- Feedback loop closure : measures whether previous audits' actions actually resolved the drift (if not → escalate)

## Quality gate

- [ ] Each entry in the log is accounted for (no silent session)
- [ ] Audit conclusion is specific (not "Voice is slightly drifting")
- [ ] Every proposed action maps to a concrete file to edit
- [ ] Escalation thresholds checked explicitly

## Reference

- `[[Feedback-Capture-System]]` — full spec
- `[[Voice — the user]]` — drift reference
- `[[Content-Pillars-Benoit]]` — quarterly audit section
- `[[Call-Analysis-2025-2026]]` — Modjo baseline
- `[[Analyse-LinkedIn-277-posts-2025-2026]]` — empirical anchors
- `modjo-export` skill — transcript pull
- `autoresearch` skill — escalation target when drift persists
