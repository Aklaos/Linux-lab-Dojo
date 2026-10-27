#!/usr/bin/env bash
# Lab 003 : un service sature le CPU et redémarre s'il est tué.
set -euo pipefail

LAB="lab-003"
DIR="/opt/${LAB}"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

# Dans le conteneur jetable, pas de confirmation.
# Sur une vraie machine ou une VM, on demande avant de dégrader quoi que ce soit.
if [ ! -e /run/.containerenv ]; then
  echo "Ce script va dégrader cette machine. Elle doit être jetable."
  read -r -p "Tape oui pour continuer : " rep
  [ "$rep" = "oui" ] || { echo "Annulé."; exit 1; }
fi

# Idempotent : on arrête les services avant de les recréer.
systemctl stop "${LAB}-report" "${LAB}-api" 2>/dev/null || true

mkdir -p "$DIR"

# Service sain : une petite API qui écrit un battement toutes les 5 s.
cat > "${DIR}/api.sh" <<'SCRIPT'
#!/bin/bash
while true; do
  echo "$(date +%T) api ok" >> /opt/lab-003/api.log
  sleep 5
done
SCRIPT

# Service fautif : une génération de rapports qui boucle sans pause.
cat > "${DIR}/report-generator.sh" <<'SCRIPT'
#!/bin/bash
while :; do :; done
SCRIPT
chmod +x "${DIR}/api.sh" "${DIR}/report-generator.sh"

cat > "/etc/systemd/system/${LAB}-api.service" <<UNIT
[Unit]
Description=API du lab 003

[Service]
ExecStart=${DIR}/api.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
UNIT

cat > "/etc/systemd/system/${LAB}-report.service" <<UNIT
[Unit]
Description=Generation des rapports du lab 003

[Service]
ExecStart=${DIR}/report-generator.sh
Restart=always
RestartSec=1

[Install]
WantedBy=multi-user.target
UNIT

systemctl daemon-reload
systemctl enable --now "${LAB}-api" "${LAB}-report" >/dev/null 2>&1

echo "Lab prêt. C'est parti, 10 minutes."
