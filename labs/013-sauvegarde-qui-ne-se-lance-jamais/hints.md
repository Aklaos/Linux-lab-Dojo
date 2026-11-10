# Indices

À donner un par un, à la demande, du plus vague au plus précis.

1. Demande à systemd ce qu'il a de planifié : y a-t-il quelque chose qui attend de se déclencher ?
2. `systemctl list-timers --all` liste les planifications. Si la tienne n'y est pas active, regarde son état avec `systemctl status lab-013-sync.timer`, et essaie de la démarrer : lis le message exact.
3. Une planification déclenche un service par son nom. Compare le nom visé avec les unités qui existent vraiment : `systemctl cat lab-013-sync.timer` et `systemctl list-unit-files 'lab-013*'`.
4. Corrige le nom dans le fichier de la planification, `systemctl daemon-reload`, puis active-la et démarre-la en une commande (`systemctl enable --now`). Attends la minute suivante et relis le fichier de log.
