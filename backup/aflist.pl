#!/bin/perl


# campos: (código_país; nombre_país)
sub cargarCodigosDePais(){
	my (%hash_CdP);
	open(ENTRADA,"<master/CdP") || die "ERROR: No se encontró archivo maestro CdP.\n";

	while ($linea = <ENTRADA>){
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
	open(ENTRADA,"<master/CdA") || die "ERROR: No se encontró archivo maestro CdA.\n";

	while ($linea = <ENTRADA>){
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
	open(ENTRADA,"<master/CdC") || die "ERROR: No se encontró archivo maestro CdC.\n";

	while ($linea = <ENTRADA>){
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

	while ($linea = <ENTRADA>){
		chomp($linea);
		@info_agentes = split(";",$linea); 
		$hash_agentes{$info_agentes[0]} = @info_agentes;
	}
	return %hash_agentes;
}

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

sub filtrarOficinaPorCantidadDeLlamadasSospechosas(){
	# 2 hashes para guardar por cantidades(#) y por segundos(tiempo) de llamadas sospechosas.
	my (%hash_oficina_cant, %hash_oficina_seg);
	my ($dir) = "proc";

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
		print $h_info{$key}."  ".$key."  ".$h_data{$key}."\n";
	}
}

sub imprimirFiltroOficina(){
	# El primero hash contiene para cada id un valor acumulado (ej: [id_central, cant_llamadas])
	# El segundo hash contiene para cada id el valor propiamente dicho (ej: [id_central, central])
	my (%h_data) = @_;
	my (@claves) = keys(%h_data);

	foreach my $key (@claves){
		print "Oficina: ".$key."        ".$h_data{$key}."\n";
	}
}

# MAIN
print "Filtro por Central\n";
($h_central1, $h_central2) = &filtrarCentralPorCantidadDeLlamadasSospechosas;
&imprimirFiltroCentral(%{$h_central1});
print "\n";
print "Filtro por Oficina\n";
($h_oficina1, $h_oficina2) = filtrarOficinaPorCantidadDeLlamadasSospechosas;
&imprimirFiltroOficina(%{$h_oficina1});
