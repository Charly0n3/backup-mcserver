#!/bin/bash
# Description: Crea una copia de seguridad del mundo, la comprime y la nombra como la fecha de ese día. 
# Se guardan hasta 3 días de copias, luego se borran las más antiguas y el ciclo reinicia.

# Definir colores
red="\e[0;31m\033[1m"
green="\e[0;32m\033[1m"
turquoise="\e[0;36m\033[1m"
end="\033[0m\e[0m"

copy_data() {
    DATE=$(date +"%d-%m-%Y_%H:%M")
    ORG=/home/charlyone/data/docker/minecraft/data/world
    DST=/home/charlyone/data/docker/minecraft/respaldo-mundo/
    LOG_DIR=/home/charlyone/data/docker/minecraft/logs/
    
    cd "$ORG" && zip -r "$DST/$DATE.zip" . &> /dev/null

	LOG_DIR=/home/charlyone/data/docker/minecraft/logs/


	if [ $(echo $?) -eq 0 ]; then
        	echo -e "${turquoise}[$(date)]${end} La copia se ha realizado con ${green}éxito${end}" >> $LOG_DIR/backup.log
    	else
        	echo -e "${turquoise}[$(date)]${end} Resultado de la copia:  ${red}fallido${end}" >> $LOG_DIR/backup.log
    	fi

}

check_days() {
    DST=/home/charlyone/data/docker/minecraft/respaldo-mundo/
    DAYS=$(ls $DST | wc -w)

    if [ $DAYS -ge 3 ]; then
        ls -t "$DST"/*.zip | tail -n +4 | xargs rm -f
    fi
}

server_reboot() {
    LOG_DIR=/home/charlyone/data/docker/minecraft/logs/

    docker restart kepler &> /dev/null
    
    if [ $(echo $?) -eq 0 ]; then
        echo -e "${turquoise}[$(date)]${end} Servidor reiniciado con ${green}éxito${end}" >> $LOG_DIR/reboot.log
    else
        echo -e "${turquoise}[$(date)]${end} Reinicio de servidor ${red}fallido${end}" >> $LOG_DIR/reboot.log
    fi
}

copy_data
check_days
server_reboot
