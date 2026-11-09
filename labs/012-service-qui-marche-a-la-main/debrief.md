# Débrief

À lire seulement au débrief.

## Cause

Le script dépend de son **contexte d'exécution**, qui n'est pas le même dans un shell et sous systemd :

1. Il lit `./report.conf`, un chemin **relatif**. Dans un shell, on s'est placé dans `/opt/lab-012`. Un service systemd démarre par défaut dans `/` : le fichier est introuvable.
2. Il exige la variable `REPORT_DIR`. Elle est définie dans `/etc/profile.d/lab-012.sh`, lu seulement par les **shells de connexion**. Un service n'en hérite pas : la variable est absente.

Le premier échec masque le second : il apparaît une fois le premier corrigé.

## Parcours de diagnostic efficace

1. Observer : `systemctl status lab-012-report` (échec en boucle) et `journalctl -u lab-012-report` : « impossible de lire ./report.conf ».
2. Hypothèse : le contexte diffère. `systemctl show -p WorkingDirectory lab-012-report` est vide (donc `/`), alors que le script, à la main, est lancé depuis `/opt/lab-012`.
3. Corriger : `WorkingDirectory=/opt/lab-012` dans l'unité, puis `systemctl daemon-reload` et `systemctl restart`.
4. Relire le journal : « variable REPORT_DIR absente ». Comparer avec le shell (`env | grep REPORT`) et chercher d'où elle vient (`grep -r REPORT_DIR /etc/profile.d`).
5. Corriger : `Environment=REPORT_DIR=/opt/lab-012/reports` dans l'unité (ou `EnvironmentFile=`), puis `daemon-reload` et `restart`.
6. Vérifier : le journal affiche « rapport genere », et `systemctl status` est actif.

## Commandes utiles

- `systemctl show -p WorkingDirectory,Environment,User <service>` : le contexte fourni par systemd.
- `systemctl cat`, `systemctl edit` : lire et surcharger l'unité.
- `env`, `pwd` dans ton shell : pour comparer avec le service.
- `systemd-run --pty --wait <commande>` : lancer une commande dans un contexte proche de celui d'un service, pour reproduire l'échec.

## Variantes et pièges

- Même piège avec cron : environnement minimal, dossier de travail différent, `PATH` réduit.
- Un service tourne aussi sous un autre utilisateur si `User=` est défini : droits et variables changent.
- Préférer des chemins **absolus** dans les scripts.
- `/etc/profile`, `~/.bashrc` ne concernent pas les services systemd : utiliser `Environment=` ou `EnvironmentFile=`.
- Modifier une unité demande un `systemctl daemon-reload`.
