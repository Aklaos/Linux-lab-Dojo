---
niveau: fondamentaux
duree: 10 min
themes: [systemd, dépendances, Requires, After, list-dependencies, journalctl]
---

# Lab 011 : l'application bloquée après un déploiement

## Scénario

Depuis le dernier déploiement, le service `lab-011-app` ne démarre plus : chaque tentative de démarrage est refusée immédiatement. L'équipe compte sur toi pour comprendre pourquoi et remettre l'application en marche.

## Objectif

- `lab-011-app` est actif et son journal montre qu'il traite des requêtes.
- La correction ne retire aucune protection : on ne supprime pas ce qui relie l'application aux autres services, on règle le vrai problème.
- Tu peux expliquer ce qui avait causé le problème.

## Prérequis

- Podman (rootless). Aucune VM, aucun clone : tout tourne dans un conteneur jetable et isolé (aucun dossier de l'hôte, pas de réseau).

## Lancer le lab

Depuis la racine du repo :

```
./scripts/start-lab.sh 011-application-bloquee-apres-deploiement
```

Le script ouvre le ticket et la PR du lab, construit l'environnement la première fois, puis t'ouvre un shell sur un serveur Debian. Ne lis pas `setup.sh`, `hints.md` ni `debrief.md` avant la fin.

## Remise à zéro

Quitte le shell : le conteneur est détruit. (`cleanup.sh` ne sert que si tu as lancé `setup.sh` à la main sur une VM jetable.)
