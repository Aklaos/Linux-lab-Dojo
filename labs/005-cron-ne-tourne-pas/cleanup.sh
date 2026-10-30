#!/usr/bin/env bash
# Lab 005 : annule tout (tâche cron et /opt/lab-005).
set -euo pipefail

LAB="lab-005"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

rm -f "/etc/cron.d/${LAB}-backup"
rm -rf "/opt/${LAB:?}"
echo "Machine remise en état."
