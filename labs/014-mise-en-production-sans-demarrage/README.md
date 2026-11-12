---
niveau: fondamentaux
duree: 10 min
themes: [liens symboliques, déploiement, 203/EXEC, droits d'exécution, namei, systemd]
---

# Lab 014 : la mise en production qui ne démarre pas

## Scénario

Hier soir, une nouvelle version de l'application a été mise en production dans `/opt/lab-014`. Depuis, le service `lab-014-app` ne démarre plus. L'ancienne version, elle, fonctionnait sans problème. L'équipe compte sur toi pour comprendre ce qui s'est passé et remettre le service en marche avec la **nouvelle** version.

## Objectif

- `lab-014-app` est actif et son journal affiche **« version 2026-11-12 »** (la nouvelle version, pas un retour en arrière).
- La correction est **durable** : elle reste valable après un redémarrage du service.
- Tu peux expliquer ce qui avait causé le problème.

## Prérequis

- Podman (rootless). Aucune VM, aucun clone : tout tourne dans un conteneur jetable et isolé (aucun dossier de l'hôte, pas de réseau).

## Lancer le lab

Depuis la racine du repo :

```
./scripts/start-lab.sh 014-mise-en-production-sans-demarrage
```

Le script ouvre le ticket et la PR du lab, construit l'environnement la première fois, puis t'ouvre un shell sur un serveur Debian. Ne lis pas `setup.sh`, `hints.md` ni `debrief.md` avant la fin.

## Remise à zéro

Quitte le shell : le conteneur est détruit. (`cleanup.sh` ne sert que si tu as lancé `setup.sh` à la main sur une VM jetable.)
