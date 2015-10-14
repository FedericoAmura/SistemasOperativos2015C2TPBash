#!/bin/bash

#MoverA [archivo] [destino] [comando](opcional)
echo Inicio movera

#Inicializacion de variables
#origen=$1
#destino=$2
#comando=$3

origen=./carpeta_origen/prueba.txt
destino=./carpeta_destino


#Origen es igual al Destino.
if [ "$destino" = "$origen" ]
 then
 echo El origen y el destino son iguales
fi 

#Origen no existe
if [ ! -f "$origen" ]
 then
 echo El origen no existe
fi

#Destino no existe
if [ ! -d "$destino"  ]
 then
 echo El destino no existe
fi


mv "$origen" "$destino"




echo Fin movera
