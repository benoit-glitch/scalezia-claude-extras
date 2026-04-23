---
description: Recommande les slash commands / skills les plus adaptés à un besoin décrit
argument-hint: <description libre du besoin>
---

L'utilisateur décrit un besoin et attend une recommandation de **slash commands** ou **skills** à utiliser.

## Besoin décrit par l'utilisateur

$ARGUMENTS

## Ta mission

1. **Analyse** le besoin en 1 phrase (reformule pour confirmer la compréhension).
2. **Identifie la catégorie dominante** parmi :
   - **Contenu LinkedIn/newsletter** → famille `content-*` (research → hook → draft → grade → repurpose → delivery) ou l'orchestrateur `/content`
   - **GTM / vente / offre / prospection** → famille `gtm-v2-*` (préférer v2) ou l'orchestrateur `/gtm-v2` / `/gtm`
   - **Dev / code / ship / review** → famille gstack (`/ship`, `/review`, `/qa`, `/investigate`, `/autoplan`, `/plan-*`, `/design-*`, `/browse`, `/cso`, `/codex`, `/land-and-deploy`, `/canary`, `/benchmark`, `/retro`, `/office-hours`, `/context-save`, `/context-restore`, `/health`, `/learn`, `/pair-agent`, `/make-pdf`, `/document-release`, `/setup-deploy`, `/setup-browser-cookies`)
   - **Knowledge Base (vault Scalezia-KB)** → `/kb`, `/kb-add`
   - **Méta / outillage Claude Code** → `/skill-router`, `/skill-creator`, `/level-up`, `/update-config`, `/loop`, `/schedule`, `/autoresearch-skill-optimizer`
   - **Process de réflexion** → famille `superpowers:*` (brainstorming, writing-plans, executing-plans, systematic-debugging, test-driven-development, requesting-code-review, etc.)
   - **Modjo / appels** → `/modjo-export`, skill `office-hours` (Benoît — extraction d'idées)
   - **Slack** → `slack:*`
   - **Design UI/Frontend** → `/frontend-design`, `/design-consultation`, `/design-shotgun`, `/design-html`, `/design-review`

3. **Propose 1 à 3 commandes** classées par ordre de pertinence. Pour chacune :
   - Nom (`/slash-command` ou `skill-name`)
   - **Pourquoi** (1 ligne — le match avec le besoin)
   - **Quand l'utiliser dans le workflow** si le besoin nécessite un enchaînement

4. **Si le besoin est multi-étapes**, propose une **séquence** (ex: `/content-research` → `/content-hook` → `/content-draft` → `/content-grade`).

5. **Si aucun skill ne matche parfaitement**, dis-le explicitement et propose la meilleure approximation OU suggère `/skill-creator` pour créer un skill dédié.

6. **Termine par une question de lancement** : "Veux-tu que je lance `<commande>` maintenant ?" — sauf si l'utilisateur a déjà précisé qu'il veut juste la reco.

## Format de réponse attendu

Court, dense, sans préambule. Format type :

```
**Besoin reformulé** : <1 phrase>

**Recommandation principale** : `/xxx`
→ Pourquoi : <1 ligne>

**Alternatives** :
- `/yyy` — <pourquoi>
- `/zzz` — <pourquoi>

**Séquence suggérée** (si pertinent) : /a → /b → /c

**Prochaine étape** : On lance `/xxx` ?
```

## Règles

- **Ne pas exécuter la commande** recommandée — juste recommander. Sauf si l'utilisateur confirme ensuite.
- **Priorité aux skills existants** sur la création de nouveaux.
- **Si plusieurs catégories** se croisent (ex: GTM + contenu), proposer les 2 chemins distincts.
- **Français** si l'utilisateur a écrit en français, sinon anglais.
