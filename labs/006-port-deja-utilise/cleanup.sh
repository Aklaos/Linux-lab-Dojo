#!/usr/bin/env bash
# Lab 006 : annule tout (service, processus oublié, /opt/lab-006).
set -euo pipefail

LAB="lab-006"
PIDFILE="/tmp/${LAB}-stray.pid"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

systemctl stop "${LAB}-api.service" >/dev/null 2>&1 || true
if [ -f "$PIDFILE" ]; then kill "$(cat "$PIDFILE")" 2>/dev/null || true; fi
rm -f "$PIDFILE" "/etc/systemd/system/${LAB}-api.service"
systemctl daemon-reload
rm -rf "/opt/${LAB:?}"
echo "Machine remise en état."
