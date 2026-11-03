---
niveau: fondamentaux
duree: 10 min
themes: [fichiers ouverts, ulimit, LimitNOFILE, /proc, systemd]
---

# Lab 008 : le serveur qui se dégrade

## Scénario

Le service `lab-008-gateway` doit accepter jusqu'à **300 connexions clientes** simultanées. Depuis son déploiement, tout se passe bien pendant quelques dizaines de secondes, puis il se met à produire des erreurs et n'accepte plus de nouveaux clients. L'équipe compte sur toi pour comprendre pourquoi et le remettre d'aplomb.

## Objectif

- Le service finit par afficher dans son journal que ses **300 connexions** sont ouvertes, sans plus aucune erreur.
- La correction est **durable** : elle reste valable si le service est redémarré.
- Tu peux expliquer ce qui avait causé le problème.

## Prérequis

- Podman (rootless). Aucune VM, aucun clone : tout tourne dans un conteneur jetable et isolé (aucun dossier de l'hôte, pas de réseau).

## Lancer le lab

Depuis la racine du repo :

```
./scripts/lab-run.sh 008-serveur-qui-se-degrade
```

Le script construit l'environnement la première fois, puis t'ouvre un shell sur un serveur Debian. Ne lis pas `setup.sh`, `hints.md` ni `debrief.md` avant la fin.

## Remise à zéro

Tape `exit` : le conteneur est détruit. (`cleanup.sh` ne sert que si tu as lancé `setup.sh` à la main sur une VM jetable.)
