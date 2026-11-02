#!/usr/bin/env bash
# Lab 007 : annule tout (service, unité, /opt/lab-007).
set -euo pipefail

LAB="lab-007"
UNIT="${LAB}-cache"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

systemctl disable --now "$UNIT" 2>/dev/null || true
rm -f "/etc/systemd/system/${UNIT}.service"
systemctl daemon-reload
rm -rf "/opt/${LAB:?}"
echo "Machine remise en état."
