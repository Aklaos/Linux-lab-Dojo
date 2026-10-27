---
niveau: fondamentaux
duree: 10 min
themes: [cpu, processus, top, ps, systemd]
---

# Lab 003 : CPU à 100 %

## Scénario

Le serveur est devenu très lent depuis ce matin : les connexions sont poussives et les commandes mettent du temps à répondre. L'équipe compte sur toi pour trouver ce qui consomme la machine et la remettre d'aplomb, sans casser le reste.

## Objectif

- Le serveur n'est plus saturé : plus aucun processus ne consomme durablement le CPU.
- Le service `lab-003-api` tourne toujours.
- La correction tient dans le temps : le problème ne revient pas tout seul quelques secondes plus tard.
- Tu peux expliquer ce qui avait causé le problème.

## Prérequis

- Podman (rootless). Aucune VM, aucun clone : tout tourne dans un conteneur jetable et isolé (aucun dossier de l'hôte, pas de réseau).

## Lancer le lab

Depuis la racine du repo :

```
./scripts/lab-run.sh 003-cpu-100
```

Le script construit l'environnement la première fois, puis t'ouvre un shell sur un serveur Debian. Ne lis pas `setup.sh`, `hints.md` ni `debrief.md` avant la fin.

## Remise à zéro

Tape `exit` : le conteneur est détruit. (`cleanup.sh` ne sert que si tu as lancé `setup.sh` à la main sur une VM jetable.)
