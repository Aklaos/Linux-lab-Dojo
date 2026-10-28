---
niveau: fondamentaux
duree: 10 min
themes: [droits, propriétaire, chmod, chown, systemd, journalctl]
---

# Lab 004 : droits et propriété de fichiers

## Scénario

Après une intervention de maintenance hier soir, le service `lab-004-app` ne fonctionne plus : il démarre, puis s'arrête et redémarre en boucle, et plus rien n'est enregistré. L'équipe compte sur toi pour comprendre ce qui se passe et le remettre en route proprement.

## Objectif

- Le service `lab-004-app` est actif et stable (il ne redémarre plus en boucle).
- Il écrit de nouveau dans `/opt/lab-004/data/app.log`.
- Le fichier `/opt/lab-004/data/important.db` est **intact**.
- La correction est **propre** : pas de `chmod 777`, pas d'ouverture générale des droits.
- Tu peux expliquer ce qui avait causé le problème.

## Prérequis

- Podman (rootless). Aucune VM, aucun clone : tout tourne dans un conteneur jetable et isolé (aucun dossier de l'hôte, pas de réseau).

## Lancer le lab

Depuis la racine du repo :

```
./scripts/lab-run.sh 004-droits-fichiers
```

Le script construit l'environnement la première fois, puis t'ouvre un shell sur un serveur Debian. Ne lis pas `setup.sh`, `hints.md` ni `debrief.md` avant la fin.

## Remise à zéro

Tape `exit` : le conteneur est détruit. (`cleanup.sh` ne sert que si tu as lancé `setup.sh` à la main sur une VM jetable.)
