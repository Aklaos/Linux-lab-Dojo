#!/usr/bin/env bash
# Crée la branche d'un lab depuis main.
set -euo pipefail
cd "$(dirname "$0")/.."
git switch main
git pull --ff-only
git switch -c "lab-$1"
