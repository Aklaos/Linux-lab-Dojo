# Indices

À donner un par un, à la demande, du plus vague au plus précis.

1. Lis bien le message d'erreur, puis compare-le à ce que te dit `df -h` : est-ce cohérent ?
2. Un système de fichiers peut manquer d'autre chose que d'octets. `df` a une option pour ça.
3. `df -i /opt/lab-002/data` montre l'état des inodes. Cherche ensuite quel dossier contient énormément d'éléments.
4. Compte les entrées par dossier, par exemple `for d in /opt/lab-002/data/*/*; do echo "$(find "$d" | wc -l) $d"; done | sort -n | tail`. Demande-toi si ces fichiers sont utiles avant de les supprimer.
