#!/bin/bash
source GraLog.sh #incorporamos las funciones definidas en GraLog.sh
LOGDIR="$PWD/log"
LOGSIZE=50
LOGEXT=log

#USO: GraLog Donde Porque Que
GraLog AFINSTALL "No funciona" ERR
GraLog AFINI "Algo pasa" INFO
GraLog AFUMB "No se" WAR
