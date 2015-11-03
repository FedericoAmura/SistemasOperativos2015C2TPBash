#!/usr/bin/perl

#use strict;
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

#verifica que la inicializacion de ambiente este realizada
if ("$ENV{'GRUPO'}" eq ""){
	print "El ambiente no fue inicializado. Por favor, corra AFINI y vuelva a intentarlo.\n";
	exit(1);
}

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
	my @subllamadas;
	my @archivos;
	my @archivosDir;
	my $input = '';
	my $aux = '';
	my @preInforme;
	my @informe;

	clear_screen();

	print "Bienvenido al generador de informes de llamadas.\n\n";

	while ($input ne '0')
	{
		undef(@oficinas);
		undef(@aniomes);
		undef(@subllamadas);
		undef(@archivos);
		undef(@archivosDir);
		undef(@aniomes);
		undef(@preInforme);
		undef(@informe);
		
		print "\n";
		print "Ingrese sobre que informacion desea generar informes:\n";
		print "1.Sobre los archivos de llamadas sospechosas.\n";
		print "2.Sobre los informes previos.\n";
		print "0.Salir\n";

		print "Ingresar una opcion: ";
		$input = <STDIN>;
		chomp($input);

		switch ($input)
		{
			case "1"
			{
				print "Ingreso archivos procesados.\n\n";
				$origen = "$ENV{'PROCDIR'}";
				@archivosDir = &getArchivosDir("$ENV{'PROCDIR'}");
				@oficinas = &filtrar_oficinas(@archivosDir);
				@archivos = &filtrar_aniomes(@oficinas);
			}
			case "2"
			{
				print "Ingreso informes previos.\n\n";
				$origen = "$ENV{'REPODIR'}";
				@archivos = definir_subllamadas_origen();
			}
			case "0"
			{
				exit;
			}
		}
		
		foreach(@archivos)
		{
			print "Preparando archivo: ".$_.". ";
			open (ENT,"<$origen/$_") || die "Error: No se pudo abrir ".$_ ."\n";
			print "Abierto.\n";
			while (my $linea = <ENT>){
				chomp($linea);
				push(@preInforme,$linea);
			}
		}
		
		print "\n";
		print "Ingrese cual es el filtro que desea aplicar:\n";
		print "1.Filtro por central.\n";
		print "2.Filtro por agente.\n";
		print "3.Filtro por umbral.\n";
		print "4.Filtro por tipo de llamada.\n";
		print "5.Filtro por tiempo de conversacion.\n";
		print "6.Filtro por numero A.\n";
		print "7.Filtro por numero B.\n";
		print "0.Salir\n";

		print "Ingresar una opcion: ";
		$input = <STDIN>;
		chomp($input);
		
		switch ($input)
		{
			case "1"
			{
				print "Ingreso filtro por central.\n\n";
				@informe = &filtrarInforme("Ingrese los ID de las centrales que quiere incluir en su reporte.",0,@preInforme);
			}
			case "2"
			{
				print "Ingreso filtro por agente.\n\n";
				@informe = &filtrarInforme("Ingrese los ID de agentes que quiere incluir en su reporte.",1,@preInforme);
			}
			case "3"
			{
				print "Ingreso filtro por umbral.\n\n";
				@informe = &filtrarInforme("Ingrese los ID de umbrales que quiere incluir en su reporte.",2,@preInforme);
			}
			case "4"
			{
				print "Ingreso filtro por tipo de llamada.\n\n";
				@informe = &filtrarInforme("Ingrese los ID de tipos de llamada que quiere incluir en su reporte.",3,@preInforme);
			}
			case "5"
			{
				print "Ingreso filtro por tiempo de conversacion.\n\n";
				@informe = &filtrarRangoTiempoConversacion(@preInforme);
			}
			case "6"
			{
				print "Ingreso filtro por numero A.\n\n";
				@preInforme = &filtrarInforme("Ingrese los numeros de area que quiere incluir en su reporte.",6,@preInforme);
				@informe = &filtrarInforme("Ingrese los numeros de telefono que quiere incluir en su reporte.",7,@preInforme);
			}
			case "7"
			{
				print "Ingreso filtro por numero B.\n\n";
				@preInforme = &filtrarInforme("Ingrese los numeros de pais que quiere incluir en su reporte.",8,@preInforme);
				@preInforme = &filtrarInforme("Ingrese los numeros de area que quiere incluir en su reporte.",9,@preInforme);
				@informe = &filtrarInforme("Ingrese los numeros de telefono que quiere incluir en su reporte.",10,@preInforme);
			}
			case "0"
			{
				exit;
			}
		}

		foreach (@archivos){
			close($_);
		}

		&emitir_informe(@informe);

	}
} #end menu_r

sub filtrar_oficinas
{	
	my @filtrar = @_;
	my @filtros;
	my @retval;
	my $input = '';
	print "Ingrese los codigos de oficina que quiere incluir en su reporte.\n";
	print "Si no ingresa ninguna, se incluiran todas.\n";
	print "Para terminar, ingrese 0.\n";
	#ingreso los valores que van a quedar
	while ($input ne "0")
	{
		$input = <STDIN>;
		chomp($input);
		if ( $input ne "0" ){
			push(@filtros, $input);
		}
	}
	
	#veo si quedo vacio y en ese caso dejo todos los que empiezan con XXX
	my $filtros = @filtros;
	if ($filtros==0){
		#filtro las entradas que no sean ^XXX
		foreach(@filtrar){
			if ($_ =~ /^[\w]{3}/){
				push(@retval,$_);
			}
		}
	} else {
		#paso los valores definidos a la devolucion
		foreach(@filtrar){
			$aux=$_;
			foreach(@filtros){
				if ($aux =~ /^\Q$_/){
					push(@retval,$aux);
				}
			}
		}
	}
	return @retval;
}

sub filtrar_aniomes
{
	my @filtrar = @_;
	my @filtros;
	my @retval;
	my $input = '';
	print "Ingrese los aniomes (en formato YYYYMM) que quiere incluir en su reporte.\n";
	print "Si no ingresa ninguna, se incluiran todos.\n";
	print "Para terminar, ingrese 0.\n";
	#ingreso los valores que van a quedar
	while ($input ne "0")
	{
		$input = <STDIN>;
		chomp($input);
		if ( $input ne "0" ){
			push(@filtros, $input);
		}
	}
	#veo si quedo vacio y en ese caso dejo todos los que terminan con aniomes y ext .csv
	my $filtros = @filtros;
	if ($filtros==0){
		#filtro las entradas que no sean YYYYMM.csv$
		foreach(@filtrar){
			if ($_ =~ /[0-9]{4}[01][0-9]\.csv$/){
				push(@retval,$_);
			}
		}
	} else {
		#paso los valores definidos a la devolucion
		foreach(@filtrar){
			$aux=$_;
			foreach(@filtros){
				if ($aux =~ /${_}\.csv$/){
					push(@retval,$aux);
				}
			}
		}
	}
	return @retval;
}

sub definir_aniomes
{
	my @filtrar = @_;
	my @filtros;
	my $input = '';
	print "Ingrese los aniomeses que quiere incluir en su reporte.\n";
	print "Si no ingresa ninguno, se incluiran todos.\n";
	print "Para terminar, ingrese 0.\n";
	while ($input ne "0")
	{
		$input = <STDIN>;
		chomp($input);
		if ( $input ne "0" ){
			push(@filtros, $input);
		}
	}
	return @filtros;
}

sub definir_subllamadas_origen
{
	my @retval;
	my $retval;
	my @aux;
	my $input = '1';
	print "Indique los reportes de origen que quiere incluir en su reporte ingresando los valores numericos que tienen como extension.\n";
	print "Si no ingresa ninguno, se incluiran todos.\n";
	print "Para terminar, ingrese 0.\n";
	while ($input ne "0")
	{
		$input = <STDIN>;
		chomp($input);
		if ( $input ne "0" ){
			push(@retval, "subllamada.".$input);
		}
	}
	$retval = @retval;
	if ($retval==0){
		print "Se ingresaran todas las subllamadas.\n";
		@aux = &getArchivosDir("$ENV{'REPODIR'}");
		foreach(@aux)
		{
			if ($_ =~ /^subllamada\.[0-9]*$/){
					push(@retval,$_);
			}
		}
	}
	return @retval;
}

sub filtrarInforme
{
	my ($texto,$campo,@filtrar) = @_;
	my @filtros;
	my @retval;
	my $input = '';
	my @aux;
	
	print $texto."\n";
	print "Si no ingresa ninguna, se incluiran todos.\n";
	print "Para terminar, ingrese 0.\n";
	#ingreso los valores que van a quedar
	while ($input ne "0")
	{
		$input = <STDIN>;
		chomp($input);
		if ( $input ne "0" ){
			push(@filtros, $input);
		}
	}
	my $filtros = @filtros;
	if ($filtros==0){
		return @filtrar;
	} else {
		#paso los valores definidos a la devolucion
		foreach(@filtrar){
			$aux=$_;
			@reg=split(";",$_);
			foreach(@filtros){
				if ($reg[$campo] eq $_){
					push(@retval,$aux);
				}
			}
		}
	}
	return @retval;
}

sub filtrarRangoTiempoConversacion
{
	my @filtrar = @_;
	my $minimo = 0;
	my $maximo = 0;
	my @retval;
	my $aux;
	
	print "Ingrese el tiempo minimo de llamada que quiere incluir en su reporte.\n";
	$minimo = <STDIN>;
	
	print "Ingrese el tiempo maximo de llamada que quiere incluir en su reporte.\n";
	$maximo = <STDIN>;
	
	while ($minimo>$maximo)
	{
		print "Valores invalidos. El maximo debe ser mayor al minimo.\n";
		
		print "Ingrese el tiempo minimo de llamada que quiere incluir en su reporte.\n";
		$minimo = <STDIN>;
	
		print "Ingrese el tiempo maximo de llamada que quiere incluir en su reporte.\n";
		$maximo = <STDIN>;
	}
	
	#paso los valores definidos a la devolucion
	foreach(@filtrar){
		$aux=$_;
		@reg=split(";",$aux);
		if ($reg[5] >= $minimo && $reg[5] <= $maximo){
			push(@retval,$aux);
		}
	}
	return @retval;
}

sub emitir_informe
{
	my @informe = sort @_;
	my $informe = @informe;
	my @archivosDir;
	if ($file)
	{
		@archivosDir = &getArchivosDir("$ENV{'REPODIR'}");
		if ($file == 1){
			foreach(@archivosDir){
				if ($_ =~ /^subllamada/){
					$file += 1;
				}
			}
		}
		print "Estadisticas del informe\n";
		print "Entradas finales: ".$informe."\n\n";
		print "Exportando a archivo...\n";
		my $filename = 'subllamada.' . $file;
		open(my $file_reporte, ">$ENV{'REPODIR'}/$filename") or die "No se pudo generar el archivo: '$filename' $!" ;
		foreach(@informe){
			print $file_reporte $_."\n";
		}
		close($file_reporte);
		$file += 1;
		print "Exportado con exito\n";
	}
	else
	{
		print "Informe:\n";
		print "IDcentral;IDagente;IDumbral;TipoLlamada;InicioLlamada;TiempoConversacion;AreaA;NumeroA;PaisB;AreaB;NumeroB;FechaArchivo\n";
		foreach(@informe){
			print $_."\n";
		}
		print "Presione una tecla para volver al menu principal...\n";
		my $input_opt = <STDIN>;
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
		print "Presione una tecla para continuar...\n";
        $input_opt = <STDIN>;  
		$input = '';
		}
        case "5"
        {
		f_5_ranking_umbrales();		
		print "Presione una tecla para continuar...\n";
        $input_opt = <STDIN>; 		
		$input = '';
		}
    }
}

}#end menu_s



#subrutinas opcion -s [estadisticas]
sub f_1_central_cantidad_llam_sosp
{
	my $input_llam_seg = $_[0];
	my %centrales;
	print "\n";
	print "llamando..f_1_central_cantidad_llam_sosp\n";
	print "Centrales con mayor cantidad de llamadas sospechosas\n";
	if ($_[0] == "1"){
		print "con filtro por cantidad de llamadas\n";
	}
	if ($_[0] == "2"){
		print "con filtro por cantidad de segundos\n";
	}

	my @archivos = &getArchivosDir("$ENV{'PROCDIR'}");

	my @archivos_a_procesar = &filtrar_aniomes(@archivos);

    foreach (@archivos_a_procesar){
	 	print "procesando...". $_ ."\n";
	 	sleep 1;

		open (ENT,"<$ENV{'PROCDIR'}/".$_) || die "Error: No se pudo abrir ".$_ ."\n";
	    while (my $linea = <ENT>){
			chomp($linea);	
			my @reg=split(";",$linea);
			if ($input_llam_seg == "1"){ #filtro por cantidad de llamadas
				$centrales{$reg[0]}+=1; 
			}
			if ($input_llam_seg == "2"){ # filtro por cantidad de segundos
				$centrales{$reg[0]}+=$reg[5];
			}
		}
        close (ENT);
    }#foreach
    print "\n";

    my $fecha = &getDate;
    my @rank_centrales = sort { $centrales{$b} <=> $centrales{$a} } keys %centrales;
    my %id_centrales = &cargarCodigosDeCentrales();

    print "ID_Central;Cantidad\n";
    # Se graba o se imprime
    if ($file eq 1){
 		open (SAL,">$ENV{'REPODIR'}/estad_".$fecha.".csv");

 		foreach (@rank_centrales){
 			print SAL $id_centrales{$_}.";".$centrales{$_}."\n";
 			print $id_centrales{$_}.";".$centrales{$_} ."\n";
 		}

 		print "se genero estad_".$fecha.".csv\n";
	    close (SAL);
    }else{
    	foreach (@rank_centrales){
			print $id_centrales{$_}.";".$centrales{$_} ."\n";
 		}
    }
	
}

sub f_2_ofi_cantidad_llam_sosp
{
	my $input_llam_seg = $_[0];
	my %oficinas;
	print "\n";
	print "llamando..f_2_ofi_cantidad_llam_sosp\n";
	print "Oficinas con mayor cantidad de llamadas sospechosas\n";
	if ($_[0] == "1"){
		print "con filtro por cantidad de llamadas\n";
	}
	if ($_[0] == "2"){
		print "con filtro por cantidad de segundos\n";
	}

	my @archivos = &getArchivosDir("$ENV{'PROCDIR'}");
	
	my @archivos_a_procesar = &filtrar_aniomes(@archivos);	

    foreach (@archivos_a_procesar){
	 	print "procesando...". $_ ."\n";
		sleep 1;

		my @info_oficina = split("_",$_);	 	

		open (ENT,"<$ENV{'PROCDIR'}/".$_) || die "Error: No se pudo abrir ".$_ ."\n";
	    while (my $linea = <ENT>){
			chomp($linea);	
			my @reg=split(";",$linea);

			if ($input_llam_seg == "1"){ #filtro por cantidad de llamadas
				$oficinas{$info_oficina[0]}+=1; 
				next;
			}
			if ($input_llam_seg == "2"){ # filtro por cantidad de segundos
				$oficinas{$info_oficina[0]}+=$reg[5]; 	
			}
		}
        close (ENT);
    }#foreach
    print "\n";

    my $fecha = &getDate;
    my @rank_oficinas = sort { $oficinas{$b} <=> $oficinas{$a} } keys %oficinas;
    
    print "ID_Oficina;Cantidad\n";
    if ($file eq 1){
 		open (SAL,">$ENV{'REPODIR'}/estad_".$fecha.".csv");

 		foreach (@rank_oficinas){
 			print SAL $_.";".$oficinas{$_}."\n";
 			print $_.";".$oficinas{$_}."\n";
 		}

 		print "se genero estad_".$fecha.".csv\n";
	    close (SAL);
    }else{
    	 foreach (@rank_oficinas){
 			print $_.";".$oficinas{$_} ."\n";
 		}
    }
}

sub f_3_agente_cantidad_llam_sosp
{
	my $input_llam_seg = $_[0];
	my %agentes;
	print "\n";
	print "llamando..f_3_agente_cantidad_llam_sosp\n";
	print "Agentes con mayor cantidad de llamadas sospechosas\n";
	if ($_[0] == "1"){
		print "con filtro por cantidad de llamadas\n";
	}
	if ($_[0] == "2"){
		print "con filtro por cantidad de segundos\n";
	}

	my @archivos = &getArchivosDir("$ENV{'PROCDIR'}");
	my @archivos_a_procesar = &filtrar_aniomes(@archivos);

    foreach (@archivos_a_procesar){
	 	print "procesando...". $_ ."\n";
	 	sleep 1;

		open (ENT,"<$ENV{'PROCDIR'}/".$_) || die "Error: No se pudo abrir $ENV{'PROCDIR'}/".$_ ."\n";
	    while (my $linea = <ENT>){
			chomp($linea);	
			@reg=split(";",$linea);
			if ($input_llam_seg == "1"){ #filtro por cantidad de llamadas
				$agentes{$reg[1]}+=1; 
			}
			if ($input_llam_seg == "2"){ # filtro por cantidad de segundos
				$agentes{$reg[1]}+=$reg[5];
			}
		}
        close (ENT);
    }#foreach
    print "\n";

    my $fecha = &getDate;
    my @rank_agentes = sort { $agentes{$b} <=> $agentes{$a} } keys %agentes;
    my %id_agentes = &cargarCodigosDeAgentes();

    print "ID_Agente;Cantidad;ID_Oficina;e-mail\n";
    if ($file eq 1){
 		open (SAL,">$ENV{'REPODIR'}/estad_".$fecha.".csv");

    	foreach my $k (@rank_agentes){
			print $k.";".$agentes{$k}.";". $id_agentes{$k}[3].";". $id_agentes{$k}[4]."\n";
			print SAL $k.";".$agentes{$k}.";". $id_agentes{$k}[3].";". $id_agentes{$k}[4]."\n";			
 		}
 		print "se genero estad_".$fecha.".csv\n";
	    close (SAL);
    }else{
    	foreach my $k (@rank_agentes){
			print $k.";".$agentes{$k}.";". $id_agentes{$k}[3].";". $id_agentes{$k}[4]."\n";			
 		}
    }		
	
}


sub f_4_destino_llam_sospechosa
{
	my %destinosInter;
	my %destinosNac;
	print "\n";
	print "llamando..f_4_destino_llam_sosp\n";
	print "Destino con mayor cantidad de llamadas sospechosas\n";

	my @archivos = &getArchivosDir("$ENV{'PROCDIR'}");
	
	my @archivos_a_procesar = &filtrar_aniomes(@archivos);

    foreach (@archivos_a_procesar){
	 	print "procesando...". $_ ."\n";
		sleep 1;

		open (ENT,"<$ENV{'PROCDIR'}/".$_) || die "Error: No se pudo abrir ".$_ ."\n";
	    while (my $linea = <ENT>){
			chomp($linea);	
			my @reg=split(";",$linea);
			my $tipo_llam = $reg[3];
			my $cod_pais_dest = $reg[8];
			my $cod_area_dest = $reg[9];
			
			if ($tipo_llam eq "DDI" && $cod_pais_dest ne ""){ 
				$destinosInter{$cod_pais_dest} += 1;
			
			}else{
				if ($cod_area_dest ne ""){
					$destinosNac{$cod_area_dest} += 1;
				}
			}
		}
        close (ENT);
    }#foreach
    print "\n";

    my $fecha = &getDate;
    
    my @rank_dest_inter = sort { $destinosInter{$b} <=> $destinosInter{$a} } keys %destinosInter;
    my @rank_dest_nac = sort { $destinosNac{$b} <=> $destinosNac{$a} } keys %destinosNac;
    
    my %id_dest_paises = &cargarCodigosDePais;
    my %id_dest_regiones = &cargarCodigosDeArea;


    if ($file eq 1){
 		open (SAL,">$ENV{'REPODIR'}/estad_".$fecha.".csv");

 		print SAL "Destinos internacionales con mayor cantidad de llamadas sospechosas:\n";
 		print "Destinos internacionales con mayor cantidad de llamadas sospechosas:\n";
 		print "CodigoPais;NombrePais;Cantidad\n";
 		foreach (@rank_dest_inter){
 			print SAL $_.";".$id_dest_paises{$_}.";".$destinosInter{$_}."\n";
 			print $_.";".$id_dest_paises{$_}.";".$destinosInter{$_}."\n";
 		}
 		print "\n";
 		print SAL "Destinos nacionales con mayor cantidad de llamadas sospechosas:\n";
 		print "Destinos nacionales con mayor cantidad de llamadas sospechosas:\n";
 		print "CodigoArea;NombreArea;Cantidad\n";
 		foreach (@rank_dest_nac){
 			print SAL $_.";".$id_dest_regiones{$_}.";".$destinosNac{$_}."\n";
 			print $_.";".$id_dest_regiones{$_}.";".$destinosNac{$_}."\n";
 		}

 		print "se genero estad_".$fecha.".csv\n";
	    close (SAL);
    }else{

		print "Destinos internacionales con mayor cantidad de llamadas sospechosas:\n";
		print "CodigoPais;NombrePais;Cantidad\n";
		foreach (@rank_dest_inter){
			print $_.";".$id_dest_paises{$_}.";".$destinosInter{$_}."\n";
		}
		print "\n";
		print "Destinos nacionales con mayor cantidad de llamadas sospechosas:\n";
		print "CodigoArea;NombreArea;Cantidad\n";
		foreach (@rank_dest_nac){
			print $_.";".$id_dest_regiones{$_}.";".$destinosNac{$_}."\n";
		}
    }
}


sub f_5_ranking_umbrales
{	
	my %umbrales;
	print "\n";
	print "llamando..f_5_ranking_umbrales\n";
	print "Umbrales con mayor cantidad de llamadas sospechosas\n";

	my @archivos = &getArchivosDir("$ENV{'PROCDIR'}");

	my @archivos_a_procesar = &filtrar_aniomes(@archivos);

    foreach (@archivos_a_procesar){
	 	print "procesando...". $_ ."\n";
	 	sleep 1;

		open (ENT,"<$ENV{'PROCDIR'}/".$_) || die "Error: No se pudo abrir ".$_ ."\n";
	    while (my $linea = <ENT>){
			chomp($linea);	
			my @reg=split(";",$linea);
			$umbrales{$reg[2]} += 1;
		}
        close (ENT);
    }#foreach
    print "\n";

    my $fecha = &getDate;
    my @rank_umbrales = sort { $umbrales{$b} <=> $umbrales{$a} } keys %umbrales;

    print "ID_Umbral;Cantidad\n";
    if ($file eq 1){
 		open (SAL,">$ENV{'REPODIR'}/estad_".$fecha.".csv");

 		foreach (@rank_umbrales){
 			if ($umbrales{$_} > 1){
 				print SAL $_.";".$umbrales{$_}."\n";

 				print $_.";".$umbrales{$_}."\n";
 			}
 			
 		}
 		print "se genero estad_".$fecha.".csv\n";
	    close (SAL);
    }else{
    	foreach (@rank_umbrales){
    		if ($umbrales{$_} > 1){
				print $_.";".$umbrales{$_}."\n";
 			}
 		}
    }

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
	open(ENTRADA,"<$ENV{'MAEDIR'}/CdP.csv") || die "ERROR: No se encontró archivo maestro CdP.\n";

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
	open(ENTRADA,"<$ENV{'MAEDIR'}/CdA.csv") || die "ERROR: No se encontró archivo maestro CdA.\n";

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
	open(ENTRADA,"<$ENV{'MAEDIR'}/centrales.csv") || die "ERROR: No se encontró archivo maestro CdC.\n";

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
	#print "buscando archivo de agentes $ENV{'MAEDIR'}/agentes.csv \n";
	open(ENTRADA,"<$ENV{'MAEDIR'}/agentes.csv") || die "ERROR: No se encontró archivo maestro agentes.\n";

	while (my $linea = <ENTRADA>){
		chomp($linea);
		@info_agentes = split(";",$linea); 
		$hash_agentes{$info_agentes[2]} = [@info_agentes];
	}
	return %hash_agentes;
}

sub getDate(){
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
	return $fecha;
}

sub getArchivosDir(){
	my ($dir) = @_;

	opendir (DIR,"$dir") || die "Error el directorio no existe\n";
	my @files = readdir(DIR);
	closedir(DIR);
	return @files;
}

sub validarFecha(){
	my ($periodo) = @_;
	my ($fecha_ok) = 1;

    if ($periodo !~ /(\d{4})(\d\d)/  ||  $periodo !~ /(\d{4})/) {
	    print "Error al ingresar fecha: $periodo ([YYYY] ó [YYYYMM])\n"; 
	    $fecha_ok = 0;   
    }
    return $fecha_ok;
}

sub archivoCorrespondeAPeriodoIngresado(){
	my ($filename, @periodosIngresados) = @_;
	my $correspondeAPeriodo = 0;
	foreach (@periodosIngresados){
		if ($filename =~ /$_\.csv$/){
			$correspondeAPeriodo = 1;
		} 
	}
	return $correspondeAPeriodo;
}
