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
  # TODO echo validarformato!
  #file_name=$(echo "$1" | egrep '^..*_[0-9]{4}-[0-9]{2}-[0-9]{2}$')
  echo 0
	
}

#5- Valida que el nombre del archivo.
# COD_CENTRAL debe existir en el maestro de materiales
# ANIOMESDIA debe ser una fecha valida
# ANIOMESDIA debe ser a lo sumo de un año de antiguedad
# ANIOMESDIA debe ser menor o igual a  la fecha del dia
# Devuelve 0 si el nombre del archivo es valido. 
# Devuelve 1 si el nombre del archivo es invalido.
# Recibe el nombre del archivo.
validarNombreArchivo() {
  # TODO echo validar nombre
  nombre_archivo=$1
  echo 0
	
}

#7- Rechazar.
# Rechaza el archivo
rechazar() {
  # TODO
  nombre_archivo=$1
  echo 0
	
}

source MoverA.sh

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
     	     #echo el nombre esta bien
	     #TODO 6- invocar a moverA para aceptar
	     origen="./nov/"$nombre_archivo
	     echo Intento mover $origen	a ./acep
	     MoverA $origen "./acep"
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

sleep 30 #cada 30 segundos se repite; se puede cancelar con: ctrl+c
done



