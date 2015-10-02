#!/bin/bash

#
# Crea el paquete de instalacion para el sistema AFRA-J
# Contenido del paquete .zip:
#	-README.md
#	-Documentos del sistema
#	-Arbol de directorio inicial
#


# Crea archivo .zip (paquete a descargar por el usuario)
# Directorio:
#
#├── AFRA-J
#│   ├── AFINSTALL.sh
#│   ├── bin
#│   │   ├── AFINI.sh
#│   │   ├── AFREC.sh
#│   │   ├── GraLog.sh
#│   │   ├── movera_old.sh
#│   │   └── MoverA.sh
#│   ├── conf
#│   │   ├── AFINSTAL.cnfg
#│   │   └── AFINSTAL.lg
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
	cp AFINSTALL.sh $GRUPO/
	#Agrego el resto de los *.sh al direcorio /bin	

	cp AFINI.sh $GRUPO/bin/
	cp AFREC.sh $GRUPO/bin/
	cp GraLog.sh $GRUPO/bin/
	cp MoverA.sh $GRUPO/bin/


	#Agrego el archivo readme
	cp README.md $GRUPO/

	#Agrego el resto de los documentos a /data
	cp -R data $GRUPO/

	
	#Agrego arhivos de configuracion en /conf
	> $GRUPO/conf/AFINSTAL.cnfg
	> $GRUPO/conf/AFINSTAL.lg


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














