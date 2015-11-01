#!/bin/bash

source GraLog.sh

# valores de retorno
# 0: Inicialización OK
# 1: No existe archivo de configuración (AFINSTAL.cnfg)
# 2: El archivo de configuración AFINSTAL.cnfg no tiene permisos de lectura
# 3: Ambiente ya fue inicializado
function inicializarAmbiente {

	# CASO 1 : AMBIENTE NO INICIALIZADO
	if [ -z $ambienteInicializado ]; then
		# Si no existe el archivo de configuración, volver a instalar
		if [ ! -f "conf/AFINSTAL.cnfg" ]; then
			echo "No se encontro archivo de configuración AFINSTAL.cnfg"
			echo "Vuelva a realizar la instalación"
			GraLog AFINI EF "No se encontró el archivo de configuración."
			return 1
		else
			# Si existe, verificar permisos de lectura
			if [ ! -r "conf/AFINSTAL.cnfg" ]; then
				chmod +r "conf/AFINSTAL.cnfg"
				if [ ! -r "conf/AFINSTAL.cnfg" ]; then
					echo "El archivo AFINSTAL.cnfg no tiene permisos de lectura."
					GraLog AFINI ERR "El archivo de configuración no tiene permisos de lectura."
					return 2
				fi
			fi
		fi

		echo "Inicializando variables de ambiente..."
		oldIFS=$IFS
		IFS=$'\n'
		# Seteo de variables de ambiente
		for linea in $(< "conf/AFINSTAL.cnfg")
		do
			nombre_var=$(echo $linea | cut -d "=" -f1)
			valor=$(echo $linea | cut -d "=" -f2)
			export $nombre_var=$valor
		done
		IFS=$oldIFS
		export ambienteInicializado=1
		export PATH="$PATH:$BINDIR"
		sleep 1
		echo "Ambiente Inicializado : OK"
		GraLog AFINI INFO "El ambiente ha sido inicializado correctamente."

	# CASO 2 : AMBIENTE INICIALIZADO
	else
		echo "Ambiente ya fue inicializado."
		echo "Para reiniciar, termine la sesión e ingrese nuevamente."
		GraLog AFINI WAR "Se quiere inicializar ambiente ya inicializado."
		# Si el usuario desea arrancar el demonio
		#arrancarAFREC
		echo "Para inicialiar el demonio ejecute el comando $./ARRANCAR.sh &"
		return 3
	fi

	return 0
}

function eliminarVariablesAmbiente() {
	unset CONFDIR
	unset MAEDIR
	unset BINDIR
	unset NOVEDIR
	unset ACEPDIR
	unset CONFDIR
	unset GRUPO
	unset REPODIR
	unset RECHDIR
	unset DATASIZE
	unset PROCDIR
	unset LOGDIR
	unset LOGSIZE
	unset ambienteInicializado
	PATH=$(echo $PATH | sed 's-^\(.*\):.*$-\1-g')
}

# valores de retorno
# 0: Instalación Completa
# 1: Faltante de Archivos (Scripts, Maestros, Tablas, etc.)
function instalacionCompleta {
	instalacionOk=0
	echo "Verificando Scripts..."
	sleep 1
	existenScripts
	ret=$?
	if [ $ret -ne 0 ]; then
		instalacionOk=1
	fi
	echo "Verificando Maestros y Tablas..."
	sleep 1
	existenMaestrosYTablas
	ret=$?
	if [ $ret -ne 0 ]; then
		instalacionOk=1
	fi

	if [ $instalacionOk -ne 0 ]; then
		echo "Instalación Incompleta. Por favor, vuelta a realizar la instalación e intente nuevamente."
		GraLog AFINI EF "Instalación incompleta."
		return 1
	fi

	return 0
}

# valores de retorno
# 0: Existen todos los scripts correspondientes
# 1: Faltante de algún script
function existenScripts {
	todoOk=0
	# chequeo si existe archivo ejecutable MoverA.sh
	if [ ! -f "$BINDIR/MoverA.sh" ]; then
		todoOk=1
		echo " Archivo Ejecutable MoverA: NO ENCONTRADO"
		GraLog AFINI EF "No se encontró el archivo ejecutable MoverA."
	fi

	# chequeo si existe archivo ejecutable AFREC.sh
	if [ ! -f "$BINDIR/AFREC.sh" ]; then
		todoOk=1
		echo " Archivo Ejecutable AFREC: NO ENCONTRADO"
		GraLog AFINI EF "No se encontró el archivo ejecutable AFREC."
	fi

	# chequeo si existe archivo ejecutable ARRANCAR.sh
	if [ ! -f "$BINDIR/ARRANCAR.sh" ]; then
		todoOk=1
		echo " Archivo Ejecutable ARRANCAR: NO ENCONTRADO"
		GraLog AFINI EF "No se encontró el archivo ejecutable ARRANCAR."
	fi	

		# chequeo si existe archivo ejecutable ARRANCAR.sh
	if [ ! -f "$BINDIR/AFUMB.sh" ]; then
		todoOk=1
		echo " Archivo Ejecutable ARRANCAR: NO ENCONTRADO"
		GraLog AFINI EF "No se encontró el archivo ejecutable ARRANCAR."
	fi		

    # chequeo si existe archivo ejecutable DETENER.sh
    if [ ! -f "$BINDIR/DETENER.sh" ]; then
        todoOk=1
        echo " Archivo Ejecutable DETENER: NO ENCONTRADO"
        GraLog AFINI EF "No se encontró el archivo ejecutable DETENER."
    fi

        # chequeo si existe archivo ejecutable DETENER.sh
    if [ ! -f "$BINDIR/GraLog.sh" ]; then
        todoOk=1
        echo " Archivo Ejecutable GraLog: NO ENCONTRADO"
        GraLog AFINI EF "No se encontró el archivo ejecutable GraLog."
    fi

    # chequeo si existe archivo ejecutable AFLIST.pl
    if [ ! -f "$BINDIR/AFLIST.pl" ]; then
        todoOk=1
        echo " Archivo Ejecutable AFLIST: NO ENCONTRADO"
        GraLog AFINI EF "No se encontró el archivo ejecutable AFLIST."
    fi

	# Agregar los ejecutables que falten
	return $todoOk	
}

# valores de retorno
# 0: Todos los archivos existen
# 1: Si falta algún archivo (Maestro o Tabla)
function existenMaestrosYTablas {
	todoOk=0
	# chequeo si existe archivo Maestro de Código de País
	if [ ! -f "$MAEDIR/CdP.csv" ]; then
		todoOk=1
		echo " Archivo Maestro de Código de País: NO ENCONTRADO"
		GraLog AFINI EF "No se encontró el archivo maestro CdP."
	fi

	# chequeo si existe archivo Maestro de Código de Area de Argentina
	if [ ! -f "$MAEDIR/CdA.csv" ]; then
		todoOk=1
		echo " Archivo Maestro de Código de Area de Argentina: NO ENCONTRADO"
		GraLog AFINI EF "No se encontró el archivo maestro CdA."
	fi

	# chequeo si existe archivo Maestro de Centrales
	if [ ! -f "$MAEDIR/centrales.csv" ]; then
		todoOk=1
		echo " Archivo Maestro de Código de Centrales: NO ENCONTRADO"
		GraLog AFINI EF "No se encontró el archivo maestro CdC."
	fi

	# chequeo si existe archivo Maestro de Agentes
	if [ ! -f "$MAEDIR/agentes.csv" ]; then
		todoOk=1
		echo " Archivo Maestro de Código de Agentes: NO ENCONTRADO"
		GraLog AFINI EF "No se encontró el archivo maestro agentes."
	fi

	# chequeo si existe tabla de Tipos de Llamadas
	if [ ! -f "$MAEDIR/tllama.tab" ]; then
		todoOk=1
		echo " Tabla de llamadas: NO ENCONTRADO"
		GraLog AFINI EF "No se encontró el archivo maestro tllama.tab ."
	fi

	# chequeo si existe tabla de Umbrales de Consumo
	if [ ! -f "$MAEDIR/umbrales.csv" ]; then
		todoOk=1
		echo " Tabla de Umbrales de Consumo: NO ENCONTRADO"
		GraLog AFINI EF "No se encontró el archivo maestro umbral.tab ."
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
				echo " $file"
			fi
		done
		cd ..
	fi	
}

# valores de retorno
# 0: Todos los archivos tienen los permisos seteados correctamente
# 1: Exiten archivos que no están seteados correctamente
function verificarPermisos {
	ok=0
	echo "Verificando permisos..."
	sleep 1
	dir=$MAEDIR
	cd $dir
	echo "Verificando permisos de archivos maestros..."
	sleep 1
	for file in *
	do
		if [ ! -r $file ]; then
			chmod +r $file
			if [ ! -r $file ]; then
				ok=1
				echo "No se pudo setear correctamente los permisos de lectura del archivo $file"
				GraLog AFINI ERR "El archivo $file no tiene permisos de lectura."
			fi	
		fi
	done
	cd ..
	
	dir=$BINDIR
	cd $dir
	echo "Verificando permisos de archivos ejecutables..."
	sleep 1
	for file in *
	do
		if [ ! -x $file ]; then
			chmod +x $file
			if [ ! -x $file ]; then
				ok=1
				echo "No se pudo setear correctamente los permisos de ejecución del archivo $file"
				GraLog AFINI ERR "El archivo $file no tiene permisos de ejecución."
			fi	
		fi
	done 
	cd ..	

	if [ $ok -eq 1 ];then
		echo "No puede continuar sin los permisos adecuados de los archivos necesarios."
		return 1
	fi

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
	GraLog AFINI INFO "CONFDIR = $CONFDIR"
	#Grabar en el log
	echo

	echo "Directorio de Ejecutables: $BINDIR"
	sleep 1
	listarArchivosDir $BINDIR
	GraLog AFINI INFO "BINDIR = $BINDIR"
	#Grabar en el log
	echo

	echo "Directorio de Maestros y Tablas: $MAEDIR"
	sleep 1
	listarArchivosDir $MAEDIR
	GraLog AFINI INFO "MAEDIR = $MAEDIR"
	#Grabar en el log
	echo

	echo "Directorio de recepción de archivos de llamadas: $NOVEDIR"
	sleep 1
	listarArchivosDir $NOVEDIR
	GraLog AFINI INFO "NOVEDIR = $NOVEDIR"
	#Grabar en el log
	echo

	echo "Directorio de Archivos de llamadas Aceptadas: $ACEPDIR"
	sleep 1
	listarArchivosDir $ACEPDIR
	GraLog AFINI INFO "ACEPDIR = $ACEPDIR"
	#Grabar en el log
	echo

	echo "Directorio de Archivos de llamadas Sospechosas: $PROCDIR"
	sleep 1
	listarArchivosDir $PROCDIR
	GraLog AFINI INFO "PROCDIR = $PROCDIR"
	#Grabar en el log
	echo

	echo "Directorio de Archivos de Reportes de llamadas: $REPODIR"
	sleep 1
	listarArchivosDir $REPODIR
	GraLog AFINI INFO "REPODIR = $REPODIR"
	#Grabar en el log
	echo
	
	echo "Directorio de Archivos de Log: $LOGDIR"
	sleep 1
	listarArchivosDir $LOGDIR
	GraLog AFINI INFO "LOGDIR = $LOGDIR"
	#Grabar en el log
	echo
	
	echo "Directorio de Archivos Rechazados: $RECHDIR"
	sleep 1
	listarArchivosDir $RECHDIR
	GraLog AFINI INFO "RECHDIR = $RECHDIR"
	#Grabar en el log
	echo

	echo "Estado del Sistema: INICIALIZADO"
	GraLog AFINI INFO "Grabación de variables correctamente."
	#Grabar en el log : OK
	sleep 1

	return 0
}


function arrancarAFREC {
	cd $BINDIR
	printf "¿Desea efectuar la activación de AFREC? (si-no): "
	read arrancar
	if [ $arrancar == 'si' ]; then
    	ARRANCAR_PID=`ps -ef |grep bash |grep "./ARRANCAR.sh" |grep -v $$ |grep -v "grep"|awk '{print($2)}'`
		if [ -z $ARRANCAR_PID  ]; then
			export afrecActivado=1
			echo "Iniciando AFREC..."
			GraLog AFINI INFO "El usuario $USER inició AFREC."
			sleep 1
			
			./ARRANCAR.sh &
			echo "ARRANCAR.sh corriendo bajo el PID=$! - PPID=$$"
			GraLog AFINI WAR "Se ha invocado ARRANCAR.sh PID=$!."
			return 0
		else
			echo "WARNING: Ya hay un proceso AFREC corriendo."
			GraLog AFINI WAR "Ya hay un proceso AFREC corriendo."
			#exit
		fi
	else
		if [ $arrancar == 'no' ]; then
			echo "El Usuario no desea arrancar AFREC."
			GraLog AFINI INFO "El usuario $USER no desea iniciar AFREC en este momento."
			echo "Si desea arrancar AFREC, en otro momento, ejecute el siguiente comando: \". ARRANCAR.sh\" desde el directorio donde se encuentran los ejecutables."
			#exit
		else
			echo "Opción ingresada inválida. Intente nuevamente (si-no)."
			arrancarAFREC
		fi
	fi
	GraLog AFINI INFO "Cierre de Log."
}

# PROGRAMA PRINCIPAL DE AFINI

# Nos posicionamos en el directorio "GRUPO"
while [ ! -d conf ]
do
   cd ..
done

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
			else
				eliminarVariablesAmbiente
			fi
		else
			eliminarVariablesAmbiente
		fi
	else
		eliminarVariablesAmbiente
	fi	
fi
