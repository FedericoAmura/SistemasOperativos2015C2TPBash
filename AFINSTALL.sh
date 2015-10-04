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
INPUT_USUARIO

#Verificamos si perl esta instalado y guardo en una variable si estaba o no (0 si esta, 1 si no segun dpkg)
dpkg -s perl #TODO habria que evitar lo que imprime esto y evitamos el clear en 2 lineas, ademas seria mas limpio
PERL_INSTALLED=$?
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
	#Por el momento, no interactua con el usuario.
	echo "(aLog) Defina el directorio de instalacion de los ejecutables  ($GRUPO/bin):"
 	echo "(aLog) Defina el directorio de instalacion de los archivos maestros y tablas ($GRUPO/mae):"
 	echo "(aLog) Defina el directorio de input del proceso AFREC ($GRUPO/novedades):"
 	echo "(aLog) Defina el directorio de input del proceso AFUMB ($GRUPO/aceptadas):"
 	echo "(aLog) Defina el directorio de output del proceso AFUMB ($GRUPO/sospechosas):"
 	echo "(aLog) Defina el directorio de trabajo principal del proceso AFLIST ($GRUPO/reportes):"
 	echo "(aLog) Defina el directorio para depositar los archovos de log de los comandos ($GRUPO/log):"
 	echo "(aLog) Defina el repositorio de archivos rechazados ($GRUPO/rechazadas):"

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
function step1(){

	echo "(logInfo) step 1: Verificando si el sistema AFRA-J se encuentra instalado"
	#Verifico si el paquete ya esta instalado
	if [ -e "$CONFDIR/AFINSTAL.cnfg" ]
	then
		echo "Existe una version instalada de AFRA-J."
		# Verificar si la instalacion esta completa.
		step2		
	fi
	#Chequear que Perl este instalado.
	step4
}

# verificar si la instalacion esta completa.
# 
function step2(){

	echo "(logInfo) step 2: Verificar si la instalacion esta completa"
	exit 1
}

function step3(){

	echo "step 3"

}

# verificar si Perl esta instaldo en el SO.
# 
function step4(){

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
function step5(){
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
function step18(){
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
	echo -e "loading..."
	# Confirmo si el paquete ya esta instalado.
	step1
	
	# Aceptar terminos y condiciones.
	step5

	# Interaccion con el usuario.	
	echo "Acepta? Si - No (Si/No)"	
	read INPUT_USUARIO
	echo "(logInfo) $INPUT_USUARIO"

	if [ "$INPUT_USUARIO" == "n" ] #Validar con una expresion regular.
	then
		echo "Fin de la instalacion"
		exit 1
	fi

	echo "Iniciando instalacion...."
	# Definir el arbol de directorios
	setPath

	# Mostrar como quedo configurada la instalacion.
	step18

	# Interaccion con el usuario.	
	echo "Desea continuar con la instalación? (Si-No)"
	read INPUT_USUARIO
	echo "(logInfo) $INPUT_USUARIO"

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






