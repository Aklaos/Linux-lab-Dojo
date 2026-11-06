#!/usr/bin/env bash
# Lab 011 : une application dépend d'un service dont la configuration contient deux erreurs.
set -euo pipefail

LAB="lab-011"
DIR="/opt/${LAB}"
DB="${LAB}-db"
APP="${LAB}-app"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

# Dans le conteneur jetable, pas de confirmation.
# Sur une vraie machine ou une VM, on demande avant de dégrader quoi que ce soit.
if [ ! -e /run/.containerenv ]; then
  echo "Ce script va dégrader cette machine. Elle doit être jetable."
  read -r -p "Tape oui pour continuer : " rep
  [ "$rep" = "oui" ] || { echo "Annulé."; exit 1; }
fi

# Idempotent : on repart d'un état propre.
systemctl stop "$APP" "$DB" 2>/dev/null || true
mkdir -p "${DIR}/data"

# Configuration livrée avec deux erreurs : un port mal écrit et un dossier qui n'existe pas.
cat > "${DIR}/db.conf" <<'CONF'
# Configuration de la base du lab 011
port=5432a
datadir=/opt/lab-011/donnees
CONF

# Initialisation de la base : valide la configuration, échoue s'il y a un problème.
cat > "${DIR}/db-init.sh" <<'SCRIPT'
#!/bin/bash
CONF=/opt/lab-011/db.conf
port=$(sed -n 's/^port=//p' "$CONF")
datadir=$(sed -n 's/^datadir=//p' "$CONF")
if ! [[ "$port" =~ ^[0-9]+$ ]]; then
  echo "db : configuration invalide : port='$port' (un nombre est attendu)" >&2
  exit 2
fi
if [ ! -d "$datadir" ]; then
  echo "db : dossier de donnees introuvable : $datadir" >&2
  exit 3
fi
echo "db : initialisee (port $port, donnees $datadir)"
SCRIPT

# L'application : traite des requêtes, une toutes les 5 secondes.
cat > "${DIR}/app.sh" <<'SCRIPT'
#!/bin/bash
while true; do
  echo "app : requete traitee, base connectee"
  sleep 5
done
SCRIPT
chmod +x "${DIR}/db-init.sh" "${DIR}/app.sh"

cat > "/etc/systemd/system/${DB}.service" <<UNITFILE
[Unit]
Description=Base du lab 011

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=${DIR}/db-init.sh

[Install]
WantedBy=multi-user.target
UNITFILE

cat > "/etc/systemd/system/${APP}.service" <<UNITFILE
[Unit]
Description=Application du lab 011
Requires=${DB}.service
After=${DB}.service

[Service]
ExecStart=${DIR}/app.sh

[Install]
WantedBy=multi-user.target
UNITFILE

systemctl daemon-reload
systemctl reset-failed "$APP" "$DB" 2>/dev/null || true
# Le démarrage échoue : c'est voulu.
systemctl start "$APP" >/dev/null 2>&1 || true

echo "Lab prêt. C'est parti, 10 minutes."
