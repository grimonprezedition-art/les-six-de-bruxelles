#!/bin/bash
# ==============================================================
# pre-deliver.sh — PIÈCE FROIDE
# Propriétaire : Léonide (Juge)
# Signé P0 : Franco Grimonprez — 25 avril 2026
# Statut : GELÉ — aucune modification sans signature P0
#
# Usage : bash pre-deliver.sh <fichier.html>
# Exit 0 = livrable autorisé. Exit 1 = bloqué.
#
# Ce script est le seul verrou entre l'IA et Franco.
# Aucun fichier HTML ne peut être soumis à Franco
# sans avoir passé ce script.
# ==============================================================

set -euo pipefail

FILE="${1:-}"

if [ -z "$FILE" ]; then
  echo "Usage : bash pre-deliver.sh <fichier.html>"
  exit 2
fi

if [ ! -f "$FILE" ]; then
  echo "❌ Fichier introuvable : $FILE"
  exit 1
fi

echo ""
echo "══════════════════════════════════════════"
echo "  CONTRÔLE PRÉ-LIVRAISON — Léonide"
echo "  Fichier : $FILE"
echo "══════════════════════════════════════════"

ERRORS=0

# ── CHECK 1 : cold-validator.py (fond clair + import tokens) ──
echo ""
echo "[ 1/3 ] Validation fond clair..."
if python3 "$(dirname "$0")/cold-validator.py" "$FILE"; then
  echo "        → OK"
else
  ERRORS=$((ERRORS + 1))
fi

# ── CHECK 2 : skeleton utilisé (présence du commentaire PIÈCE FROIDE) ──
echo ""
echo "[ 2/3 ] Vérification structure skeleton..."
if grep -q "design-tokens.css" "$FILE"; then
  echo "        ✅ design-tokens.css référencé"
else
  echo "        ❌ design-tokens.css absent"
  ERRORS=$((ERRORS + 1))
fi

# ── CHECK 3 : pas de style inline sombre sur body/html ──
echo ""
echo "[ 3/3 ] Détection styles inline interdits..."
if grep -qiE 'style="[^"]*background[^"]*#[0-9a-f]{3,6}' "$FILE"; then
  echo "        ❌ Style inline avec couleur de fond détecté"
  ERRORS=$((ERRORS + 1))
else
  echo "        ✅ Aucun style inline de fond détecté"
fi

# ── VERDICT ──
echo ""
echo "══════════════════════════════════════════"
if [ $ERRORS -eq 0 ]; then
  echo "  ✅ VERDICT : LIVRABLE AUTORISÉ"
  echo "  Ce fichier peut être soumis à Franco."
  echo "══════════════════════════════════════════"
  echo ""
  exit 0
else
  echo "  🔴 VERDICT : BLOQUÉ ($ERRORS erreur(s))"
  echo "  Ce fichier NE PEUT PAS être soumis à Franco."
  echo "  Corriger les erreurs et relancer."
  echo "══════════════════════════════════════════"
  echo ""
  exit 1
fi
