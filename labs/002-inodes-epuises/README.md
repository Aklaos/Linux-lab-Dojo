---
niveau: fondamentaux
duree: 10 min
themes: [inodes, df, find, fichiers]
---

# Lab 002 : inodes épuisés

## Scénario

Une petite application enregistre ses données dans `/opt/lab-002/data`. Depuis ce matin, elle n'arrive plus à créer de nouveaux fichiers : elle affiche « No space left on device ». Pourtant, un collègue jure qu'il reste de la place. L'équipe compte sur toi pour comprendre ce qui se passe et remettre l'application d'aplomb.

## Objectif

- On peut de nouveau créer de nouveaux fichiers dans `/opt/lab-002/data` (par exemple `touch /opt/lab-002/data/app/test`).
- Le fichier `/opt/lab-002/data/app/important.db` est **intact** : on ne le supprime pas.
- Tu peux expliquer ce qui avait causé le problème.

## Prérequis

- Podman (rootless). Aucune VM, aucun clone : tout tourne dans un conteneur jetable et isolé (aucun dossier de l'hôte, pas de réseau).

## Lancer le lab

Depuis la racine du repo :

```
./scripts/lab-run.sh 002-inodes-epuises
```

Le script construit l'environnement la première fois, puis t'ouvre un shell sur un serveur Debian. Ne lis pas `setup.sh`, `hints.md`, `debrief.md` ni `tmpfs.opts` avant la fin.

## Remise à zéro

Tape `exit` : le conteneur et son disque sont détruits. (`cleanup.sh` ne sert que si tu as lancé `setup.sh` à la main sur une VM jetable.)
