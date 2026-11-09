---
niveau: fondamentaux
duree: 10 min
themes: [systemd, WorkingDirectory, Environment, environnement d'exécution, journalctl]
---

# Lab 012 : le service qui marche à la main

## Scénario

Le service `lab-012-report` génère des rapports. Quand on lance son script à la main depuis un terminal, tout se passe bien. Mais quand c'est systemd qui le démarre, le service échoue. L'équipe compte sur toi pour comprendre pourquoi et le faire fonctionner en service.

## Objectif

- `lab-012-report` est actif en tant que **service** et son journal indique que les rapports sont générés.
- Tu ne modifies pas le script `/opt/lab-012/report.sh` : la correction se fait côté service.
- La correction est **durable** : elle reste valable après un redémarrage du service.
- Tu peux expliquer ce qui avait causé le problème.

## Prérequis

- Podman (rootless). Aucune VM, aucun clone : tout tourne dans un conteneur jetable et isolé (aucun dossier de l'hôte, pas de réseau).

## Lancer le lab

Depuis la racine du repo :

```
./scripts/start-lab.sh 012-service-qui-marche-a-la-main
```

Le script ouvre le ticket et la PR du lab, construit l'environnement la première fois, puis t'ouvre un shell sur un serveur Debian. Ne lis pas `setup.sh`, `hints.md` ni `debrief.md` avant la fin.

## Remise à zéro

Quitte le shell : le conteneur est détruit. (`cleanup.sh` ne sert que si tu as lancé `setup.sh` à la main sur une VM jetable.)
