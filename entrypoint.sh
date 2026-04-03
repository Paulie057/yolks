#!/bin/bash
cd /home/container

# Nahrazení proměnných v příkazu (standardní Pterodactyl procedura)
MODIFIED_STARTUP=$(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Spuštění příkazu
eval ${MODIFIED_STARTUP}
