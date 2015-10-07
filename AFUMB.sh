#!/bin/bash
#
####################################### AFUMB ##########################################################################
#                                                                                                                      #
# Parámetros entrada:  (LISTA_ARCH_ACEP, MAE_COD_PAIS, MAE_COD_AREA_ARG, MAE_CENTRAL, MAE_AGENTES, TAB_TIPO_LLAMADAS,  #
#	                TAB_UMB_CONS)                                                                                  #
# Parámetros salida:   (ARCH_LLAM_SOSP, ARCH_PROC, ARCH_REG_RECH, ARCH_RECH, LOG_COMANDO                               # #	                                                                                                               #
# LISTA_ARCH_ACEP: Archivos de llamadas aceptadas                                                                      #
# MAE_COD_PAIS: Maestro de códigos de país.                                                                            #
# MAE_COD_AREA_ARG: Maestro de códigos de área de Argentina.                                                           #
# MAE_CENTRAL: Maestro de centrales.                                                                                   #
# MAE_AGENTES: Maestro de Agentes.                                                                                     #
# TAB_TIPO_LLAMADAS: Tabla de tipos de llamadas.                                                                       #
# TAB_UMB_CONS: Tabla de umbrales de consumo.                                                                          #
# ARCH_LLAM_SOS: Archivos de llamadas sospechosas.                                                                     #
# ARCH_PROC: Archivos procesados.                                                                                      #
# ARCH_REG_RECH: Archivos de registros rechazados.                                                                     #
# ARCH_RECH: Archivos rechazados.                                                                                      #
# LOG_COMANDO: Log del comando                                                                                         #
#                                                                                                                      #
########################################################################################################################

DIRECTORIO_ACEP=$ACEPDIR #Obtengo el directorio donde se almacenan los archivos aceptados.
DIRECTORIO_PROC=$PROCDIR #Obtengo el directorio donde se almacena los archivos procesados
DIRECTORIO_RECH=$RECHDIR #Obtnego el directorio de archivos rechazados.

#Calculo la cantidad de arhivos a procesar.

cant=$(ls $DIRECTORIO_ACEP | wc -l)

#INICIALIZO EL LOG

bash ./GraLog.sh AFUMB I "Inicio de AFUMB"
bash ./GraLog.sh AFUMB I "Cantidad de archivos a procesar: $cant"

#PROCESAR ARCHIVOS EN ORDEN CRONOLOGICO, DEL MAS ANTIGUO AL MAS NUEVO
#1
for FILE in `ls $DIRECTORIO_ACEP`    #TODO - falta agregar que tome el archivo mas antiguo
do
	path_origen=$DIRECTORIO_ACEP"/"$FILE
	bash ./GraLog.sh AFUMB I "Proceso: $FILE"
	echo "Proceso $FILE"
	
	arch=""
	
	#2
	#Verifico que el archivo no este duplicado
	ls -1 $DIRECTORIO_PROC > "$DIRECTORIO_PROC/nombres_archivos.tmp"

	arch=`grep "$FILE" "$DIRECTORIO_PROC/nombres_archivos.tmp"`	

	echo "ARCHVO A BUSCAR $arch"
	path_destino_rech=$DIRECTORIO_RECH"/"$FILE
	

	if [ "$arch" = "$FILE" ]
	then
		#archivo duplicado mover a rechazados
		echo "archivo duplicado: $FILE"
		source MoverA.sh
		MoverA $path_origen $path_destino_rech
		bash ./GraLog.sh AFUMB I "Se rechaza el archivo por estar duplicado: $FILE"
		exit 1
	fi
	
	#Verifico la cantidad de campos del primer registro
	linea=$(head -1 $path_origen)
	cant_de_campos=$((`echo "$linea" | grep -o ';' | wc -l` + 1))	
	
	if [ $cant_de_campos -ne 8 ]
	then
		#archivo con formato invalido
		echo "archivo formato invalido $FILE"		
		source MoverA.sh
		MoverA $path_origen $path_destino_rech
		bash ./GraLog.sh AFUMB I "Se rechaza el archivo porque su estrutura no se corresponde con el formato esperado: $FILE"
		exit 1
	fi
	
	bash ./GraLog.sh AFUMB I "Archivo a procesar: $FILE"
	
	#3
	path_destino_proc=$DIRECTORIO_PROC"/"$FILE

	#archivo procesado
	source MoverA.sh
	MoverA $path_origen $path_destino_proc
	bash ./GraLog.sh AFUMB I "archivo procesado $FILE"
done
