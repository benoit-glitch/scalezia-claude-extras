---
name: content-foundation
description: Build or refresh the 3 foundation assets for a team member — Voice Profile (via 25Q), ICP document (6 levels + Language by Tier), Content Pillars (3-5 themes). Outputs live in Scalezia-KB. Run once per person at onboarding, then refresh quarterly. Use when user says "build voice profile", "onboard new team member on content", "refresh my voice", "set content pillars", or kicks off the content system for someone new.
user-invocable: true
disable-model-invocation: false
---

# content-foundation

Produces the 3 foundation documents that guard every downstream content skill against drift and genericity.

## When to use

- Onboarding a new person into the content system (new team member, new client)
- Quarterly refresh of an existing Voice Profile (drift detected by `content-refresh`)
- Major pivot (company, positioning, audience) that invalidates prior ICP or Pillars
- User explicitly asks: "build voice profile", "set content pillars", "map ICP for content"

## When NOT to use

- Writing a post (use `content-draft`)
- Grading a post (use `content-grade`)
- Light personalization ("make it sound more X") — adjust inline, don't rerun the full foundation

## Inputs required

Ask upfront if not provided:
- **Subject person** : name, role, company, 1-line context
- **Mode** : `new` (full 25Q) | `refresh-voice` (voice only) | `refresh-icp` | `refresh-pillars`
- **Corpus available** : recent posts (URLs or text), call transcripts (Modjo), existing ICP draft
- **Target audience tier dominant** : Tier 1 / 2 / 3 (see `[[ICP-Language-by-Tier]]`)

## Procedure

### Mode `new` — Full foundation build

1. **Voice Profile (25Q)**
   - Load questionnaire from `[[Voice-Profile-Questionnaire-25Q]]` in Scalezia-KB
   - Conduct as conversation, not form (allow for elaboration, follow-ups)
   - Cross-reference with 3-5 of the person's best posts AND 3-5 rejected posts (Q24/Q25)
   - Produce `03-Systèmes/Contenu/Voice — {Prénom Nom}.md` mirroring the structure of `[[Voice — the user]]`
   - Run blind reader test (see quality gate below)

2. **ICP document (6 levels + Language by Tier)**
   - If Scalezia context: start from `[[ICP_Synthese_Scalezia_compressed]]`
   - Else: build 6 levels (conscience Schwartz, firmo, psycho, peurs, green flags, red flags)
   - Map 3 tiers using `[[ICP-Language-by-Tier]]` — collect verbatims from Modjo or client calls
   - Output `02- Fondations/Frameworks/ICP — {Projet}.md`

3. **Content Pillars (3-5)**
   - Anchor on: performance data (analogue to `[[Analyse-LinkedIn-277-posts-2025-2026]]` if available), ICP priorities, person's unique thesis (Q3 of questionnaire)
   - Define per pillar: thesis, allowed angles, forbidden angles, validation signals, target share of production
   - Output `02- Fondations/Content-Pillars — {Prénom}.md` mirroring `[[Content-Pillars-Benoit]]`

### Mode `refresh-voice`

Skip to Voice Profile step. Compare new transcripts/posts to existing profile (see `[[Feedback-Capture-System]]` Boucle 3). Update sections in place, keep version history in frontmatter.

### Mode `refresh-icp` / `refresh-pillars`

Same logic — refresh one asset, not full foundation.

## Output templates

Strictly enforced — downstream skills (`content-draft`, `content-grade`) parse these for voice/pillar references.

### Voice — {Prénom Nom}.md

Required sections (mirror `[[Voice — the user]]`):
1. Registre
2. Signature numérique
3. Connecteurs favoris
4. Tics de langage
5. Signature de clôture
6. **Emoji Policy** (hard requirement — body/hook/close rule per LI format, see `[[Voice — the user]]` > Emoji Policy for canonical shape)
7. Ce que la voix N'EST PAS
8. Application (skills concerned, scopes in vs out)
9. Liens

### ICP — {Projet ou Prénom}.md

6 levels required:
1. Conscience (Schwartz L0-L3 %)
2. Firmographique
3. Psychographique
4. Peurs profondes
5. Green flags (liste + seuil validation, e.g. 8/13)
6. Red flags (disqualifiants)

Plus Language by Tier mapping (cf. `[[ICP-Language-by-Tier]]`): 3 tiers with verbatims + recommended format + CTA shape per tier.

### Content-Pillars — {Prénom}.md

Per pillar (3-5 total):
- Thèse (1 sentence)
- Angles autorisés + Angles interdits
- Signaux de validation (format, hook pattern, chiffres)
- Multiplicateur empirique OR seed estimate
- Part cible de la production (%)

Global sections: Répartition hebdo cible, Créneaux empiriques, Règle anti-monotonie, Audit trimestriel.

### Naming convention

Path/filename rules → `~/.claude/skills/_shared/content-system-conventions.md` section 2. Multi-person strict.

### Verbatims ICP sourcing

When building ICP's 3 tiers, sample ≥5 real Modjo calls per tier via `modjo-export`. Do NOT invent verbatims — extract them. Cite call IDs in an internal frontmatter field (e.g. `source_calls: [id1, id2, ...]`).

## Outputs (paths)

- `${VAULT_PATH}/03-Systèmes/Contenu/Voice — {Prénom Nom}.md`
- `${VAULT_PATH}/02- Fondations/Frameworks/ICP — {Projet}.md`
- `${VAULT_PATH}/02- Fondations/Content-Pillars — {Prénom}.md`
- Feedback log entry in `04-Intelligence/Apprentissages/Content-Feedback-Log-{YYYY-MM}.md` (see `[[Feedback-Capture-System]]`)

## Quality gate

Before handing off to user:
- [ ] Each Voice Profile section has ≥3 person-specific verbatims (not abstractions)
- [ ] Blind reader test passed (3 posts presented, person's identified correctly)
- [ ] ICP 3 tiers each have ≥5 verbatims from real calls/DMs
- [ ] Pillars have explicit forbidden angles (not just allowed ones)
- [ ] Pillars total share = 100%

## Integration

- Consumes : `[[Voice-Profile-Questionnaire-25Q]]`, `[[ICP-Language-by-Tier]]`, existing voice references
- Produces foundation for : `content-draft`, `content-grade`, `content-research`, `content-refresh`
- Feedback : writes to `Content-Feedback-Log-{YYYY-MM}.md` per invocation

## Reference

- `[[Voice-Profile-Questionnaire-25Q]]` — the 25 questions
- `[[Voice — the user]]` — reference example of a finished Voice Profile
- `[[ICP_Synthese_Scalezia_compressed]]` — reference ICP (6 levels)
- `[[ICP-Language-by-Tier]]` — 3 tiers mapping
- `[[Content-Pillars-Benoit]]` — reference pillars example
- `[[Feedback-Capture-System]]` — how outputs are tracked
