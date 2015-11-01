#!/bin/bash

#
# Crea el paquete de instalacion para el sistema AFRA-J
# Contenido del paquete .zip:
#	-README.md
#	-Documentos del sistema
#	-Arbol de directorio inicial
#

#  AL EXTRAER EL PAQUETE PARA LA INSTALACION
# =============================================================================================

# Crea el siguiente arbol de directorio:
	#├── AFRA-J
	#│   ├── AFINI.sh
	#│   ├── AFINSTAL.sh
	#│   ├── AFLIST.pl
	#│   ├── AFREC.sh
	#│   ├── AFUMB.sh
	#│   ├── ARRANCAR.sh
	#│   ├── DETENER.sh
	#│   ├── GraLog.sh
	#│   ├── MoverA.sh
	#│   └── README.md
	#│   ├── conf  #INFO: este path el usuario no lo puede modificar
	#│   ├── data  #INFO: todos los archivos que luego de la instalacion, se mueven a $MAEDIR, $NOVEDIR, etc.
	#│   │   ├── archivoDeLlamadasSospechosas
	#│   │   ├── BEL_20150703
	#│   │   ├── BEL_20150803
	#│   │   ├── co_central.rech
	#│   │   ├── COS_20150703
	#│   │   ├── COS_20150803
	#│   │   ├── SIS_20150703.csv
	#│   │   └── SIS_20150803.csv
	
# INICIO SCRIPT
# =====================================================================================

#Set Name
NOMBRE_PAQUETE_ZIP="AFRA-J.zip"

#Variable de entorno para usar en AFINSTAL.sh 
GRUPO="AFRA-J"

#Set Archivos

if [ "$1" == "-pack" ]
then
	
	#Carpeta par contener el paquete y arbol de directorio por defecto.
	mkdir $GRUPO
	mkdir $GRUPO/source
	mkdir $GRUPO/conf
	

	#Agrega todos los scripts para la instalacion.
	cp ./bin/AFINSTAL.sh $GRUPO/

	#Agrego el resto de los *.sh $GRUPO/
	cp ./bin/AFINI.sh $GRUPO/source/
	cp ./bin/AFINSTAL.sh $GRUPO/source/
	cp ./bin/AFREC.sh $GRUPO/source/
	cp ./bin/AFUMB.sh $GRUPO/source/
	cp ./bin/ARRANCAR.sh $GRUPO/source/
	cp ./bin/DETENER.sh $GRUPO/source/
	cp ./bin/GraLog.sh $GRUPO/source/
	cp ./bin/MoverA.sh $GRUPO/source/

	# Archivos .pl
	cp ./bin/AFLIST.pl $GRUPO/source/

	#Agrego el archivo readme
	cp README.md $GRUPO/

	# Copio toda la carpeta data
	cp ./data/agentes.csv $GRUPO/source/
	cp ./data/CdA.csv $GRUPO/source/
	cp ./data/CdP.csv $GRUPO/source/
	cp ./data/centrales.csv $GRUPO/source/
	cp ./data/tllama.tab $GRUPO/source/
	cp ./data/umbrales.csv $GRUPO/source/

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
