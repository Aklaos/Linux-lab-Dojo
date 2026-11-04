# Indices

À donner un par un, à la demande, du plus vague au plus précis.

1. Lis l'état du service et son journal : à quel moment exact le démarrage échoue-t-il, et avec quel message ?
2. Le message parle d'une ressource « temporairement indisponible » pour certains processus de travail seulement. Regarde la ligne `Tasks:` de `systemctl status lab-009-workers`.
3. Cette ligne compare un nombre et une limite. La limite se lit aussi dans le système de fichiers des cgroups : `cat /sys/fs/cgroup/system.slice/lab-009-workers.service/pids.max`, et `pids.events` compte les refus. `systemctl show -p TasksMax lab-009-workers` donne la valeur configurée.
4. La limite est définie par l'unité elle-même (`systemctl cat`). Relève-la avec une surcharge (`systemctl edit lab-009-workers`), puis redémarre le service et relis son journal.
