#!/bin/bash
#Notas generales

#Parametros de entrada

#CMD_INSTALL=$1





#Return Values
#0: Todo ok
#1: Paquete ya instalado
#2: Instalacion abortada por el usuario

#GRUPO="/home/freddy/Workspace/TPSisOp" #Esto estaria hardcodeado, seria la ruta donde esta mi local, asi uso eso directamente, hay que ver como seria en caso de una maquina distinta
#Por el momento, tomo como path para instalar AFRA-J el direcorio definido en compose.sh 
#GRUPO="AFRA-J"
#GRUPO=$(pwd) #Esto estaria hardcodeado, seria la ruta donde esta mi local, asi uso eso directamente, hay que ver como seria en caso de una maquina distinta
#CONFDIR="$GRUPO/conf" #aca van el log AFINSTAL.lg y el de configuracion AFINSTAL.cnfg
#BINDIR="$GRUPO/bin"
#MAEDIR="$GRUPO/mae"
#NOVEDIR="$GRUPO/novedades"
#ACEPDIR="$GRUPO/aceptadas"
#PROCDIR="$GRUPO/sospechosas"
#REPODIR="$GRUPO/reportes"
#LOGDIR="$GRUPO/log"
#RECHDIR="$GRUPO/rechazadas"

#Verificamos si perl esta instalado y guardo en una variable si estaba o no (0 si esta, 1 si no segun dpkg)
#dpkg -s perl #TODO habria que conseguir la version de perl y que esta sea al menos la 5
#PERL_INSTALLED=$?
#clear


#echo "Bienvenido al programa de instalacion de AFRA-J."
#echo "Mediante unos pasos vamos a definir la configuracion del programa, luego procederemos con la instalacion."
#echo "Una vez terminado podra arrancar el demonio para correr el sistema."
#echo "Puede interrumpir la instalacion en cualquier momento ingresando un 0 como opcion, regresando al inicio de la instalacion para realizar cualquier correccion, tambien puede salir del instalador si hiciera falta, no se van a aplicar los cambios hasta el final."

#Hacemos instalar perl si no estaba
#if [ $PERL_INSTALLED != 0 ]
#then
#	echo "El programa necesita de Perl para poder generar reportes, se va a proceder a instalarlo. Por favor ingrese la contrasena cuando se le solicite"
#	sudo apt-get --force-yes --yes install perl
#fi

#1_Verifico si el paquete ya esta instalado
#if [ -e "$CONFDIR/AFINSTAL.cnfg" ]
#then
#	echo "El paquete ya fue instalado, no es necesario seguir."
	#FIXEARINSTALACION=verificarInstalacion
	#si todo esta bien, no hacer nada y salir con 1
#	exit 1
	#si faltan cosas, ofrecer completar, si no quiere, salir con 2, si no, completar la instalacion
#fi

#2_Inicio de la instalacion.
#if [ "$CMD_INSTALL" == "-start" ]
#then
	#mostrar terminos y condiciones, si no acepta, salir con 2, si acepta, seguir
	#definir directorios
	#mostrar configuracion y ofrecer cambiar alguno, si quiere, volver a definir directorios, si no, seguir
	#verificar que quiere instalar todo como dice, si no quiere, salir con 2, si quiere, seguir
	#crear directorios
	#mover ejecutables, funciones, maestros, tablas
	#actualizar archivo de configuracion de instalacion $CONFDIR/AFINSTAL.cnfg y estamo
#	echo -e "Creando arbol de directorios y archivos \n \t * AFINSTAL.lg \n \t * AFINSTAL.cnfg"

#	> $CONFDIR/AFINSTAL.lg
#	> $CONFDIR/AFINSTAL.cnfg
#fi



#
#----------------  AFINSTALL.sh  ----------------
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


#GRUPO=$(pwd) #Esto estaria hardcodeado, seria la ruta donde esta mi local, asi uso eso directamente, hay que ver como seria en caso de una maquina distinta
CONFDIR="$GRUPO/conf" #aca van el log AFINSTAL.lg y el de configuracion AFINSTAL.cnfg
BINDIR="$GRUPO/bin"
MAEDIR="$GRUPO/mae"
NOVEDIR="$GRUPO/novedades"
ACEPDIR="$GRUPO/aceptadas"
PROCDIR="$GRUPO/sospechosas"
REPODIR="$GRUPO/reportes"
LOGDIR="$GRUPO/log"
RECHDIR="$GRUPO/rechazadas"



# Variables para interactuar con el Usuario
#INPUT_USUARIO no se tienen que declarar las variables, directamente se asignan

#Verificamos si perl 5 al menos esta instalado y guardo en una variable si estaba o no (0 si esta, 1 si no segun dpkg)
dpkg -s perl
PERL_INSTALLED=$?
PERL_VERSION="$(dpkg --status perl | grep ^Version)"
clear 

#######################################################################



#echo "Bienvenido al programa de instalacion de AFRA-J......."
#echo "Mediante unos pasos vamos a definir la configuracion del programa, luego procederemos con la instalacion."
#echo "Una vez terminado podra arrancar el demonio para correr el sistema."
#echo "Puede interrumpir la instalacion en cualquier momento ingresando un 0 como opcion, regresando al inicio de la instalacion para realizar cualquier correccion, tambien puede salir del instalador si hiciera falta, no se van a aplicar los cambios hasta el final."


###############################################################################
#					INICIO FUNCIONES AUX
###############################################################################

# Se encarga de crear el arbol de directorios.
# Existe un arbol de direcorio por defecto, pero el usuario 
# tiene la posibilidad de modificar cada uno.
# 
# $GRUPO/bin
# $GRUPO/mae
# $GRUPO/novedades
# $GRUPO/aceptadas
# $GRUPO/sospechosas
# $GRUPO/reportes
# $GRUPO/log
# $GRUPO/rechazadas
#
function setPath(){

	echo "(logInfo) step 6: Definir el direcorio de los ejecutables"
	echo "Defina el directorio de instalación de los ejecutables ($GRUPO/bin):"
	read BINDIR
	echo "Defina directorio para maestros y tablas ($GRUPO/mae):"
	read MAEDIR
	echo "Defina el Directorio de recepción de archivos de llamadas ($GRUPO/novedades):"
	read NOVEDIR
	echo "Defina espacio mínimo libre para la recepción de archivos de llamadas en Mbytes (100):"
	read DATASIZE
	#verificarEspacioEnDisco
	echo "Defina el directorio de grabación de los archivos de llamadas aceptadas ($GRUPO/aceptadas):"
	read ACEPDIR
	echo "Defina el directorio de grabación de los registros de llamadas sospechosas ($GRUPO/sospechosas):"
	read PROCDIR
	echo "Defina el directorio de grabación de los reportes ($GRUPO/reportes):"
	read REPODIR
	echo "Defina el directorio para los archivos de log ($GRUPO/log):"
	read LOGDIR
	echo "Defina el nombre para la extensión de los archivos de log (lg):"
	read LOGEXT
	echo "Defina el tamaño máximo para cada archivo de log en Kbytes (400):"
	read LOGSIZE
	echo "Defina el directorio de grabación de Archivos rechazados ($GRUPO/rechazadas):"
	read RECHDIR
}	

# Crea las estructuras de directorio requeridas
#
function instalacion(){ 
	echo "Creando Extructuras de directorio..."
	echo -e "\t $CONFDIR"
	echo -e "\t $BINDIR"
	echo -e "\t $MAEDIR"
	echo -e "\t $NOVEDIR"
	echo -e "\t $ACEPDIR"
	echo -e "\t $PROCDIR"
	echo -e "\t $REPODIR"
	echo -e "\t $LOGDIR"
	echo -e "\t $RECHDIR"

	# Creacion de los directorios.
	# $CONFDIR se crea por defecto al descomprimir el paquete de instalacion.
	# $BINDIR  por el momento dejo que se cree por defecto este direcorio.
	mkdir $MAEDIR $NOVEDIR $ACEPDIR $PROCDIR $REPODIR $LOGDIR $RECHDIR
	#despues hay que crear el file de configuracion y ver si tmb uno extra donde esta afini para que ese lo levante y pueda llegar al cnfg	

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

	echo "(logInfo) step 1: Verificando si el sistema AFRA-J se encuentra instalado"
	#Verifico si el paquete ya esta instalado
	if [ -e "$CONFDIR/AFINSTAL.cnfg" ]
	then
		echo "Existe una version instalada de AFRA-J."
		# Verificar si la instalacion esta completa.
		verificarInstalacionCompleta		
	fi
	#Chequear que Perl este instalado.
	verificarPerl
}

# verificar si la instalacion esta completa.
# 
function verificarInstalacionCompleta(){

	echo "(logInfo) step 2: Verificar si la instalacion esta completa"
	exit 1
}

function step3(){

	echo "step 3"

}

# verificar si Perl esta instaldo en el SO.
# 
function verificarPerl(){

	echo "(logInfo) step 4: Verificando que Perl este instaldo."
	#Hacemos instalar perl si no estaba
	if [ $PERL_INSTALLED != 0 ]
	then
		echo "El programa necesita de Perl para poder generar reportes, se va a proceder a instalarlo. Por favor ingrese la contrasena cuando se le solicite"
		sudo apt-get --force-yes --yes install perl
	fi
	echo "Perl instalado"
#	exit 1
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
	echo -e "loading..." #para que este loading?
	# Confirmo si el paquete ya esta instalado.
	detectarInstalacion
	
	# Aceptar terminos y condiciones.
	terminosYCondiciones

	# Interaccion con el usuario.	
	echo "Acepta? Si - No (Si/No)"	
	read INPUT_USUARIO
	echo "(logInfo) Input usuario: $INPUT_USUARIO"	

	if [ "$INPUT_USUARIO" == "n" ] #Validar con una expresion regular.
	then
		echo "Fin de la instalacion"
		exit 1
	fi

	echo "Iniciando instalacion...."
	# Definir el arbol de directorios
	setPath

	# Mostrar como quedo configurada la instalacion.
	imprimirConfiguracion

	# Interaccion con el usuario.	
	echo "Desea continuar con la instalación? (Si-No)"
	read INPUT_USUARIO
	echo "(logInfo) Input usuario: $INPUT_USUARIO"

	if [ "$INPUT_USUARIO" == "n" ] #Validar con una expresion regular.
	then 
		clear
		echo "(logInfo) El usuario no quiere seguir con la instalacion"
		exit 1
	fi

	#Confirmar inicio de instalacion
	echo "Iniciando Instalacion. Esta Ud. seguro? (Si-No)"
	read INPUT_USUARIO 
	if [ "$INPUT_USUARIO" == "n" ] #Validar con una expresion regular.
	then
		echo "Fin, no se instalo el sistema."
		exit 1		
	fi

	# Instalacion
	instalacion 
	
	exit 1
fi






