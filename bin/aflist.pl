#!/bin/perl

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

	# El usuario puede ingresar uno ó  más períodos
	my @input_periodos = &definir_aniomes;
	my @input_periodos_validos;
	foreach (@input_periodos){
		if (&validarFecha($_) > 0){
			push (@input_periodos_validos, $_);
		}
	}
	my @archivos = &getArchivosDir("./proc/");

    foreach (@archivos){
	 	next if ( not &archivoCorrespondeAPeriodoIngresado($_, @input_periodos_validos));
	 	print "procesando...". $_ ."\n";

		open (ENT,"<./proc/".$_) || die "Error: No se pudo abrir ".$_ ."\n";
	    while (my $linea = <ENT>){
			chomp($linea);	
			@reg=split(";",$linea);
			if ($input_llam_seg == "1"){ #filtro por cantidad de llamadas
				$centrales{$reg[0]}+=1; 
			}
			if ($input_llam_seg == "2"){ # filtro por cantidad de segundos
				$centrales{$reg[0]}+=$reg[4];
			}
		}
        close (ENT);
    }#foreach

    my $fecha = &getDate;
    my @rank_centrales = sort { $centrales{$b} <=> $centrales{$a} } keys %centrales;
    my %id_centrales = cargarCodigosDeCentrales;


    if ($file eq 1){
 		open (SAL,">estad_".$fecha.".csv");

 		foreach (@rank_centrales){
 			print SAL $id_centrales{$_}.";".$centrales{$_}."\n";
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

	# El usuario puede ingresar uno ó  más períodos
	my @input_periodos = &definir_aniomes;
	my @input_periodos_validos;
	foreach (@input_periodos){
		if (&validarFecha($_) > 0){
			push @input_periodos_validos, $_;
		}
	}
	my @archivos = &getArchivosDir("./proc/");

    foreach (@archivos){
	 	next if ( not &archivoCorrespondeAPeriodoIngresado($_, @input_periodos_validos));
	 	print "procesando...". $_ ."\n";

		@info_oficina = split("_",$_);

	 	if ($input_llam_seg == "1"){ #filtro por cantidad de llamadas
			$oficinas{$info_oficina[0]}+=1; 
			next;
		}

		open (ENT,"<./proc/".$_) || die "Error: No se pudo abrir ".$_ ."\n";
	    while (my $linea = <ENT>){
			chomp($linea);	
			@reg=split(";",$linea);
			if ($input_llam_seg == "2"){ # filtro por cantidad de segundos
				$oficinas{$info_oficina[0]}+=$reg[4]; 	
			}
		}
        close (ENT);
    }#foreach

    my $fecha = getDate;
    my @rank_oficinas = sort { $oficinas{$b} <=> $oficinas{$a} } keys %oficinas;
    
    if ($file eq 1){
 		open (SAL,">estad_".$fecha.".csv");

 		foreach (@rank_oficinas){
 			print SAL $_.";".$oficinas{$_}."\n";
 		}

 		print "se genero estad_".$fecha.".csv\n";
	    close (SAL);
    }else{
    	 foreach (@rank_oficinas){
 			print $_.";".$oficinas{$_} ."\n";
 		}
    }
}

sub f_4_destino_llam_sospechosa{
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

	# El usuario puede ingresar uno ó  más períodos
	my @input_periodos = &definir_aniomes;
	my @input_periodos_validos;
	foreach (@input_periodos){
		if (&validarFecha($_) > 0){
			push (@input_periodos_validos, $_);
		}
	}
	my @archivos = &getArchivosDir("./proc/");

    foreach (@archivos){
	 	next if ( not &archivoCorrespondeAPeriodoIngresado($_, @input_periodos_validos));
	 	print "procesando...". $_ ."\n";

		open (ENT,"<./proc/".$_) || die "Error: No se pudo abrir ".$_ ."\n";
	    while (my $linea = <ENT>){
			chomp($linea);	
			@reg=split(";",$linea);
			if ($input_llam_seg == "1"){ #filtro por cantidad de llamadas
				$centrales{$reg[0]}+=1; 
			}
			if ($input_llam_seg == "2"){ # filtro por cantidad de segundos
				$centrales{$reg[0]}+=$reg[4];
			}
		}
        close (ENT);
    }#foreach

    my $fecha = &getDate;
    my @rank_centrales = sort { $centrales{$b} <=> $centrales{$a} } keys %centrales;
    my %id_centrales = cargarCodigosDeCentrales;


    if ($file eq 1){
 		open (SAL,">estad_".$fecha.".csv");

 		foreach (@rank_centrales){
 			print SAL $id_centrales{$_}.";".$centrales{$_}."\n";
 		}

 		print "se genero estad_".$fecha.".csv\n";
	    close (SAL);
    }else{
    	foreach (@rank_centrales){
			print $id_centrales{$_}.";".$centrales{$_} ."\n";
 		}
    }		
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
	pop (@retval);
	return @retval;
}

&f_1_central_cantidad_llam_sosp(2);
&f_2_ofi_cantidad_llam_sosp(2);