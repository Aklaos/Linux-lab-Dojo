#!/usr/bin/env bash
# Lab 009 : un service lance 8 processus mais son unité n'autorise que 5 tâches.
set -euo pipefail

LAB="lab-009"
DIR="/opt/${LAB}"
UNIT="${LAB}-workers"

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

# Le « gestionnaire » : lance 8 processus de travail, échoue s'il n'y arrive pas.
cat > "${DIR}/workers.pl" <<'PERL'
use strict; use warnings;
$| = 1;
my $wanted = 8;
my ($ok, $fail) = (0, 0);
for my $i (1 .. $wanted) {
  my $pid = fork();
  if (!defined $pid) {
    print "worker $i : demarrage impossible : $!\n";
    $fail++;
    next;
  }
  if ($pid == 0) { sleep 3600; exit 0; }
  $ok++;
}
if ($fail) {
  print "demarrage incomplet : $ok/$wanted workers, arret\n";
  exit 1;
}
print "$ok workers actifs, tout est ok\n";
sleep 3600 while 1;
PERL

cat > "/etc/systemd/system/${UNIT}.service" <<UNITFILE
[Unit]
Description=Equipe de workers du lab 009
StartLimitIntervalSec=0

[Service]
ExecStart=/usr/bin/perl ${DIR}/workers.pl
TasksMax=5
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
UNITFILE

systemctl daemon-reload
systemctl enable --now "$UNIT" >/dev/null 2>&1 || true

echo "Lab prêt. C'est parti, 10 minutes."
