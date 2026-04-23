# /kb — Knowledge Base Context Loader

Load the Scalezia Knowledge Base context for this conversation.

## Instructions

1. Read the Context Brief to get a full picture of the knowledge base:
   ```
   ~/Library/Mobile Documents/iCloud~md~obsidian/Documents/${VAULT_PATH}/00-Index/Context-Brief.md
   ```

2. Read the MOC-Méthodologie to know all available frameworks and systems:
   ```
   ~/Library/Mobile Documents/iCloud~md~obsidian/Documents/${VAULT_PATH}/00-Index/MOC-Méthodologie.md
   ```

3. Confirm to the user that the KB context is loaded, and list the key frameworks available.

4. For the rest of this conversation, when the user asks about any topic covered by the KB:
   - Check the vault FIRST for existing knowledge before generating from scratch
   - Reference specific vault notes with [[wikilinks]]
   - If new knowledge emerges, offer to write it to the appropriate vault location

## Optional: Deep load a specific domain

If the user specifies a domain (e.g., `/kb gtm`, `/kb contenu`, `/kb vente`), also read:
- For `gtm`: `02-Systèmes/GTM/GTM-Overview.md`
- For `contenu`: `02-Systèmes/Contenu/LinkedIn-Content-System.md` + `Hook-Families.md`
- For `vente`: `02-Systèmes/Vente/Cold-Call-AIDA.md` + `Cold-Email-Structure.md` + `Objection-Matrix.md`
- For `frameworks`: List all files in `01-Fondations/Frameworks/`
- For `idées`: Read `00-Index/MOC-Idées.md`
