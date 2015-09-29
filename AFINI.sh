#!/bin/bash

#retorno de valores
# 0: Inicialización OK
# 1: No existe archivo de configuración (AFINSTAL.cnfg)
# 2: El archivo de configuración AFINSTAL.cnfg no tiene permisos de lectura
# 3: El usuario cierra la sesión
# 4: El usuario continúa la sesión
function inicializarAmbiente {

	# CASO 1 : AMBIENTE NO INICIALIZADO
	if [ -z $fueInicializado ]; then
		# Si no existe el archivo de configuración, volver a instalar
		if [ ! -f "conf/AFINSTAL.cnfg" ]; then
			echo "No se encontro archivo de configuración AFINSTAL.cnfg"
			echo "Volvel a instalar"
			# Agregar lo del GraLog : No se encontró archivo de configuración
			return 1
		else
			# Si existe, verificar permisos de lectura
			if [ ! -r "conf/AFINSTAL.cnfg" ]; then
				chmod +r "conf/AFINSTAL.cnfg"
				if [ ! -r "conf/AFINSTAL.cnfg" ]; then
					echo "El archivo AFINSTAL.cnfg no tiene permisos de lectura."
					# Agregar lo del GraLog : El archivo de configuración no tiene permisos de lectura
					return 2
				fi
			fi
		fi

		echo "Inicializando variables de ambiente..."
		IFS=$'\n'
		# Seteo de variables de ambiente
		for linea in $(< "conf/AFINSTAL.cnfg")
		do
			nombre_var=`echo $linea | cut -d "=" -f1`
			valor=`echo $linea | cut -d "=" -f2`
			export $nombre_var=$valor

			if [ "$nombre_var" == "BINDIR" ]; then
				PATH="$PATH:$valor"	
			fi	
		done

		export fueInicializado=true
		sleep 1
		echo "Ambiente Inicializado : OK"
		# Agregar GraLog : Inicialización de ambiente correctamente

	# CASO 2 : AMBIENTE INICIALIZADO
	else
		echo "Ambiente ya inicializado."
		echo "Para reiniciar, termine la sesión e ingrese nuevamente."
		# Agregar GraLog : Se quiere inicializar ambiente ya inicializado
		echo "¿Desea terminar la sesión? (s-n)"
		read terminar

		if [ $terminar == 's' ]; then
			echo "Cerrando Sesión"
			# Agregar GraLog : Usuario cierra sesión
			return 3
		else
			if [ $terminar == 'n' ]; then
				echo "Continua con la sesión"
				return 4
			else	
				echo "Opción ingresada inválida. Intente nuevamente"
				inicializarAmbiente # Llamada recursiva
			fi
		fi
	fi

	return 0
}

#retorno de valores
# 0: Instalación Completa
# 1: Faltante de Archivos (Scripts, Maestros, Tablas, etc.)
function instalacionCompleta {
	todoOk=0
	echo "Verificando Scripts..."
	sleep 1
	existenScripts
	ret=$?
	if [ $ret -gt 0 ]; then
		todoOk=1
	fi
	echo "Verificando Maestros y Tablas..."
	sleep 1
	existenMaestrosYTablas
	ret=$?
	if [ $ret -gt 0 ]; then
		todoOk=1
	fi

	if [ $todoOk -eq 1 ]; then
		echo "Instalación Incompleta. Por favor, vuelta a realizar la instalación e intente nuevamente."
		# GraLog
		return 1
	fi
	
	return 0
}

#retorno de valores
# 0: Existen todos los scripts correspondientes
# 1: Faltante de algún script
function existenScripts {
	return 0	
}

#retorno de valores
# 0: Todos los archivos existen
# 1: Si falta algún archivo (Maestro o Tabla)
function existenMaestrosYTablas {
	todoOk=0
	# chequeo si existe archivo Maestro de Código de País
	if [ ! -f "$MAEDIR/CdP.mae" ]; then
		todoOk=1
		echo " Archivo Maestro de Código de País: NO ENCONTRADO"
		# GraLog
	fi

	# chequeo si existe archivo Maestro de Código de Area de Argentina
	if [ ! -f "$MAEDIR/CdA.mae" ]; then
		todoOk=1
		echo " Archivo Maestro de Código de Area de Argentina: NO ENCONTRADO"
		# GraLog
	fi

	# chequeo si existe archivo Maestro de Centrales
	if [ ! -f "$MAEDIR/CdC.mae" ]; then
		todoOk=1
		echo " Archivo Maestro de Código de Centrales: NO ENCONTRADO"
		# GraLog
	fi

	# chequeo si existe archivo Maestro de Agentes
	if [ ! -f "$MAEDIR/agentes.mae" ]; then
		todoOk=1
		echo " Archivo Maestro de Código de Agentes: NO ENCONTRADO"
		# GraLog
	fi

	# chequeo si existe tabla de Tipos de Llamadas
	if [ ! -f "$MAEDIR/tllama.tab" ]; then
		todoOk=1
		echo " Tabla de llamadas: NO ENCONTRADO"
		# GraLog
	fi

	# chequeo si existe tabla de Umbrales de Consumo
	if [ ! -f "$MAEDIR/umbral.tab" ]; then
		todoOk=1
		echo " Tabla de Umbrales de Consumo: NO ENCONTRADO"
		# GraLog
	fi

	return $todoOk
}

# recibe como parametro un directorio y lista todos los archivos que se encuentran en él
function listarArchivosDir {
	dir=$1
	if [ -d $dir ]; then
		cd $dir
		for file in *
		do
			if [ -f $file ]; then
				echo "  $file"
			fi
		done
	fi	
}


function verificarPermisos {
	echo "Verificando permisos..."
	sleep 1
	return 0
}

# Mostrar y grabar en el log las variables y contenidos
# si todo salió bien, retorna 0
function mostrarYgrabar {
	echo "Grabando variables y contenidos en log..."
	sleep 1
	echo

	echo "Directorio de Configuración: $CONFDIR"
	sleep 1
	listarArchivosDir $CONFDIR
	#Grabar en el log
	echo

	echo "Directorio de Ejecutables: $BINDIR"
	sleep 1
	listarArchivosDir $BINDIR
	#Grabar en el log
	echo

	echo "Directorio de Maestros y Tablas: $MAEDIR"
	sleep 1
	listarArchivosDir $MAEDIR
	#Grabar en el log
	echo

	echo "Directorio de recepción de archivos de llamadas: $NOVEDIR"
	sleep 1
	listarArchivosDir $NOVEDIR
	#Grabar en el log
	echo

	echo "Directorio de Archivos de llamadas Aceptadas: $ACEPDIR"
	sleep 1
	listarArchivosDir $ACEPDIR
	#Grabar en el log
	echo

	echo "Directorio de Archivos de llamadas Sospechosas: $PROCDIR"
	sleep 1
	listarArchivosDir $PROCDIR
	#Grabar en el log
	echo

	echo "Directorio de Archivos de Reportes de llamadas: $REPODIR"
	sleep 1
	listarArchivosDir $REPODIR
	#Grabar en el log
	echo
	
	echo "Directorio de Archivos de Log: $LOGDIR"
	sleep 1
	listarArchivosDir $LOGDIR
	#Grabar en el log
	echo
	
	echo "Directorio de Archivos Rechazados: $RECHDIR"
	sleep 1
	listarArchivosDir $RECHDIR
	#Grabar en el log
	echo

	echo "Estado del Sistema: INICIALIZADO"
	#Grabar en el log : OK
	sleep 1

	return 0
}


function arrancarAFREC {
	echo "¿Desea efectuar la activación de AFREC? (s-n):"
	read arrancar
	if [ $arrancar == 's' ]; then
		if [ -z $afrecActivado ]; then
			export afrecActivado=true
			echo "Iniciando AFREC..."
			sleep 1
			echo "AFREC corriendo bajo el no.: <Process Id de AFREC>"
			# llamar a AFREC
			exit
		else
			echo "WARNING: Ya hay un proceso AFREC corriendo."
			# GraLog
			exit
		fi
	else
		if [ $arrancar == 'n' ]; then
			echo "El Usuario no desea arrancar AFREC."
			echo "Si desea arrancar AFREC, en otro momento, ejecute el siguiente comando: <comando_AFREC> "
			exit
		else
			echo "Opción ingresada inválida. Intente nuevamente (s-n)."
			arrancarAFREC
		fi
	fi
}

# PROGRAMA PRINCIPAL DE AFINI
inicializarAmbiente
ret=$? 
# Si el valor de retorno es cero, estado de inicialización: OK
if [ $ret -eq 0 ]; then  
	echo
	instalacionCompleta
	ret=$?
	# Si el valor de retorno es cero, instalación: OK
	if [ $ret -eq 0 ]; then
		echo
		verificarPermisos
		ret=$?
		# Si el valor de retorno es cero, los permisos de los archivos de lectura y ejecución
		# estan seteados correctamente
		if [ $ret -eq 0 ]; then
			echo
			mostrarYgrabar
			ret=$?
			if [ $ret -eq 0 ]; then
				echo
				arrancarAFREC
			fi
		fi
	fi	
fi