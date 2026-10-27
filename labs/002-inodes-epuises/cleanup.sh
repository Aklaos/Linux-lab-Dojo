#!/usr/bin/env bash
# Lab 002 : annule tout (démontage et suppression de /opt/lab-002).
set -euo pipefail

DIR="/opt/lab-002"
MNT="${DIR}/data"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

# Se placer hors du point de montage pour pouvoir le démonter.
cd /
if mountpoint -q "$MNT"; then
  umount "$MNT" || umount -l "$MNT"
fi
rm -rf "${DIR:?}"
echo "Machine remise en état."
