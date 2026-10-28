# Débrief

À lire seulement au débrief.

## Cause

Le service tourne sous l'utilisateur dédié `lab004`, mais, après une « maintenance », fichiers et dossiers appartiennent à `root` :

1. `app.conf` est en `600` et appartient à `root` : `lab004` ne peut pas le lire (« Permission denied »).
2. Le dossier `data` appartient à `root` en `755` : `lab004` peut le traverser, mais pas y créer `app.log`.

Le service échoue donc, systemd le relance en boucle (`Restart=on-failure`). Le deuxième problème n'apparaît qu'une fois le premier corrigé.

## Parcours de diagnostic efficace

1. Observer : `systemctl status lab-004-app` (état `activating (auto-restart)`), puis `journalctl -u lab-004-app` pour l'erreur exacte.
2. Hypothèse : un problème de droits. Qui exécute le service ? `systemctl cat lab-004-app` donne `User=lab004`.
3. Vérifier : `ls -l` / `ls -ld` sur la config et sur le dossier, `id lab004`, ou `runuser -u lab004 -- cat /opt/lab-004/app.conf` pour reproduire l'échec.
4. Corriger au plus juste : par exemple `chown root:lab004 app.conf` et `chmod 640 app.conf` (lecture pour le groupe du service), `chown lab004: data`. Jamais `chmod 777`.
5. Vérifier : `systemctl restart lab-004-app`, relire le journal (le second problème apparaît au passage), puis `tail data/app.log`.

## Commandes utiles

- `ls -l`, `ls -ld` : propriétaire, groupe et droits d'un fichier ou d'un dossier.
- `namei -l <chemin>` : droits de chaque dossier du chemin, utile quand un dossier parent bloque.
- `id <utilisateur>` : identifiant et groupes.
- `runuser -u <utilisateur> -- <commande>` : exécuter une commande à sa place, même sans shell.
- `chown`, `chmod`, `journalctl -u <service>`.

## Variantes et pièges

- Un dossier a besoin du droit `x` pour être traversé, et `w` pour y créer des fichiers.
- `chmod 777` « règle » le problème mais ouvre tout à tout le monde : mauvaise pratique.
- Plusieurs causes peuvent se cacher l'une derrière l'autre : relire les erreurs après chaque correction.
- Une restauration faite en `root` (copie, archive) change souvent le propriétaire des fichiers.
