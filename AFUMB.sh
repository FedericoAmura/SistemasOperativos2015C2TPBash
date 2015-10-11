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

source MoverA.sh
source GraLog.sh
LOGDIR="$PWD/log"
LOGSIZE=50
LOGEXT=log

validarRegistro() {
	registro=$1
	#valido agente
	validaAgente=$(validarAgente $registro) 
	if [ $validaAgente -eq 0 ]
	then	
		validaArea=$(validarArea $registro)
		if [ $validaArea -eq 0 ]
		then
			echo 0
			return		
		else
			echo 1
			return
		fi
	else
		echo 1
		return
	fi
}

validarAgente() {

	agente=$(echo "$1" | cut -d';' -f1)
	#buscar el agente en el maestro de agentes.
	existe=$(grep "$agente" "$MAE_AGENTES") 
	agente_encontrado=$(echo "$existe" | cut -d ';' -f 3)
	if [ "$agente" != "$agente_encontrado" ]
	then
		echo 1
		return
	fi
	#valido ok  
	echo 0
}

validarArea() {
	area=$(echo "$1" | cut -d';' -f4)
	#buscar area en el maestro de codigo de areas
	existe_area=$(grep -w "$area" "$MAE_COD_AREA_ARG") 
	area_encontrada=$(echo "$existe_area" | cut -d ';' -f 2)
	if [ "$area" = "$area_encontrada" ]
	then
		echo 0
		return
	fi
	echo 1
}

###Principal###

MAE_COD_PAIS=$2
#MAE_COD_AREA_ARG=$3
MAE_COD_AREA_ARG="../master/CdA"  #TODO-BORRAR ES SOLO PARA PROBAR
MAE_CENTRAL=$4
#MAE_AGENTES=$5 
MAE_AGENTES="../master/agentes"  #TODO-BORRAR ES SOLO PARA PROBAR
TAB_TIPO_LLAMADAS=$6
TAB_UMB_CONS=$7

#DIRECTORIO_ACEP=$ACEPDIR #Obtengo el directorio donde se almacenan los archivos aceptados.
#DIRECTORIO_PROC=$PROCDIR #Obtengo el directorio donde se almacena los archivos procesados
#DIRECTORIO_RECH=$RECHDIR #Obtnego el directorio de archivos rechazados.
DIRECTORIO_ACEP="$PWD/acep" #TODO- borrar es solo para probar.
DIRECTORIO_PROC="$PWD/proc" #TODO- borrar es solo para probar.
DIRECTORIO_RECH="$PWD/rech" #TODO- borrar es solo para probar.

#Calculo la cantidad de arhivos a procesar.

cant=$(ls $DIRECTORIO_ACEP | wc -l)

#INICIALIZO EL LOG

GraLog AFUMB INFO "Inicio de AFUMB"
GraLog AFUMB INFO "Cantidad de archivos a procesar: $cant"

#PROCESAR ARCHIVOS EN ORDEN CRONOLOGICO, DEL MAS ANTIGUO AL MAS NUEVO
#1
for FILE in `ls $DIRECTORIO_ACEP`    #TODO - falta agregar que tome el archivo mas antiguo
do
	path_origen=$DIRECTORIO_ACEP"/"$FILE
	GraLog AFUMB INFO "Proceso: $FILE"
	echo "Proceso $FILE"
	arch=""
	#2
	#Verifico que el archivo no este duplicado
	ls -1 $DIRECTORIO_PROC > "$DIRECTORIO_PROC/nombres_archivos.tmp"

	arch=`grep "$FILE" "$DIRECTORIO_PROC/nombres_archivos.tmp"`	

	#echo "ARCHVO A BUSCAR $arch"
	path_destino_rech=$DIRECTORIO_RECH"/"$FILE
	
	if [ "$arch" = "$FILE" ]
	then
		#archivo duplicado mover a rechazados
		#echo "archivo duplicado: $FILE"
		MoverA $path_origen $path_destino_rech
		GraLog AFUMB INFO "Se rechaza el archivo por estar duplicado: $FILE"
		exit 1
	fi
	
	#Verifico la cantidad de campos del primer registro
	linea=$(head -1 $path_origen)
	cant_de_campos=$((`echo "$linea" | grep -o ';' | wc -l` + 1))	
	
	if [ $cant_de_campos -ne 8 ]
	then
		#archivo con formato invalido
		#echo "archivo formato invalido $FILE"		
		MoverA $path_origen $path_destino_rech
		GraLog AFUMB INFO "Se rechaza el archivo porque su estrutura no se corresponde con el formato esperado: $FILE"
		exit 1
	fi
	
	#3
	GraLog AFUMB INFO "Archivo a procesar: $FILE"
	
	#4
	#PROCESAR UN REGISTRO
	#VALIDAR LOS CAMPOS DEL REGISTRO

	contLeidos=0
	contAcep=0
	contRech=0

	while read linea
	do
		let contLeidos=$contLeidos+1
		#echo "Linea a procesar: $linea"
		validaRegistro=$(validarRegistro $linea)
		if [ $validaRegistro -eq 0 ]
		then
			echo "registro valido"
			#continuar	

		fi 
	done < $path_origen
	echo "fin proceso archivo"
	path_destino_proc=$DIRECTORIO_PROC"/"$FILE
	#archivo procesado
	#MoverA $path_origen $path_destino_proc
	GraLog AFUMB INFO "archivo procesado $FILE"

done
