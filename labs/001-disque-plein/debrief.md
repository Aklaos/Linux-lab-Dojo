# Débrief

À lire seulement au débrief.

## Cause

Une archive de logs oubliée (`logs/archive/app-2024.log.old`, environ 55 Mo) occupe presque tout le petit système de fichiers monté sur `data`. Il n'y a plus de blocs libres, donc toute écriture échoue avec « No space left on device ».

## Parcours de diagnostic efficace

1. Observer : lire le message d'erreur exact (`No space left on device`).
2. Hypothèse : le disque est plein. Vérifier avec `df -h` sur le bon point de montage.
3. Localiser : `du -sh` dossier par dossier, ou `du -ah | sort -h | tail`.
4. Décider : avant de supprimer, se demander si le fichier est utile. Ici une vieille archive de logs peut partir, `important.db` doit rester.
5. Vérifier : relancer `df -h` pour confirmer l'espace libéré.

## Commandes utiles

- `df -h` : espace par système de fichiers.
- `du -sh *` : taille de chaque élément d'un dossier.
- `du -ah <dossier> | sort -h | tail` : les plus gros fichiers.
- `ls -lhS` : fichiers triés par taille.
- `findmnt <chemin>` : à quel système de fichiers appartient un chemin.

## Variantes et pièges

- Disque non plein en octets mais **inodes épuisés** : `df -i`.
- Fichier supprimé mais **espace non libéré** car un processus le garde ouvert : `lsof +L1`.
- `df` et `du` ne montrent pas toujours le même chiffre (espace réservé, fichiers ouverts, autres points de montage).
- Supprimer à l'aveugle est risqué : toujours identifier le fichier avant.
