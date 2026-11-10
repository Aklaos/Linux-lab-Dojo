#!/usr/bin/env bash
# Lab 013 : annule tout (planification, service, /opt/lab-013).
set -euo pipefail

LAB="lab-013"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

systemctl disable --now "${LAB}-sync.timer" 2>/dev/null || true
systemctl stop "${LAB}-sync.service" 2>/dev/null || true
rm -f "/etc/systemd/system/${LAB}-sync.timer" "/etc/systemd/system/${LAB}-sync.service"
systemctl daemon-reload
rm -rf "/opt/${LAB:?}"
echo "Machine remise en état."
