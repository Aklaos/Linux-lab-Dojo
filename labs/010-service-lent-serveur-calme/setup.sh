#!/usr/bin/env bash
# Lab 010 : un service CPU-bound bridé par un quota de CPU dans son unité.
set -euo pipefail

LAB="lab-010"
DIR="/opt/${LAB}"
UNIT="${LAB}-batch"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

# Dans le conteneur jetable, pas de confirmation.
# Sur une vraie machine ou une VM, on demande avant de dégrader quoi que ce soit.
if [ ! -e /run/.containerenv ]; then
  echo "Ce script va dégrader cette machine. Elle doit être jetable."
  read -r -p "Tape oui pour continuer : " rep
  [ "$rep" = "oui" ] || { echo "Annulé."; exit 1; }
fi

# Idempotent : on repart d'un état propre.
systemctl stop "$UNIT" 2>/dev/null || true
rm -rf "/etc/systemd/system/${UNIT}.service.d"
mkdir -p "$DIR"

# Traitement : un « élément » coûte 50 ms de temps CPU, quel que soit le CPU.
# Sans bridage, le débit est donc de 20 éléments par seconde.
cat > "${DIR}/batch.pl" <<'PERL'
use strict; use warnings;
$| = 1;
# Temps CPU consommé (utilisateur + système).
sub cpu { my @t = times; return $t[0] + $t[1]; }
my ($count, $last) = (0, time);
while (1) {
  my $t0 = cpu();
  1 while (cpu() - $t0) < 0.05;
  $count++;
  my $now = time;
  if ($now - $last >= 5) {
    printf "debit : %.1f elements/s (attendu : 20)\n", $count / ($now - $last);
    ($count, $last) = (0, $now);
  }
}
PERL

cat > "/etc/systemd/system/${UNIT}.service" <<UNITFILE
[Unit]
Description=Traitement du lab 010

[Service]
ExecStart=/usr/bin/perl ${DIR}/batch.pl
CPUQuota=10%

[Install]
WantedBy=multi-user.target
UNITFILE

systemctl daemon-reload
systemctl enable --now "$UNIT" >/dev/null 2>&1

echo "Lab prêt. C'est parti, 10 minutes."
