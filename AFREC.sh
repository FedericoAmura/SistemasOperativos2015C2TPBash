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
  echo validarformato!
  file_name=$(echo "$1" | egrep '^..*_[0-9]{4}-[0-9]{2}-[0-9]{2}$')
  #echo $file_name	
}


echo Inicio AFREC

#1- TODO Log nro de ciclo

#2- Chequea si hay archivos en NOVEDIR y los valida.

find "./nov" -type f | while read file; do
    nombre_archivo="$( echo "$file" | grep '[^/]*$' -o )"
	
	echo $nombre_archivo	
	tipo_archivo_ok=$(validarTipoArchivo $nombre_archivo)
	if [ $tipo_archivo_ok -eq 0 ]; then
     	 echo es de texto
	 $(validarFormatoNombreArchivo $nombre_archivo)
    	else
          echo rechazar
    	fi
  
done

echo Fin AFREC



