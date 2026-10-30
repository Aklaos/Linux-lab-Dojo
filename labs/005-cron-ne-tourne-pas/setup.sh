#!/usr/bin/env bash
# Lab 005 : une tâche cron mal écrite et un script non exécutable.
set -euo pipefail

LAB="lab-005"
DIR="/opt/${LAB}"
CRONFILE="/etc/cron.d/${LAB}-backup"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

# Dans le conteneur jetable, pas de confirmation.
# Sur une vraie machine ou une VM, on demande avant de dégrader quoi que ce soit.
if [ ! -e /run/.containerenv ]; then
  echo "Ce script va dégrader cette machine. Elle doit être jetable."
  read -r -p "Tape oui pour continuer : " rep
  [ "$rep" = "oui" ] || { echo "Annulé."; exit 1; }
fi

mkdir -p "$DIR"
rm -f "${DIR}/backup.log"

# Le script de sauvegarde (simulé) : non exécutable.
cat > "${DIR}/backup.sh" <<'SCRIPT'
#!/bin/bash
echo "$(date +%T) sauvegarde ok"
SCRIPT
chmod 644 "${DIR}/backup.sh"

# Tâche cron système : il manque le champ « utilisateur » exigé dans /etc/cron.d.
cat > "$CRONFILE" <<'CRON'
# Sauvegarde du lab 005, toutes les minutes
* * * * * /opt/lab-005/backup.sh >> /opt/lab-005/backup.log 2>&1
CRON
chmod 644 "$CRONFILE"

systemctl enable --now cron >/dev/null 2>&1 || true
systemctl restart cron

echo "Lab prêt. C'est parti, 10 minutes."
