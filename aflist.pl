#!/bin/perl


# campos: (código_país; nombre_país)
sub cargarCodigosDePais(){
	my (%hash_CdP);
	open(ENTRADA,"<CdP") || die "ERROR: No se encontró archivo maestro CdP.\n";

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
	open(ENTRADA,"<CdA") || die "ERROR: No se encontró archivo maestro CdA.\n";

	while ($linea = <ENTRADA>){
		chomp($linea);
		@registro = split(";",$linea); 
		$hash_CdP{$registro[1]} = $registro[0];
	}
	close(ENTRADA);
	return %hash_CdA;
}

# campos: (código_central; descripción)
sub cargarCodigosDeCentrales(){
	my (%hash_CdC);
	open(ENTRADA,"<CdC") || die "ERROR: No se encontró archivo maestro CdC.\n";

	while ($linea = <ENTRADA>){
		chomp($linea);
		@registro = split(";",$linea); 
		$hash_CdP{$registro[0]} = $registro[1];
	}
	return %hash_CdC;
}

# campos: (id_agente; nombre_agente; apellido_agente; oficina; email)
sub cargarCodigosDeAgentes(){
	my (%hash_agentes);
	my (@info_agentes);
	open(ENTRADA,"<agentes") || die "ERROR: No se encontró archivo maestro agentes.\n";

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
	my ($dir) = "proc";
	my ($registro);
	my (@a_registro);

	if (opendir(DIRH,"$dir")){
		@archivos=readdir(DIRH);
		closedir(DIRH);
	}

	foreach my $file (@archivos){
		open(ARCH,"<$file") || die "ERROR: No se pudo abrir el archivo $file.\n";

		while ($registro = <ARCH>) {
			chomp($registro);
			my (@a_registro) = split(";",$registro);
			$hash_centrales_cant{$a_registro[0]} += 1;
			$hash_centrales_seg{$a_registro[0]} += $a_registro[4];
		}
		close(ARCH);
	}
	my @arrayHash = (%hash_centrales_cant, %hash_centrales_seg);
	return @arrayHash;
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
		open(ARCH,"<$file") || die "ERROR: No se pudo abrir el archivo $file.\n";

		while (my $registro = <ARCH>) {
			chomp($registro);
			my @a_registro = split(";",$registro);
			$hash_oficina_cant{$a_registro[0]} += 1;
			$hash_oficina_seg{$a_registro[0]} += $a_registro[4];
		}
		close(ARCH);
	}
	my @arrayHash = (%hash_centrales_cant, %hash_centrales_seg);
	return @arrayHash;
}

print "hola\n";
(%hash_por_cant_llam, %hash_por_tiempo) = filtrarOficinaPorCantidadDeLlamadasSospechosas;
@keys1 = keys(%hash_por_cant_llam);
foreach (@keys1){
	print $_."  ".$hash_por_cant_llam{$_}."\n";
}
