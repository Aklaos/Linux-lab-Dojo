---
niveau: fondamentaux
duree: 10 min
themes: [mémoire, oom-killer, cgroups, systemd, journalctl]
---

# Lab 007 : mémoire et OOM killer

## Scénario

Le service `lab-007-cache` est un cache en mémoire. Depuis un changement de configuration hier, il démarre, puis disparaît, puis redémarre, en boucle, et le cache n'est jamais disponible. L'équipe compte sur toi pour comprendre pourquoi et le stabiliser.

## Objectif

- `lab-007-cache` est actif et **stable** : il ne redémarre plus (laisse-lui une bonne minute pour le vérifier).
- Le cache garde une taille utile : au moins **100 Mo** (pas question de le réduire à presque rien).
- Tu peux expliquer ce qui avait causé le problème.

## Prérequis

- Podman (rootless). Aucune VM, aucun clone : tout tourne dans un conteneur jetable et isolé (aucun dossier de l'hôte, pas de réseau). Le conteneur est limité à 512 Mo de mémoire.

## Lancer le lab

Depuis la racine du repo :

```
./scripts/lab-run.sh 007-memoire-oom
```

Le script construit l'environnement la première fois, puis t'ouvre un shell sur un serveur Debian. Ne lis pas `setup.sh`, `hints.md` ni `debrief.md` avant la fin.

## Remise à zéro

Tape `exit` : le conteneur est détruit. (`cleanup.sh` ne sert que si tu as lancé `setup.sh` à la main sur une VM jetable.)
