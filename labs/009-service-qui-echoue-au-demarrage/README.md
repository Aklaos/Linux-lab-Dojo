---
niveau: fondamentaux
duree: 10 min
themes: [systemd, TasksMax, pids.max, cgroups, journalctl]
---

# Lab 009 : le service qui échoue au démarrage

## Scénario

Le service `lab-009-workers` lance une petite équipe de 8 processus de travail. Depuis son déploiement, il démarre, échoue, puis recommence en boucle : jamais les 8 processus ne tournent en même temps. L'équipe compte sur toi pour comprendre pourquoi et le faire démarrer correctement.

## Objectif

- `lab-009-workers` est actif et **stable**, avec ses **8 processus de travail** en fonctionnement (le journal l'indique).
- La correction est **durable** : elle reste valable si le service est redémarré.
- Tu peux expliquer ce qui avait causé le problème.

## Prérequis

- Podman (rootless). Aucune VM, aucun clone : tout tourne dans un conteneur jetable et isolé (aucun dossier de l'hôte, pas de réseau).

## Lancer le lab

Depuis la racine du repo :

```
./scripts/start-lab.sh 009-service-qui-echoue-au-demarrage
```

Le script ouvre le ticket et la PR du lab, construit l'environnement la première fois, puis t'ouvre un shell sur un serveur Debian. Ne lis pas `setup.sh`, `hints.md` ni `debrief.md` avant la fin.

## Remise à zéro

Quitte le shell : le conteneur est détruit. (`cleanup.sh` ne sert que si tu as lancé `setup.sh` à la main sur une VM jetable.)
