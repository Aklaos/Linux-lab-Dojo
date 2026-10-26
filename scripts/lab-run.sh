#!/usr/bin/env bash
# Lance un lab dans un conteneur Podman rootless, isolé et jetable.
# Usage : ./scripts/lab-run.sh 001-disque-plein
set -euo pipefail
cd "$(dirname "$0")/.."

LAB="${1:?Usage : $0 NNN-theme}"
NUM="${LAB%%-*}"
NAME="lab-${NUM}"
IMAGE="localhost/linux-dojo/debian-server"
SETUP="labs/${LAB}/setup.sh"
# Options du disque du lab (fichier facultatif du lab), sinon 64 Mo.
OPTS="$(cat "labs/${LAB}/tmpfs.opts" 2>/dev/null || echo "size=64m")"

command -v podman >/dev/null || { echo "Il faut Podman."; exit 1; }
[ -f "$SETUP" ] || { echo "Lab introuvable : $LAB"; exit 1; }

# Image construite une seule fois (le réseau n'est utilisé que ici).
podman image exists "$IMAGE" || podman build -q -t "$IMAGE" containers/debian-server

# Tout est détruit à la sortie, quoi qu'il arrive.
trap 'podman rm -f -t 0 "$NAME" >/dev/null 2>&1 || true' EXIT
podman rm -f -t 0 "$NAME" >/dev/null 2>&1 || true

# Aucun volume de l'hôte, aucun réseau, peu de droits, ressources bornées.
podman run -d --name "$NAME" --hostname srv-prod-01 \
  --systemd=always --network=none \
  --cap-drop=MKNOD --cap-drop=NET_RAW --cap-drop=SETFCAP --cap-drop=AUDIT_WRITE \
  --security-opt no-new-privileges \
  --pids-limit 256 --memory 512m --memory-swap 512m --cpus 1 \
  --tmpfs "/opt/lab-${NUM}/data:rw,${OPTS},mode=755,nosuid,nodev,noexec" \
  "$IMAGE" >/dev/null

# Attendre le démarrage de systemd (l'état « degraded » est sans importance).
timeout 60 podman exec "$NAME" systemctl is-system-running --wait >/dev/null 2>&1 || true

# Injection du script sans volume, puis suppression pour qu'il ne traîne pas.
podman cp "$SETUP" "$NAME:/root/.setup.sh"
podman exec -it "$NAME" bash /root/.setup.sh
podman exec "$NAME" rm -f /root/.setup.sh

echo "--- Tu es sur srv-prod-01. Tape exit pour tout détruire. ---"
podman exec -it -w /root "$NAME" bash -l || true
