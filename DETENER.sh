#!/bin/sh

### INFO
# SERVICIO: DETENER.sh
# USO: $ DETENER.sh {NOMBRE_ARCHIVO}
# PARAMETRO: -{NOMBRE_ARCHIVO} a detener.            
# Descripcion: Inicializa un proceso y crea su pid en el directorio
#              raiz
# Problemas: -detiene el pid pero no lo borra
### FINAL 
 
MIBASENAME="$(basename "$1")"
EXTENSION="${MIBASENAME##*.}"
NAME="${MIBASENAME%.*}"

#NAME="daemon" #"${MIBASENAME%.*}"
#EXTENSION="sh"
#ARG="stop"
 
DESC="servicio $NAME.$EXTENSION"
#PIDFILE="/var/run/g4_tmp_dir/daemon.pid"
PIDFILE="./${NAME}.pid"

#indicamos que vamos a ejecutar un archivo
DAEMON="/home/cesar/workspace/7508-SSOO/sistemasOperativos2015C2"
test -x $DAEMON || exit 0
set -e
 
echo "deteniendo ${DESC}: "
start-stop-daemon --stop --pidfile "$PIDFILE"
echo "$DESC finalizado"
exit 0
