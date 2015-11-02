AFRA-J

Instrucciones de instalacion
===============================================================================

  Instalacion - Linux
  ------------------------------------------------------------------------------
  1. Extraer el archivos de distribucion AFRA-J, en el directorio donde desea 
  	instalar el sistema {installHome}.  
     
  2. Abrir una terminal y diregirse a "{installHome}/bin" y ejecutar:

       ./AFINSTALL.sh

       para iniciar la instalacion.

  3. [OPCIONAL] Modificar su PATH de ambiente de modo de instalar AFRA-J
  	  desde cualquier directorio #Completar 

  4. 
  
  5.

  ------------------------------------------------------------------------------

Instrucciones de inicialización de ambiente
===============================================================================  
  Objetivo del comando: Preparar el entorno de ejecución del programa, inicializando
  variables que serán utilizadas por diferentes comandos, verificación de archivos maestros
  y verificación de ejecutables.

  Aclaraciones: 
    - El usuario no puede inicializar el ambiente si ya ha sido inicializado
      previamente.
    - El usuario tiene la opción de arrancar el Demonio, desde este comando, si es que lo desea.


  1. Abrir la terminal y dirigirse al directorio donde se encuentran los 
     ejecutables.

  2. Ejecutar . AFINI.sh


  ------------------------------------------------------------------------------


  Instrucciones para arrancar y detener el Demonio
===============================================================================  
# Agregar como arrancar desde ARRANCAR.sh

      Ejecutar
          bash ARRANCAR.sh


      
      detener un proceso
      bash  DETENER.sh ARRANCAR.sh

  ------------------------------------------------------------------------------


    Instrucciones para la obtención de informes y estadísticas
=============================================================================== 
  Objetivo del comando: Obtención de informes y estadísticas sobre llamadas sospechosas

  Aclaraciones:
    - El comando se puede ejecutar desde cualquier directorio.
    - No se puede ejecutar el comando si ya hay uno corriendo.

  Formas de ejecutar el comando:

  1. AFLIST.pl -h
     Comando de ayuda

  2. AFLIST.pl -r
     Este comando permite realizar consultas sobre uno o mas archivos de llamadas sospechosas ó
     sobre los archivos de consultas previas. Posee un segundo argumento (-w), opcional, si se desea 
     guardar el resultado de la consulta.
     AFLIST.pl -r -w

  3. AFLIST.pl -s
     Este comando permite realizar estadísticas sobre uno o mas archivos de llamadas sospechosas.
     Posee un segundo argumento (-w), opcional, si se desea guardar el resultado de la consulta.
     AFLIST.pl -s -w

  ------------------------------------------------------------------------------
Enjoy!

-AFRA-J Development Team
