#!/usr/bin/env bash
# Lab 011 : annule tout (services, unités, /opt/lab-011).
set -euo pipefail

LAB="lab-011"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

for u in "${LAB}-app" "${LAB}-db"; do
  systemctl disable --now "$u" 2>/dev/null || true
  rm -f "/etc/systemd/system/${u}.service"
done
systemctl daemon-reload
rm -rf "/opt/${LAB:?}"
echo "Machine remise en état."
