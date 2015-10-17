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

source ./bin/MoverA.sh
source ./bin/GraLog.sh


###################### variables de entorno ##########################

# Direcorio donde se va a instalar el sistema AFRA-J
GRUPO="$PWD"
CMD_INSTALL=$1

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

# Variables para interactuar con el Usuario
#INPUT_USUARIO no se tienen que declarar las variables, directamente se asignan

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

	echo "(logInfo) step 6: Definir el direcorio de los ejecutables"

	echo "Cambie, o deje vacio, el directorio de instalación de los ejecutables ($DEFAULT_BINDIR):"
	read BINDIR
	if [ "$BINDIR" == "" ]
	then
		BINDIR=$DEFAULT_BINDIR
	fi

	echo "Cambie, o deje vacio, directorio para maestros y tablas ($DEFAULT_MAEDIR):"
	read MAEDIR
	if [ "$MAEDIR" == "" ]
	then
		MAEDIR=$DEFAULT_MAEDIR
	fi

	echo "Cambie, o deje vacio, el Directorio de recepción de archivos de llamadas ($DEFAULT_NOVEDIR):"
	read NOVEDIR
	if [ "$NOVEDIR" == "" ]
	then
		NOVEDIR=$DEFAULT_NOVEDIR
	fi

	echo "Cambie, o deje vacio, el directorio de grabación de los archivos de llamadas aceptadas ($DEFAULT_ACEPDIR):"
	read ACEPDIR
	if [ "$ACEPDIR" == "" ]
	then
		ACEPDIR=$DEFAULT_ACEPDIR
	fi

	echo "Cambie, o deje vacio, el directorio de grabación de los registros de llamadas sospechosas ($DEFAULT_PROCDIR):"
	read PROCDIR
	if [ "$PROCDIR" == "" ]
	then
		PROCDIR=$DEFAULT_PROCDIR
	fi

	echo "Cambie, o deje vacio, el directorio de grabación de los reportes ($DEFAULT_REPODIR):"
	read REPODIR
	if [ "$REPODIR" == "" ]
	then
		REPODIR=$DEFAULT_REPODIR
	fi

	echo "Cambie, o deje vacio, el directorio para los archivos de log ($DEFAULT_LOGDIR):"
	read LOGDIR
	if [ "$LOGDIR" == "" ]
	then
		LOGDIR=$DEFAULT_LOGDIR
	fi

	echo "Cambie, o deje vacio, el directorio de grabación de Archivos rechazados ($DEFAULT_RECHDIR):"
	read RECHDIR
	if [ "$RECHDIR" == "" ]
	then
		RECHDIR=$DEFAULT_RECHDIR
	fi

	echo "Cambie, o deje vacio, espacio mínimo libre para la recepción de archivos de llamadas en Mbytes ($DEFAULT_DATASIZE):"
	read DATASIZE
	if [ "$DATASIZE" == "" ]
	then
		DATASIZE=$DEFAULT_DATASIZE
	fi

	echo "Cambie, o deje vacio, el tamaño máximo para cada archivo de log en Kbytes ($DEFAULT_LOGSIZE):"
	read LOGSIZE
	if [ "$LOGSIZE" == "" ]
	then
		LOGSIZE=$DEFAULT_LOGSIZE
	fi

	echo "Cambie, o deje vacio, el nombre para la extensión de los archivos de log ($DEFAULT_LOGEXT):"
	read LOGEXT
	if [ "$LOGEXT" == "" ]
	then
		LOGEXT=$DEFAULT_LOGEXT
	fi
}

# Crea las estructuras de directorio requeridas
#
function instalacion(){ 
	echo "Iniciando instalacion..."
	echo -e "\t $CONFDIR"
	echo -e "\t $BINDIR"
	echo -e "\t $MAEDIR"
	echo -e "\t $NOVEDIR"
	echo -e "\t $ACEPDIR"
	echo -e "\t $PROCDIR"
	echo -e "\t $REPODIR"
	echo -e "\t $LOGDIR"
	echo -e "\t $RECHDIR"

	echo "-Creacion de los directorios..."
	mkdir --parents "$BINDIR" "$MAEDIR" "$NOVEDIR" "$ACEPDIR" "$PROCDIR" "$REPODIR" "$LOGDIR" "$RECHDIR"	
	echo "-Directorios creados"

	verificarEspacioEnDisco
	generateFileConfiguracion
	moverFiles
}

function generateFileConfiguracion(){
	echo "-Guardando configuracion del sistema..."
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
}

function moverFiles(){
	echo "-Moviendo archivos..."
	#Movientos de ejecutables
	MoverA $DEFAULT_BINDIR/MoverA.sh $BINDIR/MoverA.sh
	MoverA $DEFAULT_BINDIR/GraLog.sh $BINDIR/GraLog.sh
	MoverA $DEFAULT_BINDIR/AFREC.sh $BINDIR/AFREC.sh
	MoverA $DEFAULT_BINDIR/AFINI.sh $BINDIR/AFINI.sh
	MoverA $DEFAULT_BINDIR/AFUMB.sh $BINDIR/AFUMB.sh
	MoverA $DEFAULT_BINDIR/ARRANCAR.sh $BINDIR/ARRANCAR.sh
	MoverA $DEFAULT_BINDIR/DETENER.sh $BINDIR/DETENER.sh
	MoverA $DEFAULT_BINDIR/AFLIST.pl $BINDIR/AFLIST.pl
	#Moviento de archivos maestros
	MoverA $GRUPO/master/CdA $MAEDIR/CdA
	MoverA $GRUPO/master/CdC $MAEDIR/CdC
	MoverA $GRUPO/master/CdP $MAEDIR/CdP
	MoverA $GRUPO/master/tllama.tab $MAEDIR/tllama.tab
	MoverA $GRUPO/master/umbral.tab $MAEDIR/umbral.tab
	MoverA $GRUPO/master/agentes $MAEDIR/agentes
	echo "-Archivos movidos"
}

function usuarioContinuar(){
	INPUT_USUARIO=$1	
	MSJ_AL_USUARIO=$2
	case $INPUT_USUARIO in
		$(echo $INPUT_USUARIO | grep "^[Nn][Oo]*$") ) # "No" "no" "NO" "nO" "n"  
			echo "Exit "	
			exit 1
		;;
		$(echo $INPUT_USUARIO | grep "^[Ss][Ii]*$") ) # "Si" "si" "sI" "SI" "s"
			echo $MSJ_AL_USUARIO
		;;
 		*)
			echo "Opcion Incorrecta.FIN"
			exit 1
		;;
	esac	
}

# Esta Funcion se encarga de interactuar con el usuario.
# Pide al usuario que ingrese un valor, este no pued ser vacio.
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

	#Verifico si el paquete ya esta instalado
	if [ -e "$DEFAULT_CONFDIR/AFINSTAL.cnfg" ]
	then
		echo "Ya existe una version instalada de AFRA-J."
		levantarValoresDelCNFG
		LISTA="A Modificar"
		verificarInstalacionCompleta
	else
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
	# Seteo de variables de ambiente desde el archivo
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
	echo "Desea modificar la instalacion? (Si/No)"
	read INPUT_USUARIO
	
	# Validar Si el usuario desea continuar. 
	usuarioContinuar $INPUT_USUARIO "Siguiente..."
}

#verificar si hay suficiente espacio en disco para las novedades
#
function verificarEspacioEnDisco(){
	ESPACIO_NOVEDIR="$(df -h -k --block-size=MB $NOVEDIR | awk 'NR==2{print$4}' | sed s/MB$//)"
	if [ $ESPACIO_NOVEDIR -lt $DATASIZE ]
	then
		echo "No hay suficiente espacio en disco para poder completar la instalacion con esa configuracion"
		echo "Libere espacio en el disco y vuelva a intentarlo"
		exit 3
	fi
}

# verificar si Perl esta instaldo en el SO.
# 
function verificarPerl(){

	echo "(logInfo) step 4: Verificando que Perl este instaldo."
	echo "(logInfo) Perl version: " $PERL_VERSION
	echo "(logInfo) Switch version: " $SWITCH_VERSION
	#Hacemos instalar perl si no estaba
	if [ $PERL_VERSION -lt "5" -o $SWITCH_VERSION -lt "2" ]
	then
		echo "El programa necesita de Perl y sus librerias para poder generar reportes, se va a proceder a instalarlo. Por favor ingrese la contrasena cuando se le solicite"
		echo "De no instalarlo no podra generar los reportes. Sin embargo, puede instalarlo por su cuenta cuando desee mas tarde."
		sudo apt-get --force-yes --yes install perl
		sudo apt-get --force-yes --yes install libswitch-perl
	fi
}

# Aceptacion de terminos y condiciones. 
#
function terminosYCondiciones(){
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
	echo "(logInfo) step 18: Parametros configurados."

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
	echo "Desea continuar con la instalación? (Si-No)"
	read INPUT_USUARIO		
	
	# Validar Si el Usuario desea continuar
	usuarioContinuar $INPUT_USUARIO "Siguiente..."
	
	#Confirmar inicio de instalacion
	echo "Iniciando Instalacion. Esta Ud. seguro? (Si-No)"
	read INPUT_USUARIO 

	# Validar Si el Usuario desea continuar
	usuarioContinuar $INPUT_USUARIO "Iniciando instalacion del sistema AFRA-J"
	
	# Instalacion
	instalacion 
	
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






