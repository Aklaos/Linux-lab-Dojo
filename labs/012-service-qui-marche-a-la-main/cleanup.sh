#!/usr/bin/env bash
# Lab 012 : annule tout (service, unité, profil, /opt/lab-012).
set -euo pipefail

LAB="lab-012"
UNIT="${LAB}-report"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

systemctl disable --now "$UNIT" 2>/dev/null || true
rm -rf "/etc/systemd/system/${UNIT}.service" "/etc/systemd/system/${UNIT}.service.d"
rm -f /etc/profile.d/lab-012.sh
systemctl daemon-reload
rm -rf "/opt/${LAB:?}"
echo "Machine remise en état."
