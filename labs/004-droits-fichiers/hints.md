# Indices

À donner un par un, à la demande, du plus vague au plus précis.

1. Avant de toucher à quoi que ce soit, regarde ce que dit le service lui-même : son état et ses messages d'erreur.
2. `systemctl status lab-004-app` et `journalctl -u lab-004-app` donnent les erreurs. Cherche qui exécute le service (`systemctl cat lab-004-app`).
3. Compare l'utilisateur du service avec le propriétaire et les droits des fichiers qu'il utilise : `ls -l`, `ls -ld`, `id lab004`. Pour tester à sa place : `runuser -u lab004 -- cat <fichier>`.
4. Corrige au plus juste avec `chown` et `chmod` (surtout pas `chmod 777`). Il peut y avoir plus d'un problème : relis les erreurs après chaque correction.
