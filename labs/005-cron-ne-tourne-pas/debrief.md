# Débrief

À lire seulement au débrief.

## Cause

Deux problèmes, l'un derrière l'autre :

1. **Syntaxe.** La tâche est dans `/etc/cron.d/lab-005-backup`. Ce format (comme `/etc/crontab`) exige un **champ utilisateur** entre l'horaire et la commande. Il manque, donc cron rejette le fichier et note l'erreur dans son journal.
2. **Droits.** Une fois la syntaxe corrigée, la tâche s'exécute mais le script `backup.sh` n'a pas le droit d'exécution : `backup.log` se remplit d'erreurs « Permission denied ».

## Parcours de diagnostic efficace

1. Observer : aucune ligne dans `backup.log`. Est-ce que cron tourne ? `systemctl status cron`.
2. Lire le journal de cron : `journalctl -u cron` indique l'erreur sur le fichier de la tâche.
3. Hypothèse : syntaxe. Comparer avec le format de `/etc/cron.d` : `m h dom mon dow utilisateur commande`. Ajouter `root`.
4. Vérifier : attendre la minute, lire `backup.log`. Il contient maintenant l'erreur du script.
5. Hypothèse : droits. `ls -l backup.sh` montre l'absence de `x`. Corriger avec `chmod +x`, ou tester `/opt/lab-005/backup.sh` à la main pour le constater.
6. Vérifier : une nouvelle ligne « sauvegarde ok » apparaît chaque minute.

## Commandes utiles

- `systemctl status cron`, `journalctl -u cron` : état et messages de cron.
- `crontab -l` : tâches de l'utilisateur courant. `/etc/crontab` et `/etc/cron.d/*` : tâches système (avec champ utilisateur).
- `ls -l` et `chmod +x` : droits d'exécution.
- Exécuter la commande à la main, dans les mêmes conditions, pour reproduire l'erreur.

## Variantes et pièges

- Dans `/etc/cron.d`, sur Debian, les fichiers dont le nom contient un point sont ignorés.
- cron utilise un environnement minimal (PATH réduit) : utiliser des chemins absolus.
- Rediriger la sortie (`>> fichier 2>&1`) est la façon la plus simple de voir les erreurs d'une tâche.
- Un fichier de tâche doit appartenir à `root` et ne pas être modifiable par d'autres.
