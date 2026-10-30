---
niveau: fondamentaux
duree: 10 min
themes: [cron, planification, journalctl, droits, scripts]
---

# Lab 005 : une tâche cron qui ne tourne pas

## Scénario

Une tâche de sauvegarde est planifiée avec cron. Pour les besoins du lab, elle est censée s'exécuter **toutes les minutes** et écrire une ligne dans `/opt/lab-005/backup.log`. Depuis la mise en place, rien ne se passe : aucune ligne ne s'ajoute. L'équipe compte sur toi pour comprendre pourquoi et la faire tourner.

## Objectif

- Une nouvelle ligne apparaît dans `/opt/lab-005/backup.log` **chaque minute** (laisse-lui le temps de s'exécuter).
- La tâche reste planifiée par cron toutes les minutes, sans la contourner (pas de boucle lancée à la main).
- Tu peux expliquer ce qui avait causé le problème.

## Prérequis

- Podman (rootless). Aucune VM, aucun clone : tout tourne dans un conteneur jetable et isolé (aucun dossier de l'hôte, pas de réseau).

## Lancer le lab

Depuis la racine du repo :

```
./scripts/lab-run.sh 005-cron-ne-tourne-pas
```

Le script construit l'environnement la première fois, puis t'ouvre un shell sur un serveur Debian. Ne lis pas `setup.sh`, `hints.md` ni `debrief.md` avant la fin.

## Remise à zéro

Tape `exit` : le conteneur est détruit. (`cleanup.sh` ne sert que si tu as lancé `setup.sh` à la main sur une VM jetable.)
