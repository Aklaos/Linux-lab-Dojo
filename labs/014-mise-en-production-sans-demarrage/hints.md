# Indices

À donner un par un, à la demande, du plus vague au plus précis.

1. Lis le code de sortie exact du service dans `systemctl status` et le message du journal : que dit systemd de la façon dont le démarrage échoue ?
2. Ce code signifie que systemd n'a même pas pu lancer le programme : problème de chemin ou de droits. Examine le chemin complet : `ls -l`, `readlink -f`, `namei -l /opt/lab-014/current/bin/app.sh`.
3. Un composant du chemin est un lien symbolique. Où pointe-t-il, et la cible existe-t-elle ? Compare avec le contenu de `/opt/lab-014/releases`.
4. Repointe le lien vers la bonne version (`ln -sfn`), relance le service, puis relis le journal : il peut y avoir un second problème, sur le fichier lui-même.
