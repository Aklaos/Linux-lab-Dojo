#!/usr/bin/env bash
# Lab 009 : annule tout (service, unité, drop-ins, /opt/lab-009).
set -euo pipefail

LAB="lab-009"
UNIT="${LAB}-workers"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

systemctl disable --now "$UNIT" 2>/dev/null || true
rm -rf "/etc/systemd/system/${UNIT}.service" "/etc/systemd/system/${UNIT}.service.d"
systemctl daemon-reload
rm -rf "/opt/${LAB:?}"
echo "Machine remise en état."
