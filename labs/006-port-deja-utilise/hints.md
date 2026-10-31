# Indices

À donner un par un, à la demande, du plus vague au plus précis.

1. Commence par lire ce que dit systemd sur le service, et ce que le service a écrit dans son journal.
2. Le message parle d'un port. Qui écoute déjà sur 8080 ? `ss -ltnp` te le dit.
3. Tu as un numéro de processus (PID). `ps -p <PID> -o pid,user,lstart,cmd` te dit qui il est et depuis quand il tourne.
4. Ce processus n'est pas lié au service. Une fois que tu es sûr qu'il est inutile, arrête-le proprement (`kill <PID>`), puis redémarre le service.
