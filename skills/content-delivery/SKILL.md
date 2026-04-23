---
name: content-delivery
description: Package a graded post (or a repurposed format bundle) for delivery. Default mode writes a self-contained queue artifact to the vault (08-Production/LinkedIn/Queue/) that a human copies to LinkedIn native scheduler or Taplio at publication time — no brittle Taplio API integration. Optional modes: Notion handoff (client sharing), Taplio push, performance-data ingest (feeds Pillar-Medians.md + Feedback Log). Use when user says "ship this post", "queue this", "schedule this", "package for client", "close the loop on performance".
user-invocable: true
disable-model-invocation: false
---

# content-delivery

The last mile. Without this skill, graded posts rot in the vault and performance data never reaches the feedback loop.

## When to use

- A post has been graded ≥70/100 and needs shipping
- A `content-repurpose` bundle needs distribution across channels
- Client handoff (deliverables package)
- Post-publication performance ingestion (manual or weekly cron)

## When NOT to use

- Pre-publication work (use draft/grade/repurpose)
- Direct publication to LinkedIn (this skill packages + queues, human still validates)

## Inputs required

- **Mode** : `schedule` | `handoff` | `ingest`
- **Artifact(s)** : path(s) to graded post(s) or repurposed bundle
- **Destination** : Taplio (default for LI posts) | Notion (client handoff) | both
- **Client context** (if `handoff`) : Notion workspace ID or page ref
- **Schedule date/time** (if `schedule`) : ISO datetime or "next-available-slot"

## Procedure

### Mode `queue-vault` — DEFAULT: queue in vault for manual publication

The primary operational path. Taplio has no stable public API; rather than build a brittle integration, the skill writes a self-contained post artifact to the vault queue folder. A human copies to LinkedIn native scheduler / Taplio / Hypefury / Publer at the scheduled time.

1. **Validate prerequisites** (same as `schedule` below: score ≥70, Voice signature, assets ready)

2. **Determine slot** (same logic: pillar rotation, mardi/jeudi priority, avoid 14h-18h, no 2 consecutive same-pillar)

3. **Write queue artifact** to `08-Production/LinkedIn/Queue/{YYYY-MM-DD}-{HHMM}-{slug}.md`:
   - Frontmatter: `scheduled_for`, `pillar`, `format`, `status: queued`, `voice_score`, `slug`, `owner`
   - Body: the final post text (ready to paste)
   - Media attachments section (paths to carousel PDF / video / image)
   - UTM tracking section (outbound links with `utm_source=linkedin&utm_medium=post&utm_campaign={pillar}-{slug}`)
   - Publication checklist (copy text, upload media, verify UTM, mark `status: published`)

4. **Log** entry with `user_action: queued-vault`.

5. **Optional chaining** via flags:
   - `--also schedule` : run `schedule` mode after (Taplio push, if integration configured)
   - `--also handoff` : run `handoff` mode after (Notion push)

### Mode `schedule` — Queue for publication

1. **Validate prerequisites**
   - Post has been through `content-grade` with score ≥70
   - Voice Profile signature matches the owner
   - Attached assets (carousel slides, video file, image) present

2. **Determine slot**
   - Check `[[Content-Pillars-Benoit]]` weekly cadence
   - Preferred days : mardi > jeudi (empirical top)
   - Avoid : 14h-18h (z=-1.98), wednesday full
   - Respect pillar rotation (no 2 consecutive same-pillar)

3. **Package for Taplio**
   - Post text (final)
   - Attached media (image/carousel/video) — verify dimensions per format
   - Scheduled time
   - UTM tracking in any outbound link (format: `utm_source=linkedin&utm_medium=post&utm_campaign={pillar}-{slug}`)

4. **Log** entry in Feedback Capture with `user_action: scheduled`

### Mode `handoff` — Client delivery via Notion

1. **Validate artifact**
   - If bundle (repurpose) : all formats complete + quality-gated
   - If single post : graded + attached assets ready

2. **Build Notion handoff page** (via `mcp__claude_ai_Notion__notion-create-pages`)
   - Title : `{YYYY-MM-DD} — {idea title} — {format(s)}`
   - Parent : client workspace page (from input)
   - Sections :
     - Context (1 paragraph : what this is, why it matters)
     - The deliverable(s) : each format in its own sub-block with final copy + assets
     - Performance target : expected metric (baseline from pillar median)
     - Post-publication actions : what the client should report back (reach, top comments, DMs)
     - Timeline : when each format ships

3. **Link back** to source idea in vault (`[[Idea-Bank-{YYYY-WW}]]`) — but keep the Notion page self-sufficient for client

### Mode `ingest` — Performance data back to vault

1. **Pull data**
   - Taplio : impressions, reactions, comments, shares per post (last 7/30d window)
   - LinkedIn native if Taplio lacks
   - Modjo : any inbound call mentioning a specific post as trigger

2. **For each post**, update the Feedback Capture Log entry :
   - Actual reach
   - Actual engagement
   - Pillar median comparison (hit / below / 2x+)
   - Flag if 2x+ → recommend `content-repurpose` trigger
   - Flag if below 0.5x → recommend analysis (why did this underperform?)

3. **Update** `[[Analyse-LinkedIn-277-posts-2025-2026]]` with new data points (monthly or quarterly rollup)

4. **Trigger downstream** automatically :
   - Posts ≥2x pillar median → proposal to `content-repurpose`
   - Pattern of underperformance on same pillar/format → proposal to `content-refresh patterns`

## Outputs (paths)

- Taplio queue entry (external, log confirmation in vault)
- Notion page (external ID stored in vault: `08-Production/Client-Handoffs/{client}-{YYYY-MM-DD}.md` with Notion URL)
- Updated `Content-Feedback-Log-{YYYY-MM}.md` entries
- Rolling update to `[[Analyse-LinkedIn-277-posts-2025-2026]]`

## Integration

- Consumes : graded post(s), repurpose bundle(s), Taplio (via manual/API), Notion (via MCP)
- Produces for : external channels (Taplio, client Notion), vault feedback updates
- Closes the loop with : `content-refresh` (which reads the enriched feedback log)

## Quality gate

- [ ] Pre-publication : score ≥70, assets present, UTM clean
- [ ] Handoff : Notion page self-sufficient (client doesn't need vault access)
- [ ] Ingest : every post in window has a performance data point logged
- [ ] Triggers fired where thresholds crossed

## Reference

- `[[Content-Pillars-Benoit]]` — scheduling cadence + median thresholds
- `[[Analyse-LinkedIn-277-posts-2025-2026]]` — rolling data source
- `[[Feedback-Capture-System]]` — log schema for ingest mode
- `[[Repurpose-Matrix]]` — trigger conditions for repurpose recommendation
- Notion MCP tools — for handoff mode
- Taplio — scheduling (external)
