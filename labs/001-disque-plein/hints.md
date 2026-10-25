# Indices

À donner un par un, à la demande, du plus vague au plus précis.

1. Avant de supprimer quoi que ce soit, regarde d'abord l'état de l'espace disque.
2. Une commande résume l'espace par système de fichiers ; une autre mesure ce que pèse chaque dossier.
3. Avec `df -h`, repère le système de fichiers monté sur `/opt/lab-001/data`, puis descends dossier par dossier avec `du -sh`.
4. Cherche le plus gros fichier : `du -ah /opt/lab-001/data | sort -h | tail`. Demande-toi ensuite s'il est vraiment utile avant de le supprimer.
