#!/bin/bash

### INFO
# SERVICIO: ARRANCAR.sh
# USO: $ ARRANCAR.sh 
# Descripcion: Inicializa el demonio AFREC con la opcion start
#              Para detener este proceso usar DETENER.sh
#              
### FINAL

MIBASENAME="$(basename "$1")"
EXTENSION="${MIBASENAME##*.}"
NAME="${MIBASENAME%.*}"


function sanityCheck {
    q=`ps -ef |grep bash |grep $0 |grep -v "grep"|grep -v $$| wc -l`
    w=`ps -ef |grep bash |grep $0 |grep -v "grep"|grep -v $$`
    if [ $q != "0" ]; then
        #echo "$w" #imprime la linea del grep
        echo "No se pudo inicializar $0. Ya existe una instancia corriendo."
        exit 1
    fi
}

function start {
    sanityCheck
    echo "Daemon corriendo desde $0"
    source AFREC.sh start
}

#inicializa ARRANCAR.sh
start


exit 0

