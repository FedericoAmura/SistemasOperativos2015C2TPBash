# ================================================================================================
# INTEGRACION DEL SISTEMA AFRA-J
# 	Objetivo: Tener en cuenta la estructura de del sistema antes y despues de la instalacion
#	para poder eliminar las variables HARDCODEADAS.
#
# ================================================================================================

# 1) Crear paquete de instalacion AFRA-j.zip
	#Ejecutar:
		$ bash compose -pack

# 2) Mover el archivo AFRA-J.zip a un directorio para la instalacion.

	#  AL EXTRAER EL PAQUETE PARA LA INSTALACION
	# =============================================================================================

	# Crea el siguiente arbol de directorio:
		#├── AFRA-J
		#│   ├── AFINI.sh
		#│   ├── AFINSTAL.sh
		#│   ├── AFLIST.pl
		#│   ├── AFREC.sh
		#│   ├── AFUMB.sh
		#│   ├── ARRANCAR.sh
		#│   ├── DETENER.sh
		#│   ├── GraLog.sh
		#│   ├── MoverA.sh
		#│   └── README.md
		#│   ├── conf  #INFO: este path el usuario no lo puede modificar
		#│   ├── data  #INFO: todos los archivos que luego de la instalacion, se mueven a $MAEDIR, $NOVEDIR, etc.
		#│   │   ├── archivoDeLlamadasSospechosas
		#│   │   ├── BEL_20150703
		#│   │   ├── BEL_20150803
		#│   │   ├── co_central.rech
		#│   │   ├── COS_20150703
		#│   │   ├── COS_20150803
		#│   │   ├── SIS_20150703.csv
		#│   │   └── SIS_20150803.csv
		


# 3) Iniciar la instalacion del sistema.
	# Ejecutar:
		$ bash AFINSTALL.sh -start

	#  EL USUARIO INICIA LA INSTALACION DEL SISTEMA AFRA-J
	# =============================================================================================

	# Al momento de la instalacion el usuario puede elegi el path de los 
	# siguientes directorios.
		# $BINDIR, $MAEDIR, $NOVEDIR, $ACEPDIR, $PROCDIR, $REPODIR, $LOGDIR, $RECHDIR, 
		# Si el usuario no cambia el path de estos directorios se carga un valor por defecto.
		# Estos campos se cargan con los archivos que se encuentran en /data luego de la instalacion.

	# El usuario podria elegir por ejemplo el siguiente path para $BINDIR=/mar/aton/buenos/aires/bin
	# El arbol de directorio quedaria:
		#├── AFRA-J
		#│   ├── conf
		#│   │   ├── AFINSTAL.cnfg
		#│   │   └── AFINSTAL.lg
		#│   ├── data
		#│   ├── mar
		#│   │   └── aton
		#│   │       └── buenos
		#│   │           └── aires
		#│   │               └── bin
		#│   │                   ├── AFINI.sh
		#│   │                   ├── AFINSTAL.sh
		#│   │                   ├── AFLIST.pl
		#│   │                   ├── AFREC.sh
		#│   │                   ├── AFUMB.sh
		#│   │                   ├── ARRANCAR.sh
		#│   │                   ├── DETENER.sh
		#│   │                   ├── GraLog.sh
		#│   │                   └── MoverA.sh
		#│   ├── $MAEDIR/mae
		#│   ├── $NOVEDIR/novedades
		#│   ├── $ACEPDIR/aceptadas
		#│   ├── $PROCDIR/sospechosas
		#│   ├── $REPODIR/reportes
		#│   ├── $LOGDIR/log
		#│   ├── $RECHDIR/rechazadas
		#│   └── README.md


# PARA EL CORRECTO FUNCIONAMIENTO E INTEGRACION DE LOS SCRIPTS INTERNOS DEBEN TOMAR EL VALOR 
# DE LAS SIGUIENTAS VARIABLES:
	# $BINDIR, $MAEDIR, $NOVEDIR, $ACEPDIR, $PROCDIR, $REPODIR, $LOGDIR, $RECHDIR, 

# NOTA: Si falta algo o algo esta mal, por favor avisen y se corrige. 






