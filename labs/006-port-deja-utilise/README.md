---
niveau: fondamentaux
duree: 10 min
themes: [réseau, ports, ss, systemd, processus]
---

# Lab 006 : un port déjà utilisé

## Scénario

Le service `lab-006-api` est une petite API qui doit répondre sur le **port 8080**. On vient de le démarrer, mais il ne fonctionne pas. L'équipe compte sur toi pour comprendre pourquoi et le remettre en marche.

## Objectif

- `systemctl status lab-006-api` indique que le service est actif.
- Le port 8080 est bien servi par ce service (et non par autre chose).
- Tu peux expliquer ce qui avait causé le problème.

## Prérequis

- Podman (rootless). Aucune VM, aucun clone : tout tourne dans un conteneur jetable et isolé (aucun dossier de l'hôte, pas de réseau).

## Lancer le lab

Depuis la racine du repo :

```
./scripts/lab-run.sh 006-port-deja-utilise
```

Le script construit l'environnement la première fois, puis t'ouvre un shell sur un serveur Debian. Ne lis pas `setup.sh`, `hints.md` ni `debrief.md` avant la fin.

## Remise à zéro

Tape `exit` : le conteneur est détruit. (`cleanup.sh` ne sert que si tu as lancé `setup.sh` à la main sur une VM jetable.)
