#!/bin/bash


### INFO
# SERVICIO: DETENER.sh
# USO: $ DETENER.sh 
# Descripcion: Detiene el demonio AFREC unicamente si fue inizializado
#              con ARRANCAR.sh. 
#              En caso de no haber inicializado el proceso ARRANCAR.sh
#              muestra un mensaje por pantalla
# 
### FINAL

MIBASENAME="$(basename "$1")"
EXTENSION="${MIBASENAME##*.}"
NAME="${MIBASENAME%.*}"

ARG_0="ARRANCAR.sh" 

function stop {
    
    q=`ps -ef |grep /bin/bash |grep $ARG_0 |grep -v "grep"|grep -v $$| wc -l`
    w=`ps -ef |grep /bin/bash |grep $ARG_0 | grep -v $$ |grep -v "grep"`
#    echo "linea cerrando $q $w " #imprime la linea del grep
    if [ $q != "0" ]; then
    kill `ps -ef |grep /bin/bash |grep $ARG_0|grep -v $$ |grep -v "grep"|awk '{print($2)}'` 
    echo "Ha finalizado $ARG_0..."   
    else
    echo "No existe llamada a $ARG_0. No se pudo completar la operacion"
    fi
     
}

stop;

exit 0
