# Débrief

À lire seulement au débrief.

## Cause

Le service lance `/opt/lab-014/current/bin/app.sh`, où `current` est un **lien symbolique** censé pointer vers la version en cours. Deux problèmes se succèdent :

1. `current` pointe vers `releases/2026-11-2` (faute de frappe) : cette cible n'existe pas, le lien est **cassé**. systemd échoue à lancer le programme (code `203/EXEC`, « No such file or directory »).
2. Une fois le lien corrigé vers `releases/2026-11-12`, le fichier `app.sh` de cette version n'a pas le droit d'exécution : nouveau `203/EXEC`, cette fois « Permission denied ».

## Parcours de diagnostic efficace

1. Observer : `systemctl status lab-014-app` montre `status=203/EXEC` ; le journal dit « Failed to execute ... No such file or directory ».
2. Comprendre le code : `203/EXEC` = systemd n'a pas pu exécuter le binaire (chemin, droits, format). Ce n'est pas l'application qui échoue.
3. Examiner le chemin : `namei -l /opt/lab-014/current/bin/app.sh` ou `ls -l /opt/lab-014` montrent `current -> releases/2026-11-2`, en erreur ; `readlink -f` ne résout rien. Comparer avec `ls /opt/lab-014/releases`.
4. Corriger le lien : `ln -sfn releases/2026-11-12 /opt/lab-014/current`.
5. Relancer et relire le journal : « Permission denied ». Regarder `ls -l` sur le fichier, puis `chmod +x /opt/lab-014/releases/2026-11-12/bin/app.sh`.
6. Vérifier : `systemctl restart lab-014-app`, le journal affiche « version 2026-11-12 en marche ».

## Commandes utiles

- `namei -l <chemin>` : traverse un chemin élément par élément (liens, droits).
- `readlink -f <lien>` : cible finale d'un lien ; vide si le lien est cassé.
- `ls -l` : un lien cassé s'affiche avec sa cible en rouge dans un terminal couleur.
- `ln -sfn <cible> <lien>` : remplace un lien sans créer de lien à l'intérieur d'un dossier existant (`-n`).

## Variantes et pièges

- Un lien symbolique relatif se résout par rapport au **dossier du lien**, pas au dossier courant.
- Sans `-n`, `ln -sf` sur un lien qui pointe vers un dossier crée un lien **dans** ce dossier : erreur classique.
- Revenir à l'ancienne version (le « rollback ») est une option légitime en urgence, mais ici l'objectif était de livrer la nouvelle.
- Pour un basculement sans coupure, créer un lien temporaire puis le renommer (`mv -T`).
- Un script sans `x` fonctionne si on le lance par `bash app.sh`, mais pas comme programme (`ExecStart=`).
