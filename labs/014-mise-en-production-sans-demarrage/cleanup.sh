#!/usr/bin/env bash
# Lab 014 : annule tout (service, unité, /opt/lab-014).
set -euo pipefail

LAB="lab-014"
UNIT="${LAB}-app"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

systemctl disable --now "$UNIT" 2>/dev/null || true
rm -f "/etc/systemd/system/${UNIT}.service"
systemctl daemon-reload
rm -rf "/opt/${LAB:?}"
echo "Machine remise en état."
