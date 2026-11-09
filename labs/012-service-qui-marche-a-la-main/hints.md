# Indices

À donner un par un, à la demande, du plus vague au plus précis.

1. Lis le message exact d'échec du service dans son journal, puis compare avec ce qui se passe quand tu lances le script toi-même.
2. Ton shell et le service ne s'exécutent pas dans le même contexte : dossier de travail, variables d'environnement. `systemctl cat lab-012-report` et `systemctl show -p WorkingDirectory,Environment lab-012-report` montrent ce que systemd fournit.
3. Compare avec ton shell : `pwd`, `env | grep REPORT`. Une variable peut venir d'un fichier de profil (`/etc/profile.d`) qui n'est lu que par les shells de connexion.
4. Adapte le service : directives `WorkingDirectory=` et `Environment=` dans l'unité (idéalement par `systemctl edit`), puis `systemctl daemon-reload` si besoin et `systemctl restart`. Relis le journal après chaque correction : il peut y avoir plus d'une cause.
