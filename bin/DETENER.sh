#!/bin/bash

### INFO
# SERVICIO: DETENER.sh ARGUMENTO_1
# USO: $ DETENER.sh 
# ARGUMENTO_1: Obligatorio. Debe ser un proceso bash a detener.
# Descripcion: Detiene el demonio AFREC unicamente inizializado
#              con ARRANCAR.sh o desde AFINI.sh. 
#              En caso de no haber inicializado el proceso ARRANCAR.sh
#              o AFINI.sh muestra un mensaje por pantalla
# 
### FINAL

MIBASENAME="$(basename "$1")"
EXTENSION="${MIBASENAME##*.}"
NAME="${MIBASENAME%.*}"

CANT_ARGS=$#
ARG_0=$1

function stop {
    
    #q=`ps -ef |grep /bin/bash |grep $ARG_0 |grep -v "grep"|grep -v $$| wc -l`
    #w=`ps -ef |grep /bin/bash |grep $ARG_0 | grep -v $$ |grep -v "grep"`
    q=`ps -ef |grep bash |grep $ARG_0 |grep -v "grep"|grep -v $$| wc -l`
    w=`ps -ef |grep bash |grep $ARG_0 | grep -v $$ |grep -v "grep"`
    #echo "linea cerrando $q $w " #imprime la linea del grep
    if [ $q != "0" ]; then
    kill `ps -ef |grep bash |grep $ARG_0|grep -v $$ |grep -v "grep"|awk '{print($2)}'` 
    #echo "Ha finalizado $ARG_0..."   
    else
    echo "No existe llamada a $ARG_0. No se pudo completar la operacion"
    exit 2
    fi
     
}

function validarArgs {
if [ "$CANT_ARGS" -ne "1" ]; then
	echo "Cantidad de argumentos incorrectos. "
	echo "USO: DETENER.sh ARGUMENTO"
    exit 1
fi
return 0
}

validarArgs
stop

#exit 0
