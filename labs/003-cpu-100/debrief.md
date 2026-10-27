# Débrief

À lire seulement au débrief.

## Cause

Le service `lab-003-report` exécute un script (`report-generator.sh`) qui boucle sans jamais attendre : il occupe un cœur de CPU à 100 %. Le service est configuré avec `Restart=always` : si on tue le processus, systemd le relance une seconde plus tard.

## Parcours de diagnostic efficace

1. Observer : la machine est lente. Regarder la consommation par processus (`top`, `ps aux --sort=-%cpu | head`).
2. Repérer le coupable : un processus `report-generator.sh` à environ 100 % de CPU, alors que l'API sommeille.
3. Relier au service : `systemctl status <PID>` (ou `cat /proc/<PID>/cgroup`) donne l'unité `lab-003-report.service`.
4. Agir par le bon canal : `systemctl stop lab-003-report`. Un simple `kill` serait inutile à cause de `Restart=always`.
5. Faire tenir la correction : `systemctl disable lab-003-report`, sinon il repart au prochain démarrage.
6. Vérifier : `top` calme, `systemctl status lab-003-api` toujours actif.

## Commandes utiles

- `top`, `ps aux --sort=-%cpu | head` : consommation par processus.
- `systemctl status <PID ou service>` : à quel service appartient un processus.
- `systemctl stop|disable|restart <service>` : gérer un service.
- `renice` et `kill -STOP <PID>` : ralentir ou suspendre un processus sans le tuer.

## Variantes et pièges

- Le « load average » et la ligne CPU globale de `top` peuvent refléter la machine hôte quand on est dans un conteneur : se fier au `%CPU` par processus.
- Tuer un processus géré par systemd est souvent vain : agir sur le service.
- Avant d'arrêter un service, vérifier qu'il n'est pas critique : ici l'API doit continuer à tourner.
- Un processus à 100 % n'est pas forcément un bug : ça peut être un travail légitime (compression, sauvegarde). D'où l'intérêt de comprendre ce qu'il fait avant de couper.
