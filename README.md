# Linux-Dojo

Un dojo de **mini-labs Linux de 10 minutes**. Chaque lab met en place un petit incident sur une machine (réseau, mémoire, disque, droits, service…). Tu te connectes, tu diagnostiques, tu corriges. Au bout de 10 minutes, on débriefe.

Niveau actuel : **fondamentaux**. Il n'y a ni note ni suivi de performance : le but est d'apprendre une méthode (observer, formuler une hypothèse, vérifier).

## Pour qui

Pour toute personne qui veut s'entraîner au diagnostic Linux, seule ou avec un mentor (humain ou IA) qui anime la session.

## Prérequis

- Une **VM Linux jetable** (Debian ou Ubuntu standard). Ne jamais utiliser une machine qui compte.
- Un accès **SSH** à cette VM.
- `sudo` (les scripts de mise en place tournent en root).
- `git` sur la VM pour récupérer les labs.

## Avertissement de sécurité

Les scripts `setup.sh` **dégradent volontairement** la machine. Lance-les uniquement sur une VM jetable. Ils se limitent à leur périmètre (dossier, utilisateur, unité systemd ou fichier propres au lab), ne coupent jamais SSH, ne téléchargent rien et ne contactent aucun service externe. Lis tout de même un script avant de le lancer en root si tu n'as pas confiance. Détails : [docs/securite.md](docs/securite.md).

## Comment se déroule un lab

1. Tu choisis un thème (ou une surprise).
2. Le mentor te donne un court scénario, sans la cause.
3. Sur la VM, tu récupères le repo et tu lances `sudo ./labs/NNN-theme/setup.sh` (confirmation demandée).
4. Chrono : **10 minutes** pour diagnostiquer et corriger.
5. Débrief : on revient ensemble sur ce que tu as observé, tes hypothèses et la cause.
6. Tu lances `cleanup.sh` pour remettre la VM en état.

Les indices (`hints.md`) ne se lisent qu'à la demande, un par un. `debrief.md` ne se lit qu'au débrief.

## Refaire un lab de zéro

```
git clone <url-du-repo>
cd Linux-Dojo
sudo ./labs/NNN-theme/setup.sh
# ... diagnostic ...
sudo ./labs/NNN-theme/cleanup.sh
```

Lis le `README.md` du lab (scénario, prérequis), mais pas `setup.sh`, `hints.md` ni `debrief.md` avant la fin si tu veux garder l'enquête intacte. La liste des labs est dans [labs/INDEX.md](labs/INDEX.md).

## Structure

- `labs/INDEX.md` : tableau de tous les labs.
- `labs/TEMPLATE/` : modèle pour créer un lab.
- `labs/NNN-theme/` : un lab (`README.md`, `setup.sh`, `cleanup.sh`, `hints.md`, `debrief.md`).
- `docs/securite.md` : règles de sécurité des scripts.
- `scripts/` : outillage (`open-lab.sh`, `publish-lab.sh`).

## Contribuer

Un lab = une branche `lab-NNN-theme` = une pull request (PR, demande de fusion de ta branche dans `main`). Pars de `labs/TEMPLATE/`, respecte les règles de [docs/securite.md](docs/securite.md), et ne mets aucune donnée personnelle (nom d'utilisateur, nom de machine, IP, jeton) : les scénarios sont génériques.
