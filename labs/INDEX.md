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
| 010 | Service lent sur un serveur calme | fondamentaux | 10 min | systemctl cat, CPUQuota, cpu.max et cpu.stat (cgroup), throttling CPU |
| 011 | Application bloquée après un déploiement | fondamentaux | 10 min | systemctl list-dependencies, Requires/After, journalctl par service, valider une configuration |
| 012 | Service qui marche à la main | fondamentaux | 10 min | contexte d'un service systemd (WorkingDirectory, Environment), comparer shell et service, journalctl |
| 013 | Sauvegarde qui ne se lance jamais | fondamentaux | 10 min | timers systemd, list-timers, enable vs start, Unit=, comparaison avec cron |
| 014 | Mise en production sans démarrage | fondamentaux | 10 min | liens symboliques cassés, code 203/EXEC, namei, readlink, droits d'exécution |
