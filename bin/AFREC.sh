#!/bin/bash
source MoverA.sh
source GraLog.sh
source AFUMB.sh


# SERVICIO: AFREC.sh
# USO: $ ARFREC.sh ARGUMENTO_1
# ARGUMENTO_1: start|stop|status
# Descripcion: Detecta la llegada de procesos EN NOVEDIR 


#ARGUMENTOS
ARG_0=$0
ARG_1=$1


#3- Valida que sea un archivo de texto.
# Devuelve 0 si el tipo de archivo es texto.
# Devuelve 1 si el tipo de archivo NO es texto.
# Recibe el nombre del archivo.
validarTipoArchivo() {
  nombre_archivo=$1
  extension=$2
    tipo_archivo=$(file -b --mime-type "$NOVEDIR/$nombre_archivo"."$extension")
    if [ "$tipo_archivo" = "text/plain" ]
  	then
   	 echo 0
  	else
  	 echo 1
    fi
}

#4- Valida que el formato del nombre del archivo sea: <cod_central>_<aniomesdia>
# Devuelve 0 si el formato del nombre del archivo es correcto. 
# Devuelve 1 si el formato del nombre del archivo NO es correcto.
# Recibe el nombre del archivo.
validarFormatoNombreArchivo() {
  nombre_archivo=$(echo "$1" | egrep '^[A-Z]{3}_[0-9]{4}[0-9]{2}[0-9]{2}$')
  if [ "$nombre_archivo" = "$1" ]
  	then
   	 echo 0
  	else
  	 echo 1
  fi		
}

#5- Valida el nombre del archivo.
# COD_CENTRAL debe existir en el maestro de materiales
# ANIOMESDIA debe ser una fecha valida
# ANIOMESDIA debe ser a lo sumo de un año de antiguedad
# ANIOMESDIA debe ser menor o igual a  la fecha del dia
# Devuelve 0 si el nombre del archivo es valido. 
# Devuelve 1 si el nombre del archivo es invalido.
# Recibe el nombre del archivo.
validarNombreArchivo() {
  
  cod_central=$(echo "$1" | cut -d '_' -f 1)
  fecha=$(echo "$1" | cut -d '_' -f 2)
  #$printf $cod_central
  #$printf $fecha
  anio=${fecha:0:4}
  #$printf $anio
  mes=${fecha:4:2}
  #$printf $mes
  dia=${fecha:6:7}
  #$printf $dia

  #Valida el numero de dia y mes
  if [ $mes -gt 12 ] || [ $mes -lt 1 ] ; then
     echo 1
     return 
  fi

  if [ $dia -gt 31 ] || [ $dia -lt 1 ] ; then
     echo 1
     return 
  fi

  diaActual=$(date +%d)
  mesActual=$(date +%m)
  anioActual=$(date +%Y)
  #hoy=$anioActual$mesActual$diaActual 

  #Valida que la fecha no sea mayor a la fecha actual
 
  hoy=$(date +%Y%m%d)	
  fechaendate=$(date -d $fecha +%Y%m%d)
  #$printf $hoy
  #$printf $fechaendate
  
  if [ "$fechaendate" -gt "$hoy" ]; then
     echo 1
     return 
  fi
  
  #Valida que la fecha tenga a lo sumo un anio de antiguedad
  anioActual=$(($anioActual-1))
  hoymenosanio=$anioActual$mesActual$diaActual
  
  #$printf $anioActual
  #$printf $hoymenosanio
  if [ "$hoymenosanio" -gt "$fecha" ]; then
     echo 1
     return 
  fi

  #Valida que el cod_central exista en el maestro de centrales
  existe=$(grep "$cod_central" "$MAEDIR/centrales.csv")
  
  cod_obtenido=$(echo "$existe" | cut -d ';' -f 1)
  #$printf $cod_obtenido
  #$printf $cod_central
  if [ $cod_central != $cod_obtenido ] ; then
     return 1
  fi
  
  #todo ok  
  echo 0
	
}

#7- Rechazar.
# Rechaza el archivo
rechazar() {
  nombre_archivo=$1
  extension=$2
  origen=$NOVEDIR/$nombre_archivo
  
  #invocar a moverA para rechazar
  MoverA $origen"."$extension $RECHDIR/$nombre_archivo"."$extension AFREC
  
  return
	
}


function sanityCheck {
    q=`ps -ef |grep /bin/bash |grep $0 |grep -v "grep"|grep -v $$| wc -l`
    w=`ps -ef |grep /bin/bash |grep $0 |grep -v "grep"|grep -v $$`
    #q=`ps -ef |grep bash |grep $0 |grep -v "grep"|grep -v $$| wc -l`
    #w=`ps -ef |grep bash |grep $0 |grep -v "grep"|grep -v $$`

    if [ $q != "0" ]; then
		GraLog AFREC INFO "Existe una instancia de $0 corriendo...$ARG_0 $ARG_1 $MIBASENAME"
        #echo "$w" #imprime la linea del grep
        #echo "Existe una instancia de $0 corriendo...$ARG_0 $ARG_1 $MIBASENAME"
        exit 1
    fi
}


#manejo de estados para AFREC
function status {
    #q=`ps -ef |grep /bin/bash |grep $0 |grep -v "grep"|grep -v $$| wc -l`
    #w=`ps -ef |grep /bin/bash |grep $0 |grep -v "grep"|grep -v $$`
	q=`ps -ef |grep bash |grep $0 |grep -v "grep"|grep -v $$| wc -l`
    w=`ps -ef |grep bash |grep $0 |grep -v "grep"|grep -v $$`
    
    if [ $q != "0" ]; then
        echo "$w" #imprime la linea del grep
		GraLog AFREC INFO "Existe una instancia de $0 corriendo..."
#        echo "Existe una instancia de $0 corriendo..."
    fi
}

function start {
    sanityCheck
    echo "Daemon corriendo.. $0"
    main
}

function stop {
    echo "cerrando daemon..$0"
    w=`ps -ef |grep /bin/bash |grep $0|grep -v $$ |grep -v "grep"`
    echo "linea cerrando $w" #imprime la linea del grep
    kill `ps -ef |grep /bin/bash |grep $0|grep -v $$ |grep -v "grep"|awk '{print($2)}'`
    exit 0
}


function main {
numero_ciclo=0
while [ true ]
do
#1- Log nro de ciclo.
numero_ciclo=$(($numero_ciclo+1))
GraLog AFREC INFO "Ciclo: $numero_ciclo"
#echo Numero de ciclo: $numero_ciclo

#2- Chequea si hay archivos en NOVEDIR y los valida.
#echo "$NOVEDIR"
find $NOVEDIR -type f | while read file; do
	nombre_archivo=$(basename "$file")
        extension="${nombre_archivo##*.}"
	nombre_archivo="${nombre_archivo%.*}"
#	nombre_archivo=${file##*/}
#	nombre_archivo=${nombre_archivo%%.*}
#       nombre_archivo="$( echo "$file" | grep '[^/]*$' -o )" #BackUp

        tipo_archivo_ok=$(validarTipoArchivo $nombre_archivo $extension)
	if [ $tipo_archivo_ok -eq 0 ]; then
     	 #echo es de texto
	 formato_nombre_archivo_ok=$(validarFormatoNombreArchivo $nombre_archivo)
	 if [ $formato_nombre_archivo_ok -eq 0 ]; then
     	   #echo el formato esta bien
	   nombre_archivo_ok=$(validarNombreArchivo $nombre_archivo)

           if [ $nombre_archivo_ok -eq 0 ]; then

             #echo el nombre esta bien
	     origen=$NOVEDIR/$nombre_archivo
             if [ -s $origen ]; then
	     	#6-invocar a moverA para aceptar
	     	MoverA $origen"."$extension $ACEPDIR/$nombre_archivo"."$extension AFREC
	     else
             echo $(rechazar $nombre_archivo $extension)
	     fi 	
    	   else
             echo $(rechazar $nombre_archivo $extension)
	   fi
    	 else
          echo $(rechazar $nombre_archivo $extension)
    	 fi
    	else
          echo $(rechazar $nombre_archivo $extension)

    	fi
  
done

if [ "$(ls -A $ACEPDIR)" ]; then

     #echo AFUMB
     GraLog AFREC INFO "AFUMB corriendo"
     bash $BINDIR/AFUMB.sh
else
    #echo ""./acep" esta vacio"
    GraLog AFREC INFO "Invocacion de AFUMB pospuesta para el siguiente ciclo"
fi

sleep 10 #cada 10 segundos se repite;
done
}


case $ARG_1 in
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


