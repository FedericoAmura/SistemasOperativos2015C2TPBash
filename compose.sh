#!/bin/bash

#
# Crea el paquete de instalacion para el sistema AFRA-J
# Contenido del paquete .zip:
#	-README.md
#	-Documentos del sistema
#	-Arbol de directorio inicial
#


#Set Name
NOMBRE_PAQUETE_ZIP="AFRA-J.zip"
PAQUETE="AFRA-J"

#Set Archivos



if [ "$1" == "-pack" ]
then
	
	#Carpeta par contener el paquete y arbol de directorio por defecto.
	mkdir $PAQUETE
	mkdir $PAQUETE/conf
	
	#Agrega todos los scripts para la instalacion.
	cp AFINSTALL.sh $PAQUETE/
	
	#Crea archivo .zip
	zip -r $NOMBRE_PAQUETE_ZIP $PAQUETE 	
	
	#Con AFRA-J.zip creado
	#Elimina todo el directorio AFRA-J
	rm -R $PAQUETE 

	echo -e "Se creo el paquete de instalacion \n \t PATH: $PWD/$NOMBRE_PAQUETE_ZIP"
	
		
fi

#Eliminar archivo .zip

if [ "$1" == "-rm" ] 
then
	rm $NOMBRE_PAQUETE_ZIP
	
fi
















