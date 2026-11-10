#!/usr/bin/env bash
# Lab 013 : une planification systemd installée mais jamais démarrée, avec un nom de service erroné.
set -euo pipefail

LAB="lab-013"
DIR="/opt/${LAB}"
SVC="${LAB}-sync"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

# Dans le conteneur jetable, pas de confirmation.
# Sur une vraie machine ou une VM, on demande avant de dégrader quoi que ce soit.
if [ ! -e /run/.containerenv ]; then
  echo "Ce script va dégrader cette machine. Elle doit être jetable."
  read -r -p "Tape oui pour continuer : " rep
  [ "$rep" = "oui" ] || { echo "Annulé."; exit 1; }
fi

# Idempotent : on repart d'un état propre.
systemctl stop "${SVC}.timer" "${SVC}.service" 2>/dev/null || true
systemctl disable "${SVC}.timer" 2>/dev/null || true
mkdir -p "$DIR"
: > "${DIR}/sync.log"

cat > "${DIR}/sync.sh" <<'SCRIPT'
#!/bin/bash
echo "$(date +%T) synchronisation ok" >> /opt/lab-013/sync.log
SCRIPT
chmod +x "${DIR}/sync.sh"

# Le travail à lancer.
cat > "/etc/systemd/system/${SVC}.service" <<UNITFILE
[Unit]
Description=Synchronisation du lab 013

[Service]
Type=oneshot
ExecStart=${DIR}/sync.sh
UNITFILE

# La planification : toutes les minutes. Le nom du service visé contient une faute de frappe.
cat > "/etc/systemd/system/${SVC}.timer" <<UNITFILE
[Unit]
Description=Planification de la synchronisation du lab 013

[Timer]
OnCalendar=minutely
Unit=${LAB}-sncy.service

[Install]
WantedBy=timers.target
UNITFILE

# La planification est installée, mais ni activée ni démarrée.
systemctl daemon-reload

echo "Lab prêt. C'est parti, 10 minutes."
