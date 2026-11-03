#!/usr/bin/env bash
# Lab 008 : un service qui garde ouvertes 300 « connexions » mais dont la limite systemd est trop basse.
set -euo pipefail

LAB="lab-008"
DIR="/opt/${LAB}"
UNIT="${LAB}-gateway"

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

# Petit « serveur » : ouvre une ressource par « client », jusqu'à 300, et les garde.
cat > "${DIR}/gateway.pl" <<'PERL'
use strict; use warnings;
$| = 1;
my $target = 300;
my @clients;
print "gateway : demarrage, objectif $target connexions\n";
while (@clients < $target) {
  if (open(my $fh, '<', '/dev/null')) {
    push @clients, $fh;
    print "gateway : ", scalar(@clients), " connexions ouvertes\n" if @clients % 25 == 0;
  } else {
    print "gateway : erreur sur le client ", scalar(@clients) + 1, " : $!\n";
  }
  select(undef, undef, undef, 0.3);
}
print "gateway : ", scalar(@clients), " connexions ouvertes, tout est ok\n";
sleep 3600 while 1;
PERL

cat > "/etc/systemd/system/${UNIT}.service" <<UNITFILE
[Unit]
Description=Passerelle du lab 008

[Service]
ExecStart=/usr/bin/perl ${DIR}/gateway.pl
LimitNOFILE=100

[Install]
WantedBy=multi-user.target
UNITFILE

systemctl daemon-reload
systemctl enable --now "$UNIT" >/dev/null 2>&1

echo "Lab prêt. C'est parti, 10 minutes."
