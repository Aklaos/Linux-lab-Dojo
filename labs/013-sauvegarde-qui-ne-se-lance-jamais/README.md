---
niveau: fondamentaux
duree: 10 min
themes: [systemd, timers, OnCalendar, enable et start, list-timers, cron]
---

# Lab 013 : la sauvegarde qui ne se lance jamais

## Scénario

Une synchronisation doit s'exécuter automatiquement **toutes les minutes** et ajouter une ligne dans `/opt/lab-013/sync.log`. Elle a été installée hier, mais le fichier reste vide : rien ne s'est jamais exécuté. L'équipe compte sur toi pour comprendre pourquoi et la faire tourner.

## Objectif

- Une nouvelle ligne apparaît dans `/opt/lab-013/sync.log` **chaque minute**, lancée par la planification (pas par une commande à la main).
- La correction est **durable** : la planification est aussi active après un redémarrage de la machine.
- Tu peux expliquer ce qui avait causé le problème.

## Prérequis

- Podman (rootless). Aucune VM, aucun clone : tout tourne dans un conteneur jetable et isolé (aucun dossier de l'hôte, pas de réseau).

## Lancer le lab

Depuis la racine du repo :

```
./scripts/start-lab.sh 013-sauvegarde-qui-ne-se-lance-jamais
```

Le script ouvre le ticket et la PR du lab, construit l'environnement la première fois, puis t'ouvre un shell sur un serveur Debian. Ne lis pas `setup.sh`, `hints.md` ni `debrief.md` avant la fin.

## Remise à zéro

Quitte le shell : le conteneur est détruit. (`cleanup.sh` ne sert que si tu as lancé `setup.sh` à la main sur une VM jetable.)
