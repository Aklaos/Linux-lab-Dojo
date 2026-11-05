# Indices

À donner un par un, à la demande, du plus vague au plus précis.

1. Compare le débit annoncé dans le journal avec ce qui est attendu, puis regarde le processus pendant qu'il travaille : que fait-il de la machine ?
2. `top` montre un processus qui consomme peu de CPU alors que la machine est libre. Quelque chose l'empêche d'utiliser le CPU disponible : cherche du côté du cgroup du service.
3. `cat /sys/fs/cgroup/system.slice/lab-010-batch.service/cpu.max` et `cpu.stat` (compteurs `nr_throttled` et `throttled_usec`). `systemctl show -p CPUQuotaPerSecUSec lab-010-batch` donne la valeur configurée.
4. Le plafond est défini par l'unité elle-même (`systemctl cat`). Modifie-le avec une surcharge (`systemctl edit lab-010-batch`), puis redémarre et relis le débit dans le journal.
