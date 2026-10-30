# Indices

À donner un par un, à la demande, du plus vague au plus précis.

1. D'abord, vérifie que cron lui-même fonctionne, et regarde ce qu'il raconte dans ses journaux.
2. `systemctl status cron` et `journalctl -u cron` : cron signale parfois qu'il n'accepte pas un fichier. Compare la syntaxe de la tâche avec le format attendu dans `/etc/cron.d` (il n'est pas identique à celui d'un `crontab -e` personnel).
3. Une fois la syntaxe corrigée, attends la minute suivante et lis `/opt/lab-005/backup.log` : les erreurs du script y sont aussi enregistrées.
4. Regarde les droits du script : `ls -l /opt/lab-005/backup.sh`, puis essaie de le lancer à la main.
