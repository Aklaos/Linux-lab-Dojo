# Index des labs

| N° | Thème | Niveau | Durée | Compétences travaillées |
|---|---|---|---|---|
| 001 | Disque plein | fondamentaux | 10 min | df, du, repérer un gros fichier, supprimer en sécurité |
| 002 | Inodes épuisés | fondamentaux | 10 min | df -i, inodes, find, compter les fichiers, supprimer en sécurité |
| 003 | CPU à 100 % | fondamentaux | 10 min | top, ps, relier un processus à son service, systemctl stop/disable |
| 004 | Droits et propriété de fichiers | fondamentaux | 10 min | ls -l, chown, chmod, journalctl, utilisateur d'un service |
| 005 | Tâche cron qui ne tourne pas | fondamentaux | 10 min | cron, journalctl -u cron, syntaxe de /etc/cron.d, droits d'exécution |
| 006 | Port déjà utilisé | fondamentaux | 10 min | ss -ltnp, lsof, ps, journalctl, relier un port à un processus, kill |
| 007 | Mémoire et OOM killer | fondamentaux | 10 min | systemctl status, journalctl, limite mémoire (cgroup v2), OOM killer, dimensionner un service |
| 008 | Trop de fichiers ouverts | fondamentaux | 10 min | journalctl, /proc/PID/fd et /proc/PID/limits, LimitNOFILE, surcharge systemd |
| 009 | Service qui échoue au démarrage | fondamentaux | 10 min | systemctl status, journalctl, TasksMax et pids.max (cgroup), surcharge d'unité |
