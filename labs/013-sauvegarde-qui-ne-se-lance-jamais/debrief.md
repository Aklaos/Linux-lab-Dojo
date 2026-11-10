# Débrief

À lire seulement au débrief.

## Cause

Deux problèmes se cumulent :

1. **La planification n'a jamais été démarrée ni activée.** Installer les fichiers `.timer` et `.service` ne suffit pas : sans `systemctl enable --now`, le timer n'existe pas pour systemd en tant que tâche en attente.
2. **Le timer vise le mauvais service.** Sa directive `Unit=` pointe vers `lab-013-sncy.service` (faute de frappe) au lieu de `lab-013-sync.service`. Au démarrage, systemd répond que ce service est introuvable.

## Parcours de diagnostic efficace

1. Observer : `sync.log` est vide. `systemctl list-timers --all` ne montre pas le timer en attente.
2. Regarder l'état : `systemctl status lab-013-sync.timer` indique « inactive (dead) » et « disabled ».
3. Essayer de le démarrer : `systemctl start lab-013-sync.timer` échoue avec « Unit lab-013-sncy.service not found ». C'est la seconde cause.
4. Corriger : `Unit=lab-013-sync.service` (ou retirer la ligne : par défaut, un timer déclenche le service du même nom), puis `systemctl daemon-reload`.
5. Activer et démarrer : `systemctl enable --now lab-013-sync.timer`. `enable` rend l'activation durable après un redémarrage, `--now` démarre tout de suite.
6. Vérifier : `systemctl list-timers` montre la prochaine échéance, et `sync.log` reçoit une ligne par minute.

## Commandes utiles

- `systemctl list-timers --all` : planifications connues, dernière et prochaine exécution.
- `systemctl status <timer>`, `systemctl cat <timer>`, `journalctl -u <timer>` : état, définition et messages.
- `systemctl list-unit-files 'motif*'` : unités installées et leur état (`enabled`, `disabled`).
- `systemd-analyze calendar "minutely"` : vérifier une expression `OnCalendar`.

## Variantes et pièges

- `enable` (démarrage au boot) et `start` (maintenant) sont deux choses distinctes ; `enable --now` fait les deux.
- Modifier un fichier d'unité demande un `systemctl daemon-reload`.
- Par défaut, un timer déclenche le service **du même nom** : `Unit=` n'est utile que pour viser un autre nom.
- Un timer peut être actif sans que le service réussisse : relire aussi `journalctl -u <service>`.
- `Persistent=true` rattrape les exécutions manquées quand la machine était éteinte.
