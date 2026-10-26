# Débrief

À lire seulement au débrief.

## Cause

Un dossier de sessions oubliées (`spool/sessions`) contient des milliers de fichiers vides. Chaque fichier consomme un **inode**, même sans contenu. Le système de fichiers n'en a que 4096 : une fois épuisés, aucune création n'est possible, avec le message « No space left on device », alors qu'il reste de la place en octets.

## Parcours de diagnostic efficace

1. Observer : l'erreur dit « No space left on device », mais `df -h` montre de l'espace libre. Cette contradiction est le signal.
2. Hypothèse : ce n'est pas l'espace en octets qui manque, mais autre chose : les inodes.
3. Vérifier : `df -i` montre `100%` d'inodes utilisés sur le disque du lab.
4. Localiser : compter les fichiers par dossier (`find <dossier> | wc -l`), repérer `spool/sessions`.
5. Décider : ces sessions sont-elles utiles ? Ici non. Supprimer les fichiers, pas le dossier ni `important.db`.
6. Vérifier : `df -i`, puis `touch` d'un fichier test.

## Commandes utiles

- `df -h` : espace en octets. `df -i` : inodes.
- `find <dossier> -type f | wc -l` : nombre de fichiers.
- `ls -i` et `stat` : numéro d'inode d'un fichier.
- `find <dossier> -type f -delete` : supprimer beaucoup de fichiers (plus fiable que `rm *`).

## Variantes et pièges

- `rm *` sur un dossier énorme échoue avec « Argument list too long » : utiliser `find … -delete`.
- Sur ext4, le nombre d'inodes est fixé à la création du système de fichiers ; sur d'autres (xfs, btrfs), c'est différent.
- Supprimer des fichiers ouverts par un processus ne libère pas leurs inodes tant qu'il les garde ouverts (`lsof +L1`).
