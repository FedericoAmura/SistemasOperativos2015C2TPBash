#!/bin/bash
#Notas generales

#Parametros de entrada

CMD_INSTALL=$1





#Return Values
#0: Todo ok
#1: Paquete ya instalado
#2: Instalacion abortada por el usuario

#GRUPO="/home/freddy/Workspace/TPSisOp" #Esto estaria hardcodeado, seria la ruta donde esta mi local, asi uso eso directamente, hay que ver como seria en caso de una maquina distinta
#Por el momento, tomo como path para instalar AFRA-J el direcorio definido en compose.sh 
GRUPO="AFRA-J"
GRUPO=$(pwd) #Esto estaria hardcodeado, seria la ruta donde esta mi local, asi uso eso directamente, hay que ver como seria en caso de una maquina distinta
CONFDIR="$GRUPO/conf" #aca van el log AFINSTAL.lg y el de configuracion AFINSTAL.cnfg
BINDIR="$GRUPO/bin"
MAEDIR="$GRUPO/mae"
NOVEDIR="$GRUPO/novedades"
ACEPDIR="$GRUPO/aceptadas"
PROCDIR="$GRUPO/sospechosas"
REPODIR="$GRUPO/reportes"
LOGDIR="$GRUPO/log"
RECHDIR="$GRUPO/rechazadas"

#Verificamos si perl esta instalado y guardo en una variable si estaba o no (0 si esta, 1 si no segun dpkg)
dpkg -s perl #TODO habria que conseguir la version de perl y que esta sea al menos la 5
PERL_INSTALLED=$?
clear


echo "Bienvenido al programa de instalacion de AFRA-J."
echo "Mediante unos pasos vamos a definir la configuracion del programa, luego procederemos con la instalacion."
echo "Una vez terminado podra arrancar el demonio para correr el sistema."
echo "Puede interrumpir la instalacion en cualquier momento ingresando un 0 como opcion, regresando al inicio de la instalacion para realizar cualquier correccion, tambien puede salir del instalador si hiciera falta, no se van a aplicar los cambios hasta el final."

#Hacemos instalar perl si no estaba
if [ $PERL_INSTALLED != 0 ]
then
	echo "El programa necesita de Perl para poder generar reportes, se va a proceder a instalarlo. Por favor ingrese la contrasena cuando se le solicite"
	sudo apt-get --force-yes --yes install perl
fi

#1_Verifico si el paquete ya esta instalado
if [ -e "$CONFDIR/AFINSTAL.cnfg" ]
then
	echo "El paquete ya fue instalado, no es necesario seguir."
	#FIXEARINSTALACION=verificarInstalacion
	#si todo esta bien, no hacer nada y salir con 1
	exit 1
	#si faltan cosas, ofrecer completar, si no quiere, salir con 2, si no, completar la instalacion
fi

#2_Inicio de la instalacion.
if [ "$CMD_INSTALL" == "-start" ]
then
	#mostrar terminos y condiciones, si no acepta, salir con 2, si acepta, seguir
	#definir directorios
	#mostrar configuracion y ofrecer cambiar alguno, si quiere, volver a definir directorios, si no, seguir
	#verificar que quiere instalar todo como dice, si no quiere, salir con 2, si quiere, seguir
	#crear directorios
	#mover ejecutables, funciones, maestros, tablas
	#actualizar archivo de configuracion de instalacion $CONFDIR/AFINSTAL.cnfg y estamo
	echo -e "Creando arbol de directorios y archivos \n \t * AFINSTAL.lg \n \t * AFINSTAL.cnfg"

	> $CONFDIR/AFINSTAL.lg
	> $CONFDIR/AFINSTAL.cnfg
fi







