---
niveau: fondamentaux
duree: 10 min
themes: [disque, df, du, logs]
---

# Lab 001 : disque plein

## Scénario

Une petite application enregistre ses données dans `/opt/lab-001/data`. Depuis ce matin, elle échoue avec des erreurs d'écriture et ne peut plus rien enregistrer. L'équipe compte sur toi pour comprendre ce qui se passe et remettre l'application d'aplomb.

## Objectif

- Au moins **20 Mo** sont de nouveau libres dans `/opt/lab-001/data`.
- Le fichier `/opt/lab-001/data/app/important.db` est **intact** : on ne le supprime pas.
- Tu peux expliquer ce qui avait causé le problème.

## Prérequis

- Podman (rootless). Aucune VM, aucun clone : tout tourne dans un conteneur jetable et isolé (pas de volume de l'hôte, pas de réseau).

## Lancer le lab

Depuis la racine du repo :

```
./scripts/lab-run.sh 001-disque-plein
```

Le script construit l'environnement la première fois, demande une confirmation, puis t'ouvre un shell sur un serveur Debian. Ne lis pas `setup.sh`, `hints.md` ni `debrief.md` avant la fin.

## Remise à zéro

Tape `exit` : le conteneur est détruit. (`cleanup.sh` ne sert que si tu as lancé `setup.sh` à la main sur une VM jetable.)
