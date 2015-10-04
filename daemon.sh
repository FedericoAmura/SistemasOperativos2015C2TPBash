#!/bin/bash

### INFO
# SERVICIO: daemon.sh
# USO: $ daemon.sh {PARAMETRO}
# PARAMETRO: - Acepta por parametro=start|stop|status
# Descripcion: Inicializa un proceso e imprime por pantalla la hora
### FINAL

#$$-> pid

function sanityCheck {
    q=`ps -ef |grep $0 |grep -v "grep"|grep -v $$| wc -l`
    if [ $q != "0" ]; then
        echo "Existe una instancia de $0 corriendo..."
        exit 1
    fi
}


function status {
    q=`ps -ef |grep $0 |grep -v "grep"|grep -v $$| wc -l`
    w=`ps -ef |grep $0 |grep -v "grep"|grep -v $$`
    if [ $q != "0" ]; then
        echo "$w" #imprime la linea del grep
        echo "Existe una instancia de $0 corriendo..."
    fi
}

function start {
    sanityCheck
    echo "Daemon corriendo.. $0"
    main
}

function stop {
    echo "cerrando daemon..$0"
    kill `ps -ef |grep $0|grep -v $$ |grep -v "grep"|awk '{print($2)}'`
   
}

function main {
    {
        while [ 1 ]; do
            fechahora=`date +"%Y/%m/%d %r"`
            echo "$fechahora test proceso $0 con pid $$"
            sleep 10
        done
    } #& #&=proceso en background
}

case $1 in
    "start")
       start
    ;;
    "stop")
        stop
    ;;
    "status")
        status        
    ;;
     *)
     echo "Uso: $0 {start|stop|status}"
     exit 1
     ;;
esac
