#!/usr/bin/env bash
# Lab NNN : annule tout ce que setup.sh a créé. Sûr même après un échec.
set -euo pipefail

LAB="lab-NNN"
DIR="/opt/${LAB}"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

# --- Annuler l'incident ici (tolérer l'absence : || true) ---

rm -rf "${DIR:?}"
echo "VM remise en état."
