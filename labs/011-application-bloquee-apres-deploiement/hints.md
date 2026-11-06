# Indices

À donner un par un, à la demande, du plus vague au plus précis.

1. Regarde le message exact que renvoie la tentative de démarrage, et l'état du service dans `systemctl status`.
2. Le message parle d'un travail qui a échoué à cause d'autre chose : `systemctl list-dependencies lab-011-app` montre de quoi le service dépend.
3. Un des services listés est en échec. Regarde son état et son journal : `systemctl status` puis `journalctl -u <service>` : le message cite un paramètre précis.
4. Le paramètre vient d'un fichier de configuration dans `/opt/lab-011`. Corrige-le (il peut y avoir plus d'une erreur : relis le journal après chaque correction), puis relance l'application. Ne retire pas la dépendance de l'unité.
