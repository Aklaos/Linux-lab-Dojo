#!/usr/bin/env bash
# Lab 004 : un service tourne sous un utilisateur dédié, mais fichiers et dossier lui sont interdits.
set -euo pipefail

LAB="lab-004"
DIR="/opt/${LAB}"
USER_NAME="lab004"
UNIT="${LAB}-app"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

# Dans le conteneur jetable, pas de confirmation.
# Sur une vraie machine ou une VM, on demande avant de dégrader quoi que ce soit.
if [ ! -e /run/.containerenv ]; then
  echo "Ce script va dégrader cette machine. Elle doit être jetable."
  read -r -p "Tape oui pour continuer : " rep
  [ "$rep" = "oui" ] || { echo "Annulé."; exit 1; }
fi

# Idempotent : on arrête le service avant de tout recréer.
systemctl stop "$UNIT" 2>/dev/null || true
id "$USER_NAME" >/dev/null 2>&1 || useradd --system --no-create-home --shell /usr/sbin/nologin "$USER_NAME"

mkdir -p "${DIR}/data"
cat > "${DIR}/app.sh" <<'APP'
#!/bin/bash
# Petite appli : lit sa configuration, puis écrit une ligne toutes les 5 s.
CONF=/opt/lab-004/app.conf
DATA=/opt/lab-004/data
. "$CONF" || { echo "lecture impossible : $CONF" >&2; exit 1; }
while true; do
  echo "$(date +%T) ${MESSAGE}" >> "${DATA}/app.log" || { echo "écriture impossible dans ${DATA}" >&2; exit 1; }
  sleep 5
done
APP
echo 'MESSAGE="appli en marche"' > "${DIR}/app.conf"
echo "donnees importantes" > "${DIR}/data/important.db"
rm -f "${DIR}/data/app.log"

# Après la « maintenance » : tout appartient à root, config fermée au service, dossier fermé en écriture.
chown root:root "${DIR}" "${DIR}/app.sh" "${DIR}/app.conf" "${DIR}/data" "${DIR}/data/important.db"
chmod 755 "${DIR}" "${DIR}/app.sh" "${DIR}/data"
chmod 600 "${DIR}/app.conf"
chmod 644 "${DIR}/data/important.db"

cat > "/etc/systemd/system/${UNIT}.service" <<UNITFILE
[Unit]
Description=Petite appli du lab 004
StartLimitIntervalSec=0

[Service]
User=${USER_NAME}
ExecStart=${DIR}/app.sh
Restart=on-failure
RestartSec=2

[Install]
WantedBy=multi-user.target
UNITFILE

systemctl daemon-reload
systemctl enable --now "$UNIT" >/dev/null 2>&1

echo "Lab prêt. C'est parti, 10 minutes."
