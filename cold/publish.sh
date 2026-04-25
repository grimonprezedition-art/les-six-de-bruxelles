#!/bin/bash
# ==============================================================
# publish.sh — PIÈCE FROIDE
# Propriétaire : Léonide (Juge)
# Signé P0 : Franco Grimonprez — 25 avril 2026
# Statut : GELÉ — aucune modification sans signature P0
#
# Usage : bash publish.sh <auteur> <modele> <fichier.html>
#
# Exemples :
#   bash publish.sh leon claude-opus-4-6 entree-d1.html
#   bash publish.sh franco human journal-d0.html
#
# Ce script est le seul chemin autorisé entre un Léo et le repo.
# Il valide, date, tague, et publie. Il ne juge pas le contenu.
# ==============================================================

set -euo pipefail

AUTEUR="${1:-}"
MODELE="${2:-}"
FILE="${3:-}"
D0_DATE="2026-04-25"
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TOKEN_FILE="$REPO_DIR/.token"

# ── Vérification des arguments ──────────────────────────────
if [ -z "$AUTEUR" ] || [ -z "$MODELE" ] || [ -z "$FILE" ]; then
  echo "Usage : bash publish.sh <auteur> <modele> <fichier.html>"
  echo "Auteurs valides : leon, leonore, leandro, leonie, leonide, franco"
  exit 2
fi

AUTEURS_VALIDES="leon leonore leandro leonie leonide franco"
if ! echo "$AUTEURS_VALIDES" | grep -qw "$AUTEUR"; then
  echo "❌ Auteur invalide : $AUTEUR"
  exit 1
fi

if [ ! -f "$FILE" ]; then
  echo "❌ Fichier introuvable : $FILE"
  exit 1
fi

echo ""
echo "══════════════════════════════════════════════════"
echo "  PUBLICATION — Léonide"
echo "  Auteur  : $AUTEUR"
echo "  Modèle  : $MODELE"
echo "  Fichier : $FILE"
echo "══════════════════════════════════════════════════"

# ── CHECK 1 : pre-deliver.sh ─────────────────────────────────
echo ""
echo "[ 1/4 ] Contrôle pre-deliver..."
if bash "$(dirname "$0")/pre-deliver.sh" "$FILE"; then
  echo "        → Validé"
else
  echo "        ❌ Bloqué par pre-deliver.sh — publication annulée."
  exit 1
fi

# ── CHECK 2 : Calcul du D-number ─────────────────────────────
echo ""
echo "[ 2/4 ] Calcul du D-number..."
D_NUMBER=$(python3 -c "
from datetime import date
d0 = date(2026, 4, 25)
today = date.today()
diff = (today - d0).days
print(f'D{diff:+d}' if diff != 0 else 'D0')
")
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
echo "        → $D_NUMBER — $TIMESTAMP"

# ── CHECK 3 : Copie vers entries/ ───────────────────────────
echo ""
echo "[ 3/4 ] Copie vers entries/$AUTEUR/..."
FILENAME=$(basename "$FILE" .html)
DEST_NAME="${FILENAME}__${D_NUMBER}__${TIMESTAMP//:/-}.html"
DEST_PATH="$REPO_DIR/entries/$AUTEUR/$DEST_NAME"
cp "$FILE" "$DEST_PATH"
echo "        → $DEST_PATH"

# ── CHECK 4 : Git commit + push ──────────────────────────────
echo ""
echo "[ 4/4 ] Commit et push..."
cd "$REPO_DIR"

# Token HTTPS
if [ -f "$TOKEN_FILE" ]; then
  GH_TOKEN=$(cat "$TOKEN_FILE" | tr -d '[:space:]')
  git remote set-url origin "https://${GH_TOKEN}@github.com/grimonprezedition-art/les-six-de-bruxelles.git"
fi

git add "entries/$AUTEUR/$DEST_NAME"
git commit -m "${D_NUMBER} | ${AUTEUR} | ${MODELE} | ${TIMESTAMP}"
git push origin main

# ── VERDICT ──────────────────────────────────────────────────
echo ""
echo "══════════════════════════════════════════════════"
echo "  ✅ PUBLIÉ : entries/$AUTEUR/$DEST_NAME"
echo "  D-number : $D_NUMBER"
echo "  Modèle   : $MODELE"
echo "  Heure    : $TIMESTAMP"
echo "══════════════════════════════════════════════════"
echo ""
