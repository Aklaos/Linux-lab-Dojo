#!/usr/bin/env bash
# Lab NNN : crée l'incident. Ne touche qu'au périmètre du lab.
set -euo pipefail

LAB="lab-NNN"          # préfixe de tout ce que crée ce lab
DIR="/opt/${LAB}"      # dossier propre au lab

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

echo "Ce script va dégrader cette machine. Elle doit être jetable."
read -r -p "Tape oui pour continuer : " rep
[ "$rep" = "oui" ] || { echo "Annulé."; exit 1; }

# Idempotent : on peut le relancer sans casser plus.
mkdir -p "$DIR"

# --- Création de l'incident ici (uniquement dans $DIR, ${LAB}-*, /tmp/${LAB}-*) ---

echo "Lab prêt. C'est parti, 10 minutes."
