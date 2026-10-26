#!/usr/bin/env bash
# Fin d'un lab : commit, push et passage de la PR en « prête à fusionner ».
# La fusion est faite par le mainteneur (elle ferme aussi le ticket).
# Usage : ./scripts/publish-lab.sh 001-disque-plein
set -euo pipefail
cd "$(dirname "$0")/.."

LAB="${1:?Usage : $0 NNN-theme}"

git add -A
git commit -m "Lab $LAB"
git push -u origin HEAD
gh pr ready
