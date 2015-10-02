#!/bin/bash

#3- Valida que sea un archivo de texto.
# Devuelve 0 si el tipo de archivo es texto.
# Devuelve 1 si el tipo de archivo NO es texto.
# Recibe el nombre del archivo.
validarTipoArchivo() {
  nombre_archivo=$1

    tipo_archivo=$(file -b --mime-type "./nov/$nombre_archivo")
    if [ "$tipo_archivo" == "text/plain" ]
  	then
   	 echo "0"
  	else
  	 echo "1"
  	fi
}

#4- Valida que el formato del nombre del archivo sea: <cod_central>_<aniomesdia>
# Devuelve 0 si el formato del nombre del archivo es correcto. 
# Devuelve 1 si el formato del nombre del archivo NO es correcto.
# Recibe el nombre del archivo.
validarFormatoNombreArchivo() {
  nombre_archivo=$(echo "$1" | egrep '^[A-Z]{3}_[0-9]{4}[0-9]{2}[0-9]{2}$')
  if [ "$nombre_archivo" == "$1" ]
  	then
   	 echo "0"
  	else
  	 echo "1"
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
     echo "1"
  fi

  if [ $dia -gt 31 ] || [ $dia -lt 1 ] ; then
     echo "1"
  fi

  diaActual=$(date +%d)
  mesActual=$(date +%m)
  anioActual=$(date +%Y)
  hoy=$anioActual$mesActual$diaActual
  $printf $hoy
  $printf $fecha
  #Valida que sea menor o igual a la fecha del dia
  #if [ $hoy -gt $fecha ]; then
  #   echo "1"
  #fi
   

  #Valida que la fecha tenga a lo sumo un anio de antiguedad
  #anioActual=$(($anioActual-1))
  #hoymenosanio=$anioActual$mesActual$diaActual

  #if [ $hoymenosanio -gt $fecha ]; then
  #   echo "1"
  #fi
  echo "0"
	
}

#7- TODO Rechazar.
# Rechaza el archivo
rechazar() {
  nombre_archivo=$1
  origen="./nov/"$nombre_archivo
  
  #invocar a moverA para rechazar
  #source MoverA.sh
  #MoverA $origen "./acep"
  #mv "$origen" "./rech"
  echo 0
	
}



numero_ciclo=0
while [ true ]
do
#1- TODO Log nro de ciclo.
numero_ciclo=$(($numero_ciclo+1))
echo Numero de ciclo: $numero_ciclo

#2- Chequea si hay archivos en NOVEDIR y los valida.

find "./nov" -type f | while read file; do
    nombre_archivo="$( echo "$file" | grep '[^/]*$' -o )"
	
	echo $nombre_archivo	
	tipo_archivo_ok=$(validarTipoArchivo $nombre_archivo)
	if [ $tipo_archivo_ok -eq 0 ]; then
     	 #echo es de texto
	 formato_nombre_archivo_ok=$(validarFormatoNombreArchivo $nombre_archivo)
	 if [ $formato_nombre_archivo_ok -eq 0 ]; then
     	   #echo el formato esta bien
	   nombre_archivo_ok=$(validarNombreArchivo $nombre_archivo)
	   if [ $nombre_archivo_ok -eq 0 ]; then
     	     echo el nombre esta bien
	     origen="./nov/"$nombre_archivo

	     #6-TODO invocar a moverA para aceptar
	     #source MoverA.sh
	     #MoverA $origen "./acep"
	     #mv "$origen" "./acep"
    	   else
             echo $(rechazar $nombre_archivo)
	   fi
    	 else
          echo $(rechazar $nombre_archivo)
    	 fi
    	else
          echo $(rechazar $nombre_archivo)
    	fi
  
done

if [ "$(ls -A "./acep")" ]; then
     # TODO invocar AFUMB
     echo AFUMB
else
    echo ""./acep" esta vacio"
fi

sleep 120 #cada 30 segundos se repite; se puede cancelar con: ctrl+c
done



