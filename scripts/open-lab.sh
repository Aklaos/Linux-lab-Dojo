#!/usr/bin/env bash
# Ouvre un lab : ticket GitHub, branche depuis main, PR en brouillon liée au ticket.
# Usage : ./scripts/open-lab.sh 001-disque-plein
set -euo pipefail
cd "$(dirname "$0")/.."

LAB="${1:?Usage : $0 NNN-theme}"

git switch main
git pull --ff-only
git switch -c "lab-$LAB"

# Ticket (issue) du lab ; on récupère son numéro dans l'URL renvoyée.
ISSUE_URL="$(gh issue create --title "Lab $LAB" --body "Mini-lab Linux de 10 minutes.")"
ISSUE="${ISSUE_URL##*/}"

# Un commit vide permet d'ouvrir la PR avant d'avoir écrit le lab.
git commit --allow-empty -m "Ouverture du lab $LAB"
git push -u origin "lab-$LAB"
gh pr create --draft --title "Lab $LAB" --body "Mini-lab Linux de 10 minutes. Closes #$ISSUE"
