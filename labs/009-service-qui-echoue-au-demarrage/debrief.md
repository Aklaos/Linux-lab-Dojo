# Débrief

À lire seulement au débrief.

## Cause

L'unité du service fixe `TasksMax=5` : systemd traduit cette directive en une limite `pids.max` sur le cgroup du service. Le gestionnaire (1 processus) lance 8 workers : seuls 4 peuvent naître, les suivants échouent avec « Resource temporarily unavailable » (EAGAIN lors du `fork`). Le gestionnaire constate un démarrage incomplet, sort en erreur, et `Restart=on-failure` relance le service 5 secondes plus tard : la boucle recommence.

## Parcours de diagnostic efficace

1. Observer : `systemctl status lab-009-workers` montre un service qui échoue et se relance. La ligne `Tasks: N (limit: 5)` est un indice direct.
2. Lire le journal : `journalctl -u lab-009-workers` cite « demarrage impossible : Resource temporarily unavailable » pour les workers 5 à 8.
3. Hypothèse : une limite sur le nombre de processus. Vérifier : `cat /sys/fs/cgroup/system.slice/lab-009-workers.service/pids.max` (5), `pids.current` et `pids.events` (compteur `max` qui augmente à chaque refus).
4. Relier à la configuration : `systemctl show -p TasksMax` ou `systemctl cat` montrent `TasksMax=5`.
5. Corriger durablement : `systemctl edit lab-009-workers` avec `[Service]` puis `TasksMax=20` (ou `infinity`), puis `systemctl restart`.
6. Vérifier : journal « 8 workers actifs, tout est ok », `Tasks: 9` dans `systemctl status`, plus de nouvelle ligne `max` dans `pids.events`.

## Commandes utiles

- `systemctl status`, `journalctl -u <service>` : état, ligne `Tasks:` et messages.
- `systemctl show -p TasksMax <service>` : limite configurée.
- `cat /sys/fs/cgroup/system.slice/<unité>/pids.max`, `pids.current`, `pids.events` : limite, nombre actuel de tâches, refus.
- `systemctl cat`, `systemctl edit` : lire et surcharger une unité proprement.

## Variantes et pièges

- Les **threads** comptent comme des tâches, pas seulement les processus : un programme multithread atteint la limite plus vite qu'on ne le croit.
- La limite par défaut de systemd (`DefaultTasksMax`) est un pourcentage du maximum du noyau ; la ligne `Tasks: N (limit: M)` la montre.
- Cette limite protège contre les « fork bombs » : l'augmenter sans réfléchir réduit cette protection.
- Dans un shell, la même cause donne « fork: retry: Resource temporarily unavailable ».
- Ne pas confondre avec `ulimit -u` (limite par utilisateur) : ici, c'est le cgroup du service qui limite.
