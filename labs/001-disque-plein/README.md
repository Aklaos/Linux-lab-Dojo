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

- Une VM Linux jetable (Debian ou Ubuntu), accès SSH, `sudo`.
- Les outils `mkfs.ext4`, `mount` et `fallocate` (présents par défaut).

## Lancer le lab

```
sudo ./labs/001-disque-plein/setup.sh
```

Le script demande une confirmation avant de dégrader la machine. Il ne crée qu'une petite image disque de 64 Mo dans `/opt/lab-001`. Ne lis pas `setup.sh`, `hints.md` ni `debrief.md` avant la fin.

## Remise à zéro

```
sudo ./labs/001-disque-plein/cleanup.sh
```
