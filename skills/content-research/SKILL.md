---
name: content-research
description: Weekly research synthesis for content creation. Mines Modjo call transcripts, LinkedIn performance data, client DMs, and optionally external sources (Reddit, YouTube, X) to surface 10-20 idea candidates filtered by PSP (Problème/Solution/Preuve) and aligned to the active Content Pillars. Output is a ranked idea bank in Scalezia-KB, ready for `content-hook`. Use when user asks "find content ideas", "what should I post about", "weekly content research", "mine Modjo for ideas".
user-invocable: true
disable-model-invocation: false
---

# content-research

Produces a ranked idea bank weekly. Replaces the guessing phase with evidence-driven idea generation.

## When to use

- Monday morning content planning (weekly cadence)
- Low on ideas / want to re-anchor on real signal
- After a notable client call / email thread / DM wave
- Quarterly refresh of the idea bank

## When NOT to use

- Drafting a specific post (use `content-draft`)
- Finding hook variations for an existing idea (use `content-hook`)
- Generic trend reports (this skill is owner-specific, not market research)

## Inputs required

- **Owner** : whose content system (default: Benoît)
- **Window** : last 7d / 30d / 90d / custom date range
- **Sources to include** : `modjo` (default on) | `linkedin-perf` | `reddit` | `youtube` | `x` | `client-dm`
- **Count target** : default 15 ideas
- **Pillar focus** : optional filter (1 pillar) or `balanced` (default)

## Procedure

1. **Load context**
   - Active Voice Profile (`[[Voice — {Owner}]]`)
   - Active Pillars (`[[Content-Pillars-{Owner}]]`)
   - Active ICP + Language by Tier (`[[ICP-Language-by-Tier]]`)

2. **Mine Modjo transcripts** (always on)
   - Use `modjo-export` skill to pull calls in window
   - Extract: recurring client questions, pain verbatims, frustration patterns, "aha" moments, objections
   - Apply PSP filter: keep only items that cleanly map to a Problème / Solution / Preuve triptych
   - Cross-reference `[[Call-Analysis-2025-2026]]` to avoid duplicates

3. **LinkedIn performance mining** (if enabled)
   - Pull window from existing analysis (`[[Analyse-LinkedIn-277-posts-2025-2026]]` or Taplio export)
   - Top 10 performers in window → extract underlying idea, flag as "candidate for repurpose cycle" rather than new idea
   - Bottom 10 performers → flag as "avoid angle" to inform generation

4. **External sources (optional, user explicit)**
   - Reddit : search subreddits relevant to ICP (`r/sales`, `r/saas`, etc.) for pain language — collect verbatims
   - YouTube : titles of top 20 videos on ICP topic — extract framework names to adapt
   - X : top engagement posts in niche last 7d — extract angles
   - These are **secondary**: Modjo + LinkedIn own data always outweigh external

5. **Client DM mining** (if available)
   - Read recent DM threads / email replies (user-supplied or integrated)
   - Extract: questions asked, objections raised, compliments received (each = idea seed)

6. **Score & rank** — Apply the rubric strictly (reproducibility)

   Each idea scored on 4 axes (0-5 each, max 20).

   **Fit pillar (0-5)**
   - 0 : no pillar match
   - 1 : tangentially matches
   - 2 : matches but in a "forbidden angle" list
   - 3 : matches an allowed angle
   - 4 : allowed angle + aligns with pillar's "signaux de validation" (format, hook pattern)
   - 5 : 4 + targets an under-activated pillar vs cible

   **Signal strength (0-5)**
   - 0 : speculative, no source
   - 1 : 1 source (1 call, 1 DM, 1 post)
   - 2 : 2 sources, different types
   - 3 : 3+ sources same type (e.g. 3 Modjo calls on same topic)
   - 4 : 3+ sources across 2+ types
   - 5 : 5+ sources across 3+ types (Modjo + DM + LI comments + external)

   **Empirical anchor (0-5)**
   - 0 : pure theory
   - 1 : one general chiffre (industry stat)
   - 2 : one specific client number OR verbatim
   - 3 : multiple client numbers OR named cas client (anonymized)
   - 4 : chiffre + verbatim + trend observation
   - 5 : 4 + before/after or A/B data

   **Tier match (0-5)**
   - 0 : unclear, mushy mix
   - 1 : leans one tier, ambiguous
   - 2 : clearly one tier but vocab from another tier
   - 3 : clear tier + consistent vocab
   - 4 : 3 + format recommended for tier
   - 5 : 4 + CTA shape matches tier

   Totals:
   - 16-20 : top-tier, prioritize
   - 11-15 : solid, include in batch
   - 6-10 : marginal, only if slots remain
   - 0-5 : reject

   **Dedupe** before ranking: query `04-Intelligence/Idées/Idea-Bank-Master.md` (lightweight index of titles from last 8 weeks) — kill any idea whose title fuzzy-matches a prior entry.

   After ranking, append selected titles to `Idea-Bank-Master.md` for future dedupe.

7. **Output idea bank**

   Write `04-Intelligence/Idées/Idea-Bank-{YYYY-WW}.md` with structure:

   ```markdown
   ---
   type: idea-bank
   week: {YYYY-WW}
   owner: {owner}
   source_count: {int}
   ---

   ## Top {N} ideas ranked

   ### 1. {Title}
   - **Pillar** : {#}
   - **Tier** : {1/2/3}
   - **Format recommandé** : {LI-VIDEO|DOC|IMAGE|TEXT}
   - **Source(s)** : {Modjo call X, DM Y, etc.}
   - **Angle PSP** :
     - Problème : ...
     - Solution : ...
     - Preuve : ...
   - **Verbatim clé** : "..."
   - **Score** : {XX}/20

   ### 2. ...
   ```

## Integration

- Consumes : `modjo-export` skill, Voice/Pillars/ICP foundations, LinkedIn perf data
- Produces for : `content-hook` (takes top ideas), `content-draft` (direct path for high-score ideas)
- Feedback : log in `Content-Feedback-Log-{YYYY-MM}.md`, flag ideas later used vs ignored

## Quality gate

- [ ] ≥ 10 ideas produced
- [ ] Each idea has ≥1 source verbatim (not a speculation)
- [ ] No idea duplicates one from the last 8 weeks (dedupe against Idea-Bank history)
- [ ] Pillar distribution roughly matches target (±10%)

## Reference

- `[[Content-Pillars-Benoit]]` — pillars for scoring
- `[[ICP-Language-by-Tier]]` — tier matching
- `[[Call-Analysis-2025-2026]]` — dedup source
- `[[Analyse-LinkedIn-277-posts-2025-2026]]` — perf benchmarks
- `modjo-export` skill — data access
- `office-hours` skill — complementary idea extraction from office-hours calls (shares Inbox logic)
