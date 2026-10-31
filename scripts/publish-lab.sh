#!/usr/bin/env bash
# Fin d'un lab : commit, push, PR « prête », fusion, retour sur main à jour.
# La fusion ferme aussi le ticket et supprime la branche.
# Usage : ./scripts/publish-lab.sh 001-disque-plein
set -euo pipefail
cd "$(dirname "$0")/.."

LAB="${1:?Usage : $0 NNN-theme}"

# Tout dans une fonction : bash lit le script en entier avant de changer de branche.
publier() {
  git add -A
  git diff --cached --quiet || git commit -m "Lab $LAB"
  git push -u origin HEAD
  gh pr ready || true
  gh pr merge --merge --delete-branch
  git switch main
  git pull
}
publier
exit
