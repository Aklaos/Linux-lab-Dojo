# Débrief

À lire seulement au débrief.

## Cause

Le service `lab-007-cache` est configuré avec `CACHE_MB=900`, alors que l'environnement est limité à 512 Mo. En réservant sa mémoire par blocs, il dépasse la limite vers 450-500 Mo : le noyau déclenche l'**OOM killer** (Out Of Memory), qui tue le plus gros processus avec le signal 9. `Restart=on-failure` le relance 3 secondes plus tard, et la boucle recommence.

## Parcours de diagnostic efficace

1. Observer : `systemctl status lab-007-cache` montre un service qui redémarre en boucle, tué par un signal (`status=9/KILL`).
2. Lire le journal : `journalctl -u lab-007-cache` montre la progression « N Mo réservés » qui s'interrompt brutalement, sans erreur du programme. Un processus qui disparaît sans message est souvent tué de l'extérieur.
3. Hypothèse : la mémoire. Vérifier la limite : `cat /sys/fs/cgroup/memory.max` (environ 512 Mo) et `cat /sys/fs/cgroup/memory.events` : le compteur `oom_kill` augmente à chaque cycle.
4. Relier la cause : `cat /opt/lab-007/cache.conf` demande 900 Mo, plus que la limite.
5. Corriger : une valeur raisonnable (par exemple 200 Mo, avec de la marge pour le reste du système), puis `systemctl restart lab-007-cache`.
6. Vérifier : `systemctl status` actif, `memory.current` sous la limite, plus de nouveau `oom_kill`.

## Commandes utiles

- `systemctl status`, `journalctl -u <service>` : fin du processus et derniers messages.
- `cat /sys/fs/cgroup/memory.max`, `memory.current`, `memory.events` : limite, usage, compteurs d'OOM de l'environnement.
- `ps aux --sort=-rss | head` : processus classés par mémoire résidente.
- `dmesg`, `journalctl -k` : traces du noyau sur une machine classique (ici inaccessibles dans le conteneur).

## Variantes et pièges

- `free -m` et `/proc/meminfo` montrent la mémoire de la machine hôte dans un conteneur : se fier à la limite du cgroup.
- L'OOM killer choisit le processus au plus mauvais « score », pas forcément le coupable : il peut tuer un processus innocent.
- Augmenter la limite masque une fuite mémoire : vérifier si la consommation est normale ou croît sans cesse.
- On peut borner un service précis avec `MemoryMax=` dans son unité systemd, pour qu'il soit le seul touché.
