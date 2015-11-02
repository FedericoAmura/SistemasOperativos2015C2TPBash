#!/bin/bash
#
#----------------  AFINSTAL.sh  ----------------
#	
# Script encargado de la instalacion del sistema AFRA-j
# Lista de comandos:
#	*-start:  Inicia la instalacion.
#

#########################  Notas generales  #########################

#Return Values
#0: Todo ok
#1: Paquete ya instalado
#2: Instalacion abortada por el usuario
#3: No hay suficiente espacio en disco para completar la instalacion

############################# sources ###############################

source ./source/MoverA.sh
source ./source/GraLog.sh
LOGSIZE=400

###################### variables de entorno ##########################

# Direcorio donde se va a instalar el sistema AFRA-J
GRUPO="$PWD"
CMD_INSTALL=$1

GraLog AFINSTAL INFO "Inicio proceso de instalacion"
GraLog AFINSTAL INFO "Directorio de invocacion: $GRUPO"

# Variables por Default

DEFAULT_CONFDIR="$GRUPO/conf" #aca van el log AFINSTAL.lg y el de configuracion AFINSTAL.cnfg
DEFAULT_BINDIR="$GRUPO/bin"
DEFAULT_MAEDIR="$GRUPO/mae"
DEFAULT_NOVEDIR="$GRUPO/novedades"
DEFAULT_ACEPDIR="$GRUPO/aceptadas"
DEFAULT_PROCDIR="$GRUPO/sospechosas"
DEFAULT_REPODIR="$GRUPO/reportes"
DEFAULT_LOGDIR="$GRUPO/log"
DEFAULT_RECHDIR="$GRUPO/rechazadas"
DEFAULT_DATASIZE=100
DEFAULT_LOGSIZE=400
DEFAULT_LOGEXT=lg

#Obtenemos las versiones de PERL y del SWITCH
PERL_VERSION="$(dpkg --status perl | grep ^Version | cut -c 10)"
SWITCH_VERSION="$(dpkg --status libswitch-perl | grep ^Version | cut -c 10)"

###############################################################################
#					INICIO FUNCIONES AUX
###############################################################################

# Se encarga de crear el arbol de directorios.
# Existe un arbol de direcorio por defecto, pero el usuario 
# tiene la posibilidad de modificar cada uno.

function setPath(){

	echo "Ingrese los siguientes directorios a utilizar por el programa. Si no ingresa ningun valor, se tomara el valor default mostrado entre parentesis."
	GraLog AFINSTAL INFO "Inicio configuracion variables."

	echo "Cambie, o deje vacio para utilizar el default, el directorio de instalación de los ejecutables ($DEFAULT_BINDIR):"
	echo -n "$GRUPO/"
	read INPUT_USUARIO
	if [ "$INPUT_USUARIO" == "" ]
	then
		BINDIR=$DEFAULT_BINDIR
	else
		BINDIR="$GRUPO/$INPUT_USUARIO"
	fi
	GraLog AFINSTAL INFO "Configuracion BINDIR: $BINDIR"

	echo "Cambie, o deje vacio para utilizar el default, el directorio para maestros y tablas ($DEFAULT_MAEDIR):"
	read MAEDIR
	if [ "$MAEDIR" == "" ]
	then
		MAEDIR=$DEFAULT_MAEDIR
	fi
	GraLog AFINSTAL INFO "Configuracion MAEDIR: $MAEDIR"

	echo "Cambie, o deje vacio para utilizar el default, el directorio de recepción de archivos de llamadas ($DEFAULT_NOVEDIR):"
	read NOVEDIR
	if [ "$NOVEDIR" == "" ]
	then
		NOVEDIR=$DEFAULT_NOVEDIR
	fi
	GraLog AFINSTAL INFO "Configuracion NOVEDIR: $NOVEDIR"

	echo "Cambie, o deje vacio para utilizar el default, el directorio de grabación de los archivos de llamadas aceptadas ($DEFAULT_ACEPDIR):"
	read ACEPDIR
	if [ "$ACEPDIR" == "" ]
	then
		ACEPDIR=$DEFAULT_ACEPDIR
	fi
	GraLog AFINSTAL INFO "Configuracion ACEPDIR: $ACEPDIR"

	echo "Cambie, o deje vacio para utilizar el default, el directorio de grabación de los registros de llamadas sospechosas ($DEFAULT_PROCDIR):"
	read PROCDIR
	if [ "$PROCDIR" == "" ]
	then
		PROCDIR=$DEFAULT_PROCDIR
	fi
	GraLog AFINSTAL INFO "Configuracion PROCDIR: $PROCDIR"

	echo "Cambie, o deje vacio para utilizar el default, el directorio de grabación de los reportes ($DEFAULT_REPODIR):"
	read REPODIR
	if [ "$REPODIR" == "" ]
	then
		REPODIR=$DEFAULT_REPODIR
	fi
	GraLog AFINSTAL INFO "Configuracion REPODIR: $REPODIR"

	echo "Cambie, o deje vacio para utilizar el default, el directorio para los archivos de log ($DEFAULT_LOGDIR):"
	read LOGDIR
	if [ "$LOGDIR" == "" ]
	then
		LOGDIR=$DEFAULT_LOGDIR
	fi
	GraLog AFINSTAL INFO "Configuracion LOGDIR: $LOGDIR"

	echo "Cambie, o deje vacio para utilizar el default, el directorio de grabación de Archivos rechazados ($DEFAULT_RECHDIR):"
	read RECHDIR
	if [ "$RECHDIR" == "" ]
	then
		RECHDIR=$DEFAULT_RECHDIR
	fi
	GraLog AFINSTAL INFO "Configuracion RECHDIR: $RECHDIR"

	echo "Cambie, o deje vacio para utilizar el default, el espacio mínimo libre para la recepción de archivos de llamadas en Mbytes ($DEFAULT_DATASIZE):"
	read DATASIZE
	if [ "$DATASIZE" == "" ]
	then
		DATASIZE=$DEFAULT_DATASIZE
	fi
	GraLog AFINSTAL INFO "Configuracion DATASIZE: $DATASIZE"

	echo "Cambie, o deje vacio para utilizar el default, el tamaño máximo para cada archivo de log en Kbytes ($DEFAULT_LOGSIZE):"
	read LOGSIZE
	if [ "$LOGSIZE" == "" ]
	then
		LOGSIZE=$DEFAULT_LOGSIZE
	fi
	GraLog AFINSTAL INFO "Configuracion LOGSIZE: $LOGSIZE"

	echo "Cambie, o deje vacio para utilizar el default, el nombre para la extensión de los archivos de log ($DEFAULT_LOGEXT):"
	read LOGEXT
	if [ "$LOGEXT" == "" ]
	then
		LOGEXT=$DEFAULT_LOGEXT
	fi
	GraLog AFINSTAL INFO "Configuracion LOGEXT: $LOGEXT"
}

# Crea las estructuras de directorio requeridas
#
function instalacion(){
	echo ""
	echo "Instalacion:"
	GraLog AFINSTAL INFO "Iniciando instalacion."
	echo "PWD: $PWD"

	echo "-Creacion de los directorios..."
	GraLog AFINSTAL INFO "Creando directorios"
	mkdir --parents "$BINDIR" "$MAEDIR" "$NOVEDIR" "$ACEPDIR" "$PROCDIR" "$REPODIR" "$LOGDIR" "$RECHDIR"	
	echo "-Directorios creados"
	GraLog AFINSTAL INFO "Directorios creados"
	echo "PWD: $PWD"
	verificarEspacioEnDisco
	generateFileConfiguracion
	moverFiles

	GraLog AFINSTAL INFO "Instalacion finalizada"
}

function generateFileConfiguracion(){
	echo "-Guardando configuracion del sistema..."
	GraLog AFINSTAL INFO "Guardando configuracion del sistema"
	echo "GRUPO=$GRUPO=$USER=$(date '+%d/%m/%Y %H:%M:%S')" > $DEFAULT_CONFDIR/AFINSTAL.cnfg
	echo "BINDIR=$BINDIR=$USER=$(date '+%d/%m/%Y %H:%M:%S')" >> $DEFAULT_CONFDIR/AFINSTAL.cnfg
	echo "MAEDIR=$MAEDIR=$USER=$(date '+%d/%m/%Y %H:%M:%S')" >> $DEFAULT_CONFDIR/AFINSTAL.cnfg
	echo "NOVEDIR=$NOVEDIR=$USER=$(date '+%d/%m/%Y %H:%M:%S')" >> $DEFAULT_CONFDIR/AFINSTAL.cnfg
	echo "ACEPDIR=$ACEPDIR=$USER=$(date '+%d/%m/%Y %H:%M:%S')" >> $DEFAULT_CONFDIR/AFINSTAL.cnfg
	echo "PROCDIR=$PROCDIR=$USER=$(date '+%d/%m/%Y %H:%M:%S')" >> $DEFAULT_CONFDIR/AFINSTAL.cnfg
	echo "REPODIR=$REPODIR=$USER=$(date '+%d/%m/%Y %H:%M:%S')" >> $DEFAULT_CONFDIR/AFINSTAL.cnfg
	echo "LOGDIR=$LOGDIR=$USER=$(date '+%d/%m/%Y %H:%M:%S')" >> $DEFAULT_CONFDIR/AFINSTAL.cnfg
	echo "RECHDIR=$RECHDIR=$USER=$(date '+%d/%m/%Y %H:%M:%S')" >> $DEFAULT_CONFDIR/AFINSTAL.cnfg
	echo "DATASIZE=$DATASIZE=$USER=$(date '+%d/%m/%Y %H:%M:%S')" >> $DEFAULT_CONFDIR/AFINSTAL.cnfg
	echo "LOGSIZE=$LOGSIZE=$USER=$(date '+%d/%m/%Y %H:%M:%S')" >> $DEFAULT_CONFDIR/AFINSTAL.cnfg
	echo "LOGEXT=$LOGEXT=$USER=$(date '+%d/%m/%Y %H:%M:%S')" >> $DEFAULT_CONFDIR/AFINSTAL.cnfg
	echo "-Configuracion guardada."
	GraLog AFINSTAL INFO "Configuracion guardada"
}

function moverFiles(){
	echo "-Moviendo archivos..."
	GraLog AFINSTAL INFO "Moviendo archivos"
	#Movientos de ejecutables
	MoverA "$GRUPO/source/MoverA.sh" "$BINDIR/MoverA.sh" AFINSTAL copiar
	MoverA "$GRUPO/source/GraLog.sh" "$BINDIR/GraLog.sh" AFINSTAL copiar
	MoverA "$GRUPO/source/AFREC.sh" "$BINDIR/AFREC.sh" AFINSTAL copiar
	MoverA "$GRUPO/source/AFINI.sh" "$BINDIR/AFINI.sh" AFINSTAL copiar
	MoverA "$GRUPO/source/AFUMB.sh" "$BINDIR/AFUMB.sh" AFINSTAL copiar
	MoverA "$GRUPO/source/ARRANCAR.sh" "$BINDIR/ARRANCAR.sh" AFINSTAL copiar
	MoverA "$GRUPO/source/DETENER.sh" "$BINDIR/DETENER.sh" AFINSTAL copiar
	MoverA "$GRUPO/source/AFLIST.pl" "$BINDIR/AFLIST.pl" AFINSTAL copiar
	#Moviento de archivos maestros
	MoverA "$GRUPO/source/CdA.csv" "$MAEDIR/CdA.csv" AFINSTAL copiar
	MoverA "$GRUPO/source/CdP.csv" "$MAEDIR/CdP.csv" AFINSTAL copiar
	MoverA "$GRUPO/source/centrales.csv" "$MAEDIR/centrales.csv" AFINSTAL copiar
	MoverA "$GRUPO/source/umbrales.csv" "$MAEDIR/umbrales.csv" AFINSTAL copiar
	MoverA "$GRUPO/source/tllama.tab" "$MAEDIR/tllama.tab" AFINSTAL copiar
	MoverA "$GRUPO/source/agentes.csv" "$MAEDIR/agentes.csv" AFINSTAL copiar

	echo "-Archivos movidos"
	GraLog AFINSTAL INFO "Archivos movidos"
}

function usuarioContinuar(){
	INPUT_USUARIO=$1	
	MSJ_AL_USUARIO=$2
	case $INPUT_USUARIO in
		$(echo $INPUT_USUARIO | grep "^[Nn][Oo]*$") ) # "No" "no" "NO" "nO" "n"  
			echo "Exit"
			GraLog AFINSTAL INFO "Opcion no aceptada. Abortando instalacion"
			exit 1
		;;
		$(echo $INPUT_USUARIO | grep "^[Ss][Ii]*$") ) # "Si" "si" "sI" "SI" "s"
			echo $MSJ_AL_USUARIO
			GraLog AFINSTAL INFO "Opcion aceptada."
		;;
 		*)
			echo "Opcion invalida ingresada. Instalacion abortada."
			GraLog AFINSTAL ERR "Opcion invalida ingresada. Instalacion abortada."
			exit 1
		;;
	esac	
}

# Esta Funcion se encarga de interactuar con el usuario.
# Pide al usuario que ingrese un valor, este no puede ser vacio.
#
function inputBoxString(){

	MSJ_AL_USUARIO=$1
	for i in `seq 1 3`;
    do
        echo $MSJ_AL_USUARIO
        read INPUT_USUARIO
		
		case $INPUT_USUARIO in
		$(echo $INPUT_USUARIO | grep "[a-zA-Z0-9\s]")) #Falta filtrar los \n o cualquier cosa nula.		
			exit
		;;
		$(echo $INPUT_USUARIO | grep "[^a-zA-Z0-9]") ) 
			echo "Valor invalido."
		;;
		esac	
    done  
    VALUE=$INPUT_USUARIO
    
}


###############################################################################
#					FIN FUNCIONES AUX
###############################################################################


###############################################################################
#					INICIO STEPS DE INSATALACION
###############################################################################
# Pasos de instalacion.
# cada step, refleja un paso de instalacion (detallado en el enunciado del tp)


# Detectar si el paquete AFRA-J o algunos de sus componentes ya esta instalado.
#
function detectarInstalacion(){
	GraLog AFINSTAL INFO "Buscando instalaciones AFRA-J existentes"
	if [ -e "$DEFAULT_CONFDIR/AFINSTAL.cnfg" ]
	then
		GraLog AFINSTAL INFO "Ya existe una version instalada de AFRA-J."
		levantarValoresDelCNFG
		LISTA="A Modificar"
		verificarInstalacionCompleta
	else
		GraLog AFINSTAL INFO "Instalacion nueva de AFRA-J."
		LISTA="Pendiente"		
	fi
	#Chequear que Perl este instalado.
	verificarPerl
}

# cargo los valores del archivo de configuracion
#
function levantarValoresDelCNFG(){
	oldIFS=$IFS
	IFS=$'\n'
	GraLog AFINSTAL INFO "Cargando variables de ambiente desde el archivo existente"
	for linea in $(< "conf/AFINSTAL.cnfg")
	do
		nombre_var=`echo $linea | cut -d "=" -f1`
		valor=`echo $linea | cut -d "=" -f2`
		export $nombre_var=$valor
	done
	IFS=$oldIFS
}

# verificar si la instalacion esta completa.
# 
function verificarInstalacionCompleta(){

	imprimirConfiguracion
	echo "Desea ejecutar de nuevo la instalacion? (Si/No)"
	read INPUT_USUARIO
	
	# Validar Si el usuario desea continuar. 
	usuarioContinuar $INPUT_USUARIO ""
}

#verificar si hay suficiente espacio en disco para las novedades
#
function verificarEspacioEnDisco(){
	ESPACIO_NOVEDIR="$(df -h -k --block-size=MB $NOVEDIR | awk 'NR==2{print$4}' | sed s/MB$//)"
	if [ "$ESPACIO_NOVEDIR" -lt "$DATASIZE" ]
	then
		echo "No hay suficiente espacio en disco para poder completar la instalacion con esa configuracion"
		echo "Libere espacio en el disco y vuelva a intentarlo"
		GraLog AFINSTAL ERR "No hay suficiente espacio en disco para recibir novedades"
		exit 3
	fi
	GraLog AFINSTAL INFO "Verificado espacio en disco: OK"
}

# verificar si Perl esta instaldo en el SO.
# 
function verificarPerl(){

	GraLog AFINSTAL INFO "Version instalada de Perl: $PERL_VERSION"
	if [ "$PERL_VERSION" -lt "5" ]
	then
		echo "El programa necesita de Perl y la libreria switch para poder generar reportes, se va a proceder a instalarlo. Por favor ingrese la contrasena cuando se le solicite"
		echo "De no instalarlo no podra generar los reportes. Sin embargo, puede instalarlo por su cuenta cuando desee mas tarde y luego podra utilizar el modulo AFLIST."
		GraLog AFINSTAL INFO "Instalacion/actualizacion Perl"
		sudo apt-get --force-yes --yes install perl
	else
		GraLog AFINSTAL INFO "No hace falta actualizar Perl."
	fi
	
	GraLog AFINSTAL INFO "Version instalada de Switch: $SWITCH_VERSION"
	if [ "$SWITCH_VERSION" -lt "2" ]
	then
		GraLog AFINSTAL INFO "Instalacion/actualizacion Switch"
		sudo apt-get --force-yes --yes install libswitch-perl
	else
		GraLog AFINSTAL INFO "No hace falta actualizar Switch."
	fi
	
	GraLog AFINSTAL INFO "Perl/Switch ya instalados y actualizados"
}

# Aceptacion de terminos y condiciones. 
#
function terminosYCondiciones(){
	GraLog AFINSTAL INFO "Impresion terminos y condiciones"
	echo "***************************************************************"
	echo "*"
	echo "*			Proceso de Instalacion \"AFRA-J\" 		 "
	echo "*"
	echo "* 	Tema: J Copyright Grupo 3 - Segundo Cuatrimestre 2015 "
	echo "*"
	echo "***************************************************************"

	echo -e "A T E N C I O N: Al instalar UD. expresa aceptar los términos y condiciones del
	\"ACUERDO DE LICENCIA DE SOFTWARE\" incluido en este paquete.\n"
}

# Mostrar los valores de los parametros configurados y preguntar para continuar o voler atrás. 
#
function imprimirConfiguracion(){
	GraLog AFINSTAL INFO "Impresion parametros configurados"

	echo "Detalles de instalacion:"
	echo -e "\t Directorio de Ejecutables: $BINDIR"
	echo -e "\t Directorio de Maestros y Tablas: $MAEDIR"
	echo -e "\t Directorio de recepcion de archivos de llamadas: $NOVEDIR"	
	echo -e "\t Espacio minimo libre para aribos: $DATASIZE mb" 
	echo -e "\t Directorio de Archivos de llamadas Aceptadas: $ACEPDIR"
	echo -e "\t Directorio de Archivos de llamadas Sospechosas: $PROCDIR"
	echo -e "\t Directorio de Archivos de Reportes de llamadas: $REPODIR"
	echo -e "\t Directorio de Archivos de Log: $LOGDIR"	
	echo -e "\t Extensión para los archivos de log: $LOGEXT"
	echo -e "\t Tamaño máximo para los archivos de log: $LOGSIZE kb"	
	echo -e "\t Direcorio de Archivos Rechazados: $RECHDIR"
	echo -e "\t Estado de la instalacion: $LISTA"

}

###############################################################################
#					FIN STEPS DE INSTALACION
###############################################################################

#Inicio de la instalacion.
if [ "$CMD_INSTALL" == "-start" ]
then	
	# Confirmo si el paquete ya esta instalado.
	detectarInstalacion
	
	# Aceptar terminos y condiciones.
	terminosYCondiciones

	# Interaccion con el usuario.	
	echo "Acepta? Si - No (Si/No)"	
	read INPUT_USUARIO
	
	# Validar Si el usuario desea continuar. 
	usuarioContinuar $INPUT_USUARIO "Siguiente..."

	# Definir el arbol de directorios
	setPath

	# Mostrar como quedo configurada la instalacion.
	imprimirConfiguracion

	# Interaccion con el usuario.
	GraLog AFINSTAL INFO "Confirmar configuracion."
	echo "Por favor, confirme la configuracion mostrada. (Si-No)"
	read INPUT_USUARIO		
	
	# Validar Si el Usuario desea continuar
	usuarioContinuar $INPUT_USUARIO ""
	
	#Confirmar inicio de instalacion
	GraLog AFINSTAL INFO "Iniciar instalacion?."
	echo "Iniciando Instalacion. Esta Ud. seguro? (Si-No)"
	read INPUT_USUARIO 

	# Validar Si el Usuario desea continuar
	usuarioContinuar $INPUT_USUARIO "Iniciando instalacion del sistema AFRA-J"
	
	# Instalacion
	instalacion
	echo "Instalacion concluida."
	GraLog AFINSTAL INFO "Fin corrida AFINSTAL completada."
	exit 1
else
	if [ "$CMD_INSTALL" == "--help" ] || [ "$CMD_INSTALL" == "-h" ]
	then
		echo "TODO aca van las cosas del help y otras yerbas"
	else
		echo "Ingrese el parametro \"-start\" para inicializar la instalacion."
		echo "O el parametro \"-h\" o \"--help\" para ver la ayuda."
	fi
fi






