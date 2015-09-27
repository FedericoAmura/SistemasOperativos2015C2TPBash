#!/bin/bash
#Notas generales

#Return Values
#0: Todo ok
#1: Paquete ya instalado

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
dpkg -s perl #TODO habria que evitar lo que imprime esto y evitamos el clear en 2 lineas, ademas seria mas limpio
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

#Verifico si el paquete ya esta instalado
if [ -e "$CONFDIR/AFINSTAL.cnfg" ]
then
	echo "El paquete ya fue instalado, no es necesario seguir."
	exit 1
fi
