#!/usr/bin/env bash
# Lab 012 : un script qui marche dans un shell de connexion échoue sous systemd.
set -euo pipefail

LAB="lab-012"
DIR="/opt/${LAB}"
UNIT="${LAB}-report"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

# Dans le conteneur jetable, pas de confirmation.
# Sur une vraie machine ou une VM, on demande avant de dégrader quoi que ce soit.
if [ ! -e /run/.containerenv ]; then
  echo "Ce script va dégrader cette machine. Elle doit être jetable."
  read -r -p "Tape oui pour continuer : " rep
  [ "$rep" = "oui" ] || { echo "Annulé."; exit 1; }
fi

# Idempotent : on repart d'un état propre.
systemctl stop "$UNIT" 2>/dev/null || true
rm -rf "/etc/systemd/system/${UNIT}.service.d"
mkdir -p "${DIR}/reports"

echo 'TITLE="Rapport mensuel"' > "${DIR}/report.conf"

# Le script : lit une configuration relative et exige une variable d'environnement.
cat > "${DIR}/report.sh" <<'SCRIPT'
#!/bin/bash
if ! . ./report.conf 2>/dev/null; then
  echo "report : impossible de lire ./report.conf" >&2
  exit 1
fi
if [ -z "${REPORT_DIR:-}" ]; then
  echo "report : variable REPORT_DIR absente" >&2
  exit 1
fi
while true; do
  echo "report : rapport genere dans ${REPORT_DIR} (${TITLE})"
  sleep 5
done
SCRIPT
chmod +x "${DIR}/report.sh"

# La variable n'existe que dans les shells de connexion (profil système).
echo "export REPORT_DIR=${DIR}/reports" > /etc/profile.d/lab-012.sh

cat > "/etc/systemd/system/${UNIT}.service" <<UNITFILE
[Unit]
Description=Generation de rapports du lab 012
StartLimitIntervalSec=0

[Service]
ExecStart=${DIR}/report.sh
Restart=on-failure
RestartSec=3

[Install]
WantedBy=multi-user.target
UNITFILE

systemctl daemon-reload
systemctl enable --now "$UNIT" >/dev/null 2>&1 || true

echo "Lab prêt. C'est parti, 10 minutes."
