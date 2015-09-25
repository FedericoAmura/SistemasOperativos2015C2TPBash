#!/bin/bash

#retorno de valores
# 0: Inicialización OK
# 1: No existe archivo de configuración (AFINSTAL.cnfg)
# 2: El archivo de configuración AFINSTAL.cnfg no tiene permisos de lectura
# 3: El usuario continúa la sesión
function inicializarAmbiente {

	# CASO 1 : AMBIENTE NO INICIALIZADO
	if [ -z $fueInicializado ]; then
		# Si no existe el archivo de configuración, volver a instalar
		if [ ! -f "CONFDIR/AFINSTAL.cnfg" ]; then
			echo "No se encontro archivo de configuración AFINSTAL.cnfg"
			echo "Volvel a instalar"
			# Agregar lo del GraLog : No se encontró archivo de configuración
			return 1
		else
			# Si existe, verificar permisos de lectura
			if [ ! -r "CONFDIR/AFINSTAL.cnfg" ]; then
				# Seteo de permisos de lectura
				chmod +r "CONFDIR/AFINSTAL.cnfg"
				if [ ! -r "CONFDIR/AFINSTAL.cnfg" ]; then
					echo "El archivo AFINSTAL.cnfg no tiene permisos de lectura."
					# Agregar lo del GraLog : El archivo de configuración no tiene permisos de lectura
					return 2
				fi
			fi
		fi

		echo "Inicializando variables de ambiente"
		oldIFS=$IFS #Guarda el separador anterior
		IFS=$'\n'
		# Seteo de variables de ambiente
		for linea in $(< "CONFDIR/AFINSTAL.cnfg")
		do
			nombre_var=`echo $linea | cut -d "=" -f1`
			valor=`echo $linea | cut -d "=" -f2`
			export $nombre_var=$valor

			if [ "$nombre_var" == "BINDIR" ]; then
				PATH="$PATH:$valor"	
			fi	
		done

		export fueInicializado=true
		echo "Ambiente Inicializado : OK"
		# Agregar GraLog : Inicialización de ambiente correctamente

	# CASO 2 : AMBIENTE INICIALIZADO
	else
		echo "Ambiente ya inicializado."
		echo "Para reiniciar, termine la sesión e ingrese nuevamente."
		# Agregar GraLog : Se quiere inicializar ambiente ya inicializado
		echo "¿Desea terminar la sesión? (s-n)"
		read terminarSesion

		if [ $terminarSesion == 's' ]; then
			echo "Cerrando Sesión"
			# Agregar GraLog : Usuario cierra sesión
			exit
		else
			if [ $terminarSesion == 'n' ]; then
				echo "Continua con la sesión"
				return 3
			else	
				echo "Opción ingresada inválida. Intente nuevamente"
				inicializarAmbiente # Llamada recursiva
			fi
		fi
	fi

	return 0
}

#retorno de valores
# 0: Si falta algun archivo (Maestro o Tabla)
# 1: Todos los archivos exintes
function existenMaestrosYTablas {
	# chequeo si existe archivo Maestro de Codigo de Pais
	if [ ! -f "$MAEDIR/CdP.mae" ]; then
		return 0
	fi

	# chequeo si existe archivo Maestro de Codigo de Area de Argentina
	if [ ! -f "$MAEDIR/CdA.mae" ]; then
		return 0
	fi

	# chequeo si existe archivo Maestro de Centrales
	if [ ! -f "$MAEDIR/CdC.mae" ]; then
		return 0
	fi

	# chequeo si existe archivo Maestro de Agentes
	if [ ! -f "$MAEDIR/agentes.mae" ]; then
		return 0
	fi

	# chequeo si existe tabla de Tipos de Llamadas
	if [ ! -f "$MAEDIR/tllama.tab" ]; then
		return 0
	fi

	# chequeo si existe tabla de Umbrales de Consumo
	if [ ! -f "$MAEDIR/umbral.tab" ]; then
		return 0
	fi

	return 1
}

inicializarAmbiente;
inicializarAmbiente;
#existenMaestrosYTablas;