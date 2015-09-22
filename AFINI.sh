#!/bin/bash

#retorno de valores
#0: Si falta algun archivo (Maestro o Tabla)
#1: Todos los archivos exintes

function existenMaestrosYTablas {
	# chequeo si existe archivo Maestro de Codigo de Pais
	if [ ! [-f $MAEDIR/CdP.mae ]]
	then
		return 0
	fi

	# chequeo si existe archivo Maestro de Codigo de Area de Argentina
	if [ ! [-f $MAEDIR/CdA.mae ]]
	then
		return 0
	fi

	# chequeo si existe archivo Maestro de Centrales
	if [ ! [-f $MAEDIR/CdC.mae ]]
	then
		return 0
	fi

	# chequeo si existe archivo Maestro de Agentes
	if [ ! [-f $MAEDIR/agentes.mae ]] 
	then
		return 0
	fi

	# chequeo si existe tabla de Tipos de Llamadas
	if [ ! [-f $MAEDIR/tllama.tab ]] 
	then
		return 0
	fi

	# chequeo si existe tabla de Umbrales de Consumo
	if [ ! [-f $MAEDIR/umbral.tab ]]
	then
		return 0
	fi

	return 1
}