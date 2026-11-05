# Débrief

À lire seulement au débrief.

## Cause

L'unité du service fixe `CPUQuota=10%`. systemd la traduit en `cpu.max` sur le cgroup du service : `10000 100000`, c'est-à-dire **10 ms de CPU par période de 100 ms**. Dès que le service a consommé ce budget, le noyau le met en pause jusqu'à la période suivante (le « throttling »). Le débit tombe à environ 2 éléments/s au lieu de 20, alors que le reste de la machine est inactif.

## Parcours de diagnostic efficace

1. Observer : le journal (`journalctl -u lab-010-batch`) montre un débit d'environ 2/s au lieu de 20.
2. Regarder le processus : `top` ou `ps` montrent environ 10 % de CPU, alors que la machine est libre et que le programme ne fait que calculer. Un travail purement CPU qui n'utilise pas tout son CPU est bridé de l'extérieur.
3. Hypothèse : une limite de CPU. Vérifier : `cat /sys/fs/cgroup/system.slice/lab-010-batch.service/cpu.max` (`10000 100000`) et `cpu.stat` (`nr_throttled` et `throttled_usec` augmentent sans cesse).
4. Relier à la configuration : `systemctl show -p CPUQuotaPerSecUSec` ou `systemctl cat` montrent `CPUQuota=10%`.
5. Corriger durablement : `systemctl edit lab-010-batch` avec `[Service]` puis `CPUQuota=100%` (ou une ligne vide `CPUQuota=` pour retirer le plafond), puis `systemctl restart`.
6. Vérifier : le débit remonte vers 20 éléments/s, et `nr_throttled` cesse d'augmenter.

## Commandes utiles

- `top`, `ps -o pid,pcpu,cmd -p <PID>` : consommation de CPU d'un processus.
- `cat /sys/fs/cgroup/system.slice/<unité>/cpu.max` et `cpu.stat` : quota, période et compteurs de throttling.
- `systemctl show -p CPUQuotaPerSecUSec <service>`, `systemctl cat`, `systemctl edit` : lire et surcharger l'unité.

## Variantes et pièges

- Un quota de CPU ne se voit ni dans la charge de la machine (« load average »), ni dans les processus concurrents : c'est le symptôme d'un service lent sans cause apparente.
- Ne pas confondre le quota (`cpu.max`, plafond absolu) et le poids (`cpu.weight`, partage proportionnel quand la machine est chargée).
- Plusieurs niveaux peuvent se cumuler : ici le conteneur est lui-même limité à 1 CPU.
- `CPUQuota=200%` autorise l'usage de deux cœurs au maximum.
