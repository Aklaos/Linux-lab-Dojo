# Indices

À donner un par un, à la demande, du plus vague au plus précis.

1. Lis le journal du service : le message d'erreur exact est la meilleure piste, avec le moment où il apparaît.
2. `journalctl -u lab-008-gateway` : le message cite une limite. Combien de ressources le processus a-t-il ouvertes ? `ls /proc/<PID>/fd | wc -l` (le PID vient de `systemctl status`). Et quelle limite lui est appliquée ? `cat /proc/<PID>/limits`.
3. Cette limite ne vient pas de ton shell : elle est définie par le service lui-même. `systemctl cat lab-008-gateway` te la montre.
4. Modifie-la proprement avec un fichier de surcharge (`systemctl edit lab-008-gateway`), puis redémarre le service et relis son journal.
