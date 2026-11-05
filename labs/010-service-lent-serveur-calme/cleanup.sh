#!/usr/bin/env bash
# Lab 010 : annule tout (service, unité, drop-ins, /opt/lab-010).
set -euo pipefail

LAB="lab-010"
UNIT="${LAB}-batch"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

systemctl disable --now "$UNIT" 2>/dev/null || true
rm -rf "/etc/systemd/system/${UNIT}.service" "/etc/systemd/system/${UNIT}.service.d"
systemctl daemon-reload
rm -rf "/opt/${LAB:?}"
echo "Machine remise en état."
