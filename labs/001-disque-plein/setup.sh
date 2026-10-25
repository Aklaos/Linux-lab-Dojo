#!/usr/bin/env bash
# Lab 001 : remplit une petite image disque montée dans /opt/lab-001.
set -euo pipefail

LAB="lab-001"
DIR="/opt/${LAB}"
IMG="${DIR}/disk.img"
MNT="${DIR}/data"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

echo "Ce script va dégrader cette machine. Elle doit être jetable."
read -r -p "Tape oui pour continuer : " rep
[ "$rep" = "oui" ] || { echo "Annulé."; exit 1; }

# Idempotent : on repart d'un état propre.
if mountpoint -q "$MNT"; then
  umount "$MNT" || umount -l "$MNT"
fi
mkdir -p "$MNT"
rm -f "$IMG"

# Petit disque de 64 Mo, sans espace réservé à root.
fallocate -l 64M "$IMG"
mkfs.ext4 -q -F -m 0 "$IMG"
mount -o loop "$IMG" "$MNT"

# Contenu de l'application.
mkdir -p "$MNT/app" "$MNT/cache" "$MNT/logs/archive"
fallocate -l 1M "$MNT/app/important.db"
for i in 1 2 3 4 5; do
  fallocate -l 1M "$MNT/cache/tmp-$i.dat"
done
echo "appli demarree" > "$MNT/logs/app.log"

# Une archive de logs oubliée avale tout l'espace restant.
avail=$(df --output=avail -B1 "$MNT" | tail -n 1 | tr -d ' ')
fallocate -l "$avail" "$MNT/logs/archive/app-2024.log.old"

echo "Lab prêt. C'est parti, 10 minutes."
