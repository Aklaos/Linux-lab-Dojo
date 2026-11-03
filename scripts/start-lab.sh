#!/usr/bin/env bash
# Démarre un lab en une commande : ticket, branche, PR en brouillon, puis conteneur.
# Les fichiers du lab doivent déjà exister dans labs/NNN-nom/ (non commités, c'est normal).
# Usage : ./scripts/start-lab.sh 008-nom-du-lab
set -euo pipefail
cd "$(dirname "$0")/.."

LAB="${1:?Usage : $0 NNN-nom}"
[ -f "labs/${LAB}/setup.sh" ] || { echo "Lab introuvable : $LAB"; exit 1; }

./scripts/open-lab.sh "$LAB"
exec ./scripts/lab-run.sh "$LAB"
