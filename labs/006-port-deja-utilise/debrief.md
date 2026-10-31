# Débrief

À lire seulement au débrief.

## Cause

Un vieux processus oublié (`report-viewer`), lancé hors de systemd, écoute déjà sur le port 8080. Quand `lab-006-api` démarre, il ne peut pas réserver ce port : « bind 8080 impossible : Address already in use ». Le service s'arrête en échec.

## Parcours de diagnostic efficace

1. `systemctl status lab-006-api` : état `failed`, code de sortie non nul.
2. `journalctl -u lab-006-api` : le message « Address already in use » désigne le port 8080.
3. `ss -ltnp` (ou `lsof -i :8080`) : montre quel processus écoute sur 8080, avec son PID.
4. `ps -p <PID> -o pid,user,lstart,cmd` : qui est-il, depuis quand tourne-t-il, est-il lié à un service ? Ici, non.
5. Vérifier qu'il est inutile **avant** de le tuer, puis `kill <PID>` (SIGTERM d'abord, `kill -9` en dernier recours).
6. `systemctl start lab-006-api`, puis `ss -ltnp` et `systemctl status` pour vérifier.

## Commandes utiles

- `ss -ltnp` : sockets TCP en écoute (`-l` écoute, `-t` TCP, `-n` numérique, `-p` processus).
- `lsof -i :8080`, `fuser 8080/tcp` : qui utilise ce port.
- `journalctl -u <service>` : ce que le service a écrit.

## Variantes et pièges

- Le processus peut appartenir à un autre service systemd : tuer le processus ne suffit pas, il redémarre. Il faut arrêter l'unité (`systemctl stop`).
- Sans `-p` ou sans root, `ss` n'affiche pas le processus.
- Changer le port du service est une autre solution, mais il faut alors prévenir ceux qui l'appellent.
- Un port dans l'état TIME_WAIT n'empêche pas un service de redémarrer s'il utilise `SO_REUSEADDR`.
