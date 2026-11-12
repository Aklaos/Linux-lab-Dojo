#!/usr/bin/env bash
# Lab 014 : un déploiement par lien symbolique « current » mal pointé, avec un script non exécutable.
set -euo pipefail

LAB="lab-014"
DIR="/opt/${LAB}"
UNIT="${LAB}-app"

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
rm -rf "${DIR}/releases" "${DIR}/current"
mkdir -p "${DIR}/releases/2026-11-11/bin" "${DIR}/releases/2026-11-12/bin"

# Ancienne version : fonctionne.
cat > "${DIR}/releases/2026-11-11/bin/app.sh" <<'SCRIPT'
#!/bin/bash
while true; do echo "app : version 2026-11-11 en marche"; sleep 5; done
SCRIPT
chmod 755 "${DIR}/releases/2026-11-11/bin/app.sh"

# Nouvelle version : le fichier n'est pas exécutable.
cat > "${DIR}/releases/2026-11-12/bin/app.sh" <<'SCRIPT'
#!/bin/bash
while true; do echo "app : version 2026-11-12 en marche"; sleep 5; done
SCRIPT
chmod 644 "${DIR}/releases/2026-11-12/bin/app.sh"

# Le lien « current » pointe vers un dossier qui n'existe pas (faute de frappe dans la date).
ln -s releases/2026-11-2 "${DIR}/current"

cat > "/etc/systemd/system/${UNIT}.service" <<UNITFILE
[Unit]
Description=Application du lab 014
StartLimitIntervalSec=0

[Service]
ExecStart=${DIR}/current/bin/app.sh
Restart=on-failure
RestartSec=3

[Install]
WantedBy=multi-user.target
UNITFILE

systemctl daemon-reload
systemctl enable --now "$UNIT" >/dev/null 2>&1 || true

echo "Lab prêt. C'est parti, 10 minutes."
