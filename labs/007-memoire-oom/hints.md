# Indices

À donner un par un, à la demande, du plus vague au plus précis.

1. Regarde comment le service se termine et ce qu'il a écrit juste avant : état et journal du service.
2. `systemctl status lab-007-cache` et `journalctl -u lab-007-cache` : le journal s'arrête à un chiffre précis, puis le processus est tué (signal 9) sans que personne ne l'ait demandé.
3. Quand un processus est tué de force, pense à la mémoire. Regarde la limite de ton environnement : `cat /sys/fs/cgroup/memory.max`, `cat /sys/fs/cgroup/memory.events` (compteur `oom_kill`). Attention : `free -m` montre la mémoire de la machine hôte, pas ta limite.
4. Compare ce que le service demande (`cat /opt/lab-007/cache.conf`) avec la limite. Ajuste raisonnablement, redémarre, et surveille `memory.current` pour vérifier la marge.
