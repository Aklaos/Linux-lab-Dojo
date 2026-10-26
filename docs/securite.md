# Sécurité des labs

Les scripts sont publics et lancés en `root` dans un conteneur jetable : ils doivent être sûrs.

## Isolation (`scripts/lab-run.sh`)

- Podman **rootless** : le root du conteneur n'est qu'un utilisateur sans droits sur l'hôte.
- **Aucun volume de l'hôte** (le script du lab est injecté avec `podman cp` puis effacé), **aucun réseau**.
- Droits réduits (`--cap-drop`, `no-new-privileges`), mémoire, CPU et processus bornés.
- Conteneur détruit à la sortie, quoi qu'il arrive.

## Règles des scripts de lab

- **Conteneur jetable (ou VM jetable) uniquement.** Jamais sur une machine qui compte.
- Hors conteneur, `setup.sh` demande une **confirmation explicite** avant de rien casser.
- Il ne touche **que** ce qui est propre au lab : dossier `/opt/lab-NNN`, unité systemd `lab-NNN-*`, utilisateur `lab-NNN`, fichier dans `/tmp`. Jamais de suppression ni de modification hors de ce périmètre.
- Il ne coupe **jamais** l'accès SSH, ne supprime aucune donnée personnelle, ne contacte aucun service externe et ne télécharge rien.
- Il est **idempotent** : le relancer ne casse pas plus.
- `cleanup.sh` **annule tout**, y compris après un échec.
- Bash strict (`set -euo pipefail`), commentaires courts, outils présents sur une Debian ou Ubuntu standard.
- Le repo est public : aucun secret, aucune donnée personnelle (nom d'utilisateur, nom de machine, IP, chemin personnel, jeton).
- En cas de doute sur un risque, simplifier le scénario.
