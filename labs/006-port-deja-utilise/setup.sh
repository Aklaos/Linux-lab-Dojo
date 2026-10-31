#!/usr/bin/env bash
# Lab 006 : un service ne peut pas démarrer car son port est déjà pris.
set -euo pipefail

LAB="lab-006"
DIR="/opt/${LAB}"
UNIT="/etc/systemd/system/${LAB}-api.service"
PIDFILE="/tmp/${LAB}-stray.pid"

[ "$(id -u)" -eq 0 ] || { echo "Lance ce script avec sudo."; exit 1; }

# Dans le conteneur jetable, pas de confirmation.
# Sur une vraie machine ou une VM, on demande avant de dégrader quoi que ce soit.
if [ ! -e /run/.containerenv ]; then
  echo "Ce script va dégrader cette machine. Elle doit être jetable."
  read -r -p "Tape oui pour continuer : " rep
  [ "$rep" = "oui" ] || { echo "Annulé."; exit 1; }
fi

mkdir -p "$DIR"

# Petit serveur HTTP en Perl : écoute sur le port 8080 et répond « ok ».
cat > "${DIR}/server.pl" <<'PERL'
use strict; use warnings;
use IO::Socket::INET;
$0 = $ARGV[0] // 'server';
my $s = IO::Socket::INET->new(LocalAddr => '0.0.0.0', LocalPort => 8080,
  Listen => 5, ReuseAddr => 1) or die "bind 8080 impossible : $!\n";
while (my $c = $s->accept) {
  print $c "HTTP/1.0 200 OK\r\nContent-Length: 3\r\n\r\nok\n";
  close $c;
}
PERL

# Service du lab : doit écouter sur le port 8080.
cat > "$UNIT" <<UNITEOF
[Unit]
Description=API du lab 006

[Service]
ExecStart=/usr/bin/perl ${DIR}/server.pl lab-006-api

[Install]
WantedBy=multi-user.target
UNITEOF
systemctl daemon-reload

# Idempotence : on repart d'un état propre.
systemctl stop "${LAB}-api.service" >/dev/null 2>&1 || true
[ -f "$PIDFILE" ] && kill "$(cat "$PIDFILE")" 2>/dev/null || true
rm -f "$PIDFILE"

# Un vieux processus oublié occupe déjà le port 8080.
setsid nohup /usr/bin/perl "${DIR}/server.pl" report-viewer \
  >/dev/null 2>&1 < /dev/null &
echo $! > "$PIDFILE"
sleep 1

# Le service est lancé : il échoue, c'est voulu.
systemctl start "${LAB}-api.service" >/dev/null 2>&1 || true

echo "Lab prêt. C'est parti, 10 minutes."
