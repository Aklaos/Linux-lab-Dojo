# Débrief

À lire seulement au débrief.

## Cause

L'unité `lab-011-app` déclare `Requires=lab-011-db.service` et `After=lab-011-db.service` : l'application ne peut démarrer que si la base a démarré avec succès. L'initialisation de la base (`db-init.sh`) lit `/opt/lab-011/db.conf`, qui contient deux erreurs : `port=5432a` (pas un nombre) puis `datadir=/opt/lab-011/donnees` (dossier inexistant). L'initialisation échoue, la base est en échec, et systemd refuse de démarrer l'application (« dependency failed »).

## Parcours de diagnostic efficace

1. Observer : `systemctl start lab-011-app` répond qu'une dépendance a échoué ; `systemctl status lab-011-app` montre le service inactif.
2. Remonter la chaîne : `systemctl list-dependencies lab-011-app` fait apparaître `lab-011-db.service`, marqué en échec.
3. Lire le bon journal : `journalctl -u lab-011-db` donne « configuration invalide : port='5432a' ».
4. Corriger le fichier `/opt/lab-011/db.conf` (`port=5432`), puis relancer la base : `systemctl start lab-011-db`. Une seconde erreur apparaît (dossier introuvable) : relire le journal, corriger `datadir` vers le dossier qui existe (`/opt/lab-011/data`).
5. Relancer : `systemctl start lab-011-app` (la base est alors démarrée avec succès).
6. Vérifier : `systemctl status lab-011-app` actif, et son journal affiche « requete traitee ».

## Commandes utiles

- `systemctl list-dependencies <unité>` (et `--reverse`) : ce dont une unité dépend, et ce qui dépend d'elle.
- `systemctl status`, `journalctl -u <service>` : état et messages de **chaque** service de la chaîne.
- `systemctl reset-failed <service>` : efface l'état « failed ».
- `systemd-analyze verify <unité>` : détecte des erreurs dans une unité.

## Variantes et pièges

- Lire l'erreur de l'application ne sert à rien : la cause est dans le service dont elle dépend.
- `Requires=` rend le démarrage dépendant du succès de l'autre unité ; `Wants=` est plus souple (démarre quand même). `After=` ne règle que l'**ordre**, pas l'exigence.
- Plusieurs erreurs peuvent se succéder : relire le journal après chaque correction.
- Retirer `Requires=` « débloquerait » l'application mais la ferait tourner sans base : mauvais remède.
- Modifier un fichier de configuration ne demande pas de `daemon-reload` ; modifier une unité, si.
