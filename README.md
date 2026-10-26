# Linux-Dojo

Un dojo de **mini-labs Linux de 10 minutes**. Chaque lab met en place un petit incident sur une machine (réseau, mémoire, disque, droits, service…). Tu te connectes, tu diagnostiques, tu corriges. Au bout de 10 minutes, on débriefe.

Niveau actuel : **fondamentaux**. Il n'y a ni note ni suivi de performance : le but est d'apprendre une méthode (observer, formuler une hypothèse, vérifier).

## Pour qui

Pour toute personne qui veut s'entraîner au diagnostic Linux, seule ou avec un mentor (humain ou IA) qui anime la session.

## Prérequis

- **Linux** avec **Podman** (rootless, cgroups v2). Aucune VM, aucun SSH, aucun `sudo`.
- `git`, et `gh` (GitHub CLI) pour le workflow des tickets et des PR.

## Avertissement de sécurité

Chaque lab tourne dans un **conteneur Podman jetable, rootless et durci** : pas de volume de l'hôte, pas de réseau, droits réduits, mémoire, CPU et processus bornés, `no-new-privileges`. Le conteneur est détruit à la sortie. Les scripts `setup.sh` se limitent à leur périmètre (dossier, utilisateur, unité systemd ou fichier propres au lab). S'ils sont lancés à la main sur une vraie machine, ils demandent confirmation : à réserver à une VM jetable. Détails : [docs/securite.md](docs/securite.md).

## Comment se déroule un lab

1. Tu choisis un thème (ou une surprise).
2. Le mentor ouvre un **ticket** (issue GitHub), une branche et une PR en brouillon, puis écrit le lab.
3. Tu lances `./scripts/lab-run.sh NNN-theme` : tu arrives dans un shell sur un serveur Debian jetable.
4. Chrono : **10 minutes** pour diagnostiquer et corriger.
5. Débrief : on revient ensemble sur ce que tu as observé, tes hypothèses et la cause.
6. Tu tapes `exit` : le conteneur est détruit. Le mentor pousse le lab, la PR passe en « prête », le mainteneur la fusionne (le ticket se ferme).

Les indices (`hints.md`) ne se lisent qu'à la demande, un par un. `debrief.md` ne se lit qu'au débrief.

## Refaire un lab de zéro

```
git clone <url-du-repo>
cd Linux-Dojo
./scripts/lab-run.sh NNN-theme
```

Lis le `README.md` du lab (scénario), mais pas `setup.sh`, `hints.md` ni `debrief.md` avant la fin si tu veux garder l'enquête intacte. La liste des labs est dans [labs/INDEX.md](labs/INDEX.md).

## Structure

- `labs/INDEX.md` : tableau de tous les labs.
- `labs/TEMPLATE/` : modèle pour créer un lab.
- `labs/NNN-theme/` : un lab (`README.md`, `setup.sh`, `cleanup.sh`, `hints.md`, `debrief.md`).
- `docs/securite.md` : règles de sécurité des scripts.
- `containers/debian-server/` : image du serveur Debian jetable.
- `scripts/` : outillage (`lab-run.sh`, `open-lab.sh`, `publish-lab.sh`).

## Contribuer

Un lab = un ticket = une branche `lab-NNN-theme` = une pull request (PR, demande de fusion de ta branche dans `main`). Pars de `labs/TEMPLATE/`, respecte les règles de [docs/securite.md](docs/securite.md), et ne mets aucune donnée personnelle (nom d'utilisateur, nom de machine, IP, jeton) : les scénarios sont génériques.
