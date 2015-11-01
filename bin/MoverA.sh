#!/bin/bash
#Notas generales
#Para obtener las funciones en el ambiente "source MoverA.sh" y despues para usar la funcion "MoverA origen destino [comandollamador]"
#si hay que distinguir los pipes y cosas asi que no son files realmente, cambiar los -e por -f

#Return values
#1: funcion mal llamada
#2: origen = destino
#3: origen no existe
#4: destino no existe

#definimos la variable contador en cero si es que no esta ya definida
if [ -z "$contador" ]
then
	contador=0
fi

#incorporamos las posibilidades de logear
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/GraLog.sh

function MoverA {
	origen=$1
	destino=$2
	dir_destino=${destino%/*}
	filename_destino=${destino##*/}
	llamador=$3
	copiar=$4
	#limpio e imprimo variables, mas amigable
	#clear
	#echo
	#echo "--------------------------------"
	#echo "Parametros"
	#echo "Origen: " $1
	#echo "Destino: " $2
	#echo "El directorio destino seria: " $dir_destino
	#echo "El filename destino seria: " $filename_destino
	#echo "Llamado por: " $3
	#echo

	#chequeo que hayan llamado bien a la funcion
	if [[ "$origen" == "" ]] || [[ "$destino" == "" ]]
	then
		GraLog $llamador ERR "MoverA: Parametros incorrectos. Origen: \"$origen\". Destino: \"$destino\"."
		return 1
	fi

	#chequeo si el origen y el destino son iguales
	if [[ "$origen" == "$destino" ]]
	then
		GraLog $llamador ERR "MoverA: Origen y destino son iguales. Origen: \"$origen\". Destino: \"$destino\"."
		return 2
	fi

	#chequeo si el file origen existe
	if [ ! -e "$origen" ]
	then
		GraLog $llamador ERR "MoverA: No existe file origen. File: \"$origen\"."
		return 3
	fi

	#chequeo que exista el directorio destino
	if [ ! -e "$dir_destino" ]
	then
		GraLog $llamador ERR "MoverA: No existe directorio destino. Directorio: \"$dir_destino\"."
		return 4
	fi

	#chequeo si el file destino ya existe
	if [ ! -e "$destino" ]
	then
		if [ "$copiar" == "copiar" ]
		then
			GraLog $llamador INFO "MoverA: Copiado $origen a $destino con exito"
			cp "$origen" "$destino"
		else
			GraLog $llamador INFO "MoverA: Movido $origen a $destino con exito"
			mv "$origen" "$destino"
		fi
	else
		GraLog $llamador INFO "MoverA: File duplicado, redirigido"
		mkdir -p "${dir_destino}/duplicados"
		if [ ! -e "${dir_destino}/duplicados/${filename_destino}" ]
		then
			if [ "$copiar" == "copiar" ]
			then
				cp "$origen" "${dir_destino}/duplicados/${filename_destino}"
			else
				mv "$origen" "${dir_destino}/duplicados/${filename_destino}"
			fi
		else
			contador=`expr $contador + 1`
			if [ "$copiar" == "copiar" ]
			then
				cp "$origen" "${dir_destino}/duplicados/${filename_destino}.${contador}"
			else
				mv "$origen" "${dir_destino}/duplicados/${filename_destino}.${contador}"
			fi
		fi
	fi
}  
