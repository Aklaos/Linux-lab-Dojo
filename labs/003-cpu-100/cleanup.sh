#!/usr/bin/env bash
# Lab 003 : annule tout (services, unités, /opt/lab-003).
set -euo pipefail

LAB="lab-003"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

for u in "${LAB}-report" "${LAB}-api"; do
  systemctl disable --now "$u" 2>/dev/null || true
  rm -f "/etc/systemd/system/${u}.service"
done
systemctl daemon-reload
rm -rf "/opt/${LAB:?}"
echo "Machine remise en état."
