# Débrief

À lire seulement au débrief.

## Cause

L'unité systemd du service fixe `LimitNOFILE=100` : le processus ne peut pas avoir plus de 100 **descripteurs de fichiers** ouverts (fichiers, sockets, connexions). Chaque « client » en consomme un. Vers 95 clients, `open` échoue avec « Too many open files » (EMFILE), et le service ne peut plus accepter personne.

## Parcours de diagnostic efficace

1. Observer : le service tourne, puis des erreurs apparaissent après quelques dizaines de secondes. `journalctl -u lab-008-gateway` donne le message exact : « Too many open files ».
2. Hypothèse : une limite sur le nombre de fichiers ouverts. Vérifier : `ls /proc/<PID>/fd | wc -l` (proche de la limite) et `grep 'open files' /proc/<PID>/limits` (`Max open files 100`).
3. Trouver l'origine : `systemctl cat lab-008-gateway` (ou `systemctl show -p LimitNOFILE lab-008-gateway`) montre `LimitNOFILE=100`.
4. Corriger durablement : `systemctl edit lab-008-gateway` pour ajouter `[Service]` puis `LimitNOFILE=1024` (ou plus) dans une surcharge, puis `systemctl restart lab-008-gateway`.
5. Vérifier : le journal arrive à « 300 connexions ouvertes, tout est ok », sans erreur, et `/proc/<PID>/limits` affiche la nouvelle valeur.

## Commandes utiles

- `ls /proc/<PID>/fd | wc -l` et `lsof -p <PID>` : descripteurs ouverts par un processus.
- `cat /proc/<PID>/limits` : limites réellement appliquées à ce processus.
- `systemctl show -p LimitNOFILE <service>`, `systemctl cat`, `systemctl edit` : limite d'un service et surcharge propre.
- `ulimit -n` : limite de **ton shell**, pas celle du service.

## Variantes et pièges

- `ulimit -n` dans ton shell et `/etc/security/limits.conf` ne s'appliquent pas aux services systemd : il faut `LimitNOFILE=`.
- Distinguer le besoin légitime (beaucoup de clients) d'une **fuite** de descripteurs (le nombre monte sans cesse) : augmenter la limite ne règle pas une fuite.
- Il existe aussi une limite pour tout le système (`fs.file-max`), distincte de celle d'un processus.
- Modifier directement le fichier d'unité fonctionne, mais une surcharge (`systemctl edit`) survit aux mises à jour du paquet.
