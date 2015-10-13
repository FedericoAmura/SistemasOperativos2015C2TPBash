#!/usr/bin/perl

use strict;
use warnings;
use Switch;
use Date::Parse;
my $key = '';
my $file = 0;

#ARCHIVO=AFLIST.pl 
#USO: AFLIST.pl ARGUMENTO_1 [ARGUMENTO_2]"
#OBJETIVO=Visualizacion de informes y estadisticas para 
#         llamadas sospechosas.
#ARGUMENTO 1= -r /Consultas de llamadas sospechosas
#             -s /Ranking de llamadas sospechosas
#             -h /Muestra la ayuda por pantalla
#ARGUMENTO 2= -w /OPCIONAL. Si existe, escribe en un archivo el resultado
#USO: AFLIST.pl -r/s/h [-w]"

#verifica si no hay otro AFLIST en ejecucion
#TODO

#verifica que la inicializacion de ambiente este realizada
#TODO

# obtiene los comandos desde los argumentos
my $arg_0=$ARGV[0];
my $arg_1=$ARGV[1];
my $uso_prog="USO: $0 -r|s|h [-w]";
# valida la cantidad de argumentos recibidos por linea de comando
my $num_args = $#ARGV + 1;

#valida que haya al menos un argumento
if ($num_args == 0) 
{
    print "\nDebe pasar al menos un argumento. ".$uso_prog."\n";
    exit;
}
#valida que la cantidad de argumentos no sea mayor a 2
if ($num_args > 2) 
{
    print "\nMas argumentos [$num_args] de los permitidos. ".$uso_prog."\n";
    exit;
}

#valida que el 2do argumento sea -w
if ($num_args == 2) 
{
	if ($arg_1 ne "-w")
	{
	   print "\nArgumento invalido [$arg_1]. ".$uso_prog."\n";
	   exit;	
	}
	else
	{
	   $file = 1;
	}
}

# muestra el menu
    switch ($arg_0)
    {
        case "-r" 
        {
			print "ejecutando opcion -r...\n";
			#valida que el segundo argumento no sea distinto a -w
			menu_r();
	}
	case "-s"
	{
			print "ejecutando opcion -s...\n";	
			menu_s();
	}
	case "-h"
	{
			print 
			       "#AYUDA $0 \n".
			       "#OBJETIVO=Visualizacion de informes y estadisticas para llamadas sospechosas.\n".	      		
			       "#USO: $0 ARGUMENTO_1 [ARGUMENTO_2]\n".
			       "#ARGUMENTO 1= -r /Consultas de llamadas sospechosas\n".
			       "#             -s /Ranking de llamadas sospechosas\n".
			       "#             -h /Muestra ayuda por pantalla\n".
			       "#ARGUMENTO 2= -w /OPCIONAL. Si existe, escribe en un archivo el resultado\n".
			       "#".$uso_prog."\n"
			       
			       ;			
	}
	else{
			print "\nArgumento invalido. ".$uso_prog."\n";
			exit;
	}		
   }

exit(0);

#MENU PRINCIPAL opcion -r [consultas]
sub menu_r
{

my $origen = "";
my @oficinas;
my @aniomes;
my $subllamadas = 0;
my @subllamadas;

clear_screen();
print "Bienvenido al generador de informes de llamadas.\n\n";
$origen = definir_origen();
print "Origen".$origen."\n";
@oficinas = definir_oficinas();
@aniomes = definir_aniomes();
@subllamadas = definir_subllamadas_origen();
#realizar_informe();

} #end menu_r

sub definir_origen
{
	my $input = '';

	while ($input ne '0')
	{
		print "\n";
		print "Ingrese sobre que informacion desea generar informes:\n";
		print "1.Sobre los archivos de llamadas sospechosas.\n";
		print "2.Sobre los informes previos.\n";
		print "0.Salir\n";

		print "Ingresar una opcion: ";
		$input = <STDIN>;
		chomp($input);

		switch($input)
		{
			case "1"
			{
				return($ENV{'PROCDIR'});
			}
			case "2"
			{
				return($ENV{'REPODIR'});
			}
			case "0"
			{
				exit;
			}
		}
	}
}

sub definir_oficinas
{	
	my @retval;
	my $input = '';
	print "Ingrese los codigos de oficina que quiere incluir en su reporte.\n";
	print "Si no ingresa ninguna, se incluiran todas.\n";
	print "Para terminar, ingrese 0.\n";
	while ($input ne "0")
	{
		$input = <STDIN>;
		chomp($input);
		push(@retval, $input);
	}
	return @retval;
}

sub definir_aniomes
{
	my @retval;
	my $input = '';
	print "Ingrese los aniomeses que quiere incluir en su reporte.\n";
	print "Si no ingresa ninguno, se incluiran todos.\n";
	print "Para terminar, ingrese 0.\n";
	while ($input ne "0")
	{
		$input = <STDIN>;
		chomp($input);
		push(@retval, $input);
	}
	return @retval;
}

sub definir_subllamadas_origen
{
my @retval;
	my $input = '';
	print "Ingrese los reportes de origen que quiere incluir en su reporte.\n";
	print "Si no ingresa ninguno, se incluiran todos.\n";
	print "Para terminar, ingrese 0.\n";
	while ($input ne "0")
	{
		$input = <STDIN>;
		chomp($input);
		push(@retval, $input);
	}
	return @retval;
}

sub realizar_informe
{
	emitir_informe();
}

sub emitir_informe
{
	if ($file)
	{
		print "Estadisticas del informe\n";
		print "Exportando a archivo...\n";
		my $filename = 'subllamada.' . $file;
		open(my $file_reporte, '>>', $filename) or die "No se pudo generar el archivo: '$filename' $!" ;
		print $file_reporte "una cadena de prueba";
		close $file_reporte;
		$file += 1;
		print "Exportado con exito\n";
	}
	else
	{
		print "Estadisticas y header del informe\n";
		print "File vale: ".$file."\n";
		print "una cadena de prueba\n";
	}
}


#MENU PRINCIPAL opcion -s [estadisticas]
sub menu_s
{
my $input = '';
my $input_opt = '';

while ($input ne '0')
{
    clear_screen();

    print  "Ingrese la opcion que desea conocer:\n". 
	   "1.Cuál es la central con mayor cantidad de llamadas sospechosas?\n".
           "2.Cuál es la oficina con mayor cantidad de llamadas sospechosas?\n". 
           "3.Cuál es el agente con mayor cantidad de llamadas sospechosas?\n". 
           "4.Cuál es el destino con mayor cantidad de llamadas sospechosas?\n". 
           "5.Cuál es el ranking de umbrales?\n".
           "0.Salir\n";

    print "Ingresar una opcion: ";
    $input = <STDIN>;
    chomp($input);

    switch ($input)
    {
		#opciones 1,2,3 filtro por llamadas o por segundos
        case ["1","2","3"] 
        {
            $input_opt = '';

            while ($input_opt ne "3")
            {
                clear_screen();

                print "Seleccione un filtro\n".
                      "1.Por cantidad de llamadas\n".
                      "2.Por cantidad de segundos\n".
                      "3.Volver al menu principal\n";

                print "Seleccionar filtro: ";
                $input_opt = <STDIN>;
                chomp($input_opt);   
            
                if ($input_opt ne "3") {
	                if ($input=="1") {
						f_1_central_cantidad_llam_sosp($input_opt);
	                    print "Presione una tecla para continuar...\n";
	                    $input_opt = <STDIN>;  
	                    chomp($input_opt);					
					}elsif ($input=="2") {
						f_2_ofi_cantidad_llam_sosp($input_opt);
						print "Presione una tecla para continuar...\n";
	                    $input_opt = <STDIN>;  
	                    chomp($input_opt);
					}elsif ($input=="3") {
						f_3_agente_cantidad_llam_sosp($input_opt);
					    print "Presione una tecla para continuar...\n";
	                    $input_opt = <STDIN>;  
	                    chomp($input_opt);				   				     
					} 
				}
						
            print "valor input $input input_opt $input_opt\n";
            #presione_tecla_para_continuar();
                       
            }
            $input = '';  
            $input_opt = '';
        }
        case "4"
        {
		f_4_destino_llam_sospechosa();
		
		$input = '';
		}
        case "5"
        {
		f_5_ranking_umbrales();		
		
		$input = '';
		}
    }
}

}#end menu_s



#subrutinas opcion -s [estadisticas]
sub f_1_central_cantidad_llam_sosp
{
	print "llamando..f_1_central_cantidad_llam_sosp\n";
	my ($h_central1, $h_central2) = &filtrarCentralPorCantidadDeLlamadasSospechosas;
	if ($_[0] == "1"){
		print "con filtro por cantidad de llamadas\n";	
		print "Central            Cantidad de llamadas\n";	
		&imprimirFiltroCentral(%{$h_central1});
	}
	if ($_[0] == "2"){
		print "con filtro por cantidad de segundos\n";
		print "con filtro por cantidad de segundos\n";
		print "Central            Cantidad de segundos\n";	
		&imprimirFiltroCentral(%{$h_central2});	
	}
	
}

sub f_2_ofi_cantidad_llam_sosp
{
	print "llamando..f_2_ofi_cantidad_llam_sosp\n";
	my ($h_oficina1, $h_oficina2) = &filtrarOficinaPorCantidadDeLlamadasSospechosas;
	if ($_[0] == "1"){
		print "con filtro por cantidad de llamadas\n";
		print "Oficina        Cantidad de llamadas\n";
		&imprimirFiltroOficina(%{$h_oficina1});	
	}
	if ($_[0] == "2"){
		print "con filtro por cantidad de segundos\n";
		print "Oficina        Cantidad de segundos\n";
		&imprimirFiltroOficina(%{$h_oficina2});		
	}
}

sub f_3_agente_cantidad_llam_sosp
{
	print "llamando..f_3_agente_cantidad_llam_sosp\n";
	if ($_[0] == "1"){
	print "con filtro por cantidad de llamadas\n";	
	}
	if ($_[0] == "2"){
	print "con filtro por cantidad de segundos\n";	
	}
	my %age;
	my @reg;
    my $sec;
    my $min;
    my $hora;
    my $dia;
    my $mes;
    my $anio;
	($sec,$min,$hora,$dia,$mes,$anio)=localtime;    
    $anio+=1900;
    $mes++;
	my $fecha = $anio.$mes.$dia."_".$hora.$min.$sec;
    my $input_periodo='';
    my $fecha_ok="N";	
	
	opendir (DIR,"./proc/") || die "Error el directorio no existe\n";
	my @indice = readdir(DIR);
	closedir(DIR);

    while ($input_periodo eq '' && $fecha_ok eq "N")
    {
    print "Ingrese el periodo a filtrar YYYY o YYYYMM: ";
    $input_periodo = <STDIN>;
    chomp($input_periodo);	
	    if ($input_periodo !~ /(\d{4})(\d\d)/  ||  $input_periodo !~ /(\d{4})/) {
	    print "Error al ingresar fecha: [YYYY] o [YYYYMM]\n";    
	    }
	    else { 
		$fecha_ok="S";
	    }
    }        
    
    foreach my $archivos (@indice)
	{
	 next unless ($archivos =~ /$input_periodo\.csv$/);
	 print "procesando...". $archivos ."\n";

		open (ENT,"<./proc/".$archivos) || die "Error: No se pudo abrir ".$archivos ."\n";
	    while (<ENT>)
	    {
		chomp($_);	
		@reg=split(";",$_);
		if ($_[0] == "1"){ #filtro por cantidad de llamadas
			$age{$reg[1]}+=1; 
		}
		if ($_[0] == "2"){ # filtro por cantidad de segundos
			$age{$reg[1]}+=$reg[5]; 	
		}
		}
        close (ENT);
    }#foreach
    
    
	if ( $file eq 1 ) #escribe en archivo?
	{
	open (SAL,">estad_".$fecha.".csv");
    }
	#foreach (keys (%age))
    #	my $linea;
    #   foreach $linea (sort { $age{$a} <=> $age{$b} } keys %age)
    foreach (sort { $age{$a} <=> $age{$b} } keys %age)	
	{
		if ( $file eq 1 )
		{
		print SAL $_.";".$age{$_} ."\n";
		#print SAL  $linea .";" . $age{$linea}."\n";
		} else 
		{
		print $_.";".$age{$_} ."\n";
		}
	};
    
    if ( $file eq 1 )
	{
	    print "se genero estad_".$fecha.".csv\n";
	    close (SAL);
    } 
	
	
	
}


sub f_4_destino_llam_sospechosa
{
	print "llamando..f_4_destino_llam_sospechosa\n";
}

sub f_5_ranking_umbrales
{
	print "llamando..f_5_ranking_umbrales\n";
}

#subrutinas generales
sub clear_screen
{
    system("clear");
}

sub presione_tecla_para_continuar {
    print "Presione una tecla para continuar...\n";
    $key = <STDIN>;
    chomp($key);
}
####################################################
# campos: (código_país; nombre_país)
sub cargarCodigosDePais(){
	my (%hash_CdP);
	my (@registro);
	open(ENTRADA,"<master/CdP") || die "ERROR: No se encontró archivo maestro CdP.\n";

	while (my $linea = <ENTRADA>){
		chomp($linea);
		@registro = split(";",$linea); 
		$hash_CdP{$registro[0]} = $registro[1];
	}
	close(ENTRADA);
	return %hash_CdP;
}

# campos: (nombre_área; código_área)
sub cargarCodigosDeArea(){
	my (%hash_CdA);
	my (@registro);
	open(ENTRADA,"<master/CdA") || die "ERROR: No se encontró archivo maestro CdA.\n";

	while (my $linea = <ENTRADA>){
		chomp($linea);
		@registro = split(";",$linea); 
		$hash_CdA{$registro[1]} = $registro[0];
	}
	close(ENTRADA);
	return %hash_CdA;
}

# campos: (código_central; descripción)
sub cargarCodigosDeCentrales(){
	my (%hash_CdC);
	my (@registro);
	open(ENTRADA,"<master/CdC") || die "ERROR: No se encontró archivo maestro CdC.\n";

	while (my $linea = <ENTRADA>){
		chomp($linea);
		@registro = split(";",$linea); 
		$hash_CdC{$registro[0]} = $registro[1];
	}
	return %hash_CdC;
}

# campos: (id_agente; nombre_agente; apellido_agente; oficina; email)
sub cargarCodigosDeAgentes(){
	my (%hash_agentes);
	my (@info_agentes);
	open(ENTRADA,"<master/agentes") || die "ERROR: No se encontró archivo maestro agentes.\n";

	while (my $linea = <ENTRADA>){
		chomp($linea);
		@info_agentes = split(";",$linea); 
		$hash_agentes{$info_agentes[0]} = @info_agentes;
	}
	return %hash_agentes;
}

# Central con mayor cantidad de llamadas sospechosas (cantidad ó tiempo)
# Devuelve un arreglo con 2 hashes (cantidad ó tiempo)
sub filtrarCentralPorCantidadDeLlamadasSospechosas(){
	# 2 hashes para guardar por cantidades(#) y por segundos(tiempo) de llamadas sospechosas.
	my (%hash_centrales_cant, %hash_centrales_seg);
	my ($dir) = "proc"; # esta hardcodeado, debería ir $PROCDIR

	if (opendir(DIRH,"$dir")){
		@archivos=readdir(DIRH);
		closedir(DIRH);
	}

	foreach my $file (@archivos){
		next if ($file eq "." || $file eq "..");
		open(ARCH,"<$dir/$file") || die "ERROR: No se pudo abrir el archivo $file.\n";

		# Para cada registro del archivo, tomamos el campo "id_central" y "tiempoConversación"
		# y actualizamos los hashes
		while (my $registro = <ARCH>) {
			chomp($registro);
			my (@a_registro) = split(";",$registro);
			$hash_centrales_cant{$a_registro[0]} += 1;
			$hash_centrales_seg{$a_registro[0]} += $a_registro[4];
		}
		close(ARCH);
	}
	# Se van a devolver los 2 hashes en un vector (por una cuestión de eficiencia)
	return (\%hash_centrales_cant, \%hash_centrales_seg);
}

# Oficina con mayor cantidad de llamadas sospechosas (cantidad ó tiempo)
# Devuelve un arreglo con 2 hashes (cantidad ó tiempo)
sub filtrarOficinaPorCantidadDeLlamadasSospechosas(){
	# 2 hashes para guardar por cantidades(#) y por segundos(tiempo) de llamadas sospechosas.
	my (%hash_oficina_cant, %hash_oficina_seg);
	my ($dir) = "proc"; # esta hardcodeado, debería ir $PROCDIR

	if (opendir(DIRH,"$dir")){
		@archivos=readdir(DIRH);
		closedir(DIRH);
	}

	foreach my $file (@archivos){
		next if ($file eq "." || $file eq "..");
		open(ARCH,"<$dir/$file") || die "ERROR: No se pudo abrir el archivo $file.\n";
		
		# En el nombre del archivo esta el identificador de la oficina
		@campos = split("_",$file);
		$hash_oficina_cant{$campos[0]} += 1;

		# Para todos los registros del archivo, tomo el tiempo de conversación
		while (my $registro = <ARCH>) {
			chomp($registro);
			my @a_registro = split(";",$registro);
			$hash_oficina_seg{$a_registro[0]} += $a_registro[4];
		}
		close(ARCH);
	}
	# Se van a devolver los 2 hashes en un vector (por una cuestión de eficiencia)
	return (\%hash_oficina_cant, \%hash_oficina_seg);
}

sub imprimirFiltroCentral(){
	# El primero hash contiene para cada id un valor acumulado (ej: [id_central, cant_llamadas])
	# El segundo hash contiene para cada id el valor propiamente dicho (ej: [id_central, central])
	my (%h_data) = @_;
	my (@claves) = keys(%h_data);
	my (%h_info) = cargarCodigosDeCentrales;

	foreach my $key (@claves){
		print $h_info{$key}."      ".$h_data{$key}."\n";
	}
}

sub imprimirFiltroOficina(){
	# El primero hash contiene para cada id un valor acumulado (ej: [id_central, cant_llamadas])
	my (%h_data) = @_;
	my (@claves) = keys(%h_data);

	foreach my $key (@claves){
		print $key."            ".$h_data{$key}."\n";
	}
}
