#!/bin/bash

################################### GRALOG ##########################################
#                                                                                   #
# Parámetros:  (NOMBRE_COMANDO, TIPO_MENSAJE, MENSAJE)                              #
# 	                                                                            #
# NOMBRE_COMANDO: Nombre del comado que genera el MENSAJE                           #
# TIPO_MENSAJE: I = INFO; W = WARNING; E = ERROR; EF = ERROR FATAL                  #
# MENSAJE: Mensaje a guardar en el archivo de log.                                  #
#                                                                                   #
#################################################################################### 

#Función que verifica si el archivo supera el tamaño máximo

verificarSiArchivoExcedeLogsize (){

	arch_log=""

	#Almaceno los nombres de los archivos del directorio de logs en un archivo temporal
	ls -1 $DIRECTORIO_LOGS > "$DIRECTORIO_LOGS/nombres_archivos.tmp"

	arch_log=`grep "$NOMBRE_COMANDO.$EXTENSION_ARCH_LOG" "$DIRECTORIO_LOGS/nombres_archivos.tmp"`

	if [ "$arch_log"="$NOMBRE_COMANDO.$EXTENSION_ARCH_LOG" ]

	then
		cd $DIRECTORIO_LOGS
		cant_bytes=`wc -c $arch_log | cut -d' ' -f1` #Tomo la cantidad de bytes que ocupa

		if [ ${cant_bytes:-0} -ge $MAX_SIZE_LOG ]
		then
			#Grabo en el log que el tamaño fue excedido
			echo $NOMBRE_COMANDO.$EXTENSION_ARCH_LOG" - "`date '+%m-%d-%y %T'`" - "$NOMBRE_USUARIO" - "$NOMBRE_COMANDO" - I - Log excedido">>$DIRECTORIO_LOGS/"$NOMBRE_COMANDO."$EXTENSION_ARCH_LOG

			bytes_acum=0
			mitad_tamanio=0

			#Calculo el tamaño en bytes del archivo de log
			while read linea_archivo
			do
				#Acumulo los bytes que van sumando las líneas del archivo
				bytes_acum=$(($bytes_acum+`echo $linea_archivo | wc -c`))
			done < $DIRECTORIO_LOGS/"$NOMBRE_COMANDO."$EXTENSION_ARCH_LOG
	
			mitad_tamanio=$(($bytes_acum/2))

			bytes_eliminados=0

			#Elimino las líneas más antiguas que superen el 50% del tamaño permitido
			while read linea_archivo
			do
				if [ $bytes_eliminados -le $mitad_tamanio ]
				then	
					#Sumo bytes acumulados de las lineas que tengo que eliminar hasta llegar al 50% del total
					#Voy eliminando líneas hasta sumar el 50% del total
					bytes_eliminados=$(($bytes_eliminados+`echo $linea_archivo | wc -c`))
				else
					#Escribo la línea que persiste en un archivo temporal "temp.log"
					echo "$linea_archivo">>"$DIRECTORIO_LOGS/temp.log"
				fi #[ $bytes_eliminados -le $mitad_tamanio ]
			done < $DIRECTORIO_LOGS/"$NOMBRE_COMANDO."$EXTENSION_ARCH_LOG


			#Renombro el archivo temporal "temp.log" para que se llame como lo solicitó el usuario
			rm $DIRECTORIO_LOGS/"$NOMBRE_COMANDO."$EXTENSION_ARCH_LOG
			mv $DIRECTORIO_LOGS/"temp.log" $DIRECTORIO_LOGS/"$NOMBRE_COMANDO."$EXTENSION_ARCH_LOG

		fi #[ ${cant_bytes:-0} -ge $MAX_SIZE_LOG]
	
	fi # [ "$arch_log"="$NOMBRE_COMANDO.$EXTENSION_ARCH_LOG" ]

	rm "$DIRECTORIO_LOGS/nombres_archivos.tmp" #se borrarn archivos temporales

} #Fin verificarSiArchivoExcedeLogsize ()

function GraLog {
	####Principal#####
	NOMBRE_USUARIO=$USER
	NOMBRE_COMANDO=""
	MENSAJE=""
	TIPO_MENSAJE="I"


	#Verifico la cantidad de parámetros
	if [ $# != 3 ]
	then
		echo "Parámetros inválidos"
		exit 1
	fi #[ $# != 3 ]


	#Obtengo los parámetros

	#Nombre del comando
	NOMBRE_COMANDO="$1"

	#Tipo de MENSAJE #de minusculas a mayusculas
	tipo="`echo $2 | tr "[:lower:]" "[:upper:]"`"

	if [ "$tipo" = "INFO" -o "$tipo" = "WAR" -o "$tipo" = "ERR" -o "$tipo" = "EF" ]
	then
		TIPO_MENSAJE="$tipo"
	else
		echo "Parámetro 2 inválido"
		exit 1
	fi

	#Mensaje
	MENSAJE="$3"

	# Valido que el directorio de logs sea una ruta válida (no vacía)
	if [ -z "$LOGDIR" ]
	then
		echo "El directorio especificado para almacenar los archivos de log no existe."
		echo "No será posible generar el archivo de log."
		exit 2
	fi

	# Valido que no sea vacía la cantidad de KB que pueden ocupar los archivos de log
	if [ -z "$LOGSIZE" ]
	then
		echo "El tamaño especificado para los archivos de log es nulo."
		echo "No será posible generar el archivo de log."
		exit 2
	fi

	DIRECTORIO_LOGS="$LOGDIR" #Obtengo el directorio en donde se almacenan los logs
	EXTENSION_ARCH_LOG="$LOGEXT" #Obtengo la extensión del archivo de log (sin .)
	MAX_SIZE_LOG=$(($LOGSIZE * 1024)) #Obtengo el máximo tamaño que puede ocupar un archivo de log (en bytes)

	#Verifico si existe el directorio de los archivos de log
	if [ ! -d "$DIRECTORIO_LOGS" ]
	then
		#Creo el directorio
		mkdir -p "$DIRECTORIO_LOGS"
	fi
	
	#Verifico si existe el archivo de log
	existe_log=`ls $DIRECTORIO_LOGS | grep "$NOMBRE_COMANDO.$EXTENSION_ARCH_LOG"`
	if [ -z $existe_log ]
	then
		#Creo el archivo de log
		>"$DIRECTORIO_LOGS/$NOMBRE_COMANDO.$EXTENSION_ARCH_LOG"
	fi

	#Guardo el MENSAJE en el log	
	echo $NOMBRE_COMANDO.$EXTENSION_ARCH_LOG" - "`date '+%m-%d-%y %T'`" - "$NOMBRE_USUARIO" - "$NOMBRE_COMANDO" - "$TIPO_MENSAJE" - "$MENSAJE>>$DIRECTORIO_LOGS/"$NOMBRE_COMANDO."$EXTENSION_ARCH_LOG
	
	verificarSiArchivoExcedeLogsize

}


