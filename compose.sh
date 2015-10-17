#!/bin/bash

#
# Crea el paquete de instalacion para el sistema AFRA-J
# Contenido del paquete .zip:
#	-README.md
#	-Documentos del sistema
#	-Arbol de directorio inicial
#


# Directorio:
#
#├── AFRA-J
#│   ├── bin
#│   │   ├── AFINSTAL.sh
#│   │   ├── GraLog.sh
#│   │   ├── MoverA.sh
#│   │   ├── ARRANCAR.sh
#│   │   ├── DETENER.sh
#│   │   ├── AFINI.sh
#│   │   ├── AFREC.sh
#│   │   ├── AFUMB.sh
#│   │   └── AFLIST.sh
#│   ├── conf
#│   ├── master
#│   └── data
#│       ├── agentes.csv
#│       ├── BEL_20150703.csv
#│       ├── BEL_20150803.csv
#│       ├── CdA.csv
#│       ├── CdP.csv
#│       ├── centrales.csv
#│       ├── COS_20150703.csv
#│       ├── COS_20150803.csv
#│       ├── SIS_20150703.csv
#│       ├── SIS_20150803.csv
#│       └── umbrales.csv
# 
#

#MUY IMPORTANTE, MODIFICAR ESTE SIMPRE SCRIPT A GUSTO,
#SI VEN QUE ES NECESARIO OTRA FUNCIONALIDAD, SERIA IDEAL AGREGARLA
#


#Set Name
NOMBRE_PAQUETE_ZIP="AFRA-J.zip"

#Variable de entorno para usar en AFINSTAL.sh 
GRUPO="AFRA-J"

#Set Archivos



if [ "$1" == "-pack" ]
then
	
	#Carpeta par contener el paquete y arbol de directorio por defecto.
	mkdir $GRUPO
	mkdir $GRUPO/conf
	mkdir $GRUPO/bin
	mkdir $GRUPO/data

	#Agrega todos los scripts para la instalacion.
	cp ./bin/AFINSTAL.sh $GRUPO/bin/

	#Agrego el resto de los *.sh al direcorio /bin
	cp ./bin/GraLog.sh $GRUPO/bin/
	cp ./bin/MoverA.sh $GRUPO/bin/
	cp ./bin/ARRANCAR.sh $GRUPO/bin/
	cp ./bin/DETENER.sh $GRUPO/bin/
	cp ./bin/AFINI.sh $GRUPO/bin/
	cp ./bin/AFREC.sh $GRUPO/bin/
	cp ./bin/AFUMB.sh $GRUPO/bin/
	cp ./bin/AFLIST.pl $GRUPO/bin/

	#Agrego el archivo readme
	cp README.md $GRUPO/

	#Agrego los documentos maestros a /data
	cp -R master $GRUPO/

	#Agrego el resto de los documentos a /data
	cp -R data $GRUPO/

	#Crea archivo .zip
	zip -r $NOMBRE_PAQUETE_ZIP $GRUPO 	
	
	#Con AFRA-J.zip creado
	#Elimina todo el directorio AFRA-J
	rm -R $GRUPO 

	echo -e "Se creo el paquete de instalacion \n \t PATH: $PWD/$NOMBRE_PAQUETE_ZIP"
	
fi

#Eliminar archivo .zip

if [ "$1" == "-rm" ] 
then
	rm $NOMBRE_PAQUETE_ZIP
	
fi

if [ "$1" == "-mvHome" ]
then
	#mkdir $HOME/tmp
	unzip $NOMBRE_PAQUETE_ZIP
	mv $PAQUETE $HOME/tmp/
	rm $NOMBRE_PAQUETE_ZIP

fi



