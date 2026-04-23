---
name: content-repurpose
description: Transform 1 validated LinkedIn post into 6 other formats (X thread, newsletter, blog, video script, carousel, podcast outline) using the Repurpose Matrix. Each format gets platform-specific voice modulation and structure, not a copy-paste. Triggers only when a post exceeds 2x its pillar's median reach (validated idea). Use when user says "repurpose this post", "turn this into a thread/newsletter/carousel", "extend this to other formats".
user-invocable: true
disable-model-invocation: false
---

# content-repurpose

Repurposing is restructuring, not copy-pasting. This skill takes 1 validated post and produces natively-formatted versions for 6 target channels.

## When to use

- A LinkedIn post exceeds 2x its pillar's median reach (validated idea per `[[Content-Pillars-{Owner}]]` thresholds)
- User explicitly requests repurposing ("turn this into a newsletter")
- Quarterly repurpose sprint (batch on past quarter's best posts)

## When NOT to use

- Post underperformed — don't repurpose, iterate the original
- Single-format quick adaptation (just write inline)
- Post whose reach came from outrage/controversy without substance — repurposing amplifies the weak part

## Inputs required

- **Source post** : published LinkedIn post (URL or full text)
- **Performance** : actual reach + engagement data (for validation)
- **Formats to produce** : subset of `[thread, newsletter, blog, video, carousel, podcast]` — default **5** (thread, newsletter, blog, video, carousel). Podcast is **opt-in** — requires `--include-podcast` flag or explicit user request (300 min effort, specific distribution channel, skip unless strategic)
- **Timing** : immediate | staggered (following Repurpose Matrix J+N schedule)
- **Voice Profile** : active owner (same as original post)

## Procedure

1. **Validate trigger**
   - Read **live** pillar median from `[[Pillar-Medians]]` (NOT hardcoded values in `[[Content-Pillars-{Owner}]]` — those are baseline only, see `~/.claude/skills/_shared/content-system-conventions.md` section 4)
   - If `Pillar-Medians.md` shows `status: seed` for the pillar OR file missing: fallback to baseline with a logged warning (`ban_violations: "using-baseline-median"`)
   - Confirm actual reach ≥ 2× median (use the "2x threshold" column directly)
   - If not met: halt with explanation, suggest iterating the original instead

2. **Extract the idea core**
   - What is the 1-sentence insight?
   - What is the PSP triptych (Problème / Solution / Preuve)?
   - What was the winning hook mechanic?
   - What verbatims / chiffres / cas are in the post?

3. **Apply format-specific rules from `[[Repurpose-Matrix]]`**

   For each requested format:
   - Load the format's rules section (structure, length, voice modulation, anti-patterns)
   - Load the "contenu additionnel obligatoire vs LI" list — you MUST add at least the required new content (not just restructure)
   - Apply cross-platform voice modulation table

4. **Produce each format**

   **Thread X**
   - 7-9 tweets
   - Tweet 1 = hook ≤280 char (reformulated from LI hook)
   - 1 idea per tweet, no transitions
   - No `1/`, no hashtags
   - Closing callback tweet + CTA in first reply

   **Newsletter**
   - Subject line (≤55 char) + preheader (≤90 char)
   - Intro (1-2 lines) → development (300-500 words, adds depth vs LI) → concrete example → 1 CTA → signature + PS
   - Must contain exclusive content not in LI post

   **Blog**
   - 1200-2500 words, SEO title (not LI hook)
   - H2 every 200-300 words
   - Internal links (2-3) + meta description
   - FAQ section (5-7 Q)
   - "Pour aller plus loin" with cross-links

   **Video script**
   - Hook (0-3s, visual strong) → Tension (3-10s) → Delivery (10-50s) → Close (50-60s, callback)
   - Word-for-word script
   - Incrustations (on-screen text) noted
   - Plan cuts every 5-8s

   **Carousel (LI DOC)**
   - 8-12 slides, 10 is sweet spot
   - Slide 1 = unique design hook
   - 1 idea per slide, ≤40 words per slide
   - Final slide = CTA

   **Podcast outline**
   - 20-45 min target
   - Structure : Accroche (0-2') → Thèse (2-5') → 3 actes (5-35') → Conclusion (35-40') → CTA (40-42')
   - Shownotes template + 3 extract clips (30-60s each)

5. **Respect J+N staggering (optional)**

   Standard sequence from `[[Repurpose-Matrix]]`:
   - J+1 : Thread
   - J+3 : Newsletter
   - J+5 : Carousel
   - J+7 : Video
   - J+14 : Blog
   - J+21 : Podcast

   Skip any format where effort >3h produces gain <30 min.

6. **Run quality gate per format** (see `[[Repurpose-Matrix]]` quality gate section)

7. **Output**

   Create one file per format in `08-Production/{Format}/{YYYY-MM-DD}-{slug}.md`:
   - `08-Production/Threads-X/`
   - `08-Production/Newsletter/`
   - `08-Production/Blog/`
   - `08-Production/Video-Scripts/`
   - `08-Production/Carousels/`
   - `08-Production/Podcast/`

   (Create directory if missing.)

   Each file has frontmatter + body + source link back to the original post.

## Integration

- Consumes : validated post + `[[Repurpose-Matrix]]` + Voice Profile
- Produces for : `content-delivery` (package for respective channels)
- Feedback : track performance of each repurposed piece vs the original to refine format priority order

## Quality gate

For each format produced:
- [ ] Structural rules respected (length, line rules, section headers)
- [ ] Voice modulation applied (not a copy-paste from LI)
- [ ] Contenu additionnel obligatoire present
- [ ] Ban List (platform-adapted) clean
- [ ] CTA native to the platform
- [ ] Mobile-tested if visual (carousel)

## Reference

- `[[Repurpose-Matrix]]` — full format rules and staggering schedule
- `[[Voice — the user]]` — anchor for voice modulation
- `[[Content-Pillars-Benoit]]` — pillar median for trigger validation
- `[[LinkedIn Content System]]` — empirical baseline
- `[[Architecture strategique de contenu B2B]]` — design references for carousels
