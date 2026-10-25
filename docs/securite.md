# Sécurité des labs

Les scripts sont publics et lancés en `root` sur une VM : ils doivent être sûrs.

- **VM jetable uniquement.** Jamais sur une machine qui compte.
- `setup.sh` demande une **confirmation explicite** avant de rien casser.
- Il ne touche **que** ce qui est propre au lab : dossier `/opt/lab-NNN`, unité systemd `lab-NNN-*`, utilisateur `lab-NNN`, fichier dans `/tmp`. Jamais de suppression ni de modification hors de ce périmètre.
- Il ne coupe **jamais** l'accès SSH, ne supprime aucune donnée personnelle, ne contacte aucun service externe et ne télécharge rien.
- Il est **idempotent** : le relancer ne casse pas plus.
- `cleanup.sh` **annule tout**, y compris après un échec.
- Bash strict (`set -euo pipefail`), commentaires courts, outils présents sur une Debian ou Ubuntu standard.
- Le repo est public : aucun secret, aucune donnée personnelle (nom d'utilisateur, nom de machine, IP, chemin personnel, jeton).
- En cas de doute sur un risque, simplifier le scénario.
