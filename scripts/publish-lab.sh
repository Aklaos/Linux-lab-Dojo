#!/usr/bin/env bash
# Commit, push et PR en brouillon du lab en cours.
set -euo pipefail
cd "$(dirname "$0")/.."
git add -A
git commit -m "Lab $1"
git push -u origin "lab-$1"
gh pr create --draft --title "Lab $1" --body "Mini-lab Linux de 10 minutes."
