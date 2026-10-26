#!/usr/bin/env bash
# Lab 001 : annule tout (démontage et suppression de /opt/lab-001).
set -euo pipefail

DIR="/opt/lab-001"
MNT="${DIR}/data"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

# Se placer hors du point de montage pour pouvoir le démonter.
cd /
if mountpoint -q "$MNT"; then
  umount "$MNT" || umount -l "$MNT"
fi
rm -rf "${DIR:?}"
echo "VM remise en état."
