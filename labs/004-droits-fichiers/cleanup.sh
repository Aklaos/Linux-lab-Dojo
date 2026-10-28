#!/usr/bin/env bash
# Lab 004 : annule tout (service, unité, utilisateur lab004, /opt/lab-004).
set -euo pipefail

LAB="lab-004"
UNIT="${LAB}-app"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

systemctl disable --now "$UNIT" 2>/dev/null || true
rm -f "/etc/systemd/system/${UNIT}.service"
systemctl daemon-reload
id lab004 >/dev/null 2>&1 && userdel lab004
rm -rf "/opt/${LAB:?}"
echo "Machine remise en état."
