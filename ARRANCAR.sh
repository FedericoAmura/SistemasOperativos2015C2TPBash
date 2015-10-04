#!/bin/sh

### INFO
# SERVICIO: ARRANCAR.sh
# USO: $ ARRANCAR.sh {NOMBRE_ARCHIVO} {PARAMETRO}
# PARAMETRO: -El primer parametro es el nombre del archivo a inicializar. 
#             Solo acepta un parametro {PARAMETRO} para un 
#             {NOMBRE_ARCHIVO}
# Descripcion: Inicializa un proceso y crea su pid en el directorio
#              raiz
# Problemas: -no pude crear el pid en el directorio /var/run por no 
#             tener permisos sobre el directorio. Se probo creando
#             un directorio temporal pero dio el mismo error.
#            -no borra el pid 
### FINAL

MIBASENAME="$(basename "$1")"
EXTENSION="${MIBASENAME##*.}"
NAME="${MIBASENAME%.*}"


#NAME="daemon" #"${MIBASENAME%.*}"
#EXTENSION="sh"
#ARG="start"

DESC="servicio $NAME.$EXTENSION"
PIDFILE="./${NAME}.pid" #"var/run/${NAME}.pid"

#indicamos que vamos a ejecutar el archivo
DAEMON="/home/cesar/workspace/7508-SSOO/sistemasOperativos2015C2"
test -x $DAEMON || exit 0
set -e

echo "inicializando ${DESC}: "
start-stop-daemon --start --make-pidfile --pidfile "$PIDFILE" --exec "$DAEMON/$NAME.$EXTENSION" -- $ARG
echo "$DESC inicializado"
exit 0

