#!/usr/bin/env bash
# Lab 002 : épuise les inodes d'un petit disque monté dans /opt/lab-002.
set -euo pipefail

LAB="lab-002"
DIR="/opt/${LAB}"
IMG="${DIR}/disk.img"
MNT="${DIR}/data"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

# Dans le conteneur jetable (disque fourni), pas de confirmation.
# Sur une vraie machine ou une VM, on demande avant de dégrader quoi que ce soit.
if ! { mountpoint -q "$MNT" && [ ! -e "$IMG" ]; }; then
  echo "Ce script va dégrader cette machine. Elle doit être jetable."
  read -r -p "Tape oui pour continuer : " rep
  [ "$rep" = "oui" ] || { echo "Annulé."; exit 1; }
fi

# Idempotent : on repart d'un état propre.
if mountpoint -q "$MNT" && [ ! -e "$IMG" ]; then
  # Disque déjà fourni (ex. tmpfs d'un conteneur) : on le vide, rien d'autre.
  find "$MNT" -mindepth 1 -delete
else
  # Sinon : petit disque de 64 Mo avec très peu d'inodes.
  if mountpoint -q "$MNT"; then
    umount "$MNT" || umount -l "$MNT"
  fi
  mkdir -p "$MNT"
  rm -f "$IMG"
  fallocate -l 64M "$IMG"
  mkfs.ext4 -q -F -m 0 -N 4096 "$IMG"
  mount -o loop "$IMG" "$MNT"
fi

# Contenu de l'application.
mkdir -p "$MNT/app" "$MNT/logs" "$MNT/spool/sessions"
fallocate -l 1M "$MNT/app/important.db"
echo "appli demarree" > "$MNT/logs/app.log"

# Une file de sessions oubliée accumule des fichiers vides jusqu'à épuiser les inodes.
seq -f 'sess-%06g' 1 20000 | (cd "$MNT/spool/sessions" && xargs -n 500 touch 2>/dev/null) || true

echo "Lab prêt. C'est parti, 10 minutes."
