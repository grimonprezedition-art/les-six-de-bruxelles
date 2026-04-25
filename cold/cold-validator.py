#!/usr/bin/env python3
"""
cold-validator.py — PIÈCE FROIDE
Propriétaire : Léandro (Constructeur P4)
Signé P0 : Franco Grimonprez — 25 avril 2026
Statut : GELÉ — aucune modification sans signature P0

Usage : python3 cold-validator.py <fichier.html>
Exit 0 = validé. Exit 1 = bloqué.

Ce script ne sait pas qu'une IA a produit le fichier.
Il calcule. C'est tout.
"""

import sys
import re

# Seuil de luminance minimale pour un fond acceptable (0.0 = noir, 1.0 = blanc)
LUMINANCE_THRESHOLD = 0.45

def luminance(hex_color: str) -> float:
    """Calcule la luminance perçue d'une couleur hex."""
    h = hex_color.lstrip('#')
    if len(h) == 3:
        h = ''.join(c * 2 for c in h)
    if len(h) != 6:
        return 1.0  # couleur non parsable → on ne bloque pas
    r = int(h[0:2], 16) / 255
    g = int(h[2:4], 16) / 255
    b = int(h[4:6], 16) / 255
    return 0.299 * r + 0.587 * g + 0.114 * b

def luminance_rgb(r: int, g: int, b: int) -> float:
    return (0.299 * r + 0.587 * g + 0.114 * b) / 255

def check_file(path: str) -> list[str]:
    errors = []
    try:
        content = open(path, encoding='utf-8').read()
    except Exception as e:
        return [f"Impossible de lire le fichier : {e}"]

    # 1. Vérifier que design-tokens.css est importé
    if 'design-tokens.css' not in content:
        errors.append("IMPORT MANQUANT : design-tokens.css n'est pas importé.")

    # 2. Détecter les fonds sombres en hex (#000, #111, #1a1a1a, etc.)
    for match in re.finditer(
        r'background(?:-color)?\s*:\s*(#[0-9a-fA-F]{3,6})',
        content
    ):
        color = match.group(1)
        lum = luminance(color)
        if lum < LUMINANCE_THRESHOLD:
            errors.append(
                f"FOND SOMBRE : background '{color}' "
                f"(luminance {lum:.2f} < {LUMINANCE_THRESHOLD})"
            )

    # 3. Détecter les fonds rgb() sombres
    for match in re.finditer(
        r'background(?:-color)?\s*:\s*rgb\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)',
        content
    ):
        r, g, b = int(match.group(1)), int(match.group(2)), int(match.group(3))
        lum = luminance_rgb(r, g, b)
        if lum < LUMINANCE_THRESHOLD:
            errors.append(
                f"FOND SOMBRE : background rgb({r},{g},{b}) "
                f"(luminance {lum:.2f} < {LUMINANCE_THRESHOLD})"
            )

    # 4. Détecter les mots-clés nommés sombres
    dark_keywords = ['background: black', 'background-color: black',
                     'background: #000', 'background-color: #000']
    for kw in dark_keywords:
        if kw in content.lower():
            errors.append(f"FOND SOMBRE : mot-clé détecté '{kw}'")

    return errors

def main():
    if len(sys.argv) < 2:
        print("Usage : python3 cold-validator.py <fichier.html>")
        sys.exit(2)

    path = sys.argv[1]
    errors = check_file(path)

    if errors:
        print(f"\n🔴 VALIDATION ÉCHOUÉE — {path}")
        for e in errors:
            print(f"   ❌ {e}")
        print("\n   Ce fichier ne peut pas être soumis à Franco.\n")
        sys.exit(1)
    else:
        print(f"\n✅ VALIDATION OK — {path}")
        print("   Fond clair confirmé. Prêt pour pre-deliver.sh\n")
        sys.exit(0)

if __name__ == '__main__':
    main()
