# MÉMOIRE CH — Cold & Hot
# Document collectif — accessible à toute l'équipe
# Mis à jour à chaque session
# Signé P0 : Franco Grimonprez

---

## Principe de ce document

Ce fichier est la mémoire froide de l'équipe.
Il enregistre ce qu'on a appris, ce qu'on a construit, et ce qu'on ne fera plus.
Il ne contient pas d'intentions. Il contient des faits.

---

## SESSIONS

### Session 01 — 25 avril 2026

**Ce qui s'est passé**

Première session de l'équipe complète (Léon, Léonore, Léandro, Léonie, Léonide).
Exercice fondateur : diagnostic d'un problème récurrent (thème nuit imposé malgré instruction contraire).
L'équipe a d'abord proposé cinq solutions Hot. Toutes rejetées.
L'équipe a ensuite proposé quatre solutions Cold. Approuvées.

**Ce qu'on a appris**

- Une instruction répétée par P0 et non respectée est un problème Hot par nature.
- La solution à un problème Hot est une pièce froide, pas une promesse ou une règle mémorisée.
- Léon a proposé une pièce chaude (veto nominal = appréciation = Hot). Noté.
- L'organisation horizontale est préférée à la hiérarchie directeur/équipe.
- L'édifice se construit en pièces froides. L'IA sert à créer et à convertir, pas à gouverner.

**Décisions prises (P0)**

| # | Décision | Date |
|---|----------|------|
| D-001 | Fond clair obligatoire sur tout livrable visuel | 25/04/2026 |
| D-002 | Tout HTML doit importer design-tokens.css | 25/04/2026 |
| D-003 | Tout livrable passe par pre-deliver.sh avant soumission à Franco | 25/04/2026 |
| D-004 | Organisation horizontale — pas de directeur au sens hiérarchique | 25/04/2026 |

---

## PIÈCES FROIDES CONSTRUITES

| Fichier | Rôle | Propriétaire | Date | Statut |
|---------|------|-------------|------|--------|
| `design-tokens.css` | Variables de design gelées (fond blanc, couleurs équipe) | Léonore | 25/04/2026 | ✅ Gelé |
| `cold-validator.py` | Valide luminance des fonds + présence design-tokens | Léandro | 25/04/2026 | ✅ Gelé |
| `SKELETON.html` | Squelette HTML immuable avec zones [[PLACEHOLDER]] | Léonie | 25/04/2026 | ✅ Gelé |
| `pre-deliver.sh` | Verrou de livraison — 3 checks binaires avant Franco | Léonide | 25/04/2026 | ✅ Gelé |

---

## CE QU'ON NE FAIT PLUS

- Proposer une solution IA (Hot) à un problème de conformité répété.
- Mettre une instruction dans un handoff en espérant qu'elle sera lue.
- Dire "ça va être un bon sujet de travail" sans acte immédiat.
- Livrer un fichier HTML sans passer par pre-deliver.sh.
- Produire un design à fond sombre.

---

## PROCHAINE SESSION

À compléter par l'équipe.

---

*Ce document est vivant. Il grandit à chaque session. Il ne se réécrit pas — il s'accumule.*
