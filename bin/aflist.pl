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
		$hash_agentes{$info_agentes[2]} = @info_agentes;
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
				$centrales{$reg[0]}+=$reg[5];
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

		open (ENT,"<./proc/".$_) || die "Error: No se pudo abrir ".$_ ."\n";
	    while (my $linea = <ENT>){
			chomp($linea);	
			@reg=split(";",$linea);

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
    my %id_agentes = cargarCodigosDeAgentes;

    #foreach (@rank_agentes){
    print $rank_agentes[0]."\n";
    print $id_agentes{$rank_agentes[0]}[0]."\n";
    #}

    if ($file eq 1){
 		open (SAL,">estad_".$fecha.".csv");

 		foreach (@rank_agentes){
 			print SAL $id_agentes{$_}[0].";".$agentes{$_}."\n";
 		}

 		print "se genero estad_".$fecha.".csv\n";
	    close (SAL);
    }else{
    	foreach (@rank_agentes){
			print $id_agentes{$_}[0].";".$agentes{$_} ."\n";
 		}
    }		
}

sub f_4_destino_llam_sospechosa{
	my %destinosInter;
	my %destinosNac;
	print "\n";
	print "llamando..f_4_destino_llam_sosp\n";
	print "Destino con mayor cantidad de llamadas sospechosas\n";

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
    
    my %id_dest_paises = cargarCodigosDePais;
    my %id_dest_regiones = cargarCodigosDeArea;


    if ($file eq 1){
 		open (SAL,">estad_".$fecha.".csv");

 		print SAL "Destinos internacionales con mayor cantidad de llamadas sospechosas:\n";
 		foreach (@rank_dest_inter){
 			print SAL $_.";".$id_dest_paises{$_}.";".$destinosInter{$_}."\n";
 		}

 		print SAL "Destinos nacionales con mayor cantidad de llamadas sospechosas:\n";
 		foreach (@rank_dest_nac){
 			print SAL $_.";".$id_dest_regiones{$_}.";".$destinosNac{$_}."\n";
 		}

 		print "se genero estad_".$fecha.".csv\n";
	    close (SAL);
    }else{

		print "Destinos internacionales con mayor cantidad de llamadas sospechosas:\n";
		foreach (@rank_dest_inter){
			print $_.";".$id_dest_paises{$_}.";".$destinosInter{$_}."\n";
		}
		print "\n";
		print "Destinos nacionales con mayor cantidad de llamadas sospechosas:\n";
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
	 	sleep 1;

		open (ENT,"<./proc/".$_) || die "Error: No se pudo abrir ".$_ ."\n";
	    while (my $linea = <ENT>){
			chomp($linea);	
			@reg=split(";",$linea);
			$umbrales{$reg[2]} += 1;
		}
        close (ENT);
    }#foreach
    print "\n";

    my $fecha = &getDate;
    my @rank_umbrales = sort { $umbrales{$b} <=> $umbrales{$a} } keys %umbrales;


    if ($file eq 1){
 		open (SAL,">estad_".$fecha.".csv");

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

&f_1_central_cantidad_llam_sosp(1);
#&f_2_ofi_cantidad_llam_sosp(1);
#&f_3_agente_cantidad_llam_sosp(1);
#&f_4_destino_llam_sospechosa;
#&f_5_ranking_umbrales;