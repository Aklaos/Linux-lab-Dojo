# Indices

À donner un par un, à la demande, du plus vague au plus précis.

1. Avant d'agir, trouve qui consomme : il existe des outils qui classent les processus par consommation de CPU.
2. `top` (touche `q` pour quitter) ou `ps aux --sort=-%cpu | head` montrent le coupable en tête.
3. Tu as le numéro de processus (PID). Cherche à quel service il appartient : `systemctl status <PID>`.
4. Si tu le tues avec `kill`, il revient : un service géré par systemd peut être relancé automatiquement. Passe par systemd pour l'arrêter, et pense à ce qui se passerait au prochain démarrage.
