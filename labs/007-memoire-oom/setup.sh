#!/usr/bin/env bash
# Lab 007 : un cache configuré plus gros que la mémoire disponible se fait tuer en boucle.
set -euo pipefail

LAB="lab-007"
DIR="/opt/${LAB}"
UNIT="${LAB}-cache"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

# Dans le conteneur jetable, pas de confirmation.
# Sur une vraie machine ou une VM, on demande avant de dégrader quoi que ce soit.
if [ ! -e /run/.containerenv ]; then
  echo "Ce script va dégrader cette machine. Elle doit être jetable."
  read -r -p "Tape oui pour continuer : " rep
  [ "$rep" = "oui" ] || { echo "Annulé."; exit 1; }
fi

# Idempotent : on arrête le service avant de tout recréer.
systemctl stop "$UNIT" 2>/dev/null || true
mkdir -p "$DIR"

# Petit « cache » : réserve la taille demandée par blocs de 10 Mo, puis reste en attente.
cat > "${DIR}/cache-server.pl" <<'PERL'
use strict; use warnings;
$| = 1;
my $mb = $ENV{CACHE_MB} // 64;
my (@cache, $done);
$done = 0;
print "cache : demarrage, objectif ${mb} Mo\n";
while ($done < $mb) {
  push @cache, 'x' x (10 * 1024 * 1024);
  $done += 10;
  print "cache : ${done} Mo reserves\n";
  select(undef, undef, undef, 0.2);
}
print "cache : pret\n";
sleep 3600 while 1;
PERL

# Configuration modifiée « hier » : trop gros pour cette machine.
echo "CACHE_MB=900" > "${DIR}/cache.conf"

cat > "/etc/systemd/system/${UNIT}.service" <<UNITFILE
[Unit]
Description=Cache en memoire du lab 007
StartLimitIntervalSec=0

[Service]
EnvironmentFile=${DIR}/cache.conf
ExecStart=/usr/bin/perl ${DIR}/cache-server.pl
Restart=on-failure
RestartSec=3

[Install]
WantedBy=multi-user.target
UNITFILE

systemctl daemon-reload
systemctl enable --now "$UNIT" >/dev/null 2>&1

echo "Lab prêt. C'est parti, 10 minutes."
