---
niveau: fondamentaux
duree: 10 min
themes: [cgroups, cpu.max, CPUQuota, throttling, systemd]
---

# Lab 010 : le service lent sur un serveur calme

## Scénario

Le service `lab-010-batch` traite des éléments en continu et écrit son débit dans son journal. Il devrait traiter environ **20 éléments par seconde**. Depuis son déploiement, il en traite beaucoup moins, alors que le serveur est pourtant quasiment au repos. L'équipe compte sur toi pour comprendre pourquoi et lui rendre sa vitesse normale.

## Objectif

- Le journal du service affiche de nouveau un débit proche de **20 éléments/s** (au moins 15).
- La correction est **durable** : elle reste valable si le service est redémarré.
- Tu peux expliquer ce qui avait causé le problème.

## Prérequis

- Podman (rootless). Aucune VM, aucun clone : tout tourne dans un conteneur jetable et isolé (aucun dossier de l'hôte, pas de réseau).

## Lancer le lab

Depuis la racine du repo :

```
./scripts/start-lab.sh 010-service-lent-serveur-calme
```

Le script ouvre le ticket et la PR du lab, construit l'environnement la première fois, puis t'ouvre un shell sur un serveur Debian. Ne lis pas `setup.sh`, `hints.md` ni `debrief.md` avant la fin.

## Remise à zéro

Quitte le shell : le conteneur est détruit. (`cleanup.sh` ne sert que si tu as lancé `setup.sh` à la main sur une VM jetable.)
